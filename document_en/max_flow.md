# MaxFlow

Library for solving [Maximum flow problem](https://en.wikipedia.org/wiki/Maximum_flow_problem).


## Class Methods

### new(n) -> MaxFlow

```ruby
graph = Maxflow.new(10)
```

It creates a graph of `n` vertices and `0` edges.

**Complexity**

- `O(n)`

## Instance Methods

### add_edge(from, to, cap) -> Integer

```ruby
graph.add_edge(0, 1, 5)
```

It adds an edge oriented from the vertex `from` to the vertex `to` with the capacity cap and the flow amount `0`.

It returns an integer `k` such that this is the `k`-th edge that is added.

**Complexity**

- `O(1)` amortized




### flow(start, to, flow_limit = 1 << 64) -> Integer

```ruby
(1) graph.flow(0, 3)
(2) graph.flow(0, 3, flow_limit)
```

- It augments the flow from `s` to `t` as much as possible. It returns the amount of the flow augmented.

**Aliases**

- `max_flow`
- `flow`

**Constraints**

- `start ≠ to`

### min_cut(start) -> Array(boolean)

```ruby
graph.min_cut(start)
```

The return value is an array of length `n`.

The `i`-th element of the return value is filled with `true` if the vertex `start` to `i` is reachable by the remainder graph, otherwise it is filled with `false`.

**Complexity**

- `O(n + m)`, where `m` is the number of added edges.

### get_edge(i) -> [from, to, cap, flow].

```ruby
graph.get_edge(i)
graph.edge(i)
graph[i].
```

- It returns the current internal state of the `i`-th edge.
- The edges are ordered in the same order as added by `add_edge`.

**Complexity**

- `O(1)`.

**Aliases**

- `get_edge`
- `edge`
- `[]`

### edges -> Array([from, to, cap, flow])

```ruby
graph.edges
```

- It returns the current internal state of the all edges.
- The edges are ordered in the same order as added by `add_edge`.

**Complexity**

- `O(m)`, where `m` is the number of added edges.

#### Notes on the `edges` method

The `edges` method is `O(m)` because it generates information for all edges.

Because of the generation cost, consider using `get_edge(i)` or storing it in a separate variable once, `edges = graph.edges`.

### change_edge(i, new_cap, new_flow)

Change the capacity and flow rate of the `i`-th changed edge to `new_cap` and `new_flow`.

**Constraints**

- `0 ≤ new_fow ≤ new_cap`

**Complexity**

- `O(1)`

## Verified.

- [ALPC: D - Maxflow](https://atcoder.jp/contests/practice2/tasks/practice2_d)
  - [AC Code 211ms 2020/9/17](https://atcoder.jp/contests/practice2/submissions/16789801)
  - [ALPC: D \fnDroid Sans Fallback - Qiita](https://qiita.com/magurofly/items/bfaf6724418bfde86bd0)

## Reference links

- ac-library-rb
  - [Code max_flow.rb(GitHub)](https://github.com/universato/ac-library-rb/blob/main/lib/max_flow.rb)
  - [Test code: max_flow_test.rb(GitHub)](https://github.com/universato/ac-library-rb/blob/main/test/max_flow_test.rb)
- The original library AtCoder Library
  - Code of the original library
    - [Code: maxflow.hpp(GitHub)](https://github.com/atcoder/ac-library/blob/master/atcoder/maxflow.hpp)
    - [Test code: maxflow_test.cpp(GitHub)](https://github.com/atcoder/ac-library/blob/master/test/unittest/maxflow_test.cpp)
  - Main family documentation
    - [Documentat: maxflow.md(GitHub)](https://github.com/atcoder/ac-library/blob/master/document_en/maxflow.md)
    - [Documentat: maxflow.html](https://atcoder.github.io/ac-library/document_en/maxflow.html)
    - [Document: appendix.md(GitHub)](https://github.com/atcoder/ac-library/blob/master/document_en/appendix.md)

## Questions and Answers.

### Why does the `flow_limit` of the `flow` method default to `1 << 64`?

I don't remember, and there is no deeper meaning.
It looks like `Float::MAX` or `Float::INFINITY` might be OK, but won't it slow things down?

### Don't use Struct for edges.

Using Struct makes the code slimmer, more advanced, and better looking.

However, as a result of measurements, Struc is slow, so we use arrays.

### What is the purpose of a variable that starts with `_`?

It's a bit confusing, but there are two separate intentions: 1.

1. `_e` and `_re` are matching variable names to make them easier to read with the original ACL code. 2.
2. `_rev` is spit out but not used for the convenience of running `each`, so it starts with `_` with the intention of "not using".

````ruby
@g[q].each do |(to, _rev, cap)|
````
