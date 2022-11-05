# Fenwick Tree
class FenwickTree
  attr_reader :data, :size

  def initialize(arg)
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
      raise ArgumentError.new("wrong argument. type is Array or Integer")
    end
  end

  def add(i, x)
    i += 1
    while i <= @size
      @data[i] += x
      i += (i & -i)
    end
  end

  # .sum(l, r)  # [l, r)  <- Original
  # .sum(r)     # [0, r)  <- [Experimental]
  # .sum(l..r)  # [l, r]  <- [Experimental]
  def sum(a, b = nil)
    if b
      _sum(b) - _sum(a)
    elsif a.is_a?(Range)
      l = a.begin
      l += @size if l < 0
      if r = a.end
        r += @size if r < 0
        r += 1 unless a.exclude_end?
      else
        r = @size
      end
      _sum(r) - _sum(l)
    else
      _sum(a)
    end
  end

  def _sum(i)
    res = 0
    while i > 0
      res += @data[i]
      i &= i - 1
    end
    res
  end
  alias left_sum _sum

  def to_s
    "<#{self.class}: @size=#{@size}, (#{@data[1..].join(', ')})>"
  end
end
