# Math

## crt(r, m) -> [rem , mod] or [0, 0]

中国剰余定理
Chinese remainder theorem

同じ長さ`n`の配列`r`, `m`を渡したとき、

`x ≡ r[i] (mod m[i]), ∀i ∈ {0, 1, …… n - 1}`

を解きます。答えが存在するとき、`x ≡ rem(mod)`という形で書け、

答えが存在するとき、`[rem ,mod]`を返します。

答えがないとき、`[0, 0]`を返します。

## Verified

問題
[No\.187 中華風 \(Hard\) \- yukicoder](https://yukicoder.me/problems/no/187)

## 参考リンク

- [当ライブラリの実装コード crt.rb](https://github.com/universato/ac-library-rb/blob/master/lib/crt.rb)
- 本家
  - [本家ライブラリの実装コード math.hpp](https://github.com/atcoder/ac-library/blob/master/atcoder/math.hpp)
  - [本家ライブラリのドキュメント math.md](https://github.com/atcoder/ac-library/blob/master/document_ja/math.md)

## floor_sum(n, m, a, b)

$\sum_{i = 0}^{n - 1} \mathrm{floor}(\frac{a \times i + b}{m})$

`Σ[k = 0 → n - 1] floow((a * i + b) / m)`

を計算量を工夫して計算して返します。

**計算量** `O(log(n + m + a + b))`

## Verified

[ALPC: C \- Floor Sum](https://atcoder.jp/contests/practice2/tasks/practice2_c)
 - [ACコード 426ms 2020/9/14](https://atcoder.jp/contests/practice2/submissions/16735215)

## 参考リンク

- [当ライブラリの実装コード floor_sum.rb](https://github.com/universato/ac-library-rb/blob/master/lib/floor_sum.rb)
- 本家
  - [本家ライブラリの実装コード math.hpp](https://github.com/atcoder/ac-library/blob/master/atcoder/math.hpp)
  - [本家ライブラリのドキュメント math.md](https://github.com/atcoder/ac-library/blob/master/document_ja/math.md)
  - [Relax the constraints of floor\_sum? · Issue \#33 · atcoder/ac\-library](https://github.com/atcoder/ac-library/issues/33)

## Q&A

### ファイルは個別なの?

本家側に合わせて`math`ファイルなどにまとめてもいいかもしれないです。
