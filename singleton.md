# Singleton パターン

## 課題
あるクラスのインスタンス1つを、アプリケーション全体を通して使いたい。

## 解決策
**Singleton**パターンではコンストラクターへのアクセスが制限され、インスタンス化できないようにされる。そのためクラス内部でインスタンスの生成が完了し、クラス変数として保持される。アプリケーションからはゲッターを通してアクセスされる。

## 例
ログを記録するクラスの実装を考えよう。

```ruby
class SimpleLogger
  attr_accessor :level

  ERROR = 1
  WARNING = 2
  INFO = 3
  
  def initialize
    @log = File.open("log.txt", "w")
    @level = WARNING
  end

  def error(msg)
    @log.puts(msg)
    @log.flush
  end

  def warning(msg)
    @log.puts(msg) if @level >= WARNING
    @log.flush
  end

  def info(msg)
    @log.puts(msg) if @level >= INFO
    @log.flush
  end
end
```

ログはアプリケーション全体を通して記録されるため、ロガークラスのインスタンスはたった1つ存在するのが合理的だ。`SimpleLogger`クラスを2回以上インスタンス化できないようにするため、コンストラクターをprivateメソッドにする。


```ruby
class SimpleLogger

  # Lots of code deleted...
  @@instance = SimpleLogger.new

  def self.instance
    return @@instance
  end

  private_class_method :new
end

SimpleLogger.instance.info('Computer wins chess game.')
```

`Singleton`モジュールをincludeすることで同じ挙動を実装することができ、複数のsingletonクラスをつくる場合はコードの重複を避けられる。

```ruby
require 'singleton'

class SimpleLogger
  include Singleton
  # Lots of code deleted...
end
```
