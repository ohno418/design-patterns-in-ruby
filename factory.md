# Factory パターン

## 課題
生成するオブジェクトのクラスを指定することなく、オブジェクトを生成したい。

## 解決策
**Factory** パターンは、[Template パターン](template_method.md)を特化したものだ。ベースとなる一般クラスをつくることからはじめる。このベースクラスは「どのクラスにするか」についての決定を行わない。代わりに、オブジェクトを新しく作る必要があるときは、サブクラスで定義されたメソッドをベースクラスから呼ぶ。だから、使うサブクラス (**factory**) によって、いろんなクラスのオブジェクト (**products**) を生成するのである。

## 例
アヒルがたくさんいる池での生命シミュレーションをつくることになったとしよう。

```ruby
class Pond
  def initialize(number_ducks)
    @ducks = number_ducks.times.inject([]) do |ducks, i|
      ducks << Duck.new("Duck#{i}")
      ducks
    end
  end

  def simulate_one_day
    @ducks.each {|duck| duck.speak}
    @ducks.each {|duck| duck.eat}
    @ducks.each {|duck| duck.sleep}
  end
end

pond = Pond.new(3)
pond.simulate_one_day
```

でももしアヒルの代わりにカエルにしたいとき、どうやって`Pond`をモデリングしようか？上記の実装では、`Pond`の初期化処理においてアヒルを指定している。だからどの動物を生成するかの決定はサブクラスが行うようにリファクタリングしよう。

```ruby
class Pond
  def initialize(number_animals)
    @animals = number_animals.times.inject([]) do |animals, i|
      animals << new_animal("Animal#{i}")
      animals
    end
  end

  def simulate_one_day
    @animals.each {|animal| animal.speak}
    @animals.each {|animal| animal.eat}
    @animals.each {|animal| animal.sleep}
  end
end

class FrogPond < Pond
  def new_animal(name)
    Frog.new(name)
  end
end

pond = FrogPond.new(3)
pond.simulate_one_day
```
