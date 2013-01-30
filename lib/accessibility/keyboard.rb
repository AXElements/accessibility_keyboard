require 'accessibility/keyboard/version'
require 'accessibility/keyboard/parser'
require 'accessibility/keyboard/event_generator'


##
# Parses strings of human readable text into a series of events
#
# Events are meant to be processed by {KeyCoder.post_event} or
# [Accessibility::Core#post](https://github.com/AXElements/accessibility_core/blob/master/lib/accessibility/core/macruby.rb#L597).
#
# Supports most, if not all, latin keyboard layouts, maybe some
# international layouts as well. Japanese layouts can be made to work with
# use of `String#transform` on MacRuby. See README for examples.
#
module Accessibility::Keyboard

  ##
  # Generate keyboard events for the given string
  #
  # Strings should be in a human readable format with a few exceptions.
  # Command key (e.g. control, option, command) should be written in
  # string as they appear in {Accessibility::Keyboard::EventGenerator::CUSTOM}.
  #
  # For more details on event generation, read the
  # [Keyboarding wiki](http://github.com/AXElements/AXElements/wiki/Keyboarding).
  #
  # @param string [#to_s]
  # @return [Array<Array(Fixnum,Boolean)>]
  def keyboard_events_for string
    EventGenerator.new(Parser.new(string).parse).generate
  end

end
