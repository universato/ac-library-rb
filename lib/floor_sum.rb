def floor_sum(n, m, a, b)
  res = 0

  if a >= m
    res += (n - 1) * n * (a / m) / 2
    a %= m
  end

  if b >= m
    res += n * (b / m)
    b %= m
  end

  y_max = (a * n + b) / m

  return res if y_max == 0

  x_max = (m * y_max - b + a - 1) / a
  res += (n - x_max) * y_max + floor_sum(y_max, a, m, a * x_max - m * y_max + b)
  res
end
