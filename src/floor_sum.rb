# frozen_string_literal: true

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
  x_max = (y_max * m - b)

  return res if y_max == 0

  res += (n - (x_max + a - 1) / a) * y_max
  res += floor_sum(y_max, a, m, (a - x_max % a) % a)
  res
end
