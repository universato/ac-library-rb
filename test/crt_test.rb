# frozen_string_literal: true

require 'minitest'
require 'minitest/autorun'

require_relative '../lib/crt.rb'

class CrtTest < Minitest::Test
  def test_two_elements
    [*1 .. 5].repeated_permutation(2){ |a, b|
      [*-4 .. 4].repeated_permutation(2){ |c, d|
        rem, mod = crt([c, d], [a, b])
        if mod == 0
          assert (0 ... a.lcm(b)).none?{ |x| x % a == c && x % b == d }
        else
          assert_equal a.lcm(b), mod
          assert_equal c % a, rem % a
          assert_equal d % b, rem % b
        end
      }
    }
  end

  def test_three_elements
    [*1 .. 4].repeated_permutation(3){ |a, b, c|
      [*-4 .. 4].repeated_permutation(3){ |d, e, f|
        rem, mod = crt([d, e, f], [a, b, c])
        lcm = [a, b, c].reduce :lcm
        if mod == 0
          assert (0 ... lcm).none?{ |x| x % a == d && x % b == e && x % c == f }
        else
          assert_equal lcm, mod
          assert_equal d % a, rem % a
          assert_equal e % b, rem % b
          assert_equal f % c, rem % c
        end
      }
    }
  end

  def test_random_array
    max_ans = 10**1000
    max_num = 10**18
    20.times{
      ans = rand(max_ans)
      m = (0 ... 20).map{ rand(1 .. max_num) }
      r = m.map{ |m| ans % m }
      mod = m.reduce(:lcm)
      assert_equal [ans % mod, mod], crt(r, m)
    }
  end

  def test_no_solution
    assert_equal [0, 0], crt([0, 1], [2, 2])
    assert_equal [0, 0], crt([1, 0, 5], [2, 4, 17])
  end

  def test_empty_array
    assert_equal [0, 1], crt([], [])
  end

  def test_argument_error
    # different size
    assert_raises(ArgumentError){ crt([], [1]) }
    assert_raises(ArgumentError){ crt([1], []) }
    assert_raises(ArgumentError){ crt([*1 .. 10**5], [*1 .. 10**5 - 1]) }
    assert_raises(ArgumentError){ crt([*1 .. 10**5 - 1], [*1 .. 10**5]) }

    # modulo 0
    assert_raises(ArgumentError){ crt([0], [0]) }
    assert_raises(ArgumentError){ crt([0] * 5, [2, 3, 5, 7, 0]) }
  end
end
