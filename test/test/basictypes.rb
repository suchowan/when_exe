# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2014 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module MiniTest

  module BasicTypes

    #
    # ISO 8601 Date and Time Representation
    #
    class DateTime < TestCase

      def test__to_array_assert
       assert_raises(TypeError)     { When::BasicTypes::DateTime._to_array(1)  }
       assert_raises(ArgumentError) { When::BasicTypes::DateTime._to_array("") }
      end

      def test__x0301_5_2_1
        [                                                     # 5.2.1 暦日付
         ["19850412",                [ 0, "1985-04-12"]],     #  1 完全表記 基本形式
         ["1985-04-12",              [ 0, "1985-04-12"]],     #  1 完全表記 拡張形式
         ["1985-04",                 [-1, "1985-04"   ]],     #  2 a) 下位省略表記 特定の月 基本形式
         ["1985",                    [-2, "1985"      ]],     #  2 b) 下位省略表記 特定の年 基本形式
         ["19",                      [-4, "1900"      ]],     #  2 c) 下位省略表記 特定の百年台 基本形式
         ["850412",                  [ 0, "1985-04-12"]],     #  3 a) 上位省略表記 ある百年代の特定の日 基本形式
         ["85-04-12",                [ 0, "1985-04-12"]],     #  3 a) 上位省略表記 ある百年代の特定の日 拡張形式
         ["-8504",                   [-1, "1985-04"   ]],     #  3 b) 上位省略表記 ある百年代の特定の月 基本形式
         ["-85-04",                  [-1, "1985-04"   ]],     #  3 b) 上位省略表記 ある百年代の特定の月 拡張形式
         ["-85",                     [-2, "1985"      ]],     #  3 c) 上位省略表記 ある百年代の特定の年 基本形式
         ["--0412",                  [ 0, "1985-04-12"]],     #  3 d) 上位省略表記 ある年の特定の月日 基本形式
         ["--04-12",                 [ 0, "1985-04-12"]],     #  3 d) 上位省略表記 ある年の特定の月日 拡張形式
         ["--04",                    [-1, "1985-04"   ]],     #  3 e) 上位省略表記 ある年の特定の月 基本形式
         ["---12",                   [ 0, "1985-04-12"]],     #  3 f) 上位省略表記 ある月の特定の日 基本形式
         ["+019850412",              [ 0, "1985-04-12"]],     #  4 a) 拡大表記 特定の日 基本形式
         ["+01985-04-12",            [ 0, "1985-04-12"]],     #  4 a) 拡大表記 特定の日 拡張形式
         ["+01985-04",               [-1, "1985-04"   ]],     #  4 b) 拡大表記 特定の月 基本形式
         ["+01985",                  [-2, "1985"      ]],     #  4 c) 拡大表記 特定の年 基本形式
         ["+019",                    [-4, "1900"      ]],     #  4 d) 拡大表記 特定の百年代 基本形式
        ].each do |sample|
          date = When.when?(sample[0], {:abbr=>[1985,4,12]})
          assert_equal(sample[1], [date.precision, date.to_s])
        end
      end

      def test__x0301_5_2_1_4
        [                                                     # 5.2.1.4 暦日付 拡大表記(Abbr 指定なし)
         ["-019850412",              [ 0, "-01985-04-12"]],   #  4 a) 拡大表記 特定の日 基本形式
         ["+019850412",              [ 0,   "1985-04-12"]],   #  4 a) 拡大表記 特定の日 基本形式
         ["-01985-04-12",            [ 0, "-01985-04-12"]],   #  4 a) 拡大表記 特定の日 拡張形式
         ["+01985-04-12",            [ 0,   "1985-04-12"]],   #  4 a) 拡大表記 特定の日 拡張形式
         ["-01985-04",               [-1, "-01985-04"   ]],   #  4 b) 拡大表記 特定の月 基本形式
         ["+01985-04",               [-1,   "1985-04"   ]],   #  4 b) 拡大表記 特定の月 基本形式
         ["-01985",                  [-2, "-01985"      ]],   #  4 c) 拡大表記 特定の年 基本形式
         ["+01985",                  [-2,   "1985"      ]],   #  4 c) 拡大表記 特定の年 基本形式
         ["-0190",                   [-2, "-00190"      ]],   #  4 d) 拡大表記 特定の年 基本形式
         ["+0190",                   [-2,   "0190"      ]],   #  4 d) 拡大表記 特定の年 基本形式
         ["-019",                    [-4, "-01900"      ]],   #  4 d) 拡大表記 特定の百年代 基本形式
         ["+019",                    [-4,   "1900"      ]],   #  4 d) 拡大表記 特定の百年代 基本形式
         ["-119",                    [-4, "-11900"      ]],   #  4 d) 拡大表記 特定の百年代 基本形式
         ["+119",                    [-4, "+11900"      ]],   #  4 d) 拡大表記 特定の百年代 基本形式
        ].each do |sample|
          date = When.when?(sample[0])
          assert_equal(sample[1], [date.precision, date.to_s])
        end
      end

      def test__x0301_5_2_2
        [                                                     # 5.2.2 年間通算日
         ["1985102",                 [ 0, "1985-04-12"]],     #  1 完全表記 基本形式
         ["1985-102",                [ 0, "1985-04-12"]],     #  1 完全表記 拡張形式
         ["85102",                   [ 0, "1985-04-12"]],     #  2 a) 上位省略表記 ある百年代の特定の年日 基本形式
         ["85-102",                  [ 0, "1985-04-12"]],     #  2 a) 上位省略表記 ある百年代の特定の年日 拡張形式
         ["-102",                    [ 0, "1985-04-12"]],     #  2 b) 上位省略表記 ある年の特定の日 基本形式
         ["+01985102",               [ 0, "1985-04-12"]],     #  3 a) 拡大表記 特定の日 基本形式
         ["+01985-102",              [ 0, "1985-04-12"]],     #  3 a) 拡大表記 特定の日 拡張形式
        ].each do |sample|
          date = When.when?(sample[0], {:abbr=>[1985,4,12]})
          assert_equal(sample[1], [date.precision, date.to_s])
        end
      end

      def test__x0301_5_2_3
        [                                                     # 5.2.3 暦週日付
         ["1985W155",                [ 0, "1985-04-12"]],     #  1 完全表記 基本形式
         ["1985-W15-5",              [ 0, "1985-04-12"]],     #  1 完全表記 拡張形式
         ["1985W15",    [ 0, "1985-04-08...1985-04-15"]],     #  2 a) 下位省略表記 基本形式
         ["1985-W15",   [ 0, "1985-04-08...1985-04-15"]],     #  2 a) 下位省略表記 拡張形式
         ["85W155",                  [ 0, "1985-04-12"]],     #  3 a) 上位省略表記 ある百年代における年週日 基本形式
         ["85-W15-5",                [ 0, "1985-04-12"]],     #  3 a) 上位省略表記 ある百年代における年週日 拡張形式
         ["85W15",      [ 0, "1985-04-08...1985-04-15"]],     #  3 b) 上位省略表記 ある百年代における年週 基本形式
         ["85-W15",     [ 0, "1985-04-08...1985-04-15"]],     #  3 b) 上位省略表記 ある百年代における年週 拡張形式
         ["-5W155",                  [ 0, "1985-04-12"]],     #  3 c) 上位省略表記 ある十年代における年週日 基本形式
         ["-5-W15-5",                [ 0, "1985-04-12"]],     #  3 c) 上位省略表記 ある十年代における年週日 拡張形式
         ["-5W15",      [ 0, "1985-04-08...1985-04-15"]],     #  3 d) 上位省略表記 ある十年代における年週 基本形式
         ["-5-W15",     [ 0, "1985-04-08...1985-04-15"]],     #  3 d) 上位省略表記 ある十年代における年週 拡張形式
         ["-W155",                   [ 0, "1985-04-12"]],     #  3 e) 上位省略表記 ある年の週日 基本形式
         ["-W15-5",                  [ 0, "1985-04-12"]],     #  3 e) 上位省略表記 ある年の週日 拡張形式
         ["-W15",       [ 0, "1985-04-08...1985-04-15"]],     #  3 f) 上位省略表記 ある年の週 基本形式
         ["-W-5",                    [ 0, "1985-04-12"]],     #  3 g) 上位省略表記 ある週の日 基本形式
         ["+01985W155",              [ 0, "1985-04-12"]],     #  4 a) 拡大表記 特定の日 基本形式
         ["+01985-W15-5",            [ 0, "1985-04-12"]],     #  4 a) 拡大表記 特定の日 拡張形式
         ["+01985W15",  [ 0, "1985-04-08...1985-04-15"]],     #  4 b) 拡大表記 特定の週 基本形式
         ["+01985-W15", [ 0, "1985-04-08...1985-04-15"]],     #  4 c) 拡大表記 特定の週 拡張形式
        ].each do |sample|
          date = When.when?(sample[0], {:abbr=>[1985,15,5]})
          assert_equal(sample[1], [date.precision, date.to_s])
        end

        result = []
        (1900...1928).each do |year|
          date = ::Date.new(year, 1, 1) - 7
          14.times do
            gdate     = When.TemporalPosition(date.year, date.month, date.day)
            strdate   = date.strftime('%G-W%V-%u')
            strgdate  = gdate.strftime('%G-W%V-%u')
            w1date    = When::WeekDate ^ date
            w2date    = When.when?(strdate, {:frame=>When::WeekDate})
            strw1date = w1date.strftime
            strw2date = w2date.strftime
            result << [[strdate, strgdate, strw1date, strw2date].uniq.size, date.jd == w1date.to_i, date.jd == w2date.to_i]
          end
        end
        assert_equal([[1, true, true]], result.uniq)
      end

      def test__x0301_5_2_4
        [                                                     # 5.2.4 元号による日付
         ["60.04.12",        [ 0, "S60(1985).04.12"]],        #  1 完全表記 基本形式
         ["S60.04.12",       [ 0, "S60(1985).04.12"]],        #  1 完全表記 拡張形式
        ].each do |sample|
          date = When.when?(sample[0], {:era_name=>'S'})
          assert_equal(sample[1], [date.precision, date.to_s])
        end
      end

      def test__x0301_5_3_1
        When::TM::Clock.local_time = When::UTC

        [                                                             # 5.3.1 地方時の時刻
         ["T232050",                [ 3, "T23:20:50"          ]],     #  1 完全表記 基本形式
         ["T23:20:50",              [ 3, "T23:20:50"          ]],     #  1 完全表記 拡張形式
         ["T2320",                  [ 2, "T23:20"             ]],     #  2 a) 下位省略表記 特定の時分 基本形式
         ["T23:20",                 [ 2, "T23:20"             ]],     #  2 a) 下位省略表記 特定の時分 拡張形式
         ["T23",                    [ 1, "T23"                ]],     #  2 b) 下位省略表記 特定の時 基本形式
        ].each do |sample|
          date = When.when?(sample[0])
          assert_equal(sample[1], [date.precision, date.to_s])
        end

        [                                                             #  3 小数点を用いる表記
         ["T232050.5",   4,         [ 4, "T23:20:50.5"        ]],     #   a) 特定の時分秒及び秒の小数部分 基本形式
         ["T152735,5",   4,         [ 4, "T15:27:35.5"        ]],     #   a) 特定の時分秒及び秒の小数部分 基本形式
         ["T23:20:50.5", 4,         [ 4, "T23:20:50.5"        ]],     #   a) 特定の時分秒及び秒の小数部分 拡張形式
         ["T2320.8",     3,         [ 3, "T23:20:48"          ]],     #   b) 特定の時分及び分の小数部分 基本形式
         ["T23:20.8",    3,         [ 3, "T23:20:48"          ]],     #   b) 特定の時分及び分の小数部分 拡張形式
         ["T23.3",       2,         [ 2, "T23:18"             ]],     #   c) 特定の時及び時の小数部分 基本形式
        ].each do |sample|
          date = When.when?(sample[0], {:precision=>sample[1]})
          assert_equal(sample[2], [date.precision, date.to_s])
        end

        [                                                             #  4 上位省略表記
         ["T-2050",                 [ 3, "T23:20:50"          ]],     #   a) ある時“hour”における特定の分秒 基本形式
         ["T-:20:50",               [ 3, "T23:20:50"          ]],     #   a) ある時“hour”における特定の分秒 拡張形式
         ["T-20",                   [ 2, "T23:20"             ]],     #   b) ある時“hour”における特定の分 基本形式
         ["T--50",                  [ 3, "T23:20:50"          ]],     #   c) ある分の特定の秒 基本形式
        ].each do |sample|
          date = When.when?(sample[0], {:abbr=>[1985,4,12,23,20,50]})
          assert_equal(sample[1], [date.precision, date.to_s])
        end

        [                                                             #  4 小数点を用いる上位省略表記
         ["T-2050.5",    4,         [ 4, "T23:20:50.5"        ]],     #   a) ある時“hour”における特定の分秒 基本形式
         ["T-2735,5",    4,         [ 4, "T23:27:35.5"        ]],     #   a) ある時“hour”における特定の分秒 基本形式
         ["T-:20:50.5",  4,         [ 4, "T23:20:50.5"        ]],     #   a) ある時“hour”における特定の分秒 拡張形式
         ["T-20.8",      3,         [ 3, "T23:20:48"          ]],     #   b) ある時“hour”における特定の分 基本形式
         ["T--50.5",     4,         [ 4, "T23:20:50.5"        ]],     #   c) ある分の特定の秒 基本形式
        ].each do |sample|
          date = When.when?(sample[0], {:abbr=>[1985,4,12,23,20,50], :precision=>sample[1]})
          assert_equal(sample[2], [date.precision, date.to_s])
        end
      end

      def test__x0301_5_3_2
        When::TM::Clock.local_time = When.Clock("+0900")
        [                                                             # 5.3.2 夜の12時
         ["19850412T240000",        [ 3, "1985-04-13T00:00:00"]],     #  完全表記 基本形式
         ["1985-04-12T24:00:00",    [ 3, "1985-04-13T00:00:00"]],     #  完全表記 拡張形式
         ["19850412T2400",          [ 2, "1985-04-13T00:00"   ]],     #  下位省略表記 基本形式
         ["1985-04-12T24:00",       [ 2, "1985-04-13T00:00"   ]],     #  下位省略表記 拡張形式
        ].each do |sample|
          date = When.when?(sample[0])
          assert_equal(sample[1], [date.precision, date.to_s])
        end
      end

      def test__x0301_5_3_3
        [                                                             # 5.3.3 協定世界時(UTC)の時刻
         ["T232050Z",               [ 3, "T23:20:50Z"         ]],     #  1 完全表記 基本形式
         ["T23:20:50Z",             [ 3, "T23:20:50Z"         ]],     #  1 完全表記 拡張形式
         ["T2320Z",                 [ 2, "T23:20Z"            ]],     #  2 a) 下位省略表記 特定の時分 基本形式
         ["T23:20Z",                [ 2, "T23:20Z"            ]],     #  2 a) 下位省略表記 特定の時分 拡張形式
         ["T23Z",                   [ 1, "T23Z"               ]],     #  2 b) 下位省略表記 特定の時 基本形式
        ].each do |sample|
          date = When.when?(sample[0])
          assert_equal(sample[1], [date.precision, date.to_s])
        end

        [                                                             #  3 小数点を用いる表記
         ["T232050.5Z",  4,         [ 4, "T23:20:50.5Z"       ]],     #   a) 特定の時分秒及び秒の小数部分 基本形式
         ["T23:20:50.5Z",4,         [ 4, "T23:20:50.5Z"       ]],     #   a) 特定の時分秒及び秒の小数部分 拡張形式
         ["T2320.8Z",    3,         [ 3, "T23:20:48Z"         ]],     #   b) 特定の時分及び分の小数部分 基本形式
         ["T23:20.8Z",   3,         [ 3, "T23:20:48Z"         ]],     #   b) 特定の時分及び分の小数部分 拡張形式
         ["T23.3Z",      2,         [ 2, "T23:18Z"            ]],     #   c) 特定の時及び時の小数部分 基本形式
        ].each do |sample|
          date = When.when?(sample[0], {:precision=>sample[1]})
          assert_equal(sample[2], [date.precision, date.to_s])
        end

        [                                                             #  4 上位省略表記
         ["T-2050Z",                [ 3, "T23:20:50Z"         ]],     #   a) ある時“hour”における特定の分秒 基本形式
         ["T-:20:50Z",              [ 3, "T23:20:50Z"         ]],     #   a) ある時“hour”における特定の分秒 拡張形式
         ["T-20Z",                  [ 2, "T23:20Z"            ]],     #   b) ある時“hour”における特定の分 基本形式
         ["T--50Z",                 [ 3, "T23:20:50Z"         ]],     #   c) ある分の特定の秒 基本形式
        ].each do |sample|
          date = When.when?(sample[0], {:abbr=>[1985,4,12,23,20,50]})
          assert_equal(sample[1], [date.precision, date.to_s])
        end

        [                                                             #  4 小数点を用いる上位省略表記
         ["T-2050.5Z",   4,         [ 4, "T23:20:50.5Z"       ]],     #   a) ある時“hour”における特定の分秒 基本形式
         ["T-:20:50.5Z", 4,         [ 4, "T23:20:50.5Z"       ]],     #   a) ある時“hour”における特定の分秒 拡張形式
         ["T-20.8Z",     3,         [ 3, "T23:20:48Z"         ]],     #   b) ある時“hour”における特定の分 基本形式
         ["T--50.5Z",    4,         [ 4, "T23:20:50.5Z"       ]],     #   c) ある分の特定の秒 基本形式
        ].each do |sample|
          date = When.when?(sample[0], {:abbr=>[1985,4,12,23,20,50], :precision=>sample[1]})
          assert_equal(sample[2], [date.precision, date.to_s])
        end
      end

      def test__x0301_5_3_4
        [                                                             # 5.3.4 地方時及び協定世界時
         ["T+0100",                 [ 0, "T+01:00"            ]],     #  1 地方時と協定世界時との差(時差の表記) 基本形式
         ["T+01",                   [ 0, "T+01:00"            ]],     #  1 地方時と協定世界時との差(時差の表記) 基本形式
         ["T+01:00",                [ 0, "T+01:00"            ]],     #  1 地方時と協定世界時との差(時差の表記) 拡張形式
         ["T152746+0100",           [ 3, "T15:27:46+01:00"    ]],     #  2 地方時と協定世界時との差(地方時の表記) 基本形式
         ["T152746-0500",           [ 3, "T15:27:46-05:00"    ]],     #  2 地方時と協定世界時との差(地方時の表記) 基本形式
         ["T152746+01",             [ 3, "T15:27:46+01:00"    ]],     #  2 地方時と協定世界時との差(地方時の表記) 基本形式
         ["T152746-05",             [ 3, "T15:27:46-05:00"    ]],     #  2 地方時と協定世界時との差(地方時の表記) 基本形式
         ["T15:27:46+01:00",        [ 3, "T15:27:46+01:00"    ]],     #  2 地方時と協定世界時との差(地方時の表記) 拡張形式
         ["T15:27:46-05:00",        [ 3, "T15:27:46-05:00"    ]],     #  2 地方時と協定世界時との差(地方時の表記) 拡張形式
         ["T15:27:46+01",           [ 3, "T15:27:46+01:00"    ]],     #  2 地方時と協定世界時との差(地方時の表記) 拡張形式
         ["T15:27:46-05",           [ 3, "T15:27:46-05:00"    ]],     #  2 地方時と協定世界時との差(地方時の表記) 拡張形式
        ].each do |sample|
          date = When.when?(sample[0])
          assert_equal(sample[1], [date.precision, date.to_s])
        end
      end

      def test__x0301_5_4_2
        When::TM::Clock.local_time = When.Clock("+0900")
        [                                                             # 5.4.2 完全表記以外の表記
         ["19850412T1015",         [ 2, "1985-04-12T10:15"       ]],  #  a) 暦日付及び地方時 基本形式
         ["1985-04-12T10:15",      [ 2, "1985-04-12T10:15"       ]],  #  a) 暦日付及び地方時 拡張形式
         ["1985102T1015Z",         [ 2, "1985-04-12T10:15Z"      ]],  #  b) 年間通算日及び協定世界時 基本形式
         ["1985-102T10:15Z",       [ 2, "1985-04-12T10:15Z"      ]],  #  b) 年間通算日及び協定世界時 拡張形式
         ["1985W155T1015+0400",    [ 2, "1985-04-12T10:15+04:00" ]],  #  c) 暦週日付,地方時,及びUTCとの差 基本形式
         ["1985-W15-5T10:15+04:00",[ 2, "1985-04-12T10:15+04:00" ]],  #  c) 暦週日付,地方時,及びUTCとの差 拡張形式
        ].each do |sample|
          date = When.when?(sample[0])
          assert_equal(sample[1], [date.precision, date.to_s])
        end
      end

      def test__x0301_5_5_4
        When::TM::Clock.local_time = When.Clock("+0900")                                           # 時間間隔の表記
        [                                                                                          # 5.5.4 完全表記
         ["19850412T232050/19850625T103000",         "1985-04-12T23:20:50..1985-06-25T10:30:00" ], #  1 始点及び終点 基本形式
         ["1985-04-12T23:20:50/1985-06-25T10:30:00", "1985-04-12T23:20:50..1985-06-25T10:30:00" ], #  1 始点及び終点 拡張形式
         ["P2Y10M15DT10H30M20S",                     "P2Y10M15DT10H30M20S"                      ], #  2.1 時間の単位の指示記号付
         ["P6W",                                     "P6W"                                      ], #  2.1 時間の単位の指示記号付
         ["P1Y6M",                                   "P1Y6M"                                    ], #  2.1 時間の単位の指示記号付
         ["PT72H",                                   "PT72H"                                    ], #  2.1 時間の単位の指示記号付
         ["P00021015T103020",                        "P2Y10M15DT10H30M20S"                      ], #  2.2 代用形式 基本形式
         ["P0001-06",                                "P1Y6M"                                    ], #  2.2 代用形式 基本形式
         ["P010600",                                 "P1Y6M"                                    ], #  2.2 代用形式 基本形式
         ["P0002-10-15T10:30:20",                    "P2Y10M15DT10H30M20S"                      ], #  2.2 代用形式 拡張形式
         ["19850412T232050/P1Y2M15DT12H30M0S",       "1985-04-12T23:20:50...1986-06-28T11:50:50"], #  3 始点及び時間長 基本形式
         ["19850412T232050/P00010215T123000",        "1985-04-12T23:20:50...1986-06-28T11:50:50"], #  3 始点及び時間長 基本形式
         ["1985-04-12T23:20:50/P1Y2M15DT12H30M0S",   "1985-04-12T23:20:50...1986-06-28T11:50:50"], #  3 始点及び時間長 拡張形式
         ["1985-04-12T23:20:50/P0001-02-15T12:30:00","1985-04-12T23:20:50...1986-06-28T11:50:50"], #  3 始点及び時間長 拡張形式
         ["P1Y2M15DT12H30M0S/19850412T232050",       "1984-01-28T10:50:50..1985-04-12T23:20:50" ], #  4 時間長及び終点 基本形式
         ["P00010215T123000/19850412T232050",        "1984-01-28T10:50:50..1985-04-12T23:20:50" ], #  4 時間長及び終点 基本形式
         ["P1Y2M15DT12H30M0S/1985-04-12T23:20:50",   "1984-01-28T10:50:50..1985-04-12T23:20:50" ], #  4 時間長及び終点 拡張形式
         ["P0001-02-15T12:30:00/1985-04-12T23:20:50","1984-01-28T10:50:50..1985-04-12T23:20:50" ], #  4 時間長及び終点 拡張形式
        ].each do |sample|
          assert_equal(sample[1], When.when?(sample[0]).to_s)
        end
      end

      def test__x0301_5_6_3
        When::TM::Clock.local_time = When.Clock("+0900")                                           # 反復時間間隔の表記
        [                                                                                          # 5.6.3 完全表記
         ["R2/19850412T232050/19850625T103000",    ["1985-04-12T23:20:50","1985-06-25T10:30:00"]], #  始点及び終点
         ["R2/P2Y10M15DT10H30M20S",                ["P2Y10M15DT10H30M20S","P2Y10M15DT10H30M20S"]], #  時間間隔
         ["R2/19850412T232050/P1Y2M15DT12H30M0S",  ["1985-04-12T23:20:50","1986-06-28T11:50:50"]], #  始点及び時間間隔
         ["R2/P1Y2M15DT12H30M0S/19850412T232050",  ["1984-01-28T10:50:50","1985-04-12T23:20:50"]], #  時間間隔及び終点
        ].each do |sample|
          event = When.when?(sample[0])
          sample[1].each do |date|
            assert_equal(date, event.shift.to_s)
          end
        end
        [                                                                                          # 5.6.3 完全表記
         ["R/19850412T232050/19850625T103000",     ["1985-04-12T23:20:50","1985-06-25T10:30:00"]], #  始点及び終点
         ["R/19850412T232050/P1Y2M15DT12H30M0S",   ["1985-04-12T23:20:50","1986-06-28T11:50:50"]], #  始点及び時間間隔
        ].each do |sample|
          event = When.when?(sample[0]).each
          sample[1].each do |date|
            assert_equal(date, event.succ.to_s)
          end
        end
      end

      def test__abbr_and_extra_year_digits

        assert_equal('-00500',     When.when?('-005').to_s)
        assert_equal('2013-01-05', When.when?('-005', {:abbr=>2013}).to_s)
        assert_equal('-000005',    When.when?('-005', {:extra_year_digits=>2}).to_s)

        assert_equal('1900',       When.when?('19').to_s)
        assert_equal('1900',       When.when?('19', {:extra_year_digits=>0 }).to_s)
        assert_equal('0019',       When.when?('19', {:extra_year_digits=>-1}).to_s)

        [['019',        ["0019",    -2, "0019-01-01"  ]],
         ['0019',       ["0019",    -2, "0019-01-01"  ]],
         ['+019',       ["1900",    -4, "1900-01-01"  ]],
         ['-119',       ["-11900",  -4, "-11900-01-01"]],
         ['-0119',      ["-00119",  -2, "-00119-01-01"]],
         ['+01985-04',  ["1985-04", -1, "1985-04-01"  ]],
         ['+001985-04', ["1985-04", -1, "1985-04-01"  ]]].each do |sample|
          date = When.when?(sample[0])
          assert_equal(sample[1], [date.to_s, date.precision, date.floor.to_s])
        end
      end
    end

    #
    # ISO 8601 Date Representation
    #
    class Date < TestCase
      def test__to_array_basic_ISO8601
        assert_equal([nil, [1985,4,12]], When::BasicTypes::Date._to_array_basic_ISO8601('19850412'))
        assert_equal([nil, [1985]], When::BasicTypes::Date._to_array_basic_ISO8601('1985'))
        assert_equal([:century, [1900]], When::BasicTypes::Date._to_array_basic_ISO8601('19'))
      end

      def test__to_array_extended_ISO8601
        assert_equal([nil, [1985,4,12]], When::BasicTypes::Date._to_array_extended_ISO8601('1985-04-12'))
        assert_equal([nil, [1985,4]], When::BasicTypes::Date._to_array_extended_ISO8601('1985-04'))
        # assert_equal([19,nil,nil], When::BasicTypes::Date._to_array_extended_ISO8601('19'))
      end
    end

    #
    # ISO 8601 Time Representation
    #
    class Time < TestCase
      def test_nothing
      end
    end

    #
    # M17n String
    #
    class M17n < TestCase
      Term1 = When::BasicTypes::M17n.new('Tokyo', 'zip')
      Term2 = When::BasicTypes::M17n.new(<<LABEL, <<NS, <<LOCALE)
[
Getsuyou
Monday
]
LABEL
ISO, jwiki=http://ja.wikipedia.org/wiki/, ewiki=http://en.wikipedia.org/wiki/
NS
=jwiki:, en=ewiki:
LOCALE
      Term3 = When.Resource('_co:Common::Week::Monday::Monday')

      def test__code_space
        assert_equal('zip', Term1.codeSpace)
        assert_equal("ISO", Term2.codeSpace)
        assert_equal(nil, Term3.codeSpace)
      end

      def test__label
        assert_equal("Getsuyou", Term2.label.to_s)
        assert_equal(String, Term2.label.class)
        assert_equal("Monday", Term3.label.to_s)
      end
    end

    class Object < TestCase
      def test_nothing
      end
    end

  end

  module RS
    class Identifier < TestCase
      def test__forward
        name   = When.Residue('Monday').label
        monday = When::RS::Identifier.new(name)
        assert_equal("月曜日", monday / 'ja')
      end
    end
  end

  module EX
    class Extent < TestCase
      def test_nothing
      end
    end
  end
end
