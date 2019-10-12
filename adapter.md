# Adapter パターン

## 課題
あるオブジェクトと他のオブジェクトを通信させたいが、インターフェイスが合わない。

## 解決策
既存のクラス (**adaptee**クラス) をラッピングする、**adapter**クラスをつくる。このクラスは、呼び出し元のオブジェクトが理解できるようなインターフェイスを実装する。一方で実際の処理は、既存のadapteeクラスのオブジェクトがすべて行う。

## 例
開かれたFileオブジェクト2つ (reader と writer) を取り、ファイルを暗号化するクラスを考えてみよう。

```ruby
class Encrypter
  def initialize(key)
    @key = key
  end

  def encrypt(reader, writer)
    key_index = 0
    while not reader.eof?
      clear_char = reader.getc
      encrypted_char = clear_char ^ @key[key_index]
      writer.putc(encrypted_char)
      key_index = (key_index + 1) % @key.size
    end
  end
end
```

しかし、もし暗号化したいデータが、ファイルではなく文字列だったら？開かれたFileオブジェクトかのように振る舞うオブジェクトが必要だ。言い換えると、Rubyの `IO` オブジェクトと同じインターフェイスをもつオブジェクトが必要である。このために `StringIOAdapter` をつくろう。

```ruby
class StringIOAdapter
  def initialize(string)
    @string = string
    @position = 0
  end

  def getc
    if @position >= @string.length
      raise EOFError
    end
    ch = @string[@position]
    @position += 1
    return ch
  end

  def eof?
    return @position >= @string.length
  end
end
```

これでファイルかのように `String` を使えるようになった。 (`IO` のインターフェイスのうち、本当に必要な部分を少し実装しただけだ。)

```ruby
encrypter = Encrypter.new('XYZZY')
reader = StringIOAdapter.new('We attack at dawn')
writer = File.open('out.txt', 'w')
encrypter.encrypt(reader, writer)
```
