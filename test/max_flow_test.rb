# frozen_string_literal: true

require 'minitest'
require 'minitest/autorun'

require_relative '../lib/max_flow.rb'

class MaxFlowTest < Minitest::Test
  def test_simple
    g = MaxFlow.new(4)
    assert_equal 0, g.add_edge(0, 1, 1)
    assert_equal 1, g.add_edge(0, 2, 1)
    assert_equal 2, g.add_edge(1, 3, 1)
    assert_equal 3, g.add_edge(2, 3, 1)
    assert_equal 4, g.add_edge(1, 2, 1)

    assert_equal 2, g.flow(0, 3)

    edges = [
      [0, 1, 1, 1],
      [0, 2, 1, 1],
      [1, 3, 1, 1],
      [2, 3, 1, 1],
      [1, 2, 1, 0]
    ]
    edges.each_with_index do |edge, i|
      assert_equal edge, g.get_edge(i)
      assert_equal edge, g.edge(i)
      assert_equal edge, g[i]
    end
    assert_equal edges, g.edges
    assert_equal [true, false, false, false], g.min_cut(0)
  end

  def test_not_simple
    g = MaxFlow.new(2)
    assert_equal 0, g.add_edge(0, 1, 1)
    assert_equal 1, g.add_edge(0, 1, 2)
    assert_equal 2, g.add_edge(0, 1, 3)
    assert_equal 3, g.add_edge(0, 1, 4)
    assert_equal 4, g.add_edge(0, 1, 5)
    assert_equal 5, g.add_edge(0, 0, 6)
    assert_equal 6, g.add_edge(1, 1, 7)

    assert_equal 15, g.flow(0, 1)

    assert_equal [0, 1, 1, 1], g.get_edge(0)
    assert_equal [0, 1, 2, 2], g.get_edge(1)
    assert_equal [0, 1, 3, 3], g.get_edge(2)
    assert_equal [0, 1, 4, 4], g.get_edge(3)
    assert_equal [0, 1, 5, 5], g.get_edge(4)
    assert_equal [true, false], g.min_cut(0)
  end

  def test_cut
    g = MaxFlow.new(3)
    assert_equal 0, g.add_edge(0, 1, 2)
    assert_equal 1, g.add_edge(1, 2, 1)

    assert_equal 1, g.flow(0, 2)

    assert_equal [0, 1, 2, 1], g[0]
    assert_equal [1, 2, 1, 1], g[1]
    assert_equal [true, true, false], g.min_cut(0)
  end

  def test_twice
    g = MaxFlow.new(3)
    assert_equal 0, g.add_edge(0, 1, 1)
    assert_equal 1, g.add_edge(0, 2, 1)
    assert_equal 2, g.add_edge(1, 2, 1)

    assert_equal 2, g.max_flow(0, 2)

    assert_equal [0, 1, 1, 1], g.edge(0)
    assert_equal [0, 2, 1, 1], g.edge(1)
    assert_equal [1, 2, 1, 1], g.edge(2)

    g.change_edge(0, 100, 10)
    assert_equal [0, 1, 100, 10], g.edge(0)

    assert_equal 0, g.max_flow(0, 2)
    assert_equal 90, g.max_flow(0, 1)

    assert_equal [0, 1, 100, 100], g.edge(0)
    assert_equal [0, 2, 1, 1], g.edge(1)
    assert_equal [1, 2, 1, 1], g.edge(2)

    assert_equal 2, g.max_flow(2, 0)

    assert_equal [0, 1, 100, 99], g.edge(0)
    assert_equal [0, 2, 1, 0], g.edge(1)
    assert_equal [1, 2, 1, 0], g.edge(2)
  end

  def test_typical_mistake
    n = 100
    g = MaxFlow.new(n)
    s, a, b, c, t = *0..4
    uv = [5, 6]

    g.add_edge(s, a, 1)
    g.add_edge(s, b, 2)
    g.add_edge(b, a, 2)
    g.add_edge(c, t, 2)
    uv.each { |x| g.add_edge(a, x, 3) }

    loop do
      next_uv = uv.map { |x| x + 2 }
      break if next_uv[1] >= n

      uv.each  do |x|
        next_uv.each do |y|
          g.add_edge(x, y, 3)
        end
      end
      uv = next_uv
    end
    uv.each { |x| g.add_edge(x, c, 3) }

    assert_equal 2, g.max_flow(s, t)
  end

  # https://github.com/atcoder/ac-library/issues/1
  # https://twitter.com/Mi_Sawa/status/1303170874938331137
  def test_self_loop
    g = MaxFlow.new(3)
    assert_equal 0, g.add_edge(0, 0, 100)
    assert_equal [0, 0, 100, 0], g.edge(0)
  end

  # https://onlinejudge.u-aizu.ac.jp/courses/library/5/GRL/6/GRL_6_A
  def test_aizu_grl6_a
    g = MaxFlow.new(5)
    assert_equal 0, g.add_edge(0, 1, 2)
    assert_equal 1, g.add_edge(0, 2, 1)
    assert_equal 2, g.add_edge(1, 2, 1)
    assert_equal 3, g.add_edge(1, 3, 1)
    assert_equal 4, g.add_edge(2, 3, 2)
    assert_equal 3, g.max_flow(0, 4 - 1)
  end

  def test_arihon_antsbook_3_5
    g = MaxFlow.new(5)
    assert_equal 0, g.add_edge(0, 1, 10)
    assert_equal 1, g.add_edge(0, 2, 2)
    assert_equal 2, g.add_edge(1, 2, 6)
    assert_equal 3, g.add_edge(1, 3, 6)
    assert_equal 4, g.add_edge(2, 4, 5)
    assert_equal 5, g.add_edge(3, 2, 3)
    assert_equal 6, g.add_edge(3, 4, 8)
    assert_equal 11, g.max_flow(0, 4)
  end

  # https://onlinejudge.u-aizu.ac.jp/courses/library/5/GRL/6/GRL_6_A
  def test_push
    g = MaxFlow.new(5)
    assert_equal 0, g << [0, 1, 2]
    assert_equal 1, g << [0, 2, 1]
    assert_equal 2, g << [1, 2, 1]
    assert_equal 3, g << [1, 3, 1]
    assert_equal 4, g << [2, 3, 2]
    assert_equal 3, g.max_flow(0, 4 - 1)
  end

  def test_add_edges
    g = MaxFlow.new(3)
    g.add([[0, 1, 2], [1, 2, 1]])

    assert_equal 1, g.flow(0, 2)

    assert_equal [0, 1, 2, 1], g[0]
    assert_equal [1, 2, 1, 1], g[1]
    assert_equal [true, true, false], g.min_cut(0)
  end

  def test_constructor_error
    assert_raises(ArgumentError){ MaxFlow.new }
  end
end
