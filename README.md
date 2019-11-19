# Design Patterns in Ruby (Rubyによるデザインパターン)

[Design Patterns in Ruby](http://designpatternsinruby.com/)で紹介されているデザインパターンのまとめ。著者の[Russ Olsen](http://russolsen.com/)は、Rubyに合わせて、オリジナルのGoFデザインパターン23個のうち14個を記述している。

## デザインパターン

### GoFのデザインパターン

* [Adapter](adapter.md): 2つの異なるインターフェイスが一緒に作用するのを可能にする。
* [Builder](builder.md): 設定の難しい複雑なオブジェクトをつくる。
* [Command](command.md): リクエストの受け手について一切知ることなく、特定のタスクを実行したい。
* [Composite](composite.md): オブジェクト群をツリー構造で構築する。すべてのオブジェクトは同じ方法で相互作用する。
* [Decorator](decorator.md): オブジェクトの責務にバリエーションを加え、機能を追加する。
* [Factory](factory.md): 生成するオブジェクトのクラスを指定することなく、オブジェクトを生成する。
* [Interpreter](interpreter.md): よく定義された問題を解決するための特化言語を提供する。
* [Iterator](iterator.md): 内部表現を外部に晒すことなく、サブオブジェクトのコレクションにアクセスする方法を提供する。
* [Observer](observer.md): 高度に統合されたシステムを構築する。メンテナンスしやすくクラス同士の密結合を避ける。
* [Proxy](proxy.md): あるオブジェクトにアクセスする方法とその場面をよりコントロールする。
* [Singleton](singleton.md): あるクラスのインスタンス1つを、アプリケーション全体を通して使う。
* [Strategy](strategy.md): アルゴリズムの一部にバリエーションを加える。
* [Template Method](template_method.md): その構造を変更することなく、アルゴリズムのある段階を再定義する。

### GoF以外のデザインパターン: Rubyのためのデザインパターン

* [Convention Over Configuration](convention_over_configuration.md): build an extensible system and not carrying the configuration burden.
* [Domain-Specific Language](dsl.md): build a convenient syntax for solving problems of a specific domain.
* [Meta-Programming](meta_programming.md): gain more flexibility when defining new classes and create custom tailored objects on the fly.

## Contributing

[Contributing](https://github.com/davidgf/design-patterns-in-ruby#contributing)参照。
