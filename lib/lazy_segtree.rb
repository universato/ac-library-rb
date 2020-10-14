# Segment tree with Lazy propagation
class LazySegtree
  attr_reader   :d, :lz
  attr_accessor :op, :mapping, :composition

  def initialize(v, e, id, op, mapping, composition)
    v = Array.new(v, e) if v.is_a?(Integer)

    @n  = v.size
    @e  = e
    @id = id
    @op = op
    @mapping = mapping
    @composition = composition

    @log  = (@n - 1).bit_length
    @size = 1 << @log
    @d    = Array.new(2 * @size, e)
    @lz   = Array.new(@size, id)

    @n.times { |i| @d[@size + i] = v[i] }
    (@size - 1).downto(1) { |i| update(i) }
  end

  def set(pos, x)
    pos += @size
    @log.downto(1) { |i| push(pos >> i) }
    @d[pos] = x
    1.upto(@log) { |i| update(pos >> i) }
  end

  def get(pos)
    pos += @size
    @log.downto(1) { |i| push(pos >> i) }
    @d[pos]
  end

  def prod(l, r)
    return @e if l == r

    l += @size
    r += @size

    @log.downto(1) do |i|
      push(l >> i) if (l >> i) << i != l
      push(r >> i) if (r >> i) << i != r
    end

    sml = @e
    smr = @e
    while l < r
      if l.odd?
        sml = @op.call(sml, @d[l])
        l += 1
      end
      if r.odd?
        r -= 1
        smr = @op.call(@d[r], smr)
      end
      l >>= 1
      r >>= 1
    end

    @op.call(sml, smr)
  end

  def all_prod
    @d[1]
  end

  def apply(pos, f)
    pos += @size
    @log.downto(1) { |i| push(pos >> i) }
    @d[pos] = @mapping.call(f, @d[pos])
    1.upto(@log) { |i| update(pos >> i) }
  end

  def range_apply(l, r, f)
    return if l == r

    l += @size
    r += @size

    @log.downto(1) do |i|
      push(l >> i) if (l >> i) << i != l
      push((r - 1) >> i) if (r >> i) << i != r
    end

    l2 = l
    r2 = r
    while l < r
      (all_apply(l, f); l += 1) if l.odd?
      (r -= 1; all_apply(r, f)) if r.odd?
      l >>= 1
      r >>= 1
    end
    l = l2
    r = r2

    1.upto(@log) do |i|
      update(l >> i)       if (l >> i) << i != l
      update((r - 1) >> i) if (r >> i) << i != r
    end
  end

  def max_right(l, &g)
    return @n if l == @n

    l += @size
    @log.downto(1) { |i| push(l >> i) }
    sm = @e

    loop do
      while l.even?
        l >>= 1
      end
      unless g.call(@op.call(sm, @d[l]))
        while l < @size
          push(l)
          l <<= 1
          if g.call(@op.call(sm, @d[l]))
            sm = @op.call(sm, @d[l])
            l += 1
          end
        end
        return l - @size
      end
      sm = @op.call(sm, @d[l])
      l += 1
      break if l & -l == l
    end
    @n
  end

  def update(k)
    @d[k] = @op.call(@d[2 * k], @d[2 * k + 1])
  end

  def all_apply(k, f)
    @d[k]  = @mapping.call(f, @d[k])
    @lz[k] = @composition.call(f, @lz[k]) if k < @size
  end

  def push(k)
    all_apply(2 * k,     @lz[k])
    all_apply(2 * k + 1, @lz[k])
    @lz[k] = @id
  end
end
