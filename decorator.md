# Decorator パターン

## 課題
いくつかの機能を追加することで、オブジェクトの責務に変更を加えたい。

## 解決策
**Decorator** パターンでは、実際のオブジェクトをラッピングしたオブジェクトをつくり、同じインターフェイスとメソッド転送 (forwarding) を実装する。しかし、実際のオブジェクトに委譲する前に、decoratorオブジェクトは別処理を加える。また、すべてのdecoratorは同じコアインターフェイスを実装しているため、decoratorのチェーンをつくり、機能を組み合わせることができる。

## 例
以下は、ファイルにテキスト行を書き込むシンプルなオブジェクトの実装である。

```ruby
class SimpleWriter
  def initialize(path)
    @file = File.open(path, 'w')
  end

  def write_line(line)
    @file.print(line)
    @file.print("\n")
  end

  def pos
    @file.pos
  end

  def rewind
    @file.rewind
  end

  def close
    @file.close
  end
end
```

それぞれの行の前に、行数やタイムスタンプ、チェックサムを書き込む必要があるかもしれない。そういった場合、このクラスに新しいメソッドを追加するか、それぞれのケースに合うサブクラスを新しく作ることができるだろう。しかしこれらの解決策は最適ではない。前者の場合、呼び出し元は、どういった種類の行を出力しているのか、ずっと知っておかねばならない。後者の場合、膨大な数のサブクラスをもつことになる。特に新しい機能を組み合わせるときはそうであろう。だから、writerクラスと同じインターフェイスを実装するdecoratorベースクラスをつくって、処理をwriterクラスに委譲しよう。

```ruby
class WriterDecorator
  def initialize(real_writer)
    @real_writer = real_writer
  end

  def write_line(line)
    @real_writer.write_line(line)
  end

  def pos
    @real_writer.pos
  end

  def rewind
    @real_writer.rewind
  end

  def close
    @real_writer.close
  end
end
```

`WriteDecorator`クラスを拡張することで別の機能を追加できる。例えばナンバリングを加えるにはこんな感じだ。

```ruby
class NumberingWriter < WriterDecorator
  def initialize(real_writer)
    super(real_writer)
    @line_number = 1
  end

  def write_line(line)
    @real_writer.write_line("#{@line_number}: #{line}")
    @line_number += 1
  end
end

writer = NumberingWriter.new(SimpleWriter.new('final.txt'))
writer.write_line('Hello out there')
```

同じコアインターフェイスを実装するdecoratorを新しくつくるとき、以下のようにそれらを繋げることできる。

```ruby
class TimeStampingWriter < WriterDecorator
  def write_line(line)
    @real_writer.write_line("#{Time.new}: #{line}")
  end
end

writer = CheckSummingWriter.new(TimeStampingWriter.new(
            NumberingWriter.new(SimpleWriter.new('final.txt'))))
writer.write_line('Hello out there')
```
