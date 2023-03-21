# ModInt

This is a library that can be used for problems where the answer is divided by a certain number and the remainder is output.

It automatically takes the remainder when calculating, thus reducing errors.

## Caution

The use of this library ModInt may slow down the execution time.

Please be careful when using it.

## Example usage

First, set the remainder law with `ModInt.set_mod` or `ModInt.mod =`.

```ruby
ModInt.set_mod(11)
ModInt.mod #=> 11

a = ModInt(10)
b = 3.to_m

p -b # 8 mod 11

p a + b # 2 mod 11
p 1 + a # 0 mod 11
p a - b # 7 mod 11
p b - a # 4 mod 11

p a * b # 8 mod 11
p b.inv # 4 mod 11

p a / b # 7 mod 11

a += b
p a # 2 mod 11
a -= b
p a # 10 mod 11
a *= b
p a # 8 mod 11
a /= b
p a # 10 mod 11

p ModInt(2)**4 # 5 mod 11

puts a #=> 10

p ModInt.raw(3) #=> 3 mod 11
```

## output with puts and p

```ruby
ModInt.mod = 11
a = 12.to_m

puts a #=> 1
p a #=> 1 mod 11
```

`ModInt` defines `to_s` and `inspect`.

This causes `puts` to use `to_s` and `p` to use `inspect` internally, so the output is modified.

Note that the `puts` method is useful because it behaves no differently than the output of `Integer`, but conversely, it is indistinguishable.

## Singular methods.

### new(val = 0) -> ModInt

```ruby
a = ModInt.new(10)
b = ModInt(3)
```

We have a syntax sugar `Kernel#ModInt` that does not use `new`.

#### [Reference] Integer#to_m, String#to_m

```ruby
5.to_m
'2'.to_m
```

Converts `Integer` and `String` instances to `ModInt`.

**aliases** `to_modint`, `to_m`.

### set_mod(mod)

```ruby
ModInt.set_mod(10**9 + 7)
ModInt.mod = 10**9 + 7
```

Use this method first to set the mod.

This is set to the global variable `$_mod` as an internal implementation.

It also internally checks whether `$_mod` is prime or not, and assigns a boolean value to the global variable `$_mod_is_prime`.

Note that you may not have many chances to use the return value of this method, but `mod=` returns the assigned argument as it is, while `set_mod` returns `[mod, mod.prime?]

**aliases** `set_mod`, `mod=`

### mod -> Integer

```ruby
ModInt.mod
```
Returns mod.

This returns the global variable `$_mod` as an internal implementation.

### raw(val) -> ModInt

Returns

 ````ruby
ModInt.raw(2, 11) # 2 mod 11
````

Returns ModInt instead of taking mod for `val`.

This is a constructor for constant-fold speedup.

If `val` is guaranteed to be greater than or equal to `0` and not exceed `mod`, it is faster to generate `ModInt` here.

## Instance Methods

### val -> Integer

```ruby
ModInt.mod = 11
m = 12.to_m # 1 mod 11
n = -1.to_m # 10 mod 11

p i = m.val #=> 1
p j = n.to_i #=> 10
```

Returns the value of the body from an instance of the ModInt class.

As an internal implementation, it returns `@val`.

Use it to convert to `integer`.

**Aliases**

- `val`
- `to_i`.

#### Additional information about aliases

There is no difference between `val` and `to_i` as an alias for the instance method of `ModInt`. However, the `Integer` class also has a `to_i` method, so `to_i` is more flexible and Ruby-like. In the internal implementation, `to_i` is used so that either argument can be used. Note that `val` is the name of the function in the original, and `@val` is the name of the instance variable in the internal implementation.

### inv -> ModInt

```rb
ModInt.mod = 11
m = 3.to_m

p m.inv #=> 4 mod 11
```

It returns `y` such that `xy ≡ 1 (mod ModInt.mod)`.

That is, it returns the modulus inverse.

### pow(other) -> ModInt

```ruby
ModInt.mod = 11
m = 2.to_m

