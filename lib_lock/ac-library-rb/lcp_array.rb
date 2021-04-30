module AcLibraryRb
  # lcp array for array of integers or string
  def lcp_array(s, sa)
    s = s.bytes if s.is_a?(String)

    n = s.size
    rnk = [0] * n
    sa.each_with_index{ |sa, id|
      rnk[sa] = id
    }

    lcp = [0] * (n - 1)
    h = 0
    n.times{ |i|
      h -= 1 if h > 0
      next if rnk[i] == 0

      j = sa[rnk[i] - 1]
      h += 1 while j + h < n && i + h < n && s[j + h] == s[i + h]
      lcp[rnk[i] - 1] = h
    }

    return lcp
  end
end
