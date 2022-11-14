require_relative './scc.rb'

# TwoSAT
# Reference: https://github.com/atcoder/ac-library/blob/master/atcoder/twosat.hpp
class TwoSAT
  def initialize(n)
    @n = n
    @answer = Array.new(n)
    @scc = SCC.new(2 * n)
  end

  attr_reader :answer

  def add_clause(i, f, j, g)
    unless 0 <= i && i < @n && 0 <= j && j < @n
      raise ArgumentError.new("i:#{i} and j:#{j} must be in (0...#{@n})")
    end

    @scc.add_edge(2 * i + (f ? 0 : 1), 2 * j + (g ? 1 : 0))
    @scc.add_edge(2 * j + (g ? 0 : 1), 2 * i + (f ? 1 : 0))
    nil
  end

  def satisfiable?
    id = @scc.send(:scc_ids)[1]
    @n.times do |i|
      return false if id[2 * i] == id[2 * i + 1]

      @answer[i] = id[2 * i] < id[2 * i + 1]
    end
    true
  end
  alias satisfiable satisfiable?
end

TwoSat = TwoSAT
