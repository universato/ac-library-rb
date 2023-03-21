# MinCostFlow

最小費用流問題を扱うライブラリです。

## 特異メソッド

### new(n) -> MinCostFlow

```ruby
graph = MinCostFlow.new(10)
```

n頂点0辺のグラフを作ります。

頂点の番号は、0-based indexです。

## インスタンスメソッド

### add_edge(from, to, cap, cost) -> Integer

```ruby
graph.add_edge(0, 1, 5)
```

頂点`from`から頂点`to`への最大容量`cap`, 流量`0`の辺を追加します。

返り値は、0-based indexで何番目に追加された辺かを返します。

### flow(start, to, flow_limit = Float::MAX) -> [flow, cost]

```ruby
(1) graph.flow(0, 3)
(2) graph.flow(0, 3, flow_limit)
```

内部はほぼ`slope`メソッドで、`slop`メソッドの返り値の最後の要素を取得しているだけ。制約・計算量は`slope`メソッドと同じ。

**エイリアス** `flow`, `min_cost_max_flow`

### slope(s, t,  flow_limit = Float::MAX) -> [[flow, cost]]

```ruby
graph.slop(0, 3)
```

**計算量** `O(F(n + m) log n)` ※ Fは流量、mは辺数

**エイリアス** `slope`, `min_cost_slope`

### get_edge(i) -> [from, to, cap, flow, cost]

```ruby
graph.get_edge(i)
graph.edge(i)
graph[i]
```

辺の状態を返します。

**制約** `0 ≦ i < m`

**計算量** `O(1)`

### edges -> Array([from, to, cap, flow, cost])

```ruby
graph.edges
```

全ての辺の情報を含む配列を返します。

**計算量** `O(m)` ※`m`は辺数です。

## Verified

[ALPC: E - MinCostFlow](https://atcoder.jp/contests/practice2/tasks/practice2_e)
- [1213ms 2020/9/17](https://atcoder.jp/contests/practice2/submissions/16792967)

## 参考リンク

- 当ライブラリ
  - [当ライブラリの実装コード min_cost_flow.rb](https://github.com/universato/ac-library-rb/blob/main/lib/min_cost_flow.rb)
  - [当ライブラリのテストコード min_cost_flow_test.rb](https://github.com/universato/ac-library-rb/blob/main/test/min_cost_flow_test.rb)
- 本家ライブラリ
  - [本家ライブラリのドキュメント mincostflow.md(GitHub)](https://github.com/atcoder/ac-library/blob/master/document_ja/mincostflow.md)
  - [本家ライブラリの実装コード mincostflow.hpp(GitHub)](https://github.com/atcoder/ac-library/blob/master/atcoder/mincostflow.hpp)
  - [本家ライブラリのテストコード mincostflow_test.cpp(GitHub)](https://github.com/atcoder/ac-library/blob/master/test/unittest/mincostflow_test.cpp)

## 備考

### エイリアスの意図は

本家ライブラリの最小費用流の方のメソッド名が長いので、エイリアスを持たせています。  
本家ライブラリの最大流の方のメソッド名は短いので、不思議です。

### `Float::INFINITY`ではなく、`Float::MAX`を使う意図とは

特に検証してないので、何の数値がいいのか検証したいです。

`Integer`クラスでも良いような気がしました。

### 辺にStructは使わないの

Structを使った方がコードがスリムになって上級者ぽくもあり見栄えは良いです。

しかし、計測した結果、Strucだと遅かったので使用していません。
