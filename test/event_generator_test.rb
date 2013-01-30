# -*- coding: utf-8 -*-
require 'test/helper'
require 'accessibility/keyboard/event_generator'

class TestEventGenerator < MiniTest::Unit::TestCase

  def gen tokens
    Accessibility::Keyboard::EventGenerator.new(tokens).generate
  end

  def map; @@map ||= KeyCoder.dynamic_mapping; end

  def t; true; end
  def f; false; end

  def a; @@a ||= map['a']; end
  def c; @@c ||= map['c']; end
  def e; @@e ||= map['e']; end
  def h; @@h ||= map['h']; end
  def i; @@i ||= map['i']; end
  def k; @@k ||= map['k']; end
  def m; @@m ||= map["m"]; end

  def two;  @@two  ||= map['2']; end
  def four; @@four ||= map['4']; end

  def retern; @@retern ||= map["\r"]; end
  def tab;    @@tab    ||= map["\t"]; end
  def space;  @@space  ||= map["\s"]; end

  def dash;  @@dash  ||= map["-"]; end
  def comma; @@comma ||= map[","]; end
  def apos;  @@apos  ||= map["'"]; end
  def at;    @@at    ||= map["2"]; end
  def paren; @@paren ||= map["9"]; end
  def chev;  @@chev  ||= map["."]; end

  def sigma; @@sigma ||= map["w"]; end
  def tm;    @@tm    ||= map["2"]; end
  def gbp;   @@gbp   ||= map["3"]; end
  def omega; @@omega ||= map["z"]; end

  def bslash; @@blash ||= map["\\"]; end

  # key code for the left shift key
  def sd; [56,t];  end
  def su; [56,f]; end

  # key code for the left option key
  def od; [58,t];  end
  def ou; [58,f]; end

  # key code for the left command key
  def cd; [0x37,t]; end
  def cu; [0x37,f]; end

  # key code for right arrow key
  def rd; [0x7c,t]; end
  def ru; [0x7c,f]; end

  # key code for left control key
  def ctrld; [0x3B,t]; end
  def ctrlu; [0x3B,f]; end


  def test_generate_lowercase
    assert_equal [[a,t],[a,f]],                                     gen(['a'])
    assert_equal [[c,t],[c,f],[k,t],[k,f]],                         gen(['c','k'])
    assert_equal [[e,t],[e,f],[e,t],[e,f]],                         gen(['e','e'])
    assert_equal [[c,t],[c,f],[a,t],[a,f],[k,t],[k,f],[e,t],[e,f]], gen(['c','a','k','e'])
  end

  def test_generate_uppercase
    assert_equal [sd,[a,t],[a,f],su],                         gen(['A'])
    assert_equal [sd,[c,t],[c,f],[k,t],[k,f],su],             gen(['C','K'])
    assert_equal [sd,[e,t],[e,f],[e,t],[e,f],su],             gen(['E','E'])
    assert_equal [sd,[c,t],[c,f],[a,t],[a,f],[k,t],[k,f],su], gen(['C','A','K'])
  end

  def test_generate_numbers
    assert_equal [[two,t],[two,f]],                   gen(['2'])
    assert_equal [[four,t],[four,f],[two,t],[two,f]], gen(['4','2'])
    assert_equal [[two,t],[two,f],[two,t],[two,f]],   gen(['2','2'])
  end

  def test_generate_ruby_escapes
    assert_equal [[retern,t],[retern,f]], gen(["\r"])
    assert_equal [[retern,t],[retern,f]], gen(["\n"])
    assert_equal [[tab,t],[tab,f]],       gen(["\t"])
    assert_equal [[space,t],[space,f]],   gen(["\s"])
    assert_equal [[space,t],[space,f]],   gen([" "])
  end

  def test_generate_symbols
    assert_equal [[dash,t],[dash,f]],         gen(["-"])
    assert_equal [[comma,t],[comma,f]],       gen([","])
    assert_equal [[apos,t],[apos,f]],         gen(["'"])
    assert_equal [sd,[at,t],[at,f],su],       gen(["@"])
    assert_equal [sd,[paren,t],[paren,f],su], gen(["("])
    assert_equal [sd,[chev,t],[chev,f],su],   gen([">"])
  end

  def test_generate_unicode # holding option
    assert_equal [od,[sigma,t],[sigma,f],ou],           gen(["∑"])
    assert_equal [od,[tm,t],[tm,f],ou],                 gen(["™"])
    assert_equal [od,[gbp,t],[gbp,f],ou],               gen(["£"])
    assert_equal [od,[omega,t],[omega,f],ou],           gen(["Ω"])
    assert_equal [od,[tm,t],[tm,f],[gbp,t],[gbp,f],ou], gen(["™","£"])
  end

  def test_generate_backslashes
    assert_equal [[bslash,t],[bslash,f]],                               gen(["\\"])
    assert_equal [[bslash,t],[bslash,f],[space,t],[space,f]],           gen(["\\"," "])
    assert_equal [[bslash,t],[bslash,f],[h,t],[h,f],[m,t],[m,f]],       gen(["\\",'h','m'])
    # is this the job of the parser or the lexer?
    assert_equal [[bslash,t],[bslash,f],sd,[h,t],[h,f],[m,t],[m,f],su], gen([["\\HM"]])
  end

  def test_generate_a_custom_escape
    assert_equal [cd,cu],       gen([["\\COMMAND"]])
    assert_equal [cd,cu],       gen([["\\CMD"]])
    assert_equal [ctrld,ctrlu], gen([["\\CONTROL"]])
    assert_equal [ctrld,ctrlu], gen([["\\CTRL"]])
  end

  def test_generate_hotkey
    assert_equal [ctrld,[a,t],[a,f],ctrlu], gen([["\\CONTROL",["a"]]])
    assert_equal [cd,sd,rd,ru,su,cu],       gen([["\\COMMAND",['\SHIFT',['\->']]]])
  end

  def test_generate_real_use # a regression
    assert_equal [ctrld,[a,t],[a,f],ctrlu,[h,t],[h,f]], gen([["\\CTRL",["a"]],"h"])
  end

  def test_bails_for_unmapped_token
    # cannot generate snowmen :(
    e = assert_raises(ArgumentError) { gen(["☃"]) }
    assert_match /bail/i, e.message
  end

  def test_generate_arbitrary_nested_array_sequence
    assert_equal [[c,t],[a,t],[k,t],[e,t],[e,f],[k,f],[a,f],[c,f]], gen([["c",["a",["k",["e"]]]]])
  end

  def test_generate_command_A
    assert_equal [cd,sd,[a,t],[a,f],su,cu], gen([["\\COMMAND",["A"]]])
  end

end
