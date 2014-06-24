# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2014 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module Test::TM

#
# (5.4) Temporal Position Package
#
#

  class IndeterminateValue < Test::Unit::TestCase
    def test_nothing
    end
  end

  class Position < Test::Unit::TestCase
    def test__forward
       pos = When::TM::Position.new('2013-11-12')
       assert_equal(2456609, pos.to_i)
    end
  end

  class TemporalPosition < Test::Unit::TestCase
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
      assert_equal("1980-02-01", When.when?("800201", {:abbr=>1970}).to_s)
      # assert_equal(nil, When.TemporalPosition(2011,2,29))
      assert_equal('2011-03-01', When.TemporalPosition(2011,2,29).to_s)
      assert_equal(nil, When.TemporalPosition(2011,2,29, {:invalid=>:check}))
      assert_raises(ArgumentError) { When.TemporalPosition(2011,2,29, {:invalid=>:raise}) }
    end

    def test__to_date
      if ::Object.const_defined?(:Date) && Date.respond_to?(:civil)
        assert(/\ATue Jun  7 00:00:00 (\+00:00|Z) 2011\z/ =~  When.when?("2011-06-07").to_date.strftime('%+'))
      end
    end

    def test__to_date_time
      if ::Object.const_defined?(:Date) && Date.respond_to?(:civil)
        assert(/Tue Jun  7 16:17:36 \+09:?00 2011\z/ =~ When.when?("2011-06-07T16:17:36+09:00").to_date_time.strftime('%+'))
      end
    end
  end

  class Coordinate < Test::Unit::TestCase
    def test_nothing
    end
  end

  class JulianDate < Test::Unit::TestCase
    def test_nothing
    end
  end

  class OrdinalPosition < Test::Unit::TestCase
    def test_nothing
    end
  end

  class ClockTime < Test::Unit::TestCase
    def test_nothing
    end
  end

  class CalDate < Test::Unit::TestCase
    def test__floor
      date4 = When.when?("19820606^^Julian")
      [[-2, "1982"],
       [-1, "1982-06"],
       [ 0, "1982-06-06"]].each do |sample|
        assert_equal(sample[1], date4.floor(sample[0]).to_s)
      end
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
  end

  class DateAndTime < Test::Unit::TestCase
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
  end
end
