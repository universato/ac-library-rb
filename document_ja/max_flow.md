# MaxFlow

最大フロー問題を解くライブラリです。

## 特異メソッド

### new(n) -> MaxFlow

```ruby
graph = Maxflow.new(10)
```

n頂点0辺のグラフを作ります。

頂点の番号は、0-based indexです。

## インスタンスメソッド

### add_edge(from, to, cap) -> Integer

```ruby
graph.add_edge(0, 1, 5)
```

頂点`from`から頂点`to`への最大容量`cap`, 流量`0`の辺を追加します。

返り値は、0-based indexで何番目に追加された辺かを返します。

### flow(start, to, flow_limit = 1 << 64) -> Integer

```ruby
(1) graph.flow(0, 3)
(2) graph.flow(0, 3, flow_limit)
```

**エイリアス** `max_flow`, `flow`

### min_cut(start) -> Array(boolean)

```ruby
graph.min_cut(start)
```

返り値は、長さ`n`の配列。

返り値の`i`番目の要素には、頂点`start`から`i`へ残余グラフで到達可能なときに`true`が入り、そうでない場合に`false`が入る。

**計算量** `O(n + m)` ※ `m`は辺数

### get_edge(i) -> [from, to, cap, flow]

```ruby
graph.get_edge(i)
graph.edge(i)
graph[i]
```

辺の状態を返します。

**計算量** `O(1)`

**エイリアス** `get_edge`, `edge`, `[]`

### edges -> Array([from, to, cap, flow])

```ruby
graph.edges
```

全ての辺の情報を含む配列を返します。

**計算量** `O(m)` ※`m`は辺数です。

#### `edges`メソッドの注意点

`edges`メソッドは全ての辺の情報を生成するため、`O(m)`です。

生成コストがあるため、`get_edge(i)`を用いる方法や、`edges = graph.edges`と一度別の変数に格納する方法も考慮してください。

### change_edge(i, new_cap, new_flow)

`i`番目に変更された辺の容量、流量を`new_cap`, `new_flow`に変更します。

**制約** `0 ≦ new_fow ≦ new_cap`

**計算量** `O(1)`

## Verified

[ALPC: D - Maxflow](https://atcoder.jp/contests/practice2/tasks/practice2_d)
- [ACコード 211ms 2020/9/17](https://atcoder.jp/contests/practice2/submissions/16789801)
- [ALPC: D解説 - Qiita](https://qiita.com/magurofly/items/bfaf6724418bfde86bd0)

## 参考リンク

- 当ライブラリ
  - [当ライブラリの実装コード max_flow.rb(GitHub)](https://github.com/universato/ac-library-rb/blob/main/lib/max_flow.rb)
  - [当ライブラリのテストコード max_flow_test.rb(GitHub)](https://github.com/universato/ac-library-rb/blob/main/test/max_flow_test.rb)
- 本家ライブラリ
  - 本家のコード
    - [本家の実装コード maxflow.hpp(GitHub)](https://github.com/atcoder/ac-library/blob/master/atcoder/maxflow.hpp)
    - [本家のテストコード maxflow_test.cpp(GitHub)](https://github.com/atcoder/ac-library/blob/master/test/unittest/maxflow_test.cpp)
  - 本家ドキュメント
    - [本家のドキュメント maxflow.md(GitHub)](https://github.com/atcoder/ac-library/blob/master/document_ja/maxflow.md)
    - [本家のドキュメント appendix.md(GitHub)](https://github.com/atcoder/ac-library/blob/master/document_ja/appendix.md)

## Q&A

### `flow`メソッドの`flow_limit`のデフォルトは 何故`1 << 64`

意味はないです。
`Float::MAX`や`Float::INFINITY`でも良さそうですが、遅くならないでしょうか。

### 辺にStructは使わないの

Structを使った方がコードがスリムになって上級者ぽくもあり見栄えは良いです。

しかし、計測した結果、Strucだと遅いので、配列を使用しています。

### `_`始まりの変数の意図は

`_rev`は、`each`で回す都合上吐き出すけれど使わないので、「使わない」という意図で`_`始まりにしています。

```ruby
@g[q].each do |(to, _rev, cap)|
```
