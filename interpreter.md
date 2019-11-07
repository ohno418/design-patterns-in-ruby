# Interpreter パターン

## 課題
よく定義された問題を解決するための特化言語がほしい。

## 解決策
インタープリターは通常2つの段階で作用する。**パース** と **評価** だ。パーサーはデータを読み込み、**抽象構文木(AST)** と呼ばれるデータ構造をつくる。ASTは元データと同じ情報を保持するが、木構造で表現される。次にASTは外部条件に対して評価される。ASTでは、リーフノード (**terminal**) はこの言語において最も基本となるブロックだ。リーフでないノード (**nonterminal**) はこの言語において高次のオーダーコンセプトを表現する。外部条件 (**context**) が与えられた後、ASTは再帰的に評価される。

## 例
シンプルなクエリ言語によるファイル検索ツールを考えよう。最も基本となる操作はすべてのファイルを返すものだ。実装は以下のような感じだろう。

```ruby
require 'find'

class Expression
  # Common expression code will go here soon...
end

class All < Expression
  def evaluate(dir)
    results= []
    Find.find(dir) do |p|
      next unless File.file?(p)
      results << p
    end
    results
  end
end
```

また、特定のパターンに合う名前のファイルを取得する必要がある。

```ruby
class FileName < Expression
  def initialize(pattern)
    @pattern = pattern
  end

  def evaluate(dir)
    results= []
    Find.find(dir) do |p|
      next unless File.file?(p)
      name = File.basename(p)
      results << p if File.fnmatch(@pattern, name)
    end
    results
  end
end

expr_all = All.new
files = expr_all.evaluate('test_dir')
```

あたえられたサイズより大きいファイルを探したり、書き込み可能なファイルを探す機能もある。

```ruby
class Bigger < Expression
  def initialize(size)
    @size = size
  end

  def evaluate(dir)
    results = []
    Find.find(dir) do |p|
      next unless File.file?(p)
      results << p if( File.size(p) > @size)
    end
    results
  end
end

class Writable < Expression
  def evaluate(dir)
    results = []
    Find.find(dir) do |p|
      next unless File.file?(p)
      results << p if( File.writable?(p) )
    end
    results
  end
end
```

これらの基本操作はASTの**terminal**だ。最初の**nonterminal**をつくってみよう。特定の操作を打ち消すものだ。

```ruby
class Not < Expression
  def initialize(expression)
    @expression = expression
  end

  def evaluate(dir)
    All.new.evaluate(dir) - @expression.evaluate(dir)
  end
end
```

これで書き込み不可能なファイルを探すことができる。例えば

```ruby
expr_not_writable = Not.new( Writable.new )
readonly_files = expr_not_writable.evaluate('test_dir')
```

操作を打ち消すのでなく、2つの操作結果を組み合わせたり、2つの条件に合うファイル群を取得したい場合、**OR** や **AND** といったnonterminalをつくることができる。

```ruby
class Or < Expression
  def initialize(expression1, expression2)
    @expression1 = expression1
    @expression2 = expression2
  end

  def evaluate(dir)
    result1 = @expression1.evaluate(dir)
    result2 = @expression2.evaluate(dir)
    (result1 + result2).sort.uniq
  end
end

class And < Expression
  def initialize(expression1, expression2)
    @expression1 = expression1
    @expression2 = expression2
  end

  def evaluate(dir)
    result1 = @expression1.evaluate(dir)
    result2 = @expression2.evaluate(dir)
    (result1 & result2)
  end
end

big_or_mp3_expr = Or.new( Bigger.new(1024), FileName.new('*.mp3') )
big_or_mp3s = big_or_mp3_expr.evaluate('test_dir')
```

**Interpreter**パターンもまた、**Composite**パターンを実装していることに気づいたかもしれない。新しい操作の追加や既存操作の組み合わせが柔軟にできるのである。

```ruby
complex_expression = And.new(
                      And.new(Bigger.new(1024), FileName.new('*.mp3')),
                      Not.new(Writable.new))
complex_expression.evaluate('test_dir')
```
