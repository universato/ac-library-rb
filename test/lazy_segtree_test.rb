# frozen_string_literal: true

require 'minitest'
require 'minitest/autorun'

require_relative '../lib/lazy_segtree.rb'

# Test for Segment tree with lazy propagation
class LazySegtreeTest < Minitest::Test
  # AOJ: RSQ and RAQ
  # https://onlinejudge.u-aizu.ac.jp/problems/DSL_2_F
  def test_aizu_dsl_2_f
    inf = 2**31 - 1

    e = inf
    id = inf
    op = proc { |x, y| [x, y].min }
    mapping = proc { |f, x| f == id ? x : f }
    composition = proc { |f, g| f == id ? g : f }

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

  # AOJ: RMQ and RUQ
  # https://onlinejudge.u-aizu.ac.jp/problems/DSL_2_G
  def test_aizu_dsl_2_g
    e = [0, 1]
    id = 0
    op = proc{ |(vx, sx), (vy, sy)| [vx + vy, sx + sy] }
    mapping = proc{ |f, (s, sz)| [s + f * sz, sz] }
    composition = proc{ |f, g| f + g }

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

  # AOJ: RMQ and RAQ
  # https://onlinejudge.u-aizu.ac.jp/problems/DSL_2_H
  def test_aizu_dsl_2_h
    vector = [0] * 6
    e = 1_000_000_000
    id = 0

    seg = LazySegtree.new(vector, e, id){ |x, y| [x, y].min }
    seg.set_mapping{ |x, y| x + y }
    seg.set_composition{ |x, y| x + y }

    seg.range_apply(1, 3 + 1, 1)
    seg.range_apply(2, 4 + 1, -2)
    assert_equal -2, seg.prod(0, 5 + 1)
    assert_equal 0, seg.prod(0, 1 + 1)
    seg.range_apply(3, 5 + 1, 3)
    assert_equal 1, seg.prod(3, 4 + 1)
    assert_equal -1, seg.prod(0, 5 + 1)
  end

  # AOJ: RSQ and RUQ
  # https://onlinejudge.u-aizu.ac.jp/problems/DSL_2_I
  def test_aizu_dsl_2_i
    vector = Array.new(6){ [0, 1] }
    e = [0, 0]
    id = 10**18

    seg = LazySegtree.new(vector, e, id){ |(vx, sx), (vy, sy)| [vx + vy, sx + sy] }
    seg.set_mapping{ |f, x| x[0] = f * x[1] unless f == id; x }
    seg.set_composition{ |f, g| f == id ? g : f }

    seg.range_apply(1, 3 + 1, 1)
    seg.range_apply(2, 4 + 1, -2)
    assert_equal [-5, 6], seg.prod(0, 5 + 1)
    assert_equal [1, 2], seg.prod(0, 1 + 1)
    seg.range_apply(3, 5 + 1, 3)
    assert_equal [6, 2], seg.prod(3, 4 + 1)
    assert_equal [8, 6], seg.prod(0, 5 + 1)
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
    assert_equal -5, seg.prod(2, 3)
    assert_equal 0, seg.prod(2, 4)
  end

  def test_proc_setter
    vector = [0] * 10
    e = -1_000_000_000
    id = 0

    seg = LazySegtree.new(vector, e, id){ |x, y| [x, y].max }
    seg.set_mapping{ |x, y| x + y }
    seg.set_composition{ |x, y| x + y }

    assert_equal 0, seg.all_prod
    seg.range_apply(0, 3, 5)
    assert_equal 5, seg.all_prod
    seg.apply(2, -10)
    assert_equal -5, seg.prod(2, 3)
    assert_equal 0, seg.prod(2, 4)
  end

  def test_empty_lazy_segtree
    vector = []
    e = -1_000_000_000
    id = 0

    empty_seg = LazySegtree.new(vector, e, id){ |x, y| [x, y].max }
    empty_seg.set_mapping{ |x, y| x + y }
    empty_seg.set_composition{ |x, y| x + y }

    assert_equal e, empty_seg.all_prod
  end

  def test_one_lazy_segtree
    vector = [0]
    e = -1_000_000_000
    id = 0

    empty_seg = LazySegtree.new(vector, e, id){ |x, y| [x, y].max }
    empty_seg.set_mapping{ |x, y| x + y }
    empty_seg.set_composition{ |x, y| x + y }

    assert_equal e, empty_seg.prod(0, 0)
    assert_equal e, empty_seg.prod(1, 1)
    assert_equal 0, empty_seg.prod(0, 1)
    assert_equal 0, empty_seg.get(0)
    assert_equal 0, empty_seg[0]
  end

  def test_quora2021_skyscraper
    a = [4, 2, 3, 2, 4, 7, 6, 5]

    e = -(10**18)
    id = 10**18
    seg = LazySegtree.new(a, e, id){ |x, y| [x, y].max }
    seg.set_mapping{ |f, x| f == id ? x : f }
    seg.set_composition{ |f, g| f == id ? g : f }

    g = proc{ |x| x <= $h }

    i = 3 - 1
    $h = seg.get(i)
    r = seg.max_right(i, &g)
    l = seg.min_left(i, &g)
    assert_equal 3, r - l

    i = 2 - 1
    $h = seg.get(i)
    r = seg.max_right(i, &g)
    l = seg.min_left(i, &g)
    assert_equal 1, r - l

    seg.set(3 - 1, 8)

    i = 5 - 1
    $h = seg.get(i)
    r = seg.max_right(i, &g)
    l = seg.min_left(i, &g)
    assert_equal 2, r - l

    seg.range_apply(5 - 1, 7 - 1 + 1, 1)

    i = 8 - 1
    $h = seg.get(i)
    r = seg.max_right(i, &g)
    l = seg.min_left(i, &g)
    assert_equal 5, r - l
  end

  # AOJ: RMQ and RAQ
  # https://onlinejudge.u-aizu.ac.jp/problems/DSL_2_H
  def test_apply_3arguments
    vector = [0] * 6
    e = 1_000_000_000
    id = 0

    seg = LazySegtree.new(vector, e, id){ |x, y| [x, y].min }
    seg.set_mapping{ |x, y| x + y }
    seg.set_composition{ |x, y| x + y }

    seg.apply(1, 3 + 1, 1)
    seg.apply(2, 4 + 1, -2)
    assert_equal -2, seg.prod(0, 5 + 1)
    assert_equal 0, seg.prod(0, 1 + 1)
    seg.apply(3, 5 + 1, 3)
    assert_equal 1, seg.prod(3, 4 + 1)
    assert_equal -1, seg.prod(0, 5 + 1)
  end

  # AOJ: RMQ and RUQ
  # https://onlinejudge.u-aizu.ac.jp/problems/DSL_2_G
  def test_acl_original_order_new1
    op = proc { |(vx, sx), (vy, sy)| [vx + vy, sx + sy] }
    e = [0, 1]
    mapping = proc{ |f, (s, sz)| [s + f * sz, sz] }
    composition = proc{ |f, g| f + g }
    id = 0

    n = 3
    seg = LazySegtree.new(n, op, e, mapping, composition, id)
    seg.apply(0, 2, 1)
    seg.apply(1, 3, 2)
    seg.apply(2, 3, 3)
    assert_equal 4, seg.prod(0, 2)[0]
    assert_equal 8, seg.prod(1, 3)[0]

    n = 4
    seg = LazySegtree.new(n, op, e, mapping, composition, id)
    assert_equal 0, seg.prod(0, 4)[0]
    seg.apply(0, 4, 1)
    assert_equal 4, seg.prod(0, 4)[0]
  end

  # AOJ: RMQ and RAQ
  # https://onlinejudge.u-aizu.ac.jp/problems/DSL_2_H
  def test_acl_original_order_new2
    vector = [0] * 6
    op = ->(x, y){ [x, y].min }
    e = 1_000_000_000
    mapping = ->(f, x){ f + x }
    composition = ->(f, g) { f + g }
    id = 0
    seg = LazySegtree.new(vector, op, e, mapping, composition, id)

    seg.range_apply(1, 3 + 1, 1)
    seg.range_apply(2, 4 + 1, -2)
    assert_equal -2, seg.prod(0, 5 + 1)
    assert_equal 0, seg.prod(0, 1 + 1)
    seg.range_apply(3, 5 + 1, 3)
    assert_equal 1, seg.prod(3, 4 + 1)
    assert_equal -1, seg.prod(0, 5 + 1)
  end
end
