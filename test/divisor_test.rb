require 'minitest'
require 'minitest/autorun'

require_relative '../lib/core_ext/integer.rb'

class IntegerTest < Minitest::Test
  def test_divisors
    assert_equal [1], 1.divisors
    assert_equal [1, 2], 2.divisors
    assert_equal [1, 3], 3.divisors
    assert_equal [1, 2, 4], 4.divisors
    assert_equal [1, 5], 5.divisors
    assert_equal [1, 2, 3, 6], 6.divisors
    assert_equal [1, 7], 7.divisors
    assert_equal [1, 2, 4, 8], 8.divisors
    assert_equal [1, 3, 9], 9.divisors
    assert_equal [1, 2, 5, 10], 10.divisors
    assert_equal [1, 2, 4, 5, 10, 20, 25, 50, 100], 100.divisors

    # large prime number
    assert_equal [1, 2**31 - 1], (2**31 - 1).divisors
    assert_equal [1, 1_000_000_007], 1_000_000_007.divisors
    assert_equal [1, 1_000_000_009], 1_000_000_009.divisors
    assert_equal [1, 67_280_421_310_721], 67_280_421_310_721.divisors

    # large composite number
    p1 = 2**13 - 1
    p2 = 2**17 - 1
    assert_equal [1, p1, p2, p1 * p2], (p1 * p2).divisors

    assert_raises(ZeroDivisionError){ 0.divisors }
    assert_equal [-1, 1], -1.divisors
    assert_equal [-2, -1, 1, 2], -2.divisors
    assert_equal [-3, -1, 1, 3], -3.divisors
    assert_equal [-4, -2, -1, 1, 2, 4], -4.divisors
    assert_equal [-6, -3, -2, -1, 1, 2, 3, 6], -6.divisors
  end

  def test_each_divisor
    d10 = []
    10.each_divisor{ |d| d10 << d }
    assert_equal [1, 2, 5, 10], d10

    assert_equal [1], 1.each_divisor.to_a
    assert_equal [1, 3], 3.each_divisor.to_a
    assert_equal [1, 2, 4], 4.each_divisor.to_a
    assert_equal [1, 2, 3, 6], 6.each_divisor.to_a

    assert_raises(ZeroDivisionError){ 0.each_divisor.to_a }
    assert_equal [-1, 1], -1.each_divisor.to_a
    assert_equal [-2, -1, 1, 2], -2.each_divisor.to_a
    assert_equal [-4, -2, -1, 1, 2, 4], -4.each_divisor.to_a
    assert_equal [-6, -3, -2, -1, 1, 2, 3, 6], -6.each_divisor.to_a
  end
end
