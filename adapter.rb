# Takes two open files (a read and a writer),
# and encrypts a file.
class Encrypter
  def initialize(key)
    @key = key
  end

  def encrypt(reader, writer)
    key_index = 0
    while not reader.eof?
      clear_char = reader.getc
      encrypted_char = clear_char ^ @key[key_index] # bitwise XOR calculation
      writer.putc(encrypted_char)
      key_index = (key_index + 1) % @key.size
    end
  end
end

# context:
# The data we want to secure happens to be in a STRING, rather than in a FILE.

# adapter class of Encrypter
class StringIOAdapter
  def initialize(string)
    @string = string
    @position = 0
  end

  def getc
    if @position >= @string.length
      raise EOFError
    end
    char = @string[@position]
    @position += 1
    char
  end

  def eof?
    @position >= @string.length
  end
end

encrypter = Encrypter.new('abcxyz')
reader = StringIOAdapter.new('Some private message to your lover')
writer = File.open('enc.txt', 'w')
encrypter.encrypt(reader, writer)
