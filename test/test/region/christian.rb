# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module MiniTest

  class ChristianVariation < MiniTest::TestCase

    def verify_built_in_date(calendar, start, length)
      date = Date.new(start, 1, 1)
      diff = {}
      while date.year < start + length
        cal_date = [date.year, date.month, date.day]
        cal_jdn  = date.jd
        fdate = When.TemporalPosition(date.year, date.month, date.day, {:frame=>calendar})
        rdate = calendar ^ cal_jdn
        [fdate, rdate].each do |tdate|
          [[cal_date, tdate.cal_date], [cal_jdn, tdate.to_i]].each do |verify|
            unless verify.uniq.size == 1
              diff[cal_date] ||= []
              diff[cal_date] << verify[1]
            end
          end
        end
        date = yield(date)
      end
      diff
    end

    def test__verify_to_built_in_date

      sample = [{}, {}, {}, {}, {}, {[2900, 1, 1]=>[2780263, [2900, 1, 2]]}]

      %w(Gregorian RevisedJulian).each do |name|
        calendar = When.Calendar(name)
        assert_equal(sample.shift, verify_built_in_date(calendar, 1900,  8) {|date| date  +    1})
        assert_equal(sample.shift, verify_built_in_date(calendar, 2000,400) {|date| date >>    1})
        assert_equal(sample.shift, verify_built_in_date(calendar, 2400,900) {|date| date >> 1200})
      end
    end

    def test__gregorian_date

      calendar = When.Calendar('Gregorian')

      dates = [When.when?('1900-02-28', {:frame=>calendar})]
      9.times do
        dates << dates.last + When::P1Y * 100
      end
      assert_equal([2415079, 2451603, 2488128, 2524652, 2561176,
                    2597700, 2634225, 2670749, 2707273, 2743797], dates.map {|date| date.to_i})
      assert_equal(%w(1900-02-28 2000-02-28 2100-02-28 2200-02-28 2300-02-28
                      2400-02-28 2500-02-28 2600-02-28 2700-02-28 2800-02-28), dates.map {|date| (calendar ^ date.to_i).to_s})
      assert_equal([28, 29, 28, 28, 28, 29, 28, 28, 28, 29], dates.map {|date| date.length(When::MONTH)})

      dates = [When.when?('1900-03-01', {:frame=>calendar})]
      9.times do
        dates << dates.last + When::P1Y * 100
      end
      assert_equal([2415080, 2451605, 2488129, 2524653, 2561177,
                    2597702, 2634226, 2670750, 2707274, 2743799], dates.map {|date| date.to_i})
      assert_equal(%w(1900-03-01 2000-03-01 2100-03-01 2200-03-01 2300-03-01
                      2400-03-01 2500-03-01 2600-03-01 2700-03-01 2800-03-01), dates.map {|date| (calendar ^ date.to_i).to_s})
      assert_equal([1], dates.map {|date| calendar._century_from_jdn(date.to_i) - calendar._century_from_jdn(date.to_i-1)}.uniq)
    end

    def test__revised_julian_date

      calendar = When.Calendar('RevisedJulian')

      dates = [When.when?('1900-02-28', {:frame=>calendar})]
      9.times do
        dates << dates.last + When::P1Y * 100
      end
      assert_equal([2415079, 2451603, 2488128, 2524652, 2561176,
                    2597700, 2634225, 2670749, 2707273, 2743797], dates.map {|date| date.to_i})
      assert_equal(%w(1900-02-28 2000-02-28 2100-02-28 2200-02-28 2300-02-28
                      2400-02-28 2500-02-28 2600-02-28 2700-02-28 2800-02-28), dates.map {|date| (calendar ^ date.to_i).to_s})
      assert_equal([28, 29, 28, 28, 28, 29, 28, 28, 28, 28], dates.map {|date| date.length(When::MONTH)})

      dates = [When.when?('1900-03-01', {:frame=>calendar})]
      9.times do
        dates << dates.last + When::P1Y * 100
      end
      assert_equal([2415080, 2451605, 2488129, 2524653, 2561177,
                    2597702, 2634226, 2670750, 2707274, 2743798], dates.map {|date| date.to_i})
      assert_equal(%w(1900-03-01 2000-03-01 2100-03-01 2200-03-01 2300-03-01
                      2400-03-01 2500-03-01 2600-03-01 2700-03-01 2800-03-01), dates.map {|date| (calendar ^ date.to_i).to_s})
      assert_equal([1], dates.map {|date| calendar._century_from_jdn(date.to_i) - calendar._century_from_jdn(date.to_i-1)}.uniq)
    end
  end

  class Swedish < MiniTest::TestCase
    def test__swedish_date

      dates = []
      jdns  = []
      [2342042, 2346424].each do |base|
        (-3..+3).each do |diff|
          jdn    = base + diff
          jdate  = When::Julian  ^ jdn
          s1date = When::Swedish ^ jdn
          s2date = When.tm_pos(*(s1date.cal_date + [{:frame=>When::Swedish}]))
          dates << s1date.to_s
          jdns  << [s1date.to_s == s2date.to_s, s1date.to_i == jdn, s2date.to_i == jdn].uniq
        end
      end

      assert_equal(%w(1700-02-26 1700-02-27 1700-02-28 1700-03-01 1700-03-02 1700-03-03 1700-03-04
                      1712-02-26 1712-02-27 1712-02-28 1712-02-29 1712-02-30 1712-03-01 1712-03-02), dates)
      assert_equal([[true]], jdns.uniq)
    end

    def test__swedish_easter

      dates = []
      civil = When.Calendar('Civil?old=Swedish&reform_date=1753-03-01')
      ((1700..1711).to_a + (1740..1752).to_a+[1802,1805,1818]).each do |year|
         dates << When.tm_pos(year, {:frame=>civil}).easter.to_s
      end
      assert_equal(%w(1700-04-01 1701-04-21 1702-04-06 1703-03-29 1704-04-17 1705-04-02 1706-03-25
                      1707-04-14 1708-04-05 1709-04-18 1710-04-10 1711-03-26 1740-04-06 1741-03-22
                      1742-03-14 1743-04-03 1744-03-18 1745-04-07 1746-03-30 1747-03-22 1748-04-03
                      1749-03-26 1750-03-18 1751-03-31 1752-03-22 1802-04-25 1805-04-21 1818-03-29), dates)
    end
  end

  class Civil < MiniTest::TestCase
    def test__border
      frame = When.Calendar('Civil?reform=1752-9-14&border=0-3-25(1753)0-1-1')
      assert_equal("1641=03-24", (frame ^ When.when?('1642-4-3')  ).to_s)
      assert_equal("1642-03-25", (frame ^ When.when?('1642-4-4')  ).to_s)
      assert_equal("1752-12-31", (frame ^ When.when?('1752-12-31')).to_s)
      assert_equal("1753-01-01", (frame ^ When.when?('1753-1-1')  ).to_s)
      assert_equal("1753-03-24", (frame ^ When.when?('1753-3-24') ).to_s)
      assert_equal("1753-03-25", (frame ^ When.when?('1753-3-25') ).to_s)
    end

    def test__reform_inc
      sample = %w(
        1582-09-30 1582-10-01 1582-10-02 1582-10-03 1582-10-04 1582-10-15 1582-10-16 1582-10-17
        1582-10-18 1582-10-19 1582-10-20 1582-10-21 1582-10-22 1582-10-23 1582-10-24 1582-10-25
        1582-10-26 1582-10-27 1582-10-28 1582-10-29 1582-10-30 1582-10-31 1582-11-01 1582-11-02
        1582-11-03)
      date = When.when?('1582-9-30', :frame=>'Civil?reform=1582-10-15')
      25.times do
        assert_equal(sample.shift, date.to_s)
        date = date + When::P1D
      end
    end

    def test__reform_dec
      sample = %w(
        1582-11-01 1582-10-31 1582-10-30 1582-10-29 1582-10-28 1582-10-27 1582-10-26 1582-10-25
        1582-10-24 1582-10-23 1582-10-22 1582-10-21 1582-10-20 1582-10-19 1582-10-18 1582-10-17
        1582-10-16 1582-10-15 1582-10-04 1582-10-03 1582-10-02 1582-10-01 1582-09-30 1582-09-29
        1582-09-28)
      date = When.when?('1582-11-01', :frame=>'Civil?reform=1582-10-15')
      25.times do
        assert_equal(sample.shift, date.to_s)
        date = date - When::P1D
      end
    end

    def test__reform_year
      date = When.when?('1752^^Civil?reform=1752-9-14&border=(1000)0-3-25(1753)0-1-1')
      assert_equal(
        [[1752,
         [[3,
          ["*", 1, 2, 3, 4, 5, 6, 7],
          ["*", 8, 9, 10, 11, 12, 13, 14],
          ["*", 15, 16, 17, 18, 19, 20, 21],
          ["*", 22, 23, 24, 25, 26, 27, 28],
          ["*", 29, 30, 31, "*", "*", "*", "*"]]],
         [[4,
          ["*", "*", "*", "*", 1, 2, 3, 4],
          ["*", 5, 6, 7, 8, 9, 10, 11],
          ["*", 12, 13, 14, 15, 16, 17, 18],
          ["*", 19, 20, 21, 22, 23, 24, 25],
          ["*", 26, 27, 28, 29, 30, "*", "*"]]],
         [[5,
          ["*", "*", "*", "*", "*", "*", 1, 2],
          ["*", 3, 4, 5, 6, 7, 8, 9],
          ["*", 10, 11, 12, 13, 14, 15, 16],
          ["*", 17, 18, 19, 20, 21, 22, 23],
          ["*", 24, 25, 26, 27, 28, 29, 30],
          ["*", 31, "*", "*", "*", "*", "*", "*"]]],
         [[6,
          ["*", "*", 1, 2, 3, 4, 5, 6],
          ["*", 7, 8, 9, 10, 11, 12, 13],
          ["*", 14, 15, 16, 17, 18, 19, 20],
          ["*", 21, 22, 23, 24, 25, 26, 27],
          ["*", 28, 29, 30, "*", "*", "*", "*"]]],
         [[7,
          ["*", "*", "*", "*", 1, 2, 3, 4],
          ["*", 5, 6, 7, 8, 9, 10, 11],
          ["*", 12, 13, 14, 15, 16, 17, 18],
          ["*", 19, 20, 21, 22, 23, 24, 25],
          ["*", 26, 27, 28, 29, 30, 31, "*"]]],
         [[8,
          ["*", "*", "*", "*", "*", "*", "*", 1],
          ["*", 2, 3, 4, 5, 6, 7, 8],
          ["*", 9, 10, 11, 12, 13, 14, 15],
          ["*", 16, 17, 18, 19, 20, 21, 22],
          ["*", 23, 24, 25, 26, 27, 28, 29],
          ["*", 30, 31, "*", "*", "*", "*", "*"]]],
         [[9,
          ["*", "*", "*", 1, 2, 14, 15, 16],
          ["*", 17, 18, 19, 20, 21, 22, 23],
          ["*", 24, 25, 26, 27, 28, 29, 30]]],
         [[10,
          ["*", 1, 2, 3, 4, 5, 6, 7],
          ["*", 8, 9, 10, 11, 12, 13, 14],
          ["*", 15, 16, 17, 18, 19, 20, 21],
          ["*", 22, 23, 24, 25, 26, 27, 28],
          ["*", 29, 30, 31, "*", "*", "*", "*"]]],
         [[11,
          ["*", "*", "*", "*", 1, 2, 3, 4],
          ["*", 5, 6, 7, 8, 9, 10, 11],
          ["*", 12, 13, 14, 15, 16, 17, 18],
          ["*", 19, 20, 21, 22, 23, 24, 25],
          ["*", 26, 27, 28, 29, 30, "*", "*"]]],
         [[12,
          ["*", "*", "*", "*", "*", "*", 1, 2],
          ["*", 3, 4, 5, 6, 7, 8, 9],
          ["*", 10, 11, 12, 13, 14, 15, 16],
          ["*", 17, 18, 19, 20, 21, 22, 23],
          ["*", 24, 25, 26, 27, 28, 29, 30],
          ["*", 31, "*", "*", "*", "*", "*", "*"]]]]],
        date.year_included('Sunday') {|d,b|
          case b
          when When::YEAR  ; d[When::YEAR]
          when When::MONTH ; d[When::MONTH]
          when When::DAY   ; d[When::DAY]
          else       ; '*'
         end
        }
      )
    end
  end
end
