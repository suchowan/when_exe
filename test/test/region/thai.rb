# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2013 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module MiniTest

  class Thai < MiniTest::TestCase
    def test_thai_date

      date = When.Resource('_c:ThaiP') ^ When.when?('2011-05-16')
      [["1373-07-15", 2455698],
       ["1373-07<01", 2455699],
       ["1373-07<02", 2455700]].each do |sample|
        assert_equal(sample, [date.to_s, date.to_i])
        date += When.Duration('P1D')
      end
      
      [["1373-07<03", 2455701],
       ["1373-08-03", 2455716],
       ["1373-08<03", 2455731],
       ["1373-09-03", 2455745],
       ["1373-09<03", 2455760],
       ["1373-10-03", 2455775],
       ["1373-10<03", 2455790],
       ["1373-11-03", 2455804],
       ["1373-11<03", 2455819],
       ["1373-12-03", 2455834]].each do |sample|
        assert_equal(sample, [date.to_s, date.to_i])
        date += When.Duration('P1M')
      end
      
      date = When.Resource('_c:Thai') ^ When.when?('2011-05-16')
      [["1373-06-14", 2455698],
       ["1373-06-15", 2455699],
       ["1373-06<01", 2455700]].each do |sample|
        assert_equal(sample, [date.to_s, date.to_i])
        date += When.Duration('P1D')
      end
      
      [["1373-06<02", 2455701],
       ["1373-07-02", 2455716],
       ["1373-07<02", 2455731],
       ["1373-08-02", 2455745],
       ["1373-08<02", 2455760],
       ["1373-09-02", 2455775],
       ["1373-09<02", 2455790],
       ["1373-10-02", 2455804],
       ["1373-10<02", 2455819],
       ["1373-11-02", 2455834],
       ["1373-11<02", 2455849],
       ["1373-12-02", 2455863],
       ["1373-12<02", 2455878],
       ["1374-01-02", 2455893],
       ["1374-01<02", 2455908],
       ["1374-02-02", 2455922],
       ["1374-02<02", 2455937],
       ["1374-03-02", 2455952],
       ["1374-03<02", 2455967],
       ["1374-04-02", 2455981],
       ["1374-04<02", 2455996],
       ["1374-05-02", 2456011],
       ["1374-05<02", 2456026],
       ["1374-06-02", 2456040],
       ["1374-06<02", 2456055],
       ["1374-07-02", 2456070],
       ["1374-07<02", 2456085],
       ["1374-08&02", 2456099],
       ["1374-08*02", 2456114],
       ["1374-08-02", 2456129],
       ["1374-08<02", 2456144],
       ["1374-09-02", 2456159],
       ["1374-09<02", 2456174],
       ["1374-10-02", 2456188],
       ["1374-10<02", 2456203],
       ["1374-11-02", 2456218],
       ["1374-11<02", 2456233],
       ["1374-12-02", 2456247],
       ["1374-12<02", 2456262],
       ["1375-01-02", 2456277]].each do |sample|
        assert_equal(sample, [date.to_s, date.to_i])
        date += When.Duration('P1M')
      end

      date = When.when?('1374-08&02', {:frame=>When.Resource('_c:Thai')})
      assert_equal(["1374-08&02", 2456099, "adhika Āṣāḍha Śuklapakṣa"],
                   [date.to_s, date.to_i, date.name('Month').translate('en')])

      diffs = [
        [1840,-1], [1860, 1], [1865, 1], [1876,-1], [1880,-1], [1881,-1], [1891,29], [1901, 1],
        [1902, 1], [1906, 1], [1910,30], [1911, 1], [1915, 1], [1916, 1], [1922, 1], [1926, 1],
        [1927, 1], [1934, 1], [1935, 1], [1936, 1], [1963, 1], [2024,-1], [2025,-1], [2040,-1],
        [2041,-1]]
      (1840..2050).each do |year|
        cdate = When.TemporalPosition(year-638, 1, 1, :frame=>'ThaiC').to_i
        tdate = When.TemporalPosition(year-638, 1, 1, :frame=>'ThaiT').to_i
        unless cdate == tdate
          assert_equal(diffs.shift, [year, tdate - cdate])
        end
      end
      assert_equal(0, diffs.size)

      diffs = [[1961,0], [1962,0], [1963,1], [1964,1]]
      (1961..1964).each do |year|
        t0date = When.TemporalPosition(year-638, 1, 1, :frame=>'ThaiT').to_i
        t1date = When.TemporalPosition(year-638, 1, 1, :frame=>'ThaiT?patch=1962A').to_i
        assert_equal(diffs.shift, [year, t0date - t1date])
      end
      assert_equal(0, diffs.size)
    end
  end
end

