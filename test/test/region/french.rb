# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module Test

  class FrenchRepublican < Test::Unit::TestCase
    def test__french_republican
      date = When.when? 'FRE1.1.1'
      [["FRE01(1793).01.01", 2375840],
       ["FRE02(1794).01.01", 2376205],
       ["FRE03(1795).01.01", 2376570],
       ["FRE04(1796).01.01", 2376936],
       ["FRE05(1797).01.01", 2377301],
       ["FRE06(1798).01.01", 2377666],
       ["FRE07(1799).01.01", 2378031],
       ["FRE08(1800).01.01", 2378397],
       ["FRE09(1801).01.01", 2378762],
       ["FRE10(1802).01.01", 2379127],
       ["FRE11(1803).01.01", 2379492],
       ["FRE12(1804).01.01", 2379858],
       ["FRE13(1805).01.01", 2380223],
       ["FRE14(1806).01.01", 2380588]].each do |sample|
        assert_equal(sample, [date.to_s, date.to_i])
        date += When.Duration('P1Y')
      end
    end
  end
end
