# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2020 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module MiniTest

  class Japanese < MiniTest::TestCase

    include When::CalendarNote::Japanese::Index
    Masks = MD廿四節気|MD七十二候|MD六十卦|MD没|MD往亡

    def test_japanese_epoch
      eras = When.Resource('_e:Japanese')

      sample = 
        [["天平21(0749).04.13", "天平感宝01(0749).04.13", "天平勝宝01(0749).04.13"],
         ["天平21(0749).04.13"],
         ["天平感宝01(0749).04.14", "天平勝宝01(0749).04.14"],
         ["天平感宝01(0749).04.14"],
         ["天平勝宝01(0749).07.02"],
         ["天平勝宝01(0749).07.02"]]
         ['天平勝宝01.04.13', '天平勝宝01.04.14', '天平勝宝01.07.02'].each do |string|
        assert_equal(sample.shift, ((When.when?(string) ^ eras).
                                     delete_if {|d| !d.leaf?}).map {|d| d.to_s})
        assert_equal(sample.shift, ((When.when?(string, {:lower=>true}) ^ eras).
                                     delete_if {|d| !d.leaf?}).map {|d| d.to_s})
      end

      sample =
        [["大正15(1926).12.24"],
         ["大正15(1926).12.24"],
         ["昭和01(1926).12.25"],
         ["昭和01(1926).12.25"],
         ["昭和01(1926).12.26"],
         ["昭和01(1926).12.26"]]
      ['大正15.12.24', '大正15.12.25', '大正15.12.26'].each do |string|
        assert_equal(sample.shift, ((When.when?(string) ^ eras).
                                     delete_if {|d| !d.leaf?}).map {|d| d.to_s})
        assert_equal(sample.shift, ((When.when?(string, {:lower=>true}) ^ eras).
                                     delete_if {|d| !d.leaf?}).map {|d| d.to_s})
      end
    end

    def test__solar_terms
      sample = [
        [ # 修正後
          ["貞観12(0870).07.17T+00", []],
          ["貞観12(0870).07.18T+00", ["処暑(150)", "鷹乃祭鳥", "公損", "没"]],
          ["貞観12(0870).07.19T+00", []],

          ["天喜05(1057).03.10T+00", []],
          ["天喜05(1057).03.11T+00", ["穀雨(30)", "萍始生", "公革", "没"]],
          ["天喜05(1057).03.12T+00", []],

          ["建仁02(1202).10=29T+00", ["没"]],
          ["建仁02(1202).11.01T+00", ["冬至(270)", "蚯蚓結", "公中孚"]],
          ["建仁02(1202).11.02T+00", []],
          ["建仁02(1202).11.03T+00", []],

          ["寛元01(1243).11.03T+00", []],
          ["寛元01(1243).11.04T+00", ["冬至(270)", "蚯蚓結", "公中孚", "没"]],
          ["寛元01(1243).11.05T+00", []],

          ["弘安04(1281).07=30T+00", ["没"]],
          ["弘安04(1281).08.01T+00", ["秋分(180)", "雷乃收聲", "公賁"]],
          ["弘安04(1281).08.02T+00", []],

          ["永享02(1430).07.11T+00", ["没"]],
          ["永享02(1430).07.12T+00", []],
          ["永享02(1430).07.13T+00", []],
          ["永享02(1430).07.14T+00", ["大夫節"]],
          ["永享02(1430).07.15T+00", []],
          ["永享02(1430).07.16T+00", ["白露降"]],
          ["永享02(1430).07.17T+00", []],
          ["永享02(1430).07.18T+00", []],
          ["永享02(1430).07.19T+00", ["往亡"]],
          ["永享02(1430).07.20T+00", ["卿同人"]],
          ["永享02(1430).07.21T+00", ["寒蟬鳴"]],
          ["永享02(1430).07.22T+00", []],
          ["永享02(1430).07.23T+00", []],
          ["永享02(1430).07.24T+00", []],
          ["永享02(1430).07.25T+00", []],

          ["元和03(1617).03.18T+00", []],
          ["元和03(1617).03.19T+00", ["穀雨(30)", "萍始生", "公革", "没"]],
          ["元和03(1617).03.20T+00", []],

          ["平成06(1994).06.21T+09:00", ["夏至(90)", "乃東枯"]],
          ["平成06(1994).06.22T+09:00", []]
        ],

        [ # 修正前
          ["貞観12(0870).07.17T+00", ["没"]],
          ["貞観12(0870).07.18T+00", ["処暑(150)", "鷹乃祭鳥", "公損"]],
          ["貞観12(0870).07.19T+00", []],

          ["天喜05(1057).03.10T+00", ["没"]],
          ["天喜05(1057).03.11T+00", ["穀雨(30)", "萍始生", "公革"]],
          ["天喜05(1057).03.12T+00", []],

          ["建仁02(1202).10=29T+00", ["冬至(270)", "蚯蚓結", "公中孚"]],
          ["建仁02(1202).11.01T+00", []],
          ["建仁02(1202).11.02T+00", []],
          ["建仁02(1202).11.03T+00", ["没"]],

          ["寛元01(1243).11.03T+00", ["没"]],
          ["寛元01(1243).11.04T+00", ["冬至(270)", "蚯蚓結", "公中孚"]],
          ["寛元01(1243).11.05T+00", []],

          ["弘安04(1281).07=30T+00", ["秋分(180)", "雷乃收聲", "公賁"]],
          ["弘安04(1281).08.01T+00", []],
          ["弘安04(1281).08.02T+00", ["没"]],

          ["永享02(1430).07.11T+00", []],
          ["永享02(1430).07.12T+00", []],
          ["永享02(1430).07.13T+00", ["大夫節"]],
          ["永享02(1430).07.14T+00", []],
          ["永享02(1430).07.15T+00", ["白露降"]],
          ["永享02(1430).07.16T+00", []],
          ["永享02(1430).07.17T+00", []],
          ["永享02(1430).07.18T+00", ["往亡"]],
          ["永享02(1430).07.19T+00", ["卿同人"]],
          ["永享02(1430).07.20T+00", ["寒蟬鳴"]],
          ["永享02(1430).07.21T+00", []],
          ["永享02(1430).07.22T+00", []],
          ["永享02(1430).07.23T+00", []],
          ["永享02(1430).07.24T+00", []],
          ["永享02(1430).07.25T+00", ["没"]],

          ["元和03(1617).03.18T+00", ["没"]],
          ["元和03(1617).03.19T+00", ["穀雨(30)", "萍始生", "公革"]],
          ["元和03(1617).03.20T+00", []],

          ["平成06(1994).06.21T+09:00", ["夏至(90)", "乃東枯"]],
          ["平成06(1994).06.22T+09:00", []]
        ]
      ]

      2.times do
        result = []
        [2039054..2039056,
         2107233..2107235,
         2160437..2160440,
         2175412..2175414,
         2189200..2189202,
         2243577..2243591,
         2311770..2311772,
         2449525..2449526].each do |range|
          range.each do |jdn|
            (When.when?(jdn) ^ When.CalendarEra('Japanese')).each do |date|
              dates = When.CalendarNote('Japanese').send(:_to_date_for_note, date)
              date  = When.when?(dates.o_date.to_cal_date.to_s,
                               {:clock=>dates.s_date.frame.time_basis})
              long  = dates.cal4note.s_terms.position(date)
              notes = date.notes(:indices => When::DAY,
                                 :notes   => Masks,
                                 :locale  => 'ja').simplify[:value].compact
              result << [date.to_m17n/'ja', notes]
            end
          end
        end
        assert_equal(sample.shift, result)
        When::CalendarNote::Japanese::SolarTerms.send(:patch=, {})
      end
      When::CalendarNote::Japanese::SolarTerms.send(:patch=, nil)

      assert_equal('白露(135.375/560)',
        When.when?('康和1.8.14').notes(:notes=>'廿四節気', :shoyo=>true)[:value].simplify.to_s)

    end

    def test__lunar_phases
      [%w(康和3.01.09 康和3.01.16 康和3.01.23),
       %w(康和3.02.08 康和3.02.16 康和3.02.23),
       %w(康和3.03.08 康和3.03.15 康和3.03.22),
       %w(康和3.04.09 康和3.04.16 康和3.04.23),
       %w(康和3.05.08 康和3.05.15 康和3.05.22),
       %w(康和3.06.08 康和3.06.15 康和3.06.23),
       %w(康和3.07.08 康和3.07.15 康和3.07.22),
       %w(康和3.08.07 康和3.08.14 康和3.08.22),
       %w(康和3.09.07 康和3.09.15 康和3.09.23),
       %w(康和3.10.08 康和3.10.15 康和3.10.23),
       %w(康和3.11.07 康和3.11.15 康和3.11.23),
       %w(康和3.12.08 康和3.12.16 康和3.12.23),

       %w(平成26.01.01 平成26.01.08 平成26.01.16 平成26.01.24),
       %w(平成26.01.31 平成26.02.07 平成26.02.15 平成26.02.23),
       %w(平成26.03.01 平成26.03.08 平成26.03.17 平成26.03.24),
       %w(平成26.03.31 平成26.04.07 平成26.04.15 平成26.04.22),
       %w(平成26.04.29 平成26.05.07 平成26.05.15 平成26.05.21),
       %w(平成26.05.29 平成26.06.06 平成26.06.13 平成26.06.20),
       %w(平成26.06.27 平成26.07.05 平成26.07.12 平成26.07.19),
       %w(平成26.07.27 平成26.08.04 平成26.08.11 平成26.08.17),
       %w(平成26.08.25 平成26.09.02 平成26.09.09 平成26.09.16),
       %w(平成26.09.24 平成26.10.02 平成26.10.08 平成26.10.16),
       %w(平成26.10.24 平成26.10.31 平成26.11.07 平成26.11.15),
       %w(平成26.11.22 平成26.11.29 平成26.12.06 平成26.12.14),
       %w(平成26.12.22 平成26.12.29)
      ].each do |month|
        assert_equal([true], month.map {|date| When.when?(date).is?('月相')}.uniq)
      end
    end

    def test__eclipse
      date = When.when?('貞観4.2.1')
      assert_equal('夜日蝕七分', date.notes({:notes=>'日食'}).value)
      assert_nil(date.notes({:notes=>'日食', :solar_eclipse=>1}).value)

      date = When.when?('貞観4.2.15')
      assert_equal('(月蝕ニ分)', date.notes({:notes=>'月食'}).value)
      assert_nil(date.notes({:notes=>'月食', :lunar_eclipse=>3}).value)
    end

    def test_japanese_lunisolar
      assert_equal({1850=>{"hI"=>"Hi"}, 1866=>{"cD"=>"Cd"}, 1884=>{"cD"=>"Cd"}, 1947=>{"b"=>"c"}},
                    When.Calendar('Japanese').verify(When.Calendar('JapaneseTwin::旧暦'), 1844..2033))
    end

    def test_japanese_era
      assert_raises(RangeError) {When.TemporalPosition("正慶", 2, 11)}
      assert_equal("延元02(1337).01.08",          When.when?("建武4.1.8").to_s)
      assert_equal("延元02(1337).01.08",          When.TemporalPosition("建武", 4, 1, 8, {:invalid=>:non}).to_s)
      assert_equal("<神武>03(-657).01.30",        When.when?('神武3.1.30').to_s)    # , {'period'=>/清/})
      assert_equal("日本::皇紀2600(1940).01.30",  When.when?('皇紀2600.1.30').to_s) # , {'period'=>/清/})
      assert_equal("応永11(1404).12.10",          When.when?('嘉慶18.12.10').to_s)
      assert_equal("明治01(1868).09.08",          When.when?('明治1(1868).09.08').to_s)
      assert_equal("天保03(0564).10.01",          When.when?('天保3.10.01', {'period'=>/梁/}).to_s)
      assert_equal(%w(元暦 文治 建久 正治 建仁 元久 建永 承元 建暦 建保
                      承久 貞応 元仁 嘉禄 安貞 寛喜 貞永 天福 文暦 嘉禎
                      暦仁 延応 仁治 寛元 宝治 建長 康元 正嘉 正元 文応
                      弘長 文永 建治 弘安 正応 永仁 正安 乾元 嘉元 徳治
                      延慶 応長 正和 文保 元応 元亨 正中 嘉暦 元徳 元弘),
                   When.era('鎌倉時代')[0].map { |era| era.label.to_s})

      date = When.when?('768-10-20^^Gregorian')
      assert_equal('神護景雲02(0768).09.02',                        (date ^ When.CalendarEra('Japanese'))[0].to_s)
      assert_equal('日本?V=0764::奈良時代::神護景雲02(0768).09.01', (date ^ When.CalendarEra('Japanese?V=0764'))[0].to_s)
      assert_equal('日本::奈良時代::神護景雲02(0768).09.02',        (date ^ When.CalendarEra('Japanese'))[0].to_s)
    end

    def test__japanese_parser
      assert_equal('1945-08-15', When.when?('1945 Aug 15', :parse=>'%Y %B %d').to_s)
      assert_equal('2022-01-06T09:18:24+09:00', When.when?('Thu Jan 6  9:18:24 JST', {:abbr=>2015, :parse=>'%A %B %d %H:%M:%S %z'}).to_s)
      assert_equal('2022-01-06T09:18:24+09:00', When.when?('木 1月 6  9:18:24 JST', {:abbr=>2015, :parse=>['%A %B %d %H:%M:%S %z', 'ja']}).to_s)
      assert_equal('昭和15(1940).11.20', When.when?('昭和十五年十一月廿日', {:parse=>When::Locale::JapaneseParser}).to_s)
      assert_equal('昭和59(1984).11.26', When.when?('昭和甲子年11月甲子', {:parse=>When::Locale::JapaneseParser}).to_s)
      assert_equal('昭和59(1984).11.26', When.when?('昭和甲子歳11月甲子', {:parse=>When::Locale::JapaneseParser}).to_s)
      assert_equal('明治01(1868).04=07T12:06:03+09:00', When.when?('明治元年閏4月甲寅12時6分3秒+09:00',
                                                       {:parse=>When::Locale::JapaneseParser}).to_s)
    end

    def test__japanese_digits
      When::Locale::NumRExp3
      assert_equal([512100060, 1200000000, 230000000, 34000000, 4500000, 560000, 67000, 7800, 890, 90, 0],
      %w(伍億仟弐佰拾萬陸拾 十二億 二億三千万 三千四百万 四百五十万 五十六万 六万七千 七千八百 八百九十 九十零 零).map {|fig|
        When::Locale.k2a_digits(fig, true)
      })
    end

=begin
    def test_japanese_date
      jc   = When.Resource('_c:Japanese')
      diff = []
      open('test/region/japanese-calendar.txt', "1".respond_to?(:force_encoding) ? 'r:utf-8' : 'r') do |f|
        while (line = f.gets)
          next if line =~ /\A *#/
          x, x, jdn, x, x, x, gy, gm, gd, x, x, jy, jm, jd = line.split(/ +/).map {|v| v.to_i}
          jm, leap = (jm > 0) ? [jm, '-'] : [-jm, '=']
          date = When.when?("%04d-%02d%s%02d" % [(gm >= jm) ? gy : gy-1, jm, leap, jd], {:frame=>jc})
          diff << [jdn - date.to_i, date.to_s] unless jdn == date.to_i
        end
      end
      assert_equal([], diff)
    end
=end
  end
end
