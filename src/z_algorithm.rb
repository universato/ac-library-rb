# frozen_string_literal: true

def z_algorithm(s)
  n = s.size
  return [] if n == 0

  z = [0]*n
  j = 0
  1.upto(n-1){ |i|
    z[i] = j+z[j] <= i ? 0 : j+z[j]-i < z[i-j] ? j+z[j]-i : z[i-j]
    z[i] += 1 while i+k<n && s[z[i]]==s[i+z[i]]
    j = i if j+z[j] < i+z[i]
  }
  z[0] = n
  return z
end
