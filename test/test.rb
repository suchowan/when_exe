#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2014 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

require 'pp'
require 'date'
begin
  require 'minitest/unit'
  require 'minitest/autorun'
  Test = MiniTest
  class Test::Unit::TestCase
    alias :assert_raise :assert_raises
  end
rescue LoadError
  require 'test/unit'
end

class Test::Unit::TestCase
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
require './test/inspect'
require './test/googlecalendar'
require './test/region/m17n'
require './test/region/residue'
require './test/region/civil'
require './test/region/japanese'
require './test/region/chinese'
require './test/region/tibetan'
require './test/region/thai'
require './test/region/indian'
require './test/region/iran'
require './test/region/mayan'
require './test/region/jewish'
require './test/region/french'
require './test/region/coptic'
require './test/region/geologicalage'
