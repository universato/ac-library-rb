# frozen_string_literal: true

require 'minitest'
require 'minitest/autorun'

require_relative '../lib/scc.rb'

class SCCTest < Minitest::Test
  def test_empty
    assert_raises(ArgumentError){ SCC.new }

    graph1 = SCC.new(0)
    assert_equal [], graph1.scc
  end

  def test_simple
    graph = SCC.new(2)
    graph.add_edge(0, 1)
    graph.add_edge(1, 0)
    scc = graph.scc
    assert_equal 1, scc.size
  end

  def test_self_loop
    graph = SCC.new(2)
    graph.add_edge(0, 0)
    graph.add_edge(0, 0)
    graph.add_edge(1, 1)
    scc = graph.scc
    assert_equal 2, scc.size
  end

  def test_practice
    graph = SCC.new(6)
    edges = [[1, 4], [5, 2], [3, 0], [5, 5], [4, 1], [0, 3], [4, 2]]
    edges.each { |x, y| graph.add_edge(x, y) }
    groups = graph.scc

    assert_equal 4, groups.size
    assert_equal [5],         groups[0]
    assert_equal [4, 1].sort, groups[1].sort
    assert_equal [2],         groups[2]
    assert_equal [3, 0].sort, groups[3].sort
  end

  def test_typical90_021
    graph = SCC.new(4)
    edges = [[1, 2], [2, 1], [2, 3], [4, 3], [4, 1], [1, 4], [2, 3]]
    edges.each{ |edge| edge.map!{ |e| e - 1 } }
    graph.add(edges)
    groups = graph.scc

    assert_equal 2, groups.size
    assert_equal [[0, 1, 3], [2]], groups
  end

  def test_error
    graph = SCC.new(2)
    assert_raises(ArgumentError){ graph.add_edge(0, 2) }
  end
end
