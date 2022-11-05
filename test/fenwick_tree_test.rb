# frozen_string_literal: true

require 'minitest'
require 'minitest/autorun'

require_relative '../lib/fenwick_tree.rb'

class FenwickTreeTest < Minitest::Test
  def test_practice_contest
    a = [1, 2, 3, 4, 5]

    ft = FenwickTree.new(a)
    assert_equal 15, ft.sum(0, 5)
    assert_equal 7, ft.sum(2, 4)

    ft.add(3, 10)
    assert_equal 25, ft.sum(0, 5)
    assert_equal 6, ft.sum(0, 3)
  end

  def test_empty
    assert_raises(ArgumentError){ FenwickTree.new }
  end

  def test_zero
    fw = FenwickTree.new(0)
    assert_equal 0, fw.sum(0, 0)
  end

  def test_naive
    (1 .. 20).each do |n|
      fw = FenwickTree.new(n)
      n.times { |i| fw.add(i, i * i) }
      (0 .. n).each do |l|
        (l .. n).each do |r|
          sum = 0
          (l ... r).each { |i| sum += i * i }
          assert_equal sum, fw.sum(l, r)
        end
      end
    end
  end

  def test_init
    n = 10
    a = Array.new(n) { |i| i }

    fwa = FenwickTree.new(a)

    fwi = FenwickTree.new(n)
    a.each_with_index { |e, i| fwi.add(i, e) }

    assert_equal fwi.data, fwa.data
  end

  def test_invalid_init
    assert_raises(ArgumentError){ FenwickTree.new(:invalid_argument) }
  end

  def test_experimental_sum
    a = [1, 2, 3, 4, 5]

    ft = FenwickTree.new(a)
    assert_equal 15, ft.sum(0...5)
    assert_equal 15, ft.sum(0..4)
    assert_equal 15, ft.sum(0..)
    assert_equal 15, ft.sum(0..-1)
    assert_equal 10, ft.sum(0...-1)
    assert_equal 7, ft.sum(2...4)
    assert_equal 7, ft.sum(2..3)

    ft.add(3, 10)
    assert_equal 25, ft.sum(0...5)
    assert_equal 25, ft.sum(0..4)
    assert_equal 25, ft.sum(5)
    assert_equal 6, ft.sum(3)
  end

  def test_to_s
    uft = FenwickTree.new([1, 2, 4, 8])
    assert_equal "<FenwickTree: @size=4, (1, 3, 4, 15)>", uft.to_s
  end
end
