require 'accessibility/keyboard/version'
require 'accessibility/keyboard/parser'
require 'accessibility/keyboard/event_generator'


##
# Parses strings of human readable text into a series of events meant to
# be processed by {Accessibility::Core#post} or {KeyCoder.post_event}.
#
# Supports most, if not all, latin keyboard layouts, maybe some
# international layouts as well. Japanese layouts can be made to work with
# use of `String#transform`.
#
# @example
#
#   app = AXUIElementCreateApplication(3456)
#   include Accessibility::String
#   app.post keyboard_events_for "Hello, world!\n"
#
module Accessibility::Keyboard

  ##
  # Generate keyboard events for the given string. Strings should be in a
  # human readable with a few exceptions. Command key (e.g. control, option,
  # command) should be written in string as they appear in
  # {Accessibility::String::EventGenerator::CUSTOM}.
  #
  # For more details on event generation, read the
  # [Keyboarding wiki](http://github.com/Marketcircle/AXElements/wiki/Keyboarding).
  #
  # @param string [#to_s]
  # @return [Array<Array(Fixnum,Boolean)>]
  def keyboard_events_for string
    EventGenerator.new(Parser.new(string).parse).generate
  end

end
