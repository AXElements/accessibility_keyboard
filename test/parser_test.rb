# -*- coding: utf-8 -*-
require 'test/helper'
require 'accessibility/keyboard/parser'

class TestParser < MiniTest::Unit::TestCase

  def parse string
    Accessibility::Keyboard::Parser.new(string).parse
  end

  def test_parse_simple_string
    assert_equal [],                                                    parse('')
    assert_equal ['"',"J","u","s","t"," ","W","o","r","k","s",'"',"™"], parse('"Just Works"™')
    assert_equal ["M","i","l","k",","," ","s","h","a","k","e","."],     parse("Milk, shake.")
    assert_equal ["D","B","7"],                                         parse("DB7")
  end

  def test_parse_single_custom_escape
    assert_equal [["\\CMD"]], parse("\\CMD")
    assert_equal [["\\1"]],   parse("\\1")
    assert_equal [["\\F1"]],  parse("\\F1")
    assert_equal [["\\*"]],   parse("\\*")
  end

  def test_parse_hotkey_custom_escape
    assert_equal [["\\COMMAND",[","]]],             parse("\\COMMAND+,")
    assert_equal [["\\COMMAND",["\\SHIFT",["s"]]]], parse("\\COMMAND+\\SHIFT+s")
    assert_equal [["\\COMMAND",["\\+"]]],           parse("\\COMMAND+\\+")
    assert_equal [["\\FN",["\\F10"]]],              parse("\\FN+\\F10")
  end

  def test_parse_ruby_escapes
    assert_equal ["\n","\r","\t","\b"],                                parse("\n\r\t\b")
    assert_equal ["O","n","e","\n","T","w","o"],                       parse("One\nTwo")
    assert_equal ["L","i","e","\b","\b","\b","d","e","l","i","s","h"], parse("Lie\b\b\bdelish")
  end

  def test_parse_compparse_string
    assert_equal ["T","e","s","t",["\\CMD",["s"]]],                          parse("Test\\CMD+s")
    assert_equal ["Z","O","M","G"," ","1","3","3","7","!","!","1"],          parse("ZOMG 1337!!1")
    assert_equal ["F","u","u","!","@","#","%",["\\CMD",["a"]],"\b"],         parse("Fuu!@#%\\CMD+a \b")
    assert_equal [["\\CMD",["a"]],"\b","A","l","l"," ","g","o","n","e","!"], parse("\\CMD+a \bAll gone!")
  end

  def test_parse_backslash # make sure we handle these edge cases predictably
    assert_equal ["\\"],             parse("\\")
    assert_equal ["\\"," "],         parse("\\ ")
    assert_equal ["\\","h","m","m"], parse("\\hmm")
    assert_equal [["\\HMM"]],        parse("\\HMM") # the one missed case
  end

  def test_parse_plus_escape
    assert_equal [["\\+"]], parse("\\+")
  end

  def test_parse_bad_custom_escape_sequence
    assert_raises ArgumentError do
      parse("\\COMMAND+")
    end
  end

end
