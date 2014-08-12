# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module MiniTest

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
end
