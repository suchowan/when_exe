#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2013 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the COPYING file included in this archive.
=end

begin
  require 'minitest/unit'
  require 'minitest/autorun'
  Test = MiniTest
rescue LoadError
  require 'test/unit'
end

require 'when_exe'
require './test/tmobjects'
