# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module MiniTest

  class Zoroastrian < MiniTest::TestCase
    def test_fasli
      date = When.when? '1366.1.1^^Fasli?location=(_co:Iranian::Tehran)'
      [["1366-01-01", "1996-03-20", 2450163],
       ["1367-01-01", "1997-03-20", 2450528],
       ["1368-01-01", "1998-03-21", 2450894],
       ["1369-01-01", "1999-03-21", 2451259],
       ["1370-01-01", "2000-03-20", 2451624],
       ["1371-01-01", "2001-03-20", 2451989],
       ["1372-01-01", "2002-03-21", 2452355],
       ["1373-01-01", "2003-03-21", 2452720],
       ["1374-01-01", "2004-03-20", 2453085],
       ["1375-01-01", "2005-03-20", 2453450],
       ["1376-01-01", "2006-03-21", 2453816],
       ["1377-01-01", "2007-03-21", 2454181],
       ["1378-01-01", "2008-03-20", 2454546],
       ["1379-01-01", "2009-03-20", 2454911],
       ["1380-01-01", "2010-03-21", 2455277],
       ["1381-01-01", "2011-03-21", 2455642],
       ["1382-01-01", "2012-03-20", 2456007],
       ["1383-01-01", "2013-03-20", 2456372],
       ["1384-01-01", "2014-03-21", 2456738],
       ["1385-01-01", "2015-03-21", 2457103],
       ["1386-01-01", "2016-03-20", 2457468],
       ["1387-01-01", "2017-03-20", 2457833],
       ["1388-01-01", "2018-03-21", 2458199],
       ["1389-01-01", "2019-03-21", 2458564],
       ["1390-01-01", "2020-03-20", 2458929],
       ["1391-01-01", "2021-03-20", 2459294],
       ["1392-01-01", "2022-03-21", 2459660],
       ["1393-01-01", "2023-03-21", 2460025],
       ["1394-01-01", "2024-03-20", 2460390],
       ["1395-01-01", "2025-03-20", 2460755],
       ["1396-01-01", "2026-03-20", 2461120],
       ["1397-01-01", "2027-03-21", 2461486],
       ["1398-01-01", "2028-03-20", 2461851]].each do |sample|
        assert_equal(sample, [date.to_s, (When::Gregorian ^ date).to_s, date.to_i])
        date += When::P1Y
      end

      date = When.when? '2001.3.21'
      400.times do
        assert_equal([1,1], (When.Calendar('Fasli') ^ date).cal_date[-2..-1])
        date += When::P1Y
      end
    end
  end
end