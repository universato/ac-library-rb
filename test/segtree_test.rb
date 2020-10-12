# frozen_string_literal: true

require 'minitest'
require 'minitest/autorun'

require_relative '../lib/segtree.rb'

class SegtreeTest < Minitest::Test
  INF = (1 << 60) - 1

  # https://atcoder.jp/contests/practice2/tasks/practice2_j
  def test_atcoder_library_practice_contest
    a = [1, 2, 3, 2, 1]
    st = Segtree.new(a, -INF) { |x, y| [x, y].max }
    assert_equal 3, st.prod(1 - 1, 5)
    assert_equal 3, st.max_right(2 - 1) { |v| v < 3 } + 1
    st.set(3 - 1, 1)
    assert_equal 2, st.get(1)
    assert_equal 2, st.all_prod
    assert_equal 2, st.prod(2 - 1, 4)
    assert_equal 6, st.max_right(1 - 1) { |v| v < 3 } + 1
  end
end
