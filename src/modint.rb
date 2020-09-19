class ModInt < Numeric

  def self.set_mod(mod)
    raise ArgumentError unless mod.kind_of? Integer and 1 <= mod
    @@mod, @@bt, @@is_prime = mod, Barrett.new(mod), ModInt.is_prime(mod)
  end

  def self.mod=(mod)
    set_mod mod
  end

  def self.mod
    @@mod
  end

  attr_accessor :val, :mod, :is_prime
  alias to_i val

  def self.raw(val, mod = @@mod, is_prime = false)
    x = allocate
    x.val, x.mod, x.is_prime = val, mod, is_prime
    return x
  end

  def initialize(val = 0, mod = nil)
    val = 1 if true == val
    val = 0 if false == val
    raise ArgumentError unless val.kind_of? Integer
    if mod
      bt, is_prime = Barrett.new(mod), ModInt.is_prime(mod)
    else
      mod, bt, is_prime = @@mod, @@bt, @@is_prime
    end
    @val, @mod, @is_prime, @bt = val % mod, mod, is_prime, bt
  end

  def inc!
    @val += 1
    @val = 0 if @val == @mod
    return self
  end

  def dec!
    @val = @mod if @val == 0
    @val -= 1
    return self
  end

  def add!(other)
    other = of_val(other) unless other.kind_of? ModInt
    @val += other.to_i
    @val -= @mod if @val >= @mod
    return self
  end

  def sub!(other)
    other = of_val(other) unless other.kind_of? ModInt
    @val = (@val - other.to_i) % @mod
    return self
  end

  def mul!(other)
    other = of_val(other) unless other.kind_of? ModInt
    @val = @bt.mul(@val, other.to_i)
    return self
  end

  def div!(other)
    other = of_val(other) unless other.kind_of? ModInt
    mul! other.inv
    return self
  end

  def +@
    return self
  end

  def -@
    return of_val(-self.to_i)
  end

  def **(n)
    n = n.to_i
    raise ArgumentError unless 0 <= n
    x, r = dup, of_val(1)
    while 0 < n
      r.mul! x if (n & 1) == 1
      x.mul! x
      n >>= 1
    end
    return r
  end

  def inv
    if @is_prime
      raise RangeError if 0 == @val
      return self ** (@mod - 2)
    else
      g, x = ModInt.inv_gcd(@val, @mod)
      raise RangeError unless 1 == g
      return of_val(x)
    end
  end

  def coerce(other)
    [of_val(other % @mod), self]
  end

  def +(other)
    return dup.add! other
  end

  def -(other)
    return dup.sub! other
  end

  def *(other)
    return dup.mul! other
  end

  def /(other)
    return dup.div! other
  end

  def ==(rhs)
    return @val == rhs.val
  end

  def !=(rhs)
    return @val != rhs.val
  end

  def dup
    return Object.instance_method(:dup).bind(self).call
  end

  private

  def of_val(val)
    x = dup
    x.val = val % @mod
    return x
  end

  class Barrett
    FULL64 = 0xffffffffffffffff

    def initialize(m)
      @umod, @im = m, FULL64 / m + 1
    end

    attr_reader :umod

    def mul(a, b)
      z = a * b & FULL64
      x = z * @im >> 64 & FULL64
      v = z - x * @umod & FULL64
      v += @umod if @umod <= v
      return v
    end
  end

  class << self
    def is_prime(n)
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
      return true
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
      return [s, m0]
    end
  end
end

def ModInt(val = 0, mod = nil)
  return ModInt.new(val, mod)
end