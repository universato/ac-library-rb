# frozen_string_literal: true

require_relative '../../lib/crt.rb'

# Warning: This sample is a solution of the following problem:
#   https://yukicoder.me/problems/no/187

gets
r, m = $<.map{ |e| e.split.map(&:to_i) }.transpose

r, m = crt(r, m)

if r == 0 && m == 0
  puts -1
else
  r = m if r == 0
  puts r % (10**9 + 7)
end
