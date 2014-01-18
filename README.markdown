# keyboard

This  gem is a component of
[AXElements](http://github.com/Marketcircle/AXElements). It provides
an interface for posting keyboard events to the system as well as a
mixin for parsing a string into a series of events.


A port of keyboard simulator code from
[AXElements](http://github.com/AXElements/AXElements),
but cleaned up and released as its own gem.

By itself, the `accessibility_keyboard` gem has limited use; but in
combination with a gem for performing other GUI manipulations, like
AXElements, this gem is very powerful and can be used for tasks such
as automated functional testing.

[![Dependency Status](https://gemnasium.com/AXElements/accessibility_keyboard.png)](https://gemnasium.com/AXElements/accessibility_keyboard)
[![Build Status](https://travis-ci.org/AXElements/accessibility_keyboard.png?branch=master)](https://travis-ci.org/AXElements/accessibility_keyboard)
[![Code Climate](https://codeclimate.com/github/AXElements/accessibility_keyboard.png)](https://codeclimate.com/github/AXElements/accessibility_keyboard)
[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/AXElements/accessibility_keyboard/trend.png)](https://bitdeli.com/free "Bitdeli Badge")


## Examples

The basics:

```ruby
    require 'accessibility/keyboard'

    include Accessibility::Keyboard

    keyboard_events_for("Hey, there!").each do |event|
      KeyCoder.post_event event
    end
```

Something a bit more advanced:

```ruby
    require 'accessibility/keyboard'

    include Accessibility::Keyboard

    keyboard_events_for("\\COMMAND+\t").each do |event|
      KeyCoder.post_event event
    end
```


## Documentation

- [Keyboarding Blog Post](http://ferrous26.com/blog/2012/04/03/axelements-part1/).
- [API documentation](http://rdoc.info/gems/accessibility_keyboard/frames)
- The AXElements [keyboarding tutorial](https://github.com/AXElements/AXElements/wiki/Keyboarding)


## Development

Development of this library happens as part of AXElements, but tests
and the API for this component remain separate so that it can be
released as part of the `accessibility_keyboard` gem.


### TODO

The API for posting events is ad-hoc for the sake of demonstration;
AXElements exposes this functionality via `Kernel#type`. The standalone
API provided here could be improved.


## Copyright

Copyright (c) 2013, Mark Rada
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.
* Neither the name of Mark Rada nor the names of its
  contributors may be used to endorse or promote products derived
  from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL Mark Rada BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
