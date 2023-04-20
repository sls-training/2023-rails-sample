# Ruby Tutorial

## How to install
- homebrewをinstallする
- rbenvのinstall
    - 初期設定
    
        rbenv init
        ```bash
            % rbenv init
            # Load rbenv automatically by appending
            # the following to ~/.zshrc:

            eval "$(rbenv init - zsh)"
        ```
        環境によってちょっと変わりそうなので注意して設定
        ```bash
            echo 'eval "$(rbenv init - zsh)"' >> ~/.zshrc
        ```
- install ruby
    
    ```bash
    # 失敗して警告されたのでlibyamlもinstall
    brew install rbenv ruby-build libyaml
    
    # ruby3.2.2(stable)のinstall
    # 一番最新のrubyをinstallした
    rbenv install 3.2.2
    rbenv global 3.2.2
    ```
  

- create rails app
    ```
    rails _${version}_ new ${app_name}
    ```

## deploy

これしないとlinuxサーバー上のbundle installでこける
```bash
bundle lock --add-platform x86_64-linux
```

### dbをpostgresに対応させる
productionを次のようにする

```bash
production:
  <<: *default
  adapter: postgresql
  encoding: unicode
  url: <%= ENV['DATABASE_URL'] %>
```

- DATABASE_URLをproduction時に環境変数通す
- pgを入れる必要があるらしい
なんとなくGemfileに追加してみた
```
gem 'pg', '>=1.1.4'
```


あとはRenderでごにょごにょ<br>
多分使うことなさそうだしTutorial見ればいいか

renderの起動スクリプトにdb:migrateとかなかったから入れたり必要に応じてなんかバグ対処です。

---

↓こっからは大体お勉強の内容

---


## メモ (勉強の落書き)
user modelの作成

```bash
rails generate scaffold User name:string email:string
rails db:migrate
```

対話型shell
```ls
rails console
```


```bash
## 追加
rails g controller StaticPages home help
## 削除
rails d controller StaticPages home help
```

大事そうだからmemo


- アプリケーションのコード >> テストコード (短い) =簡単に書ける 「先に」

- 動作の仕様がまだ固まりきっていない場合、アプリケーションのコードを先に書き、期待する動作を「後で」書く

- セキュリティが重要な課題またはセキュリティ周りのエラーが発生した場合、テストを「先に」書く

- バグを見つけたら、そのバグを再現するテストを「先に」書き、回帰バグを防ぐ体制を整えてから修正に取りかかる

- すぐにまた変更しそうなコード (HTML構造の細部など) に対するテストは「後で」書く

- リファクタリングするときは「先に」テストを書く。特に、エラーを起こしそうなコードや止まってしまいそうなコードを集中的にテストする

=> 基本エラーが起こりそう or 楽にかける 「先に」
=> 仕様が変わりがち、すぐ編集する 「後で」


## カスタムヘルパー

