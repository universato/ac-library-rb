# Fenwick Tree

**alias: BIT (Binary Indexed Tree)**

Given an array of length `N`, it processes the following queries in `O(log N)` time.

- Updating an element
- Calculating the sum of the elements of an interval

## Class Method

### new(n) -> FenwickTree

```rb
fw = FenwickTree.new(5)
```

It creates an array `a_0, a_1, ...... a_{n-1}` of length `n`. All the elements are initialized to `0`.

**complexity**

- `O(n)`

### new(ary) -> FenwickTree

```rb
fw = FenwickTree.new([1, 3, 2])
```

It creates an array `ary`.

**complexity**

- `O(n)`

## add(pos, x)

```rb
fw.add(pos, x)
```

It processes `a[p] += x`.

`pos` is zero-based index.

**constraints**

- `0 ≦　pos < n`

**complexity**

- `O(log n)`

## sum(l, r) ->Integer

```rb
fw.sum(l, r)
```

It returns `a[l] + a[l + 1] + ... + a[r - 1]`.

It equals `fw._sum(r) - fw._sum(l)`

**constraints**

-  `0 ≦　l ≦ r ≦ n`

**complexity**

- `O(log n)`

## _sum(pos) -> Integer

```rb
fw._sum(pos)
```

It returns `a[0] + a[1] + ... + a[pos - 1]`.

**complexity**

- `O(logn)`

## Verified

- [AtCoder ALPC B - Fenwick Tree](https://atcoder.jp/contests/practice2/tasks/practice2_b)
  -  [AC Code(1272ms)](https://atcoder.jp/contests/practice2/submissions/17074108)
- [F - Range Xor Query](https://atcoder.jp/contests/abc185/tasks/abc185_f)
  - [AC Code(821ms)](https://atcoder.jp/contests/abc185/submissions/18769200)


## Link

- ac-library-rb
  - [Code dsu.rb](https://github.com/universato/ac-library-rb/blob/main/lib/dsu.rb)
  - [Test dsu_test.rb](https://github.com/universato/ac-library-rb/blob/main/test/dsu_test.rb)
- AtCoder
  - [fenwicktree.html](https://atcoder.github.io/ac-library/document_en/fenwicktree.html)
  - [Code fenwick.hpp](https://github.com/atcoder/ac-library/blob/master/atcoder/fenwick.hpp)
