# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module MiniTest

  class Tibetan < MiniTest::TestCase
    Sample = [
      "1991-05-01-", "1991-05-02-", "1991-05-03-", "1991-05-04-", "1991-05-05%", "1991-05-07-", "1991-05-08-", "1991-05-09-",
      "1991-05-10-", "1991-05-11-", "1991-05-12-", "1991-05-13-", "1991-05-14-", "1991-05-15-", "1991-05-15=", "1991-05-16-",
      "1991-05-17-", "1991-05-18-", "1991-05-19-", "1991-05-20-", "1991-05-21-", "1991-05-22-", "1991-05-23-", "1991-05-24-",
      "1991-05-25-", "1991-05-26-", "1991-05-27-", "1991-05-28%", "1991-05-30-"
    ]

    def test_tibetan_date
      cc     = When.Resource('_c:Tibetan')
      date   = When.when?('1991-05-01', {:frame=>cc})
      start  = 2448421
      Sample.size.times do |i|
        assert_equal([Sample[i], start+i], [date.to_s, date.to_i])
        date += When.Duration('P1D')
      end
    end
  end
end

