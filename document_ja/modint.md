# ModInt

答えをある数で割ったあまりを出力する問題で使えるライブラリです。

計算の際に自動であまりを取るため、ミスを減らすことができます。

## 注意

本ライブラリModIntの使用により、**実行時間が遅く**なる可能性があります。

使用にあたり注意してください。

## 使用例

最初に`ModInt.set_mod`か`ModInt.mod =`で、剰余の法を設定して下さい。

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

### new(val = 0) -> ModInt

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

最初にこのメソッドを用い、modを設定して下さい。

これは、内部の実装として、グローバル変数`$_mod`に設定しています。

また、内部では`$_mod`が素数かどうかを判定して, グローバル変数`$_mod_is_prime`に真偽値を代入します。

なお、このメソッドの返り値を使う機会は少ないと思いますが、`mod=`の方は、代入した引数をそのまま返すのに対し、`set_mod`は`[mod, mod.prime?]`を返します。

**エイリアス** `set_mod`, `mod=`

### mod -> Integer

```ruby
ModInt.mod
```
modを返します。

これは、内部の実装として、グローバル変数`$_mod`を返します。

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

内部の実装として、`@val`を返しています。

`integer`に変換するときに、使用してください。

**エイリアス** `val`, `to_i`

#### エイリアスについての補足

`val`と`to_i`は、`ModInt`のインスタンスメソッドとしてはエイリアスで違いはありません。しかし、`Integer`クラスにも`to_i`メソッドがあるため`to_i`の方が柔軟性がありRubyらしいです。内部実装でもどちらが引数であってもいいように`to_i`が使われています。なお、`val`は、本家の関数名であり、内部実装のインスタンス変数名`@val`です。

### inv -> ModInt

```ruby
ModInt.mod = 11
m = 3.to_m

p m.inv #=> 4 mod 11
```

`xy ≡ 1`なる`y`を返します。

つまり、モジュラ逆数を返します。

### pow(other) -> ModInt

```ruby
ModInt.mod = 11
m = 2.to_m

p m**4　#=> 5 mod 11
p m.pow(4)　#=> 5 mod 11
```

引数は`Integer`のみです。

### 各種演算

`Integer`クラスと同じように、`ModInt`同士、`Integer`と`ModInt`で四則演算などができます。
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

