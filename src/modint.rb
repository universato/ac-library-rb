# frozen_string_literal: true

# ModInt
class ModInt < Numeric
  class << self
    def set_mod(mod)
      raise ArgumentError unless mod.is_a? Integer and 1 <= mod

      $mod, $is_prime = mod, ModInt.prime?(mod)
    end

    def mod=(mod)
      set_mod mod
    end

    def mod
      $mod
    end

    def raw(val)
      x = allocate
      x.val = val.to_int
      x
    end

    def prime?(n)
      return false if n <= 1
      return true if n == 2 or n == 7 or n == 61
      return false if (n & 1) == 0

      d = n - 1
      d >>= 1 while (d & 1) == 0
      [2, 7, 61].each do |a|
        t = d
        y = a.pow(t, n)
        while t != n - 1 and y != 1 and y != n - 1
          y = y * y % n
          t <<= 1
        end
        return false if y != n - 1 and (t & 1) == 0
      end
      true
    end

    def inv_gcd(a, b)
      a %= b
      return [b, 0] if 0 == a

      s, t = b, a
      m0, m1 = 0, 1
      while 0 != t
        u = s / t
        s -= t * u
        m0 -= m1 * u
        s, t = t, s
        m0, m1 = m1, m0
      end
      m0 += b / s if m0 < 0
      [s, m0]
    end
  end

  attr_accessor :val

  alias to_i val

  def initialize(val = 0)
    @val = val.to_int % $mod
  end

  def inc!
    @val += 1
    @val = 0 if @val == $mod
    self
  end

  def dec!
    @val = $mod if @val == 0
    @val -= 1
    self
  end

  def add!(other)
    @val = (@val + other.to_i) % $mod
    self
  end

  def sub!(other)
    @val = (@val - other.to_i) % $mod
    self
  end

  def mul!(other)
    @val = @val * other.to_i % $mod
    self
  end

  def div!(other)
    mul! inv_internal(other.to_i)
  end

  def +@
    self
  end

  def -@
    ModInt.raw($mod - @val)
  end

  def **(other)
    n = other.to_i
    raise ArgumentError unless 0 <= n

    of_val(@val.pow(n, $mod))
  end

  def pow(other)
    of_val(@val.to_i.pow(other, $mod))
  end

  def inv
    of_val(inv_internal(@val))
  end

  def coerce(other)
    [of_val(other), self]
  end

  def +(other)
    dup.add! other
  end

  def -(other)
    dup.sub! other
  end

  def *(other)
    dup.mul! other
  end

  def /(other)
    dup.div! other
  end

  def ==(other)
    @val == other.to_i
  end

  def !=(other)
    @val != other.to_i
  end

  def dup
    ModInt.raw(@val)
  end

  def to_int
    @val
  end

  def zero?
    @val.zero?
  end

  def to_s
    @val.to_s
  end

  def inspect
    "#{@val} mod #{$mod}"
  end

  private

  def of_val(val)
    ModInt.raw(val.to_int % $mod)
  end

  def inv_internal(a)
    if $is_prime
      raise RangeError, 'no inverse' if 0 == a

      a.pow($mod - 2, $mod)
    else
      g, x = ModInt.inv_gcd(a, $mod)
      raise RangeError, 'no inverse' unless 1 == g

      x
    end
  end
end

def ModInt(val = 0)
  ModInt.new(val)
end

class Integer
  def to_modint
    ModInt.new(self)
  end

  alias to_m to_modint
end

class String
  def to_modint
    ModInt.new(to_i)
  end

  alias to_m to_modint
end
