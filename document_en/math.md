# Math

It contains number-theoretic algorithms.

- `pow_mod`
- `inv_mod`
- `crt`
- `floor_sum`

## pow_mod

```ruby
pow_mod(x, n, m)
```

It returns `(x**n) % m`.

However, Ruby core has `Integer#pow`. Use it.

**Constraints**

- `n`, `m` are intergers.
- `0 ≦ n`, `1 ≦ m`

**Complexity**

- `O(log n)`

## inv_mod

```ruby
inv_mod(x, n, m)
```

It returns an integer `y` such that `0 ≦ y < m` and `xy ≡ 1 (mod m)`.

If m is a prime number, Use `x.pow(m - 2, m)`。

**Constraints**

- `gcd(x, m) = 1`, `1 ≦ m`

**Complexity**

- `O(log m)`

### Verified
- [ABC186 E - Throne](https://atcoder.jp/contests/abc186/tasks/abc186_e)
  - [AC Code(59ms) 2020/12/20](https://atcoder.jp/contests/abc186/submissions/18898186)

## crt(r, m) -> [rem , mod] or [0, 0]

Chinese remainder theorem


Given two arrays `r`, `m` with length `n`, it solves the modular equation system

`x ≡ r[i] (mod m[i]), ∀i ∈ {0, 1, …… n - 1}`

If there is no solution, it returns `[0, 0]`.

If there is a solution, all the solutions can be written as the form `x ≡ rem(mod)`. it returns `[rem ,mod]`


## Verified

Problems
- [No\.187 中華風 \(Hard\) - yukicoder](https://yukicoder.me/problems/no/187)

## floor_sum(n, m, a, b)

$\sum_{i = 0}^{n - 1} \mathrm{floor}(\frac{a \times i + b}{m})$

It retrurns `Σ[k = 0 → n - 1] floor((a * i + b) / m)`

**Complexity**

- `O(log(n + m + a + b))`

## Verified

[ALPC: C - Floor Sum](https://atcoder.jp/contests/practice2/tasks/practice2_c)
 - [AC Code 426ms 2020/9/14](https://atcoder.jp/contests/practice2/submissions/16735215)

## 参考リンク

- ac-library-rb
  - codes in ac-library-rb
    - [Code pow_mod.rb](https://github.com/universato/ac-library-rb/blob/main/lib/pow_mod.rb)
    - [Code inv_mod.rb](https://github.com/universato/ac-library-rb/blob/main/lib/inv_mod.rb)
    - [Code crt.rb](https://github.com/universato/ac-library-rb/blob/main/lib/crt.rb)
    - [Code floor_sum.rb](https://github.com/universato/ac-library-rb/blob/main/lib/floor_sum.rb)
  - test in ac-library-rb
    - [Test pow_mod_test.rb](https://github.com/universato/ac-library-rb/blob/main/test/pow_mod.rb)
    - [Test inv_mod_test.rb](https://github.com/universato/ac-library-rb/blob/main/test/inv_mod.rb)
    - [Test crt_test.rb](https://github.com/universato/ac-library-rb/blob/main/test/crt.rb)
    - [Test floor_sum_test.rb](https://github.com/universato/ac-library-rb/test/main/lib/floor_sum.rb)
- AtCoder Library
  - [Code math.hpp](https://github.com/atcoder/ac-library/blob/master/atcoder/math.hpp)
  - [Code internal_math.hpp](https://github.com/atcoder/ac-library/blob/master/atcoder/internal_math.hpp)
  - [Test math_test.cpp](https://github.com/atcoder/ac-library/blob/master/test/unittest/math_test.cpp)
  - [Document math.md](https://github.com/atcoder/ac-library/blob/master/document_ja/math.md)
  - [Document math.html](https://atcoder.github.io/ac-library/document_en/math.html)
  - [Relax the constraints of floor\_sum? · Issue \#33 · atcoder/ac-library](https://github.com/atcoder/ac-library/issues/33)
