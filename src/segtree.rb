# frozen_string_literal: true

# Segment Tree
class Segtree
  def initialize(arg, e, &block)
    case arg
    when Integer
      v = Array.new(arg) { e }
    when Array
      v = arg
    end

    @e  = e
    @op = proc(&block)

    @n = v.size
    @log = (@n - 1).bit_length
    @leaf_size = 1 << @log
    @d = Array.new(@leaf_size * 2) { e }
    v.each_with_index { |v_i, i| @d[@leaf_size + i] = v_i }
    (@leaf_size - 1).downto(1) { |i| update(i) }
  end

  def set(q, x)
    q += @leaf_size
    @d[q] = x
    1.upto(@log) { |i| update(q >> i) }
  end

  def get(pos)
    @d[@leaf_size + pos]
  end

  def prod(l, r)
    sml = @e
    smr = @e
    l += @leaf_size
    r += @leaf_size

    while l < r
      if l[0] == 1
        sml = @op.call(sml, @d[l])
        l += 1
      end
      if r[0] == 1
        r -= 1
        smr = @op.call(@d[r], smr)
      end
      l /= 2
      r /= 2
    end

    @op.call(sml, smr)
  end

  def all_prod
    d[1]
  end

  def max_right(l, &block)
    return @n if l == @n

    f = proc(&block)

    l += @leaf_size
    sm = @e
    loop do
      l /= 2 while l.even?
      unless f.call(@op.call(sm, @d[l]))
        while l < @leaf_size
          l *= 2
          if f.call(@op.call(sm, @d[l]))
            sm = @op.call(sm, @d[l])
            l += 1
          end
        end
        return l - @leaf_size
      end
      sm = @op.call(sm, @d[l])
      l += 1
      break if (l & -l) == l
    end

    @n
  end

  def update(k)
    @d[k] = @op.call(@d[2 * k], @d[2 * k + 1])
  end

  def inspect
    t = 0
    res = "SegmentTree\n  "
    a = @d[1, @d.size - 1]
    a.each_with_index do |e, i|
      res << e.to_s << ' '
      if t == i && i < @leaf_size
        res << "\n  "
        t = t * 2 + 2
      end
    end
    res
  end
end

SegTree     = Segtree
SegmentTree = Segtree
