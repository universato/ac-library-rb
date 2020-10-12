# LazySegtree

遅延評価セグメントツリーです。

この命名には批判があって、遅延伝播セグメントツリーの方が良いという意見も根強いです。

宗教戦争を避けるために、遅延セグ木と呼ぶのがいいかもしれません。

## 特異メソッド

### new(v, e, id, op, mapping, composition)

```ruby
seg = LazySegtree.new(v, e, id, op, mapping, compositon)
```

第1引数は、`Integer`または`Array`です。

- 第1引数が`Integer`の`n`のとき、長さ`n`・初期値`e`のセグメント木を作ります。
- 第1引数が長さ`n`の`Array`の`a`のとき、`a`をもとにセグメント木を作ります。

第2引数`e`は、単位元です。ブロックで二項演算`op(x, y)`を定義することで、モノイドを定義する必要があります。

**計算量** `O(n)`

## インスタンスメソッド

### set(pos, x)

```ruby
seg.set(pos, x)
```

`a[pos]`に`x`を代入します。

**計算量** `O(logn)`


### get(pos)  -> 単位元eと同じクラス

```ruby
seg.get(pos)
```

`a[pos]`を返します。

**計算量** `O(1)`


### prod(l, r) -> 単位元eと同じクラス

```ruby
seg.prod(l, r)
```

`op(a[l], ..., a[r - 1])` を返します。

**制約** `0 ≦ l ≦ r ≦ n`

**計算量** `O(logn)`

### all_prod -> 単位元eと同じクラス

```ruby
seg.all_prod
```

`op(a[0], ..., a[n - 1])` を返します。

**計算量** `O(1)`

### apply(pos, val)

```ruby
seg.apply(pos, val)
```

本家コードで引数が3つのとき実装について、当ライブラリでは`range_apply`という名称で実装しています。実行時間を計測して問題なさそうなら、`apply`メソッドに2引数と3引数の両方に対応できるようにします。

**制約** `0 ≦ pos < n`

**計算量** `O(log n)`

### range_apply(l, r, val)

```ruby
seg.range_apply(l, r, val)
```

**制約** `0 ≦ l ≦ r ≦ n`

**計算量** `O(log n)`

### max_right

[TODO] 暇な誰かが書く。

### min_left

[TODO] コード側の実装ができていないです。

## Verified

問題のリンクです。コードはないですが、Verified済みです。
[AIZU ONLINE JUDGE DSL\_2\_F RMQ and RUQ](http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=DSL_2_F)
[AIZU ONLINE JUDGE DSL\_2\_G RSQ and RAQ](http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=DSL_2_G)

以下の問題は、Rubyでは実行時間が厳しくTLEになりACできてないです。
[ALPC: K \- Range Affine Range Sum](https://atcoder.jp/contests/practice2/tasks/practice2_k)
[ALPC: L \- Lazy Segment Tree](https://atcoder.jp/contests/practice2/tasks/practice2_l)

## 参考リンク

- [当ライブラリの実装コード lazy_segtree.rb](https://github.com/universato/ac-library-rb/blob/master/lib/lazy_segtree.rb)
- 本家
  - [本家ライブラリのドキュメント lazysegtree.md(GitHub)](https://github.com/atcoder/ac-library/blob/master/document_ja/lazysegtree.md)
  - [本家のドキュメント appendix.md(GitHub)](https://github.com/atcoder/ac-library/blob/master/document_ja/appendix.md)
  - [本家ライブラリの実装コード lazysegtree.hpp(GitHub)](https://github.com/atcoder/ac-library/blob/master/atcoder/lazysegtree.hpp)
  - [本家ライブラリのテストコード lazysegtree_test.hpp(GitHub)](https://github.com/atcoder/ac-library/blob/master/test/unittest/lazysegtree_test.cpp)
- セグメントツリーについて
  - [セグメント木をソラで書きたいあなたに \- hogecoder](https://tsutaj.hatenablog.com/entry/2017/03/29/204841)
  - [遅延評価セグメント木をソラで書きたいあなたに \- hogecoder](https://tsutaj.hatenablog.com/entry/2017/03/30/224339)
- AtCooderLibrary(ACL)のLazySegtreeについて
  - [使い方 \- ARMERIA 2020/9/22](https://betrue12.hateblo.jp/entry/2020/09/22/194541)
  - [チートシート \- ARMERIA 2020/9/23](https://betrue12.hateblo.jp/entry/2020/09/23/005940)
  - [ACLPC: K–Range Affine Range Sumの解説 \|optのブログ 2020/9/27](https://opt-cp.com/cp/lazysegtree-aclpc-k/)
  - [ACL 基礎実装例集 \- buyoh\.hateblo\.jp 2020/9/27](https://buyoh.hateblo.jp/entry/2020/09/27/190144)

## 本家ライブラリとの違い

### `ceil_pow2`ではなく、`bit_length`

本家C++ライブラリは独自定義の`internal::ceil_pow2`関数を用いてますが、本ライブラリではRuby既存のメソッド`Integer#bit_length`を用いています。そちらの方が計測した結果、高速でした。
