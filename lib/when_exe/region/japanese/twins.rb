# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014-2015 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When

  class TM::CalendarEra

    # Historical Japanese Luni-Solar Calendar for Japanese Note
    JapaneseLuniSolar = [{}, self, [
      'locale:[=ja:, en=en:, zh=zh:, alias]',
      'area:[日本の暦月=, (Auto selected) JapaneseLuniSolar=, 被在日本使用陰陽曆=, *JapaneseLuniSolar=]',
      ['[平朔儀鳳暦=]01.01.01',  '@F',     '001-01-01^JapaneseTwin::平朔儀鳳暦'], # 西暦が正になるところから開始(実際は-659.01.01)
      ['[元嘉暦]454.01.01',        '@CR',  '454-01-01^ChineseTwin::元嘉暦', '697-01-01='],
      ['[儀鳳暦]697.01.01',        '@CR',  '697-01-01^ChineseTwin::麟徳暦'],
      ['[大衍暦]764.01.01',        '@CR',  '764-01-01^ChineseTwin::大衍暦'],
      ['[五紀暦]858.01.01',        '@CR',  '858-01-01^ChineseTwin::五紀暦'],
      ['[宣明暦]862.01.01',        '@CR',  '862-01-01^ChineseTwin::宣明暦'],
      ['[貞享乙丑暦=]1685.01.01',  '@CR', '1685-01-01^JapaneseTwin::貞享乙丑暦'],
      ['[貞享暦]1687.01.01',       '@CR', '1687-01-01^JapaneseTwin::貞享暦'    ],
      ['[宝暦癸酉暦=]1753.01.01',  '@CR', '1753-01-01^JapaneseTwin::宝暦癸酉暦'],
      ['[宝暦甲戌暦=]1754.01.01',  '@CR', '1754-01-01^JapaneseTwin::宝暦甲戌暦'],
      ['[宝暦暦]1755.01.01',       '@CR', '1755-01-01^JapaneseTwin::宝暦暦'    ],
      ['[修正宝暦暦=]1771.01.01',  '@CR', '1771-01-01^JapaneseTwin::修正宝暦暦'],
      ['[寛政暦]1798.01.01',       '@CR', '1798-01-01^JapaneseTwin::寛政暦'    ], # 京都平均太陽時
      ['[寛政丁亥暦=]1827.01.01',  '@CR', '1827-01-01^JapaneseTwin::寛政丁亥暦'], # 京都平均太陽時
      ['[天保暦]1844.01.01',       '@CR', '1844-01-01^JapaneseTwin#{?Clock=Clock}::天保暦'], # 京都真太陽時
      ['[旧々暦=,*JLSO=]1872.12.03','@CR','1872-12-03^JapaneseTwin::旧々暦'    ], # 東京平均太陽時
      ['[旧暦,*JLS=]1887.11.18',    '@CR','1887-11-18^JapaneseTwin::旧暦'      ]  # 日本標準時
    ]]

    # Historical Japanese Solar Calendar for Japanese Note
    JapaneseSolar = [{}, self, [
      'locale:[=ja:, en=en:, zh=zh, alias]',
      'area:[日本の節月=, (Auto selected) JapaneseSolar=, 被在日本使用陽曆=, *JapaneseSolar=]',
      ['[平朔儀鳳暦=]01.01.01',    '@F',   '001-01-01^JapaneseTwin::平朔儀鳳暦(節月)'], # 年の始めに遡って開始
      ['[元嘉暦]454.01.12',        '@CR',  '454-01-12^ChineseTwin::元嘉暦(節月)'],
      ['[儀鳳暦]696.12.27',        '@CR',  '696-12-27^ChineseTwin::麟徳暦(節月)'],
      ['[大衍暦]764.01.06',        '@CR',  '764-01-06^ChineseTwin::大衍暦(節月)'],
      ['[五紀暦]857.12.19',        '@CR',  '857-12-19^ChineseTwin::五紀暦(節月)'],
      ['[宣明暦]862.01.03',        '@CR',  '862-01-03^ChineseTwin::宣明暦(節月)'],
      ['[貞享乙丑暦=]1685.01.01',  '@CR', '1685-01-01^JapaneseTwin::貞享乙丑暦(節月)'],
      ['[貞享暦]1687.01.08',       '@CR', '1687-01-08^JapaneseTwin::貞享暦(節月)'    ],
      ['[宝暦癸酉暦=]1752.12.30',  '@CR', '1752-12-30^JapaneseTwin::宝暦癸酉暦(節月)'],
      ['[宝暦甲戌暦=]1753.12.19',  '@CR', '1753-12-19^JapaneseTwin::宝暦甲戌暦(節月)'],
      ['[宝暦暦]1755.01.07',       '@CR', '1755-01-07^JapaneseTwin::宝暦暦(節月)'    ],
      ['[修正宝暦暦=]1771.01.11',  '@CR', '1771-01-11^JapaneseTwin::修正宝暦暦(節月)', '1798.01.12='],
      ['[寛政暦]1798.01.12',       '@CR', '1798-01-12^JapaneseTwin::寛政暦(節月)'    ],
      ['[寛政丁亥暦=]1826.12.22',  '@CR', '1826-12-22^JapaneseTwin::寛政丁亥暦(節月)'],
      ['[天保暦]1844.01.14',       '@CR', '1844-01-14^JapaneseTwin#{?Clock=Clock}::天保暦(節月)'], # 京都真太陽時
      ['[旧々暦=,*JSO=]1872.11.26','@CR', '1872-11-26^JapaneseTwin::旧々暦(節月)'    ], # 東京平均太陽時
      ['[旧暦,*JS=]1887.11.26',    '@CR', '1887-11-26^JapaneseTwin::旧暦(節月)'      ]  # 日本標準時
    ]]
  end

  module CalendarTypes

    _japanese_common = {
      'year_delta'               => 1,         # 冬至年の変化率 / (10^(-6)日/年)
      'year_span'                => 1,         # 冬至年の改訂周期 / 年
      'lunation_length'          => 29.530590, # 朔実(朔望月)
      'lunar_mean_motion'        => 13.36875,  # 月平行(恒星天に対する月の平均運動 / 日)
      'anomalistic_month_length' => 27.5546,   # 転終(近点月)
      'anomaly_method'           => 'a',       # (経朔-定朔)の計算方法(a:差分, b:微分, c:幾何学的補正)
      'anomaly_precision'        => 1e-5,      # c 方式 での収束判定誤差 / 日
      'lunar_unit'               =>  0.1,      # 太陰遅速計算用招差法定数の時間の単位(限)
      'solar_weight'             =>  1,        # (経朔-定朔)の計算で用いる実行差での太陽盈縮の重み(0:非考慮,1:考慮)
      'm'                        => [          # 太陰遅速計算用招差法定数
        [  0      ... 72.65342,   0,     [-0, -1173_1000, +3_7000, +400]],
        [ 72.65342...137.773,   137.773, [-0, -1324_0000, +5_2000, +500]],
        [137.773  ...202.89258, 137.773, [+0, +1324_0000, -5_2000, -500]],
        [202.89258...275.546,   275.546, [+0, +1173_1000, -3_7000, -400]],
        [275.546  .. 277,       275.546, [-0, -1173_1000, +3_7000, +400]]
      ],
      's'                        => [          # 太陽盈縮計算用招差法定数
        [  0       ... 89.25392,    0,        [0, +436_0000, -2_0000, -34]],
        [ 89.25392 ...182.620848, 182.620848, [0, +411_9800, -1_7640, -31]],
        [182.620848...275.987776, 182.620848, [0, -411_9800, +1_7640, +31]],
        [275.987776.. 365.241696, 365.241696, [0, -436_0000, +2_0000, +34]]
      ]
    }

    JapaneseTwin = [{}, When::BasicTypes::M17n, ChineseSolar.twin('JapaneseTwin', [
      "locale:[=ja:, en=en:, alias]",
      "area:[日本,Japan]",

      [ChineseLuniSolar,
        'name:[平朔儀鳳暦=]',
        'formula:MeanLunation?year_length=122357/335&lunation_length=39571/1340&day_epoch=-96608689'
      ],

      [ChineseLuniSolar,
        'name:[貞享乙丑暦=]',
        {'formula'=>['12S', '1L'].map {|f| [
          Ephemeris::ChineseTrueLunation, _japanese_common.merge({
            'formula'                  => f,
            'day_epoch'                => 2336111 +  7.675, # 暦元天正冬至のユリウス日
            'year_epoch'               => 1684,             # 暦元の西暦年
            'year_length'              => 365.241696,       # 暦元の冬至年 / 日
            'anomalistic_year_shift'   => 6.445,            # 暦應(暦元での冬至から近日点通過までの日数)
            'lunation_shift'           =>  2.779 - 0.015,   # 閏應(暦元前経朔から暦元天正冬至までの日数)
            'anomalistic_month_shift'  => 22.72  - 0.015,   # 転應(暦元前近/遠地点通過から暦元天正冬至までの日数)
            'anomaly_method'           => '#{Method:a}',    # (経朔-定朔)の計算方法(a:差分, b:微分, c:幾何学的補正)
            'solar_weight'             => '#{Weight:1}',    # (経朔-定朔)の計算で用いる実行差での太陽盈縮の重み(0:非考慮,1:考慮)
         })]
        }
       }
      ],

      [ChineseLuniSolar,
        'name:[貞享暦]',
        {'formula'=>['12S', '1L'].map {|f| [
          Ephemeris::ChineseTrueLunation, _japanese_common.merge({
            'formula'                  => f,
            'day_epoch'                => 2336111 +  7.69 , # 暦元天正冬至のユリウス日
            'year_epoch'               => 1684,             # 暦元の西暦年
            'year_length'              => 365.241696,       # 暦元の冬至年 / 日
            'anomalistic_year_shift'   => 6.445,            # 暦應(暦元での冬至から近日点通過までの日数)
            'lunation_shift'           =>  2.779,           # 閏應(暦元前経朔から暦元天正冬至までの日数)
            'anomalistic_month_shift'  => 22.72,            # 転應(暦元前近/遠地点通過から暦元天正冬至までの日数)
            'anomaly_method'           => '#{Method:a}',    # (経朔-定朔)の計算方法(a:差分, b:微分, c:幾何学的補正)
            'solar_weight'             => '#{Weight:1}',    # (経朔-定朔)の計算で用いる実行差での太陽盈縮の重み(0:非考慮,1:考慮)
         })]
        }
       }
      ],

      [ChineseLuniSolar,
        'name:[宝暦癸酉暦=]',
        {'formula'=>['12S', '1L'].map {|f| [
          Ephemeris::ChineseTrueLunation, _japanese_common.merge({
            'formula'                  => f,
            'day_epoch'                => 2336111 +  7.9038,# 暦元天正冬至のユリウス日
            'year_epoch'               => 1684,             # 暦元の西暦年
            'year_length'              => 365.241696,       # 暦元の冬至年 / 日
            'anomalistic_year_shift'   => 6.445,            # 暦應(暦元での冬至から近日点通過までの日数)
            'lunation_shift'           =>  2.779 + 0.2138,  # 閏應(暦元前経朔から暦元天正冬至までの日数)
            'anomalistic_month_shift'  => 22.72  + 0.2138,  # 転應(暦元前近/遠地点通過から暦元天正冬至までの日数)
            'anomaly_method'           => '#{Method:a}',    # (経朔-定朔)の計算方法(a:差分, b:微分, c:幾何学的補正)
            'solar_weight'             => '#{Weight:1}',    # (経朔-定朔)の計算で用いる実行差での太陽盈縮の重み(0:非考慮,1:考慮)
         })]
        }
       }
      ],

      [ChineseLuniSolar,
        'name:[宝暦甲戌暦=]',
        {'formula'=>['12S', '1L'].map {|f| [
          Ephemeris::ChineseTrueLunation, _japanese_common.merge({
            'formula'                  => f,
            'day_epoch'                => 2336111 +  7.6223,# 暦元天正冬至のユリウス日
            'year_epoch'               => 1684,             # 暦元の西暦年
            'year_length'              => 365.241696,       # 暦元の冬至年 / 日
            'anomalistic_year_shift'   => 6.445,            # 暦應(暦元での冬至から近日点通過までの日数)
            'lunation_shift'           =>  2.779 - 0.0677,  # 閏應(暦元前経朔から暦元天正冬至までの日数)
            'anomalistic_month_shift'  => 22.72  - 0.0677,  # 転應(暦元前近/遠地点通過から暦元天正冬至までの日数)
            'anomaly_method'           => '#{Method:a}',    # (経朔-定朔)の計算方法(a:差分, b:微分, c:幾何学的補正)
            'solar_weight'             => '#{Weight:1}',    # (経朔-定朔)の計算で用いる実行差での太陽盈縮の重み(0:非考慮,1:考慮)
         })]
        }
       }
      ],

      [ChineseLuniSolar,
        'name:[宝暦暦]',
        {'formula'=>['12S', '1L'].map {|f| [
          Ephemeris::ChineseTrueLunation, _japanese_common.merge({
            'formula'                  => f,
            'day_epoch'                => 2361671 + 14.536, # 暦元天正冬至のユリウス日
            'year_epoch'               => 1754,             # 暦元の西暦年
            'year_length'              => 365.241556,       # 暦元の冬至年 / 日
            'anomalistic_year_shift'   => 6.455,            # 暦應(暦元での冬至から近日点通過までの日数)
            'lunation_shift'           => 25.654,           # 閏應(暦元前経朔から暦元天正冬至までの日数)
            'anomalistic_month_shift'  => 18.88,            # 転應(暦元前近/遠地点通過から暦元天正冬至までの日数)
            's'                        => ChineseSolar.change_unit(365.241556 / 365.241696, _japanese_common['s']),
            'anomaly_method'           => '#{Method:a}',    # (経朔-定朔)の計算方法(a:差分, b:微分, c:幾何学的補正)
            'solar_weight'             => '#{Weight:1}',    # (経朔-定朔)の計算で用いる実行差での太陽盈縮の重み(0:非考慮,1:考慮)
         })]
        }
       }
      ],

      [ChineseLuniSolar,
        'name:[修正宝暦暦=]',
        {'formula'=>['12S', '1L'].map {|f| [
          Ephemeris::ChineseTrueLunation, _japanese_common.merge({
            'formula'                  => f,
            'day_epoch'                => 2361671 + 14.681, # 暦元天正冬至のユリウス日
            'year_epoch'               => 1754,             # 暦元の西暦年
            'year_length'              => 365.241626,       # 暦元の冬至年 / 日
            'anomalistic_year_shift'   => 7.42,             # 暦應(暦元での冬至から近日点通過までの日数)
            'lunation_shift'           => 25.82,            # 閏應(暦元前経朔から暦元天正冬至までの日数)
            'anomalistic_month_shift'  => 19.307,           # 転應(暦元前近/遠地点通過から暦元天正冬至までの日数)
            's'                        => ChineseSolar.change_unit(365.241626 / 365.241696, _japanese_common['s']),
            'anomaly_method'           => '#{Method:a}',    # (経朔-定朔)の計算方法(a:差分, b:微分, c:幾何学的補正)
            'solar_weight'             => '#{Weight:1}',    # (経朔-定朔)の計算で用いる実行差での太陽盈縮の重み(0:非考慮,1:考慮)
         })]
        }
       }
      ],

      [ChineseLuniSolar,
        'name:[寛政暦]',
        'time_basis:+00,+09:03:01',          # 寛政9天正冬至.107112
         {'formula'=>['ChineseTrueLunation?day_epoch=2377391.107112&year_epoch=1797&year_length=365.242347071&year_delta=-0.217685&year_span=1000',
                      'Formula']}
      ],

      [ChineseLuniSolar,
        'name:[寛政丁亥暦=]',
        'time_basis:+00,+09:03:01',          # 寛政9天正冬至.107112
         {'formula'=>['ChineseTrueLunation?day_epoch=2377391.107112&year_epoch=1797&year_length=365.242347071&year_delta=-0.217685&year_span=10',
                      'Formula']}
      ],

      [ChineseLuniSolar,
        'name:[天保暦]',
        'time_basis:#{Clock:LAT}?long=135.4520E&lat=35.0117N',
        'intercalary_span:3'
      ],

      [ChineseLuniSolar,
        'name:[旧々暦=]',
        'time_basis:+09:18:59',
        'intercalary_span:3'
      ],

      [ChineseLuniSolar,
        'name:[旧暦]',
        'time_basis:+09:00',
        'intercalary_span:3'
      ]
    ])]
  end
end
