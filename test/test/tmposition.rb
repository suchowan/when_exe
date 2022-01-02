# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2022 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module MiniTest::TM

#
# (5.4) Temporal Position Package
#
#

  class IndeterminateValue < MiniTest::TestCase
    def test_nothing
    end
  end

  class Position < MiniTest::TestCase
    def test__forward
       pos = When::TM::Position.new('2013-11-12')
       assert_equal(2456609, pos.to_i)
    end
  end

  class TemporalPosition < MiniTest::TestCase
    def test__instance
      [["19800203T234512.33+0900",       "1980-02-03T23:45:12.33+09:00"],
       ["19800203T234512.33Z",           "1980-02-03T23:45:12.33Z"],
       ["19800203T234512",               "1980-02-03T23:45:12Z"],
       ["19800203T2345",                 "1980-02-03T23:45Z"],
       ["19800203T23",                   "1980-02-03T23Z"],
       ["19800203T",                     "1980-02-03TZ"],
       ["19800203",                      "1980-02-03"],
       ["1980-02",                       "1980-02"],
       ["S33.07.31",                     "S33(1958).07.31"],
       ["S33.07.31/",                    "S33(1958).07.31"],
       ["1980T-0700",                    "1980T-07:00"],
       ["T234512-0700",                  "T23:45:12-07:00"],
       ["H2(1990)-05-11T23:45:12-07:00", "H02(1990).05.11T23:45:12-07:00"],
       ["T3(1914)=05-11T23:45:12-07:00", "T03(1914)=05.11T23:45:12-07:00"], # TODO
       ["S64.01.07",                     "S64(1989).01.07"],
       ["2001-08-02/After",              "2001-08-02"],
       ["Before/2001-09-10",             "2001-09-10"]].each do |sample|
         assert_equal(sample[1], When.when?(sample[0]).to_s)
      end
      assert_equal(["1980-02-03","1980-02-05","1980-02-06","1980-02-09"], When.when?(<<LIST).map {|date| date.to_s})
