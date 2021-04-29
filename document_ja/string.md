# String

文字列`s`の`a`番目から`b-1`番目の要素の`substring`を、`s[a..b)`と表記します。

## suffix_array

```ruby
(1) suffix_array(s)
(2) suffix_array(a)
(3) suffix_array(a, upper)
```

長さ`n`の文字列`s`に対し、Suffix Arrayとして長さ`n`の`Integer`の配列を返します。

Suffix Array `sa`は`0 ... n`の順列であって、各`i`について`s[sa[i]..n) < s[sa[i+1]..n)`を満たします。

このSuffix Arrayの概念は一般の列にも適用でき、`<=>`演算子で比較可能な要素の配列`a`に対しても動作します。

1. `suffix_array(s)`

内部で`s.bytes`によってバイト列に変換します。

**制約**

- `s`は文字コード255以下の文字のみからなる文字列

**計算量**

`O(|s|)`

2. `suffix_array(a)`

内部で、いわゆる座標圧縮を行います。要素は大小関係を保ったまま非負整数に変換されます。

**制約**

- `a`の要素は互いに`<=>`演算子で比較可能

**計算量**

要素の比較が定数時間で行えるとして、`O(|a| log |a|)`

3. `suffix_array(a, upper)`

**制約**

- `a`は`Integer`の配列

- `a`の全ての要素`x`について`0≦x≦upper`

**計算量**

`O(|a| + upper)`

## lcp_array

```ruby
lcp_array(s, sa)
```

長さ`n`の文字列`s`のLCP Arrayとして、長さ`n-1`の`Integer`の配列を返します。`i`番目の要素は`s[sa[i]..n)`と`s[sa[i+1]..n)`のLCP ( Longest Common Prefix ) の長さです。

こちらも`suffix_array`と同様一般の列に対して動作します。

**制約**

- `sa`は`s`のSuffix Array

- (`s`が文字列の場合) `s`は文字コード255以下の文字のみからなる

**計算量**

`O(|s|)`

## z_algorithm

```ruby
z_algorithm(s)
```

入力された配列の長さを`n`として、長さ`n`の`Integer`の配列を返します。`i`番目の要素は`s[0..n)`と`s[i..n)`のLCP ( Longest Common Prefix ) の長さです。

**制約**

- `s`の要素は互いに`==`演算子で比較可能

**計算量**

`O(|s|)`

<hr>

## Verified

- suffix_array, lcp_array
  - [I - Number of Substrings](https://atcoder.jp/contests/practice2/tasks/practice2_i)
    - [AC 1362 ms](https://atcoder.jp/contests/practice2/submissions/17194669)

- z_algorithm
  - [ABC135 F - Strings of Eternity](https://atcoder.jp/contests/abc135/tasks/abc135_f)
    - [AC 1076 ms](https://atcoder.jp/contests/abc135/submissions/16656965)

## 参考

- [本家ACLのドキュメント String](https://atcoder.github.io/ac-library/master/document_ja/string.html)
