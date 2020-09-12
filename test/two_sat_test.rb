# frozen_string_literal: true

require 'minitest'
require 'minitest/autorun'

require_relative '../src/two_sat.rb'

def solve(two_sat, count, distance, x, y)
  count.times do |i|
    (i + 1...count).each do |j|
      two_sat.add_clause(i, false, j, false) if (x[i] - x[j]).abs < distance
      two_sat.add_clause(i, false, j, true) if (x[i] - y[j]).abs < distance
      two_sat.add_clause(i, true, j, false) if (y[i] - x[j]).abs < distance
      two_sat.add_clause(i, true, j, true) if (y[i] - y[j]).abs < distance
    end
  end
  two_sat
end

class TwoSATTest < Minitest::Test
  # https://atcoder.jp/contests/practice2/tasks/practice2_h
  def test_atcoder_library_practice_contest_case_one
    count, distance = 3, 2
    x = [1, 2, 0]
    y = [4, 5, 6]
    two_sat = solve(TwoSAT.new(count), count, distance, x, y)

    assert_equal true, two_sat.satisfiable
    assert_equal [false, true, true], two_sat.answer
  end

  def test_atcoder_library_practice_contest_case_two
    count, distance = 3, 3
    x = [1, 2, 0]
    y = [4, 5, 6]
    two_sat = solve(TwoSAT.new(count), count, distance, x, y)

    assert_equal false, two_sat.satisfiable
  end
end
