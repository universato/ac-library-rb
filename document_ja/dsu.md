# DSU - Disjoint Set Union

別名: Union Find (むしろ、こちらが有名)

無向グラフに対して、

- 辺の追加(2頂点の連結)
- 2頂点が連結かの判定(別の頂点を通して行き来できることを含みます)

をならし`O(α(n))`時間で高速に計算できます。


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

## 特異メソッド

### new(n) -> DSU

```rb
d = DSU.new(n)
```

`n` 頂点, `0` 辺の無向グラフを生成します。

頂点の番号は `0` 始まりで数え、`n - 1` までになります。

**計算量**

- `O(n)`


**エイリアス**

- `DSU`
- `UnionFind`

## インスタンスメソッド

### merge(a, b) -> Integer

```rb
d.merge(a, b)
```

頂点 `a` と頂点 `b`を連結させます。
`a`, `b` が既に連結だった場合はその代表元、非連結だった場合は連結させたあとの新たな代表元を返します。

計算量 ならしO(α(n))

**エイリアス**

- `merge`
- `unite`

### same?(a, b) -> bool

```rb
d.same?(a, b)
```

頂点aと頂点bが連結であるとき `true` を返し、そうでないときは `false` を返します。

**計算量**

- ならし `O(α(n))`

**エイリアス**

- `same?`
- `same`

### leader(a) -> Integer

```rb
d.leader(a)
```

頂点 `a` の属する連結成分の代表(根)の頂点を返します。

**計算量**

- ならし `O(α(n))`

**エイリアス**

- `leader`
- `root`
- `find`

### size(a) -> Integer

```rb
d.size(3)
```

頂点 `a` の属する連結成分の頂点数(サイズ)を返します。

**計算量**

- ならし `O(α(n))`

### groups -> [[Integer]]

```rb
d.groups
```

グラフを連結成分に分けて、その情報を返します。

返り値は2次元配列で、内側・外側ともに配列内の順番は未定義です。

**計算量**

- `O(n)`

## Verified

- [A - Disjoint Set Union](https://atcoder.jp/contests/practice2/tasks/practice2_a)

## 参考リンク

- 当ライブラリ
  - [当ライブラリの実装コード dsu.rb](https://github.com/universato/ac-library-rb/blob/main/lib/dsu.rb)
  - [当ライブラリのテストコード dsu_test.rb](https://github.com/universato/ac-library-rb/blob/main/test/dsu_test.rb)
- 本家ライブラリ
  - [本家ACLのドキュメント dsu.md](https://github.com/atcoder/ac-library/blob/master/document_ja/dsu.md)
  - [本家ACLのコード dsu.hpp](https://github.com/atcoder/ac-library/blob/master/atcoder/dsu.hpp)

## その他

### DSUよりUnionFindの名称の方が一般的では?

UnionFindの方が一般的だと思いますが、本家ライブラリに合わせています。なお、`UnionFind`をクラスのエイリアスとしています。

https://twitter.com/3SAT_IS_IN_P/status/1310122929284210689 (2020/9/27)

Google Scholar によると
- "union find": 8,550件
- "union find data structure": 1,970件
- "disjoint set union": 1,610 件
- "disjoint set data structure": 1,030 件

### メソッドのエイリアスについて

本家ライブラリでは`same`ですが、真偽値を返すメソッドなのでRubyらしく`same?`をエイリアスとして持ちます。`same`はdeprecated(非推奨)ですので、`same?`を使って下さい。

本家は`merge`ですが、`unite`もエイリアスに持ちます。`unite`は`UnionFind`に合っているし、蟻本などでも一般的にもよく使われています。

本家は`leader`ですが、`UnionFind`に合っていて一般的であろう`find`や`root`もエイリアスとして持ちます。

### mergeの返り値について

本家ライブラリの実装に合わせて、`merge`メソッドは新たにマージしたか否かにかかわらず、代表元を返しています。

ただ、新たに結合した場合には代表元を返して、そうでない場合は`nil`か`false`を返すような`merge?`(あるいは`merge!`)を入れようという案があります。Rubyに, true/false以外を返す` nonzero?`などもあるので、`merge?`という名称は良いと思います。

### 実装の説明

本家ライブラリに合わせて、内部のデータを`@parent_or_size`というインスタンス変数名で持っています。これは、根(代表元)となる要素の場合は、その連結成分の要素数(サイズ)に-1を乗じた値を返し、それ以外の要素の場合に、その要素の属する連結成分の代表(根)の番号を返します。

なお、インスタンスが初期化され、まだどの頂点どうしも連結されていないときは、全ての頂点が自分自身を代表元とし、サイズ1の連結成分が頂点の数だけできます。そのため、初期化されたときは、内部の配列`@parent_or_size`は、要素が全て-1となります。

### 変更履歴

2020/10/25 [PR #64] メソッド`groups`(正確には内部で定義されている`groups_with_leader`)のバグを修正しました。
