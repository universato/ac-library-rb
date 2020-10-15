# frozen_string_literal: true

require_relative '../../lib/segtree.rb'

# Warning: This sample is a solution of the following problem:
# https://atcoder.jp/contests/practice2/tasks/practice2_j

# reference: https://github.com/atcoder/ac-library/blob/master/test/example/segtree_practice.cpp

INF = (1 << 60) - 1

_, q = gets.to_s.split.map(&:to_i)
a    = gets.to_s.split.map(&:to_i)

st = Segtree.new(a, -INF) { |x, y| [x, y].max }

q.times do
  query = gets.to_s.split.map(&:to_i)

  case query[0]
  when 1
    _, x, v = query
    st.set(x - 1, v)
  when 2
    _, l, r = query
    l -= 1
    puts st.prod(l, r)
  when 3
    _, x, v = query
    x -= 1
    puts st.max_right(x) { |t| t < v } + 1
  end
end
