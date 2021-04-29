# Convolution

Performs convolution. An array of `Integer` of length `N`, `a[0],a[1],... ,a[N - 1]` and an array of `Integer` of length `M`, `b[0],b[1],... ,b[M - 1]`, and returns it as `c`, an array of `Integer` of length `N + M - 1`.

## convolution

``ruby
(1) conv = Convolution.new(m = 998244353)
(2) conv = Convolution.new(m, primitive_root)
``

It creates an object to compute the convolution with `mod m`.

The `primitive_root` must be a primitive root for the method `m`. If it is not given, the minimal primitive root is computed internally.

**constraints**.

- `2 ≤ m`.

- `m` is a prime number

- ((2) only) `primitive_root` is the primitive root for law `m`.

**computational complexity** 1.

1.`O(sqrt m)` 2.

2.`O(log m)`.

### Usage

The actual computation is done as follows, using the object `conv` created above.

```ruby
c = conv.convolution(a, b)
```

If at least one of `a` and `b` is an empty array, it returns an empty array.

**constraints**.

- There exists a `c` such that `2^c|(m-1)` and `|a|+|b|-1<=2^c`.

**computational complexity**.

- `O((|a|+|b|) log (|a|+|b|))`

## convolution_ll

This can be handled by using a sufficiently large prime number as `m` in `convolution`.

An example of an `NTT-Friendly` prime over `1e15` is `1125900443713537 = 2^29×2097153+1`.

# Verified

- [C - Fast Fourier Transform](https://atcoder.jp/contests/atc001/tasks/fft_c)
  - `m = 1012924417`
    [1272ms](https://atcoder.jp/contests/atc001/submissions/17193829)
  - `m = 1125900443713537`
    [2448 ms](https://atcoder.jp/contests/atc001/submissions/17193739)

# Reference.

- [Main ACL documentation Convolution](https://atcoder.github.io/ac-library/master/document_ja/convolution.html)


Translated with www.DeepL.com/Translator (free version)
