# Strategy パターン

## 課題
アルゴリズムの一部にバリエーションを加えたい。これは以前にTemplateMethodパターンを使って解決したものだが、その中心に継承をおいたことによる欠点を避けたい。

## 解決策
継承による問題を避けるために委譲を使おう。つまり (TemplateMethodパターンのように) サブクラスを生成する代わりに、コードのなかのバリエーションの必要な部分を切り離し、バリエーションごとに独立してクラスを生成する。Strategyパターンのキーとなる考え方は、オブジェクト群 (strategies) のファミリーを定義し、(ほぼ) 同じ挙動をさせて同じインターフェイスをもたせるというものだ。そしてstrategyを使う側 (context) は、内部変化する部品としてstrategyをあつかう。

## 例
TemplateMethodパターンの例にしたがって、コードをリファクタリングしよう。TemplateMethodパターンのようにサブクラスではなく、各フォーマットがクラス (strategy) となるように。このやり方でReportクラスはよりシンプルになる。Reportクラスはcontextオブジェクトの役割をはたし、strategyオブジェクトに渡させる。


```ruby
class Report
  attr_reader :title, :text
  attr_accessor :formatter

  def initialize(formatter)
    @title = 'Monthly Report'
    @text = ['Things are going', 'really, really well.']
    @formatter = formatter
  end

  def output_report
    @formatter.output_report(self)
  end
end
```

各フォーマットの実装はそれぞれの独自クラスに定義し、関心の分離をより実現できる。

```ruby
class HTMLFormatter
  def output_report(context)
    puts('<html>')
    puts(' <head>')
    puts("<title>#{context.title}</title>")
    puts(' </head>')
    puts(' <body>')
    context.text.each do |line|
      puts("<p>#{line}</p>")
    end
    puts(' </body>')
    puts('</html>')
  end
end

class PlainTextFormatter
  def output_report(context)
    puts("***** #{context.title} *****")
    context.text.each do |line|
      puts(line)
    end
  end
end
```

これで、Formatterオブジェクト (strategy) をReportオブジェクト (context) に渡せばよい。

```ruby
report = Report.new(HTMLFormatter.new)
report.output_report

report.formatter = PlainTextFormatter.new
report.output_report
```
