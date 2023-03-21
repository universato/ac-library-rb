# SCC

Strongly Connected Components

有向グラフを強連結成分分解します。

## 特異メソッド

### new(n) -> SCC

```ruby
graph = SCC.new(6)
```

`n` 頂点 `0` 辺の有向グラフを作ります。

頂点番号は、0-based indexです。

**制約** `0 ≦ n`

**計算量** `O(n)`

## インスタンスメソッド

### add_edge(from, to)

```ruby
graph.add_edge(1, 4)
```

頂点 `from` から頂点 `to` へ有向辺を足します。

**制約** `0 ≦ from < n`, `0 ≦ to < n`

**計算量** `ならしO(1)`

### scc -> Array[Array[Integer]]

```ruby
graph.scc
```

強連結成分分解して、頂点のグループの配列を返します。

強連結成分分解は、お互いが行き来できる頂点を同じグループとなるように分解します。

また、グループの順番は、トポロジカルソートとなっており、頂点uから頂点vに一方的に到達できるとき、頂点uに属するグループは頂点vに属するグループよりも先頭に来ます。

**計算量** `O(n + m)` ※ `m` は辺数です。

## Verified

- [ALPC: G - SCC](https://atcoder.jp/contests/practice2/tasks/practice2_g)  
  - [Ruby2.7 1848ms 2022/11/22](https://atcoder.jp/contests/practice2/submissions/36708506)
- [競プロ典型 90 問: 021 - Come Back in One Piece](https://atcoder.jp/contests/typical90/tasks/typical90_u)
  - [Ruby2.7 471ms 2021/6/15](https://atcoder.jp/contests/typical90/submissions/23487102)

# 参考リンク

- 当ライブラリ
  - [当ライブラリの実装コード scc.rb](https://github.com/universato/ac-library-rb/blob/main/lib/scc.rb)
  - [当ライブラリの実装コード scc_test.rb](https://github.com/universato/ac-library-rb/blob/main/test/scc_test.rb)
- 本家ライブラリ
  - [本家ライブラリの実装コード scc.hpp](https://github.com/atcoder/ac-library/blob/master/atcoder/scc.hpp)
  - [本家ライブラリのドキュメント scc.md](https://github.com/atcoder/ac-library/blob/master/document_ja/scc.md)
- その他
  - [強連結成分分解の意味とアルゴリズム | 高校数学の美しい物語](https://mathtrain.jp/kyorenketsu)
