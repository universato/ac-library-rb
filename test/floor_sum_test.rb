# frozen_string_literal: true

require 'minitest'
require 'minitest/autorun'

require_relative '../lib/floor_sum.rb'

def floor_sum_naive(n, m, a, b)
  res = 0
  n.times do |i|
    z = a * i + b
    res += (z - z % m) / m
  end
  res
end

class FloorSumTest < Minitest::Test
  def test_floor_sum
    k = 5
    (0..k).each do |n|
      (1..k).each do |m|
        (-k..k).each do |a|
          (-k..k).each do |b|
            assert_equal floor_sum_naive(n, m, a, b), floor_sum(n, m, a, b)
          end
        end
      end
    end
  end

  # https://atcoder.jp/contests/practice2/tasks/practice2_c
  def test_atcoder_library_practice_contest
    assert_equal 3,  floor_sum(4, 10, 6, 3)
    assert_equal 13, floor_sum(6, 5,  4, 3)
    assert_equal 0,  floor_sum(1, 1,  0, 0)
    assert_equal 314_095_480, floor_sum(31_415, 92_653, 58_979, 32_384)
    assert_equal 499_999_999_500_000_000, floor_sum(1_000_000_000, 1_000_000_000, 999_999_999, 999_999_999)
  end
end
