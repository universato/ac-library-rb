# frozen_string_literal: true

# MaxFlowGraph
class MaxFlow
  def initialize(n = 0)
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

  def push(edge)
    add_edge(*edge)
  end
  alias << push

  # return edge = [from, to, cap, flow]
  def [](i)
    _e  = @g[@pos[i][0]][@pos[i][1]]
    _re = @g[_e[0]][_e[1]]
    [@pos[i][0], _e[0], _e[-1] + _re[-1], _re[-1]]
  end
  alias get_edge []
  alias edge []

  def edges
    @pos.map do |(to, rev, _cap)|
      _e  = @g[to][rev]
      _re = @g[_e[0]][_e[1]]
      [to, _e[0], _e[-1] + _re[-1], _re[-1]]
    end
  end

  def flow(s, t, flow_limit = 1 << 64)
    level = Array.new(@n)
    iter  = Array.new(@n)
    que   = []

    flow = 0
    while flow < flow_limit
      bfs(level, que, s, t)
      break if level[t] == -1

      iter.fill(0)
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
    visited = Array.new(@n) { false }
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

  def bfs(level, que, s, t)
    level.fill(-1)
    level[s] = 0
    que.clear
    que << s

    while (v = que.shift)
      @g[v].each do |e|
        next if e[2] == 0 || level[e[0]] >= 0

        level[e[0]] = level[v] + 1
        return nil if e[0] == t

        que << e[0]
      end
    end
  end

  def dfs(v, up, s, level, iter)
    return up if v == s

    res = 0
    level_v = level[v]

    iter[v].upto(@g[v].size - 1) do |i|
      e = @g[v][i]
      next if level_v <= level[e[0]] || @g[e[0]][e[1]][2] == 0

      d = dfs(e[0], [up - res, @g[e[0]][e[1]][2]].min, s, level, iter)
      next if d <= 0

      @g[v][i][2] += d
      @g[e[0]][e[1]][2] -= d
      res += d
      break if res == up
    end

    res
  end
end

MaxFlowGraph = MaxFlow
MFGraph      = MaxFlow
