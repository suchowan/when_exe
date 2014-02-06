# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module Test::TM

#
# (5.3) Temporal Reference System Package
#
#

  class ReferenceSystem < Test::Unit::TestCase
    def test_nothing
    end
  end

  class OrdinalReferenceSystem < Test::Unit::TestCase
    def test_nothing
    end
  end

  class Calendar < Test::Unit::TestCase
    def test__jul_trans
      gc = When.Calendar('Gregorian')
      assert_equal("1858-11-16", (gc ^ 2400000).to_s)
      assert_equal("1858-11-16T12:00:00.00Z", (gc ^ 2400000.0).to_s)
      assert_equal("1858-11-16T21:00:00.00+09:00", (gc.jul_trans(2400000.0, {:clock=>'+0900'})).to_s)
      assert_equal("1970-01-01T12:00:00.00Z", (gc ^ Time.utc(1970,1,1,12)).to_s)
      assert_equal("1970-01-01T12:00:00.00Z", When.when?(Time.utc(1970,1,1,12)).to_s)
      if ::Object.const_defined?(:Date) && Date.respond_to?(:civil)
        assert_equal("1858-11-16T12:00:00.00Z", (gc ^ DateTime.new(1858,11,16,12,0,0,0)).to_s)
        assert_equal("1858-11-16T12:00:00.00Z", When.when?(DateTime.new(1858,11,16,12,0,0,0)).to_s)
      end
    end
  end

  class Clock < Test::Unit::TestCase
    def test__clock_trans
      obj1 = When.when?("20100928T234512.33-0600^^Gregorian")
      assert_equal("2010-09-29T14:45:12.33+09:00", (When.Clock("+0900") ^ obj1).to_s)
      assert_equal("2010-09-29T14:45:12.33+09:00", (When.Clock("+0900") ^ Time.utc(2010,9,29,5,45,12,330000)).to_s)
      if ::Object.const_defined?(:Date) && Date.respond_to?(:civil)
        assert_equal("2010-09-29T14:45:12.00+09:00", (When.Clock("+0900") ^ DateTime.new(2010,9,29,5,45,12)).to_s)
      end
    end
  end

  class CoordinateSystem < Test::Unit::TestCase
    def test_nothing
    end
  end

  class OrdinalEra < Test::Unit::TestCase
    def test_nothing
    end
  end

  class CalendarEra < Test::Unit::TestCase
    def test__pool
      era = When.Resource('_e:ModernJapanese')
      assert_equal([true, false, true, false],
                   [era.registered?, era.dup.registered?, era['M'].registered?, era['M'].dup.registered?])
      assert_equal("M", era['M'].label)
      assert_equal("http://hosi.org/When/TM/CalendarEra/ModernJapanese::M", era['M'].iri)
      assert_equal("http://hosi.org/When/TM/CalendarEra/ModernJapanese::M", When::Parts::Resource[era['M'].iri].iri)
    end

    def test__ce_bce
      [['BCE11.2.21', 'BCE11(-010).02.21', 1717457],
       ['CE-10.2.21', 'BCE11(-010).02.21', 1717457],
       ['-10.2.21',   '-00010-02-21',     1717459],
       ['CE1.1.1',    'Common::CE01.01.01',       1721424]
      ].each do |sample|
        date = When::when?(sample.shift)
        assert_equal(sample, [date.to_s, date.to_i])
      end

      assert_equal('BCE11(-010).02.21', When::TemporalPosition('BCE', 11, 2, 21).to_s)
    end

    def test__era_trans
      common =When.Resource('_e:Common::CE')
      obj1 = When.when?("20100929T144512.33+0900^^Gregorian")
      assert_equal("Common::CE2010.09.29T14:45:12.33+09:00", (common ^ obj1).to_s)
      assert_equal("Common::CE2010.09.29T14:45:12.33Z", (common ^ Time.utc(2010,9,29,14,45,12,330000)).to_s)
      if ::Object.const_defined?(:Date) && Date.respond_to?(:civil)
        assert_equal("Common::CE2010.09.29T14:45:12.00Z", (common ^ DateTime.new(2010,9,29,14,45,12)).to_s)
      end
    end

    def test__julian_gregorian_change
      epoch = When.when?('CE1582.10.03') ^ When.Duration('1D')
      sample = [
        "Common::CE1582.10.03",
        "Common::CE1582.10.04",
        "Common::CE1582.10.15",
        "Common::CE1582.10.16"
      ]
      4.times do
        assert_equal(sample.shift, epoch.next.to_s)
      end

      sample = [
        "Common::CE1582.10.16",
        "Common::CE1582.10.15",
        "Common::CE1582.10.04",
        "Common::CE1582.10.03"
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

      epoch = When.when?('Common?Reform=1752.09.14::CE1752.09.01') ^ When.Duration('1D')
      sample = [
        "Common?Reform=1752.09.14::CE1752.09.01",
        "Common?Reform=1752.09.14::CE1752.09.02",
        "Common?Reform=1752.09.14::CE1752.09.14",
        "Common?Reform=1752.09.14::CE1752.09.15"
      ]
      4.times do
        assert_equal(sample.shift, epoch.next.to_s)
      end

      sample = [
        "Common?Reform=1752.09.14::CE1752.09.15",
        "Common?Reform=1752.09.14::CE1752.09.14",
        "Common?Reform=1752.09.14::CE1752.09.02",
        "Common?Reform=1752.09.14::CE1752.09.01"
      ]
      epoch = When.when?('Common?Reform=1752.09.14::CE1752.09.15') ^ -When.Duration('1D')
      4.times do
        assert_equal(sample.shift, epoch.next.to_s)
      end
    end
  end
end
