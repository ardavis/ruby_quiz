class Solitaire

  attr_accessor :phrase, :keystream, :message1, :message2, :sum_message, :encryption

  def initialize(phrase: 'Passphrase')
    @phrase = phrase
  end

  def to_s
    @phrase
  end

  def encrypt
    simplify
    generate_keystream
    @message1 = @phrase.to_numeric_message
    @message2 = @keystream.to_numeric_message
    @sum_message = [@message1, @message2].transpose.map{|x| x.reduce :+}.under_26_only
    @encryption = @sum_message.to_alpha_message
  end

  # Discard any non A to Z characters, and uppercase all remaining characters.
  # Split the message into five character groups, using Xs to pad the last group, if needed.
  def simplify
    @phrase.upcase!
    @phrase.remove_non_word_characters!
    @phrase.append_xs!
    @phrase.split_into_groups_of_five!
  end

  def generate_keystream
    @keystream = 'CLEPK HHNIY CFPWH FDFEH'
  end

end

class Array

  def under_26_only
    array = []
    self.each do |num|
      number = num
      number = num - 26 if number > 26
      array << number
    end
    array
  end

  def to_alpha_message
    string = ''
    self.each_with_index do |num, i|
      string << number_to_letter(num)
      string << ' ' if (i+1) % 5 == 0
    end
    string.strip
  end

  def number_to_letter(n)
    n.to_s(27).tr("0-9a-q", "A-Z")
  end
end

class String

  def remove_non_word_characters!
    gsub!(/\W/, '')
  end

  def append_xs!
    self << 'X' until size % 5 == 0
  end

  def split_into_groups_of_five!
    replace scan(/.{5}/).to_a.join(' ')
  end

  def to_numeric_message
    array = []
    self.split('').each do |char|
      array << ('A'..'Z').to_a.index(char)
    end
    array.compact
  end

end


# Execution
solitaire = Solitaire.new(phrase: 'Code in Ruby, live longer!')
solitaire.encrypt
puts solitaire.encryption.inspect