#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2015 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

require 'pp'
require 'date'
begin
  require 'minitest/autorun'
  module MiniTest
    TestCase = MiniTest.const_defined?(:Test) ? Test : Unit::TestCase
  end
rescue LoadError
  require 'test/unit'
  MiniTest = Test
  module Test
    TestCase = Unit::TestCase
    class Unit::TestCase
      alias :assert_raises :assert_raise
    end
  end
end

class MiniTest::TestCase
  def setup
    When._setup_({:multi_thread=>true})
  end
end

require 'when_exe'
require 'when_exe/mini_application'
#include When

require './test/parts'
require './test/basictypes'
require './test/ephemeris'
require './test/timestandard'
require './test/coordinates'
require './test/icalendar'
require './test/tmobjects'
require './test/tmreference'
require './test/tmposition'
require './test/calendartypes'
require './test/calendarnote'
require './test/inspect'
require './test/linkeddata'
require './test/obsolete/googlecalendar'
require './test/region/m17n'
require './test/region/residue'
require './test/region/christian'
require './test/region/swedish'
require './test/region/armenian'
require './test/region/japanese'
require './test/region/chinese'
require './test/region/vietnamese'
require './test/region/tibetan'
require './test/region/balinese'
require './test/region/thai'
require './test/region/indian'
require './test/region/iran'
require './test/region/islamic'
require './test/region/jewish'
require './test/region/french'
require './test/region/coptic'
require './test/region/bahai'
require './test/region/mayan'
require './test/region/discordian'
require './test/region/zoroastrian'
require './test/region/yerm'
require './test/region/reforms'
require './test/region/shire'
require './test/region/geologicalage'
