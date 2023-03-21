### Other language English version(英語バージョン)

This file is for Japanese to read.  
The following files are written in English: (英語で読みたい方は次のファイルを)
- [README.md (ver. English)](README.md)

# ac-library-rb

[![Gem Version](https://badge.fury.io/rb/ac-library-rb.svg)](https://badge.fury.io/rb/ac-library-rb)
[![codecov](https://codecov.io/gh/universato/ac-library-rb/branch/main/graph/badge.svg?token=NUAIDTMGBE)](https://codecov.io/gh/universato/ac-library-rb)

<img width="560" src="ac-library-rb_header.jpg" alt="ac-library-rb Logo">

ac-library-rbは、AtCoder Library (ACL)のRuby版です。

ACLの詳細は、以下をご覧ください.

- AtCoder Library(ACL)とは
  - [AtCoder Library (ACL) - AtCoder](https://atcoder.jp/posts/517)
  - [AtCoder Library - Codeforces](https://codeforces.com/blog/entry/82400)
    - [けんちょん氏による日本語訳](https://drken1215.hatenablog.com/entry/2020/09/08/181500)
- コード
  - [atcoder/ac-library - GitHub](https://github.com/atcoder/ac-library)

## ライブラリの使い方

[ライブラリ目次: index.md](https://github.com/universato/ac-library-rb/blob/main/document_ja/index.md)

公式に、ac-library-rbの利用として、以下の方法を想定しています。
- 直接コピペして使う方法
  - `lib`ディレクトリに、ac-library-rbのライブラリのコードがあります。
  - `lib_lock`ディレクトリに、Gem用にモジュール化されたコードがあります。
    (別途モジュール化するの、ちょっとトリッキーですが……)
- Gemとして使う方法(詳細は後述)

他に、有志作成のバンドルツール[expander-rb](https://github.com/surpace/expander-rb)(by surpaceさん)を利用する方法もあります。

目次は、[index.md](https://github.com/universato/ac-library-rb/blob/main/document_ja/index.md)をご覧ください。

## Gemとなったac-library-rbを使う方法

コピペ以外にGemとなったac-library-rbを使う方法を紹介します。

### gemのインストール方法

ac-library-rbに限った話ではないですが、一般的な2種類のgemのインストール方法を紹介します。

- Gemとして使う方法
  - `gem`コマンドにより、`gem install ac-library-rb`
  - gemのbundlerを用いる方法

#### gemコマンドによるインストール方法

Ruby本体に付属のgemコマンドを用い、そのまま`gem install ac-library-rb`を実行します。

#### gemのbundlerを用いたインストール方法

bundlerをインストールしてない場合は、`gem install bundler`というコマンドを打ちインストールします。

次に、ac-library-rbを使いたいディレクトリ配下にGemfileを置きます。Gemfileという名称のファイルです。  
このGemfileの中で、次のように書きます。
```ruby
gem "ac-library-rb"
```
そして、`budnle install`というコマンドにより、Gemfileに書かれたac-library-rbをインストールします。

このとき、bundlerを通してRubyファイルを実行する必要があるため、`bundle exec`コマンドを用います。

`$ bundle exec ruby sample.rb`

### (インストール後の)Rubyファイルでの書き方

#### 一括ロード

Rubyファイル上で一括でac-library-rbのライブラリを使えるようにするには、下記のように書きます。

```ruby
require "ac-library-rb/all"

dsu = AcLibraryRb::DSU.new

include AcLibraryRb
dsu = DSU.new
```

`include AcLibraryRb`とモジュールをインクルードすることで、  
何度も`AcLibraryRb`といわゆる名前空間を書く必要がなくなります。

また、`/all`なしで`require "ac-library-rb"`とした場合は、`include AcLibraryRb`も同時に実行されます。
```ruby
require "ac-library-rb"

dsu = DSU.new
```

#### 個別ロード

特定のライブラリのみをインストールしたいときは下記のように`ac-library-rb/`のあとにライブラリ名を指定します。

```ruby
require "ac-library-rb/dsu"
dsu = AcLibraryRb::DSU.new

require "ac-library-rb/priority_queue"
pq = AcLibraryRb::PriorityQueue.new
```

本gem名はハイフン区切りですが、ac-library-rb内のライブラリ名はアンダースコア区切りであるため、注意して下さい。  
一般的にRubyのライブラリ名はアンダースコアが推奨されていますが、  
ACL本家のレポジトリ名がac-libraryとハイフン区切りで、それに合わせているため、レポジトリ名・gem名がハイフン区切りとなっています。

## Rubyバージョン

現在、AtCoderのRubyバージョンは、2.7.1です。

そのため、2.7と最新の3.1でテストをしています。

ただ、開発される方は2.7より古くても動かせるようNumbered parametersなどの使用は控えてもらえると嬉しいです。

## ライセンス

とりあえず、本家ライブラリと同じCC0-1.0 Licenseです。

競技プログラミング等で自由に使って下さい。

宣伝・バグ報告などしてもらえると嬉しいです。

## ac-library-rbを開発したい方向けの情報(CONTRIBUTEING)

### コーディングスタイル

推奨スタイル
- インデントは、半角スペース2文字
- 行末の余計なスペースは削除

RuboCopを使用できる方は、使用してもらえるとありがたいです。  
使い方のわからない方は、使う必要がないです。  

```console
$gem install rubocop
```
上記の方法でrubocopをインストールします。

```console
$rubocop    <- チェック
$rubocop -a <- 安全に直せるところは自動で修正
$rubocop -A <- 安全でない可能性のところも自動で修正
```

### ディレクトリの説明

`lib`ディレクトリ内に各種のデータ構造などのライブラリがあります。  
`lib_lock`は、Gem用にモジュール化させるため`lib`の内容をコピーする形でモジュール化させています。  
[`bin/lock_lib.rb`](./bin/lock_lib.rb)を実行することで、`lib`から`lib_lock`にモジュール化させる形でコピーします。  
`rake copy`コマンドを実行すると、[`bin/lock_lib.rb`](./bin/lock_lib.rb)が実行されるため、この2つは同等です。

なお、`rake`コマンドでテストを実行させると、自動的に`require_relative "./bin/lock_lib.rb"`により、コピーが行われます。  
このあたりはトリッキーで、予定は未定ですが、今後全てモジュール化される等に統一される可能性があります。  

```
$ rake copy <- `lib`に変更があれば、`./lib_lokc`を更新する。
$ rake test <- 全てのテストを実行
$ rake      <- 上2つのcopy & testを実行
```

## その他の情報

### RubyのSlackのAtCoderチャンネル

[ruby-jp](https://ruby-jp.github.io/) に"atcoder"というチャンネルがあります。

ここで、バグ報告などすると、競プロ詳しい人などが反応しやすいかもしれません。

Slackに4000人近く、atcoderチャンネルに350人ほどの登録者がいるので、お気軽に参加してください。

### 他言語のライブラリ

- [Unofficial Portings of AtCoder Library](https://docs.google.com/spreadsheets/d/19jMAqUbv98grVkLV_Lt54x5B8ILoTcvBzG8EbSvf5gY/edit#gid=0) (by [notさん](https://twitter.com/not_522/status/1303466197300649984))

### 他言語

[README in English](README.md)
