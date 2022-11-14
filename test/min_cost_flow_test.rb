# frozen_string_literal: true

require 'minitest'
require 'minitest/autorun'

require_relative '../lib/min_cost_flow.rb'

# Test for MinCostFlow
class MinCostFlowTest < Minitest::Test
  def test_simple
    g = MinCostFlow.new(4)
    g.add_edge(0, 1, 1, 1)
    g.add_edge(0, 2, 1, 1)
    g.add_edge(1, 3, 1, 1)
    g.add_edge(2, 3, 1, 1)
    g.add_edge(1, 2, 1, 1)

    assert_equal [[0, 0], [2, 4]], g.slope(0, 3, 10)

    edges = [
      [0, 1, 1, 1, 1],
      [0, 2, 1, 1, 1],
      [1, 3, 1, 1, 1],
      [2, 3, 1, 1, 1],
      [1, 2, 1, 0, 1]
    ]
    edges.each_with_index { |edge, i| assert_equal edge, g.get_edge(i) }
    assert_equal edges, g.edges
  end

  def test_usage
    g = MinCostFlow.new(2)
    g.add_edge(0, 1, 1, 2)
    assert_equal [1, 2], g.flow(0, 1)

    g = MinCostFlow.new(2)
    g.add_edge(0, 1, 1, 2)
    assert_equal [[0, 0], [1, 2]], g.slope(0, 1)
  end

  def test_self_loop
    g = MinCostFlow.new(3)
    assert_equal 0, g.add_edge(0, 0, 100, 123)
    assert_equal [0, 0, 100, 0, 123], g.get_edge(0)
    assert_equal [0, 0, 100, 0, 123], g.edge(0)
    assert_equal [0, 0, 100, 0, 123], g[0]
  end

  def test_same_cost_paths
    g = MinCostFlow.new(3)
    assert_equal 0, g.add_edge(0, 1, 1, 1)
    assert_equal 1, g.add_edge(1, 2, 1, 0)
    assert_equal 2, g.add_edge(0, 2, 2, 1)
    assert_equal [[0, 0], [3, 3]], g.slope(0, 2)
  end

  def test_add_edges
    g = MinCostFlow.new(3)
    edges = [[0, 1, 1, 1], [1, 2, 1, 0], [0, 2, 2, 1]]
    g.add(edges)
    assert_equal [[0, 0], [3, 3]], g.slope(0, 2)
  end

  def test_only_one_nonzero_cost_edge
    g = MinCostFlow.new(2)
    g.add_edge(0, 1, 1, 100)
    assert_equal [1, 100], g.flow(0, 1, 1)

    g = MinCostFlow.new(3)
    g.add_edge(0, 1, 1, 1)
    g.add_edge(1, 2, 1, 0)
    assert_equal [[0, 0], [1, 1]], g.slope(0, 2)
  end
end
