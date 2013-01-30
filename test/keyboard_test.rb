require 'test/helper'
require 'accessibility/keyboard'

# @note DO NOT TEST POSTING EVENTS HERE
# We only want to test posting events if all the tests in this file pass,
# otherwise the posted events may be unpredictable depending on what fails.
# Test event posting in the integration tests.
class TestKeyboard < MiniTest::Unit::TestCase
  include Accessibility::Keyboard

  # basic test to make sure the lexer and generator get along
  def test_keyboard_events_for
    events = keyboard_events_for 'cheezburger'
    assert_kind_of Array, events
    refute_empty events

    assert_equal true,  events[0][1]
    assert_equal false, events[1][1]
  end

  def test_dynamic_map_initialized
    refute_empty Accessibility::Keyboard::EventGenerator::MAPPING
  end

  def test_can_parse_empty_string
    assert_equal [], keyboard_events_for('')
  end

end
