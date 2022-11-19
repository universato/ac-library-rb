# frozen_string_literal: true

require 'minitest'
require 'minitest/autorun'

require_relative '../lib/dsu.rb'

class UnionFindTest < Minitest::Test
  def test_zero
    uf = DSU.new(0)
    assert_equal [], uf.groups
  end

  def test_empty
    uf = DSU.new
    assert_equal [], uf.groups
  end

  def test_simple
    uf = DSU.new(2)
    x = uf.merge(0, 1)
    assert_equal x, uf.leader(0)
    assert_equal x, uf.leader(1)
    assert x, uf.same?(0, 1)
    assert_equal 2, uf.size(0)
  end

  def test_line
    n = 30
    uf = DSU.new(n)
    (n - 1).times { |i| uf.merge(i, i + 1) }
    assert_equal n, uf.size(0)
    assert_equal 1, uf.groups.size
  end

  def test_line_reverse
    n = 30
    uf = DSU.new(n)
    (n - 2).downto(0) { |i| uf.merge(i, i + 1) }
    assert_equal n, uf.size(0)
    assert_equal 1, uf.groups.size
  end

  def test_groups
    d = DSU.new(4)
    groups = d.groups.map(&:sort).sort
    assert_equal 4, groups.size
    assert_equal [[0], [1], [2], [3]], groups

    d.merge(0, 1)
    d.merge(2, 3)
    groups = d.groups.map(&:sort).sort
    assert_equal 2, groups.size
    assert_equal [0, 1], groups[0]
    assert_equal [2, 3], groups[1]

    d.merge(0, 2)
    groups = d.groups.map(&:sort).sort
    assert_equal 1, groups.size, "[PR #64]"
    assert_equal [0, 1, 2, 3], groups[0], "[PR #64]"
  end

  def test_atcoder_typical_true
    uft = UnionFind.new(8)
    query = [[0, 1, 2], [0, 3, 2], [1, 1, 3], [0, 2, 4], [1, 4, 1], [0, 4, 2], [0, 0, 0], [1, 0, 0]]
    query.each do |(q, a, b)|
      if q == 0
        uft.unite(a, b)
      else
        assert uft.same?(a, b)
      end
    end
  end

  def test_aizu_sample_true
    uft = UnionFind.new(5)
    query = [[0, 1, 4], [0, 2, 3], [1, 1, 4], [1, 3, 2], [0, 1, 3], [1, 2, 4], [0, 0, 4], [1, 0, 2], [1, 3, 0]]
    query.each do |(q, a, b)|
      if q == 0
        uft.unite(a, b)
      else
        assert uft.same?(a, b)
      end
    end
  end

  def test_aizu_sample_false
    uft = UnionFind.new(5)
    query = [[0, 1, 4], [0, 2, 3], [1, 1, 2], [1, 3, 4], [0, 1, 3], [1, 3, 0], [0, 0, 4]]
    query.each do |(q, a, b)|
      if q == 0
        uft.unite(a, b)
      else
        assert !uft.same?(a, b)
      end
    end
  end

  def test_rand_isoration
    n = 30
    uft = UnionFind.new(n)
    values = [0, 1, 2, 3, 5, 10]
    values.product(values) do |a, b|
      if a == b
        assert uft.same?(a, b)
      else
        assert !uft.same?(a, b)
      end
    end
    assert_equal Array.new(n){ |i| [i] }, uft.groups
  end

  def test_merge
    uft = UnionFind.new(2)
    assert_equal 0, uft.merge(0, 1)
  end

  def test_root_with_dynamic_expansion
    uft = UnionFind.new
    assert_equal false, uft[0] == uft[1]

    uft.unite(0, 1)
    assert_equal true, uft[0] == uft[1]
  end

  def test_edge_cases_error
    assert_raises(ArgumentError){ UnionFind.new(-1) }

    n = 2
    uft = UnionFind.new(n)
    uft.unite(0, n - 1)
    assert uft.same?(0, n - 1)
    assert_equal 0, uft.leader(0)
    assert_equal 2, uft.size(0)
    assert_raises(ArgumentError){ uft.merge(1, n) }
    assert_raises(ArgumentError){ uft.merge(n, 1) }
    assert_raises(ArgumentError){ uft.same?(1, n) }
    assert_raises(ArgumentError){ uft.same?(n, 1) }
    assert_raises(ArgumentError){ uft.leader(n) }
    assert_raises(ArgumentError){ uft.size(n) }
  end

  def test_to_s
    uft = UnionFind.new(2)
    assert_equal "<DSU: @n=2, [-1, -1]>", uft.to_s
  end
end
