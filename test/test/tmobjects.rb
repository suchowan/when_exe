# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2013 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module Test::TM

#
# (5.2) Temporal Objects Package
#
#

  class Separation < Test::Unit::TestCase
    def test_nothing
    end
  end

  class Order < Test::Unit::TestCase
    def test_nothing
    end
  end

  class RelativePosition < Test::Unit::TestCase
    def test_nothing
    end
  end

  class Object < Test::Unit::TestCase
    def test_nothing
    end
  end

  class Complex < Test::Unit::TestCase
    def test_nothing
    end
  end

  class TopologicalComplex < Test::Unit::TestCase
    def test_nothing
    end
  end

  class Primitive < Test::Unit::TestCase
    def test_nothing
    end
  end

  class GeometricPrimitive < Test::Unit::TestCase
    def test_nothing
    end
  end

  class Instant < Test::Unit::TestCase

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

  class Period < Test::Unit::TestCase

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

  class TopologicalPrimitive < Test::Unit::TestCase
    def test_nothing
    end
  end

  class Node < Test::Unit::TestCase
    def test_nothing
    end
  end

  class Edge < Test::Unit::TestCase
    def test_nothing
    end
  end

  class Duration < Test::Unit::TestCase
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
       duration = When::TM::Duration.dhms(1,2,3,4.4)
       stop  = start + duration
       assert_equal((RUBY_VERSION.to_f<1.9 ? 93784.4 : 93784), stop-start)
       require 'when_exe/core/duration'
       stop  = start + duration
       assert_equal(93784.4, stop-start)

       stop  = start + When.Duration('P1DT2H3M4S')
       assert_equal(93784, stop-start)

       assert_raise(TypeError) {
         stop  = start + When.Duration('P2M1DT2H3M4S')
       }
    end
  end

  class PeriodDuration < Test::Unit::TestCase
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

    def test__julian_gregorian_change
      epoch = When.when?('CE1582.10.3') ^ When.Duration('P1D')
      sample = [
        "CE1582.10.03",
        "CE1582.10.04",
        "CE1582.10.15",
        "CE1582.10.16"
      ]
      4.times do
        assert_equal(sample.shift, epoch.next.to_s)
      end

      sample = [
        "CE1582.10.16",
        "CE1582.10.15",
        "CE1582.10.04",
        "CE1582.10.03"
      ]
      epoch = When.when?('CE1582.10.16') ^ -When.Duration('P1D')
      4.times do
        assert_equal(sample.shift, epoch.next.to_s)
      end

     assert_equal(
       [["October 1582",
        ["-", 1, 2, 3, 4, 15, 16],
        [17, 18, 19, 20, 21, 22, 23],
        [24, 25, 26, 27, 28, 29, 30],
        [31, "-", "-", "-", "-", "-", "-"]]],
       When.when?('CE1582.10').month_included('SU') {|date, type|
         case type
         when When::YEAR,
              When::MONTH ; date.strftime("%B %Y")
         when When::WEEK  ; nil
         when When::DAY   ; date[0]
         else             ; '-'
         end
       })
    end
  end

  class IntervalLength < Test::Unit::TestCase
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

    def test__julian_gregorian_change
      epoch = When.when?('CE1582.10.03') ^ When.Duration('1D')
      sample = [
        "CE1582.10.03",
        "CE1582.10.04",
        "CE1582.10.15",
        "CE1582.10.16"
      ]
      4.times do
        assert_equal(sample.shift, epoch.next.to_s)
      end

      sample = [
        "CE1582.10.16",
        "CE1582.10.15",
        "CE1582.10.04",
        "CE1582.10.03"
      ]
      epoch = When.when?('CE1582.10.16') ^ -When.Duration('1D')
      4.times do
        assert_equal(sample.shift, epoch.next.to_s)
      end
    end
  end
end
