# frozen_string_literal: true

class Convolution
  def initialize(mod = 998244353, primitive_root = 3)
    @mod = mod

    cnt2 = bsf(@mod - 1)
    e = primitive_root.pow((@mod-1) >> cnt2, @mod)
    ie = e.pow(@mod - 2, @mod)
    
    es = [0]*(cnt2-1)
    ies = [0]*(cnt2-1)
    cnt2.downto(2){ |i|
      es[i-2] = e
      ies[i-2] = ie
      e = e*e % @mod
      ie = ie*ie % @mod
    }
    now = inow = 1

    @sum_e = [0]*(cnt2-2)
    @sum_ie = [0]*(cnt2-2)
    (cnt2-2).times{ |i|
      @sum_e[i] = es[i]*now % @mod
      now = now*ies[i] % @mod
      @sum_ie[i] = ies[i]*inow % @mod
      inow = inow*es[i] % @mod
    }
  end

  def convolution(a, b)
    n = a.size
    m = b.size
    return [] if n==0 || m==0

    h = (n+m-2).bit_length
    z = 1 << h

    a = a+[0]*(z-n)
    b = b+[0]*(z-m)

    batterfly(a, h)
    batterfly(b, h)

    c = a.zip(b).map{ |a, b| a*b % @mod }

    batterfly_inv(c, h)

    iz = z.pow(@mod-2, @mod)
    return c[0,n+m-1].map{ |c| c*iz % @mod }
  end

  def batterfly(a, h)
    1.upto(h){ |ph|
      w = 1 << (ph-1)
      p = 1 << (h-ph)
      now = 1
      w.times{ |s|
        offset = s << (h-ph+1)
        offset.upto(offset+p-1){ |i|
          l = a[i]
          r = a[i+p]*now % @mod
          a[i] = l+r
          a[i+p] = l-r
        }
        now = now*@sum_e[bsf(~s)] % @mod
      }
    }
  end

  def batterfly_inv(a, h)
    h.downto(1){ |ph|
      w = 1 << (ph-1)
      p = 1 << (h-ph)
      inow = 1
      w.times{ |s|
        offset = s << (h-ph+1)
        offset.upto(offset+p-1){ |i|
          l = a[i]
          r = a[i+p]
          a[i] = l+r
          a[i+p] = (l-r)*inow % @mod
        }
        inow = inow*@sum_ie[bsf(~s)] % @mod
      }
    }
  end

  def bsf(x)
    (x & -x).bit_length - 1
  end
  protected :batterfly, :batterfly_inv, :bsf
end
