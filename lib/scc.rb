# Strongly Connected Components
class SCCGraph
  # initialize graph with n vertices
  def initialize(n = 0)
    @n, @edges = n, []
  end

  # add directed edge
  def add_edge(from, to)
    raise "invalid params" unless (0...@n).include? from and (0...@n).include? to

    @edges << [from, to]
  end

  # returns list of strongly connected components
  # the components are sorted in topological order
  # O(@n + @edges.size)
  def scc
    group_num, ids = scc_ids
    counts = [0] * group_num
    ids.each { |x| counts[x] += 1 }
    groups = Array.new(group_num) { [] }
    ids.each_with_index { |x, i| groups[x] << i }
    groups
  end

  private

  def scc_ids
    start, elist = csr
    now_ord = group_num = 0
    visited, low, ord, ids = [], [], [-1] * @n, []
    dfs = ->(v) {
      low[v] = ord[v] = now_ord
      now_ord += 1
      visited << v
      (start[v]...start[v + 1]).each do |i|
        to = elist[i]
        low[v] = if ord[to] == -1
                   dfs.(to)
                   [low[v], low[to]].min
                 else
                   [low[v], ord[to]].min
                 end
      end
      if low[v] == ord[v]
        loop do
          u = visited.pop
          ord[u] = @n
          ids[u] = group_num
          break if u == v
        end
        group_num += 1
      end
    }
    @n.times { |i| dfs.(i) if ord[i] == -1 }
    ids = ids.map { |x| group_num - 1 - x }
    [group_num, ids]
  end

  def csr
    start, elist = [0] * (@n + 1), [nil] * @edges.size
    @edges.each { |(i, _)| start[i + 1] += 1 }
    @n.times { |i| start[i + 1] += start[i] }
    counter = start.dup
    @edges.each do |(i, j)|
      elist[counter[i]] = j
      counter[i] += 1
    end
    [start, elist]
  end
end

# class alias
StronglyConnectedComponents = SCCGraph
SCC  = SCCGraph
SCCG = SCCGraph
