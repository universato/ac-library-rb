class ModInt < Numeric
  class << self
    def set_mod(mod)
      raise ArgumentError unless mod.kind_of? Integer and 1 <= mod
      @@mod, @@is_prime = mod, ModInt.prime?(mod)
    end

    def mod=(mod)
      set_mod mod
    end

    def mod
      @@mod
    end

    def raw(val, mod = @@mod, is_prime = false)
      raise ArgumentError unless val.kind_of? Integer
      x = allocate
      x.val, x.mod, x.is_prime = val, mod, is_prime
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

  attr_accessor :val, :mod, :is_prime

  alias to_i val

  def initialize(val = 0, mod = nil)
    val = 1 if true == val
    val = 0 if false == val
    raise ArgumentError unless val.kind_of? Integer
    if mod
      is_prime = ModInt.prime?(mod)
    else
      mod, is_prime = @@mod, @@is_prime
    end
    @val, @mod, @is_prime = val % mod, mod, is_prime
  end

  def inc!
    @val += 1
    @val = 0 if @val == @mod
    self
  end

  def dec!
    @val = @mod if @val == 0
    @val -= 1
    self
  end

  def add!(other)
    @val = (@val + other.to_i) % @mod
    self
  end

  def sub!(other)
    @val = (@val - other.to_i) % @mod
    self
  end

  def mul!(other)
    @val = @val * other.to_i % @mod
    self
  end

  def div!(other)
    other = of_val(other) unless other.kind_of? ModInt
    mul! other.inv
    self
  end

  def +@
    self
  end

  def -@
    of_val(-self.to_i)
  end

  def **(n)
    n = n.to_i
    raise ArgumentError unless 0 <= n
    of_val(@val.pow(n, @mod))
  end

  def inv
    if @is_prime
      raise RangeError if 0 == @val
      of_val(@val.pow(@mod - 2, @mod))
    else
      g, x = ModInt.inv_gcd(@val, @mod)
      raise RangeError unless 1 == g
      of_val(x)
    end
  end

  def coerce(other)
    [of_val(other % @mod), self]
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

  def ==(rhs)
    @val == rhs.val
  end

  def !=(rhs)
    @val != rhs.val
  end

  def dup
    ModInt.raw(@val, @mod, @is_prime)
  end

  def to_s
    val.to_s
  end

  def inspect
    "#{val} mod #{mod}"
  end

  private

  def of_val(val)
    raise ArgumentError unless val.kind_of? Integer
    ModInt.raw(val % @mod, @mod, @is_prime)
  end
end

def ModInt(val = 0, mod = nil)
  ModInt.new(val, mod)
end

class Integer
  def to_modint(mod = nil)
    ModInt.new(self, mod)
  end

  alias to_m to_modint
end

class String
  def to_modint(mod = nil)
    ModInt.new(to_i, mod)
  end

  alias to_m to_modint
end
