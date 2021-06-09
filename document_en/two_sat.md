# 2-SAT

It solves 2-SAT.

For variables x_0, x_1, ..., x_N-1 and clauses with form

(x_i = f) ∨ (x_j = g)

it decides whether there is a truth assignment that satisfies all clauses.


**Alias**

`TwoSAT`, `TwoSat`

<hr>

## Class Methods

### new(n) -> TwoSAT

```ruby
ts = TwoSAT.new(n)
```

It creates a 2-SAT of `n` variables and `0` clauses.

**Complexity**

O(n)

<hr>

## Instance Methods

### add_clause(i, f, j, g) -> nil

`i: Integer`, `f: bool`, `j: Integer`, `g: bool`

```ruby
ts.add_clause(i, true, j, false)
```

It adds a clause (x_i = f) ∨ (x_j = g).

**Constraints**

- `0 <= i < n`
- `0 <= j < n`

**Complexity**

- `O(1)` amortized

### satisfiable? -> bool

```ruby
ts.satisfiable?
```

If there is a truth assignment that satisfies all clauses, it returns `true`. Otherwise, it returns `false`.

**Alias**

`satisfiable?`, `satisfiable`

**Complexity**

`O(n + m)`, where `m` is the number of added clauses.

### answer -> Array(bool)

```ruby
ts.answer
```

It returns a truth assignment that `satisfie` all clauses of the last call of satisfiable. If we call it before calling `satisfiable` or when the last call of `satisfiable` returns `false`, it returns the vector of length `n` with undefined elements.

**Complexity**

- `O(n)`

## Verified

- [H - Two SAT](https://atcoder.jp/contests/practice2/tasks/practice2_h)
  - [163 ms](https://atcoder.jp/contests/practice2/submissions/16655036 )

## Links

- AtCoder Library(ACL)
  - [Documetn twosat.html](https://atcoder.github.io/ac-library/master/document_ja/twosat.html)