- [ABC156: D - Bouquet](https://atcoder.jp/contests/abc156/tasks/abc156_d) 2020/2/22開催
  - [ACコード 138ms 2020/10/5](https://atcoder.jp/contests/abc156/submissions/17205940)
- [ARC009: C - 高橋君、24歳](https://atcoder.jp/contests/arc009/tasks/arc009_3) 2012/10/20開催
  - [ACコード 1075ms 2020/10/5](https://atcoder.jp/contests/arc009/submissions/17206081)
  - [ACコード 901ms 2020/10/5](https://atcoder.jp/contests/arc009/submissions/17208378)

## 高速化Tips

`+`, `-`, `*`, `/`のメソッドは、それぞれ内部で`dup`で複製させたものに対して`add!`, `sub!`, `mul!`, `div!`のメソッドを用いています。レシーバの`ModInt`を破壊的に変更してもいいときは、こちらのメソッドを用いた方が定数倍ベースで速いかもしれません。

## 参考リンク

- 当ライブラリ
  - [当ライブラリのコード modint.rb(GitHub)](https://github.com/universato/ac-library-rb/blob/main/lib/modint.rb)
  - [当ライブラリのコード modint_test.rb(GitHub)](https://github.com/universato/ac-library-rb/blob/main/lib/modint.rb)
- 本家ライブラリ
  - [本家の実装コード modint.hpp(GitHub)](https://github.com/atcoder/ac-library/blob/master/atcoder/modint.hpp)
  - [本家のテストコード modint_test.cpp(GitHub)](https://github.com/atcoder/ac-library/blob/master/atcoder/modint.hpp)
  - [本家のドキュメント modint.md(GitHub)](https://github.com/atcoder/ac-library/blob/master/document_ja/modint.md)
- Rubyリファレンスマニュアル
  - [class Numeric \(Ruby 2\.7\.0 リファレンスマニュアル\)](https://docs.ruby-lang.org/ja/latest/class/Numeric.html)
- その他
  - [modint 構造体を使ってみませんか？ \(C\+\+\) - noshi91のメモ](https://noshi91.hatenablog.com/entry/2019/03/31/174006)(2019/3/31)
  - [Pythonでmodintを実装してみた - Qiita](https://qiita.com/wotsushi/items/c936838df992b706084c)(2019/4/1)
  - [C#版のModIntのドキュメント](https://github.com/key-moon/ac-library-cs/blob/main/document_ja/modint.md)
  

## Q&A

### 実行時間が遅くなる可能性があるのに、何故入れるのか

- 本家ライブラリの再現。
- コードの本質的な部分への再現
- 実際どれぐらい遅いのか計測するため。ベンチマークとして。
- 利用者を増やして需要を確かめ、Ruby本体に入れるように訴えたい。

### ModIntのメリット

Rubyは、C言語/C++と異なり、次のような特徴があります。

- 負数を正数で割っても正数を返す定義
- 多倍長整数で、オーバーフローしない(※数が大きすぎると計算は遅くなります)

そのため、C言語/C++に比べるとModIntを使うメリットは薄れる部分もありますが、

- 可読性の向上
- Modの取り忘れを気にする必要がなくなる

などのメリットがあります。

### グローバル変数を使う意図は

`$_mod`や`$_mod_is_prime`というグローバル変数を使用しています。

特に実務などで、グローバル変数は忌避すべきものとされています。

しかし、クラス変数は、インスタンス変数に比べアクセスするのに時間がかかるようで、全てのそれぞれのModIntインスタンス変数`@mod`を持たせるよりも遅くなることがありました。

そのため、総合的に1番実行時間が速かったグローバル変数を使用しています。

インスタンス変数、クラス変数、クラスインスタンス変数、グローバル変数、定数など色々ありますが、どれがどこで遅いのか・速いのか、何が最善なのかわかっていないので、実装を変える可能性があります。

### グローバル変数が、アンダースコア始まりな理由

`$mod`はコードで書きたい人もいたので、名前衝突しないよう`$_mod`としました。

### Numericクラスから継承する意図は

Rubyの数値クラスは、`Numeric`クラスから継承する仕様で、それに合わせています。

継承してると、少しだけいいことがあります。
- `==`を定義すると、`!=`, `zero?`, `nonzero?`などのメソッドも定義される。
  - ここ重要です。`==`を定義しているので、`!=`を定義しなくて済んでいます。 
- `*`を定義すると、`abs2`メソッドも定義される。
- `finite?`, `real`, `real?`,`imag`, が使えるようになる。
- `is_a?(Numeric)`で`true`を返し数値のクラスだとわかる。

### Integerクラスから継承しない理由

`Integer`などの数値クラスでは`Integer.new(i)`のように書けないように`new`メソッドが封じられていて、うまい継承方法がわかりませんでした。
また、そもそも`Integer`と割り算などの挙動が違うため、`Integer`から継承すべきではないという意見もありました。`ModInt`は大小の比較などもすべきではないです。。

### add!と!がついている理由

Rubyだと!付きメソッドが破壊的メソッドが多いから、本ライブラリでもそうしました。`+`に`add`のエイリアスをつけるという案もありましたが、そのようなエイリアスがあっても使う人はほぼいないと考え保留にしました。

### primeライブラリのprime?を使わない理由

Ruby本体の`prime`ライブラリにある`prime?`を使用せず、本家ライブラリの`is_prime`関数に合わせて`ModInt.prime?(k)`を実装しています。こちらの方が速いようです。「Ruby本体の`prime`ライブラリは計測などの目的であり高速化する必要はない」旨をRubyコミッターの方がruby-jpで発言していた記憶です。

### powメソッドの引数がIntegerで、ModIntが取れない理由

`ModInt#pow`の引数は、`Integer`のみとしています。

しかし、`ModInt`も許容すれば、コードがスッキリする可能性もあると思いますが、理論的に`Integer`のみが来るはずと考えるためです。間違った形で`ModInt`を引数にとれてしまうとバグが起きたときに気がつきにくいため、封印しています。

### ModIntの大小比較やRangeが取れない理由

コードがスッキリする可能性もあると思いますが、理論的に正しくないと考えるためです。間違った形で`ModInt`が大小比較できてしまうと、バグが起きたときに気がつきにくいため、封印しています。

### RubyならRefinementsでModIntを作れるのでは

それもいいかもしれないです。

### ModIntのコンストラクタまわりの由来など

#### ModInt(val) -> ModInt

`Kernel#Integer`, `Kernel#Float`, `Kernel#Rational`に準じて、`Kernel#ModInt`を作っています。

```ruby
ModInt.mod = 11

m = ModInt(5)
```

#### ModInt.raw(val)

`raw`の由来は本家がそうしてたからです。

#### to_m

Rubyの`to_i`, `to_f`などに準じています。


## 本家ライブラリとの違い

### rhsという変数名

右辺(right-hand side)の意味で`rhs`という変数名が使われていましたが、馴染みがなくRubyでは`other`が一般的であるため`other`に変更しています。

```ruby
def ==(other)
  @val == other.to_i
end
```

### コンストラクタは、true/false未対応

本家C++ライブラリの実装では、真偽値からmodint型の0, 1を作れるらしいです。

しかし、本ライブラリは、下記の理由から、対応しません。

- 定数倍高速化
- Rubyの他の数値型は、true/falseから直接変換できない。
- Rubyの偽扱いのfaltyはfalse/nilのみであり、コンストラクタだけ対応しても変な印象を受ける。
- Ruby中心に使っている人には馴染みがなく使う人が少なそう。
- 使う機会もあまりなさそう。