views/layout/*.erb
```ruby
<%= yield(:title) %> | Ruby on Rails Tutorial Sample App
```

views/static_pages/*.erb
```ruby
<% provide(:title, "Home") %>
```

helpersに定義する


## 文法
- if系
    ```ruby
    if s.nil?
        "s is nil"
    elsif s.empty?
        "s is empty"
    elsif s.include("foo")
        "s include foo"
    end
    ```

- 文字変換

    ```ruby
    object.to_s
    ```

    メソッドチェーンできる
    ```ruby
    object.to_s.empty?
    # => true
    ```

    後続タスク
    method1が真の時、method2が実行される
    ```ruby
    {method1} unlress {method2}
    ```


- 例外処理
    ```ruby
    file.save!  #失敗 => 例外発生
    file.save   #失敗 => nil


    begin
      10 / 0
    rescue => e
      puts e
    end

    # => divided by 0

    ```

- 関数
    ```ruby
    def string_message(str = '')
        return "It's an empty string!" if str.empty?
        return "The string is nonempty."
    end

    #　関数のオブジェクト => :string_message
    puts string_message("foobar")
    ```

- 配列操作
    ```ruby
    a = [2, 3, 4, 7]

    # 結合
    a.join
    # => "2347"
    a.join(',')
    # => "2,3,4,7"
    
    # range操作
    b = (0..9).to_a
    # => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    # 0から2まで
    b[0..2]
    # => [0, 1, 2]
    # 0から3つ
    b[0,3]
    # => [0, 1, 2]
    ```

- ブロック
    ```ruby
    (1..3).each {|i| puts 2 * i}
    2
    4
    6
    => 1..3

    ## (1..3) 範囲オブジェクト
    ## { |i| puts 2 * i } ブロック

    ## 書き換え
    (1..3).each do |i|
        puts 2 * i
    end


    # map
    (1..5).map { |i| i**2 }
    ## => [1, 4, 9, 16, 25]
    ```

    symbol-to-proc
    ```ruby
    ## ラムダ式みたいなやつで省略できるっぽい
    %w[A B C].map { |char| char.downcase }
    %w[A B C].map { &:downcase }
    ```

- hash
    ```ruby
    user = {}
    user["name"] = "hogehoge"
    user["id"] = 22
    # => {"fdf"=>"fdsf", "id"=>22}
   
    user[:name]   
    # => "hogehoge"
    
    # :name <- このことをシンボル
    # railsでは文字列よりシンブルで扱うのが一般的

    a = {"one" => 'uno', "two" => "doc", "three" => "tres"}

    # こっちの方が良い
    a = {:one => 'uno', :two => "doc", :three => "tres"}
    # これでも良い(こっちの方が直感的だなぁ)
    a = {one: 'uno', two: "doc", three: "tres"}
    # a[:one]でアクセスできる
    ```

- class
    ```ruby
    s = "foobar"       # ダブルクォートは文字列のコンストラクタ
    s = String.new("foobar")

    # 継承
    class Word < String
        # @@でクラス変数 => staticのこと
        @@uouo = "hoge"
        # コンストラクタ
        def initialize(name)
            # 初期処理
            ## @でインスタンス変数
            @name = name
        end
        def uouo?
            puts "uouou"
        end
    end
        
    ```

- class拡張
    ```ruby
    class String
        def palindrome?
            self == self.reverse
        end
    end
    ## 普通に書けばoverrideできる
    ## なんかアンセーフな感じできもいなぁ
    ```


- マスアサイメント
    ```ruby
    ## こういうの
    Person.new(name: 'hoge', age: 24)
    person.update(name: 'hoge', age: 24)
    ```
    rails3 => `attr_accessible`とかを用意して更新対象を限定していた
    rails4 => 脆弱性があるから Strong Parametersを導入
    ```ruby
    def person_params
        params.require(:person).permit(:name, :age)
    end
    ```


- Asset Pipeline

app => 画像とかスタイルシート
lib => 自作ライブラリ
vender => サードパーティライブラリ

- プリプロセッサエンジン
  つまり.erbを.htmlにしてくれるやつ
  coffeeスクリプトとか色々


- リンクのテスト
  ```bash
  rails g integration_test site_layout
  ```

  ```ruby
  require 'test_helper'

    class SiteLayoutTest < ActionDispatch::IntegrationTest

        test "layout links" do
            get root_path
            assert_template 'static_pages/home'
            assert_select "a[href=?]", root_path, count: 2
            assert_select "a[href=?]", help_path
            assert_select "a[href=?]", about_path
            assert_select "a[href=?]", contact_path
        end
    end
```

helper関数のテスト書く時
test/helpers/*.rb ActionView::TestCase継承したクラスでequalとかテストしてやる
helperのモジュールはtest_helperにincludeしてtest_helperから叩く


- migrateミスった時
rails db:reset
?
development.sqlite3消す


validation => https://railsguides.jp/active_record_validations.html#uniqueness
ここ見ればいけそう


APIはここググればいけそう
https://api.rubyonrails.org/classes/ActiveModel/Type/String.html



例としてusers tableにpassword_digestを追加するとき
```bash
rails g migration add_password_digest_to_users password_digest:string
```


- 
Rails7からRailsのデフォルトになった

- Turbo
  - js lib
  - js書かずにSPAライクなページが作れるとか
- Stimulus
  - js lib
- Strada
  - mobile application開発の際に必要らしい。詳しいことがわからなかった

React fetch(client) => response(json) : render(client)
Hotwire fetch(client) => response(HTML) : render(server)

turboの機能中にturbo driveとか色々あるらしい後でググろ

10章でようやく出てきたturbo君
turbo-method
```html
<a href="/cats/1" data-turbo-method="delete">リンク</a>
```
こんなんが書けるとか
リンクでPOST・PUT・PATCH・DELETEを使うことができるらしい
erbだとこうか
turbo-confirm => data-turbo-confirm属性になって確認ダイアログでる
```erb
<%= link_to "delete", user, data: { "turbo-method": :delete,
                                          turbo_confirm: "You sure?" } %>
```

## 永続cookieと一時cookie
### なんぞ？
- 一時Cookie → 普通のcookie、ブラウザ閉じれば消える
  ログイン情報とか、token持ってたりするよね

- 永続cookie → 複数ブラウザでのセッション共有とか、ずっと残る<br>
    
  ユーザのカート情報の永続化とかに使われるらしいか<br>
  確かにあいつずっと残るよなあアマゾンとか<br>
  自分割とウザいと思ってるが<br>


## セッションハイジャック
sessionIdを知られた場合、自由にアクセスできちゃうよねって話

- 管理の甘いネットワークのパケットから掠め取る => 対策: TLS
- データベースに保存されているトークンを盗み出す => 対策: トークンを生で管理しない(hash化)
- XSS(クロスサイトスクリプティング) => 対策: rails君が勝手にやってくれるま？？
- ユーザの機材から直接盗む(まあ確かにある)

tutorial君の方針コピーしてきた
1. 記憶トークンにはランダムな文字列を生成して用いる。
2. ブラウザのcookiesにトークンを保存するときには、有効期限を設定する。
3. トークンはハッシュ値に変換してからデータベースに保存する。
4. ブラウザのcookiesに保存するユーザーIDは暗号化しておく。
5. 永続ユーザーIDを含むcookiesを受け取ったら、そのIDでデータベースを検索し、記憶トークンのcookiesがデータベース内のハッシュ値と一致することを確認する。

確かにこうやって方針書き出すと設計しやすそうだしいいかも...


## テスト

### 受け入れテスト

  実装する前に統合テストを書く
  ある機能の実装が完了して受け入れ可能な状態になったかどうかをテストする。
  
  

## ページネーション
ユーザ一覧のページングをマジで簡単に作れた.びっくり

Gemfileにこれ書いただけ

```bash
gem "will_paginate",           "3.3.1"
gem "bootstrap-will_paginate", "1.0.0"
```
User.pagenation(page: 1)とかで手に入るオブジェクトの実態はん<br>
ActiveRecord_Relation というものらしい...何？ん<br>

ActiveRecordとは、DBの操やらレコードの読み込みとかとかん<br>
ふむふむ

Relationって確かhasuraでみたやつやん<br>
中間テーブルとかでテーブルに関係性持たせるやつやねん<br>

RubyでWhere、OrderByとか呼べる抽象メソッド的な？まあ今はこの認識でよいか

## モックとスタブ

モック : データベース等にはアクセスせず、本物のように働くテストのためのオブジェクトのこと
スタブ : 本物のように動くメソッドをオーバライドしたダミーメソッド(db, network)

使う時のイメージ : オブジェクトの作成が困難だったり、複雑、時間がかかるとか


## システムスペックとリクエストスペック
テストの分け方としてはモデルとか引っこ抜いたらあとはこの二つになるでいいと思う


統合テスト -> システムスペック(大部分はこれになるわけか)
API系      -> リクエストスペック

けど、、、チュートリアルの統合テストがリクエストチックなのでシステムスペック仕様に書き換えにくい...
それだけ
つまりチュートリアルがRSpec使ってないのが悪い
