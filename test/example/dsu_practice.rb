# frozen_string_literal: true

require_relative '../../lib/dsu.rb'

n, q = gets.split.map(&:to_i)

uf = UnionFind.new(n)

q.times do
  t, u, v = gets.split.map(&:to_i)

  if t == 0
    uf.unite(u, v)
  else
    puts(uf.same?(u, v) ? 1 : 0)
  end
end
