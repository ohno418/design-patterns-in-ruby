# Composite パターン

## 課題
オブジェクトツリーの階層を構築したい。すべてのオブジェクトは、リーフオブジェクトかどうかにかかわらず、同じ方法で相互作用する。

## 解決策
Composite パターンには3つの主なクラスがある。**component**クラス、**leaf**クラス、**composite**クラスである。**component** はベースクラスで、すべてのコンポーネントに共通のインターフェイスを定義する。**leaf** は分割不可能な基本要素だ。**composite** は、サブコンポーネントから構成される高次のコンポーネントで、2つの役割を果たす。コンポーネントのひとつであるとともに、コンポーネントの集合体でもあるのだ。compositeクラスとleafクラスは同じインターフェイスを実装し、同じ方法で使われる。

## 例
ケーキの製造をトラッキングするシステムをつくるように頼まれた。キーとなる要件は、焼きあがるのにどのくらいかかるのか知ることができるという部分だ。ケーキを作るのは煩雑なプロセスだ。異なるサブタスクから構成されるであろうタスクを複数含む。全体のプロセスは以下のツリーで表せる。

```
|__ Manufacture Cake
    |__ Make Cake
    |   |__ Make Batter
    |   |   |__ Add Dry Ingredients
    |   |   |__ Add Liquids
    |   |   |__ Mix
    |   |__ Fill Pan
    |   |__ Bake
    |   |__ Frost
    |
    |__ Package Cake
        |__ Box
        |__ Label
```

Composite パターンでは、すべてのステップを、共通のインターフェイスをもつクラスにそれぞれモデル化する。そして各々がどのくらい時間がかかるのかレポートするのである。だから共通のベースクラス `Task` を定義しよう。これが **component** の役割を果たす。

```ruby
class Task
  attr_accessor :name, :parent

  def initialize(name)
    @name = name
    @parent = nil
  end

  def get_time_required
    0.0
  end
end
```

これでもっとも基本的なタスクを責務とするクラス (**leaf**クラス) をつくることができるようになった。例えば `AddDryIngredientsTask` はこんな感じだ。

```ruby
class AddDryIngredientsTask < Task
  def initialize
    super('Add dry ingredients')
  end

  def get_time_required
    1.0
  end
end
```

複雑なタスクを扱うコンテナが必要だ。このコンテナは、内部的にはサブタスクから構成させるが、外部からは他の `Task` と同じに見える。**composite**クラスをつくろう。

```ruby
class CompositeTask < Task
  def initialize(name)
    super(name)
    @sub_tasks = []
  end

  def add_sub_task(task)
    @sub_tasks << task
    task.parent = self
  end

  def remove_sub_task(task)
    @sub_tasks.delete(task)
    task.parent = nil
  end

  def get_time_required
    @sub_tasks.inject(0.0) {|time, task| time += task.get_time_required}
  end
end
```

このベースクラスによって複雑なタスクをつくることができ、なおかつそのタスクはシンプルなひとつのタスクのように振る舞う。 (`Task` のインターフェイスを実装しているからだ。) また、`add_sub_task` メソッドによってサブクラスを追加できる。`MakeBatterTask` をつくろう。

```ruby
class MakeBatterTask < CompositeTask
  def initialize
    super('Make batter')
    add_sub_task(AddDryIngredientsTask.new)
    add_sub_task(AddLiquidsTask.new)
    add_sub_task(MixTask.new)
  end
end
```

オブジェクトツリーはすきなだけ深くできることに注意しよう。`MakeBatterTask` はleafオブジェクトのみから構成されるが、compositeオブジェクトを含むクラスもつくることができる。そしてそれらはまったく同じように振る舞う。

```ruby
class MakeCakeTask < CompositeTask
  def initialize
    super('Make cake')
    add_sub_task(MakeBatterTask.new)
    add_sub_task(FillPanTask.new)
    add_sub_task(BakeTask.new)
    add_sub_task(FrostTask.new)
    add_sub_task(LickSpoonTask.new)
  end
end
```
