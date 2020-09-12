# frozen_string_literal: true

require 'minitest'
require 'minitest/autorun'

require_relative '../src/z_algorithm.rb'

def z_algorithm_naive(s)
  n = s.size
  return (0 ... n).map{ |i|
    j = 0
    j += 1 while i+j<n && s[j]==s[i+j]
    j
  }
end

class ZAlgorithmTest < Minitest::Test
  def test_random_string
    maxA = ?~.ord - ?\s.ord + 1
    20.times{
      s = (0 ... 100).map{ (rand(maxA) + ?\s.ord).chr }.join
      assert_equal z_algorithm_naive(s), z_algorithm(s)
    }
  end

  def test_random_array_of_small_integer
    maxA = 10
    20.times{
      a = (0 ... 100).map{ rand(maxA) }
      assert_equal z_algorithm_naive(a), z_algorithm(a)
    }
  end

  def test_random_array_of_large_integer
    maxA = 10**18
    20.times{
      a = (0 ... 100).map{ rand(maxA) }
      assert_equal z_algorithm_naive(a), z_algorithm(a)
    }
  end

  def test_random_array_of_char
    maxA = ?~.ord - ?\s.ord + 1
    20.times{
      a = (0 ... 100).map{ (rand(maxA) + ?\s.ord).chr }
      assert_equal z_algorithm_naive(a), z_algorithm(a)
    }
  end

  def test_random_array_of_array
    candidate = [[],[0],[1],[2],[0, 0],[1, 1],[2, 2]]
    20.times{
      a = (0 ... 100).map{ candidate.sample.dup }
      assert_equal z_algorithm_naive(a), z_algorithm(a)
    }
  end

  def test_repeated_string
    20.times{
      n = rand(10**5)+1
      s = ?A*n
      assert_equal [*1 .. n].reverse, z_algorithm(s)
    }
  end

  def test_unique_array
    maxA = 10**18
    20.times{
      a = (0 ... 10**5).map{ rand(maxA) }.uniq
      assert_equal [a.size]+[0]*(a.size-1), z_algorithm(a)
    }
  end
end
