# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014-2017 Takashi SUGA

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

  class Tranquility < MiniTest::TestCase
    def test_tranquility
      date = When.when? '1969.7.21'
      400.times do |i|
        assert_equal([1+i,1,1], (When::Tranquility ^ date).cal_date)
        date += When::P1Y
      end
    end
  end

  class WorldSeason < MiniTest::TestCase
    def test_world_season
      date = When.when? '2000.12.21'
      400.times do |i|
        assert_equal([2001+i,1,1], (When::WorldSeason ^ date).cal_date)
        date += When::P1Y
      end
    end
  end

  class Pax < MiniTest::TestCase
    def test_pax

      samples = [
        %w(2014-01-01 2013-12-29),
        %w(2015-01-01 2014-12-28),
        %w(2016-01-01 2015-12-27),
        %w(2017-01-01 2016-12-25),
        %w(2018-01-01 2017-12-24),
        %w(2019-01-01 2018-12-30),
        %w(2020-01-01 2019-12-29),
        %w(2021-01-01 2020-12-27),
        %w(2022-01-01 2021-12-26),
        %w(2023-01-01 2022-12-25),

        %w(2018-02-01 2018-01-21),
        %w(2018-03-01 2018-02-18),
        %w(2018-04-01 2018-03-18),
        %w(2018-05-01 2018-04-15),
        %w(2018-06-01 2018-05-13),
        %w(2018-07-01 2018-06-10),
        %w(2018-08-01 2018-07-08),
        %w(2018-09-01 2018-08-05),
        %w(2018-10-01 2018-09-02),
        %w(2018-11-01 2018-09-30),
        %w(2018-12-01 2018-10-28),
        %w(2018-12=01 2018-11-25),
        %w(2018-13-01 2018-12-02)]

      date = When.when? '2014.1.1^^Pax'
      10.times do
        assert_equal(samples.shift, [date.to_s, (When::Gregorian ^ date).to_s])
        date += When::P1Y
      end

      date = When.when? '2018.1.1^^Pax'
      13.times do
        date += When::P1M
        assert_equal(samples.shift, [date.to_s, (When::Gregorian ^ date).to_s])
      end
    end
  end

  class HankeHenry < MiniTest::TestCase
    def test_hanke_henry
      assert_equal(When.when?('2018.1.1').to_i, When.when?('2018.1.1^^HankeHenry').to_i)
      count = 0
      (2000...2400).each do |year|
        first = When.tm_pos(year, 1, 1)
        last  = When.tm_pos(year,12,31)
        if (first.to_i % 7) == 3 || (last.to_i % 7) == 3
          assert_equal(371, When.tm_pos(year, :frame=>When::HankeHenry).length(When::YEAR))
          count += 1
        else
          assert_equal(364, When.tm_pos(year, :frame=>When::HankeHenry).length(When::YEAR))
        end
      end
      assert_equal(71, count)
    end
  end
end
