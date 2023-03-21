# PriorityQueue

優先度付きキューです。
デフォルトでは降順で要素を保持します。

**エイリアス** `HeapQueue`

## 特異メソッド

### new(array = []) -> PriorityQueue

```ruby
PriorityQueue.new
pq = PriorityQueue.new([1, -1, 100])
pq.pop # => 100
pq.pop # => 1
pq.pop # => -1
```

引数に与えた配列から優先度付きキューを構築します。

**計算量** `O(n)` (`n` は配列の要素数)

### new(array = []) {|x, y| ... } -> PriorityQueue

```ruby
PriorityQueue.new([1, -1, 100]) {|x, y| x < y }
pq.pop # => -1
pq.pop # => 1
pq.pop # => 100
```

引数に与えた配列から優先度付きキューを構築します。
ブロックで比較関数を渡すことができます。比較関数が渡されると、それを使って要素の優先度が計算されます。

比較関数で比較できるなら、任意のオブジェクトをキューの要素にできます。

**計算量** `O(n)` (`n` は配列の要素数)

## インスタンスメソッド

### push(item)

```ruby
pq.push(10)
```

要素を追加します。

**エイリアス** `<<`, `append`

**計算量** `O(log n)` (`n` はキューの要素数)

### pop -> 最も優先度の高い要素 | nil

```ruby
pq.pop # => 100
```

最も優先度の高い要素をキューから取り除き、それを返します。キューが空のときは `nil` を返します。

**計算量** `O(log n)` (`n` はキューの要素数)

### get -> 最も優先度の高い要素 | nil

```ruby
pq.get # => 10
```

最も優先度の高い要素を**取り除くことなく**、その値を返します。

キューが空のときは `nil` を返します。

**エイリアス** `top`

**計算量** `O(1)`

### empty? -> bool

```ruby
pq.empty? # => false
```

キューの中身が空なら `true`、そうでないなら `false` を返します。

**計算量** `O(1)`

### heap -> Array(キューの要素)

```ruby
pq.heap
```

キューが内部で持っている二分ヒープを返します。

## Verified

- [Aizu Online Judge ALDS1_9_C Priority Queue](https://onlinejudge.u-aizu.ac.jp/problems/ALDS1_9_C)
  - [code](https://onlinejudge.u-aizu.ac.jp/solutions/problem/ALDS1_9_C/review/4835681/qsako6/Ruby)

## 参考

- [cpython/heapq.py at main - python/cpython](https://github.com/python/cpython/blob/main/Lib/heapq.py)
