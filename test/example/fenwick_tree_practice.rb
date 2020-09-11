# frozen_string_literal: true

require_relative '../../src/fenwick_tree.rb'

_, q = gets.split.map(&:to_i)
a    = gets.split.map(&:to_i)

ft = FenwickTree.new(a)

q.times do
  t, u, v = gets.split.map(&:to_i)

  if t == 0
    ft.add(u + 1, v)
  else
    puts ft.sum(u, v)
  end
end
