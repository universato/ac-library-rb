# ModInt

答えをある数で割ったあまりを出力する問題で使えるライブラリです。

計算の際に自動であまりを取るため、ミスを減らすことができます。

## 注意

本ライブラリModIntの使用により、**実行時間が遅く**なる可能性があります。

使用にあたり注意してください。

## 使用例

```ruby
ModInt.set_mod(11)
ModInt.mod #=> 11

a = ModInt(10)
b = 3.to_m

p -b    # 8 mod 11

p a + b # 2 mod 11
p 1 + a # 0 mod 11
p a - b # 7 mod 11
p b - a # 4 mod 11

p a * b # 8 mod 11
p b.inv # 4 mod 11

p a / b #  7 mod 11

a += b 
p a #  2 mod 11
a -= b 
p a # 10 mod 11
a *= b 
p a #  8 mod 11
a /= b 
p a # 10 mod 11

p ModInt(2)**4 # 5 mod 11

puts a  #=> 10

p a.mod #=> 11

p ModInt.raw(3) #=> 3 mod 11
```

## putsとpによる出力

```ruby
ModInt.mod = 11
a = 12.to_m

puts a #=> 1
p a    #=> 1 mod 11
```

`ModInt`は、`to_s`, `inspect`を定義しています。

これにより、`puts`は`to_s`, `p`は`inspect`を内部で使っているため、出力が変更されています。

`puts`メソッドは、`Integer`の出力と変わらない振る舞いで便利ですが、逆にいえば見分けはつかないので注意して下さい。

## 特異メソッド

### new(val = 0, mod = nil) -> ModInt

```ruby
a = ModInt.new(10)
b = ModInt(3)
```

`new`を使わないシンタックスシュガー`Kernel#ModInt`を用意しています。

#### 【参考】Integer#to_m, String#to_m

```ruby
5.to_m
'2'.to_m
```

`Integer`、`String`インスタンスを`ModInt`に変換します。

**エイリアス** `to_modint`, `to_m`

### set_mod(mod)

```ruby
ModInt.set_mod(10**9 + 7)
ModInt.mod = 10**9 + 7
```
modを設定します。

これは、内部の実装として、クラス変数`@@mod`に設定しています。

modを複数使わない場合、最初に呼んでください。

また、内部では、`@@mod`が素数かどうかを判定しています。

なお、このメソッドの返り値を使う機会は少ないと思いますが、`mod=`の方は、代入した引数をそのまま返すのに対し、`set_mod`は`[mod, mod.prime?]`を返します。

**エイリアス** `set_mod`, `mod=`

### mod -> Integer

```ruby
ModInt.mod
```
modを返します。

これは、内部の実装として、クラス変数`@@mod`を返します。

### raw(val) -> ModInt

```ruby
ModInt.raw(2, 11) # 2 mod 11
```

`val`に対してmodを取らずに、ModIntを返します。

定数倍高速化のための、コンストラクタです。

`val`が`0`以上で`mod`を超えないことが保証される場合、こちらで`ModInt`を生成した方が高速です。

## インスタンスメソッド

### val -> Integer

```ruby
ModInt.mod = 11
m = 12.to_m #  1 mod 11
n = -1.to_m # 10 mod 11

p i = m.val  #=> 1
p j = n.to_i #=> 10
```

ModIntクラスのインスタンスから、本体の値を返します。

`integer`に変換するときに、使用してください。

**エイリアス** `val`, `to_i`

### inv -> ModInt

```ruby
ModInt.mod = 11
m = 3.to_m

p m.inv #=> 4 mod 11
```

`xy ≡ 1`なる`y`を返します。

つまり、モジュラ逆数を返します。

### pow -> ModInt

[TODO]`**`はあったけど、コードになかったので、作った方が良さそう。-> 雑に作ってテストも追加してPRした。

```rb
ModInt.mod = 11
m = 2.to_m

p m**4　#=> 5 mod 11
p m.pow(4)　#=> 5 mod 11
```
### 各種演算

`Integer`クラスと同じように四則演算などができます。
詳しくは、使用例のところを見てください。

```ruby
ModInt.mod = 11

p 5.to_m + 7.to_m #=> 1 mod 11
p 0 + -1.to_m     #=> 10 mod 11
p -1.to_m + 0     #=> 10 mod 11

p 12.to_m == 23.to_m #=> true
p 12.to_m == 1 #=> true
```

#### 【注意】IntegerとModIntの比較方法

`Integer`と`ModInt`は`==`, `!=`による比較ができますが、本家ACLと一部の挙動が異なっています。

比較する`Integer`は[0, mod)の範囲では真偽値を返しますが、それ以外の範囲の場合は必ず`false`を返します。本ライブラリは[0, mod)の範囲で制約がありますが、本家ライブラリは制約がないので、この点で異なります。

## Verified

[TODO]

## 参考リンク

- 当ライブラリ
  - [当ライブラリのコード modint.rb(GitHub)](https://github.com/universato/ac-library-rb/blob/master/src/modint.rb)
  - [当ライブラリのコード modint_test.rb(GitHub)](https://github.com/universato/ac-library-rb/blob/master/src/modint.rb)
- 本家ライブラリ
  - [本家の実装コード modint.hpp(GitHub)](https://github.com/atcoder/ac-library/blob/master/atcoder/modint.hpp)
  - [本家のテストコード modint_test.hpp(GitHub)](https://github.com/atcoder/ac-library/blob/master/atcoder/modint.hpp)
  - [本家のドキュメント modint.md(GitHub)](https://github.com/atcoder/ac-library/blob/master/document_ja/modint.md)
- その他
  - [C#版のModIntのドキュメント](https://github.com/key-moon/ac-library-cs/blob/master/document_ja/modint.md)

## privateメソッド(コード読みたい人向け)

### of_val(val)

引数が`Integer`以外ならエラーとし、`Integer`のとき`ModInt`に変換します。

## Q&A

### 実行時間が遅くなる可能性があるのに、何故入れるのか

- 本家ライブラリの再現。
- コードの本質的な部分への再現
- 実際どれぐらい遅いのか計測するため。ベンチマークとして。
- 利用者を増やして需要を確かめ、Ruby本体に入れるように訴えたい。

### Numericクラスから継承する意図

- Rubyの数値クラスは、`Numeric`クラスから継承する仕様
- 恩恵は少ないが、`is_a?(Numeric)`で数値クラスとしての挙動ができるようです。
- Integerなどの数値クラスでは`Integer.new(i)`のように書けないように`new`メソッドが封じられていて、扱えませんでした。
- そもそも、`Integer`と割り算などの挙動が違うため、`Integer`から継承すべきではないという意見もありました。
- `Numeric`クラスを継承しなくてもテストは通ったので、継承を書かずにデフォルトの`Object`クラスから継承しても問題なさそうです。

### add!とついている理由

Rubyだと!付きメソッドが破壊的メソッドが多いから、本ライブラリでもそうしました。+にaddのエイリアスをつけるという案もありましたが、そのようなエイリアスがあっても使う人はほぼいないだろうと保留になりました。

## 本家ライブラリとの違い

- 右辺(right-hand side)の意味で`rhs`という変数名が使われていましたが、馴染みがなくRubyでは`other`が一般的であるため`other`に変更しています。
- Ruby本体の`prime`ライブラリにある`prime?`を使用せず、本家ライブラリの`is_prime`関数に合わせて`ModInt.prime?(k)`を実装しています。こちらの方が速いようです。「Ruby本体の`prime`ライブラリは計測などの目的であり高速化する必要はない」旨をRubyコミッターの方がruby-jpで発言していた記憶です。
