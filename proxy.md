# Proxy パターン

## 課題
あるオブジェクトにアクセスする方法とその場面をよりコントロールしたい。

## 解決策
proxyパターンでは1つのオブジェクト (**proxy**オブジェクト) がつくられ、このオブジェクトがアクセス対象である実オブジェクトへの参照をもつ。そしてproxyオブジェクトが呼び出されると、実オブジェクトにリクエストが転送されるのである。このパターンが有用になりうる場面は主に3つある。
* **Protection Proxy**: 実オブジェクトに呼び出しを委譲する前に、セキュリティー層を追加する。この方法の大きな利点は関心の分離である。proxyオブジェクトがアクセス制御に注意を払うため、実オブジェクトはビジネスロジックにのみ注力すればよいのである。
* **Remote Proxy**: 使いたいオブジェクトが別の端末にあるとき、ネットワーク越しにアクセスを取得するであろう。proxyオブジェクトが複雑なコネクションの色々を取り扱うため、クライアントは同じ端末にあるかのようにオブジェクトを使用することができる。
* **Virtual Proxy**: オブジェクトの生成を実際に使用されるときまで先延ばしにする。

## 例
`BankAccount`オブジェクトを考えてみよう。

```ruby
class BankAccount
  attr_reader :balance

  def initialize(starting_balance=0)
    @balance = starting_balance
  end

  def deposit(amount)
    @balance += amount
  end

  def withdraw(amount)
    @balance -= amount
  end
end
```

誰がアクセスするかを制御したい場合にはproxyオブジェクトをつくる。このproxyオブジェクトが、BankAccountオブジェクトに呼び出しを委譲する前に、なにかしらのチェックを行う。

```ruby
require 'etc'

class AccountProtectionProxy
  def initialize(real_account, owner_name)
    @subject = real_account
    @owner_name = owner_name
  end

  def deposit(amount)
    check_access
    return @subject.deposit(amount)
  end

  def withdraw(amount)
    check_access
    return @subject.withdraw(amount)
  end

  def balance
    check_access
    return @subject.balance
  end

  def check_access
    if Etc.getlogin != @owner_name
      raise "Illegal access: #{Etc.getlogin} cannot access account."
    end
  end
end
```

実際に必要なときにのみ、BankAccountオブジェクトを生成したいかもしれない。メソッドが呼び出されたときのみ実オブジェクトを初期化するproxyオブジェクトをつくり、さらなる呼び出しに備えてキャッシュされたコピーを保持することができる。

```ruby
class VirtualAccountProxy
  def initialize(starting_balance=0)
    @starting_balance=starting_balance
  end

  def deposit(amount)
    s = subject
    return s.deposit(amount)
  end

  def withdraw(amount)
    s = subject
    return s.withdraw(amount)
  end

  def balance
    s = subject
    return s.balance
  end

  def subject
    @subject || (@subject = BankAccount.new(@starting_balance))
  end
end
```
