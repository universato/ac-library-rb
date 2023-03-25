module AcLibraryRb
  require_relative './core_ext/modint.rb'

  # ModInt
  class ModInt < Numeric
    class << self
      def set_mod(mod)
        raise ArgumentError unless mod.is_a?(Integer) && (1 <= mod)

        $_mod = mod
        $_mod_is_prime = ModInt.prime?(mod)
      end

      def mod=(mod)
        set_mod mod
      end

      def mod
        $_mod
      end

      def raw(val)
        x = allocate
        x.val = val.to_i
        x
      end

      def prime?(n)
        return false if n <= 1
        return true if (n == 2) || (n == 7) || (n == 61)
        return false if (n & 1) == 0

        d = n - 1
        d >>= 1 while (d & 1) == 0
        [2, 7, 61].each do |a|
          t = d
          y = a.pow(t, n)
          while (t != n - 1) && (y != 1) && (y != n - 1)
            y = y * y % n
            t <<= 1
          end
          return false if (y != n - 1) && ((t & 1) == 0)
        end
        true
      end

      def inv_gcd(a, b)
        a %= b
        return [b, 0] if a == 0

        s, t = b, a
        m0, m1 = 0, 1
        while t != 0
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
      @val = val.to_i % $_mod
    end

    def inc!
      @val += 1
      @val = 0 if @val == $_mod
      self
    end

    def dec!
      @val = $_mod if @val == 0
      @val -= 1
      self
    end

    def add!(other)
      @val = (@val + other.to_i) % $_mod
      self
    end

    def sub!(other)
      @val = (@val - other.to_i) % $_mod
      self
    end

    def mul!(other)
      @val = @val * other.to_i % $_mod
      self
    end

    def div!(other)
      mul! inv_internal(other.to_i)
    end

    def +@
      self
    end

    def -@
      ModInt.raw($_mod - @val)
    end

    def **(other)
      $_mod == 1 ? 0 : ModInt.raw(@val.pow(other, $_mod))
    end
    alias pow **

    def inv
      ModInt.raw(inv_internal(@val) % $_mod)
    end

    def coerce(other)
      [ModInt(other), self]
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

    def pred
      dup.add!(-1)
    end

    def succ
      dup.add! 1
    end

    def zero?
      @val == 0
    end

    def dup
      ModInt.raw(@val)
    end

    def to_int
      @val
    end

    def to_s
      @val.to_s
    end

    def inspect
      "#{@val} mod #{$_mod}"
    end

    private

    def inv_internal(a)
      if $_mod_is_prime
        raise(RangeError, 'no inverse') if a == 0

        a.pow($_mod - 2, $_mod)
      else
        g, x = ModInt.inv_gcd(a, $_mod)
        g == 1 ? x : raise(RangeError, 'no inverse')
      end
    end
  end
end
