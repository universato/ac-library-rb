# LazySegtree

This is a lazy evaluation segment tree.

## Class Methods

### new(v, e, id, op, mapping, composition)

```ruby
seg = LazySegtree.new(v, e, id, op, mapping, compositon)
```

The first argument can be an `Integer` or an `Array`.

- If the first argument is an `Integer` of `n`, a segment tree of length `n` and initial value `e` will be created.
- If the first argument is `a` of `Array` with length `n`, a segment tree will be created based on `a`.

The second argument `e` is the unit source. We need to define the monoid by defining the binary operation `op(x, y)` in the block.

**Complexity**

- `O(n)`

## Instance methods

## set(pos, x)

```ruby
seg.set(pos, x)
```

Assign `x` to `a[pos]`.

**Complexity**

-  `O(logn)`

### get(pos) -> same class as unit source e

```ruby
seg.get(pos)
```

It returns `a[pos]`.

**Complexity**

- `O(1)`

### prod(l, r) -> same class as unit source e

```ruby
seg.prod(l, r)
```

It returns `op(a[l], ... , a[r - 1])`.

**Constraints**

- `0 ≤ l ≤ r ≤ n`.

**Complexity**

- `O(logn)`

### all_prod -> same class as unit source e

```ruby
seg.all_prod
```

It returns `op(a[0], ... , a[n - 1])`.

**Complexity**

- `O(1)`.

### apply(pos, val)

```ruby
seg.apply(pos, val)
```

The implementation with three arguments in the original code is called `range_apply` in this library. If it looks OK after measuring the execution time, we can make the `apply` method support both 2 and 3 arguments.

**Constraints**

- `0 ≤ pos < n`.

**Complexity**

- `O(log n)`.

### range_apply(l, r, val)

```ruby
seg.range_apply(l, r, val)
```

**Constraints**

- `0 ≤ l ≤ r ≤ n`.

**Complexity**

- `O(log n)`

### max_right(l){  } -> Integer

It applies binary search on the LazySegtree.

**Constraints**

- `0 ≦ l ≦ n`

**Complexity**

- `O(log n)`

### min_left(r){  } -> Integer

It applies binary search on the LazySegtree.

**Constraints**

- `0 ≦ r ≦ n`

**Complexity**

- `O(log n)`

## Verified

This is the link in question. There is no code, but it has been Verified.
- [AIZU ONLINE JUDGE DSL\_2\_F RMQ and RUQ](http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=DSL_2_F)
- [AIZU ONLINE JUDGE DSL\_2\_G RSQ and RAQ](http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=DSL_2_G)

The following problem is not AC in Ruby because the execution time is strictly TLE.
- [ALPC: K - Range Affine Range Sum](https://atcoder.jp/contests/practice2/tasks/practice2_k)
- [ALPC: L - Lazy Segment Tree](https://atcoder.jp/contests/practice2/tasks/practice2_l)

## Reference links

- ac-library-rb
  - [Code: lazy_segtree.rb](https://github.com/universato/ac-library-rb/blob/main/lib/lazy_segtree.rb)
  - [Test code: lazy_segtree_test.rb](https://github.com/universato/ac-library-rb/blob/main/test/lazy_segtree_test.rb)
- AtCoder Library
  - [Document: lazysegtree.md(GitHub)](https://github.com/atcoder/ac-library/blob/master/document_en/lazysegtree.md)
  - [Documentat: appendix.md(GitHub)](https://github.com/atcoder/ac-library/blob/master/document_en/appendix.md)
  - [Code: lazysegtree.hpp(GitHub)](https://github.com/atcoder/ac-library/blob/master/atcoder/lazysegtree.hpp)
  - [Test code: lazysegtree_test.cpp(GitHub)](https://github.com/atcoder/ac-library/blob/master/test/unittest/lazysegtree_test.cpp )

## Differences from the original library.

### Not `ceil_pow2`, but `bit_length`.

The original C++ library uses the original `internal::ceil_pow2` function, but this library uses the existing Ruby method `Integer#bit_length`. This library uses the existing Ruby method `Integer#bit_length`, which is faster than the original method.
