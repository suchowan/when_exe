# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module MiniTest

  class Armenian < MiniTest::TestCase
    def test__armenian
      date = When.when?('1-1-1^^Armenian')
      assert_equal(["0001-01-01", "0552-07-11"], [date.to_s, (When::Julian ^ date).to_s])

      date = When.when?('1462-1-1^^Armenian')
      assert_equal(["1462-01-01", "2012-07-24"], [date.to_s, (When::Gregorian ^ date).to_s])
    end
  end
end
