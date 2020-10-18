# frozen_string_literal: true

# TLE, but if you replace all @mod with 998244353 and define all method in top level, you may be able to get AC.
# https://atcoder.jp/contests/practice2/submissions/16655600

require_relative '../../lib/convolution.rb'

_, a, b = $<.map{ |e| e.split.map(&:to_i) }

conv = Convolution.new
puts conv.convolution(a, b).join("\s")
