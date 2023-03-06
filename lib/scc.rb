# Strongly Connected Components
class SCC
  # initialize graph with n vertices
  def initialize(n)
    @n = n
    @edges = Array.new(n) { [] }
  end

  # add directed edge
  def add_edge(from, to)
    unless 0 <= from && from < @n && 0 <= to && to < @n
      msg = "Wrong params: from=#{from} and to=#{to} must be in 0...#{@n}"
      raise ArgumentError.new(msg)
    end

    @edges[from] << to
    self
  end

  def add_edges(edges)
    edges.each{ |from, to| add_edge(from, to) }
    self
  end

  def add(x, to = nil)
    to ? add_edge(x, to) : add_edges(x)
  end

  # returns list of strongly connected components
  # the components are sorted in topological order
  # O(@n + @edges.sum(&:size))
  def scc
    group_num, ids = scc_ids
    groups = Array.new(group_num) { [] }
    ids.each_with_index { |id, i| groups[id] << i }
    groups
  end

  private

  def scc_ids
    now_ord = 0

    visited = []
    low = Array.new(@n, 1 << 60)
    ord = Array.new(@n, -1)
    group_num = 0

    (0...@n).each do |v|
      next if ord[v] != -1

      stack = [[v, 0]]

      while (v, i = stack.pop)
        if i == 0
          visited << v
          low[v] = ord[v] = now_ord
          now_ord += 1
        end

        while i < @edges[v].size
          u = @edges[v][i]
          i += 1

          if ord[u] == -1
            stack << [v, i] << [u, 0]
            break 1
          end
        end and next

        low[v] = [low[v], @edges[v].map { |e| low[e] }.min || @n].min
        next if low[v] != ord[v]

        while (u = visited.pop)
          low[u] = @n
          ord[u] = group_num
          break if u == v
        end
        group_num += 1

      end
    end

    ord.map! { |e| group_num - e - 1 }
    [group_num, ord]
  end
end
