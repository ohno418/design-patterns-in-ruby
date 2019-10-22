# Iterator パターン

## 課題
ある集約オブジェクトの内部表現を外部に晒すことなく、そのサブオブジェクト群にアクセスする方法を提供したい。

## 解決策
方法が2つある。**外部イテレーター**と**内部イテレーター**だ。

### 外部イテレーター
外部イテレーターは集約オブジェクトから独立したオブジェクトだ。集約オブジェクト自体はイテレーターを初期化するための引数として渡される。この外部イテレーターは現在のインデックスへの参照を保持し、残りのitemがまだあるか尋ねるインターフェイスを提供する。現在のitemと次のitemを取得するためだ。

### 内部イテレーター
内部イテレーターの場合は、集約オブジェクトの内部へロジックを渡すためにブロックを用いる。`Array`の`each`メソッドがこの方法の好例だ。

## 例
Rubyの配列の外部イテレーターはこんな感じになるだろう。

```ruby
class ArrayIterator
  def initialize(array)
    @array = array
    @index = 0
  end

  def has_next?
    @index < @array.length
  end

  def item
    @array[@index]
  end

  def next_item
    value = @array[@index]
    @index += 1
    value
  end
end
```

ダックタイピングのおかげで、`length`メソッドをもち、かつ整数でインデックスできるクラスであればどのクラスでも、この実装は作用する。例えば`String`など。内部イテレーターを使って集約クラスをつくるには、`Enumerable`ミックスインモジュールを用いる。この場合、イテレーターメソッドは`each`と名付け、比較演算子`<=>`を実装する必要がある。こうすることによって、`include?`や`all?`、`sort`など、便利なメソッド群を自動的に使える。例として、2つのクラスを考えてみよう。`Account`と、複数のaccountを管理する`Portfolio`だ。

```ruby
class Account
  attr_accessor :name, :balance

  def initialize(name, balance)
    @name = name
    @balance = balance
  end

  def <=>(other)
    balance <=> other.balance
  end
end

class Portfolio
  include Enumerable

  def initialize
    @accounts = []
  end

  def each(&block)
    @accounts.each(&block)
  end

  def add_account(account)
    @accounts << account
  end
end
```

```ruby
my_portfolio.any? {|account| account.balance > 2000}
```
