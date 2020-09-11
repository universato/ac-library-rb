# frozen_string_literal: true

# Fenwick Tree
class FenwickTree
  def initialize(arg)
    case arg
    when Array
      @size = arg.size
      @data = Array.new(@size + 1) { 0 }
      arg.each.with_index(1) { |e, i| add(i, e) }
    when Integer
      @size = arg
      @data = Array.new(@size + 1) { 0 }
    else
      raise ArgumentError
    end
  end

  def add(i, x)
    while i <= @size
      @data[i] += x
      i += (i & -i)
    end
  end

  def sum(l, r)
    _sum(r) - _sum(l)
  end

  def _sum(i)
    res = 0
    while i > 0
      res += @data[i]
      i -= (i & -i)
    end
    res
  end
end

FeTree            = FenwickTree
BinaryIndexedTree = FenwickTree
