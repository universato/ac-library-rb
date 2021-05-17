# frozen_string_literal: true

require 'minitest'
require 'minitest/autorun'

require_relative '../lib/pow_mod.rb'

def naive_pow_mod(x, n, mod)
  y = x % mod
  z = 1 % mod
  n.times { z = (z * y) % mod }
  z
end

class PowModTest < Minitest::Test
  def test_prime_mod
    (-5 .. 5).each do |a|
      (0 .. 5).each do |b|
        (2 .. 10).each do |c|
          assert_equal naive_pow_mod(a, b, c), pow_mod(a, b, c)
          # assert_equal naive_pow_mod(a, b, c), a.pow(b, c)
        end
      end
    end
  end
end
