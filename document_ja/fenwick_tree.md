# Fenwick Tree

**別名** BIT(Binary Indexed Tree)

長さ`N` の配列に対し、

- 要素の`1`点変更
- 区間の要素の総和

を`O(logN)`で求めることが出来るデータ構造です。

## コンストラクタ

```rb
fw = FenwickTree.new(arg)
```

引数は`Integer`または`Array`です。

1. 引数が`Integer`クラスの`n`のとき、長さ`n`の全ての要素が`0`で初期化された配列を作ります。 
2. 引数が長さ`n`の`Array`クラスの配列`a`のとき、`a`で初期化された配列を作ります。


配列の添字は、0-based indexです。
 
**計算量** 引数が`Integer`オブジェクトのとき`O(n)`で、引数が`Array`オブジェクトのとき`O(n log(n))`です。

## add(pos, x)

```rb
fw.add(pos, x)
```

`a[pos] += x`を行います。

`pos`は、0-based indexです。

**計算量** `O(logn)`

## sum(l, r) ->Integer

```rb
fw.sum(l, r)
```

`a[l] + a[l - 1] + ... + a[r - 1]`を返します。

引数は、半開区間です。

実装として、内部で`_sum(r) - _sum(l)`を返しています。

**計算量** `O(logn)`

## _sum(pos) -> Integer

```rb
fw._sum(pos)
```

`a[0] + a[1] + ... + a[pos - 1]`を返します。

**計算量** `O(logn)`