p m**4 #=> 5 mod 11
p m.pow(4) #=> 5 mod 11
```

Only `integer` can be taken as argument.

### Various operations.

As with the `Integer` class, you can perform arithmetic operations between `ModInt` and `Integer`, or between `Integer` and `ModInt`.
See the usage examples for details.

```ruby
ModInt.mod = 11

p 5.to_m + 7.to_m #=> 1 mod 11
p 0 + -1.to_m #=> 10 mod 11
p -1.to_m + 0 #=> 10 mod 11

p 12.to_m == 23.to_m #=> true
p 12.to_m == 1 #=> true
```

#### [Note] How to compare Integer and ModInt

`Integer` and `ModInt` can be compared by `==`, `! =`, but some behaviors are different from the original ACL.

The `Integer` to be compared returns true or false in the range of [0, mod), but always returns `false` in other ranges. This library has a restriction in the range of [0, mod), but the original library does not, so it differs in this point.

## Verified

- [ABC156: D - Bouquet](https://atcoder.jp/contests/abc156/tasks/abc156_d) held on 2020/2/22
  - [AC Code 138ms 2020/10/5](https://atcoder.jp/contests/abc156/submissions/17205940)
- [ARC009: C - Takahashi, 24 years old](https://atcoder.jp/contests/arc009/tasks/arc009_3) held on 2012/10/20
  - [AC Code 1075ms 2020/10/5](https://atcoder.jp/contests/arc009/submissions/17206081)
  - [AC code 901ms 2020/10/5](https://atcoder.jp/contests/arc009/submissions/17208378)

## Speedup Tips.

The methods `+`, `-`, `*`, and `/` use the methods `add!`, `sub!`, `mul!`, and `div!` for the ones that are internally duplicated with `dup`, respectively. If you can destructively change the receiver's `ModInt`, this method may be faster on a constant-duple basis.

## Reference links

- This library
  - [The code of this library modint.rb(GitHub)](https://github.com/universato/ac-library-rb/blob/main/lib/modint.rb)
  - Our library [Our code modint_test.rb(GitHub)](https://github.com/universato/ac-library-rb/blob/main/lib/modint.rb)
- The original library
  - [Our implementation code modint.hpp(GitHub)](https://github.com/atcoder/ac-library/blob/master/atcoder/modint.hpp)
  - Test code of the main library [modint_test.cpp(GitHub)](https://github.com/atcoder/ac-library/blob/master/atcoder/modint.hpp)
  - Documentation of the original modint.md(GitHub)](https://github.com/atcoder/ac-library/blob/master/document_ja/modint.md)
- Ruby Reference Manual
  - [class Numeric \(Ruby 2\.7\.0 Reference Manual\)](https://docs.ruby-lang.org/ja/latest/class/Numeric.html)
- Others
  - [Why don't you try using the modint struct? \(C\cH000000)}Noshi91's Notes](https://noshi91.hatenablog.com/entry/2019/03/31/174006)(Mar 31, 2019)
  - [Implementing modint in Python - Qiita](https://qiita.com/wotsushi/items/c936838df992b706084c)(Apr 1, 2019)
  - [Documentation of the C# version of ModInt](https://github.com/key-moon/ac-library-cs/blob/main/document_ja/modint.md)


## Q&A.

### Why include it if it may slow down the execution time?

- Reproduction of the original library.
- Reproduction to the essential part of the code.
- To measure how slow it really is. As a benchmark.
- To increase the number of users, to check the demand, and to appeal for inclusion in Ruby itself.

### Advantages of ModInt

Ruby, unlike C/C++, has the following features.

- Definition of a negative number divided by a positive number that still returns a positive number
- Multiple length integers, no overflow (* If the number is too large, the calculation becomes slower)

Therefore, compared to C/C++, the advantages of using ModInt are diminished in some areas, but

- Improved readability
- There is no need to worry about forgetting to take ModInt.

The following are some of the advantages.

### The intention of using global variables is

We are using global variables `$_mod` and `$_mod_is_prime`.

Global variables are to be avoided, especially in practice.

Translated with www.DeepL.com/Translator (free version)
