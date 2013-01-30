# encoding: UTF-8

require 'accessibility/keyboard/version'
require 'accessibility/key_coder'

##
# Generate a sequence of keyboard events given a sequence of tokens.
# The token format is defined by the
# {Accessibility::Keyboard::EventGenerator}
# class output; it is best to use that class to generate the tokens.
#
# @example
#
#   # Upper case 'A'
#   EventGenerator.new(["A"]).generate  # => [[56,true],[70,true],[70,false],[56,false]]
#
#   # Press the volume up key
#   EventGenerator.new([["\\F12"]]).generate # => [[0x6F,true],[0x6F,false]]
#
#   # Hotkey, press and hold command key and then 'a', then release both
#   EventGenerator.new([["\\CMD",["a"]]]).generate # => [[55,true],[70,true],[70,false],[55,false]]
#
#   # Press the return/enter key
#   EventGenerator.new(["\n"]).generate # => [[10,true],[10,false]]
#
class Accessibility::Keyboard::EventGenerator

  ##
  # Regenerate the portion of the key mapping that is set dynamically
  # based on keyboard layout (e.g. US, Dvorak, etc.).
  #
  # This method should be called whenever the keyboard layout changes.
  # This can be called automatically by registering for a notification
  # in a run looped environment.
  def self.regenerate_dynamic_mapping
    # KeyCoder is declared in the Objective-C extension
    MAPPING.merge! KeyCoder.dynamic_mapping
    # Also add an alias to the mapping
    MAPPING["\n"] = MAPPING["\r"]
  end

  ##
  # Dynamic mapping of characters to keycodes. The map is generated at
  # startup time in order to support multiple keyboard layouts.
  #
  # @return [Hash{String=>Fixnum}]
  MAPPING = {}

  # Initialize the table
  regenerate_dynamic_mapping

  ##
  # @note These mappings are all static and come from `/System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/HIToolbox.framework/Versions/A/Headers/Events.h`
  #
  # Map of custom escape sequences to their hardcoded keycode value.
  #
  # @return [Hash{String=>Fixnum}]
  CUSTOM = {
            "\\FUNCTION"      => 0x3F,      # Standard Control Keys
            "\\FN"            => 0x3F,
            "\\CONTROL"       => 0x3B,
            "\\CTRL"          => 0x3B,
            "\\OPTION"        => 0x3A,
            "\\OPT"           => 0x3A,
            "\\ALT"           => 0x3A,
            "\\COMMAND"       => 0x37,
            "\\CMD"           => 0x37,
            "\\LSHIFT"        => 0x38,
            "\\SHIFT"         => 0x38,
            "\\CAPSLOCK"      => 0x39,
            "\\CAPS"          => 0x39,
            "\\ROPTION"       => 0x3D,
            "\\ROPT"          => 0x3D,
            "\\RALT"          => 0x3D,
            "\\RCONTROL"      => 0x3E,
            "\\RCTRL"         => 0x3E,
            "\\RSHIFT"        => 0x3C,
            "\\ESCAPE"        => 0x35,      # Top Row Keys
            "\\ESC"           => 0x35,
            "\\VOLUMEUP"      => 0x48,
            "\\VOLUP"         => 0x48,
            "\\VOLUMEDOWN"    => 0x49,
            "\\VOLDOWN"       => 0x49,
            "\\MUTE"          => 0x4A,
            "\\F1"            => 0x7A,
            "\\F2"            => 0x78,
            "\\F3"            => 0x63,
            "\\F4"            => 0x76,
            "\\F5"            => 0x60,
            "\\F6"            => 0x61,
            "\\F7"            => 0x62,
            "\\F8"            => 0x64,
            "\\F9"            => 0x65,
            "\\F10"           => 0x6D,
            "\\F11"           => 0x67,
            "\\F12"           => 0x6F,
            "\\F13"           => 0x69,
            "\\F14"           => 0x6B,
            "\\F15"           => 0x71,
            "\\F16"           => 0x6A,
            "\\F17"           => 0x40,
            "\\F18"           => 0x4F,
            "\\F19"           => 0x50,
            "\\F20"           => 0x5A,
            "\\HELP"          => 0x72,      # Island Keys
            "\\HOME"          => 0x73,
            "\\END"           => 0x77,
            "\\PAGEUP"        => 0x74,
            "\\PAGEDOWN"      => 0x79,
            "\\DELETE"        => 0x75,
            "\\LEFT"          => 0x7B,      # Arrow Keys
            "\\<-"            => 0x7B,
            "\\RIGHT"         => 0x7C,
            "\\->"            => 0x7C,
            "\\DOWN"          => 0x7D,
            "\\UP"            => 0x7E,
            "\\0"             => 0x52,      # Keypad Keys
            "\\1"             => 0x53,
            "\\2"             => 0x54,
            "\\3"             => 0x55,
            "\\4"             => 0x56,
            "\\5"             => 0x57,
            "\\6"             => 0x58,
            "\\7"             => 0x59,
            "\\8"             => 0x5B,
            "\\9"             => 0x5C,
            "\\DECIMAL"       => 0x41,
            "\\."             => 0x41,
            "\\PLUS"          => 0x45,
            "\\+"             => 0x45,
            "\\MULTIPLY"      => 0x43,
            "\\*"             => 0x43,
            "\\MINUS"         => 0x4E,
            "\\-"             => 0x4E,
            "\\DIVIDE"        => 0x4B,
            "\\/"             => 0x4B,
            "\\EQUALS"        => 0x51,
            "\\="             => 0x51,
            "\\ENTER"         => 0x4C,
            "\\CLEAR"         => 0x47,
           }

  ##
  # Mapping of shifted (characters written when holding shift) characters
  # to keycodes.
  #
  # @return [Hash{String=>Fixnum}]
  SHIFTED = {
             '~'               => '`',
             '!'               => '1',
             '@'               => '2',
             '#'               => '3',
             '$'               => '4',
             '%'               => '5',
             '^'               => '6',
             '&'               => '7',
             '*'               => '8',
             '('               => '9',
             ')'               => '0',
             '{'               => '[',
             '}'               => ']',
             '?'               => '/',
             '+'               => '=',
             '|'               => "\\",
             ':'               => ';',
             '_'               => '-',
             '"'               => "'",
             '<'               => ',',
             '>'               => '.',
             'A'               => 'a',
             'B'               => 'b',
             'C'               => 'c',
             'D'               => 'd',
             'E'               => 'e',
             'F'               => 'f',
             'G'               => 'g',
             'H'               => 'h',
             'I'               => 'i',
             'J'               => 'j',
             'K'               => 'k',
             'L'               => 'l',
             'M'               => 'm',
             'N'               => 'n',
             'O'               => 'o',
             'P'               => 'p',
             'Q'               => 'q',
             'R'               => 'r',
             'S'               => 's',
             'T'               => 't',
             'U'               => 'u',
             'V'               => 'v',
             'W'               => 'w',
             'X'               => 'x',
             'Y'               => 'y',
             'Z'               => 'z',
            }

  ##
  # Mapping of optioned (characters written when holding option/alt)
  # characters to keycodes.
  #
  # @return [Hash{String=>Fixnum}]
  OPTIONED = {
              '¡'               => '1',
              '™'               => '2',
              '£'               => '3',
              '¢'               => '4',
              '∞'               => '5',
              '§'               => '6',
              '¶'               => '7',
              '•'               => '8',
              'ª'               => '9',
              'º'               => '0',
              '“'               => '[',
              '‘'               => ']',
              'æ'               => "'",
              '≤'               => ',',
              '≥'               => '.',
              'π'               => 'p',
              '¥'               => 'y',
              'ƒ'               => 'f',
              '©'               => 'g',
              '®'               => 'r',
              '¬'               => 'l',
              '÷'               => '/',
              '≠'               => '=',
              '«'               => "\\",
              'å'               => 'a',
              'ø'               => 'o',
              '´'               => 'e',
              '¨'               => 'u',
              'ˆ'               => 'i',
              '∂'               => 'd',
              '˙'               => 'h',
              '†'               => 't',
              '˜'               => 'n',
              'ß'               => 's',
              '–'               => '-',
              '…'               => ';',
              'œ'               => 'q',
              '∆'               => 'j',
              '˚'               => 'k',
              '≈'               => 'x',
              '∫'               => 'b',
              'µ'               => 'm',
              '∑'               => 'w',
              '√'               => 'v',
              'Ω'               => 'z',
             }


  ##
  # Once {#generate} is called, this contains the sequence of
  # events.
  #
  # @return [Array<Array(Fixnum,Boolean)>]
  attr_reader :events

  # @param tokens [Array<String,Array<String,Array...>>]
  def initialize tokens
    @tokens = tokens
    # *3 since the output array will be at least *2 the
    # number of tokens passed in, but will often be larger
    # due to shifted/optioned characters and custom escapes;
    # though a better number could be derived from
    # analyzing common input...
    @events = Array.new tokens.size*3
  end

  ##
  # Generate the events for the tokens the event generator
  # was initialized with. Returns the generated events, though
  # you can also use {#events} to get the events later.
  #
  # @return [Array<Array(Fixnum,Boolean)>]
  def generate
    @index = 0
    gen_all @tokens
    @events.compact!
    @events
  end


  private

  def add event
    @events[@index] = event
    @index += 1
  end
  def previous_token; @events[@index-1] end
  def rewind_index;   @index -= 1       end

  def gen_all tokens
    tokens.each do |token|
      if token.kind_of? Array
        gen_nested token.first, token[1..-1]
      else
        gen_single token
      end
    end
  end

  def gen_nested head, tail
    ((code =   CUSTOM[head]) &&  gen_dynamic(code, tail)) ||
     ((code =  MAPPING[head]) &&  gen_dynamic(code, tail)) ||
     ((code =  SHIFTED[head]) &&  gen_shifted(code, tail)) ||
     ((code = OPTIONED[head]) && gen_optioned(code, tail)) ||
     gen_all(head.split(EMPTY_STRING)) # handling a special case :(
  end

  def gen_single token
    ((code =  MAPPING[token]) &&  gen_dynamic(code, nil)) ||
     ((code =  SHIFTED[token]) &&  gen_shifted(code, nil)) ||
     ((code = OPTIONED[token]) && gen_optioned(code, nil)) ||
     raise(ArgumentError, "#{token.inspect} has no mapping, bail!")
  end

  def gen_shifted code, tail
    previous_token == SHIFT_UP ? rewind_index : add(SHIFT_DOWN)
    gen_dynamic MAPPING[code], tail
    add SHIFT_UP
  end

  def gen_optioned code, tail
    previous_token == OPTION_UP ? rewind_index : add(OPTION_DOWN)
    gen_dynamic MAPPING[code], tail
    add OPTION_UP
  end

  def gen_dynamic code, tail
    add [code,  true]
    gen_all tail if tail
    add [code, false]
  end

  # @private
  # @return [String]
  EMPTY_STRING = ""
  # @private
  # @return [Array(Number,Boolean)]
  OPTION_DOWN  = [58,  true]
  # @private
  # @return [Array(Number,Boolean)]
  OPTION_UP    = [58, false]
  # @private
  # @return [Array(Number,Boolean)]
  SHIFT_DOWN   = [56,  true]
  # @private
  # @return [Array(Number,Boolean)]
  SHIFT_UP     = [56, false]
end
