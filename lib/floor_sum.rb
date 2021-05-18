def floor_sum(n, m, a, b)
  res = 0

  if a >= m
    res += (n - 1) * n / 2 * (a / m)
    a %= m
  end

  if b >= m
    res += n * (b / m)
    b %= m
  end

  y_max = a * n + b
  return res if y_max < m

  res += floor_sum(y_max / m, a, m, y_max % m)
  res
end
