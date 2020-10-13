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
    fw = FenwickTree.new
    assert_equal 0, fw.sum(0, 0)
  end

  def test_zero
    fw = FenwickTree.new(0)
    assert_equal 0, fw.sum(0, 0)
  end

  def test_naive
    (1 .. 50).each do |n|
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
    n = 100
    a = Array.new(n) { rand(1..n) }

    fwa = FenwickTree.new(a)

    fwi = FenwickTree.new(n)
    a.each_with_index { |e, i| fwi.add(i, e) }

    assert_equal fwi.data, fwa.data
  end
end
