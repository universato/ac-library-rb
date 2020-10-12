# frozen_string_literal: true

require_relative '../../lib/fenwick_tree.rb'

_, q = gets.split.map(&:to_i)
a    = gets.split.map(&:to_i)

ft = FenwickTree.new(a)

q.times do
  t, u, v = gets.split.map(&:to_i)

  if t == 0
    ft.add(u, v)
  else
    puts ft.sum(u, v)
  end
end
