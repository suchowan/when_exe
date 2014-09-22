# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2014 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module MiniTest

  class Chinese < MiniTest::TestCase
    def test_chinese_table
      assert_equal({1677=>{"iJ"=>"Ij"},
                    1698=>{"jK"=>"Jk"},
                    1709=>{"aB"=>"Ab", "jK"=>"Jk"},
                    1727=>{"cC"=>"Cc"},
                    1730=>{"Cd"=>"cD"},
                    1751=>{"Jk"=>"jK"},
                    1778=>{"Cd"=>"cD"},
                    1841=>{"kL"=>"Kl"}}, When.Calendar('Korean').verify(When.Calendar('Chinese1645'), 1654..1911))
    end

    def test_chinese_date

      emd = When.Resource('_c:EphemerisBasedSolar?time_basis=+09:00')
      date = When.when?('2009-01-01', {:frame=>emd})
      [
        ["2009-01-01", 2454867],
        ["2009-02-01", 2454896],
        ["2009-03-01", 2454927],
        ["2009-04-01", 2454957],
        ["2009-05-01", 2454988],
        ["2009-06-01", 2455020],
        ["2009-07-01", 2455051],
        ["2009-08-01", 2455082],
        ["2009-09-01", 2455113],
        ["2009-10-01", 2455143],
        ["2009-11-01", 2455173],
        ["2009-12-01", 2455202]
      ].each do |sample|
        assert_equal(sample, [date.to_s, date.to_i])
        date += When.Duration('P1M')
      end

      cc   = When::CalendarTypes::ChineseLuniSolar.new({'time_basis'=>'+09:00'})
      date = When.when?('2009-01-01', {:frame=>cc})
      [
        ["2009-01-01", 2454858],
        ["2009-02-01", 2454888],
        ["2009-03-01", 2454918],
        ["2009-04-01", 2454947],
        ["2009-05-01", 2454976],
        ["2009-05=01", 2455006],
        ["2009-06-01", 2455035],
        ["2009-07-01", 2455064],
        ["2009-08-01", 2455094],
        ["2009-09-01", 2455123],
        ["2009-10-01", 2455153],
        ["2009-11-01", 2455182],
        ["2009-12-01", 2455212]
      ].each do |sample|
        assert_equal(sample, [date.to_s, date.to_i])
        date += When.Duration('P1M')
      end

      date = When.when?('2032-11-01', {:frame=>cc})
      [
        ["2032-11-01", 2463570],
        ["2032-12-01", 2463599],
        ["2033-01-01", 2463629],
        ["2033-02-01", 2463658],
        ["2033-03-01", 2463688],
        ["2033-04-01", 2463717],
        ["2033-05-01", 2463746],
        ["2033-06-01", 2463776],
        ["2033-07-01", 2463805],
        ["2033-08-01", 2463835],
        ["2033-09-01", 2463864],
        ["2033-10-01", 2463894],
        ["2033-11-01", 2463924],
        ["2033-11=01", 2463954],
        ["2033-12-01", 2463983],
        ["2034-01-01", 2464013],
        ["2034-02-01", 2464042],
        ["2034-03-01", 2464072]
      ].each do |sample|
        assert_equal(sample, [date.to_s, date.to_i])
        date += When.Duration('P1M')
      end

      date = When.when?('2728-11-01', {:frame=>cc})
      [
        ["2728-11-01", 2717768],
        ["2728-11=01", 2717798],
        ["2728-12-01", 2717827],
        ["2729-01-01", 2717857],
        ["2729-02-01", 2717887],
        ["2729-03-01", 2717916],
        ["2729-04-01", 2717946]
      ].each do |sample|
        assert_equal(sample, [date.to_s, date.to_i])
        date += When.Duration('P1M')
      end

      cc   = When::CalendarTypes::ChineseLuniSolar.new({'time_basis'=>'+09:00', 'intercalary_span'=>3})
      date = When.when?('2728-11-01', {:frame=>cc})
      [
        ["2728-11-01", 2717768],
        ["2728-12-01", 2717798],
        ["2729-01-01", 2717827],
        ["2729-02-01", 2717857],
        ["2729-02=01", 2717887],
        ["2729-03-01", 2717916],
        ["2729-04-01", 2717946]
      ].each do |sample|
        assert_equal(sample, [date.to_s, date.to_i])
        date += When.Duration('P1M')
      end
    end

    def test_chinese_epoch
      date = When.when?('天保2.10.01')
      assert_equal([2390126, "天保02(1831).10.01", "神無月"],
                   [date.to_i, date.to_s, date.name('Month')/'alias'])
      assert_equal("1831-11-04", (When.Calendar('Gregorian') ^ When.when?('天保02.10.01')).to_s)

