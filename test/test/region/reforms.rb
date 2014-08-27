# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module MiniTest

  class World < MiniTest::TestCase
    def test_world
      date = When.when? '2001.1.1'
      400.times do
        assert_equal(date.cal_date, (When::World ^ date).cal_date)
        date += When::P1Y
      end
    end
  end

  class Positivist < MiniTest::TestCase
    def test_positivist
      date = When.when? '2001.1.1'
      400.times do |i|
        assert_equal([2001+i-1788,1,1], (When::Positivist ^ date).cal_date)
        date += When::P1Y
      end
    end
  end

  class InternationalFixed < MiniTest::TestCase
    def test_international_fixed
      date = When.when? '2001.1.1'
      400.times do |i|
        assert_equal([2001+i,1,1], (When::InternationalFixed ^ date).cal_date)
        date += When::P1Y
      end
    end
  end
end
