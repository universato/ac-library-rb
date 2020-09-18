class ModInt < Numeric

  def self.set_mod(mod)
    raise ArgumentError unless mod.is_a? Integer and 1 <= mod
    @@mod, @@bt = mod, Barrett.new(mod)
  end

  attr_reader :val, :mod
  alias to_i val

  def self.raw(val, mod = @@mod, is_prime = false)
    x = allocate
    x.val, x.mod, x.is_prime = val, mod, is_prime
  end

  def initialize(val = 0, mod = @@mod)
    val = 1 if true == val
    val = 0 if false == val
    raise ArgumentError unless val.is_a? Integer
    @val, @mod, @is_prime = val % mod, mod, ModInt.is_prime(mod)
  end

  def succ!
    @val += 1
    @val = 0 if @val == @mod
    return self
  end

  def pred!
    @val = @mod if @val == 0
    @val -= 1
    return self
  end

  def add!(rhs)
    @val += rhs.to_i
    @val -= @mod if @val >= @mod
    return self
  end

  def sub!(rhs)
    @val -= rhs.to_i
    @val -= @mod if @val >= @mod
    return self
  end

  def mul!(rhs)
    @val = @val * rhs.to_i % @mod
    return self
  end

  def div!(rhs)
    @val = @val * rhs.inv
    return self
  end

  def +@
    return self
  end

  def -@
    return of_val(0).sub! self
  end

  def **(n)
    raise ArgumentError unless n.is_a? Integer and 0 <= n
    x, r = self, of_val(1)
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
      raise RangeError if 1 == g
      return of_val(x)
    end
  end

  def coerce(other)
    [self, of_val(other % @mod)]
  end

  def +(rhs)
    return dup.add! rhs
  end

  def -(rhs)
    return dup.sub! rhs
  end

  def *(rhs)
    return dup.mul! rhs
  end

  def /(rhs)
    return dup.div! rhs
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

  attr_writer :val, :mod, :is_prime

  def of_val(val)
    x = dup
    x.val = val
    return x
  end

  class Barrett
    FULL32 = 0xffffffff
    FULL64 = 0xffffffffffffffff

    def initialize(m)
      @umod, @im = m, FULL64 / m + 1
    end

    attr_reader :umod

    def mul(a, b)
      z = a & FULL64
      z *= b
      x = z * @im >> 64
      v = z - x * @umod & FULL32
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
      a %= b # ruby's mod is safe
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
