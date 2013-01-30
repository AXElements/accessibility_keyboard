require './lib/accessibility/keyboard/version'

Gem::Specification.new do |s|
  s.name     = 'accessibility_keyboard'
  s.version  = Accessibility::Keyboard::VERSION

  s.summary     = 'Keyboard simulation for OS X'
  s.description = <<-EOS
Simulate keyboard input via the Mac OS X Accessibility Framework. This
gem is a component of AXElements.
  EOS
  s.authors     = ['Mark Rada']
  s.email       = 'mrada@marketcircle.com'
  s.homepage    = 'http://github.com/AXElements/accessibility_keyboard'
  s.licenses    = ['BSD 3-clause']
  s.has_rdoc    = 'yard'
  s.extensions << 'ext/key_coder/extconf.rb'


  s.files            = [
                        'lib/accessibility/keyboard.rb',
                        'lib/accessibility/keyboard/version.rb',
                        'lib/accessibility/keyboard/parser.rb',
                        'lib/accessibility/keyboard/event_generator.rb',

                        'ext/key_coder/key_coder.c',
                        'ext/key_coder/extconf.rb'
                       ]

  s.test_files       = [
                        'test/keyboard_test.rb',
                        'test/parser_test.rb',
                        'test/event_generator_test.rb',
                        'test/helper.rb',
                        'test/runner'
                       ]

  s.extra_rdoc_files = [
                        'README.markdown',
                        'History.markdown',
                        'CONTRIBUTING.markdown',
                        '.yardopts',
                       ]
end
