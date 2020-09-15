# DSU - Disjoint Set Union

無向グラフに対して、

- 辺の追加(2頂点の連結)
- 2頂点が連結かの判定(別の頂点を通して行き来できることを含みます)

をならしO(α(n))時間で高速に計算できます。


また、内部的に、各連結成分ごとに代表元(代表となる頂点)を1つ持っています。

辺の追加により連結成分がマージされるとき、元の連結成分の代表元のどちらかが新たな代表元になります。

## 使い方

```rb
d = DSU.new(5)
p d.groups      # => [[0], [1], [2], [3], [4]]
p d.same?(2, 3) # => false
p d.size(2)     # => 1

d.merge(2, 3)
p d.groups      # => [[0], [1], [2, 3], [4]]
p d.same?(2, 3) # => true
p d.size(2)     # => 2
```

## new(n = 0) -> DSU

```rb
d = DSU.new(n)
```

n頂点, 0辺の無向グラフを生成します。 

頂点の番号は0始まりで数え、n-1までになります。

計算量 O(n)

**エイリアス**

`DSU`, `DisjointSetUnion`, `UnionFind`, `UnionFindTree`

## merge(a, b) -> Integer

```rb
d.merge(a, b)
```

頂点aと頂点bを連結させます。
a, bが既に連結だった場合はその代表元、非連結だった場合は連結させたあとの新たな代表元を返します。

計算量 ならしO(α(n))

**エイリアス**

`merge`, `unite`, `union`

## same?(a, b) -> bool

### エイリアス

```rb
d.same?(a, b)
```

頂点aと頂点bが連結であるとき`true`を返し、そうでないときは`false`を返します。

計算量 ならしO(α(n))

**エイリアス**

`same?`, `same`

## leader(a) -> Integer

```rb
d.leader(a)
```

頂点aの属する連結成分の代表(根)の頂点を返します。

計算量 ならしO(α(n))

**エイリアス**

`leader`, `root`, `find`

## size(a) -> Integer

頂点aの属する連結成分の頂点数(サイズ)を返します。

計算量 ならしO(α(n))

## groups -> Array(Array(Integer))

```rb
d.groups
```

グラフを連結成分に分けて、その情報を返します。

返り値は2次元配列で、内側・外側ともに配列内の順番は未定義です。

計算量 O(n)

# 参考

[本家ACLのドキュメント dsu.md](https://github.com/atcoder/ac-library/blob/master/document_ja/dsu.md)

