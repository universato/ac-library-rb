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
  # O(@n + @edges.sum {_1.size})
  def scc
    now_ord = 0

    visited = []
    low = Array.new(@n, 1 << 60)
    ord = Array.new(@n, -1)
    groups = []

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

        low[v] = [low[v], @edges[v].map { low[_1] }.min || @n].min
        next unless low[v] == ord[v]

        groups << []
        while (u = visited.pop)
          low[u] = @n
          groups[-1] << u
          break if u == v
        end

        groups[-1].reverse!
      end
    end

    groups.reverse
  end
end
