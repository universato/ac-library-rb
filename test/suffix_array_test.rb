# frozen_string_literal: true

require 'minitest'
require 'minitest/autorun'

require_relative '../lib/suffix_array.rb'

def suffix_array_naive(s)
  s = s.bytes if s.is_a?(String)
  n = s.size
  return (0 ... n).sort_by{ |i| s[i..-1] }
end

class SuffixArrayTest < Minitest::Test
  def test_random_array_small_elements
    max_num = 5
    20.times{
      a = (0 ... 20).map{ rand(-max_num .. max_num) }
      assert_equal suffix_array_naive(a), suffix_array(a)
    }
  end

  def test_random_array_big_elements
    max_num = 10**18
    20.times{
      a = (0 ... 20).map{ rand(-max_num .. max_num) }
      assert_equal suffix_array_naive(a), suffix_array(a)
    }
  end

  def test_random_array_given_upper
    max_num = 100
    20.times{
      a = (0 ... 20).map{ rand(0 .. max_num) }
      assert_equal suffix_array_naive(a), suffix_array(a, max_num)
    }
  end

  def test_random_array_calculated_upper
    max_num = 100
    20.times{
      a = (0 ... 20).map{ rand(0 .. max_num) }
      assert_equal suffix_array_naive(a), suffix_array(a, a.max)
    }
  end

  def test_wrong_given_upper
    assert_raises(ArgumentError){ suffix_array([*0 .. 1_000_000], 999_999) }
  end

  def test_random_string
    20.times{
      s = (0 ... 20).map{ rand(' '.ord .. '~'.ord).chr }.join
      assert_equal suffix_array_naive(s), suffix_array(s)
    }
  end

  def test_mississippi
    assert_equal [10, 7, 4, 1, 0, 9, 8, 6, 3, 5, 2], suffix_array("mississippi")
  end

  def test_abracadabra
    assert_equal [10, 7, 0, 3, 5, 8, 1, 4, 6, 9, 2], suffix_array("abracadabra")
  end
end
