# frozen_string_literal: true

require 'minitest'
require 'minitest/autorun'
require 'openssl'

require_relative '../lib/modint.rb'

# test ModInt
class ModIntTest < Minitest::Test
  def setup
    @mods = [1, 2, 3, 6, 10, 11, 1_000_000_007]
    @primes = [2, 3, 5, 7, 1_000_000_007]
    @values = [-100_000, -2, -1, 0, 1, 2, 10_000_000_000]
  end

  def test_example
    ModInt.set_mod(11) # equals `ModInt.mod = 11`
    assert_equal 11, ModInt.mod

    a = ModInt(10)
    b = 3.to_m

    assert_equal 8, -b    # 8 mod 11

    assert_equal 2, a + b # 2 mod 11
    assert_equal 0, 1 + a # 0 mod 11
    assert_equal 7, a - b # 7 mod 11
    assert_equal 4, b - a # 4 mod 11

    assert_equal 8, a * b # 8 mod 11
    assert_equal 4, b.inv # 4 mod 11

    assert_equal 7, a / b # 7 mod 11

    a += b
    assert_equal 2, a  #  2 mod 11
    a -= b
    assert_equal 10, a # 10 mod 11
    a *= b
    assert_equal 8, a  #  8 mod 11
    a /= b
    assert_equal 10, a # 10 mod 11

    assert_equal 5, ModInt(2)**4 # 5 mod 11
    assert_equal 5, ModInt(2).pow(4) # 5 mod 11

    assert_output("10\n") { puts a } # 10
    assert_output("10 mod 11\n") { p a } # 10 mod 11

    assert_equal 3, ModInt.raw(3) # 3 mod 11
  end

  def test_method_zero?
    ModInt.mod = 11
    assert_equal 11, ModInt.mod

    assert_equal true, ModInt.new(11).zero?
    assert_equal true, ModInt.new(-11).zero?
    assert_equal true, ModInt.new(0).zero?

    assert_equal false, ModInt.new(12).zero?
    assert_equal false, ModInt.new(1).zero?
    assert_equal false, ModInt.new(-1).zero?
  end

  def test_pred
    ModInt.mod = 11
    assert_equal 11, ModInt.mod

    m = ModInt.new(12)
    assert_equal 2, m.succ
    assert_equal 0, m.pred
    assert_equal 1, m
  end

  def test_usage
    ModInt.mod = 11
    assert_equal 11, ModInt.mod

    assert_equal 4, ModInt.new(4)
    assert_equal 7, -ModInt.new(4)

    assert_equal 4, ModInt.new(4).to_i
    assert_equal 7, (-ModInt.new(4)).to_i

    assert ModInt.new(1) != ModInt.new(4)
    assert ModInt.new(1) == ModInt.new(12)

    ModInt.mod = 998_244_353
    assert_equal 998_244_353, ModInt.mod
    assert_equal 3, (ModInt(1) + ModInt(2))
    assert_equal 3, (1 + ModInt(2))
    assert_equal 3, (ModInt(1) + 2)

    assert_equal 3, ModInt.mod = 3
    assert_equal 3, ModInt.mod
    assert_equal 1, ModInt(2) - ModInt(1)
    assert_equal 0, ModInt(1) + ModInt(2)
    assert_equal 0, 1 + ModInt(2)
    assert_equal 0, ModInt(1) + 2

    ModInt.set_mod(11)
    assert_equal 11, ModInt.mod
    assert_equal 4, ModInt(3) * ModInt(5)
    assert_equal 4, ModInt.new(4)
    assert_equal 7, -ModInt.new(4)
  end

  def test_self_prime?
    assert_equal false, ModInt.prime?(1)
    assert_equal true,  ModInt.prime?(2)
    assert_equal true,  ModInt.prime?(3)
    assert_equal false, ModInt.prime?(4)
    assert_equal true,  ModInt.prime?(5)
    assert_equal false, ModInt.prime?(6)
    assert_equal true,  ModInt.prime?(7)
    assert_equal false, ModInt.prime?(8)
    assert_equal false, ModInt.prime?(9)
    assert_equal false, ModInt.prime?(10)
    assert_equal true,  ModInt.prime?(11)
    assert_equal true,  ModInt.prime?(10**9 + 7)
  end

  def test_add
    @mods.each do |mod|
      ModInt.mod = mod

      @values.product(@values) do |(x, y)|
        expected = (x + y) % mod
        assert_equal expected, x.to_m + y
        assert_equal expected, x + y.to_m
        assert_equal expected, x.to_m + y.to_m
      end
    end
  end

  def test_sub
    @mods.each do |mod|
      ModInt.mod = mod

      @values.product(@values) do |(x, y)|
        expected = (x - y) % mod
        assert_equal expected, x.to_m - y
        assert_equal expected, x - y.to_m
        assert_equal expected, x.to_m - y.to_m
      end
    end
  end

  def test_mul
    @mods.each do |mod|
      ModInt.mod = mod

      @values.product(@values) do |(x, y)|
        expected = (x * y) % mod
        assert_equal expected, x.to_m * y
        assert_equal expected, x * y.to_m
        assert_equal expected, x.to_m * y.to_m
      end
    end
  end

  def test_equal
    @mods.each do |mod|
      ModInt.mod = mod

      @values.each do |value|
        assert_equal true, (value % mod) == value.to_m
        assert_equal true, value.to_m == (value % mod)
        assert_equal true, value.to_m == value.to_m
      end
    end
  end

  def test_not_equal
    @mods.each do |mod|
      ModInt.mod = mod

      @values.each do |value|
        assert_equal false, (value % mod) != value.to_m
        assert_equal false, value.to_m != (value % mod)
        assert_equal false, value.to_m != value.to_m
      end
    end
  end

  def test_pow
    xs = [-6, -2, -1, 0, 1, 2, 6, 100]
    ys = [0, 1, 2, 3, 6, 100]

    @mods.each do |mod|
      ModInt.mod = mod

      xs.product(ys) do |(x, y)|
        expected = (x**y) % mod
        assert_equal expected, x.to_m**y
        assert_equal expected, x.to_m.pow(y)
      end
    end
  end

  def test_pow_method
    mods = [2, 3, 10, 1_000_000_007]
    xs = [-6, -2, -1, 0, 1, 2, 1_000_000_007]
    ys = [0, 1, 2, 1_000_000_000]

    mods.each do |mod|
      ModInt.mod = mod

      xs.product(ys) do |(x, y)|
        expected = x.pow(y, mod)
        assert_equal expected, x.to_m**y
        assert_equal expected, x.to_m.pow(y)
      end
    end
  end

  def test_pow_in_the_case_mod_is_one
    # Ruby 2.7.1 may have a bug: i.pow(0, 1) #=> 1 if i is a Integer
    # this returns should be 0
    ModInt.mod = 1
    assert_equal 0, ModInt(-1).pow(0), "corner case when modulo is one"
    assert_equal 0, ModInt(0).pow(0), "corner case when modulo is one"
    assert_equal 0, ModInt(1).pow(0), "corner case when modulo is one"
    assert_equal 0, ModInt(-5)**0, "corner case when modulo is one"
    assert_equal 0, ModInt(0)**0, "corner case when modulo is one"
    assert_equal 0, ModInt(5)**0, "corner case when modulo is one"
  end

  def test_inv_in_the_case_that_mod_is_prime
    @primes.each do |prime_mod|
      ModInt.mod = prime_mod

      @values.each do |value|
        next if (value % prime_mod).zero?

        expected = value.to_bn.mod_inverse(prime_mod).to_i
        assert_equal expected, value.to_m.inv
        assert_equal expected, 1 / value.to_m
        assert_equal expected, 1.to_m / value
        assert_equal expected, 1.to_m / value.to_m
      end
    end
  end

  def test_inv_in_the_random_mod_case
    mods = [2, 3, 4, 5, 10, 1_000_000_007]
    mods.each do |mod|
      ModInt.mod = mod

      assert_equal 1,  1.to_m.inv
      assert_equal 1,  1 / 1.to_m
      assert_equal 1,  1.to_m / 1

      assert_equal mod - 1, (mod - 1).to_m.inv
      assert_equal mod - 1, 1 / (mod - 1).to_m
      assert_equal mod - 1, 1.to_m / (mod - 1)
      assert_equal mod - 1, 1.to_m / (mod - 1).to_m
    end
  end

  def test_div_in_the_case_that_mod_is_prime
    @primes.each do |prime_mod|
      ModInt.mod = prime_mod

      @values.product(@values) do |(x, y)|
        next if (y % prime_mod).zero?

        expected = (x * y.to_bn.mod_inverse(prime_mod).to_i) % prime_mod

        assert_equal expected, x.to_m / y
        assert_equal expected, x / y.to_m
        assert_equal expected, x.to_m / y.to_m
      end
    end
  end

  def test_inv_in_the_case_that_mod_is_not_prime
    mods = { 4 => [1, 3], 6 => [1, 5], 9 => [2, 4, 7, 8], 10 => [3, 7, 9] }
    mods.each do |(mod, numbers)|
      ModInt.mod = mod

      @values.product(numbers) do |(x, y)|
        expected = (x * y.to_bn.mod_inverse(mod).to_i) % mod

        assert_equal expected, x.to_m / y
        assert_equal expected, x / y.to_m
        assert_equal expected, x.to_m / y.to_m
      end
    end
  end

  def test_inc!
    ModInt.set_mod(11)
    m = ModInt(20)
    assert_equal 9, m
    assert_equal 10, m.inc!
    assert_equal 10, m
    assert_equal 0, m.inc!
    assert_equal 0, m
  end

  def test_dec!
    ModInt.set_mod(11)
    m = ModInt(12)
    assert_equal 1, m
    assert_equal 0, m.dec!
    assert_equal 0, m
    assert_equal 10, m.dec!
    assert_equal 10, m
  end

  def test_unary_operator_plus
    ModInt.set_mod(11)
    m = ModInt(12)
    assert m.equal?(+m)
  end

  def test_to_i
    @mods.each do |mod|
      ModInt.mod = mod

      @values.each do |value|
        expected =  value % mod
        actual   =  value.to_m.to_i

        assert actual.is_a?(Integer)
        assert_equal expected, actual
      end
    end
  end

  def test_to_int
    @mods.each do |mod|
      ModInt.mod = mod

      @values.each do |value|
        expected =  value % mod
        actual   =  value.to_m.to_int

        assert actual.is_a?(Integer)
        assert_equal expected, actual
      end
    end
  end

  def test_zero?
    @mods.each do |mod|
      ModInt.mod = mod

      @values.each do |value|
        expected = (value % mod).zero?
        actual   =  value.to_m.zero?

        assert_equal expected, actual
      end
    end
  end

  def test_integer_to_modint
    ModInt.mod = 10**9 + 7

    @values.each do |value|
      expected = ModInt(value)
      assert_equal expected, value.to_m
      assert_equal expected, value.to_modint
    end
  end

  def test_string_to_modint
    ModInt.mod = 10**9 + 7
    values = ['-100', '-1', '-2', '0', '1', '2', '10', '123', '100000000000000', '1000000007']
    values.concat(values.map { |str| "#{str}\n" })

    values.each do |value|
      expected = ModInt(value.to_i)
      assert_equal expected, value.to_m
      assert_equal expected, value.to_modint
    end
  end

  def test_output_by_p_method
    ModInt.mod = 10**9 + 7
    assert_output("1000000006 mod 1000000007\n") { p(-1.to_m) }
    assert_output("1000000006 mod 1000000007\n") { p (10**9 + 6).to_m }
    assert_output("0 mod 1000000007\n") { p (10**9 + 7).to_m }
    assert_output("1 mod 1000000007\n") { p (10**9 + 8).to_m }

    @mods.each do |mod|
      ModInt.mod = mod

      @values.each do |n|
        expected = "#{n % mod} mod #{mod}\n"
        assert_output(expected) { p n.to_m }
      end
    end
  end

  def test_output_by_puts_method
    ModInt.mod = 10**9 + 7
    assert_output("1000000006\n") { puts(-1.to_m) }
    assert_output("1000000006\n") { puts (10**9 + 6).to_m }
    assert_output("0\n") { puts (10**9 + 7).to_m }
    assert_output("1\n") { puts (10**9 + 8).to_m }

    @mods.each do |mod|
      ModInt.mod = mod

      @values.each do |n|
        expected = "#{n % mod}\n"
        assert_output(expected) { puts n.to_m }
      end
    end
  end
end
