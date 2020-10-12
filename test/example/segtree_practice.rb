# frozen_string_literal: true

require_relative '../../lib/segtree.rb'

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
    puts st.prod(l - 1, r)
  else
    _, x, v = query
    puts st.max_right(x - 1) { |t| t < v } + 1
  end
end
