# DSU - Disjoint Set Union

**alias: Union Find**

Given an undirected graph, it processes the following queries in `O(α(n))` time (amortized).

- Edge addition
- Deciding whether given two vertices are in the same connected component

Each connected component internally has a representative vertex.

When two connected components are merged by edge addition, one of the two representatives of these connected components becomes the representative of the new connected component.

## Usage

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

## Class Method

### new(n) -> DSU

```rb
d = DSU.new(n)
```

It creates an undirected graph with `n` vertices and `0` edges.

**complexity**

- `O(n)`

**alias**

- `DSU`, `UnionFind`

## Instance Methods

### merge(a, b) -> Integer

```rb
d.merge(a, b)
```

It adds an edge $(a, b)$.

If the vertices $a$ and $b$ were in the same connected component, it returns the representative of this connected component. Otherwise, it returns the representative of the new connected component.

**complexity**

- `O(α(n))`  amortized

**alias**

- `merge`, `unite`

### same?(a, b) -> bool

```rb
d.same?(a, b)
```

It returns whether the vertices `a` and `b` are in the same connected component.

**complexity**

- `O(α(n))`  amortized

**alias**

- `same?`, `same`

### leader(a) -> Integer

```rb
d.leader(a)
```

It returns the representative of the connected component that contains the vertex `a`.

**complexity**

- `O(α(n))`  amortized

**alias**

- `leader`, `root`, `find`

### size(a) -> Integer

It returns the size of the connected component that contains the vertex `a`.

**complexity**

- `O(α(n))`  amortized

### groups -> Array(Array(Integer))

```rb
d.groups
```

It divides the graph into connected components and returns the list of them.

More precisely, it returns the list of the "list of the vertices in a connected component". Both of the orders of the connected components and the vertices are undefined.


**complexity**

- `O(α(n))`  amortized

## Verified

[A - Disjoint Set Union](https://atcoder.jp/contests/practice2/tasks/practice2_a)

## Links & Reference

- ac-library-rb
  - [Code dsu.rb](https://github.com/universato/ac-library-rb/blob/main/lib/dsu.rb)
  - [Test dsu_test.rb](https://github.com/universato/ac-library-rb/blob/main/test/dsu_test.rb)
- AtCoder Library
  - [Document](https://github.com/atcoder/ac-library/blob/master/document_en/dsu.md)
  - [Code dsu.hpp](https://github.com/atcoder/ac-library/blob/master/atcoder/dsu.hpp)
