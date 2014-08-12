# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2013 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module MiniTest::TM

#
# (5.2) Temporal Objects Package
#
#

  class Separation < MiniTest::TestCase
    def test_nothing
    end
  end

  class Order < MiniTest::TestCase
    def test_nothing
    end
  end

  class RelativePosition < MiniTest::TestCase
    def test_nothing
    end
  end

  class Object < MiniTest::TestCase
    def test_nothing
    end
  end

  class Complex < MiniTest::TestCase
    def test_nothing
    end
  end

  class TopologicalComplex < MiniTest::TestCase
    def test_nothing
    end
  end

  class Primitive < MiniTest::TestCase
    def test_nothing
    end
  end

  class GeometricPrimitive < MiniTest::TestCase
    def test_nothing
    end
  end

  class Instant < MiniTest::TestCase

    include When::TM::RelativePosition

    def test__distance
      position = []
      instant  = []
      When.when?('20110201/06').each do |sample|
        position << When.when?(sample)
        instant  << When::TM::Instant.new(position[-1])
      end
      period_0202_0204 = When::TM::Period.new(instant[1], instant[3])

      sample = ['P2D', 'P1D', 'P0D', 'P1D', 'P2D', 'P3D']
      instant.each do |i|
        assert_equal(sample.shift, i.distance(instant[2]).to_s)
      end

      sample = ['P1D', 'P0D', 'P0D', 'P0D', 'P1D', 'P2D']
      instant.each do |i|
        assert_equal(sample.shift, i.distance(period_0202_0204).to_s)
      end
    end

    def test__relative_position
      position = []
      instant  = []
      When.when?('20110201/06').each do |sample|
        position << When.when?(sample)
        instant  << When::TM::Instant.new(position[-1])
      end
      period_0202_0204 = When::TM::Period.new(instant[1], instant[3])

      sample = [Before, Before, Equals, After, After, After]
      instant.each do |i|
        assert_equal(sample.shift, i.relative_position(instant[2]))
      end

      sample = [Before, Begins, During,  Ends,   After, After]
      instant.each do |i|
        assert_equal(sample.shift, i.relative_position(period_0202_0204))
      end
    end
  end

  class Period < MiniTest::TestCase

    include When::TM::RelativePosition

    def test__distance
      position = []
      instant  = []
      When.when?('20110201/06').each do |sample|
        position << When.when?(sample)
        instant  << When::TM::Instant.new(position[-1])
      end
      assert_equal(["2011-02-01", "2011-02-02", "2011-02-03",
                    "2011-02-04", "2011-02-05", "2011-02-06"],
                    position.map {|v| v.to_s})

      period_0201_0202 = When::TM::Period.new(instant[0], instant[1])
      period_0202_0203 = When::TM::Period.new(instant[1], instant[2])
      period_0203_0204 = When::TM::Period.new(instant[2], instant[3])
      period_0204_0205 = When::TM::Period.new(instant[3], instant[4])
      period_0205_0206 = When::TM::Period.new(instant[4], instant[5])

      period_0202_0204 = When::TM::Period.new(instant[1], instant[3])
      period_0204_0206 = When::TM::Period.new(instant[3], instant[5])
      period_0203_0206 = When::TM::Period.new(instant[2], instant[5])
      period_0201_0206 = When::TM::Period.new(instant[0], instant[5])

      extent_0201_0202 = When::EX::Extent.new(period_0201_0202)
      extent_0202_0203 = When::EX::Extent.new(period_0202_0203)
      extent_0203_0204 = When::EX::Extent.new(period_0203_0204)
      extent_0204_0205 = When::EX::Extent.new(period_0204_0205)
      extent_0205_0206 = When::EX::Extent.new(period_0205_0206)

      extent_0202_0204 = When::EX::Extent.new(period_0202_0204)
      extent_0204_0206 = When::EX::Extent.new(period_0204_0206)
      extent_0203_0206 = When::EX::Extent.new(period_0203_0206)
      extent_0201_0206 = When::EX::Extent.new(period_0201_0206)

      sample = ['P1D', 'P0D', 'P0D', 'P0D', 'P1D', 'P2D']
      instant.each do |i|
        assert_equal(sample.shift, period_0202_0204.distance(i).to_s)
      end

      [['P2D', period_0201_0202, period_0204_0206],
       ['P0D', period_0201_0202, period_0202_0204],
       ['P0D', period_0202_0203, period_0202_0204],
       ['P0D', period_0203_0204, period_0202_0204],
       ['P0D', period_0204_0205, period_0202_0204],
       ['P0D', period_0203_0206, period_0202_0204],
       ['P1D', period_0205_0206, period_0202_0204]].each do |sample|
        assert_equal(sample[0], sample[1].distance(sample[2]).to_s)
        assert_equal(sample[0], sample[2].distance(sample[1]).to_s)
      end

      sample = ['P1D', 'P0D', 'P0D', 'P0D', 'P1D', 'P2D']
      instant.each do |i|
        assert_equal(sample.shift, extent_0202_0204.distance(i).to_s)
      end

      [['P2D', extent_0201_0202, extent_0204_0206],
       ['P0D', extent_0201_0202, extent_0202_0204],
       ['P0D', extent_0202_0203, extent_0202_0204],
       ['P0D', extent_0203_0204, extent_0202_0204],
       ['P0D', extent_0204_0205, extent_0202_0204],
       ['P0D', extent_0203_0206, extent_0202_0204],
       ['P1D', extent_0205_0206, extent_0202_0204]].each do |sample|
        assert_equal(sample[0], sample[1].distance(sample[2]).to_s)
        assert_equal(sample[0], sample[2].distance(sample[1]).to_s)
      end
    end

    def test__relative_position
      position = []
      instant  = []
      When.when?('20110201/06').each do |sample|
        position << When.when?(sample)
        instant  << When::TM::Instant.new(position[-1])
      end
      period_0201_0202 = When::TM::Period.new(instant[0], instant[1])
      period_0202_0203 = When::TM::Period.new(instant[1], instant[2])
      period_0203_0204 = When::TM::Period.new(instant[2], instant[3])
      period_0204_0205 = When::TM::Period.new(instant[3], instant[4])
      period_0205_0206 = When::TM::Period.new(instant[4], instant[5])

      period_0202_0204 = When::TM::Period.new(instant[1], instant[3])
      period_0203_0206 = When::TM::Period.new(instant[2], instant[5])
      period_0204_0206 = When::TM::Period.new(instant[3], instant[5])
      period_0201_0206 = When::TM::Period.new(instant[0], instant[5])

      sample = [After, BegunBy, Contains, EndedBy, Before, Before]
      instant.each do |i|
        assert_equal(sample.shift, period_0202_0204.relative_position(i))
      end

      [[Before,       period_0201_0202, period_0204_0206],
       [Meets,        period_0201_0202, period_0202_0204],
       [Overlaps,     period_0202_0204, period_0203_0206],
       [Begins,       period_0202_0203, period_0202_0204],
       [BegunBy,      period_0202_0204, period_0202_0203],

       [During,       period_0202_0204, period_0201_0206],
       [Contains,     period_0201_0206, period_0202_0204],
       [Equals,       period_0202_0204, period_0202_0204],

       [OverlappedBy, period_0203_0206, period_0202_0204],
       [Ends,         period_0203_0204, period_0202_0204],
       [EndedBy,      period_0202_0204, period_0203_0204],
       [MetBy,        period_0204_0205, period_0202_0204],
       [After,        period_0205_0206, period_0202_0204]].each do |sample|
        assert_equal(sample[0], sample[1].relative_position(sample[2]))
      end

    end
  end

  class TopologicalPrimitive < MiniTest::TestCase
    def test_nothing
    end
  end

  class Node < MiniTest::TestCase
    def test_nothing
    end
  end

  class Edge < MiniTest::TestCase
    def test_nothing
    end
  end

  class Duration < MiniTest::TestCase
    def test__duration_constructors
       assert_equal(    1,       When::TM::Duration.new(1).duration)
       assert_equal(    1.0/128, When::TM::Duration.second(1).duration)
       assert_equal(   60.0/128, When::TM::Duration.minute(1).duration)
       assert_equal( 3600.0/128, When::TM::Duration.hour(1).duration)
       assert_equal(86400.0/128, When::TM::Duration.day(1).duration)
       assert_equal(93784.0/128, When::TM::Duration.dhms(1,2,3,4).duration)
    end

    def test__duration_values
       assert_equal(1, When::TM::Duration.new(1).system)
       assert_equal(2, When::TM::Duration.second(2).second)
       assert_equal(3, When::TM::Duration.minute(3).minute)
       assert_equal(4, When::TM::Duration.hour(4).hour)
       assert_equal(5, When::TM::Duration.day(5).day)
       assert_equal([1,2,3,4], When::TM::Duration.dhms(1,2,3,4).to_dhms)
       assert_equal([-2,21,56,56], (-When::TM::Duration.dhms(1,2,3,4)).to_dhms)
    end

    def test__duration_elements
       duration = When::TM::Duration.dhms(1,2,3,4.5)
       assert_equal(1,   duration[0])
       assert_equal(2,   duration[1])
       assert_equal(3,   duration[2])
       assert_equal(4.5, duration[3])
    end

    def test__duration_arithmetics
       assert_equal(When::TM::Duration.dhms(-2,21,56,56), -When::TM::Duration.dhms(1,2,3,4))
       assert_equal(When::TM::Duration.dhms(2,3,4,5), When::TM::Duration.dhms(1,2,3,4) + When::TM::Duration.dhms(1,1,1,1))
       assert_equal(When::TM::Duration.dhms(0,1,2,3), When::TM::Duration.dhms(1,2,3,4) - When::TM::Duration.dhms(1,1,1,1))
       assert_equal(When::TM::Duration.dhms(2,4,6,8), When::TM::Duration.dhms(1,2,3,4) * 2)
       assert_equal(When::TM::Duration.dhms(1,2,3,4), When::TM::Duration.dhms(2,4,6,8) / 2)
       assert_equal(2, When::TM::Duration.dhms(2,4,6,8) / When::TM::Duration.dhms(1,2,3,4))
    end

    def test__duration_and_time
       start    = Time.now
       duration = When::TM::Duration.dhms(1,2,3,4.25)
       stop  = start + duration
       assert_equal((RUBY_VERSION.to_f<1.9 ? 93784.25 : 93784), stop-start)
       assert_raises(TypeError) {
         ::Date.today + duration
       }
       require 'when_exe/core/duration'
       stop  = start + duration
       assert_equal(93784.25, stop-start)

       now_date = DateTime.now
       duration = When::TM::Duration.hour(8)
       assert_equal(Rational(1,128), (now_date + duration * 3 / 128   ) - now_date)
       assert_equal(Rational(1,3),   (now_date + duration    ) - now_date)
       assert_equal(Rational(1,1),   (now_date + duration * 3) - now_date)

       stop  = start + When.Duration('P1DT2H3M4S')
       assert_equal(93784, stop-start)

       assert_raises(TypeError) {
         stop  = start + When.Duration('P2M1DT2H3M4S')
       }
    end
  end

  class PeriodDuration < MiniTest::TestCase
    def test__period_duration
      period = When.Duration('P2Y3M4D')
      [[-2, 2], [-1, 3], [0, 4]].each do |sample|
         assert_equal(sample[1], period[sample[0]])
      end
      period = When.Duration('PT5H6M7S')
      [[1, 5], [2, 6], [3, 7]].each do |sample|
         assert_equal(sample[1], period[sample[0]])
      end
      period = When.Duration('P2Y3M4DT5H6M7S')
      [[-2, 2], [-1, 3], [0, 4], [1, 5], [2, 6], [3, 7]].each do |sample|
         assert_equal(sample[1], period[sample[0]])
      end
      period = When.Duration('P8W9D')
      [[-0.5, 8], [0, 8*7+9]].each do |sample|
         assert_equal(sample[1], period[sample[0]])
      end
    end

    def test__period_duration_diff
      date1 = When.when?('2012-07-01')
      date2 = When.when?('2012-07-02')
      duration = date2 - date1
      assert_equal('P1D', duration.to_s)
      assert_equal(When::TM::PeriodDuration, duration.class)

      if Object.const_defined?(:TZInfo)
        time = When.when?('2013-03-10T01:00:00', :tz=>'America/New_York')
        assert_equal('2013-03-10T02:30:00-04:00', (time + When.Duration('PT1.5H')).to_s) # óÔñ Ç≈1.5éûä‘
      else
        puts
        puts "Tests for TZInfo have been skipped at line #{__LINE__} of #{__FILE__.split(/\//)[-1]}."
      end

      vcal = When.Resource("examples/USA-DST.ics?C=New_York&Z=E&D=04&DZ=06&S=05&SZ=07")
      time = When.when?('2013-03-10T01:00:00', :clock=>vcal['America/New_York'])
      assert_equal('2013-03-10T02:30:00-04:00', (time + When.Duration('PT1.5H')).to_s) # óÔñ Ç≈1.5éûä‘
    end

    Sample10 = %w(2013-01-31 2013-02-28 2013-03-31 2013-04-30 2013-05-31
                  2013-06-30 2013-07-31 2013-08-31 2013-09-30 2013-10-31)

    Sample12 = %w(2013-01-31 2013-02-28 2013-03-31 2013-04-30 2013-05-31 2013-06-30
                  2013-07-31 2013-08-31 2013-09-30 2013-10-31 2013-11-30 2013-12-31)

    def test__duration_each
      sample = Sample10.dup
      When::P1M.enum_for(When.when?('2013-01-31'), :forward, 10).each do |date|
        assert_equal(sample.shift, date.to_s)
      end

      count = 0
      (When.when?('2013-01-31') ^ When::P1M).each({:count_limit=>0}) do |date|
        count += 1
      end
      assert_equal(0, count)

      sample = Sample10.dup
      (When.when?('2013-01-31') ^ When::P1M).each({:count_limit=>10}) do |date|
        assert_equal(sample.shift, date.to_s)
      end

      sample = Sample12.dup
      (When.when?('2013-01-31') ^ When::P1M).each({:until=>When.when?('2013-12-31')}) do |date|
        assert_equal(sample.shift, date.to_s)
      end

      sample = Sample12.reverse
      (When.when?('2013-12-31') ^ -When::P1M).each({:until=>When.when?('2013-01-31')}) do |date|
        assert_equal(sample.shift, date.to_s)
      end
    end
  end

  class IntervalLength < MiniTest::TestCase
    def test__interval_length
      [
       ['7E-3s',      7,  3, 10, 'second', '7E-3s'      ],
       ['8X-2m',      8,  2, 60, 'minute', '8X-2m'      ],
       ['6(12)7D',    6, -7, 12, 'day',    '6(12)+7D'   ],
       ['1(16)4*10S', 1, -4, 16, '10',     '1(16)+4*10S']
      ].each do |sample|
        interval = When.Duration(sample[0])
        assert_equal(sample[1..5], [interval.value, interval.factor, interval.radix, interval.unit, interval.to_s])
      end
    end

    def test__interval_length_diff
      time1 = When.when?('2012-07-01T01:23:45+09:00')
      time2 = When.when?('2012-07-02T01:23:45+09:00')
      duration = time2 - time1
      assert_equal('86401.0s', duration.to_s)
      assert_equal(When::TM::IntervalLength, duration.class)

      if Object.const_defined?(:TZInfo)
        time = When.when?('2013-03-10T01:00:00', :tz=>'America/New_York')
        assert_equal('2013-03-10T03:30:00-04:00', (time + When.Duration('1.5h')).to_s)   # ï®óùìIÇ…1.5éûä‘
      else
        puts
        puts "Tests for TZInfo have been skipped at line #{__LINE__} of #{__FILE__.split(/\//)[-1]}."
      end

      vcal = When.Resource("examples/USA-DST.ics?C=New_York&Z=E&D=04&DZ=06&S=05&SZ=07")
      time = When.when?('2013-03-10T01:00:00', :clock=>vcal['America/New_York'])
      assert_equal('2013-03-10T03:30:00-04:00', (time + When.Duration('1.5h')).to_s)   # ï®óùìIÇ…1.5éûä‘
    end
  end
end
