require 'accessibility/keyboard/version'

##
# Parse arbitrary strings into a stream of keyboard events
#
# This class will take a string and break it up into chunks for the keyboard
# event generator. The structure generated here is an array that contains
# strings and recursively other arrays of strings and arrays of strings.
#
# @example
#
#   Parser.new("Hai").lex          # => ['H','a','i']
#   Parser.new("\\CONTROL").lex    # => [["\\CONTROL"]]
#   Parser.new("\\COMMAND+a").lex  # => [["\\COMMAND", ['a']]]
#   Parser.new("One\nTwo").lex     # => ['O','n','e',"\n",'T','w','o']
#
class Accessibility::Keyboard::Parser

  ##
  # Once a string is parsed, this contains the tokenized structure.
  #
  # @return [Array<String,Array<String,...>]
  attr_accessor :tokens

  # @param string [String,#to_s]
  def initialize string
    @chars  = string.to_s
    @tokens = []
  end

  ##
  # Tokenize the string that the lexer was initialized with and
  # return the sequence of tokens that were lexed.
  #
  # @return [Array<String,Array<String,...>]
  def parse
    length = @chars.length
    @index = 0
    while @index < length
      @tokens << if custom?
                   lex_custom
                 else
                   lex_char
                 end
      @index += 1
    end
    @tokens
  end


  private

  ##
  # Is it a real custom escape? Kind of a lie, there is one
  # case it does not handle--they get handled in the generator,
  # but maybe they should be handled here?
  # - An upper case letter or symbol following `"\\"` that is
  #   not mapped
  def custom?
    @chars[@index] == CUSTOM_ESCAPE &&
     (next_char = @chars[@index+1]) &&
     next_char == next_char.upcase &&
     next_char != SPACE
  end

  # @todo refactor
  # @return [Array]
  def lex_custom
    start = @index
    loop do
      char = @chars[@index]
      if char == PLUS
        if @chars[@index-1] == CUSTOM_ESCAPE # \\+ case
          @index += 1
          return custom_subseq start
        else
          tokens  = custom_subseq start
          @index += 1
          return tokens << lex_custom
        end
      elsif char == SPACE
        return custom_subseq start
      elsif char == nil
        raise ArgumentError, "Bad escape sequence" if start == @index
        return custom_subseq start
      else
        @index += 1
      end
    end
  end

  # @return [Array]
  def custom_subseq start
    [@chars[start...@index]]
  end

  # @return [String]
  def lex_char
    @chars[@index]
  end

  # @private
  # @return [String]
  SPACE         = " "
  # @private
  # @return [String]
  PLUS          = "+"
  # @private
  # @return [String]
  CUSTOM_ESCAPE = "\\"
end
