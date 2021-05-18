def floor_sum(n, m, a, b)
  raise ArgumentError if n < 0 || m < 1

  res = 0

  if a < 0
    a2 = a % m
    res -= n * (n - 1) / 2 * ((a2 - a) / m)
    a = a2
  end

  if b < 0
    b2 = b % m
    res -= n * ((b2 - b) / m)
    b = b2
  end

  res + floor_sum_unsigned(n, m, a, b)
end

def floor_sum_unsigned(n, m, a, b)
  res = 0

  while true
    if a >= m
      res += n * (n - 1) / 2 * (a / m)
      a %= m
    end

    if b >= m
      res += n * (b / m)
      b %= m
    end

    y_max = a * n + b
    break if y_max < m

    n = y_max / m
    b = y_max % m
    m, a = a, m
  end

  res
end
