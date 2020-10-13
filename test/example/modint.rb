# frozen_string_literal: true

require_relative '../../lib/modint.rb'

ModInt.set_mod(11)
ModInt.mod # 11

a = ModInt(10)
b = 3.to_m

-b    # 8 mod 11

a + b # 2 mod 11
1 + a # 0 mod 11
a - b # 7 mod 11
b - a # 4 mod 11

a * b # 8 mod 11
b.inv # 4 mod 11

a / b #  7 mod 11

a += b
a #  2 mod 11
a -= b
a # 10 mod 11
a *= b
a #  8 mod 11
a /= b
a # 10 mod 11

a**2 # 1 mod 11
a**3 # 10 mod 11
a.pow(4) # 1 mod 11

ModInt(2)**4 # 5 mod 11

puts a # 10

a = ModInt.raw(3) # 3 mod 11

a.zero?    # false
a.nonzero? # 3 mod 11

a = 11.to_m
a.zero?    # true
a.nonzero? # nil

ModInt.mod = 1
a # 0 mod 1
a.pow(0) # 0
a**0 # 0
