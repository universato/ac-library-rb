# frozen_string_literal: true

require 'minitest'
require 'minitest/autorun'

require_relative '../lib/convolution.rb'

def convolution_naive(a, b, mod)
  n = a.size
  m = b.size
  c = [0] * (n + m - 1)
  n.times{ |i|
    m.times{ |j|
      c[i + j] += a[i] * b[j]
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
      a = (0 .. 20).map{ rand(-max_num .. max_num) }
      b = (0 .. 20).map{ rand(-max_num .. max_num) }
      assert_equal convolution_naive(a, b, 998_244_353), conv.convolution(a, b)
    }
  end

  def test_random_array_modulo_NTT_friendly_given_proot
    max_num = 10**18
    [[  998_244_353,             5], # [mod, primitive_root]
     [  998_244_353,   100_000_005],
     [  998_244_353,   998_244_350],
     [1_012_924_417,             5],
     [1_012_924_417, 1_012_924_412],
     [  924_844_033,             5],
     [  924_844_033,   924_844_028]].each{ |mod, proot|
      conv = Convolution.new(mod, proot)
      20.times{
        a = (0 ... 20).map{ rand(-max_num .. max_num) }
        b = (0 ... 20).map{ rand(-max_num .. max_num) }
        assert_equal convolution_naive(a, b, mod), conv.convolution(a, b)
      }
    }
  end

  def test_random_array_modulo_NTT_friendly_not_given_proot
    max_num = 10**18
    [998_244_353, 1_012_924_417, 924_844_033].each{ |mod|
      conv = Convolution.new(mod)
      20.times{
        a = (0 ... 20).map{ rand(-max_num .. max_num) }
        b = (0 ... 20).map{ rand(-max_num .. max_num) }
        assert_equal convolution_naive(a, b, mod), conv.convolution(a, b)
      }
    }
  end

  def test_random_array_small_modulo_limit_length
    max_num = 10**18
    [641, 769].each{ |mod|
      conv = Convolution.new(mod)
      limlen = 1
      limlen *= 2 while (mod - 1) % limlen == 0
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
      limlen *= 2 while (mod - 1) % limlen == 0
      limlen /= 2
      # a.size + b.size - 1 == limlen + 1 > limlen
      assert_raises(ArgumentError){ conv.convolution([*0 ... limlen], [0, 0]) }
      assert_raises(ArgumentError){ conv.convolution([0, 0], [*0 ... limlen]) }
      assert_raises(ArgumentError){ conv.convolution([*0 .. limlen / 2], [*0 .. limlen / 2]) }
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
      assert (1 .. prime - 2).all?{
        r = r * g % prime
        r != 1
      }
    }
  end
end

# [EXPERIMENTAL]
class ConvolutionMethodTest < Minitest::Test
  def test_typical_contest
    assert_equal [5, 16, 34, 60, 70, 70, 59, 36], convolution([1, 2, 3, 4], [5, 6, 7, 8, 9])
    assert_equal [871_938_225], convolution([10_000_000], [10_000_000])
  end

  def test_for_small_array
    assert_equal [1], convolution([1], [1])
    assert_equal [1, 2], convolution([1], [1, 2])
    assert_equal [1, 2], convolution([1, 2], [1])
    assert_equal [1, 4, 4], convolution([1, 2], [1, 2])
  end

  def test_random_array_modulo_default
    max_num = 10**18
    20.times{
      a = (0 .. 20).map{ rand(0 .. max_num) }
      b = (0 .. 20).map{ rand(0.. max_num) }
      assert_equal convolution_naive(a, b, 998_244_353), convolution(a, b)
    }
  end

  def test_random_array_modulo_NTT_friendly_given_proot
    max_num = 10**18
    [[  998_244_353,             5], # [mod, primitive_root]
     [  998_244_353,   100_000_005],
     [  998_244_353,   998_244_350],
     [1_012_924_417,             5],
     [1_012_924_417, 1_012_924_412],
     [  924_844_033,             5],
     [  924_844_033,   924_844_028]].each{ |mod, _proot|
      20.times{
        a = (0 ... 20).map{ rand(0 .. max_num) }
        b = (0 ... 20).map{ rand(0 .. max_num) }
        assert_equal convolution_naive(a, b, mod), convolution(a, b, mod: mod)
      }
    }
  end

  def test_random_array_modulo_NTT_friendly_not_given_proot
    max_num = 10**18
    [998_244_353, 1_012_924_417, 924_844_033].each{ |mod|
      20.times{
        a = (0 ... 20).map{ rand(0 .. max_num) }
        b = (0 ... 20).map{ rand(0 .. max_num) }
        assert_equal convolution_naive(a, b, mod), convolution(a, b, mod: mod)
      }
    }
  end

  def test_random_array_small_modulo_limit_length
    max_num = 10**18
    [641, 769].each{ |mod|
      limlen = 1
      limlen *= 2 while (mod - 1) % limlen == 0
      limlen /= 2
      20.times{
        len_a = rand(limlen) + 1
        len_b = limlen - len_a + 1 # len_a + len_b - 1 == limlen
        a = (0 ... len_a).map{ rand(0 .. max_num) }
        b = (0 ... len_b).map{ rand(0 .. max_num) }
        assert_equal convolution_naive(a, b, mod), convolution(a, b, mod: mod)
      }
    }
  end
end
