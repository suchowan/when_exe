# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2013 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the COPYING file included in this archive.
=end

module Test::TM
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
    end
  end
end
