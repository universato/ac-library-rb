# MaxFlowGraph
class MaxFlow
  def initialize(n)
    @n   = n
    @pos = []
    @g   = Array.new(n) { [] }
  end

  def add_edge(from, to, cap)
    edge_number = @pos.size

    @pos << [from, @g[from].size]

    from_id = @g[from].size
    to_id   = @g[to].size
    to_id += 1 if from == to
    @g[from] << [to,   to_id,   cap]
    @g[to]   << [from, from_id, 0]

    edge_number
  end

  def add_edges(edges)
    edges.each{ |from, to, cap| add_edge(from, to, cap) }
    self
  end

  def add(x, to = nil, cap = nil)
    cap ? add_edge(x, to, cap) : add_edges(x)
  end

  def push(edge)
    add_edge(*edge)
  end
  alias << push

  # return edge = [from, to, cap, flow]
  def [](i)
    from, from_id = @pos[i]

    to, to_id, cap = @g[from][from_id]    # edge
    _from, _from_id, flow = @g[to][to_id] # reverse edge

    [from, to, cap + flow, flow]
  end
  alias get_edge []
  alias edge []

  def edges
    @pos.map do |(from, from_id)|
      to, to_id, cap = @g[from][from_id]
      _from, _from_id, flow = @g[to][to_id]
      [from, to, cap + flow, flow]
    end
  end

  def change_edge(i, new_cap, new_flow)
    from, from_id = @pos[i]

    e = @g[from][from_id]
    re = @g[e[0]][e[1]]
    e[2]  = new_cap - new_flow
    re[2] = new_flow
  end

  def flow(s, t, flow_limit = 1 << 64)
    flow = 0
    while flow < flow_limit
      level = bfs(s, t)
      break if level[t] == -1

      iter = [0] * @n
      while flow < flow_limit
        f = dfs(t, flow_limit - flow, s, level, iter)
        break if f == 0

        flow += f
      end
    end

    flow
  end
  alias max_flow flow

  def min_cut(s)
    visited = Array.new(@n, false)
    que = [s]
    while (q = que.shift)
      visited[q] = true
      @g[q].each do |(to, _rev, cap)|
        if cap > 0 && !visited[to]
          visited[to] = true
          que << to
        end
      end
    end
    visited
  end

  private

  def bfs(s, t)
    level = Array.new(@n, -1)
    level[s] = 0
    que = [s]

    while (v = que.shift)
      @g[v].each do |u, _, cap|
        next if cap == 0 || level[u] >= 0

        level[u] = level[v] + 1
        return level if u == t

        que << u
      end
    end
    level
  end

  def dfs(v, up, s, level, iter)
    return up if v == s

    res = 0
    level_v = level[v]

    while iter[v] < @g[v].size
      i = iter[v]
      e = @g[v][i]
      cap = @g[e[0]][e[1]][2]
      if level_v > level[e[0]] && cap > 0
        d = dfs(e[0], (up - res < cap ? up - res : cap), s, level, iter)
        if d > 0
          @g[v][i][2] += d
          @g[e[0]][e[1]][2] -= d
          res += d
          break if res == up
        end
      end
      iter[v] += 1
    end

    res
  end
end
