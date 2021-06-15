# frozen_string_literal: true

require 'minitest'
require 'minitest/autorun'

require_relative '../lib/two_sat.rb'

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
  def test_empty
    assert_raises(ArgumentError){ TwoSAT.new }

    ts1 = TwoSAT.new(0)
    assert_equal true, ts1.satisfiable
    assert_equal [], ts1.answer
  end

  def test_one
    ts = TwoSAT.new(1)
    ts.add_clause(0, true, 0, true)
    ts.add_clause(0, false, 0, false)
    assert_equal false, ts.satisfiable

    ts = TwoSAT.new(1)
    ts.add_clause(0, true, 0, true)
    assert_equal true, ts.satisfiable
    assert_equal [true], ts.answer

    ts = TwoSAT.new(1)
    ts.add_clause(0, false, 0, false)
    assert_equal true, ts.satisfiable
    assert_equal [false], ts.answer
  end

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

  def test_alias_satisfiable?
    ts1 = TwoSAT.new(0)
    assert_equal true, ts1.satisfiable?
    assert_equal [], ts1.answer
  end

  def test_error
    ts1 = TwoSAT.new(2)
    assert_raises(ArgumentError){ ts1.add_clause(0, true, 2, false) }
    assert_raises(ArgumentError){ ts1.add_clause(2, true, 0, false) }
  end
end
