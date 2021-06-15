module AcLibraryRb
  # return [rem, mod] or [0, 0] (if no solution)
  def crt(r, m)
    unless r.size == m.size
      raise ArgumentError.new("size of r and m must be equal for crt(r, m)")
    end

    n = r.size
    r0, m0 = 0, 1
    n.times do |i|
      raise ArgumentError if m[i] < 1

      r1, m1 = r[i] % m[i], m[i]
      if m0 < m1
        r0, r1 = r1, r0
        m0, m1 = m1, m0
      end

      if m0 % m1 == 0
        return [0, 0] if r0 % m1 != r1

        next
      end

      g, im = inv_gcd(m0, m1)
      u1 = m1 / g
      return [0, 0] if (r1 - r0) % g != 0

      x = (r1 - r0) / g * im % u1
      r0 += x * m0
      m0 *= u1
      r0 += m0 if r0 < 0
    end

    return [r0, m0]
  end

  # internal method
  # return [g, x] s.t. g = gcd(a, b), x*a = g (mod b), 0 <= x < b/g
  def inv_gcd(a, b)
    a %= b
    return [b, 0] if a == 0

    s, t = b, a
    m0, m1 = 0, 1
    while t > 0
      u, s = s.divmod(t)
      m0 -= m1 * u
      s, t = t, s
      m0, m1 = m1, m0
    end
    m0 += b / s if m0 < 0

    return [s, m0]
  end
end
