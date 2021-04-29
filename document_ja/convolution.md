# Convolution

畳み込みを行います。長さ`N`の`Integer`の配列`a[0],a[1],...,a[N-1]`と長さ`M`の`Integer`の配列`b[0],b[1],...,b[M-1]`から畳み込みを計算し、長さ`N+M-1`の`Integer`の配列`c`として返します。

## convolution

```ruby
(1) conv = Convolution.new(m = 998244353)
(2) conv = Convolution.new(m, primitive_root)
```

畳み込みを`mod m`で計算するためのオブジェクトを作成します。

`primitive_root`は法`m`に対する原始根である必要があります。与えられなかった場合は、内部で最小の原始根を計算します。

**制約**

- `2≦m`

- `m`は素数

- ((2)のみ) `primitive_root`は法`m`に対する原始根

**計算量**

1. `O(sqrt m)`

2. `O(log m)`

### 使用方法

実際の計算は、上で作成したオブジェクト`conv`を用いて次のように行います。

```ruby
c = conv.convolution(a, b)
```

`a`と`b`の少なくとも一方が空配列の場合は空配列を返します。

**制約**

- `2^c|(m-1)`かつ`|a|+|b|-1<=2^c`なる`c`が存在する

**計算量**

- `O((|a|+|b|) log (|a|+|b|))`

## convolution_ll

`convolution`の`m`として十分大きな素数を用いることで対応できます。

`1e15`を超える`NTT-Friendly`な素数の1例として、`1125900443713537 = 2^29×2097153+1`があります。

# Verified

- [C - 高速フーリエ変換](https://atcoder.jp/contests/atc001/tasks/fft_c)
  - `m = 1012924417`
    [1272ms](https://atcoder.jp/contests/atc001/submissions/17193829)
  - `m = 1125900443713537`
    [2448 ms](https://atcoder.jp/contests/atc001/submissions/17193739)

# 参考

- [本家 ACL のドキュメント Convolution](https://atcoder.github.io/ac-library/master/document_ja/convolution.html)
