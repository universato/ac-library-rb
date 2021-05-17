# frozen_string_literal: true

require 'minitest'
require 'minitest/autorun'

require_relative '../lib/z_algorithm.rb'

def z_algorithm_naive(s)
  n = s.size
  return (0 ... n).map{ |i|
    j = 0
    j += 1 while i + j < n && s[j] == s[i + j]
    j
  }
end

class ZAlgorithmTest < Minitest::Test
  def test_random_string
    20.times{
      s = (0 ... 20).map{ rand(' '.ord .. '~'.ord).chr }.join
      assert_equal z_algorithm_naive(s), z_algorithm(s)
    }
  end

  def test_random_array_of_small_integer
    max_num = 5
    20.times{
      a = (0 ... 20).map{ rand(-max_num .. max_num) }
      assert_equal z_algorithm_naive(a), z_algorithm(a)
    }
  end

  def test_random_array_of_large_integer
    max_num = 10**18
    20.times{
      a = (0 ... 20).map{ rand(-max_num .. max_num) }
      assert_equal z_algorithm_naive(a), z_algorithm(a)
    }
  end

  def test_random_array_of_char
    20.times{
      a = (0 ... 20).map{ rand(' '.ord .. '~'.ord).chr }
      assert_equal z_algorithm_naive(a), z_algorithm(a)
    }
  end

  def test_random_array_of_array
    candidate = [[], [0], [1], [2], [0, 0], [1, 1], [2, 2]]
    20.times{
      a = (0 ... 20).map{ candidate.sample.dup }
      assert_equal z_algorithm_naive(a), z_algorithm(a)
    }
  end

  def test_repeated_string
    max_n = 30
    20.times{
      n = rand(1..max_n)
      s = 'A' * n
      assert_equal [*1 .. n].reverse, z_algorithm(s)
    }
  end

  def test_unique_array
    max_num = 10**18
    20.times{
      a = (0 ... 20).map{ rand(-max_num .. max_num) }.uniq
      n = a.size
      # [n, 0, 0, ..., 0]
      assert_equal [n] + [0] * (n - 1), z_algorithm(a)
    }
  end
end
