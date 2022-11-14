module AcLibraryRb
  # Segment tree with Lazy propagation
  class LazySegtree
    attr_reader :d, :lz, :e, :id
    attr_accessor :op, :mapping, :composition

    # new(v, op, e, mapping, composition, id)
    # new(v, e, id, op, mapping, composition)
    # new(v, e, id){ |x, y|  }
    def initialize(v, a1, a2, a3 = nil, a4 = nil, a5 = nil, &op_block)
      if a1.is_a?(Proc)
        @op, @e, @mapping, @composition, @id = a1, a2, a3, a4, a5
      else
        @e, @id, @op, @mapping, @composition = a1, a2, a3, a4, a5
        @op ||= op_block
      end
      v = Array.new(v, @e) if v.is_a?(Integer)

      @n  = v.size

      @log  = (@n - 1).bit_length
      @size = 1 << @log
      @d    = Array.new(2 * @size, e)
      @lz   = Array.new(@size, id)

      @n.times { |i| @d[@size + i] = v[i] }
      (@size - 1).downto(1) { |i| update(i) }
    end

    def set_mapping(&mapping)
      @mapping = mapping
    end

    def set_composition(&composition)
      @composition = composition
    end

    def set(pos, x)
      pos += @size
      @log.downto(1) { |i| push(pos >> i) }
      @d[pos] = x
      1.upto(@log) { |i| update(pos >> i) }
    end
    alias []= set

    def get(pos)
      pos += @size
      @log.downto(1) { |i| push(pos >> i) }
      @d[pos]
    end
    alias [] get

    def prod(l, r = nil)
      if r.nil? # if 1st argument l is Range
        if r = l.end
          r += @n if r < 0
          r += 1 unless l.exclude_end?
        else
          r = @n
        end
        l = l.begin
        l += @n if l < 0
      end

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

    # apply(pos, f)
    # apply(l, r, f)  -> range_apply(l, r, f)
    # apply(l...r, f) -> range_apply(l, r, f)  ... [Experimental]
    def apply(pos, f, fr = nil)
      if fr
        return range_apply(pos, f, fr)
      elsif pos.is_a?(Range)
        l = pos.begin
        l += @n if l < 0
        if r = pos.end
          r += @n if r < 0
          r += 1 unless pos.exclude_end?
        else
          r = @n
        end
        return range_apply(l, r, f)
      end

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
        l >>= 1 while l.even?
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

    def min_left(r, &g)
      return 0 if r == 0

      r += @size
      @log.downto(1) { |i| push((r - 1) >> i) }
      sm = @e

      loop do
        r -= 1
        r /= 2 while r > 1 && r.odd?
        unless g.call(@op.call(@d[r], sm))
          while r < @size
            push(r)
            r = r * 2 + 1
            if g.call(@op.call(@d[r], sm))
              sm = @op.call(@d[r], sm)
              r -= 1
            end
          end
          return r + 1 - @size
        end
        sm = @op.call(@d[r], sm)
        break if (r & -r) == r
      end
      0
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

  LazySegTree = LazySegtree
end
