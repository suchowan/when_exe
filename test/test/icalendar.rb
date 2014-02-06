# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2012 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module Test:V

  class Root < Test::Unit::TestCase
    def test_nothing
    end
  end

  class Calendar < Test::Unit::TestCase
    def test__each
      When::TM::Clock.local_time = When.Clock("+0900")
      cal = When.Resource("examples/JapanHolidays.ics")
      sample = [
        "2010-01-01T+09:00",
        "2010-01-11T+09:00",
        "2010-02-11T+09:00",
        "2010-03-21T+09:00",
        "2010-03-22T+09:00",
        "2010-04-29T+09:00",
        "2010-05-03T+09:00",
        "2010-05-04T+09:00",
        "2010-05-05T+09:00",
        "2010-07-19T+09:00",
        "2010-09-20T+09:00",
        "2010-09-23T+09:00",
        "2010-10-11T+09:00",
        "2010-11-03T+09:00",
        "2010-11-23T+09:00",
        "2010-12-23T+09:00",
      ]
      cal.each(When.when?('20100101')...When.when?('20110101')) do |date|
        assert_equal(sample.shift, date.to_s)
      end
      assert_equal([], sample)

      cal = cal.intersection({'summary'=>'成人の日'})
      sample = [
        "2010-01-11T+09:00",
      ]
      cal.each(When.when?('20100101')...When.when?('20110101')) do |date|
        assert_equal(sample.shift, date.to_s)
      end
      assert_equal([], sample)
    end

    def test__byweekno
      sample = [
        "1997-05-12",
        "1998-05-11",
        "1999-05-17"
      ]
      event = When::V::Event.new({
                'rrule'   => 'FREQ=YEARLY;BYDAY=MO;BYWEEKNO=20',
                'dtstart' => 'VALUE=DATE:19970512'
              })
      event.enum_for(When.when?('19970512'), :forward, 3, {'1st'=>"don't care"}).each do |date|
        assert_equal(sample.shift, date.to_s)
      end
    end

    def test__include_event
      d0504 = When.when?('20100504')
      d0505 = When.when?('20100505')

      cal   = When.Resource("examples/JapanHolidays.ics")
      it    = cal.enum_for(When.when?('20100501'))
      date  = it.next
      assert_equal(["2010-05-03T+09:00", 0], [date.to_s, date.precision])
      assert_equal([true,true],  [d0504,d0505].map {|v| cal.include?(v)})

      event = When::Parts::Resource["examples/JapanHolidays.ics::Midori_no_hi_2"] # みどりの日
      it    = event.enum_for(When.when?('20100501'))
      date  = it.next
      assert_equal(["2010-05-04T+09:00", 0], [date.to_s, date.precision])
      assert_equal([true,false], [d0504,d0505].map {|v| event.include?(v)})
    end

    def test__rfc_update
      sample = ["Children's_Day_(Japan)", 'Children"s_Day_(Japan)', "Children's_Day_(Japan)"]
      When::TM::Clock.local_time = When.Clock("+0900")
      ["JapanHolidays.ics", "JapanHolidays.ics?Escape=^'", "JapanHolidaysRFC6350.ics"].each do |ics|
        cal = When.Resource('examples/' + ics)
        cal = cal.intersection({'summary'=>/Children['"]s_Day_\(Japan\)/})
        cal.each(When.when?('20100101')...When.when?('20110101')) do |date|
          assert_equal(sample.shift, date.events[0].summary / 'en')
        end
      end
    end
  end

  class Event < Test::Unit::TestCase
    def test__event
      When::TM::Clock.local_time = When.Clock("+0900")
      event = When::V::Event.new({
                'rrule'   => {'FREQ'=>'MONTHLY', 'INTERVAL'=>12, 'BYDAY'=>{''=>'2MO'}},
                'dtstart' => 'VALUE=DATE:20070108'
              })
      sample = [
        "2007-01-08",
        "2008-01-14",
        "2009-01-12",
        "2010-01-11",
        "2011-01-10",
        "2012-01-09",
        "2013-01-14",
        "2014-01-13",
        "2015-01-12",
        "2016-01-11"
      ]
      event.enum_for(When.when?('20070101'), :forward, 10).each do |date|
        assert_equal(sample.shift, date.to_s)
      end
      assert_equal([], sample)

      sample = [
        "2007-01-08",
        "2007-01-15",
        "2007-01-22",
        "2007-01-29",
        "2007-02-05",
        "2007-02-12",
        "2007-02-19",
        "2007-02-26",
        "2007-03-05",
        "2007-03-12"
      ]
      event = When::V::Event.new({
                'rrule'   => {'FREQ'=>'P1W'},
                'dtstart' => 'VALUE=DATE:20070108'
              })
      event.enum_for(When.when?('20070101'), :forward, 10).each do |date|
        assert_equal(sample.shift, date.to_s)
      end
      assert_equal([], sample)
    end

    def test__last_work_days  # See RFC 5545 [Page 43]
      sample = [
        "2011-01-28",
        "2011-01-31",
        "2011-02-25",
        "2011-02-28",
        "2011-03-30",
        "2011-03-31",
      ]
      event = When::V::Event.new({
                'rrule'   => 'FREQ=MONTHLY;BYDAY=MO,TU,WE,TH,FR;BYSETPOS=-1,-2',
                'dtstart' => 'VALUE=DATE:20010101'
              })
      event.enum_for(When.when?('20110101'), :forward, 6).each do |date|
        assert_equal(sample.shift, date.to_s)
      end
      assert_equal([], sample)
    end

    def test__ignored_invalid_date
      When.Resource("examples/USA-DST.ics?C=New_York&Z=E&D=04&DZ=06&S=05&SZ=07")
      assert_equal("2007-03-30T09:00:00-04:00", When.when?('TZID=America/New_York:2007-03-30T09:00:00').to_s)
      sample = [
        "2007-01-15T09:00:00-05:00",
        "2007-01-30T09:00:00-05:00",
        "2007-02-15T09:00:00-05:00",
        "2007-03-15T09:00:00-04:00",
        "2007-03-30T09:00:00-04:00",
      ]
      When::V::Event.new({
                'rrule'   => 'FREQ=MONTHLY;BYMONTHDAY=15,30;COUNT=5',
                'dtstart' => 'TZID=America/New_York:20070115T090000'
      }).each do |date|
        assert_equal(sample.shift, date.to_s)
        break if sample == []
      end
    end

    if Object.const_defined?(:TZInfo)
      def test__ignored_invalid_date_chicago
        assert_equal("2007-03-30T09:00:00-05:00", When.when?('TZID=America/Chicago:2007-03-30T09:00:00').to_s)
        sample = [
          "2007-01-15T09:00:00-06:00",
          "2007-01-30T09:00:00-06:00",
          "2007-02-15T09:00:00-06:00",
          "2007-03-15T09:00:00-05:00",
          "2007-03-30T09:00:00-05:00",
        ]
        When::V::Event.new({
                  'rrule'   => 'FREQ=MONTHLY;BYMONTHDAY=15,30;COUNT=5',
                  'dtstart' => 'TZID=America/Chicago:20070115T090000'
        }).each do |date|
          assert_equal(sample.shift, date.to_s)
          break if sample == []
        end
      end
    else
      puts "Tests for TZInfo have been skipped at line #{__LINE__} of #{__FILE__.split(/\//)[-1]}."
    end

    def test__multiple_BYxxx_rule  # See RFC 5545 [Page 45]
      When.Resource("examples/USA-DST.ics?C=New_York&Z=E&D=04&DZ=06&S=05&SZ=07")

      sample = [
        "1997-04-13T01:30:00-04:00",
        "1997-04-13T02:30:00-04:00",
        "1997-04-13T03:30:00-04:00",
        "1998-04-12T01:30:00-04:00",
      ]
      When::V::Event.new({
                'rrule'   => 'FREQ=YEARLY;BYMONTH=4;BYDAY=2SU;BYHOUR=1,2,3;BYMINUTE=30',
                'dtstart' => 'TZID=America/New_York:19970413T013000'
      }).each do |date|
        assert_equal(sample.shift, date.to_s)
        break if sample == []
      end

      sample = [
        "1997-04-06T01:30:00-05:00",
        "1997-04-06T03:30:00-04:00",
        "1997-04-06T04:30:00-04:00",
        "1998-04-05T01:30:00-05:00",
      ]
      When::V::Event.new({
                'rrule'   => 'FREQ=YEARLY;BYMONTH=4;BYDAY=1SU;BYHOUR=1,2,3,4;BYMINUTE=30',
                'dtstart' => 'TZID=America/New_York:19970406T013000'
      }).each do |date|
        assert_equal(sample.shift, date.to_s)
        break if sample == []
      end

      sample = [
        "1997-10-26T01:30:00-04:00",
        "1997-10-26T01:30:00-05:00", # * 02:30:00-04:00
        "1997-10-26T02:30:00-05:00",
        "1997-10-26T03:30:00-05:00",
        "1998-10-25T01:30:00-04:00",
      ]
      When::V::Event.new({
                'rrule'   => 'FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU;BYHOUR=1,1=,2,3;BYMINUTE=30', # *
                'dtstart' => 'TZID=America/New_York:19971026T013000'
      }).each do |date|
        assert_equal(sample.shift, date.to_s)
        break if sample == []
      end

      sample = [
        "1997-10-19T01:30:00-04:00",
        "1997-10-19T02:30:00-04:00",
        "1998-10-18T01:30:00-04:00",
      ]
      When::V::Event.new({
                'rrule'   => 'FREQ=YEARLY;BYMONTH=10;BYDAY=-2SU;BYHOUR=1,1=,2;BYMINUTE=30', # *
                'dtstart' => 'TZID=America/New_York:19971019T013000'
      }).each do |date|
        assert_equal(sample.shift, date.to_s)
        break if sample == []
      end
    end

    if Object.const_defined?(:TZInfo)
      def test__multiple_BYxxx_rule_chicago  # See RFC 5545 [Page 45]
        sample = [
          "1997-04-13T01:30:00-05:00",
          "1997-04-13T02:30:00-05:00",
          "1997-04-13T03:30:00-05:00",
          "1998-04-12T01:30:00-05:00",
        ]
        When::V::Event.new({
                  'rrule'   => 'FREQ=YEARLY;BYMONTH=4;BYDAY=2SU;BYHOUR=1,2,3;BYMINUTE=30',
                  'dtstart' => 'TZID=America/Chicago:19970413T013000'
        }).each do |date|
          assert_equal(sample.shift, date.to_s)
          break if sample == []
        end

        sample = [
          "1997-04-06T01:30:00-06:00",
          "1997-04-06T03:30:00-05:00", # TODO !!
          "1997-04-06T04:30:00-05:00",
          "1998-04-05T01:30:00-06:00",
        ]
        When::V::Event.new({
                  'rrule'   => 'FREQ=YEARLY;BYMONTH=4;BYDAY=1SU;BYHOUR=1,2,3,4;BYMINUTE=30',
                  'dtstart' => 'TZID=America/Chicago:19970406T013000'
        }).each do |date|
          assert_equal(sample.shift, date.to_s)
          break if sample == []
        end

        sample = [
          "1997-10-26T01:30:00-05:00",
          "1997-10-26T01:30:00-06:00", # * - TODO !!
          "1997-10-26T02:30:00-06:00",
          "1997-10-26T03:30:00-06:00",
          "1998-10-25T01:30:00-05:00",
        ]
        When::V::Event.new({
                  'rrule'   => 'FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU;BYHOUR=1,1=,2,3;BYMINUTE=30', # *
                  'dtstart' => 'TZID=America/Chicago:19971026T013000'
        }).each do |date|
          assert_equal(sample.shift, date.to_s)
          break if sample == []
        end
        sample = [
          "1997-10-19T01:30:00-05:00",
          "1997-10-19T02:30:00-05:00",
          "1998-10-18T01:30:00-05:00",
        ]
        When::V::Event.new({
                  'rrule'   => 'FREQ=YEARLY;BYMONTH=10;BYDAY=-2SU;BYHOUR=1,1=,2;BYMINUTE=30', # *
                  'dtstart' => 'TZID=America/Chicago:19971019T013000'
        }).each do |date|
          assert_equal(sample.shift, date.to_s)
          break if sample == []
        end
      end
    else
      puts "Tests for TZInfo have been skipped at line #{__LINE__} of #{__FILE__.split(/\//)[-1]}."
    end

    def julian_easter(yy)
      a  = yy % 4
      b  = yy % 7
      c  = yy % 19
      d  = (19 * c + 15) % 30
      e  = (2 * a + 4 * b - d + 34) % 7
      mm = (d + e + 114) / 31
      dd = ((d + e + 114) % 31) + 1 
      [yy, mm, dd]
    end

    def gregorian_easter(yy)
      a  = yy % 19
      b  = yy / 100
      c  = yy % 100
      d  = b / 4
      e  = b % 4
      f  = (b + 8) / 25
      g  = (b - f + 1) / 3
      h  = (19 * a + b - d - g + 15) % 30
      i  = c / 4
      k  = c % 4
      l  = (32 + 2 * e + 2 * i - h - k) % 7
      m  = (a + 11 * h + 22 * l) / 451
      mm = (h + l - 7 * m + 114) / 31
      dd = ((h + l - 7 * m + 114) % 31) + 1
      [yy, mm, dd]
    end

    def test__easter
      jc = When.Resource('_c:Julian')
      other  = []
      myself = []
      532.times do |yy|
        y,m,d  = julian_easter(yy+325)
        other  << jc._coordinates_to_number(y,m-1,d-1)
        myself << jc.easter(yy+325)
      end
      assert_equal(other, myself)

      gc = When.Resource('_c:Gregorian')
      other  = []
      myself = []
      5700.times do |yy| # Should be 5_700_000
        y,m,d  = gregorian_easter(yy+1582)
        other  << gc._coordinates_to_number(y,m-1,d-1)
        myself << gc.easter(yy+1582)
      end
      assert_equal(other, myself)

      date = When.when?('2011').easter
      assert_equal("2011-04-24", date.to_s)

      sample = [
        "2009-04-12",
      # "2010-04-02",
        "2011-04-22",
      ]
      event = When::V::Event.new({
                'rrule'   => 'FREQ=YEARLY;INTERVAL=2;BYDAY/Christian=easter-2',
                'dtstart' => '20090412'
      })
      event.each do |date|
        assert_equal(sample.shift, date.to_s)
        break if sample == []
      end

      sample = [
        "2011-04-22",
      ]
      event.enum_for(When.when?('20100101')).each do |date|
        assert_equal(sample.shift, date.to_s)
        break if sample == []
      end

      sample = [
        "2009-04-12",
        "2010-03-30",
        "2011-04-17",
        "2012-04-07"
      ]
      event = When::V::Event.new({
                'rrule'   => 'FREQ=YEARLY;BYDAY/Christian?w=7=easter',
                'dtstart' => '20090412'
      })
      event.each do |date|
        assert_equal(sample.shift, date.to_s)
        break if sample == []
      end

      sample = [
        "2009-12-25",
        "2010-12-25",
        "2011-12-25",
      ]
      When::V::Event.new({
                'rrule'   => 'FREQ=YEARLY;BYDAY/Christian=christmas',
                'dtstart' => '20091225'
      }).each do |date|
        assert_equal(sample.shift, date.to_s)
        break if sample == []
      end
    end

    def test__terms

      event = When::V::Event.new({
                'rrule'   => 'FREQ=YEARLY;INTERVAL=2;BYDAY/SolarTerms=term180',
                'dtstart' => '20090922'
      })
      sample = [
        "2011-09-23",
      ]
      event.enum_for(When.when?('20100101')).each do |date|
        assert_equal(sample.shift, date.to_s)
        break if sample == []
      end

      sample = [
        "2009-09-22",
      # "2010-09-22",
        "2011-09-23",
      ]
      event.each do |date|
        assert_equal(sample.shift, date.to_s)
        break if sample == []
      end
    end
  end

  class Alarm < Test::Unit::TestCase
    def test_nothing
    end
  end

  class Todo < Test::Unit::TestCase
    def test__todo
      When::TM::Clock.local_time = When.Clock("+0900")
      event = When::V::Todo.new({
                'rrule'   => {'FREQ'=>'YEARLY', 'BYMONTH'=>1, 'BYDAY'=>{''=>'2MO'}},
                'due'     => 'VALUE=DATE:20160111'
              })
      sample = [
        "2011-01-10",
        "2012-01-09",
        "2013-01-14",
        "2014-01-13",
        "2015-01-12",
        "2016-01-11"
      ]
      this_time = When.now.to_s
      sample.shift while (sample[0] && sample[0] < this_time)
      event.enum_for(When.when?('20070101'), :forward, 5).each do |date|
        assert_equal(sample.shift, date.to_s)
      end
      assert_equal([], sample)
    end
  end

  class Journal < Test::Unit::TestCase
    def test_nothing
    end
  end

  class Freebusy < Test::Unit::TestCase
    def test__freebusy     # RFC 5545 [Page 101]
      sample = [
        "1997-03-08T16:00:00Z...1997-03-08T19:00:00Z",
        "1997-03-08T20:00:00Z...1997-03-08T21:00:00Z"
      ]
      When::V::Freebusy.new({'freebusy'=>'FBTYPE=FREE:19970308T160000Z/PT3H,19970308T200000Z/PT1H'}).each do |period|
        assert_equal([sample.shift, 'FREE'], [period.to_s, period.query['FBTYPE']])
      end
      assert_equal([], sample)
    end
  end

  class TimezoneProperty < Test::Unit::TestCase
    def test__tz_change
      ic = When.Resource("examples/USA-DST.ics?C=New_York&Z=E&D=04&DZ=06&S=05&SZ=07")
      tz = When::V::Timezone["America/New_York"]
      gc = When.Resource('_c:Gregorian')
      [
       ["1997-04-06T01:59:59",  "1997-04-06T01:59:59-05:00"],
       ["1997-04-06T02:00:00",  "1997-04-06T02:00:00-04:00"],
       ["1997-04-06T03:00:00",  "1997-04-06T03:00:00-04:00"],
       ["1997-10-26T00:59:00",  "1997-10-26T00:59:00-04:00"], # *
       ["1997-10-26T01:00:00",  "1997-10-26T01:00:00-04:00"], # *
       ["1997-10-26T01:59:59",  "1997-10-26T01:59:59-04:00"], # *
       ["1997-10-26T01=00:00",  "1997-10-26T01:00:00-05:00"], # *
       ["1997-10-26T01=59:59",  "1997-10-26T01:59:59-05:00"], # *
       ["1997-10-26T02:00:00",  "1997-10-26T02:00:00-05:00"]  # *
      ].each do |sample|
        assert_equal(sample[1], When.when?(sample[0], {:clock=>tz}).to_s)
      end

      [
       ["19970406T010000-0500", "1997-04-06T01:00:00-05:00"],
       ["19970406T015959-0500", "1997-04-06T01:59:59-05:00"],
       ["19970406T020000-0500", "1997-04-06T03:00:00-04:00"],
       ["19970406T030000-0500", "1997-04-06T04:00:00-04:00"],
       ["19971026T005959-0400", "1997-10-26T00:59:59-04:00"], # *
       ["19971026T010000-0400", "1997-10-26T01:00:00-04:00"], # *
       ["19971026T015959-0400", "1997-10-26T01:59:59-04:00"], # *
       ["19971026T020000-0400", "1997-10-26T01:00:00-05:00"], # *
       ["19971026T030000-0400", "1997-10-26T02:00:00-05:00"]  # *
      ].each do |sample|
        sdate = When.when?(sample[0])
        ddate = gc.jul_trans(sdate, {:clock=>tz})
        assert_equal(sample[1], ddate.to_s)
      end
    end

    if Object.const_defined?(:TZInfo)
      def test__tz_change_chicago
        tz = When::Parts::Timezone["America/Chicago"]
        gc = When.Resource('_c:Gregorian')
        [
         ["19970406T010000-0600", "1997-04-06T01:00:00-06:00"],
         ["19970406T015959-0600", "1997-04-06T01:59:59-06:00"],
         ["19970406T020000-0600", "1997-04-06T03:00:00-05:00"],
         ["19970406T030000-0600", "1997-04-06T04:00:00-05:00"],
         ["19971026T005959-0500", "1997-10-26T00:59:59-05:00"], # *
         ["19971026T010000-0500", "1997-10-26T01:00:00-05:00"], # *
         ["19971026T015959-0500", "1997-10-26T01:59:59-05:00"], # *
         ["19971026T020000-0500", "1997-10-26T01:00:00-06:00"], # *
         ["19971026T030000-0500", "1997-10-26T02:00:00-06:00"], # *
        ].each do |sample|
          sdate = When.when?(sample[0])
          ddate = gc.jul_trans(sdate, {:clock=>tz})
          assert_equal(sample[1], ddate.to_s)
        end

        [
         ["1997-04-06T01:59:59",  "1997-04-06T01:59:59-06:00"],
         ["1997-04-06T02:00:00",  "1997-04-06T02:00:00-05:00"], 
         ["1997-04-06T03:00:00",  "1997-04-06T03:00:00-05:00"],
         ["1997-10-26T00:59:00",  "1997-10-26T00:59:00-05:00"], # *
         ["1997-10-26T01:00:00",  "1997-10-26T01:00:00-05:00"], # * # "1997-10-26T02:00:00-05:00" - TODO !!
         ["1997-10-26T01:59:59",  "1997-10-26T01:59:59-05:00"], # * # "1997-10-26T02:59:59-05:00" - TODO !!
         ["1997-10-26T01=00:00",  "1997-10-26T01:00:00-06:00"], # *
         ["1997-10-26T01=59:59",  "1997-10-26T01:59:59-06:00"], # *
         ["1997-10-26T02:00:00",  "1997-10-26T02:00:00-06:00"]  # *
        ].each do |sample|
          assert_equal(sample[1], When.when?(sample[0], {:clock=>tz}).to_s)
        end
      end
    else
      puts "Tests for TZInfo have been skipped at line #{__LINE__} of #{__FILE__.split(/\//)[-1]}."
    end

    def test__date_change
      ic = When.Resource("examples/Millennium.ics")
      tz = When::V::Timezone["Oceania/Millennium_Island"]
      gc = When.Resource('_c:Gregorian')
      [
       ["1994-12-30T23:59:59",  "1994-12-30T23:59:59-10:00"],
       ["1995-01-01T00:00:00",  "1995-01-01T00:00:00+14:00"]
      ].each do |sample|
        assert_equal(sample[1], When.when?(sample[0], {:clock=>tz}).to_s)
      end
      [
       ["19941230T235959-1000", "1994-12-30T23:59:59-10:00"],
       ["19941231T000000-1000", "1995-01-01T00:00:00+14:00"],
      ].each do |sample|
        sdate = When.when?(sample[0])
        ddate = gc.jul_trans(sdate, {:clock=>tz})
        assert_equal(sample[1], ddate.to_s)
      end
    end

    def test__tzname
      ic   = When.Resource("examples/USA-DST.ics?C=New_York&Z=E&D=04&DZ=06&S=05&SZ=07")
      date = When.when?('20110126T250000EST')
      assert_equal(["2011-01-27T01:00:00-05:00", "Thu Jan 27 01:00:00 -0500 2011", "EST"],
                   [date.to_s, date.strftime('%+'), date.clk_time.frame.tzname[0]])

      When::TM::Clock.local_time = When::V::Timezone["America/New_York"]

      date = When.when?('20110526T250000')
      assert_equal(["2011-05-27T01:00:00-04:00", "Fri May 27 01:00:00 -0400 2011", "EDT"],
                   [date.to_s, date.strftime('%+'), date.clk_time.frame.tzname[0]])
    end
  end

  class Standard < Test::Unit::TestCase
    def test_nothing
    end
  end

  class Daylight < Test::Unit::TestCase
    def test_nothing
    end
  end

  class Timezone < Test::Unit::TestCase
    def test__neighbor_event_date
      When.Resource("examples/USA-DST.ics?C=New_York&Z=E&D=04&DZ=06&S=05&SZ=07")
      tz = When::V::Timezone["America/New_York"]
      assert_equal("1997-04-06T02:00:00-05:00", tz.send(:_neighbor_event_date, When.when?("19970510").universal_time).to_s)
      assert_equal("1997-10-26T02:00:00-04:00", tz.send(:_neighbor_event_date, When.when?("19971010").universal_time).to_s)
    end

    def test__current_period
      When.Resource("examples/USA-DST.ics?C=New_York&Z=E&D=04&DZ=06&S=05&SZ=07")
      tz = When::V::Timezone["America/New_York"]
      assert_equal("1997-04-06T02:00:00-05:00...1997-10-26T02:00:00-04:00", tz.current_period(When.when?("19970510")).to_s)
      assert_equal("1997-04-06T02:00:00-05:00...1997-10-26T02:00:00-04:00", tz.current_period(When.when?("19971010")).to_s)
    end

    if Object.const_defined?(:TZInfo)
      def test__tz_info
        assert_equal("1997-05-10T06:00-05:00", When.when?("TZID=America/Chicago:19970510T0600").to_s)
      end
    else
      puts "Tests for TZInfo have been skipped at line #{__LINE__} of #{__FILE__.split(/\//)[-1]}."
    end
  end

  class Event

    def test__each_1
      When.Resource("examples/USA-DST.ics?C=New_York&Z=E&D=04&DZ=06&S=05&SZ=07")
      cal = When.Resource("examples/Test.ics")

      event1 = When.Resource("examples/Test.ics::event1-ID")
      sample = [
        "2008-09-15T+09:00",
        "2009-09-21T+09:00",
        "2010-09-20T+09:00",
        "2011-09-19T+09:00",
        "2012-09-17T+09:00",
        "2013-09-16T+09:00",
        "2014-09-15T+09:00",
        "2015-09-21T+09:00",
        "2016-09-19T+09:00",
      ]
      event1.enum_for(When.when?('20080101'), :forward, 9).each do |date|
        assert_equal(sample.shift, date.to_s)
      end
      assert_equal([], sample)

      sample = [
        "2010-09-20T+09:00",
        "2011-09-19T+09:00",
        "2012-09-17T+09:00",
        "2013-09-16T+09:00",
      ]
      event1.enum_for(When.when?('20100101'), :forward, 4).each do |date|
        assert_equal(sample.shift, date.to_s)
      end
      assert_equal([], sample)
    end

    def test__each_2
      When.Resource("examples/USA-DST.ics?C=New_York&Z=E&D=04&DZ=06&S=05&SZ=07")
      cal = When.Resource("examples/Test.ics")

      event2 = cal["event2-ID"]
      sample = [
        "2010-09-20T+09:00",
        "2011-05-13T+09:00",
        "2011-09-19T+09:00",
        "2012-01-13T+09:00",
        "2012-04-13T+09:00",
        "2012-07-13T+09:00",
        "2012-09-17T+09:00",
        "2013-09-13T+09:00",
        "2013-09-16T+09:00",
        "2013-12-13T+09:00",
      ]
      event2.enum_for(When.when?('20100101'), :forward, 10, {'1st'=>'DontCare'}).each do |date|
        assert_equal(sample.shift, date.to_s)
      end
      assert_equal([], sample)
    end

    def test__each_3
      When.Resource("examples/USA-DST.ics?C=New_York&Z=E&D=04&DZ=06&S=05&SZ=07")
      cal = When.Resource("examples/Test.ics")

      event3 = cal["event3-ID"]
      sample = [
        "1997-09-02T09:00:00-04:00",
        "1997-09-02T09:20:00-04:00",
        "1997-09-02T09:40:00-04:00",
        "1997-09-02T10:00:00-04:00",
        "1997-09-02T10:20:00-04:00",
        "1997-09-02T10:40:00-04:00",
        "1997-09-02T11:00:00-04:00",
        "1997-09-02T11:20:00-04:00",
        "1997-09-02T11:40:00-04:00",
        "1997-09-02T12:00:00-04:00",
        "1997-09-02T12:20:00-04:00",
        "1997-09-02T12:40:00-04:00",
        "1997-09-02T13:00:00-04:00",
        "1997-09-02T13:20:00-04:00",
        "1997-09-02T13:40:00-04:00",
        "1997-09-02T14:00:00-04:00",
        "1997-09-02T14:20:00-04:00",
        "1997-09-02T14:40:00-04:00",
        "1997-09-02T15:00:00-04:00",
        "1997-09-02T15:20:00-04:00",
        "1997-09-02T15:40:00-04:00",
        "1997-09-02T16:00:00-04:00",
        "1997-09-02T16:20:00-04:00",
        "1997-09-02T16:40:00-04:00",
        "1997-09-03T09:00:00-04:00",
        "1997-09-03T09:20:00-04:00",
        "1997-09-03T09:40:00-04:00",
        "1997-09-03T10:00:00-04:00",
        "1997-09-03T10:20:00-04:00",
        "1997-09-03T10:40:00-04:00",
      ]
      event3.enum_for(When.when?('19970902T090000'), :forward, 30).each do |date|
        assert_equal(sample.shift, date.to_s)
      end
      assert_equal([], sample)

      sample = [
        "1997-09-04T13:00:00-04:00",
        "1997-09-04T12:40:00-04:00",
        "1997-09-04T12:20:00-04:00",
        "1997-09-04T12:00:00-04:00",
        "1997-09-04T11:40:00-04:00",
        "1997-09-04T11:20:00-04:00",
        "1997-09-04T11:00:00-04:00",
        "1997-09-04T10:40:00-04:00",
        "1997-09-04T10:20:00-04:00",
        "1997-09-04T10:00:00-04:00",
      ]
      event3.enum_for(When.when?('19970904T170000'), :reverse, 10, {'1st'=>'DontCare'}).each do |date|
        assert_equal(sample.shift, date.to_s)
      end
      assert_equal([], sample)

      sample = [
        "1997-09-04T16:40:00-04:00",
        "1997-09-04T16:20:00-04:00",
        "1997-09-04T16:00:00-04:00",
      ]
      event3.enum_for(When.when?('TZID=America/New_York:19970904T170000'), :reverse, 3, {'1st'=>'Exclude'}).each do |date|
        assert_equal(sample.shift, date.to_s)
      end
      assert_equal([], sample)
    end

    def test__each_4
      When.Resource("examples/USA-DST.ics?C=New_York&Z=E&D=04&DZ=06&S=05&SZ=07")
      cal = When.Resource("examples/Test.ics")

      event4 = cal["event4-ID"]
      sample = [
        "1997-09-02T09:00:00-04:00",
        "1997-09-02T09:00:10-04:00",
        "1997-09-02T09:20:00-04:00",
        "1997-09-02T09:40:00-04:00",
        "1997-09-02T10:00:00-04:00",
        "1997-09-02T10:20:00-04:00",
        "1997-09-02T10:40:00-04:00",
        "1997-09-02T11:00:00-04:00",
        "1997-09-02T11:20:00-04:00",
        "1997-09-02T11:40:00-04:00",
        "1997-09-02T12:20:00-04:00",
      ]
      event4.enum_for(When.when?('19970902T090000'), :forward, 11).each do |date|
        assert_equal(sample.shift, date.to_s)
      end
      assert_equal([], sample)
    end

    class Enumerator < Test::Unit::TestCase

      def test_nothing
      end

      class Step < Test::Unit::TestCase
        def test_nothing
        end
      end

      class Logic < Test::Unit::TestCase

        def test_nothing
        end

        class Enumerator < Test::Unit::TestCase
          def test_nothing
          end
        end

        class Month < Test::Unit::TestCase
          def test_nothing
          end
        end

        class Weekno < Test::Unit::TestCase
          def test_nothing
          end
        end

        class Yearday < Test::Unit::TestCase
          def test_nothing
          end
        end

        class Monthday < Test::Unit::TestCase
          def test_nothing
          end
        end

        class Weekday < Test::Unit::TestCase
          def test_nothing
          end
        end

        class Hour < Test::Unit::TestCase
          def test_nothing
          end
        end

        class Minute < Test::Unit::TestCase
          def test_nothing
          end
        end

        class Second < Test::Unit::TestCase
          def test_nothing
          end
        end
      end
    end
  end
end
