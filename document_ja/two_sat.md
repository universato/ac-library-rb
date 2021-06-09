# 2-SAT

2-SAT を解きます。変数 x_0, x_1, ..., x_N-1 に関して、

(x_i = f) ∨ (x_j = g)

というクローズを足し、これをすべて満たす変数の割当があるかを解きます。

**エイリアス**

- `TwoSAT`
- `TwoSat`

<hr>

## 特異メソッド

### new(n) -> TwoSAT

```ruby
ts = TwoSAT.new(n)
```

n 変数の 2-SAT を作ります。

**計算量**

- `O(n)`

<hr>

## インスタンスメソッド

### add_clause(i, f, j, g) -> nil

`i: Integer`, `f: bool`, `j: Integer`, `g: bool`

```ruby
ts.add_clause(i, true, j, false)
```

(x_i = f) ∨ (x_j = g)　というクローズを足します。

**計算量**

- ならし `O(1)`

### satisfiable? -> bool

```ruby
ts.satisfiable?
```

条件を満たす割当が存在するかどうかを判定します。割当が存在するならば `true`、そうでないなら `false` を返します。

**エイリアス**

- `satisfiable?`
- `satisfiable`

**計算量**

- 足した制約の個数を `m` として `O(n + m)`

### answer -> Array[bool]

```ruby
ts.answer
```

最後に呼んだ `satisfiable?` のクローズを満たす割当を返します。
`satisfiable?` を呼ぶ前や、`satisfiable?` で割当が存在しなかったときにこの関数を呼ぶと、長さ n の意味のない配列を返します。

**計算量**

- `O(n)`

<hr>

## Verified

- [H - Two SAT](https://atcoder.jp/contests/practice2/tasks/practice2_h)
  - [163 ms](https://atcoder.jp/contests/practice2/submissions/16655036)

## 参考

[本家 ACL のドキュメント 2-SAT](https://atcoder.github.io/ac-library/master/document_ja/twosat.html)
