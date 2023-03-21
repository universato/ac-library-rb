# Segtree

セグメント木です。

## 特異メソッド

### new(arg, e){ |x, y| ... } -> Segtree
### new(arg, op, e) -> Segtree

```rb
seg = Segtree.new(arg, e) { |x, y| ... }
```

第1引数は、`Integer`または`Array`です。

- 第1引数が`Integer`の`n`のとき、長さ`n`・初期値`e`のセグメント木を作ります。
- 第1引数が長さ`n`の`Array`の`a`のとき、`a`をもとにセグメント木を作ります。

第2引数は単位元`e`で、ブロックで二項演算`op(x, y)`を定義することで、モノイドを定義する必要があります。

**計算量** `O(n)`

### モノイドの設定コード例

```ruby
n   = 10**5
inf = (1 << 60) - 1

Segtree.new(n, 0) { |x, y| x.gcd y }       # gcd
Segtree.new(n, 1) { |x, y| x.lcm y }       # lcm
Segtree.new(n, -inf) { |x, y| [x, y].max } # max
Segtree.new(n,  inf) { |x, y| [x, y].min } # min
Segtree.new(n, 0) { |x, y| x | y }         # or
Segtree.new(n, 1) { |x, y| x * y }         # prod
Segtree.new(n, 0) { |x, y| x + y }         # sum
```

## インスタンスメソッド

### set(pos, x)

```rb
seg.set(pos, x)
```

`a[pos]` に `x` を代入します。

**計算量**

- `O(logn)`

### get(pos)

```rb
seg.get(pos)
```

`a[pos]` を返します。

**計算量**

- `O(1)`

### prod(l, r)

```rb
seg.prod(l, r)
```

`op(a[l], ..., a[r - 1])` を返します。引数は半開区間です。`l == r`のとき、単位元`e`を返します。

**制約**

- `0 ≦ l ≦ r ≦ n`

**計算量**

- `O(logn)`

### all_prod

```rb
seg.all_prod
```

`op(a[0], ..., a[n - 1])` を返します。空のセグメントツリー、つまりサイズが0のとき、単位元`e`を返します。

**計算量**

- `O(1)`

### max_right(l, &f) -> Integer

```ruby
seg.max_right(l, &f)
```

Segtree上で`l <= r <= n`の範囲で、`f(prod(l, r))`の結果を二分探索をして条件に当てはまる`r`を返します。

以下の条件を両方満たす `r` (`l <= r <= n`)を(いずれか一つ)返します。

- `r = l` もしくは `f(prod(l, r))`が`true`となる`r`
- `r = n` もしくは `f(prod(l, r + 1))`が`false`となる`r`

`prod(l, r)`は半開区間`[l, r)`であることに注意。

**制約**

- `f`を同じ引数で呼んだとき、返り値は同じ。
- `f(e)`が`true`
- `0 ≦ l ≦ n`

**計算量** 

- `O(log n)`

### min_left(r, &f) -> Integer

```ruby
seg.min_left(r, &f)
```

Segtree上で`0 <= l <= r`の範囲で、`f(prod(l, r))`の結果を二分探索をして条件に当てはまる`l`を返します。

以下の条件を両方満たす `l` (`0 <= l <= r`)を(いずれか一つ)返します。

- `l = r` もしくは `f(prod(l, r))`が`true`となる`l`
- `l = 0` もしくは `f(prod(l - 1, r))`が`false`となる`l`

`prod(l, r)`は半開区間`[l, r)`であることに注意。

**制約**

- `f`を同じ引数で呼んだとき、返り値は同じ。
- `f(e)`が`true`
- `0 ≦ l ≦ n`

**計算量**

- `O(log n)`

## Verified

- [ALPC: J - Segment Tree](https://atcoder.jp/contests/practice2/tasks/practice2_j)
  - [AC Code(884ms) max_right](https://atcoder.jp/contests/practice2/submissions/23196480)
  - [AC Code(914ms) min_left](https://atcoder.jp/contests/practice2/submissions/23197311)

- [ABC185: F - Range Xor Query](https://atcoder.jp/contests/abc185/tasks/abc185_f)
  - xorのセグメントツリーの基本的な典型問題です。FenwickTree(BIT)をxorに改造するだけでも解けます。
  - [ACコード(1538ms)](https://atcoder.jp/contests/abc185/submissions/18746817): 通常のSegtree解。
  - [ACコード(821ms)](https://atcoder.jp/contests/abc185/submissions/18769200): FenwickTree(BIT)のxor改造版。

## 参考リンク

- 当ライブラリ
  - [当ライブラリの実装コード segtree.rb](https://github.com/universato/ac-library-rb/blob/main/lib/segtree.rb)
  - [当ライブラリのテストコード segtree.rb](https://github.com/universato/ac-library-rb/blob/main/test/segtree_test.rb)
    - テストコードも具体的な使い方として役に立つかもしれまん。
- 本家ライブラリ
  - [本家ライブラリのドキュメント segtree.md(GitHub)](https://github.com/atcoder/ac-library/blob/master/document_ja/segtree.md)
  - [本家のドキュメント appendix.md(GitHub)](https://github.com/atcoder/ac-library/blob/master/document_ja/appendix.md)
  - [本家ライブラリの実装コード segtree.hpp(GitHub)](https://github.com/atcoder/ac-library/blob/master/atcoder/segtree.hpp)
  - [本家ライブラリのテストコード segtree_test.cpp(GitHub)](https://github.com/atcoder/ac-library/blob/master/test/unittest/segtree_test.cpp)
  - [本家ライブラリのサンプルコード segtree_practice.cpp(GitHub)](https://github.com/atcoder/ac-library/blob/master/test/example/segtree_practice.cpp)
- セグメントツリーについて
  - [2017/3 hogecoder: セグメント木をソラで書きたいあなたに](https://tsutaj.hatenablog.com/entry/2017/03/29/204841)
  - [2017/7 はまやんはまやんはまやん: 競技プログラミングにおけるセグメントツリー問題まとめ](https://blog.hamayanhamayan.com/entry/2017/07/08/173120)
  - [2017/12 ei1333の日記: ちょっと変わったセグメント木の使い方](https://ei1333.hateblo.jp/entry/2017/12/14/000000)  
    スライドが二分探索について詳しい
  - [2020/2 ageprocpp@Qiita: Segment Treeことはじめ【前編](https://qiita.com/ageprocpp/items/f22040a57ad25d04d199)

## 本家ライブラリとの違い等

基本的に、本家の実装に合わせています。

内部実装に関しても、変数`@d`の0番目の要素には必ず単位元`@e`が入ります。

### 変数名の違い

Rubyには`p`メソッドがあるので、引数`p`について、`p`ではなくpositionの`pos`を変数名として使いました。

同様に、本家の変数`size`を、わかりやすさから`leaf_size`としています。

### `ceil_pow2`ではなく、`bit_length`

本家C++ライブラリは独自定義の`internal::ceil_pow2`関数を用いてますが、本ライブラリではRuby既存のメソッド`Integer#bit_length`を用いています。そちらの方が計測した結果、高速でした。
