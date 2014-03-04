# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2014 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module Test::TimeStandard

  class UniversalTime < Test::Unit::TestCase
    def view(time)
      return time unless time.instance_of?(When::Coordinates::LeapSeconds)
      return [time.trunk, time.branch, time.second]
    end

    def test__delta_t
      date  = When.when?('2009-01-01T00:00:00Z')
      assert_equal("2008-12-31T23:59:01Z", (date - When::TM::IntervalLength.new(60, 'second')).to_s)
      assert_equal("2008-12-31T23:59:00Z", (date - When::Duration('PT60S')).to_s)

      date  = When::TM::JulianDate.dynamical_time((2500000-(When::TM::JulianDate::JD19700101-0.5))*675)
      assert_equal(2500000.0, +date)
      assert_equal(true, +date > date.to_f)

      date  = When::TM::JulianDate.universal_time((2500000-(When::TM::JulianDate::JD19700101-0.5))*675)
      assert_equal(2500000.0, date.to_f)
      assert_equal(true, +date > date.to_f)

      assert_equal((40 + 377.0/2048), When::TimeStandard.delta_t(When.when?('1970-01-01T').to_f))

      date  = When.when?('2008-10-31T23:59:60Z')
      assert_equal([[2008, 11, 1], [0, 0, 0, 0]], [date.cal_date, date.clk_time.clk_time])

      pair  = When::Coordinates::Pair.new(1,1)
      assert_equal([-1, -1, 1], [0.9, 1, 1.1].map {|v| v<=>pair})

      time  = When.Resource('_t:UniversalTime')
      date0 = When.when?('2008-12-31T23:59:58Z') ^ When.Duration('1s') # Duration('PT1S')
      [
        "2008-12-31T23:59:58Z",
        "2008-12-31T23:59:59Z",
        "2008-12-31T23:59:60Z",
        "2009-01-01T00:00:00Z",
        "2009-01-01T00:00:01Z"
      ].each do |sample|
        date = date0.next
        assert_equal([sample, true], [date.to_s, date.universal_time == time.from_dynamical_time(date.dynamical_time)])
      end

      it = When::V::Event.new({
          'rrule'   => 'FREQ=MINUTELY;BYSECOND=59,60',
          'dtstart' => '2008-12-31T23:58:59Z'
      }).each

      [
        "2008-12-31T23:58:59Z",
        "2008-12-31T23:59:59Z",
        "2009-01-01T00:00:59Z",
        "2009-01-01T00:01:59Z"
      ].each do |sample|
        assert_equal(sample, it.next.to_s)
      end

      it = When::V::Event.new({
          'rrule'   => 'FREQ=1s', #;BYSECOND=59,60',
          'dtstart' => '2008-12-31T23:59:58Z'
      }).each

      [
        "2008-12-31T23:59:58Z",
        "2008-12-31T23:59:59Z",
        "2008-12-31T23:59:60Z",
        "2009-01-01T00:00:00Z",
        "2009-01-01T00:00:01Z"
      ].each do |sample|
        assert_equal(sample, it.next.to_s)
      end
    end
  end
end