19800203
19800205
19800206
19800209
LIST
      assert_equal("2001-08-02..2001-09-10", When.when?("2001-08-02/09-10").to_s)
      assert_equal(364, When.when?('20130101/1230').count) if Enumerable.method_defined?(:count)
      assert_equal("1980-02-01", When.when?("800201", {:abbr=>1970}).to_s)
      # assert_nil(When.TemporalPosition(2011,2,29))
      assert_equal('2011-03-01', When.TemporalPosition(2011,2,29).to_s)
      assert_nil(When.TemporalPosition(2011,2,29, {:invalid=>:check}))
      assert_raises(ArgumentError) { When.TemporalPosition(2011,2,29, {:invalid=>:raise}) }
    end

    def test__strptime
      assert_equal('1950-08', When.strptime('1950 Aug', '%Y %B').to_s)
      assert_equal('1950-08-31', When.strptime('1950 Aug 31', '%Y %B %d').to_s)
      assert_equal('2015-01-06T09:18:24+09:00', When.strptime('Tue Jan 6  9:18:24 +09:00 2015', "%A %B %d %H:%M:%S %z %Y").to_s)
      assert_equal('2022-01-06T09:18:24+09:00', When.strptime("木 1月 6  9:18:24 JST", "%A %B %d %H:%M:%S %z", {:locale=>'ja'}).to_s)
      assert_raises(ArgumentError) {When.strptime("Thu Jan 6  9:18:24 +09:00 2015", "%A %B %d %H:%M:%S %z %Y", {:invalid=>:raise})}
    end

    def test__to_date
      if ::Object.const_defined?(:Date) && Date.respond_to?(:civil)
        assert(/\ATue Jun  7 00:00:00 (\+00:00|Z) 2011\z/ =~  When.when?("2011-06-07").to_date.strftime('%+'))
      end
    end

    def test__to_datetime
      if ::Object.const_defined?(:Date) && Date.respond_to?(:civil)
        assert(/Tue Jun  7 16:17:36 \+09:?00 2011\z/ =~ When.when?("2011-06-07T16:17:36+09:00").to_datetime.strftime('%+'))
      end
    end
  end

  class Coordinate < MiniTest::TestCase
    def test_nothing
    end
  end

  class JulianDate < MiniTest::TestCase
    def test_nothing
    end
  end

  class OrdinalPosition < MiniTest::TestCase
    def test_nothing
    end
  end

  class ClockTime < MiniTest::TestCase
    def test_nothing
    end
  end

  class CalDate < MiniTest::TestCase
    def test__floor
      date4 = When.when?("19820606^^Julian")
      [[-2, "1982"],
       [-1, "1982-06"],
       [ 0, "1982-06-06"]].each do |sample|
        assert_equal(sample[1], date4.floor(sample[0]).to_s)
      end
    end

    def test__length
      assert_equal(445, When.when?('AUC708.8.1').length(When::YEAR))
      assert_equal(442, When.when?('太初1.6.1').length(When::YEAR))
    end

    def test__week
      date = When.when?('20110517')
      assert_equal("2011-05-16...2011-05-23", date.week_included.to_s)
      [
        ['MO', "2011-05-16...2011-05-23"],
        ['TU', "2011-05-17...2011-05-24"],
        ['WE', "2011-05-11...2011-05-18"],
        ['TH', "2011-05-12...2011-05-19"],
        ['FR', "2011-05-13...2011-05-20"],
        ['SA', "2011-05-14...2011-05-21"],
        ['SU', "2011-05-15...2011-05-22"]
      ].each do |sample|
        assert_equal(sample[1], date.week_included(sample[0]).to_s)
      end
      [
        [-1, "2011-05-09...2011-05-16"],
        [ 0, "2011-05-16...2011-05-23"],
        [+1, "2011-05-23...2011-05-30"],
      ].each do |sample|
        assert_equal(sample[1], date.week_included(sample[0]).to_s)
      end
    end

    def test__residue
      assert_equal('2014-08-02', When.when?('2014-8-{SA}').to_s)
      assert_equal('2014-08-30', When.when?('2014-8-{SA:-1}').to_s)
      assert_equal('2014-08-21', When.when?('2014-{甲子&TH}').to_s)
      assert_equal('2014-08-21', When.when?('2014.8.{甲子}').to_s)
      assert_equal('2014-08-21', When.when?('{甲午}.8.{甲子}', :abbr=>2000).to_s)
      assert_equal('平成26(2014).08.21', When.when?('平成{甲午}.8.{甲子}').to_s)

      assert_equal('2014-08-02', When.tm_pos(2014, 8, When.Residue('SA')).to_s)
      assert_equal('2014-08-30', When.tm_pos(2014, 8, When.Residue('SA:-1')).to_s)
      assert_equal('2014-08-21', When.tm_pos(2014, When.Residue('甲子&TH')).to_s)
      assert_equal('2014-08-21', When.tm_pos(2014, 8, When.Residue('甲子')).to_s)
      assert_equal('2014-08-21', When.tm_pos(When.Residue('甲午'), 8, When.Residue('甲子'), :abbr=>2000).to_s)
      assert_equal('平成26(2014).08.21', When.tm_pos('平成', When.Residue('甲午'), 8, When.Residue('甲子')).to_s)

      assert_equal('2014-09-06', When.tm_pos(2014, 8, When.Residue('SA:6')).to_s)
      assert_nil(When.tm_pos(2014, 8, When.Residue('SA:6'), :invalid=>:check))
      assert_raises(ArgumentError) {When.tm_pos(2014, 8, When.Residue('SA:6'), :invalid=>:raise)}
    end

    def test__residue_and_repeat

      assert_equal('1924-01-01', When.when?('1900{甲子}-01-01').to_s)
      assert_equal('1924-01-01', When.when?('{甲子}-01-01', :abbr=>1900).to_s)
      assert_equal('昭和59(1984).01.01', When.when?('昭和{甲子}-01-01').to_s)

      assert_equal('2015-02-01', When.when?('2015-02-{SU}').to_s)
      assert_equal('2015-02-22', When.when?('2015-02-{4SU}').to_s)
      assert_equal('2015-09-23T17+09:00', When.when?('2015-09-01{SolarTerms#term180}T00+09:00').to_s)
      assert_equal('2015-04-05', When.when?('2015-01-01{Christian#easter}').to_s)
      assert_equal('2015-12-25', When.when?('2015-01-01{Christian#christmas}').to_s)
      assert_equal('2015-09-22T00:00+09:00', When.when?('2015-09-01{SolarTerms#term180-1&TU}T00:00+09:00').to_s)
      assert_equal('2015-05-06', When.when?('2015-05-{06&MO,TU,WE}').to_s)
      assert_nil(When.when?('2016-05-{06&MO,TU,WE}'))

      assert_equal('2015-03-01', When.when?('2015-02-01{5SU}').to_s)
      assert_nil(When.when?('2015-02-{5SU}'))
      assert_equal('2015-02-22', When.when?('2015-02-{-SU}').to_s)

      it = When.when?('R/2015-09-01{SolarTerms#term180-1&TU}T00:00+09:00')
      assert_equal('2015-09-22T00:00+09:00', it.succ.to_s)
      assert_equal('2026-09-22T00:00+09:00', it.succ.to_s)
      assert_equal('2032-09-21T00:00+09:00', it.succ.to_s)

      assert_equal(
         %w(2015-02-02 2015-02-09 2015-02-16 2015-02-23
            2016-02-01 2016-02-08 2016-02-15 2016-02-22
            2016-02-29 2017-02-06),
        When.when?('R10/2015-02-{MO}').map {|d| d.to_s})

      assert_equal(%w(2015-05-15 2017-05-15 2019-05-15),
        When.when?('R3/2015-05-15/P2Y').map {|d| d.to_s})

      assert_equal(%w(2015-09-22T00:00+09:00 2026-09-22T00:00+09:00 2032-09-21T00:00+09:00),
        When.when?('R3/2015-09-01{SolarTerms#term180-1&TU}T00:00+09:00').map {|d| d.to_s})

      assert_equal(%w(安政02(1855).02.10 慶応03(1867).02.07),
        When.when?('R2/弘化{卯}-02-{1卯}').map {|d| d.to_s})

      assert_equal(
        %w(2016-01-06T07+09:00 2016-01-21T00+09:00 2016-02-04T18+09:00 2016-02-19T14+09:00
           2016-03-05T12+09:00 2016-03-20T13+09:00 2016-04-04T17+09:00 2016-04-20T00+09:00
           2016-05-05T10+09:00 2016-05-20T23+09:00 2016-06-05T14+09:00 2016-06-21T07+09:00
           2016-07-07T01+09:00 2016-07-22T18+09:00 2016-08-07T10+09:00 2016-08-23T01+09:00
           2016-09-07T13+09:00 2016-09-22T23+09:00 2016-10-08T05+09:00 2016-10-23T08+09:00
           2016-11-07T08+09:00 2016-11-22T06+09:00 2016-12-07T01+09:00 2016-12-21T19+09:00),
        When.when?('R24/2016-01-01{SolarTerms#term0/15}T00+09:00').map {|d| d.to_s})
 
      assert_equal(
        %w(2011-03-05...2011-03-08   2012-02-18...2012-02-21
           2013-02-09...2013-02-12   2014-03-01...2014-03-04),
        When.when?('R4P3D/2011-01-01{Christian#easter-50}').map {|d| d.to_s})
    end

    def test__prefixed_calendar
      [['平成27(2015).1.15', '平成27(2015).01.15'],
       ['HinduLuniSolar?note=HinduNote&location=(_co:Indian::Ujjain)&type=SBSA&start_month=5(1936-10<10)', '1936-10<10-'],
       ['HinduLuniSolar?note=HinduNote&type=SBSA&start_month=5&location=(_co:Indian::Ujjain)(1936-10<10)', '1936-10<10-']
      ].each do |sample|
        date = When.when?(sample[0])
        assert_equal([sample[1], 2457038], [date.to_s, date.to_i])
      end
    end

    def test__calendar_reform_in_japan
      date0  = When.when?('明治5.12.1')
      date1  = date0 + When::P1M
      sample = [%w(明治06(1873).01.01 1873-01-01),
                %w(明治05(1872).12.02 1872-12-31),
                %w(明治05(1872).12.01 1872-12-30)]
      [date1, date1.prev, date1.prev.prev].each do |date|
        assert_equal(sample.shift, [date.to_s, (When::Gregorian^date).to_s])
      end

      sample = %w(明治05(1872).12.01 明治05(1872).12.02)
      date = When.when?('明治5.12.1')
      date.month_included('Sun') do |d,b|
        assert_equal(sample.shift, d.to_s) if b==When::DAY
      end
    end

    def test__calendar_reform_in_england
      frame = When.Calendar('Civil?reform=1752-9-14&border=0-3-25(1753)0-1-1')

      assert_equal('1641=03-24', (frame ^ When.when?('1642-4-3')).to_s)
      assert_equal('1642-03-25', (frame ^ When.when?('1642-4-4')).to_s)
      assert_equal('1752-12-31', (frame ^ When.when?('1752-12-31')).to_s)
      assert_equal('1753-01-01', (frame ^ When.when?('1753-1-1')).to_s)
      assert_equal('1753-03-24', (frame ^ When.when?('1753-3-24')).to_s)
      assert_equal('1753-03-25', (frame ^ When.when?('1753-3-25')).to_s)

    # frame = When.Calendar('Civil?reform=1752-9-14&old=(Julian?border=0-3-25)')
      sample = %w(1752-08-31 1752-09-01 1752-09-02 1752-09-14 1752-09-15 1752-09-16 1752-09-17 1752-09-18
                  1752-09-19 1752-09-20 1752-09-21 1752-09-22 1752-09-23 1752-09-24 1752-09-25 1752-09-26)
      date = When.when?('1752-8-31', :frame=>frame)
      16.times do
        assert_equal(sample.shift, date.to_s)
        date = date + When::P1D
      end

      sample = %w(1751-12-01 1751=01-01 1751=02-01 1751=03-01 1752-04-01 1752-05-01 1752-06-01 1752-07-01
                  1752-08-01 1752-09-01 1752-10-01 1752-11-01 1752-12-01 1753-01-01 1753-02-01 1753-03-01)
      date = When.when?('1751-12-1', :frame=>frame)
      16.times do
        assert_equal(sample.shift, date.to_s)
        date = date + When::P1M
      end
    end
  end

  class DateAndTime < MiniTest::TestCase
    def test__caret
      week = When.Resource("_co:Residue?divisor=7")
      date = When.TemporalPosition(2010,11,30, 6, 30)
      assert_equal("2010-11-30T06:30Z", date.to_s)
      it   = date ^ week
      assert_equal("2010-12-06T06:30Z", it.next.to_s)
      assert_equal("2010-12-13T06:30Z", it.next.to_s)
      assert_equal("2010-12-20T06:30Z", it.next.to_s)
      it   = date ^ When.Duration(2 * When::TM::Duration::DAY)
      assert_equal("2010-11-30T06:30Z", it.next.to_s)
      assert_equal("2010-12-02T06:30Z", it.next.to_s)
      assert_equal("2010-12-04T06:30Z", it.next.to_s)
    end

    def test__modulo
      week = When.Resource("_co:Residue?divisor=7")
      weekName = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
      obj1 = When.when?("20100928T234512.33+0900^^Gregorian")
      assert_equal("Tue", weekName[obj1 % week])
      obj2 = When.when?("20100928T234512.33-0600^^Gregorian")
      assert_equal("Tue", weekName[obj2 % week])
    end

    def test__minus
      obj1 = When.when?("20100928T234512.33+0900^^Gregorian")
      obj2 = When.when?("20100928T234512.33-0600^^Gregorian")
      assert_equal("2010-08-28T23:45:12.33+09:00", (obj1 - When::Duration("P1M")).to_s)
      assert_equal(0.625 * When::TM::Duration::DAY, (obj2 - obj1).duration)
      assert_equal("2010-09-13T23:45:12.33-06:00", (obj2 - 15).to_s)
    end

    def test__plus
      obj1 = When.when?("20100928T234512.33+0900^^Gregorian")
      [["P3D",  "2010-10-01T23:45:12.33+09:00"],
       ["P1Y",  "2011-09-28T23:45:12.33+09:00"],
       ["P1M",  "2010-10-28T23:45:12.33+09:00"],
       ["PT3H", "2010-09-29T02:45:12.33+09:00"],
       ["P3W",  "2010-10-19T23:45:12.33+09:00"]].each do |sample|
        assert_equal(sample[1], (obj1 + When::Duration(sample[0])).to_s)
      end

      obj2 = When.when?("19820606T1234^^Julian")
      [["PT2H15M", "1982-06-06T14:49Z"],
       ["PT3H",    "1982-06-06T15:34Z"]].each do |sample|
        assert_equal(sample[1], (obj2 + When::Duration(sample[0])).to_s)
      end

      ic  = When.Resource("examples/NewYork.ics")
      tz1 = When::V::Timezone["America/New_York"]

      [tz1].each do |tz|
        When::TM::Clock.local_time = tz
        obj3 = When.when?("1997-04-06T00:00:00", {:clock=>tz})
        [["PT1H", "1997-04-06T01:00:00-05:00"],
         ["PT2H", "1997-04-06T02:00:00-04:00"],
         ["PT3H", "1997-04-06T03:00:00-04:00"],
         [1 * When::TM::Duration::HOUR, "1997-04-06T01:00:00-05:00"],
         [2 * When::TM::Duration::HOUR, "1997-04-06T03:00:00-04:00"],
         [3 * When::TM::Duration::HOUR, "1997-04-06T04:00:00-04:00"]].each do |sample|
          assert_equal(sample[1], (obj3 + When::Duration(sample[0])).to_s)
        end

        obj4 = When.when?("1997-10-26T00:00:00", {:clock=>tz})
        [["PT1H", "1997-10-26T01:00:00-04:00"],
         ["PT2H", "1997-10-26T02:00:00-05:00"], # *
         ["PT3H", "1997-10-26T03:00:00-05:00"],
         [1 * When::TM::Duration::HOUR, "1997-10-26T01:00:00-04:00"],
         [2 * When::TM::Duration::HOUR, "1997-10-26T01:00:00-05:00"], # *
         [3 * When::TM::Duration::HOUR, "1997-10-26T02:00:00-05:00"]].each do |sample|
          assert_equal(sample[1], (obj4 + When::Duration(sample[0])).to_s)
        end
      end
    end

    def test__trans
      ic = When.Resource("examples/NewYork.ics")
      tz = When::V::Timezone["America/New_York"]

      sample = %w(1997-04-06T00:00:00-05:00 1997-04-06T01:00:00-05:00
                  1997-04-06T03:00:00-04:00 1997-04-06T04:00:00-04:00
                  1997-04-05T23:00:00-05:00 1997-04-06T00:00:00-05:00
                  1997-04-06T01:00:00-05:00 1997-04-06T03:00:00-04:00
                  1997-10-26T00:00:00-04:00 1997-10-26T01:00:00-04:00
                  1997-10-26T01:00:00-05:00 1997-10-26T02:00:00-05:00
                  1997-10-26T01:00:00-04:00 1997-10-26T01:00:00-05:00
                  1997-10-26T02:00:00-05:00 1997-10-26T03:00:00-05:00)

      %w(1997-04-06T00:00:00-05:00 1997-04-06T00:00:00-04:00
         1997-10-26T00:00:00-04:00 1997-10-26T00:00:00-05:00).each do |time|
        date = When.when?(time)
        4.times do
          assert_equal(sample.shift,  (tz ^ date).to_s)
          date += When::Duration('PT1H')
        end
      end
    end

    if Object.const_defined?(:TZInfo)
      def test__trans_tzinfo
        tz = When::Parts::Timezone["America/New_York"]

        sample = %w(1997-04-06T00:00:00-05:00 1997-04-06T01:00:00-05:00
                    1997-04-06T03:00:00-04:00 1997-04-06T04:00:00-04:00
                    1997-04-05T23:00:00-05:00 1997-04-06T00:00:00-05:00
                    1997-04-06T01:00:00-05:00 1997-04-06T03:00:00-04:00
                    1997-10-26T00:00:00-04:00 1997-10-26T01:00:00-04:00
                    1997-10-26T01:00:00-05:00 1997-10-26T02:00:00-05:00
                    1997-10-26T01:00:00-04:00 1997-10-26T01:00:00-05:00
                    1997-10-26T02:00:00-05:00 1997-10-26T03:00:00-05:00)

        %w(1997-04-06T00:00:00-05:00 1997-04-06T00:00:00-04:00
           1997-10-26T00:00:00-04:00 1997-10-26T00:00:00-05:00).each do |time|
          date = When.when?(time)
          4.times do
            assert_equal(sample.shift,  (tz ^ date).to_s)
            date += When::Duration('PT1H')
          end
        end
      end

      def test__plus_tzinfo
        obj4 = When.when?("1997-10-26T00:00:00", {:clock=>When::Parts::Timezone["America/New_York"]})
        [["PT59M","1997-10-26T00:59:00-04:00"],
         ["PT1H", "1997-10-26T01:00:00-04:00"],
         ["PT2H", "1997-10-26T02:00:00-05:00"], #  "1997-10-26T02:00:00-04:00" - TODO !!
         ["PT3H", "1997-10-26T03:00:00-05:00"],
         [1 * When::TM::Duration::HOUR, "1997-10-26T01:00:00-04:00"],
         [2 * When::TM::Duration::HOUR, "1997-10-26T01:00:00-05:00"], # *
         [3 * When::TM::Duration::HOUR, "1997-10-26T02:00:00-05:00"]].each do |sample|
          assert_equal(sample[1], (obj4 + When::Duration(sample[0])).to_s)
        end
      end
    else
      puts "Tests for TZInfo have been skipped at line #{__LINE__} of #{__FILE__.split(/\//)[-1]}."
    end

    def test__floor_date_and_time
      date5 = When.when?("1982-06-06T12:34:56.78^^Julian")
      sample = [
       "1982TZ",
       "1982-06TZ",
       "1982-06-06TZ",
       "1982-06-06T12Z",
       "1982-06-06T12:34Z",
       "1982-06-06T12:34:56Z",
       "1982-06-06T12:34:56.7Z",
       "1982-06-06T12:34:56.78Z"
      ]
      (-2..5).each do |i|
        assert_equal(sample.shift, date5.floor(i).to_s)
      end
    end

    def test__floor_year_bordered_date
      sample = [
        %w(AM6497(0989)*09.01 AM6497(0989)*09.01),
        %w(AM6497(0989)*10.01 AM6497(0989)*09.01),
        %w(AM6497(0989)*11.01 AM6497(0989)*09.01),
        %w(AM6497(0989)*12.01 AM6497(0989)*09.01),
        %w(AM6497(0989).01.01 AM6497(0989)*09.01),
        %w(AM6497(0989).02.01 AM6497(0989)*09.01),
        %w(AM6497(0989).03.01 AM6497(0989)*09.01),
        %w(AM6497(0989).04.01 AM6497(0989)*09.01),
        %w(AM6497(0989).05.01 AM6497(0989)*09.01),
        %w(AM6497(0989).06.01 AM6497(0989)*09.01),
        %w(AM6497(0989).07.01 AM6497(0989)*09.01),
        %w(AM6497(0989).08.01 AM6497(0989)*09.01),
        %w(AM6498(0990)*09.01 AM6498(0990)*09.01)
      ]

      date = When.when?(sample[0][0])
      13.times do
        assert_equal(sample.shift, [date.to_s, date.floor(When::YEAR, When::DAY).to_s])
        date += When::P1M
      end

      date = When.when?('AM6500(0992).02.29')
      assert_equal(%w(AM6500(0992).02.29 0992-02-29), [date.to_s, (When::Julian ^ date).to_s])

      date = When.Calendar('Gregorian?border=1959-2-23') ^ When.tm_pos(2014,2,22)
      assert_equal([When.Pair(54,1), 2, 22], date.cal_date)
      assert_equal('0054-02-23', date.floor(When::YEAR, When::DAY).to_s)

      date = When.Calendar('Gregorian?border=1959-2-23') ^ When.tm_pos(2014,2,23)
      assert_equal([55, 2, 23], date.cal_date)
      assert_equal('0055-02-23', date.floor(When::YEAR, When::DAY).to_s)

      date = When.Calendar('Gregorian?border=1959-2-23') ^ When.tm_pos(2014,2,24)
      assert_equal([55, 2, 24], date.cal_date)
      assert_equal('0055-02-23', date.floor(When::YEAR, When::DAY).to_s)

      greg = When.Calendar('Gregorian?border=Easter')
      assert_equal('2012=03-30', (greg ^ When.tm_pos(2013, 3, 30)).to_s)
      assert_equal('2013-03-31', (greg ^ When.tm_pos(2013, 3, 31)).to_s)
      assert_equal('2013=03-31', (greg ^ When.tm_pos(2014, 3, 31)).to_s)
      assert_equal('2014-04-20', (greg ^ When.tm_pos(2014, 4, 20)).to_s)
    end

    def test__floor_day_bordered_date
      sample1 = %w(
        Nabopolassar21(-604).12.30T=05:54:00+03:00
        Nabopolassar21(-604).12.30T=05:55:00+03:00
        NebuchadnezzarII01(-603).01.01T:05:56:00+03:00
        NebuchadnezzarII01(-603).01.01T:05:57:00+03:00)

      date = When.when?('Nabopolassar21.12.30T=05:54:00', :clock=>'+03:00?border=0-5-55-10')
      4.times do
        assert_equal(sample1.shift, date.to_s)
        date += When::PT1M
      end

      sample2 = %w(
        NebuchadnezzarII01(-603).01.01T:18:13:00+03:00
        NebuchadnezzarII01(-603).01.01T:18:14:00+03:00
        NebuchadnezzarII01(-603).01.02T*18:15:00+03:00
        NebuchadnezzarII01(-603).01.02T*18:16:00+03:00)

      date = When.when?('NebuchadnezzarII1.1.1T18:13:00', :clock=>'+03:00?border=0*18-14-18')
      4.times do
        assert_equal(sample2.shift, date.to_s)
        date += When::PT1M
      end

      sample3 = %w(
        Nabopolassar21(-604).12.30T=05:54:00+03:00
        Nabopolassar21(-604).12.30T=05:55:00+03:00
        NebuchadnezzarII01(-603).01.01T:05:56:00+03:00
        NebuchadnezzarII01(-603).01.01T:05:57:00+03:00)

      date = When.when?('Nabopolassar21.12.30T=05:54:00', :clock=>'+03:00?long=45&lat=32&border=Sunrise')
      4.times do
        assert_equal(sample3.shift, date.to_s)
        date += When::PT1M
      end

      sample4 = %w(
        NebuchadnezzarII01(-603).01.01T:18:13:00+03:00
        NebuchadnezzarII01(-603).01.01T:18:14:00+03:00
        NebuchadnezzarII01(-603).01.02T*18:15:00+03:00
        NebuchadnezzarII01(-603).01.02T*18:16:00+03:00)

      date = When.when?('NebuchadnezzarII1.1.1T18:13:00', :clock=>'+03:00?long=45&lat=32&border=Sunset')
      4.times do
        assert_equal(sample4.shift, date.to_s)
        date += When::PT1M
      end

      date = When.when?('NebuchadnezzarII1.1.1T:05:50:00', :clock=>'+03:00?border=0-06')
      assert_equal([1500903, 'Nabopolassar21(-604).12.30T:06:00+03:00'], [date.to_i, date.floor(When::DAY, When::MINUTE).to_s])
      date = When.when?('NebuchadnezzarII1.1.1T:06:00:00', :clock=>'+03:00?border=0-06')
      assert_equal([1500904, 'NebuchadnezzarII01(-603).01.01T:06:00+03:00'], [date.to_i, date.floor(When::DAY, When::MINUTE).to_s])
      date = When.when?('NebuchadnezzarII1.1.1T:05:50:00', :clock=>'+03:00?long=45&lat=32&border=Sunrise')
      assert_equal([1500903, 'Nabopolassar21(-604).12.30T:05:56+03:00'], [date.to_i, date.floor(When::DAY, When::MINUTE).to_s])
      date = When.when?('NebuchadnezzarII1.1.1T:06:00:00', :clock=>'+03:00?long=45&lat=32&border=Sunrise')
      assert_equal([1500904, 'NebuchadnezzarII01(-603).01.01T:05:55+03:00'], [date.to_i, date.floor(When::DAY, When::MINUTE).to_s])

      date = When.when?('NebuchadnezzarII1.1.1T:18:10:00', :clock=>'+03:00?border=0*18-15')
      assert_equal([1500904, 'NebuchadnezzarII01(-603).01.01T*18:15+03:00'], [date.to_i, date.floor(When::DAY, When::MINUTE).to_s])
      date = When.when?('NebuchadnezzarII1.1.2T*18:20:00', :clock=>'+03:00?border=0*18-15')
      assert_equal([1500905, 'NebuchadnezzarII01(-603).01.02T*18:15+03:00'], [date.to_i, date.floor(When::DAY, When::MINUTE).to_s])
      date = When.when?('NebuchadnezzarII1.1.1T:18:10:00', :clock=>'+03:00?long=45&lat=32&border=Sunset')
      assert_equal([1500904, 'NebuchadnezzarII01(-603).01.01T*18:13+03:00'], [date.to_i, date.floor(When::DAY, When::MINUTE).to_s])
      date = When.when?('NebuchadnezzarII1.1.2T*18:20:00', :clock=>'+03:00?long=45&lat=32&border=Sunset')
      assert_equal([1500905, 'NebuchadnezzarII01(-603).01.02T*18:14+03:00'], [date.to_i, date.floor(When::DAY, When::MINUTE).to_s])
    end
  end
end
