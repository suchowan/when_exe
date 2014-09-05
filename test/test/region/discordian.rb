# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module MiniTest

  class Discordian < MiniTest::TestCase
    def test_discordian
      date = When.when? '2001.1.1'
      400.times do |i|
        assert_equal([2001+i+1166,1,1], (When::Discordian ^ date).cal_date)
        date += When::P1Y
      end
    end
  end
end
