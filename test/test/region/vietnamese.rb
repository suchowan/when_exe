# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module Test

  class Vietnamese < Test::Unit::TestCase

    Sample = [%w(大定3.1.1                                1142-02-05 大定03(1142).01.01),
              %w(ベトナム?LY=VSL::李朝::大定3.1.1         1140-01-29 ベトナム?LY=VSL::李朝::大定03(1140).01.01),
              %w(嗣徳2.8.1                                1849-09-17 ベトナム::阮朝::嗣徳02(1849).08.01),
              %w(ベトナム?LY=VSL&DN=LDNK::阮朝::嗣徳2.8.1 1849-09-16 ベトナム?LY=VSL&DN=LDNK::阮朝::嗣徳02(1849).08.01),
              %w(ベトナム::後期黎朝::福泰2.7.1            1644-08-02 ベトナム::後期黎朝::福泰02(1644).07.01),
              %w(ベトナム::広南::阮福瀾10.7.1             1644-08-03 ベトナム::広南::阮福瀾10(1644).07.01),
              %w(ベトナム::後期黎朝::慶徳4.9.1            1652-10-02 ベトナム::後期黎朝::慶徳04(1652).09.01),
              %w(ベトナム::広南::阮福瀕4.9.1              1652-10-03 ベトナム::広南::阮福瀕04(1652).09.01),
              %w(ベトナム::阮朝::建福1.1.31               1884-02-26 ベトナム::阮朝::建福01(1884).01.31)]

    def test_vietnamese_date

      When.CalendarEra('Vietnamese')
      When.CalendarEra('Vietnamese?LY=VSL')
      When.CalendarEra('Vietnamese?LY=VSL&DN=LDNK')

      Sample.each do |sample|
        date = When.when?(sample[0])
        assert_equal(sample[1..2], [date.to_date.to_s, date.to_s])
      end
    end
  end
end
