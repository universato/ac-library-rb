# Segtree

Segment Tree

## Class Methods

### new(n, e){ |x, y| ... } -> Segtree
### new(n, op, e) -> Segtree

```rb
seg = Segtree.new(n, e) { |x, y| ... }
```

It creates an array `a` of length `n`. All the elements are initialized to `e`.

- `block`: returns `op(x, y)`
- `e`: identity element.


### new(ary, e){ |x, y| ... } -> Segtree
### new(ary, op, e) -> Segtree

```rb
seg = Segtree.new(ary, e) { |x, y| ... }
```

It creates an array `seg` of length `n` = `ary.size`, initialized to `ary`.

- `block`: returns `op(x, y)`
- `e`: identity element.

**complexty**

- `O(n)`

<details>
<summary>Monoid Exmaples</summary>

```rb
n   = 10**5
inf = (1 << 60) - 1

Segtree.new(n, 0) { |x, y| x.gcd y }       # gcd
Segtree.new(n, 1) { |x, y| x.lcm y }       # lcm
Segtree.new(n, -inf) { |x, y| [x, y].max } # max
Segtree.new(n,  inf) { |x, y| [x, y].min } # min
Segtree.new(n, 0) { |x, y| x | y }         # or
Segtree.new(n, 1) { |x, y| x * y }         # prod
Segtree.new(n, 0) { |x, y| x + y }         # sum
```

</details>

## Instance Methods

### set

```rb
seg.set(pos, x)
```

It assigns `x` to `a[pos]`.

**Complexity** `O(logn)`

### get

```rb
seg.get(pos)
```

It returns `a[pos]`

**Complexity** `O(1)`

### prod

```rb
seg.prod(l, r)
```

It returns `op(a[l], ..., a[r - 1])` .

**Constraints**

- `0 ≦ l ≦ r ≦ n`

**Complexity**

- `O(logn)`

### all_prod

```rb
seg.all_prod
```

It returns `op(a[0], ..., a[n - 1])`.

**Complexity**

- `O(1)`

### max_right(l, &f) -> Integer

```ruby
seg.max_right(l, &f)
```

It applies binary search on the segment tree.

It returns an index `r` that satisfies both of the following.

- `r = l` or `f(prod(l, r)) = true`
- `r = n` or `f(prod(l, r + 1)) = false`


**Constraints**

- `f(e) = true`
- `0 ≦ l ≦ n`

**Complexity**

- `O(log n)`

### min_left(r, &f) -> Integer

```ruby
seg.min_left(r, &f)
```

It applies binary search on the segment tree.   
It returns an index l that satisfies both of the following.

- `l = r` or `f(prod(l, r)) = true`
- `l = 0` or `f(prod(l - 1, r)) = false`

**Constraints**

- `f(e) = true`
- `0 ≦ r ≦ n`

**Complexity**

- `O(log n)`

## Verified

- [ALPC: J - Segment Tree](https://atcoder.jp/contests/practice2/tasks/practice2_j)
  - [AC Code(884ms) max_right](https://atcoder.jp/contests/practice2/submissions/23196480)
  - [AC Code(914ms) min_left](https://atcoder.jp/contests/practice2/submissions/23197311)
- [F - Range Xor Query](https://atcoder.jp/contests/abc185/tasks/abc185_f)
  - [AC Code(1538ms)](https://atcoder.jp/contests/abc185/submissions/18746817): Segtree(xor)
  - [AC Code(821ms)](https://atcoder.jp/contests/abc185/submissions/18769200): FenwickTree(BIT) xor

## 参考リンク

- ac-library
  - [Code segtree.rb](https://github.com/universato/ac-library-rb/blob/main/lib/segtree.rb)
  - [Test segtree_test.rb](https://github.com/universato/ac-library-rb/blob/main/test/segtree_test.rb)
- AtCoder Library
  - [Document HTML](https://atcoder.github.io/ac-library/document_en/segtree.html)
  - [Documetn appendix.md(GitHub)](https://github.com/atcoder/ac-library/blob/master/document_en/appendix.md)
  - [Code segtree.hpp(GitHub)](https://github.com/atcoder/ac-library/blob/master/atcoder/segtree.hpp)
  - [Test segtree_test.cpp(GitHub)](https://github.com/atcoder/ac-library/blob/master/test/unittest/segtree_test.cpp)
  - [Sample code segtree_practice.cpp(GitHub)](https://github.com/atcoder/ac-library/blob/master/test/example/segtree_practice.cpp)