#=begin
      date = When.when?('天保2.10.01', {:count=>2})
      assert_equal([1926999, "天保02(0563).10.01", "十月"],
                   [date.to_i, date.to_s, date.name('Month')])

      date = When.when?('天保3(564).10.01')
      assert_equal([1927353, "天保03(0564).10.01", "十月"],
                   [date.to_i, date.to_s, date.name('Month')])

      date = When.when?('天保3.10.01', {'period'=>/梁/})
      assert_equal([1927353, "天保03(0564).10.01", "十月"],
                   [date.to_i, date.to_s, date.name('Month')])

      assert_equal(["江戸時代", "後梁", "北斉"],
                   When::era('天保').map {|v| v.parent.label}) # v.iri

      assert_raises(ArgumentError) { When.when?('天保3(0563).10.01') }

      date = When.when?('始皇帝26*10.01')
      assert_equal([1640641, 1640641, "始皇帝26(-220)*10.01", "十月"],
                   [date.to_i, date.floor(When::YEAR).to_i, date.to_s, date.name('Month')])

      cc_221 = When.Resource('_c:Chinese_221')
      [
        ["-220*10-01", 1640641, "-00220*10-01", "十月"],
        ["-220*11-01", 1640671, "-00220*11-01", "十一月"],
        ["-220*12-01", 1640700, "-00220*12-01", "十二月"],
        ["-220-01-01", 1640730, "-00220-01-01", "正月"],
        ["-220-02-01", 1640759, "-00220-02-01", "二月"],
        ["-220-03-01", 1640789, "-00220-03-01", "三月"],
        ["-220-04-01", 1640818, "-00220-04-01", "四月"],
        ["-220-05-01", 1640848, "-00220-05-01", "五月"],
        ["-220-06-01", 1640877, "-00220-06-01", "六月"],
        ["-220-07-01", 1640907, "-00220-07-01", "七月"],
        ["-220-08-01", 1640937, "-00220-08-01", "八月"],
        ["-220-09-01", 1640966, "-00220-09-01", "九月"],
        ["-220-09=01", 1640996, "-00220-09=01", "閏九月"]
      ].each do |sample|
        date = When.when?(sample[0], {:frame=>cc_221})
        assert_equal(sample[1..-1], 
                    [date.to_i, date.to_s, date.name('Month')])
      end
#=end
    end

    def test_daien_lunation
      sample = [
        2938, 2993, 2708, 2760, 2573, 2691, 2622, 
        2626, 2637, 2523, 2551, 2637, 2625, 2886, 
        2703, 2764, 2791, 2680, 2792, 2764, 2797, 
        1402, 2626, 2380, 2807, 3003,   23, 2698]

      %w(0765-02-01 0765-12-01 0768-09-01 0769-04-01 0769-07-01 0771-05-01 0772-04-01
         0772-09-01 0774-06-01 0775-02-01 0776-03-01 0780-05-01 0781-09-01 0784-10=01
         0786-03-01 0788-04-01 0791-02-01 0791-09-01 0792-05-01 0813-12-01 0816-03-01
         0820-02-01 0820-03-01 0822-02-01 0835-04-01 0836-04-01 0841-11-01 0853-02-01).each do |ptn|
        date = When.when?(ptn+ '^^ChineseTwin::大衍暦')
        formula = date.frame.formula[-1]
        m = When::Coordinates::Residue.mod(date.to_i+1) {|cn| formula.cn_to_time(cn)}
        t = formula.cn_to_time(m[0]) + Rational(1,2)
        assert_equal(sample.shift, (t - t.floor) * formula.denominator)
      end
    end

    def test_solar_terms_for_chinese_true_lunation
      date     = When.when?('1690-1-1^^JapaneseTwin::貞享暦(節月)')
      formula = date.frame.formula[0]
      class << formula
        attr_reader :day_shift, :longitude_shift, :year_delta
      end
      assert_equal(["12S", Rational(-1,4), 2336118.19, 1.0e-06, 1684.0, 365.241696],
        [formula.formula, formula.longitude_shift, formula.day_epoch, formula.year_delta, formula.year_epoch, formula.year_length.to_f])
      m = When::Coordinates::Residue.mod(date.to_i+1) {|cn| formula.cn_to_time(cn)}
      t = formula.cn_to_time(m[0]) + Rational(1,2)
    # assert_equal(["1690-01-01", 2338355, 20278, [15.923047, 30.436807, 2338340.576953]],
    #   [date.to_s, date.to_i, m[0], [m[1], m[2], t].map {|x| (x*1000000).round / 1000000.0}])

      date     = When.when?('1801-1-1^^JapaneseTwin::寛政暦(節月)')
      formula = date.frame.formula[0]
      class << formula
        attr_reader :day_epoch, :day_shift, :year_delta, :year_epoch, :year_length, :longitude_shift
      end
      assert_equal(["12S", Rational(-1,4), 2377390.607112, 1797.0, 365.242347071],
        [formula.formula, formula.longitude_shift, formula.day_epoch, formula.year_epoch, formula.year_length.to_f])
      m = When::Coordinates::Residue.mod(date.to_i+1) {|cn| formula.cn_to_time(cn)}
      t = formula.cn_to_time(m[0]) + Rational(1,2)
    # assert_equal(["1801-01-01", 2378897, 21610, [15.986637, 30.436862, 2378882.513363]],
    #   [date.to_s, date.to_i, m[0], [m[1], m[2], t].map {|x| (x*1000000).round / 1000000.0}])
    end

    def test_chinese_era
      assert_equal("慶元03(1197).01.10",          When.when?('慶元3.1.10').to_s)    # , {'period'=>/清/})
      assert_equal("紹熙03(1192).01.10",          When.when?('紹煕3.1.10').to_s)    # , {'period'=>/清/})
      assert_equal("康熙03(1664).01.10",          When.when?('康煕3.1.10').to_s)    # , {'period'=>/清/})
      assert_equal("紹熙03(1192).01.10",          When.when?('紹熙3.1.10').to_s)    # , {'period'=>/清/})
      assert_equal("崇徳03(1638).01.30",          When.when?('崇徳3.1.30', {'period'=>/清/}).to_s)
      assert_raises(ArgumentError) {When.when?('崇徳3.1.30', {'period'=>/後金/})}
      assert_equal("正徳16(1521).03.14",          When.TemporalPosition("正徳", 16, 3, 14, {"period"=>/明/}).to_s)
      assert_equal("正徳16(1521).03.14",          When.when?('正徳16.3.14', {'period'=>/明/}).to_s)
      assert_equal("中国::明::崇禎11(1638).01.30",When.when?('崇禎11.1.30', {'period'=>/明/}).to_s)
    end
  end
end
