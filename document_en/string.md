# String

The substring of the `a`-th to `b-1`-th element of the string `s` is written as `s[a..b)`.


## suffix_array

```ruby
(1) suffix_array(s)
(2) suffix_array(a)
(3) suffix_array(a, upper)
```
For a string `s` of length `n`, returns an array of `Integer` of length `n` as a Suffix Array.

Suffix Array `sa` is a permutation of `0 ... ... n`, and for each `i`, it is a permutation of `s[sa[i]. .n) < s[sa[i+1]. .n)` is satisfied.

This concept of Suffix Array can also be applied to general columns and works for `a`, an array of elements comparable with `<=>` operator. 1.

### 1. `suffix_array(s)`

Convert internally to a sequence of bytes by `s.bytes`.

**Constraints**

- `s` is a string consisting only of characters with character code 255 or less.

**Complexity**

- `O(|s|)`

### 2. `suffix_array(a)`

Inside, so-called coordinate compression is performed. Elements are converted to non-negative integers keeping their size relation.

**Constraints**

- The elements of `a` are comparable to each other with the `<=>` operator.

**Complexity**

- Assuming elements can be compared in constant time, `O(|a| log |a|)`

### 3. `suffix_array(a, upper)`

**Constraints**

- `a` is an array of `Integer`.

- For all elements `x` of `a`, `0 ≤ x ≤ upper`.

**Complexity**

- `O(|a| + upper)`

## lcp_array

```ruby
lcp_array(s, sa)
```

It returns an array of `Integer` of length `n-1` as an LCP Array of length `n` for strings `s`. The `i` th element is the length of LCP ( Longest Common Prefix ) for `s[sa[i]. .n)` and `s[sa[i+1]. .n)`.

This also works for general columns as well as `suffix_array`.

**Constraints**

- `sa` is a Suffix Array of `s`.

- If `s` is a string, `s` consists only of characters with character code 255 or less.

**Complexity**

- `O(|s|)`

## z_algorithm

```ruby
z_algorithm(s)
```

It returns an array of `Integer` of length `n`, where `n` is the length of the input array. The `i` th element is the length of LCP ( Longest Common Prefix ) of `s[0..n)` and `s[i..n)`.

**Constraints**

- The elements of `s` can be compared with each other with the `==` operator


**Complexity**

- `O(|s|)`

<hr>

## Verified

- suffix_array, lcp_array
  - [I - Number of Substrings](https://atcoder.jp/contests/practice2/tasks/practice2_i)
    - [AC 1362 ms](https://atcoder.jp/contests/practice2/submissions/17194669)
- z_algorithm
  - [ABC135 F - Strings of Eternity](https://atcoder.jp/contests/abc135/tasks/abc135_f)
    - [AC 1076 ms](https://atcoder.jp/contests/abc135/submissions/16656965)

## Links

- AtCoder Library
  - [Document String(HTML)](https://atcoder.github.io/ac-library/master/document_ja/string.html)
