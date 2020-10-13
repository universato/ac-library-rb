# frozen_string_literal: true

require_relative '../../src/suffix_array.rb'
require_relative '../../src/lcp_array.rb'

s = gets.chomp
lcp = lcp_array(s, suffix_array(s))
ans = s.size*(s.size+1)/2
lcp.each{ |lcp| ans -= lcp }
puts ans
