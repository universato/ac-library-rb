# frozen_string_literal: true

require 'minitest'
require 'minitest/autorun'

require_relative '../src/suffix_array.rb'

def suffix_array_naive(s)
  s = s.bytes if s === String
  n = s.size
  return (0 ... n).sort_by{ |i| s[i..-1] }
end

class SuffixArrayTest < Minitest::Test
  def test_random_array_small_elements
    maxA = 10
    20.times{
      a = (0 ... 100).map{ rand(maxA) }
      assert_equal suffix_array(a), suffix_array_naive(a)
    }
  end

  def test_random_array_big_elements
    maxA = 10**18
    20.times{
      a = (0 ... 100).map{ rand(maxA) }
      assert_equal suffix_array(a), suffix_array_naive(a)
    }
  end

  def test_random_array_given_upper
    maxA = 100
    20.times{
      a = (0 ... 100).map{ rand(maxA + 1) }
      assert_equal suffix_array(a, maxA), suffix_array_naive(a)
    }
  end

  def test_random_array_calculated_upper
    maxA = 100
    20.times{
      a = (0 ... 100).map{ rand(maxA + 1) }
      assert_equal suffix_array(a, a.max), suffix_array_naive(a)
    }
  end

  def test_wrong_given_upper
    assert_raises(ArgumentError){
      suffix_array([*0 .. 1_000_000], 999_999)
    }
  end

  def test_random_string
    maxA = ?~.ord - ?\s.ord + 1
    20.times{
      s = (0 ... 100).map{ (rand(maxA) + ?\s.ord).chr }.join
      assert_equal suffix_array(s), suffix_array_naive(s)
    }
  end

  def test_mississippi
    assert_equal suffix_array("mississippi"), [10,7,4,1,0,9,8,6,3,5,2]
  end
end
