# frozen_string_literal: true

require 'minitest'
require 'minitest/autorun'

require_relative '../src/suffix_array.rb'
require_relative '../src/lcp_array.rb'

def lcp_array_naive(s)
  s = s.bytes if s === String
  n = s.size
  return (0 ... n).map{ |i| s[i..-1] }.sort.each_cons(2).map{ |s, t|
    lcp = 0
    lcp += 1 while lcp<s.size && lcp<t.size && s[lcp]==t[lcp]
    lcp
  }
end

class LcpArrayTest < Minitest::Test
  def test_random_array_small_elements
    maxA = 10
    20.times{
      a = (0 ... 100).map{ rand(maxA) }
      assert_equal lcp_array(a, suffix_array(a)), lcp_array_naive(a)
    }
  end

  def test_random_array_big_elements
    maxA = 10**18
    20.times{
      a = (0 ... 100).map{ rand(maxA) }
      assert_equal lcp_array(a, suffix_array(a)), lcp_array_naive(a)
    }
  end

  def test_random_string
    maxA = ?~.ord - ?\s.ord + 1
    20.times{
      s = (0 ... 100).map{ (rand(maxA) + ?\s.ord).chr }.join
      assert_equal lcp_array(s, suffix_array(s)), lcp_array_naive(s)
    }
  end

  def test_mississippi
    assert_equal lcp_array("mississippi", suffix_array("mississippi")), lcp_array_naive("mississippi")
  end
end
