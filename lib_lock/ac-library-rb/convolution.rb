module AcLibraryRb
  # usage :
  #
  # conv = Convolution.new(mod, [primitive_root])
  # conv.convolution(a, b) #=> convolution a and b modulo mod.
  #
  class Convolution
    def initialize(mod = 998_244_353, primitive_root = nil)
      @mod = mod

      cnt2 = bsf(@mod - 1)
      e = (primitive_root || calc_primitive_root(mod)).pow((@mod - 1) >> cnt2, @mod)
      ie = e.pow(@mod - 2, @mod)

      es = [0] * (cnt2 - 1)
      ies = [0] * (cnt2 - 1)
      cnt2.downto(2){ |i|
        es[i - 2] = e
        ies[i - 2] = ie
        e = e * e % @mod
        ie = ie * ie % @mod
      }
      now = inow = 1

      @sum_e = [0] * cnt2
      @sum_ie = [0] * cnt2
      (cnt2 - 1).times{ |i|
        @sum_e[i] = es[i] * now % @mod
        now = now * ies[i] % @mod
        @sum_ie[i] = ies[i] * inow % @mod
        inow = inow * es[i] % @mod
      }
    end

    def convolution(a, b)
      n = a.size
      m = b.size
      return [] if n == 0 || m == 0

      h = (n + m - 2).bit_length
      raise ArgumentError if h > @sum_e.size

      z = 1 << h

      a = a + [0] * (z - n)
      b = b + [0] * (z - m)

      batterfly(a, h)
      batterfly(b, h)

      c = a.zip(b).map{ |a, b| a * b % @mod }

      batterfly_inv(c, h)

      iz = z.pow(@mod - 2, @mod)
      return c[0, n + m - 1].map{ |c| c * iz % @mod }
    end

    def batterfly(a, h)
      1.upto(h){ |ph|
        w = 1 << (ph - 1)
        p = 1 << (h - ph)
        now = 1
        w.times{ |s|
          offset = s << (h - ph + 1)
          offset.upto(offset + p - 1){ |i|
            l = a[i]
            r = a[i + p] * now % @mod
            a[i] = l + r
            a[i + p] = l - r
          }
          now = now * @sum_e[bsf(~s)] % @mod
        }
      }
    end

    def batterfly_inv(a, h)
      h.downto(1){ |ph|
        w = 1 << (ph - 1)
        p = 1 << (h - ph)
        inow = 1
        w.times{ |s|
          offset = s << (h - ph + 1)
          offset.upto(offset + p - 1){ |i|
            l = a[i]
            r = a[i + p]
            a[i] = l + r
            a[i + p] = (l - r) * inow % @mod
          }
          inow = inow * @sum_ie[bsf(~s)] % @mod
        }
      }
    end

    def bsf(x)
      (x & -x).bit_length - 1
    end

    def calc_primitive_root(mod)
      return 1 if mod == 2
      return 3 if mod == 998_244_353

      divs = [2]
      x = (mod - 1) / 2
      x /= 2 while x.even?
      i = 3
      while i * i <= x
        if x % i == 0
          divs << i
          x /= i while x % i == 0
        end
        i += 2
      end
      divs << x if x > 1

      g = 2
      loop{
        return g if divs.none?{ |d| g.pow((mod - 1) / d, mod) == 1 }

        g += 1
      }
    end

    private :batterfly, :batterfly_inv, :bsf, :calc_primitive_root
  end

  # [EXPERIMENTAL]
  def convolution(a, b, mod: 998_244_353, k: 35, z: 99)
    n = a.size
    m = b.size
    return [] if n == 0 || m == 0

    raise ArgumentError if a.min < 0 || b.min < 0

    format = "%0#{k}x" # "%024x"
    sa = ""
    sb = ""
    a.each{ |x| sa << (format % x) }
    b.each{ |x| sb << (format % x) }

    zero = '0'
    s = zero * z + ("%x" % (sa.hex * sb.hex))
    i = -(n + m - 1) * k - 1

    Array.new(n + m - 1){ (s[i + 1..i += k] || zero).hex % mod }
  end
end
