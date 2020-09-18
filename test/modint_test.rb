# frozen_string_literal: true

require 'minitest'
require 'minitest/autorun'

require_relative '../src/modint.rb'

class ModIntTest < Minitest::Test
  def test_add_sub
    ns = [2, 100, 0, 1000, -1]
    mods = [17, 10**9 + 7, 10, 2**16, 3]
    ys = [0, 1, 10, 27, ModInt.new(5, 3), 10000000, 128, 2357, -23, -100000, 10**100]
    ns.each do |n|
      mods.each do |mod|
        x = ModInt.new(n, mod)
        ys.each do |y|
          ac = (x.to_i + y.to_i) % x.mod
          wj = (x + y).to_i
          p [x.to_i, y.to_i, x.mod, ac, wj]
          assert_equal ac, wj

          ac = (x.to_i - y.to_i) % x.mod
          wj = (x - y).to_i
          p [x.to_i, y.to_i, x.mod, ac, wj]
          assert_equal ac, wj
        end
      end
    end
  end

  def test_mul
    ns = [2, 100, 0, 1000, -1]
    mods = [17, 10**9 + 7, 10, 2**16, 3]
    ys = [0, 1, 10, 27, ModInt.new(5, 3), 10000000, 128, 2357, -23, -100000, 10**100]
    ns.each do |n|
      mods.each do |mod|
        x = ModInt.new(n, mod)
        ys.each do |y|
          ac = (x.to_i * y.to_i) % x.mod
          wj = (x * y).to_i
          assert_equal ac, wj
        end
      end
    end
  end

  def test_pow
    ns = [2, 100, 0, 1000, -1]
    mods = [17, 10**9 + 7, 10, 2**16, 3]
    ys = [0, 1, 10, 27, ModInt.new(5, 3), 1000, 128, 2357]
    ns.each do |n|
      mods.each do |mod|
        x = ModInt.new(n, mod)
        ys.each do |y|
          ac = x.to_i.pow(y.to_i, x.mod)
          wj = (x ** y).to_i
          assert_equal ac, wj
        end
      end
    end
  end
end