# frozen_string_literal: true

require 'minitest'
require 'minitest/autorun'
require 'openssl'

require_relative '../src/modint.rb'

# test ModInt
class ModIntTest < Minitest::Test
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

    assert_equal 11, a.mod # 11

    assert_equal 3, ModInt.raw(3) # 3 mod 11
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

  def test_add_sub
    ns = [2, 100, 0, 1000, -1]
    mods = [17, 119 * 2**23 + 1, 10**9 + 7, 10, 2**16, 3]
    ys = [0, 1, 10, 27, ModInt(5, 3), 10**7, 128, 2357, -23, -10**5, 10**100]
    ns.product(mods) do |(n, mod)|
      x = ModInt(n, mod)
      ys.each do |y|
        ac = (x.to_i + y.to_i) % x.mod
        wj = (x + y).to_i
        assert_equal ac, wj

        ac = (x.to_i - y.to_i) % x.mod
        wj = (x - y).to_i
        assert_equal ac, wj
      end
    end
  end

  def test_mul
    ns = [2, 100, 0, 1000, -1]
    mods = [17, 119 * 2**23 + 1, 10**9 + 7, 10, 2**16, 3]
    ys = [0, 1, 10, 27, ModInt(5, 3), 10**7, 128, 2357, -23, -10**5, 10**100]
    ns.product(mods) do |(n, mod)|
      x = ModInt(n, mod)
      ys.each do |y|
        ac = (x.to_i * y.to_i) % x.mod
        wj = (x * y).to_i
        assert_equal ac, wj
      end
    end
  end

  def test_pow
    ns = [2, 100, 0, 1000, -1]
    mods = [17, 119 * 2**23 + 1, 10**9 + 7, 10, 2**16, 3]
    ys = [0, 1, 10, 27, ModInt(5, 3), 1000, 128, 2357]
    ns.product(mods) do |(n, mod)|
      x = ModInt(n, mod)
      ys.each do |y|
        ac = x.to_i.pow(y.to_i, x.mod)
        wj = (x**y).to_i
        assert_equal ac, wj
      end
    end
  end

  def test_inv_div
    ns = [1, 2, 3, 4, 2357, 2**64]
    mods = [5, 17, 119 * 2**23 + 1, 10**9 + 7]
    xs = [ModInt(2, 125), ModInt(3, 65_536), ModInt(20, 111_111), ModInt(99, 100)]
    xs += ns.product(mods).map { |(n, mod)| ModInt(n, mod) }
    ys = [0, 1, 10, 27, 1000, 128, 2357]
    xs.each do |x|
      ac = x.to_i.to_bn.mod_inverse(x.mod)
      wj = x.inv.to_i
      assert_equal ac, wj

      ys.each do |y|
        ac = (y.to_i * x.to_i.to_bn.mod_inverse(x.mod)).to_i % x.mod
        wj = (y / x).to_i
        assert_equal ac, wj
      end
    end
  end

  def test_to_modint
    ModInt.mod = 10**9 + 7
    testcases = ["10", "100000000000000000", "1000000007", 123]
    testcases.each do |x|
      ac = x.to_i % ModInt.mod
      assert_equal ac, x.to_modint.to_i
      assert_equal ac, x.to_m.to_i

      assert_equal x.to_i % 17, x.to_modint(17).to_i
    end
  end

  def test_output
    ModInt.mod = 10**9 + 7
    testcases = [[10, "10"], [-1, "1000000006"], [10**14, "999300007"], [10**9 + 7, "0"]]
    testcases.each do |(n, ac)|
      assert_output("#{ac} mod #{ModInt.mod}\n") { p ModInt(n) }
      assert_output("#{ac}\n") { puts ModInt(n) }
    end
  end
end
