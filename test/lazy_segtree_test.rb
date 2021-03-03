# frozen_string_literal: true

require 'minitest'
require 'minitest/autorun'

require_relative '../lib/lazy_segtree.rb'

# Test for Segment tree with lazy propagation
class LazySegtreeTest < Minitest::Test
  # http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=DSL_2_F&lang=ja
  def test_aizu_dsl_2_f
    inf = 2**31 - 1

    e = inf
    id = inf
    op = proc { |x, y| [x, y].min }
    mapping = proc { |x, y| x == 2**31 - 1 ? y : x }
    composition = proc { |x, y| x == 2**31 - 1 ? y : x }

    n = 3
    seg = LazySegtree.new(n, e, id, op, mapping, composition)
    seg.range_apply(0, 1 + 1, 1)
    seg.range_apply(1, 2 + 1, 3)
    seg.range_apply(2, 2 + 1, 2)
    seg.prod(0, 2 + 1)
    assert_equal 1, seg.prod(0, 2 + 1)
    assert_equal 2, seg.prod(1, 2 + 1)

    n = 1
    seg = LazySegtree.new(n, e, id, op, mapping, composition)
    assert_equal 2_147_483_647, seg.prod(0, 0 + 1)
    seg.range_apply(0, 0 + 1, 5)
    assert_equal 5, seg.prod(0, 0 + 1)
  end

  # http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=DSL_2_G
  def test_aizu_dsl_2_g
    e = [0, 1]
    id = 0
    op = proc{ |(ch1, ch1s), (ch2, ch2s)| [ch1 + ch2, ch1s + ch2s] }
    mapping = proc{ |f, (s, sz)| [s + f * sz, sz] }
    composition = proc{ |fl, fr| fl + fr }

    n = 3
    seg = LazySegtree.new(n, e, id, op, mapping, composition)
    seg.range_apply(0, 2, 1)
    seg.range_apply(1, 3, 2)
    seg.range_apply(2, 3, 3)
    assert_equal 4, seg.prod(0, 2)[0]
    assert_equal 8, seg.prod(1, 3)[0]

    n = 4
    seg = LazySegtree.new(n, e, id, op, mapping, composition)
    assert_equal 0, seg.prod(0, 4)[0]
    seg.range_apply(0, 4, 1)
    assert_equal 4, seg.prod(0, 4)[0]
  end

  def test_usage
    vector = [0] * 10
    e = -1_000_000_000
    id = 0
    op = proc { |x, y| [x, y].max }
    mapping = proc { |x, y| x + y }
    composition = proc { |x, y| x + y }

    seg = LazySegtree.new(vector, e, id, op, mapping, composition)
    assert_equal 0, seg.all_prod
    seg.range_apply(0, 3, 5)
    assert_equal 5, seg.all_prod
    seg.apply(2, -10)
    assert_equal (-5), seg.prod(2, 3)
    assert_equal 0, seg.prod(2, 4)
  end
end
