# Fenwick Tree
class FenwickTree
  attr_reader :data, :size

  def initialize(arg = 0)
    case arg
    when Array
      @size = arg.size
      @data = [0].concat(arg)
      (1 ... @size).each do |i|
        up = i + (i & -i)
        next if up > @size

        @data[up] += @data[i]
      end
    when Integer
      @size = arg
      @data = Array.new(@size + 1, 0)
    else
      raise ArgumentError
    end
  end

  def add(i, x)
    i += 1
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
      i &= i - 1
    end
    res
  end
end

FeTree            = FenwickTree
Fetree            = FenwickTree
BinaryIndexedTree = FenwickTree
