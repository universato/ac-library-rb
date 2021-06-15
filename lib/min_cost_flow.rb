require_relative './priority_queue.rb'

# Min Cost Flow Grapsh
class MinCostFlow
  def initialize(n)
    @n      = n
    @pos    = []
    @g_to   = Array.new(n) { [] }
    @g_rev  = Array.new(n) { [] }
    @g_cap  = Array.new(n) { [] }
    @g_cost = Array.new(n) { [] }
    @pv     = Array.new(n)
    @pe     = Array.new(n)
    @dual   = Array.new(n, 0)
  end

  def add_edge(from, to, cap, cost)
    edge_number = @pos.size

    @pos << [from, @g_to[from].size]

    from_id = @g_to[from].size
    to_id   = @g_to[to].size
    to_id += 1 if from == to

    @g_to[from]   << to
    @g_rev[from]  << to_id
    @g_cap[from]  << cap
    @g_cost[from] << cost

    @g_to[to]     << from
    @g_rev[to]    << from_id
    @g_cap[to]    << 0
    @g_cost[to]   << -cost

    edge_number
  end

  def add_edges(edges)
    edges.each{ |from, to, cap, cost| add_edge(from, to, cap, cost) }
    self
  end

  def add(x, to = nil, cap = nil, cost = nil)
    cost ? add_edge(x, to, cap, cost) : add_edges(x)
  end

  def get_edge(i)
    from, id = @pos[i]
    to = @g_to[from][id]
    rid = @g_rev[from][id]
    [from, to, @g_cap[from][id] + @g_cap[to][rid], @g_cap[to][rid], @g_cost[from][id]]
  end
  alias edge get_edge
  alias [] get_edge

  def edges
    @pos.map do |(from, id)|
      to = @g_to[from][id]
      rid = @g_rev[from][id]
      [from, to, @g_cap[from][id] + @g_cap[to][rid], @g_cap[to][rid], @g_cost[from][id]]
    end
  end

  def flow(s, t, flow_limit = Float::MAX)
    slope(s, t, flow_limit).last
  end
  alias min_cost_max_flow flow

  def dual_ref(s, t)
    dist = Array.new(@n, Float::MAX)
    @pv.fill(-1)
    @pe.fill(-1)
    vis = Array.new(@n, false)

    que = PriorityQueue.new { |par, chi| par[0] < chi[0] }
    dist[s] = 0
    que.push([0, s])

    while (v = que.pop)
      v = v[1]

      next if vis[v]

      vis[v] = true
      break if v == t

      @g_to[v].size.times do |i|
        to = @g_to[v][i]
        next if vis[to] || @g_cap[v][i] == 0

        cost = @g_cost[v][i] - @dual[to] + @dual[v]
        next unless dist[to] - dist[v] > cost

        dist[to] = dist[v] + cost
        @pv[to] = v
        @pe[to] = i
        que.push([dist[to], to])
      end
    end

    return false unless vis[t]

    @n.times do |i|
      next unless vis[i]

      @dual[i] -= dist[t] - dist[i]
    end

    true
  end

  def slope(s, t, flow_limit = Float::MAX)
    flow = 0
    cost = 0
    prev_cost_per_flow = -1
    result = [[flow, cost]]

    while flow < flow_limit
      break unless dual_ref(s, t)

      c = flow_limit - flow
      v = t
      while v != s
        c = @g_cap[@pv[v]][@pe[v]] if c > @g_cap[@pv[v]][@pe[v]]
        v = @pv[v]
      end

      v = t
      while v != s
        nv = @pv[v]
        id = @pe[v]
        @g_cap[nv][id] -= c
        @g_cap[v][@g_rev[nv][id]] += c
        v = nv
      end

      d = -@dual[s]
      flow += c
      cost += c * d
      result.pop if prev_cost_per_flow == d
      result << [flow, cost]
      prev_cost_per_flow = d
    end

    result
  end
  alias min_cost_slop slope
end
