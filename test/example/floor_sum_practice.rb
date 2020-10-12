# frozen_string_literal: true

require_relative '../../lib/floor_sum.rb'

t = gets.to_s.to_i

t.times do
  n, m, a, b = gets.to_s.split.map(&:to_i)
  puts floor_sum(n, m, a, b)
end
