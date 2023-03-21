# LazySegtree

遅延評価セグメントツリーです。

この命名には批判があって、遅延伝播セグメントツリーの方が良いという意見も根強いです。

宗教戦争を避けるために、遅延セグ木と呼ぶのがいいかもしれません。

## 特異メソッド

### new(v, e, id){  }

```ruby
seg = LazySegtree.new(v, e, id)
```

第1引数は、`Integer`または`Array`です。

- 第1引数が`Integer`の`n`のとき、長さ`n`・初期値`e`のセグメント木を作ります。
- 第1引数が長さ`n`の`Array`の`a`のとき、`a`をもとにセグメント木を作ります。

第2引数`e`は、単位元です。ブロックで二項演算`op(x, y)`を定義することで、モノイドを定義する必要があります。

また、インスタンス作成後に、`LazySegtree#set_mapping{ }`と`LazySegment#set_composition{ }`を用い、適切にインスタンス変数にprocを設定する必要があります。

**計算量** `O(n)`

### new(v, op, e, mapping, composition, id)
### new(v, e, id, op, mapping, composition)

```ruby
seg = LazySegtree.new(v, op, e, mapping, compositon, id)
seg = LazySegtree.new(v, e, id, op, mapping, compositon)
```

前者は、本家ライブラリに合わせた引数の順番。  
後者は、procを後ろにまとめた引数の順番で、これは非推奨。  
内部で、第2引数がprocかどうかで、場合分けしています。

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

`op(a[l], ..., a[r - 1])` を返します。引数は半開区間です。`l == r`のとき、単位元`e`を返します。

**制約** `0 ≦ l ≦ r ≦ n`

**計算量** `O(logn)`

### all_prod -> 単位元eと同じクラス

```ruby
seg.all_prod
```

`op(a[0], ..., a[n - 1])` を返します。サイズが0のときは、単位元`e`を返します。

**計算量** `O(1)`

### apply(pos, val)
### apply(s, r, val)

```ruby
seg.apply(pos, val)
seg.apply(l, r, val)
```

1. `a[p] = f(a[p])`
2. 半開区間`i = l..r`について`a[i] = f(a[i])`

**制約** 
1. `0 ≦ pos < n` 
2. `0 ≦ l ≦ r ≦ n`

**計算量** `O(log n)`

### range_apply(l, r, val)

```ruby
seg.range_apply(l, r, val)
```

3引数の`apply`を呼んだときに、内部で呼ばれるメソッド。  
直接、`range_apply`を呼ぶこともできる。

**制約** `0 ≦ l ≦ r ≦ n`

**計算量** `O(log n)`

### max_right(l){  } -> Integer

LazySegtree上で、二分探索をします。

**制約**  `0 ≦ l ≦ n`

**計算量** `O(log n)`

### min_left(r){  } -> Integer

LazySegtree上で、二分探索をします。

**制約**  `0 ≦ r ≦ n`

**計算量** `O(log n)`

## Verified

問題のリンクです。Verified済みです。解答はテストコードをご参考ください。
- [AIZU ONLINE JUDGE DSL\_2\_F RMQ and RUQ](https://onlinejudge.u-aizu.ac.jp/problems/DSL_2_F) ([旧DSL_2_F](http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=DSL_2_F))
- [AIZU ONLINE JUDGE DSL\_2\_G RSQ and RAQ](https://onlinejudge.u-aizu.ac.jp/problems/DSL_2_G) ([旧DSL_2_G](http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=DSL_2_G))
- [AIZU ONLINE JUDGE DSL\_2\_H RMQ and RAQ](https://onlinejudge.u-aizu.ac.jp/problems/DSL_2_H) ([旧DSL_2_H](http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=DSL_2_H))
- [AIZU ONLINE JUDGE DSL\_2\_I RSQ and RUQ](https://onlinejudge.u-aizu.ac.jp/problems/DSL_2_I) ([旧DSL_2_I](http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=DSL_2_I))

以下の問題は、Rubyでは実行時間が厳しくTLEになりACできてないです。
- [ALPC: K - Range Affine Range Sum](https://atcoder.jp/contests/practice2/tasks/practice2_k)
- [ALPC: L - Lazy Segment Tree](https://atcoder.jp/contests/practice2/tasks/practice2_l)

下記は、ジャッジにだしてないが、サンプルに正解。`max_right`, `min_left`を使う問題。
- [Quora Programming Challenge 2021: Skyscraper](https://jonathanirvin.gs/files/division2_3d16774b0423.pdf#page=5)

## 参考リンク

- 当ライブラリ
  - [当ライブラリの実装コード lazy_segtree.rb](https://github.com/universato/ac-library-rb/blob/main/lib/lazy_segtree.rb)
  - [当ライブラリのテストコード lazy_segtree_test.rb](https://github.com/universato/ac-library-rb/blob/main/test/lazy_segtree_test.rb)
- 本家ライブラリ
  - [本家ライブラリのドキュメント lazysegtree.md(GitHub)](https://github.com/atcoder/ac-library/blob/master/document_ja/lazysegtree.md)
  - [本家のドキュメント appendix.md(GitHub)](https://github.com/atcoder/ac-library/blob/master/document_ja/appendix.md)
  - [本家ライブラリの実装コード lazysegtree.hpp(GitHub)](https://github.com/atcoder/ac-library/blob/master/atcoder/lazysegtree.hpp)
  - [本家ライブラリのテストコード lazysegtree_test.cpp(GitHub)](https://github.com/atcoder/ac-library/blob/master/test/unittest/lazysegtree_test.cpp)
- セグメントツリーについて
  - [2017/3 hogecoder: セグメント木をソラで書きたいあなたに](https://tsutaj.hatenablog.com/entry/2017/03/29/204841)
  - [2017/3 hogecoder: 遅延評価セグメント木をソラで書きたいあなたに](https://tsutaj.hatenablog.com/entry/2017/03/30/224339)
  - [2017/7 はまやんはまやんはまやん: 競技プログラミングにおけるセグメントツリー問題まとめ](https://blog.hamayanhamayan.com/entry/2017/07/08/173120)
  - [2020/2 ageprocpp Qiita: Segment Treeことはじめ【後編】](https://qiita.com/ageprocpp/items/9ea58ac181d31cfdfe02)
- AtCooderLibrary(ACL)のLazySegtreeについて
  - [2020/9/22 ARMERIA: 使い方](https://betrue12.hateblo.jp/entry/2020/09/22/194541)
  - [2020/9/23 ARMERIA: チートシート](https://betrue12.hateblo.jp/entry/2020/09/23/005940)
  - [2020/9/27 optのブログ: ACLPC: K–Range Affine Range Sumの解説](https://opt-cp.com/cp/lazysegtree-aclpc-k/)
  - [2020/9/27 buyoh.hateblo.jp: ACL 基礎実装例集](https://buyoh.hateblo.jp/entry/2020/09/27/190144)

## 本家ライブラリとの違い

### `ceil_pow2`ではなく、`bit_length`

本家C++ライブラリは独自定義の`internal::ceil_pow2`関数を用いてますが、本ライブラリではRuby既存のメソッド`Integer#bit_length`を用いています。そちらの方が計測した結果、高速でした。

## 問題点

### ミュータブルな単位元

本家ACL同様に、初期化の際に配列でも数値でもいいとなっている。  
しかし、数値で要素数を指定した際に、ミュータブルなクラスでも同一オブジェクトで要素を作ってしまっている。
