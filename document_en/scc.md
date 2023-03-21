# SCC

Strongly Connected Components

It calculates the strongly connected components of directed graph.

## Class Methods

### new(n) -> SCC

```ruby
graph = SCC.new(6)
```

It creates a directed graph of `n` vertices and `0` edges.

This `n` is 0-based index.

**Constraints** `0 ≦ n`

**Complexity** $O(n)$

## Instance Methods

### add_edge(from, to)

```ruby
graph.add_edge(1, 4)
```

It adds a directed edge from the vertex `from` to the vertex `to`.

**Constraints**  `0 ≦ from < n`, `0 ≦ to < n`

**Complexity** $O(n)$

### scc -> Array[Array[Integer]]

```ruby
graph.scc
```

It returns the array of the "array of the vertices" that satisfies the following.

- Each vertex is in exactly one "array of the vertices".
- Each "array of the vertices" corresponds to the vertex set of a strongly connected component. The order of the vertices in the list is undefined.
- The array of "array of the vertices" are sorted in topological order, i.e., for two vertices $u, v$ in different strongly connected components, if there is a directed path from $u$ to $v$, the list contains uu appears earlier than the list contains $v$.



**Complexity**  $O(n + m)$ , where $m$ is the number of added edges.

## Verified

- [ALPC: G - SCC](https://atcoder.jp/contests/practice2/tasks/practice2_g)  
  - [Ruby 2.7 1848ms 2022/11/22](https://atcoder.jp/contests/practice2/submissions/36708506)
- [typical90: 021 - Come Back in One Piece](https://atcoder.jp/contests/typical90/tasks/typical90_u)
  - [Ruby2.7 471ms 2021/6/15](https://atcoder.jp/contests/typical90/submissions/23487102)

# 参考リンク

- ac-library-rb
  - [scc.rb](https://github.com/universato/ac-library-rb/blob/main/lib/scc.rb)
  - [scc_test.rb](https://github.com/universato/ac-library-rb/blob/main/test/scc_test.rb)
- Original C++
  - [Original C++ code scc.hpp](https://github.com/atcoder/ac-library/blob/master/atcoder/scc.hpp)
  - [Original document scc.md](https://github.com/atcoder/ac-library/blob/master/document_en/scc.md)
