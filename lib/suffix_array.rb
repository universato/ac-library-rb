# induce sort (internal method)
def sa_is_induce(s, ls, sum_l, sum_s, lms)
  n = s.size
  sa = [-1] * n

  buf = sum_s.dup
  lms.each{ |lms|
    if lms != n
      sa[buf[s[lms]]] = lms
      buf[s[lms]] += 1
    end
  }

  buf = sum_l.dup
  sa[buf[s[-1]]] = n - 1
  buf[s[-1]] += 1
  sa.each{ |v|
    if v >= 1 && !ls[v - 1]
      sa[buf[s[v - 1]]] = v - 1
      buf[s[v - 1]] += 1
    end
  }

  buf = sum_l.dup
  sa.reverse_each{ |v|
    if v >= 1 && ls[v - 1]
      buf[s[v - 1] + 1] -= 1
      sa[buf[s[v - 1] + 1]] = v - 1
    end
  }

  return sa
end

# SA-IS (internal method)
def sa_is(s, upper)
  n = s.size

  return [] if n == 0
  return [0] if n == 1

  ls = [false] * n
  (n - 2).downto(0){ |i|
    ls[i] = (s[i] == s[i + 1] ? ls[i + 1] : s[i] < s[i + 1])
  }

  sum_l = [0] * (upper + 1)
  sum_s = [0] * (upper + 1)
  n.times{ |i|
    if ls[i]
      sum_l[s[i] + 1] += 1
    else
      sum_s[s[i]] += 1
    end
  }
  0.upto(upper){ |i|
    sum_s[i] += sum_l[i]
    sum_l[i + 1] += sum_s[i] if i < upper
  }

  lms = (1 ... n).select{ |i| !ls[i - 1] && ls[i] }
  m = lms.size
  lms_map = [-1] * (n + 1)
  lms.each_with_index{ |lms, id| lms_map[lms] = id }

  sa = sa_is_induce(s, ls, sum_l, sum_s, lms)

  return sa if m == 0

  sorted_lms = sa.select{ |sa| lms_map[sa] != -1 }
  rec_s = [0] * m
  rec_upper = 0
  rec_s[lms_map[sorted_lms[0]]] = 0
  1.upto(m - 1) do |i|
    l, r = sorted_lms[i - 1, 2]
    end_l = lms[lms_map[l] + 1] || n
    end_r = lms[lms_map[r] + 1] || n
    same = true
    if end_l - l == end_r - r
      while l < end_l
        break if s[l] != s[r]

        l += 1
        r += 1
      end
      same = false if l == n || s[l] != s[r]
    else
      same = false
    end
    rec_upper += 1 if not same
    rec_s[lms_map[sorted_lms[i]]] = rec_upper
  end

  sa_is(rec_s, rec_upper).each_with_index{ |rec_sa, id|
    sorted_lms[id] = lms[rec_sa]
  }

  return sa_is_induce(s, ls, sum_l, sum_s, sorted_lms)
end

# suffix array for array of integers or string
def suffix_array(s, upper = nil)
  if upper
    s.each{ |s|
      raise ArgumentError if s < 0 || upper < s
    }
  else
    case s
    when Array
      # compression
      n = s.size
      idx = (0 ... n).sort_by{ |i| s[i] }
      t = [0] * n
      upper = 0
      t[idx[0]] = 0
      1.upto(n - 1){ |i|
        upper += 1 if s[idx[i - 1]] != s[idx[i]]
        t[idx[i]] = upper
      }
      s = t
    when String
      upper = 255
      s = s.bytes
    end
  end

  return sa_is(s, upper)
end
