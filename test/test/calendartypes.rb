# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2014 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module Test::CalendarTypes

  class UTC < Test::Unit::TestCase
    def test__utc
      assert_equal("+00:00", When::UTC.tzname[0].to_s)
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

  class SolarTerms < Test::Unit::TestCase

    Sample = %w(2013-03-20 2013-06-21 2013-09-23 2013-12-22
                2014-03-21 2014-06-21 2014-09-23 2014-12-22
                2015-03-21 2015-06-22 2015-09-23 2015-12-22)

    def test__term
      note = When.CalendarNote('SolarTerms')
      assert_equal('2014-03-20', note.term(When.when?('2014-3-1'), [0,30]).to_s)
      When::TM::Clock.local_time = '+09:00'
      assert_equal('2014-03-21', note.term(When.when?('2014-3-1'), [0,30]).to_s)
    end

    def test__each
      When::TM::Clock.local_time = '+09:00'
      note            = When.CalendarNote('SolarTerms')
      note_with_event = When.CalendarNote('SolarTerms?event=term0/90')
      today           = When.when?('2013-03-01')
      last            = When.when?('2016-01-01')

      sample = Sample.dup
      note_with_event.each(today) do |date|
        assert_equal(sample.shift, date.to_s)
        break if sample.empty?
      end

      sample = Sample.dup
      note_with_event.each(today...last) do |date|
        assert_equal(sample.shift, date.to_s)
      end
      assert_equal(true, sample.empty?)

      sample = Sample.dup
      note.each(today...last, {:event=>'term0/90', :count_limit=>4}) do |date|
        assert_equal(sample.shift, date.to_s)
      end
      assert_equal(Sample.length - 4, sample.length)
    end
  end
end

