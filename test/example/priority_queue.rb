# frozen_string_literal: true

require_relative '../../lib/priority_queue.rb'

# Warning: This sample is a solution of the following problem:
#   https://onlinejudge.u-aizu.ac.jp/problems/ALDS1_9_C

q = PriorityQueue.new
ans = []

loop do
  input = gets.chomp
  case input
  when 'end'
    break
  when 'extract'
    ans << q.pop
  else
    v = input.split[1].to_i
    q.push(v)
  end
end

puts ans
