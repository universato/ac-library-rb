# frozen_string_literal: true

require_relative '../src/priority_queue.rb'

# Min Cost Flow Grapsh
class MinCostFlow
  Edge = Struct.new(:to, :rev, :cap, :cost)

  def initialize(n)
    @n    = n
    @pos  = []
    @g    = Array.new(n) { [] }
    @pv   = Array.new(n)
    @pe   = Array.new(n)
    @dual = Array.new(n) { 0 }
  end

  def add_edge(from, to, cap, cost)
    edge_number = @pos.size

    @pos << [from, @g[from].size]

    from_id = @g[from].size
    to_id   = @g[to].size
    to_id += 1 if from == to
    @g[from] << Edge.new(to, to_id, cap, cost)
    @g[to]   << Edge.new(from, from_id, 0, -cost)

    edge_number
  end

  def get_edge(i)
    _e = @g[@pos[i][0]][@pos[i][1]]
    _re = @g[_e.to][_e.rev]
    [@pos[i][0], _e.to, _e.cap + _re.cap, _re.cap, _e.cost]
  end
  alias edge get_edge
  alias [] get_edge

  def edges
    @pos.map do |(from, id)|
      _e  = @g[from][id]
      _re = @g[_e.to][_e.rev]
      [from, _e.to, _e.cap + _re.cap, _re.cap, _e.cost]
    end
  end

  def flow(s, t, flow_limit = Float::MAX)
    slope(s, t, flow_limit).last
  end

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

      @g[v].size.times do |i|
        e = @g[v][i]
        next if vis[e.to] || e.cap == 0

        cost = e.cost - @dual[e.to] + @dual[v]
        next unless dist[e.to] - dist[v] > cost

        dist[e.to] = dist[v] + cost
        @pv[e.to] = v
        @pe[e.to] = i
        que.push([dist[e.to], e.to])
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
    prev_cost = -1
    result = [[flow, cost]]

    while flow < flow_limit
      break unless dual_ref(s, t)

      c = flow_limit - flow
      v = t
      while v != s
        c = @g[@pv[v]][@pe[v]].cap if c > @g[@pv[v]][@pe[v]].cap
        v = @pv[v]
      end

      v = t
      while v != s
        e = @g[@pv[v]][@pe[v]]
        e.cap -= c
        @g[v][e.rev].cap += c
        v = @pv[v]
      end

      d = -@dual[s]
      flow += c
      cost += c * d
      result.pop if prev_cost == d
      result << [flow, cost]
      prev_cost = d
    end

    result
  end
end

MCF      = MinCostFlow
MCFGraph = MinCostFlow
