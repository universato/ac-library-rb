module AcLibraryRb
  # Segment Tree
  class Segtree
    attr_reader :d, :op, :n, :leaf_size, :log

    # new(v, e){ |x, y|  }
    # new(v, op, e)
    def initialize(a0, a1, a2 = nil, &block)
      if a2.nil?
        @e, @op = a1, proc(&block)
        v = (a0.is_a?(Array) ? a0 : [@e] * a0)
      else
        @op, @e = a1, a2
        v = (a0.is_a?(Array) ? a0 : [@e] * a0)
      end

      @n = v.size
      @log = (@n - 1).bit_length
      @leaf_size = 1 << @log
      @d = Array.new(@leaf_size * 2, @e)
      v.each_with_index { |v_i, i| @d[@leaf_size + i] = v_i }
      (@leaf_size - 1).downto(1) { |i| update(i) }
    end

    def set(q, x)
      q += @leaf_size
      @d[q] = x
      1.upto(@log) { |i| update(q >> i) }
    end
    alias []= set

    def get(pos)
      @d[@leaf_size + pos]
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
      @d[1]
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

    def min_left(r, &block)
      return 0 if r == 0

      f = proc(&block)

      r += @leaf_size
      sm = @e
      loop do
        r -= 1
        r /= 2 while r > 1 && r.odd?
        unless f.call(@op.call(@d[r], sm))
          while r < @leaf_size
            r = r * 2 + 1
            if f.call(@op.call(@d[r], sm))
              sm = @op.call(@d[r], sm)
              r -= 1
            end
          end

          return r + 1 - @leaf_size
        end

        sm = @op.call(@d[r], sm)
        break if (r & -r) == r
      end

      0
    end

    def update(k)
      @d[k] = @op.call(@d[2 * k], @d[2 * k + 1])
    end

    # def inspect # for debug
    #   t = 0
    #   res = "Segtree @e = #{@e}, @n = #{@n}, @leaf_size = #{@leaf_size} @op = #{@op}\n  "
    #   a = @d[1, @d.size - 1]
    #   a.each_with_index do |e, i|
    #     res << e.to_s << ' '
    #     if t == i && i < @leaf_size
    #       res << "\n  "
    #       t = t * 2 + 2
    #     end
    #   end
    #   res
    # end
  end

  SegTree = Segtree
end
