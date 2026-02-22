=begin
  Copyright (C) 2011-2015 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

$VERBOSE = nil
Dir.chdir __dir__

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "when_exe"
require "when_exe/mini_application"

require "minitest/autorun"
require "date"

class Minitest::Test
  def setup
    When._setup_({:multi_thread=>true})
  end
end
