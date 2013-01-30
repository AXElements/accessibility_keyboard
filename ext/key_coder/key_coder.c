/*
 *  key_coder.c
 *  KeyCoder
 *
 *  Created by Mark Rada on 11-07-27.
 *  Copyright 2013 Mark Rada. All rights reserved.
 *  Copyright 2011-2012 Marketcircle Incorporated. All rights reserved.
 */


#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import <ApplicationServices/ApplicationServices.h>

#include "ruby.h"

static VALUE rb_cEventGenerator;
static ID sel_regenerate;

#ifdef NOT_MACRUBY
#define RELEASE(x) CFRelease(x)
#else
#define RELEASE(x) CFMakeCollectable(x)
#endif


/*
 *  Generate the mapping of characters to key codes for keys that can be
 *  remapped based on keyboard layout. Changing the keyboard layout at
 *  runtime will cause the returned hash to be different.
 *
 *  @example
 *
 *    KeyCoder.dynamic_mapping  => { "a" => 0, "b" => 24, ... }
 *
 *  @return [Hash{String=>Number}]
 */

static
VALUE
keycoder_dynamic_mapping()
{

  VALUE map = rb_hash_new();

#ifdef NOT_MACRUBY
  @autoreleasepool {
#endif

  TISInputSourceRef keyboard = TISCopyCurrentKeyboardLayoutInputSource();
  CFDataRef layout_data = (CFDataRef)TISGetInputSourceProperty(keyboard, kTISPropertyUnicodeKeyLayoutData);
  const UCKeyboardLayout* layout = (const UCKeyboardLayout*)CFDataGetBytePtr(layout_data);

  void (^key_coder)(int) = ^(int key_code) {
    UniChar      string[255];
    UniCharCount string_length = 0;
    UInt32       dead_key_state = 0;
    UCKeyTranslate(
		   layout,
       key_code,
		   kUCKeyActionDown,
		   0,
		   LMGetKbdType(),  // kb type
		   0,               // OptionBits keyTranslateOptions,
		   &dead_key_state,
		   255,
		   &string_length,
		   string
		  );

    NSString* nsstring = [NSString stringWithCharacters:string length:string_length];
    rb_hash_aset(map, rb_str_new_cstr([nsstring UTF8String]), INT2FIX(key_code));
  };

  // skip 65-92 since they are hard coded and do not change
  for (int key_code = 0;  key_code < 65;  key_code++)
    key_coder(key_code);
  for (int key_code = 93; key_code < 127; key_code++)
    key_coder(key_code);

  RELEASE(keyboard);

#ifdef NOT_MACRUBY
  }; // Close the autorelease pool
#endif


  return map;
}


/*
 *  Post the given event to the system and return `true`. This method
 *  will also add a small (9000 microsecond) delay after posting to
 *  ensure that keyboard actions do not go too fast.
 *
 *  @example
 *
 *    KeyCoder.post_event [0, true]  -> true
 *
 *  @param [Array(Number, Boolean)]
 *  @return [true]
 */

static
VALUE
keycoder_post_event(VALUE self, VALUE event)
{
  VALUE code  = rb_ary_entry(event, 0);
  VALUE state = rb_ary_entry(event, 1);

  CGEventRef event_ref = CGEventCreateKeyboardEvent(NULL, FIX2LONG(code), state);
  CGEventPost(kCGHIDEventTap, event_ref);
  RELEASE(event_ref);

  usleep(9000); // 9000 is a magic number
  return Qtrue;
}


@interface AKEventGenerator : NSObject
- (void)regenerateDynamicMapping;
@end

@implementation AKEventGenerator

- (void)regenerateDynamicMapping
{
  rb_funcall(rb_cEventGenerator, sel_regenerate, 0);
}

@end


void
Init_key_coder()
{
  /*
   *  Document-class: KeyCoder
   *
   *  Class that encapsulates some low level work for finding key code mappings
   *  and posting keyboard events to the system.
   *
   */
  VALUE cKeyCoder = rb_define_class("KeyCoder", rb_cObject);
  rb_define_singleton_method(cKeyCoder, "dynamic_mapping", keycoder_dynamic_mapping, 0);
  rb_define_singleton_method(cKeyCoder, "post_event", keycoder_post_event, 1);



  /* Register to be notified if the keyboard layout changes at runtime. The
   * receiver will tell the event generator to regenerate its mapping.
   * This will only work if a run loop is running (e.g. using the "spin"
   * method that comes with accessibility_core).
   */

  VALUE rb_mAccessibility = rb_define_module("Accessibility");
  VALUE rb_mKeyboard      = rb_define_module_under(rb_mAccessibility, "Keyboard");
  rb_cEventGenerator      = rb_define_class_under(rb_mKeyboard, "EventGenerator", rb_cObject);

  sel_regenerate = rb_intern("regenerate_dynamic_mapping");

  static AKEventGenerator* dynamic_regenerator;
  dynamic_regenerator = [[AKEventGenerator alloc] init];

  [[NSDistributedNotificationCenter defaultCenter]
     addObserver:dynamic_regenerator
        selector:sel_registerName("regenerateDynamicMapping")
            name:(NSString*)kTISNotifySelectedKeyboardInputSourceChanged
          object:nil];
}
