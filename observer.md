# Observer パターン

## 課題
高度に統合されたシステムをつくりたい。システムの各部分が、システム全体の状態についての関心や知識を持つといったものだ。またメンテナンスしやすいようにしたい。そのためにクラス同士の密結合は避けるべきだ。

## 解決策
別のコンポーネント (subjectコンポーネント) の挙動を知っているコンポーネント (observerコンポーネント) がほしい場合、単純に両方のクラスを強固に繋ぎ合わせて、subjectコンポーネントの挙動をobserverコンポーネントに知らせることはできる。つまりsubjectコンポーネントをつくるときにobserverコンポーネントの参照を渡し、subjectコンポーネントに変化が起きたときにobserverオブジェクトのメソッドを呼ぶということだ。しかしこのやり方だと密結合を増やすことになる。これは避けたい状況だ。さらに他のobserverにも通知したい場合、subjectコンポーネントの実装を変更しなければならない。subjectコンポーネント自体はなにも変わっていないにも関わらず。より良いやり方は、subjectコンポーネントの変化に関心のあるオブジェクトのリストをキープしておき、ニュース発信元 (subjectコンポーネント) とニュース購読者 (observerコンポーネント) とのきれいなインターフェイスを定義することだ。こうすればsubjectコンポーネントに変化があったときには、observerリストの各オブジェクトにインターフェイスを通して通知するだけだ。

## 例
`salary`プロパティーをもつ`Employee`オブジェクトを考えよう。従業員給与名簿 (payroll) のシステムに変更を知らせながら、salaryを変更したい。もっともシンプルなやり方は、payrollの参照を渡して、従業員の`salary`を変更したときに payroll に通知することだ。

```ruby
class Employee
  attr_reader :name, :title
  attr_reader :salary

  def initialize(name, title, salary, payroll)
    @name = name
    @title = title
    @salary = salary
    @payroll = payroll
  end

  def salary=(new_salary)
    @salary = new_salary
    @payroll.update(self)
  end
end
```

問題は、別のオブジェクト (例えば`TaxMan`) に通知したいとき、`Employee`を変更しなければならないことだ。つまり他のクラスが`Employee`クラスの変更の直接原因となっているのだ。`Employee`クラス自体にはなんの変更もないのに。salaryの変更に関心をもつオブジェクトのリストを保持する方法を考えよう。

```ruby
class Employee
  attr_reader :name, :title
  attr_reader :salary

  def initialize(name, title, salary)
    @name = name
    @title = title
    @salary = salary
    @observers = []
  end

  def salary=(new_salary)
    @salary = new_salary
    notify_observers
  end

  def add_observer(observer)
    @observers << observer
  end

  def delete_observer(observer)
    @observers.delete(observer)
  end

  def notify_observers
    @observers.each do |observer|
      observer.update(self)
    end
  end
end
```

これで`add_observer`メソッドでobserverリストにどんなオブジェクトでも追加できるし、salaryが変更されたときはobserverリストの全オブジェクトに知らせることができる。

```ruby
fred = Employee.new('Fred', 'Crane Operator', 30000.0)

payroll = Payroll.new
fred.add_observer(payroll)

tax_man = TaxMan.new
fred.add_observer(tax_man)

fred.salary=35000.0
```

自分でもこのパターンを実装できるが、Rubyの標準ライブラリを使えばどんなオブジェクトでもobservableなオブジェクトにできる。いろんなところで同じメソッドを定義しなくてよくなるのだ。`Observable`モジュールを使って`Employee`クラスをリファクタリングしよう。

```ruby
require 'observer'

class Employee
  include Observable

  attr_reader :name, :title
  attr_reader :salary

  def initialize(name, title, salary)
    @name = name
    @title = title
    @salary = salary
  end

  def salary=(new_salary)
    @salary = new_salary
    changed
    notify_observers(self)
  end
end
```
