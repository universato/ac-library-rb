# frozen_string_literal: true

require 'minitest'
require 'minitest/autorun'

require_relative '../lib/segtree.rb'

class SegtreeNaive
  def initialize(arg, e, &op)
    case arg
    when Integer
      @d = Array.new(arg) { e }
    end

    @n = @d.size
    @e = e
    @op = proc(&op)
  end

  def set(pos, x)
    @d[pos] = x
  end

  def get(pos)
    @d[pos]
  end

  def prod(l, r)
    res = @e
    (l ... r).each do |i|
      res = @op.call(res, @d[i])
    end
    res
  end

  def all_prod
    prod(0, @n)
  end

  def max_right(l, &f)
    sum = @e
    (l ... @n).each do |i|
      sum = @op.call(sum, @d[i])
      return i unless f.call(sum)
    end
    @n
  end

  def min_left(r, &f)
    sum = @e
    (r - 1).downto(0) do |i|
      sum = @op.call(@d[i], sum)
      return i + 1 unless f.call(sum)
    end
    0
  end
end

class SegtreeTest < Minitest::Test
  INF = (1 << 60) - 1

  def test_zero
    e = '$'
    op = ->{} # This is unused if Segtree size is 0.

    s = Segtree.new(0, e, &op)
    assert_equal e, s.all_prod

    assert_raises(ArgumentError){ Segtree.new(e, &op) }
  end

  def test_one
    e = '$'
    op = proc do |a, b|
      if a == e
        b
      elsif b == e
        a
      else
        # a + b  # This is unused if Segtree size is 1.
      end
    end
    s = Segtree.new(1, e, &op)
    assert_equal '$', s.all_prod
    assert_equal '$', s.get(0)
    assert_equal '$', s[0]
    assert_equal '$', s.prod(0, 1)
    s.set(0, "dummy")
    assert_equal "dummy", s.get(0)
    assert_equal e, s.prod(0, 0)
    assert_equal "dummy", s.prod(0, 1)
    assert_equal e, s.prod(1, 1)
  end

  def test_compare_naive
    op = proc do |a, b|
      if a == '$'
        b
      elsif b == '$'
        a
      else
        a + b
      end
    end

    (0..20).each do |n|
      seg0 = SegtreeNaive.new(n, '$', &op)
      seg1 = Segtree.new(n, '$', &op)

      assert_equal seg0.all_prod, seg1.all_prod

      n.times do |i|
        s = ""
        s += ("a".ord + i).chr
        seg0.set(i, s)
        seg1.set(i, s)
      end

      (0...n).each do |i|
        assert_equal seg0.get(i), seg1.get(i)
      end
      0.upto(n) do |l|
        l.upto(n) do |r|
          assert_equal seg0.prod(l, r), seg1.prod(l, r), "prod test failed"
        end
      end
      assert_equal seg0.all_prod, seg1.all_prod

      y = ''
      leq_y = proc{ |x| x.size <= y.size }

      0.upto(n) do |l|
        l.upto(n) do |r|
          y = seg1.prod(l, r)
          assert_equal seg0.max_right(l, &leq_y), seg1.max_right(l, &leq_y), "max_right test failed"
        end
      end

      0.upto(n) do |r|
        0.upto(r) do |l|
          y = seg1.prod(l, r)
          assert_equal seg0.min_left(r, &leq_y), seg1.min_left(r, &leq_y), "min_left test failed"
        end
      end
    end
  end

  # https://atcoder.jp/contests/practice2/tasks/practice2_j
  def test_alpc_max_right
    a = [1, 2, 3, 2, 1]
    st = Segtree.new(a, -INF) { |x, y| [x, y].max }
    assert_equal 3, st.prod(1 - 1, 5) # [0, 5)
    assert_equal 3, st.max_right(2 - 1) { |v| v < 3 } + 1
    st.set(3 - 1, 1)
    assert_equal 2, st.get(1)
    assert_equal 2, st.all_prod
    assert_equal 2, st.prod(2 - 1, 4) # [1, 4)
    assert_equal 6, st.max_right(1 - 1) { |v| v < 3 } + 1
  end

  # https://atcoder.jp/contests/practice2/tasks/practice2_j
  def test_alpc_min_left
    n = 5
    a = [1, 2, 3, 2, 1].reverse
    st = Segtree.new(a, -INF) { |x, y| [x, y].max }
    assert_equal 3, st.prod(n - 5, n - 1 + 1) # [0, 5)
    assert_equal 3, n - st.min_left(n - 2 + 1) { |v| v < 3 } + 1
    st.set(n - 3, 1)
    assert_equal 2, st.get(n - 1 - 1)
    assert_equal 2, st.all_prod
    assert_equal 2, st.prod(n - 4, n - 2 + 1) # [1, 4)
    assert_equal 6, n - st.min_left(n - 1 + 1) { |v| v < 3 } + 1
  end

  def test_sum
    a = (1..10).to_a
    seg = Segtree.new(a, 0){ |x, y| x + y }

    assert_equal 1, seg.get(0)
    assert_equal 10, seg.get(9)

    assert_equal 55, seg.all_prod
    assert_equal 55, seg.prod(0, 10)
    assert_equal 54, seg.prod(1, 10)
    assert_equal 45, seg.prod(0, 9)
    assert_equal 10, seg.prod(0, 4)
    assert_equal 15, seg.prod(3, 6)

    assert_equal 0, seg.prod(0, 0)
    assert_equal 0, seg.prod(1, 1)
    assert_equal 0, seg.prod(2, 2)
    assert_equal 0, seg.prod(4, 4)

    seg.set(4, 15)
    assert_equal 65, seg.all_prod
    assert_equal 65, seg.prod(0, 10)
    assert_equal 64, seg.prod(1, 10)
    assert_equal 55, seg.prod(0, 9)
    assert_equal 10, seg.prod(0, 4)
    assert_equal 25, seg.prod(3, 6)

    assert_equal 0, seg.prod(0, 0)
    assert_equal 0, seg.prod(1, 1)
    assert_equal 0, seg.prod(2, 2)
    assert_equal 0, seg.prod(4, 4)
  end

  # [Experimental]
  def test_experimental_range_prod
    a = (1..10).to_a
    seg = Segtree.new(a, 0){ |x, y| x + y }

    assert_equal 55, seg.prod(0...10)
    assert_equal 54, seg.prod(1...10)
    assert_equal 45, seg.prod(0...9)
    assert_equal 10, seg.prod(0...4)
    assert_equal 15, seg.prod(3...6)

    assert_equal 55, seg.prod(0..9)
    assert_equal 54, seg.prod(1..9)
    assert_equal 54, seg.prod(1..)
    assert_equal 54, seg.prod(1...)
    assert_equal 54, seg.prod(1..-1)
    assert_equal 45, seg.prod(0..8)
    assert_equal 45, seg.prod(-10..-2)
    assert_equal 10, seg.prod(0..3)
    assert_equal 15, seg.prod(3..5)
  end

  def test_max_right
    a = [*0..6]
    st = Segtree.new(a, 0){ |x, y| x + y }

    # [0, 1, 2, 3,  4,  5,  6] i
    # [0, 1, 3, 6, 10, 15, 21] prod(0, i)
    # [t, t, t, f,  f,  f,  f] prod(0, i) < 5
    assert_equal 3, st.max_right(0){ |x| x < 5 }

    # [4, 5,  6] i
    # [4, 9, 15] prod(4, i)
    # [t, f,  f] prod(4, i) >= 4
    assert_equal 5, st.max_right(4){ |x| x <= 4 }

    # [3, 4,  5,  6] i
    # [3, 7, 12, 18] prod(3, i)
    # [f, f,  f,  f] prod(3) <= 2
    assert_equal 3, st.max_right(3){ |x| x <= 2 }
  end

  def test_min_left
    a = [1, 2, 3, 2, 1]
    st = Segtree.new(a, -10**18){ |x, y| [x, y].max }

    # [0, 1, 2, 3, 4] i
    # [3, 3, 3, 2, 1] prod(i, 5)
    # [f, f, f, f, f] prod(i, 5) < 1
    assert_equal 5, st.min_left(5){ |v| v < 1 }

    # [0, 1, 2, 3, 4] i
    # [3, 3, 3, 2, 1] prod(i, 5)
    # [f, f, f, f, t] prod(i, 5) < 2
    assert_equal 4, st.min_left(5){ |v| v < 2 }

    # [0, 1, 2, 3, 4] i
    # [3, 3, 3, 2, 1] prod(i, 5)
    assert_equal 5, st.min_left(5){ |v| v < 1 }
    assert_equal 4, st.min_left(5){ |v| v < 2 }
    assert_equal 3, st.min_left(5){ |v| v < 3 }
    assert_equal 0, st.min_left(5){ |v| v < 4 }
    assert_equal 0, st.min_left(5){ |v| v < 5 }

    # [0, 1, 2, 3] i
    # [3, 3, 3, 2] prod(i, 4)
    assert_equal 4, st.min_left(4){ |v| v < 1 }
    assert_equal 4, st.min_left(4){ |v| v < 2 }
    assert_equal 3, st.min_left(4){ |v| v < 3 }
    assert_equal 0, st.min_left(4){ |v| v < 4 }
    assert_equal 0, st.min_left(4){ |v| v < 5 }
  end

  # AtCoder ABC185 F - Range Xor Query
  # https://atcoder.jp/contests/abc185/tasks/abc185_f
  def test_xor_abc185f
    a = [1, 2, 3]
    st = Segtree.new(a, 0){ |x, y| x ^ y }
    assert_equal 0, st.prod(1 - 1, 3 - 1 + 1)
    assert_equal 1, st.prod(2 - 1, 3 - 1 + 1)

    st.set(2 - 1, st.get(2 - 1) ^ 3)
    assert_equal 2, st.prod(2 - 1, 3 - 1 + 1)
  end

  # AtCoder ABC185 F - Range Xor Query
  # https://atcoder.jp/contests/abc185/tasks/abc185_f
  def test_acl_original_argument_order_of_new
    a = [1, 2, 3]
    op = ->(x, y){ x ^ y }
    e = 0
    st = Segtree.new(a, op, e)

    assert_equal 0, st.prod(1 - 1, 3 - 1 + 1)
    assert_equal 1, st.prod(2 - 1, 3 - 1 + 1)

    st.set(2 - 1, st.get(2 - 1) ^ 3)
    assert_equal 2, st.prod(2 - 1, 3 - 1 + 1)
  end
end
