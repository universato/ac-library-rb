# frozen_string_literal: true

require 'minitest'
require 'minitest/autorun'

require_relative '../src/fenwick_tree.rb'

class FenwickTreeTest < Minitest::Test
  def test_practice_contest
    a = [1, 2, 3, 4, 5]

    ft = FenwickTree.new(a)
    assert_equal 15, ft.sum(0, 5)
    assert_equal 7, ft.sum(2, 4)

    ft.add(3 + 1, 10)
    assert_equal 25, ft.sum(0, 5)
    assert_equal 6, ft.sum(0, 3)
  end
end
