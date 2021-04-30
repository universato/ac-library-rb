module AcLibraryRb
  # this implementation is different from ACL because of calculation time
  # ref : https://snuke.hatenablog.com/entry/2014/12/03/214243
  # ACL  implementation : https://atcoder.jp/contests/abc135/submissions/18836384 (731ms)
  # this implementation : https://atcoder.jp/contests/abc135/submissions/18836378 (525ms)

  def z_algorithm(s)
    n = s.size
    return [] if n == 0

    s = s.codepoints if s.is_a?(String)

    z = [0] * n
    z[0] = n
    i, j = 1, 0
    while i < n
      j += 1 while i + j < n && s[j] == s[i + j]
      z[i] = j
      if j == 0
        i += 1
        next
      end
      k = 1
      while i + k < n && k + z[k] < j
        z[i + k] = z[k]
        k += 1
      end
      i += k
      j -= k
    end

    return z
  end
end
