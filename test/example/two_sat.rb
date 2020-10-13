# frozen_string_literal: true

require_relative '../../lib/two_sat.rb'

n, d = gets.split.map(&:to_i)
x, y = n.times.map { gets.split.map(&:to_i) }.transpose
ts = TwoSAT.new(n)

n.times do |i|
  (i + 1...n).each do |j|
    ts.add_clause(i, false, j, false) if (x[i] - x[j]).abs < d
    ts.add_clause(i, false, j, true) if (x[i] - y[j]).abs < d
    ts.add_clause(i, true, j, false) if (y[i] - x[j]).abs < d
    ts.add_clause(i, true, j, true) if (y[i] - y[j]).abs < d
  end
end

if ts.satisfiable
  puts 'Yes'
  ts.answer.each_with_index do |ans, i|
    puts ans ? x[i] : y[i]
  end
else
  puts 'No'
end
