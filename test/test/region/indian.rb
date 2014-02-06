# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2013 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module Test

  class Indian < Test::Unit::TestCase
    Sample1 = [
      "1913-03-01-", "1913-03-02-", "1913-03-03-", "1913-03-04-", "1913-03-05%", "1913-03-07-", "1913-03-08-", "1913-03-09-",
      "1913-03-10-", "1913-03-11-", "1913-03-12-", "1913-03-13-", "1913-03-14-", "1913-03-15-", "1913-03-15=", "1913-03<01-",
      "1913-03<02-", "1913-03<03-", "1913-03<04-", "1913-03<05-", "1913-03<06-", "1913-03<07-", "1913-03<08-", "1913-03<09-",
      "1913-03<10-", "1913-03<11-", "1913-03<12-", "1913-03<13%", "1913-03<15-", "1913-04-01-", "1913-04-02-", "1913-04-03-",
      "1913-04-04-", "1913-04-05-", "1913-04-06-", "1913-04-07-", "1913-04-08-", "1913-04-09-", "1913-04-10-", "1913-04-11-",
      "1913-04-12-", "1913-04-13-", "1913-04-14-", "1913-04-15-", "1913-04<01-", "1913-04<02-", "1913-04<03-", "1913-04<04-",
      "1913-04<05-", "1913-04<06-", "1913-04<07-", "1913-04<08-", "1913-04<09-", "1913-04<10-", "1913-04<11-", "1913-04<12-",
      "1913-04<13-", "1913-04<14-", "1913-04<15%", "1913-05-02-"
    ]

    Sample2 = [
      "1913-04-01-", "1913-04-02-", "1913-04-03-", "1913-04-04-", "1913-04-05%", "1913-04-07-", "1913-04-08-", "1913-04-09-"
    ]

    def test_indian_date_1
      cc     = When.Calendar('HinduLuniSolar')
      date   = When.when?('1913-03-01', {:frame=>cc})
      assert_equal("Jyaiṣṭha Śuklapakṣa", date.name('month').to_s)
      start  = 2448421
      Sample1.size.times do |i|
        assert_equal([Sample1[i], start+i], [date.to_s, date.to_i])
        date += When.Duration('P1D')
      end
    end

    def test_indian_date_2
      cc     = When.Calendar('HinduLuniSolar?start_month=4')
      date   = When.when?('1913-04-01', {:frame=>cc})
      assert_equal("Jyaiṣṭha Śuklapakṣa", date.name('month').to_s)
      start  = 2448421
      Sample2.size.times do |i|
        assert_equal([Sample2[i], start+i], [date.to_s, date.to_i])
        date += When.Duration('P1D')
      end
    end

    def test_indian_date_3
      cc     = When.Calendar('HinduSolar?type=SBS')
      date   = When.when?('1913-01-01', {:frame=>cc})
      assert_equal([2448361, "1913-01-01", "1991-04-14"], [date.to_i, date.to_s, date.to_date.to_s])
      date   = When::CalendarTypes::CalendarNote::HinduNote::Dates.new(date)
      assert_equal(2448361, date.to_i)
    end
  end
end
