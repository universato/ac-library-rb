module AcLibraryRb
  # Use `x.pow(m - 2, m)` instead of `inv_mod(x, m)` if m is a prime number.
  def inv_mod(x, m)
    z = _inv_gcd(x, m)
    raise ArgumentError unless z.first == 1

    z[1]
  end

  def _inv_gcd(a, b)
    a %= b # safe_mod

    s, t = b, a
    m0, m1 = 0, 1

    while t > 0
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
