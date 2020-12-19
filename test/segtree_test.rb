# frozen_string_literal: true

require 'minitest'
require 'minitest/autorun'

require_relative '../lib/segtree.rb'

class SegtreeNaive
  def initialize(arg, e, &op)
    case arg
    when Integer
      @d = Array.new(arg) { e }
    when Array
      @d = arg
    else
      raise ArgumentError
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
    prod(0, n)
  end

  def max_right(l, &f)
    res = @e
    (l ... @n).each do |i|
      res = @op.call(res, @d[i])
      return i unless f.call(res)
    end
    @n
  end

  def min_left(r, &f)
    res = @e
    (r - 1).downto(0) do |i|
      res = @op.call(@d[i], res)
      return i + 1 unless f.call(res)
    end
    0
  end
end

class SegtreeTest < Minitest::Test
  INF = (1 << 60) - 1

  def test_zero
    op = proc do |a, b|
      if a == '$'
        b
      elsif b == '$'
        a
      else
        a + b
      end
    end
    s = Segtree.new(0, '$', &op)
    assert_equal '$', s.all_prod

    s = Segtree.new('$', &op)
    assert_equal '$', s.all_prod
  end

  def test_one
    op = proc do |a, b|
      if a == '$'
        b
      elsif b == '$'
        a
      else
        a + b
      end
    end
    s = Segtree.new(1, '$', &op)
    assert_equal '$', s.all_prod
    assert_equal '$', s.get(0)
    assert_equal '$', s.prod(0, 1)
    s.set(0, "dummy")
    assert_equal "dummy", s.get(0)
    assert_equal "$", s.prod(0, 0)
    assert_equal "dummy", s.prod(0, 1)
    assert_equal '$', s.prod(1, 1)
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

    (0..30).each do |n|
      seg0 = SegtreeNaive.new(n, '$', &op)
      seg1 = Segtree.new(n, '$', &op)

      n.times do |i|
        s = ""
        s += ("a".ord + i).chr
        seg0.set(i, s)
        seg1.set(i, s)
      end

      0.upto(n) do |l|
        l.upto(n) do |r|
          assert_equal seg0.prod(l, r), seg1.prod(l, r), "prod test failed"
        end
      end

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
  def test_atcoder_library_practice_contest
    a = [1, 2, 3, 2, 1]
    st = Segtree.new(a, -INF) { |x, y| [x, y].max }
    assert_equal 3, st.prod(1 - 1, 5)
    assert_equal 3, st.max_right(2 - 1) { |v| v < 3 } + 1
    st.set(3 - 1, 1)
    assert_equal 2, st.get(1)
    assert_equal 2, st.all_prod
    assert_equal 2, st.prod(2 - 1, 4)
    assert_equal 6, st.max_right(1 - 1) { |v| v < 3 } + 1
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
end
