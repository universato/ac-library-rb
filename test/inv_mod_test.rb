# frozen_string_literal: true

require 'minitest'
require 'minitest/autorun'

require_relative '../lib/inv_mod.rb'

class InvModTest < Minitest::Test
  def test_prime_mod
    assert_equal 1, inv_mod(1, 11)
    assert_equal 6, inv_mod(2, 11)
    assert_equal 4, inv_mod(3, 11)
    assert_equal 3, inv_mod(4, 11)
    assert_equal 9, inv_mod(5, 11)
    assert_equal 2, inv_mod(6, 11)
    assert_equal 8, inv_mod(7, 11)
    assert_equal 7, inv_mod(8, 11)
    assert_equal 5, inv_mod(9, 11)
    assert_equal 10, inv_mod(10, 11)
    assert_equal 1, inv_mod(12, 11)
    assert_equal 6, inv_mod(13, 11)

    (1 .. 10).each do |i|
      assert_equal i.pow(11 - 2, 11), inv_mod(i, 11)
    end
  end

  def test_not_prime_mod
    assert_equal 1, inv_mod(1, 10)
    assert_equal 7, inv_mod(3, 10)
    assert_equal 3, inv_mod(7, 10)
    assert_equal 9, inv_mod(9, 10)

    assert_equal 1, inv_mod(11, 10)
    assert_equal 7, inv_mod(13, 10)
    assert_equal 3, inv_mod(17, 10)
    assert_equal 9, inv_mod(19, 10)
  end

  def test_inv_hand
    min_ll = -2**63
    max_ll = 2**63 - 1
    assert_equal inv_mod(-1, max_ll), inv_mod(min_ll, max_ll)
    assert_equal 1, inv_mod(max_ll, max_ll - 1)
    assert_equal max_ll - 1, inv_mod(max_ll - 1, max_ll)
    assert_equal 2, inv_mod(max_ll / 2 + 1, max_ll)
  end

  def test_inv_mod
    (-10 .. 10).each do |a|
      (1 .. 30).each do |b|
        next unless 1 == (a % b).gcd(b)

        c = inv_mod(a, b)
        assert 0 <= c
        assert c < b
        assert_equal 1 % b, (a * c) % b
      end
    end
  end

  def test_inv_mod_zero
    assert_equal 0, inv_mod(0, 1)
    10.times do |i|
      assert_equal 0, inv_mod(i, 1)
      assert_equal 0, inv_mod(-i, 1)
    end
  end
end
