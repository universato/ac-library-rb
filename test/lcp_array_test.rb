# frozen_string_literal: true

require 'minitest'
require 'minitest/autorun'

require_relative '../lib/suffix_array.rb'
require_relative '../lib/lcp_array.rb'

def lcp_array_naive(s)
  s = s.bytes if s.is_a?(String)
  n = s.size
  return (0 ... n).map{ |i| s[i..-1] }.sort.each_cons(2).map{ |s, t|
    lcp = 0
    lcp += 1 while lcp < s.size && lcp < t.size && s[lcp] == t[lcp]
    lcp
  }
end

class LcpArrayTest < Minitest::Test
  def test_random_array_small_elements
    max_num = 5
    20.times{
      a = (0 ... 30).map{ rand(-max_num .. max_num) }
      assert_equal lcp_array_naive(a), lcp_array(a, suffix_array(a))
    }
  end

  def test_random_array_big_elements
    max_num = 10**18
    20.times{
      a = (0 ... 30).map{ rand(-max_num .. max_num) }
      assert_equal lcp_array_naive(a), lcp_array(a, suffix_array(a))
    }
  end

  def test_random_string
    20.times{
      s = (0 ... 30).map{ rand(' '.ord .. '~'.ord).chr }.join
      assert_equal lcp_array_naive(s), lcp_array(s, suffix_array(s))
    }
  end

  def test_mississippi
    s = "mississippi"
    assert_equal lcp_array_naive(s), lcp_array(s, suffix_array(s))
  end

  def test_abracadabra
    s = "abracadabra"
    assert_equal lcp_array_naive(s), lcp_array(s, suffix_array(s))
  end
end
