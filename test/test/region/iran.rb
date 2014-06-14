# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module Test

  class Iranian < Test::Unit::TestCase
    def test__iranian
      date = When.when? 'AP1391.1.1'
      [["Iranian::AH1391.01.01", 2456007], # (2012)
       ["Iranian::AH1392.01.01", 2456373], # (2013)
       ["Iranian::AH1393.01.01", 2456738], # (2014)
       ["Iranian::AH1394.01.01", 2457103], # (2015)
       ["Iranian::AH1395.01.01", 2457468], # (2016)
       ["Iranian::AH1396.01.01", 2457834], # (2017)
       ["Iranian::AH1397.01.01", 2458199], # (2018)
       ["Iranian::AH1398.01.01", 2458564], # (2019)
       ["Iranian::AH1399.01.01", 2458929], # (2020)
       ["Iranian::AH1400.01.01", 2459295], # (2021)
       ["Iranian::AH1401.01.01", 2459660], # (2022)
       ["Iranian::AH1402.01.01", 2460025], # (2023)
       ["Iranian::AH1403.01.01", 2460390], # (2024)
       ["Iranian::AH1404.01.01", 2460756], # (2025)
       ["Iranian::AH1405.01.01", 2461121], # (2026)
       ["Iranian::AH1406.01.01", 2461486], # (2027)
       ["Iranian::AH1407.01.01", 2461851], # (2028)
       ["Iranian::AH1408.01.01", 2462216], # (2029)
       ["Iranian::AH1409.01.01", 2462582], # (2030)
       ["Iranian::AH1410.01.01", 2462947], # (2031)
       ["Iranian::AH1411.01.01", 2463312], # (2032)
       ["Iranian::AH1412.01.01", 2463677], # (2033)
       ["Iranian::AH1413.01.01", 2464043], # (2034)
       ["Iranian::AH1414.01.01", 2464408], # (2035)
       ["Iranian::AH1415.01.01", 2464773], # (2036)
       ["Iranian::AH1416.01.01", 2465138], # (2037)
       ["Iranian::AH1417.01.01", 2465504], # (2038)
       ["Iranian::AH1418.01.01", 2465869], # (2039)
       ["Iranian::AH1419.01.01", 2466234], # (2040)
       ["Iranian::AH1420.01.01", 2466599], # (2041)
       ["Iranian::AH1421.01.01", 2466965], # (2042)
       ["Iranian::AH1422.01.01", 2467330], # (2043)
       ["Iranian::AH1423.01.01", 2467695], # (2044)
       ["Iranian::AH1424.01.01", 2468060]  # (2045)
      ].each do |sample|
        assert_equal(sample, [date.to_s, date.to_i])
        date += When.Duration('P1Y')
      end
    end
  end
end
