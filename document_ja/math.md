# Math

数学的アルゴリズムの詰め合わせです。

- `pow_mod`
- `inv_mod`
- `crt`
- `floor_sum`

## pow_mod

```ruby
pow_mod(x, n, m)
```

`(x**n) % m` を返します。

Rubyには、もともと `Integer#pow` があるため、そちらを利用した方がいいです。

基本的に、`pow_mod(x, n, m)` は、 `x.pow(n, m)`と等しいです。

ただ、Ruby 2.7.1の時点で、`Integer#pow` は、`x.pow(0, 1)`で「mod 1」なのに `1` を返す小さなバグがあります。

**制約**

- 引数`n`, `m`は、整数。
- `0 ≦ n`, `1 ≦ m`

**計算量**

- `O(log n)`

## inv_mod

```ruby
inv_mod(x, n, m)
```

`xy ≡ 1 (mod m)` なる `y` のうち、`0 ≦ y < m` を満たすものを返します。

mが素数のとき、フェルマーの小定理より `x.pow(m - 2, m)` を使えます。

**制約**

- `gcd(x, m) = 1`, `1 ≦ m`

**計算量**

- `O(log m)`

### Verified
- [ABC186 E - Throne](https://atcoder.jp/contests/abc186/tasks/abc186_e)
  [ACコード(59ms) 2020/12/20](https://atcoder.jp/contests/abc186/submissions/18898186)

## crt(r, m) -> [rem , mod] or [0, 0]

中国剰余定理
Chinese remainder theorem

同じ長さ`n`の配列`r`, `m`を渡したとき、

`x ≡ r[i] (mod m[i]), ∀i ∈ {0, 1, …… n - 1}`

を解きます。答えが存在するとき、`x ≡ rem(mod)`という形で書け、

答えが存在するとき、`[rem ,mod]`を返します。

答えがないとき、`[0, 0]`を返します。

### Verified

問題
- [No\.187 中華風 \(Hard\) - yukicoder](https://yukicoder.me/problems/no/187)

## floor_sum(n, m, a, b)

$\sum_{i = 0}^{n - 1} \mathrm{floor}(\frac{a \times i + b}{m})$

`Σ[k = 0 → n - 1] floow((a * i + b) / m)`

を計算量を工夫して計算して返します。

**計算量**

- `O(log(n + m + a + b))`

### Verified

[ALPC: C - Floor Sum](https://atcoder.jp/contests/practice2/tasks/practice2_c)
 - [ACコード 426ms 2020/9/14](https://atcoder.jp/contests/practice2/submissions/16735215)

## 参考リンク

- 当ライブラリ
  - 当ライブラリの実装コード
    - [当ライブラリの実装コード pow_mod.rb](https://github.com/universato/ac-library-rb/blob/main/lib/pow_mod.rb)
    - [当ライブラリの実装コード inv_mod.rb](https://github.com/universato/ac-library-rb/blob/main/lib/inv_mod.rb)
    - [当ライブラリの実装コード crt.rb](https://github.com/universato/ac-library-rb/blob/main/lib/crt.rb)
    - [当ライブラリの実装コード floor_sum.rb](https://github.com/universato/ac-library-rb/blob/main/lib/floor_sum.rb)
  - テストコード
    - [当ライブラリのテストコード pow_mod_test.rb](https://github.com/universato/ac-library-rb/blob/main/test/pow_mod.rb)
    - [当ライブラリのテストコード inv_mod_test.rb](https://github.com/universato/ac-library-rb/blob/main/test/inv_mod.rb)
    - [当ライブラリのテストコード crt_test.rb](https://github.com/universato/ac-library-rb/blob/main/test/crt.rb)
    - [当ライブラリのテストコード floor_sum_test.rb](https://github.com/universato/ac-library-rb/test/main/lib/floor_sum.rb)
- 本家ライブラリ
  - [本家ライブラリの実装コード math.hpp](https://github.com/atcoder/ac-library/blob/master/atcoder/math.hpp)
  - [本家ライブラリの実装コード internal_math.hpp](https://github.com/atcoder/ac-library/blob/master/atcoder/internal_math.hpp)
  - [本家ライブラリのテストコード math_test.cpp](https://github.com/atcoder/ac-library/blob/master/test/unittest/math_test.cpp)
  - [本家ライブラリのドキュメント math.md](https://github.com/atcoder/ac-library/blob/master/document_ja/math.md)
  - [Relax the constraints of floor\_sum? · Issue \#33 · atcoder/ac-library](https://github.com/atcoder/ac-library/issues/33)

## Q&A

### ファイルは個別なの?

本家側に合わせて`math`ファイルなどにまとめてもいいかもしれないです。
