# Use `Integer#pow` unless m == 1
def pow_mod(x, n, m)
  return 0 if m == 1

  r, y = 1, x % m
  while n > 0
    r = r * y % m if n.odd?
    y = y * y % m
    n >>= 1
  end

  r
end
