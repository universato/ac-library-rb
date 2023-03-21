# MinCostFlow

It solves [Minimum-cost flow problem](https://en.wikipedia.org/wiki/Minimum-cost_flow_problem).

## Class Methods

### new(n) -> MinCostFlow

```ruby
graph = MinCostFlow.new(10)
```

It creates a directed graph with `n` vertices and `0` edges.

Verticle order is the 0-based index.

**Constraints**

- `0 ≦ n`

**Complexity**

- `O(n)`


## Instance Methods

### add_edge(from, to, cap, cost) -> Integer

```ruby
graph.add_edge(0, 1, 5)
```

Adds an edge from vertex `from` to vertex `to` with maximum capacity `cap` and flow rate `0`.

The return value is the number of edge added with 0-based index.

### flow(start, to, flow_limit = Float::MAX) -> [flow, cost]
### min_cost_max_flow(start, to, flow_limit = Float::MAX) -> [flow, cost]

```ruby
(1) graph.flow(0, 3)
(2) graph.flow(0, 3, flow_limit)
```

The internals are mostly the `slope` method, just getting the last element of the return value of the `slop` method. The constraints and computational complexity are the same as for the `slope` method.

**Aliases**

- `flow`
- `min_cost_max_flow`

### slope(s, t, flow_limit = Float::MAX) -> [[flow, cost]]
### min_cost_slop(s, t, flow_limit = Float::MAX) -> [[flow, cost]]

```ruby
graph.slop(0, 3)
```

**Complexity**

- `O(F(n + m) log n)`, where `F` is the amount of the flow and `m` is the number of added edges.

**Aliases**

- `slope`
- `min_cost_slope`

### get_edge(i) -> [from, to, cap, flow, cost]
### edge(i) -> [from, to, cap, flow, cost]
### [](i) -> [from, to, cap, flow, cost]

```ruby
graph.get_edge(i)
graph.edge(i)
graph[i].
```

It returns the state of the `i`-th edge.

**Constraints**

- `0 ≤ i < m`.

**Complexity**

- `O(1)`

### edges -> Array[from, to, cap, flow, cost]

```ruby
graph.edges
```

It returns an array containing information on all edges.

**Complexity**

- `O(m)`, where mm is the number of added edges.

## Verified

- [ALPC: E- MinCostFlow](https://atcoder.jp/contests/practice2/tasks/practice2_e)
  - [1213ms 2020/9/17](https://atcoder.jp/contests/practice2/submissions/16792967)

## Reference links

- Our library: ac-library-rb
  - [Code: min_cost_flow.rb](https://github.com/universato/ac-library-rb/blob/main/lib/min_cost_flow.rb)
  - [Test code: min_cost_flow_test.rb](https://github.com/universato/ac-library-rb/blob/main/test/min_cost_flow_test.rb)
- The original library: AtCoder Library(ACL)
  - [Documentat: mincostflow.md(GitHub)](https://github.com/atcoder/ac-library/blob/master/document_ja/mincostflow.md)
  - [Code: mincostflow.hpp(GitHub)](https://github.com/atcoder/ac-library/blob/master/atcoder/mincostflow.hpp)
  - [Test code: mincostflow_test.cpp(GitHub)](https://github.com/atcoder/ac-library/blob/master/test/unittest/mincostflow_test.cpp )

## Questions and Answers

## The intent of the aliases is to

The method name of the minimum cost flow of the original library is long, so I have an alias for it. The method name of the maximum cost stream in the original library is short, so it is strange.

### What is the purpose of using `Float::MAX` instead of `Float::INFINITY`?

I haven't tested it specifically, so I'd like to verify what number is good.

I felt that the `Integer` class would be fine.

### Don't use Struct on the edges.

Using Struct makes the code slimmer and more advanced, and it looks better.

However, I didn't use Struct because it was too slow as a result of measurement.
