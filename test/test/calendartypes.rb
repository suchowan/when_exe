# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module Test::CalendarTypes

  class UTC < Test::Unit::TestCase
    def test__utc
      assert_equal("+00:00", When.utc.tzname[0].to_s)
    end
  end

  class TableBased < Test::Unit::TestCase
    def test_nothing
    end
  end

  class PatternTableBasedLuniSolar < Test::Unit::TestCase
    def test__japanese

      frame = When.Resource('Japanese', '_c:')
      date = When.when?('16000101^Japanese')
      assert_equal(["1600-01-01", 2305493], [date.to_s, date.to_i])
      assert_equal(2305493, frame._coordinates_to_number(1600-454,0,0))
      assert_equal([1146, 0, 0], frame._number_to_coordinates(2305493))

      date = When.when?('0594-09=12^Japanese')
      assert_equal(["0594-09=12", 1938320], [date.to_s, date.to_i])
      assert_equal(594, date['YEAR'])
      assert_equal(When::BasicTypes::M17n, date.name('Month').class)

      result = []
      (date ^ When::TM::Calendar).each do |d|
        result << d.to_s
      end
      result.sort!

      sample = ["0594-09=12", "0594-11-02", "0594-11-02"] #TODO ‚È‚º Greg 2‚Â?
      # assert_equal(sample, result)
    end
  end

  class CyclicTableBased < Test::Unit::TestCase
    def test__islamic
      frame = When.Resource('_c:TabularIslamic')
      date = When.when?('00010101^TabularIslamic')
      assert_equal(["0001-01-01", 1948440], [date.to_s, date.to_i])
      assert_equal(1959071, frame._coordinates_to_number(31,0,0))
      assert_equal([31, 0, 0], frame._number_to_coordinates(1948440+10631))
    end
  end
end

