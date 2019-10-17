# Template Method パターン

## 課題
複雑な1組のコードがあり、その途中で少し変化させる必要がある。

## 解決策
Template Method パターンの一般的な考えは、骨格となるメソッドをもった抽象クラスをつくることだ。抽象クラスは抽象メソッドを呼び出すことで処理を駆動させ、そして実際の処理は具象サブクラスが提供する。抽象クラスは高次の処理を制御し、サブクラスは処理の詳細を補填する。

## 例
HTMLレポートを生成したい。そのため以下のようなものをつくった。

```ruby
class Report
  def initialize
    @title = 'Monthly Report'
    @text = ['Things are going', 'really, really well.']
  end

  def output_report
    puts('<html>')
    puts(' <head>')
    puts("<title>#{@title}</title>")
    puts(' </head>')
    puts(' <body>')
    @text.each do |line|
      puts("<p>#{line}</p>")
    end
    puts(' </body>')
    puts('</html>')
  end
end
```

ここにきて新しいフォーマットを追加しなければならないことに気づいた。plain text だ。よし、フォーマットをパラメーターとして渡し、なにを表示するか決めよう。

```ruby
class Report
  def initialize
    @title = 'Monthly Report'
    @text = ['Things are going', 'really, really well.']
  end

  def output_report(format)
    if format == :plain
      puts("*** #{@title} ***")
    elsif format == :html
      puts('<html>')
      puts(' <head>')
      puts("<title>#{@title}</title>")
      puts(' </head>')
      puts(' <body>')
    else
      raise "Unknown format: #{format}"
    end
    @text.each do |line|
      if format == :plain
        puts(line)
      else
        puts("<p>#{line}</p>")
      end
    end
    if format == :html
      puts(' </body>')
      puts('</html>')
    end
  end
end
```

これはやや乱雑だ。両方のフォーマットをあつかうコードはもつれ合い、さらにひどいことに拡張性がまったくない。 (新しいフォーマットを追加したいときはどうする？) コードをリファクタリングしよう。フォーマットに関係なく、ほとんどのレポートでは基本的な処理の流れは同じだ。ヘッダーを出力し、タイトルを出力し、レポートの各行を出力し、各々のフォーマットに必要となる末尾を出力する。これらのすべてのステップを踏み、なおかつ詳細処理をサブクラスに任せるような、抽象ベースクラスをつくる。

```ruby
class Report
  def initialize
    @title = 'Monthly Report'
    @text = ['Things are going', 'really, really well.']
  end

  def output_report
    output_start
    output_head
    output_body_start
    output_body
    output_body_end
    output_end
  end

  def output_body
    @text.each do |line|
      output_line(line)
    end
  end

  def output_start
    raise 'Called abstract method: output_start'
  end

  def output_head
    raise 'Called abstract method: output_head'
  end

  def output_body_start
    raise 'Called abstract method: output_body_start'
  end

  def output_line(line)
    raise 'Called abstract method: output_line'
  end

  def output_body_end
    raise 'Called abstract method: output_body_end'
  end

  def output_end
    raise 'Called abstract method: output_end'
  end
end
```

これで詳細処理を実装したサブクラスを定義できる。

```ruby
class PlainTextReport < Report
  def output_start
  end

  def output_head
    puts("**** #{@title} ****")
  end

  def output_body_start
  end

  def output_line(line)
    puts(line)
  end

  def output_body_end
  end

  def output_end
  end
end
```

```ruby
report = PlainTextReport.new
report.output_report
```
