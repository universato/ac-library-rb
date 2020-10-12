# frozen_string_literal: true

require 'minitest'
require 'minitest/autorun'

require_relative '../lib/convolution.rb'

def convolution_naive(a, b, mod)
  n = a.size
  m = b.size
  c = [0]*(n+m-1)
  n.times{ |i|
    m.times{ |j|
      c[i+j] += a[i]*b[j]
    }
  }
  return c.map{ |c| c % mod }
end

class ConvolutionTest < Minitest::Test
  def test_for_small_array
    conv = Convolution.new
    assert_equal [1], conv.convolution([1], [1])
    assert_equal [1, 2], conv.convolution([1], [1, 2])
    assert_equal [1, 2], conv.convolution([1, 2], [1])
    assert_equal [1, 4, 4], conv.convolution([1, 2], [1, 2])
  end

  def test_random_array_modulo_default
    max_num = 10**18
    conv = Convolution.new
    20.times{
      a = (0 .. rand(100)).map{ rand(-max_num .. max_num) }
      b = (0 .. rand(100)).map{ rand(-max_num .. max_num) }
      assert_equal convolution_naive(a, b, 998244353), conv.convolution(a, b)
    }
  end

  def test_random_array_modulo_NTT_friendly_given_proot
    max_num = 10**18
    [[ 998244353,          5], # [mod, primitive_root]
     [ 998244353,  100000005],
     [ 998244353,  998244350],
     [1012924417,          5],
     [1012924417, 1012924412],
     [ 924844033,          5],
     [ 924844033,  924844028]].each{ |mod, proot|
      conv = Convolution.new(mod, proot)
      20.times{
        a = (0 ... 100).map{ rand(-max_num .. max_num) }
        b = (0 ... 100).map{ rand(-max_num .. max_num) }
        assert_equal convolution_naive(a, b, mod), conv.convolution(a, b)
      }
    }
  end

  def test_random_array_modulo_NTT_friendly_not_given_proot
    max_num = 10**18
    [998244353, 1012924417, 924844033].each{ |mod|
      conv = Convolution.new(mod)
      20.times{
        a = (0 ... 100).map{ rand(-max_num .. max_num) }
        b = (0 ... 100).map{ rand(-max_num .. max_num) }
        assert_equal convolution_naive(a, b, mod), conv.convolution(a, b)
      }
    }
  end

  def test_random_array_small_modulo_limit_length
    max_num = 10**18
    [641, 769].each{ |mod|
      conv = Convolution.new(mod)
      limlen = 1
      limlen *= 2 while (mod-1)%limlen == 0
      limlen /= 2
      20.times{
        len_a = rand(limlen) + 1
        len_b = limlen - len_a + 1 # len_a + len_b - 1 == limlen
        a = (0 ... len_a).map{ rand(-max_num .. max_num) }
        b = (0 ... len_b).map{ rand(-max_num .. max_num) }
        assert_equal convolution_naive(a, b, mod), conv.convolution(a, b)
      }
    }
  end

  def test_small_modulo_over_limit_length
    [641, 769].each{ |mod|
      conv = Convolution.new(mod)
      limlen = 1
      limlen *= 2 while (mod-1)%limlen == 0
      limlen /= 2
      # a.size + b.size - 1 == limlen + 1 > limlen
      assert_raises(ArgumentError){ conv.convolution([*0 ... limlen], [0, 0]) }
      assert_raises(ArgumentError){ conv.convolution([0, 0], [*0 ... limlen]) }
      assert_raises(ArgumentError){ conv.convolution([*0 .. limlen/2], [*0 .. limlen/2]) }
    }
  end

  def test_empty_array
    conv = Convolution.new
    assert_equal [], conv.convolution([], [])
    assert_equal [], conv.convolution([], [*0 ... 2**19])
    assert_equal [], conv.convolution([*0 ... 2**19], [])
  end

  def test_calc_primitive_root
    conv = Convolution.new

    require 'prime'
    test_primes = [2]
    test_primes += Prime.each(10**4).to_a.sample(30)

    test_primes.each{ |prime|
      # call private method
      # ref : https://qiita.com/koshilife/items/ba3a9f7a3ebe85503e4a
      g = conv.send(:calc_primitive_root, prime)
      r = 1
      assert (1 .. prime-2).all?{
        r = r*g % prime
        r != 1
      }
    }
  end
end
