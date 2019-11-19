# Command パターン

## 課題
全体の処理やリクエストの受け手について一切知ることなく、特定のタスクを実行したい。

## 解決策
Command パターンは、あるタスクを実行する必要のあるオブジェクトと、そのタスクの実行方法を知っているオブジェクトを、切り離す。受け手、呼び出すメソッド、パラメーターなど、そのタスクを実行するのに必要なすべての情報を、Commandオブジェクト内にカプセル化する。そうすれば、タスクを実行したい一切のオブジェクトは、Commandオブジェクトのインターフェイスについて知っているだけでよい。

## 例
あるGUIフレームワークのボタン実装を考えてみよう。ボタンがクリックされたときに呼ばれるメソッドをもっている。

```ruby
class SlickButton

  # Lots of button drawing and management
  # code omitted...

  def on_button_push
    # Do something when the button is pushed
  end
end
```

ユーザーがボタンをクリックしたときに特定のアクションを実行する `on_button_push` メソッドをオーバーライドすることで、このボタンクラスを拡張できる。例えば、もしドキュメントを保存したいならこんな感じだ。

```ruby
class SaveButton < SlickButton
  def on_button_push
    # Save the current document...
  end
end
```

しかし複雑なGUIはとても多くのボタンをもつ。つまり数百ものボタンサブクラスをもつことになるのである。もっと簡単なやり方がある。アクションを実行するコードを、それ自身のオブジェクトとして切り出し、そしてそのオブジェクトはシンプルなインターフェイスを実装するのである。ではボタン実装をリファクタリングしよう。Commandオブジェクトをパラメーターとして受け取って、クリックされた時に呼び出すのだ。

```ruby
class SaveCommand
  def execute
    # Save the current document...
  end
end

class SlickButton
  attr_accessor :command

  def initialize(command)
    @command = command
  end

  def on_button_push
    @command.execute if @command
  end
end

save_button = SlickButton.new(SaveCommand.new)
```

戻す機能 (**undo** feature) を実装したとき、Command パターンはとても有用だ。`unexecute` メソッドをCommandオブジェクトに実装するだけだ。例えば、ファイル作成の実装はこんな感じだ。

```ruby
class CreateFile < Command
  def initialize(path, contents)
    super "Create file: #{path}"
    @path = path
    @contents = contents
  end

  def execute
    f = File.open(@path, "w")
    f.write(@contents)
    f.close
  end

  def unexecute
    File.delete(@path)
  end
end
```

インストールプログラムでも Command パターンがとても便利だ。**Composite** パターンと組み合わせて、実行するタスクのリストを格納できる。

```ruby
class CompositeCommand < Command
  def initialize
    @commands = []
  end

  def add_command(cmd)
    @commands << cmd
  end

  def execute
    @commands.each {|cmd| cmd.execute}
  end
end

cmds = CompositeCommand.new
cmds.add_command(CreateFile.new('file1.txt', "hello world\n"))
cmds.add_command(CopyFile.new('file1.txt', 'file2.txt'))
cmds.add_command(DeleteFile.new('file1.txt'))
```
