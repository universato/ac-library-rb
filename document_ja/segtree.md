# Segtree

セグメント木です。

## コンストラクタ

```rb
seg = Segtree(arg, e) { |x, y| ... }
```

第1引数は、`Integer`または`Array`です。

- 第1引数が`Integer`の`n`のとき、長さ`n`・初期値`e`のセグメント木を作ります。
- 第1引数が長さ`n`の`Array`の`a`のとき、`a`をもとにセグメント木を作ります。

第2引数は単位元`e`で、ブロックで二項演算`op(x, y)`を定義することで、モノイドを定義する必要があります。

**計算量** `O(n)`

<details>
<summary>モノイドの設定コード例</summary>

```rb
n   = 10**5
inf = (1 << 60) - 1 

Segtree(n, 0) { |x, y| x.gcd y } # gcd
Segtree(n, 1) { |x, y| x.lcm y } # lcm
Segtree(n, -inf) { |x, y| [x, y].max } # max
Segtree(n,  inf) { |x, y| [x, y].min } # min
Segtree(n, 0) { |x, y| x | y } # or
Segtree(n, 1) { |x, y| x * y } # prod
Segtree(n, 0) { |x, y| x + y } # sum
```

</details>

## set

```rb
seg.set(pos, x)
```

`a[pos] に x`を代入します。

**計算量** `O(logn)`


## get

```rb
seg.get(pos)
```

`a[pos]`を返します。

**計算量** `O(1)`


## prod

```rb
seg.prod(l, r)
```

`op(a[l], ..., a[r - 1])` を返します。

**制約** `0 ≦ l ≦ r ≦ n`

**計算量** `O(logn)`

## all_prod

```rb
seg.all_prod
```

`op(a[0], ..., a[n - 1])` を返します。

**計算量** `O(1)`
