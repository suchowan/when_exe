# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2015 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When

  class TM::CalendarEra

    # Historical Chinese Luni-Solar Calendar for Chinese Note
    ChineseLuniSolar = [self, [
      'locale:[=ja:, en=en:, alias]',
      'area:[中国の暦月=, (CalendarEra) ChineseLuniSolar=, *ChineseLuniSolar=]',
      ['[太初暦]1.01.01',      '@CR',   '1-01-01^ChineseTwin::太初暦'], # 西暦が正になるところから開始(実際は-103.01.01)
      ['[四分暦]85.01.01',     '@CR',  '85-01-01^ChineseTwin::四分暦', '265'],
      ['[乾象暦]222.01.01',    '@CR', '222-01-01^ChineseTwin::乾象暦', '281'],
      ['[景初暦]237.01.01',    '@CR', '237-01-01^ChineseTwin::景初暦', '452'],
      ['[元嘉暦]445.01.01',    '@CR', '445-01-01^ChineseTwin::元嘉暦'],
      ['[大明暦]510.01.01',    '@CR', '510-01-01^ChineseTwin::大明暦', '590'],
      ['[三紀暦=]384.01.01',   '@CR', '384-01-01^ChineseTwin::三紀暦', '418'],
      ['[玄始暦=]412.01.01',   '@CR', '412-01-01^ChineseTwin::玄始暦', '440'],
      ['[玄始暦=]452.01.01',   '@CR', '452-01-01^ChineseTwin::玄始暦'],
      ['[正光暦=]523.01.01',   '@CR', '523-01-01^ChineseTwin::正光暦', '566'],
      ['[興和暦=]540.01.01',   '@CR', '540-01-01^ChineseTwin::興和暦'],
      ['[天保暦=]551.01.01',   '@CR', '551-01-01^ChineseTwin::天保暦', '578'],
      ['[天和暦=]566.01.01',   '@CR', '566-01-01^ChineseTwin::天和暦'],
      ['[大象暦=]579.01.01',   '@CR', '579-01-01^ChineseTwin::大象暦'],
      ['[開皇暦=]584.01.01',   '@CR', '584-01-01^ChineseTwin::開皇暦'],
      ['[大業暦=]597.01.01',   '@CR', '597-01-01^ChineseTwin::大業暦'],
      ['[戊寅元暦]619.01.01',  '@CR', '619-01-01^ChineseTwin::戊寅元暦'],
      ['[平朔戊寅暦=]645.01.01','@CR','645-01-01^ChineseTwin::平朔戊寅暦'],
      ['[麟徳暦]665.01.01',    '@CR', '665-01-01^ChineseTwin::麟徳暦'],
      ['[大衍暦]729.01.01',    '@CR', '729-01-01^ChineseTwin::大衍暦'],
      ['[五紀暦]762.01.01',    '@CR', '762-01-01^ChineseTwin::五紀暦'],
      ['[正元暦=]784.01.01',   '@CR', '784-01-01^ChineseTwin::正元暦',  '807-01-01'],
      ['[宣明暦]822.01.01',    '@CR', '822-01-01^ChineseTwin::宣明暦'],
      ['[崇玄暦=]893.01.01',   '@CR', '893-01-01^ChineseTwin::崇玄暦',  '956-01-01'],
      ['[授時暦]1281.01.01',   '@CR','1281-01-01^ChineseTwin::授時暦'],
      ['[大統暦]1368.01.01',   '@CR','1368-01-01^ChineseTwin::大統暦', '1645-01-01']
    ]]

    # Historical Chinese Solar Calendar for Chinese Note
    ChineseSolar = [self, [
      'locale:[=ja:, en=en:, alias]',
      'area:[中国の節月=, (CalendarEra) ChineseSolar=, *ChineseSolar]',
      ['[太初暦]1.01.01',     '@CR',    '1-01-01^ChineseTwin::太初暦(節月)'], # 西暦が正になるところから開始(実際は-103.01.15)
      ['[四分暦]85.01.07',    '@CR',   '85-01-07^ChineseTwin::四分暦(節月)', '264-12-28'],
      ['[乾象暦]221.12.23',   '@CR',  '221-12-23^ChineseTwin::乾象暦(節月)', '280-12-31'],
      ['[景初暦]237.01.07',   '@CR',  '237-01-07^ChineseTwin::景初暦(節月)', '451-12-31'],
      ['[元嘉暦]444.12.22',   '@CR',  '444-12-22^ChineseTwin::元嘉暦(節月)'],
      ['[大明暦]509.12.23',   '@CR',  '509-12-23^ChineseTwin::大明暦(節月)', '590-01-08'],
      ['[三紀暦=]384.01.02',  '@CR',  '384-01-02^ChineseTwin::三紀暦(節月)', '418-01-16'],
      ['[玄始暦=]411.12.26',  '@CR',  '411-12-26^ChineseTwin::玄始暦(節月)', '440-01-15'],
      ['[玄始暦=]452.01.02',  '@CR',  '452-01-02^ChineseTwin::玄始暦(節月)'],
      ['[正光暦=]522.12.29',  '@CR',  '522-12-29^ChineseTwin::正光暦(節月)', '566-01-04'],
      ['[興和暦=]539.12.22',  '@CR',  '539-12-22^ChineseTwin::興和暦(節月)'],
      ['[天保暦=]550.12.19',  '@CR',  '550-12-19^ChineseTwin::天保暦(節月)', '577-12-21'],
      ['[天和暦=]566.01.05',  '@CR',  '566-01-05^ChineseTwin::天和暦(節月)'],
      ['[大象暦=]579.01.11',  '@CR',  '579-01-11^ChineseTwin::大象暦(節月)'],
      ['[開皇暦=]584.01.16',  '@CR',  '584-01-16^ChineseTwin::開皇暦(節月)'],
      ['[大業暦=]596.12.22',  '@CR',  '596-12-22^ChineseTwin::大業暦(節月)'],
      ['[戊寅元暦]618.12.19', '@CR',  '618-12-19^ChineseTwin::戊寅元暦(節月)'],
      ['[麟徳暦]664.12.21',   '@CR',  '664-12-21^ChineseTwin::麟徳暦(節月)'],
      ['[大衍暦]729.01.03',   '@CR',  '729-01-03^ChineseTwin::大衍暦(節月)'],
      ['[五紀暦]761.12.29',   '@CR',  '761-12-29^ChineseTwin::五紀暦(節月)'],
      ['[正元暦=]783.12.26',  '@CR',  '783-12-26^ChineseTwin::正元暦(節月)',  '807-01-11'],
      ['[宣明暦]821.01.01',   '@CR',  '821-01-01^ChineseTwin::宣明暦(節月)'],  # 年の始めに遡って開始(実際は12.27)
      ['[崇玄暦=]892.12.22',  '@CR',  '892-12-22^ChineseTwin::崇玄暦(節月)',  '956-01-15'],
      ['[授時暦]1280.01.01',  '@CR', '1280-01-01^ChineseTwin::授時暦(節月)'],
      ['[大統暦]1367.12.24',  '@CR', '1367-12-24^ChineseTwin::大統暦(節月)', '1644-12-24']
    ]]
  end

  module CalendarTypes

    _chinese_common ={
      'day_epoch'                => 2188871 + 55.06,   # 暦元天正冬至のユリウス日
      'year_epoch'               => 1281,              # 暦元の西暦年
      'year_length'              => 365.2425,          # 暦元の冬至年 / 日
      'lunation_length'          => 29.530593,         # 朔実(朔望月)
      'lunation_shift'           => 20.185,            # 閏應(暦元前経朔から暦元天正冬至までの日数)
      'lunar_mean_motion'        => 13.36875,          # 月平行(恒星天に対する月の平均運動 / 日)
      'anomalistic_month_length' => 27.5546,           # 転終(近点月)
      'anomalistic_month_shift'  => 13.1904,           # 転應(暦元前近/遠地点通過から暦元天正冬至までの日数)
      'anomaly_method'           => 'a',               # (経朔-定朔)の計算方法(a:階差, b:微分, c:幾何学的補正, d:差分)
      'lunar_unit'               =>  27.5546 / (84*4), # 太陰遅速計算用招差法定数の時間の単位(限)
      'solar_weight'             => 0,                 # (経朔-定朔)の計算で用いる実行差での太陽盈縮の重み(0:非考慮,1:考慮)
      's'                        => [                  # 太陽盈縮計算用招差法定数
        [  0       ... 88.909225,   0,       [0, +513_3200, -2_4600, -31]],
        [ 88.909225...182.62125,  182.62125, [0, +487_0600, -2_2100, -27]],
        [182.62125 ...276.333275, 182.62125, [0, -487_0600, +2_2100, +27]],
        [276.333275.. 365.2425,   365.2425,  [0, -513_3200, +2_4600, +31]]
      ],
      'm'                       => [                   # 太陰遅速計算用招差法定数
        [  0... 82,   0, [          +0, +1111_0000, -2_8100, -325       ]],
        [ 82... 86,  84, [+5_4293_4424,         +0, -1_9292,   -0, +1484]],
        [ 86...168, 168, [          +0, +1111_0000, -2_8100, -325       ]],
        [168...250, 168, [          -0, -1111_0000, +2_8100, +325       ]],
        [250...254, 252, [-5_4293_4424,         -0, +1_9292,   +0, -1484]],
        [254.. 336, 336, [          -0, -1111_0000, +2_8100, +325       ]]
      ]
    }

    ChineseTwin = [{}, When::BasicTypes::M17n, ChineseSolar.twin('ChineseTwin', [
      "locale:[=ja:, en=en:, alias]",
      "area:[中国,China]",

      [ChineseLuniSolar,
        'name:[黄帝暦=]',
        'formula:MeanLunation?year_length=1461/4&lunation_length=27759/940&day_epoch=1228331',
        'intercalary_month:12'
      ],

      [ChineseLuniSolar,
        'name:[顓頊暦]',
        'formula:MeanLunation?year_length=1461/4&lunation_length=27759/940&day_epoch=1171396&longitude_shift=-1/8',
        'time_basis:+00,+#{P:12}',
        'intercalary_month:9'
      ],

      [ChineseLuniSolar,
        'name:[顓頊暦後期=]',
        'formula:MeanLunation?year_length=1461/4&lunation_length=27759/940&day_epoch=1171396&longitude_shift=-1/8',
        'time_basis:+00,+#{P:12}',
        'base_month:1',
        'intercalary_month:9'
      ],

      [ChineseLuniSolar,
        'name:[夏暦]',
        'formula:MeanLunation?year_length=1461/4&lunation_length=27759/940&day_epoch=1328411',
        'intercalary_month:12'
      ],

      [ChineseLuniSolar,
        'name:[殷暦]',
        'formula:MeanLunation?year_length=1461/4&lunation_length=27759/940&day_epoch=1149071',
        'intercalary_month:12'
      ],

      [ChineseLuniSolar,
        'name:[周暦]',
        'formula:MeanLunation?year_length=1461/4&lunation_length=27759/940&day_epoch=1128251',
        'intercalary_month:12'
      ],

      [ChineseLuniSolar,
        'name:[魯暦=]',
        'formula:MeanLunation?year_length=1461/4&lunation_length=27759/940&day_epoch=1048991',
        'intercalary_month:12'
      ],

      [ChineseLuniSolar,
        'name:[太初暦]',
        'formula:MeanLunation?year_length=562120/1539&lunation_length=2392/81&day_epoch=1683431'
      ],

      [ChineseLuniSolar,
        'name:[四分暦]',
        'formula:MeanLunation?year_length=1461/4&lunation_length=27759/940&day_epoch=1662611'
      ],

      [ChineseLuniSolar,
        'name:[乾象暦]',
        'formula:MeanLunation?year_length=215130/589&lunation_length=43026/1457&day_epoch=-898129'
      ],

      [ChineseLuniSolar,
        'name:[景初暦]',
        'formula:MeanLunation?year_length=673150/1843&lunation_length=134630/4559&day_epoch=+330191'
      ],

      [ChineseLuniSolar,
        'name:[三紀暦=]',
        'formula:MeanLunation?year_length=895220/2451&lunation_length=179044/6063&day_epoch=-28760989'
      ],

      [ChineseLuniSolar,
        'name:[玄始暦]',
        'formula:MeanLunation?year_length=2629759/7200&lunation_length=2629759/89052&day_epoch=-20568349'
      ],

      [ChineseLuniSolar,
        'name:[元嘉暦=]',
        'formula:MeanLunation?year_length=111035/304&lunation_length=22207/752&day_epoch=-200089&longitude_shift=-1/12' # 春分の1ヶ月前
      ],

      [ChineseLuniSolar,
        'name:[大明暦]',
        'formula:MeanLunation?year_length=14423804/39491&lunation_length=116321/3939&day_epoch=-17080189'
      ],

      [ChineseLuniSolar,
        'name:[正光暦=]',
        'formula:MeanLunation?year_length=2213377/6060&lunation_length=2213377/74952&day_epoch=-59357929'
      ],

      [ChineseLuniSolar,
        'name:[興和暦=]',
        'formula:MeanLunation?year_length=6158017/16860&lunation_length=6158017/208530&day_epoch=-105462049'
      ],

      [ChineseLuniSolar,
        'name:[天保暦=]',
        'formula:MeanLunation?year_length=8641687/23660&lunation_length=8641687/292635&day_epoch=-38447089'
      ],

      [ChineseLuniSolar,
        'name:[天和暦=]',
        'formula:MeanLunation?year_length=8568631/23460&lunation_length=8568631/290160&day_epoch=-317950249'
      ],

      [ChineseLuniSolar,
        'name:[大象暦=]',
        'formula:MeanLunation?year_length=4745247/12992&lunation_length=1581749/53563&day_epoch=-13244449'
      ],

      [ChineseLuniSolar,
        'name:[開皇暦=]',
        'formula:MeanLunation?year_length=37605463/102960&lunation_length=5372209/181920&day_epoch=-1506155749'
      ],

      [ChineseLuniSolar,
        'name:[大業暦=]',
        'formula:MeanLunation?year_length=15573963/42640&lunation_length=33783/1144&day_epoch=-519493909'
      ],

      [ChineseLuniSolar,
        'name:[戊寅元暦]',
        'time_basis:+00,+#{P:00}',
        {'formula'=>['12S', '1L'].map {|f| [
          Ephemeris::ChineseTrueLunation, {
            'formula'                  => f,
            'day_epoch'                => -58077529,
            'year_length'              =>  '3456675/9464', # 365.0 + 2315/9464(度法)
            'lunation_length'          =>  '384075/13006', #  29.0 + 6901/13006(日法)
            'anomalistic_month_length' =>  '99775/3621',   #  27.0 + 16064/28968 (798200(暦周)/28968(暦法))
            'rissei'                   =>  'a',
            'method'                   =>  'W',
            's'                        => [
              #(先後數) 盈縮數
              [    0.0,     0], # 冬至
              [    0.0,  +896], # 小寒
              [    0.0, +1294], # 大寒
              [    0.0, +1694], # 立春
              [    0.0, +1922], # 啓蟄
              [    0.0, +2263], # 雨水
              [    0.0, +2713], # 春分
              [    0.0, +2213], # 清明
              [    0.0, +1758], # 穀雨
              [    0.0, +1403], # 立夏
              [    0.0,  +848], # 小満
              [    0.0,     0], # 芒種
              [    0.0,  -739], # 夏至
              [    0.0, -1365], # 小暑
              [    0.0, -1821], # 大暑
              [    0.0, -2109], # 立秋
              [    0.0, -2149], # 処暑
              [    0.0, -2491], # 白露
              [    0.0, -2946], # 秋分
              [    0.0, -2264], # 寒露
              [    0.0, -1639], # 霜降
              [    0.0, -1069], # 立冬
              [    0.0,  -556], # 小雪
              [    0.0,  -100]  # 大雪
            ],          
            'm'                       => [
              #(変日差)   盈縮積分の差分(9037=章歳(676)+章月(8361))
              [13006.0, -11341226.0/9037], #   １日
              [13006.0, -10053632.0/9037], #   ２日
              [13006.0,  -8557946.0/9037], #   ３日
              [13006.0,  -6841146.0/9037], #   ４日
              [13006.0,  -4903257.0/9037], #   ５日
              [13006.0,  -2978403.0/9037], #   ６日
              [13006.0,  -1053445.0/9037], #   ７日
              [13006.0,  +1092498.0/9037], #   ８日
              [13006.0,  +3238489.0/9037], #   ９日
              [13006.0,  +5163376.0/9037], #   10日
              [13006.0,  +6880164.0/9037], #   11日
              [13006.0,  +8388868.0/9037], #   12日
              [13006.0,  +9884554.0/9037], #   13日
              [13006.0, +11172149.0/9037], #   14日
              [13006.0, +10742961.0/9037], #   15日
              [13006.0,  +9455368.0/9037], #   16日
              [13006.0,  +7959678.0/9037], #   17日
              [13006.0,  +6242886.0/9037], #   18日
              [13006.0,  +4526094.0/9037], #   19日
              [13006.0,  +2601205.0/9037], #   20日
              [13006.0,   +663312.0/9037], #   21日
              [13006.0,  -1482690.0/9037], #   22日
              [13006.0,  -3407578.0/9037], #   23日
              [13006.0,  -5332465.0/9037], #   24日
              [13006.0,  -7036252.0/9037], #   25日
              [13006.0,  -8753044.0/9037], #   26日
              [13006.0, -10040638.0/9037], #   27日
              [ 7295.0,  -6229880.0/9037]  #   28日
            ]
         }]
        }
       }
      ],

      [ChineseLuniSolar,
        'name:[平朔戊寅暦=]',
        'formula:MeanLunation?year_length=3456675/9464&lunation_length=384075/13006&day_epoch=-58077529'
      ],

      [ChineseLuniSolar,
        'name:[麟徳暦]',
        'time_basis:+00,+#{P:00}',
        {'formula'=>['12S', '1L'].map {|f| [
          Ephemeris::ChineseTrueLunation, {
            'formula'                  => f,
            'day_epoch'                => -96608689,
            'year_length'              => '122357/335',
            'lunation_length'          =>  '39571/1340',
            'anomalistic_month_length' =>  '443077/16080', # 27.0 + (743.0+1.0/12)/1340,
          # 'rissei'                   =>  'B',
            'method'                   =>  '#{Method:A}',
            's'                        => [
              # 消息總  盈朒積    立成b    立成c
              [    0.0,     0,  +3.9546, -0.0372], # 冬至
              [ -722.0,   +54,  +3.4091, -0.0372], # 小寒
              [-1340.0,  +100,  +2.8636, -0.0372], # 大寒
              [-1854.0,  +138,  +2.3181, +0.0372], # 立春
              [-2368.0,  +176,  +2.8636, +0.0372], # 啓蟄
              [-2986.0,  +222,  +3.4091, +0.0372], # 雨水
              [-3708.0,  +276,  -3.7220, +0.0329], # 春分
              [-2986.0,  +222,  -3.2086, +0.0329], # 清明
              [-2368.0,  +176,  -2.6952, +0.0329], # 穀雨
              [-1854.0,  +138,  -2.1818, -0.0329], # 立夏
              [-1340.0,  +100,  -2.6952, -0.0329], # 小満
              [ -722.0,   +54,  -3.2086, -0.0329], # 芒種
              [    0.0,     0,  -3.7220, +0.0329], # 夏至
              [ +722.0,   -54,  -3.2086, +0.0329], # 小暑
              [+1340.0,  -100,  -2.6952, +0.0329], # 大暑
              [+1854.0,  -138,  -2.1818, -0.0329], # 立秋
              [+2368.0,  -176,  -2.6952, -0.0329], # 処暑
              [+2986.0,  -222,  -3.2086, -0.0329], # 白露
              [+3708.0,  -276,  +3.9546, -0.0372], # 秋分
              [+2986.0,  -222,  +3.4091, -0.0372], # 寒露
              [+2368.0,  -176,  +2.8636, -0.0372], # 霜降
              [+1854.0,  -138,  +2.3181, +0.0372], # 立冬
              [+1340.0,  -100,  +2.8636, +0.0372], # 小雪
              [ +722.0,   -54,  +3.4091, +0.0372], # 大雪
            ],
            'm'                       => [
              #(変日差) 増減率
              [1340.0,   -134],                    #   １日
              [1340.0,   -117],                    #   ２日
              [1340.0,    -99],                    #   ３日
              [1340.0,    -78],                    #   ４日
              [1340.0,    -56],                    #   ５日
              [1340.0,    -33],                    #   ６日
              [1191.0,     -9],                    #   ７日
              [ 149.0,      0],                    #   ７日
              [1340.0,    +14],                    #   ８日
              [1340.0,    +38],                    #   ９日
              [1340.0,    +62],                    #   10日
              [1340.0,    +85],                    #   11日
              [1340.0,   +104],                    #   12日
              [1340.0,   +121],                    #   13日
              [1042.0,   +102],                    #   14日
              [ 298.0,    +29],                    #   14日
              [1340.0,   +128],                    #   15日
              [1340.0,   +115],                    #   16日
              [1340.0,    +95],                    #   17日
              [1340.0,    +74],                    #   18日
              [1340.0,    +52],                    #   19日
              [1340.0,    +28],                    #   20日
              [ 892.0,     +4],                    #   21日
              [ 448.0,      0],                    #   21日
              [1340.0,    -20],                    #   22日
              [1340.0,    -44],                    #   23日
              [1340.0,    -68],                    #   24日
              [1340.0,    -89],                    #   25日
              [1340.0,   -108],                    #   26日
              [1340.0,   -125],                    #   27日
              [ 743.0+1.0/12, -71]                 #   28日
            ]
         }]
        },
        'doyo'   => (Rational( 4,15) +  244) / 1340
       }
      ],

      [ChineseLuniSolar,
        'name:[大衍暦]',
        'time_basis:+00,+#{P:03}',
        {'formula'=>['12S', '1L'].map {|f| [
          Ephemeris::ChineseTrueLunation, {
            'formula'                  => f,
            'day_epoch'                => -35412747829,
            'year_length'              => '1110343/3040',
            'lunation_length'          =>   '89773/3040',
            'anomalistic_month_length' =>  '6701279/243200', # 27.0 +(1685.0+79.0/80)/3040,
          # 'rissei'                   =>  'C',
            's'                        => [
              # 先後數  朓朒積    立成b    立成c
              [    0.0,     0, +13.4524, -0.1886], # 冬至
              [-2353.0,  +176, +10.5564, -0.1634], # 小寒
              [-4198.0,  +314,  +8.0408, -0.1446], # 大寒
              [-5588.0,  +418,  +5.8160, -0.1318], # 立春
              [-6564.0,  +491,  +3.7987, -0.1240], # 雨水
              [-7152.0,  +535,  +1.9265, -0.1240], # 啓蟄
              [-7366.0,  +551,  -0.2048, -0.1178], # 春分
              [-7152.0,  +535,  -1.9968, -0.1190], # 清明
              [-6564.0,  +491,  -3.7956, -0.1240], # 穀雨
              [-5588.0,  +418,  -5.6626, -0.1324], # 立夏
              [-4198.0,  +314,  -7.6555, -0.1436], # 小満
              [-2353.0,  +176,  -9.9405, -0.1436], # 芒種
              [    0.0,     0, -12.0819, +0.1436], # 夏至
              [+2353.0,  -176,  -9.7018, +0.1324], # 小暑
              [+4198.0,  -314,  -7.5450, +0.1240], # 大暑
              [+5588.0,  -418,  -5.5634, +0.1190], # 立秋
              [+6564.0,  -491,  -3.7038, +0.1178], # 処暑
              [+7152.0,  -535,  -1.8954, +0.1178], # 白露
              [+7366.0,  -551,  +0.1783, +0.1240], # 秋分
              [+7152.0,  -535,  +2.0042, +0.1318], # 寒露
              [+6564.0,  -491,  +3.8950, +0.1446], # 霜降
              [+5588.0,  -418,  +5.9214, +0.1634], # 立冬
              [+4198.0,  -314,  +8.1610, +0.1886], # 小雪
              [+2353.0,  -176, +10.9010, +0.1886], # 大雪
            ],
            'm'                       => [
              #(変日差) 損益率
              [3040.0,   +297],                    #   １日
              [3040.0,   +259],                    #   ２日
              [3040.0,   +220],                    #   ３日
              [3040.0,   +180],                    #   ４日
              [3040.0,   +139],                    #   ５日
              [3040.0,    +97],                    #   ６日
              [2701.0,    +48],                    #   ７日
              [ 339.0,     -6],                    #   ７日
              [3040.0,    -64],                    #   ８日
              [3040.0,   -106],                    #   ９日
              [3040.0,   -148],                    #   10日
              [3040.0,   -189],                    #   11日
              [3040.0,   -229],                    #   12日
              [3040.0,   -267],                    #   13日
              [2363.0,   -231],                    #   14日
              [ 677.0,    -66],                    #   14日
              [3040.0,   -289],                    #   15日
              [3040.0,   -250],                    #   16日
              [3040.0,   -211],                    #   17日
              [3040.0,   -171],                    #   18日
              [3040.0,   -130],                    #   19日
              [3040.0,    -87],                    #   20日
              [2024.0,    -36],                    #   21日
              [1016.0,    +18],                    #   21日
              [3040.0,    +73],                    #   22日
              [3040.0,   +116],                    #   23日
              [3040.0,   +157],                    #   24日
              [3040.0,   +198],                    #   25日
              [3040.0,   +237],                    #   26日
              [3040.0,   +276],                    #   27日
              [1686.0,   +165]                     #   28日
            ]
         }]
        },
        'doyo'   => (Rational(13,30) +  531) / 3040
       }
      ],

      [ChineseLuniSolar,
        'name:[五紀暦]',
        'time_basis:+00,+#{P:06}',
        {'formula'=>['12S', '1L'].map {|f| [
          Ephemeris::ChineseTrueLunation, {
            'formula'                  => f,
            'day_epoch'                => -96608689,
            'year_length'              => '122357/335',
            'lunation_length'          =>  '39571/1340',
            'anomalistic_month_length' =>  '1366156/49580', # 27.0 + (743.0+5.0/37)/1340,
          # 'rissei'                   =>  'C',
            's'                        => [
              # 先後數  朓朒積    立成b    立成c
              [    0.0,     0,  +5.9668, -0.0843], # 冬至
              [-1037.0,   +78,  +4.6652, -0.0721], # 小寒
              [-1850.0,  +139,  +3.5656, -0.0653], # 大寒
              [-2463.0,  +185,  +2.5583, -0.0590], # 立春
              [-2893.0,  +217,  +1.6375, -0.0532], # 雨水
              [-3152.0,  +236,  +0.8384, -0.0532], # 啓蟄
              [-3246.0,  +243,  -0.0972, -0.0505], # 春分
              [-3152.0,  +236,  -0.8480, -0.0534], # 清明
              [-2893.0,  +217,  -1.6517, -0.0561], # 穀雨
              [-2463.0,  +185,  -2.5057, -0.0584], # 立夏
              [-1850.0,  +139,  -3.3781, -0.0643], # 小満
              [-1037.0,   +78,  -4.3954, -0.0643], # 芒種
              [    0.0,     0,  -5.3592, +0.0643], # 夏至
              [+1037.0,   -78,  -4.2877, +0.0584], # 小暑
              [+1850.0,  -139,  -3.3459, +0.0561], # 大暑
              [+2463.0,  -185,  -2.4475, +0.0534], # 立秋
              [+2893.0,  -217,  -1.5966, +0.0505], # 処暑
              [+3152.0,  -236,  -0.8185, +0.0505], # 白露
              [+3246.0,  -243,  +0.0858, +0.0532], # 秋分
              [+3152.0,  -236,  +0.8505, +0.0590], # 寒露
              [+2893.0,  -217,  +1.6943, +0.0653], # 霜降
              [+2463.0,  -185,  +2.6205, +0.0721], # 立冬
              [+1850.0,  -139,  +3.6007, +0.0843], # 小雪
              [+1037.0,   -78,  +4.8330, +0.0843], # 大雪
            ],
            'm'                       => [
              #(変日差) 損益率
              [1340.0,   -135],                    #   １日
              [1340.0,   -117],                    #   ２日
              [1340.0,    -99],                    #   ３日
              [1340.0,    -78],                    #   ４日
              [1340.0,    -56],                    #   ５日
              [1340.0,    -33],                    #   ６日
              [1191.0,     -8],                    #   ７日
              [ 149.0,     +1],                    #   ７日
              [1340.0,    +14],                    #   ８日
              [1340.0,    +38],                    #   ９日
              [1340.0,    +62],                    #   10日
              [1340.0,    +85],                    #   11日
              [1340.0,   +103],                    #   12日
              [1340.0,   +118],                    #   13日
              [1042.0,   +105],                    #   14日
              [ 298.0,    +30],                    #   14日
              [1340.0,   +128],                    #   15日
              [1340.0,   +115],                    #   16日
              [1340.0,    +95],                    #   17日
              [1340.0,    +74],                    #   18日
              [1340.0,    +52],                    #   19日
              [1340.0,    +28],                    #   20日
              [ 892.0,     +6],                    #   21日
              [ 448.0,     -3],                    #   21日
              [1340.0,    -20],                    #   22日
              [1340.0,    -42],                    #   23日
              [1340.0,    -65],                    #   24日
              [1340.0,    -89],                    #   25日
              [1340.0,   -109],                    #   26日
              [1340.0,   -125],                    #   27日
              [ 743.0+5.0/37, -75]                 #   28日
            ]
         }]
        },
        'doyo'   => (Rational( 4,15) +  244) / 1340
       }
      ],

      [ChineseLuniSolar,
        'name:[正元暦=]',
        'time_basis:+00,+#{P:06}',
        {'formula'=>['12S', '1L'].map {|f| [
          Ephemeris::ChineseTrueLunation, {
            'formula'                  => f,
            'day_epoch'                => -145149709,
            'year_length'              => '399943/1095',       # 365.0 + 268/1095(通法)
            'lunation_length'          =>  '32336/1095',       #  29.0 + 581/1095
            'anomalistic_month_length' =>  '301720132/10950000', #  27.0 + 607.0132(轉終日)/1095 (301720132(轉終分)/10950000)
            'rissei'                   =>  'c',
            'method'                   =>  'C',
            's'                        => [
              # 先後數  朓朒積
              [    0.0,     0], # 冬至
              [ -848.0,   +63], # 小寒
              [-1512.0,  +113], # 大寒
              [-2013.0,  +150], # 立春
              [-2364.0,  +176], # 雨水
              [-2576.0,  +192], # 啓蟄
              [-2653.0,  +198], # 春分
              [-2576.0,  +192], # 清明
              [-2364.0,  +176], # 穀雨
              [-2013.0,  +150], # 立夏
              [-1512.0,  +113], # 小満
              [ -848.0,   +63], # 芒種
              [    0.0,     0], # 夏至
              [ +848.0,   -63], # 小暑
              [+1512.0,  -113], # 大暑
              [+2013.0,  -150], # 立秋
              [+2364.0,  -176], # 処暑
              [+2576.0,  -192], # 白露
              [+2653.0,  -198], # 秋分
              [+2576.0,  -192], # 寒露
              [+2364.0,  -176], # 霜降
              [+2013.0,  -150], # 立冬
              [+1512.0,  -113], # 小雪
              [ +848.0,   -63], # 大雪
            ],
            'm'                       => [
              #(変日差) 損益率
              [1095.0,  -110], #   １日
              [1095.0,   -96], #   ２日
              [1095.0,   -81], #   ３日
              [1095.0,   -64], #   ４日
              [1095.0,   -46], #   ５日
              [1095.0,   -27], #   ６日
              [ 973.0,    -7], #   ７日
              [ 122.0,    +1], #   ７日
              [1095.0,   +12], #   ８日
              [1095.0,   +31], #   ９日
              [1095.0,   +51], #   10日
              [1095.0,   +68], #   11日
              [1095.0,   +85], #   12日
              [1095.0,   +96], #   13日
              [ 851.0,   +87], #   14日
              [ 244.0,   +25], #   14日
              [1095.0,  +107], #   15日
              [1095.0,   +94], #   16日
              [1095.0,   +78], #   17日
              [1095.0,   +61], #   18日
              [1095.0,   +42], #   19日
              [1095.0,   +23], #   20日
              [ 729.0,    +5], #   21日
              [ 366.0,    -2], #   21日
              [1095.0,   -16], #   22日
              [1095.0,   -35], #   23日
              [1095.0,   -53], #   24日
              [1095.0,   -71], #   25日
              [1095.0,   -88], #   26日
              [1095.0,  -102], #   27日
              [ 607.0,   -68], #   28日
              [ 366.0,   -42]  #   28日
            ]
         }]
        }
       }
      ],

      [ChineseLuniSolar,
        'name:[宣明暦]',
        'time_basis:+00,+#{P:06}',
        {'formula'=>['12S', '1L'].map {|f| [
          Ephemeris::ChineseTrueLunation, {
            'formula'                  => f,
            'day_epoch'                => -2580308749,
            'year_length'              => '3068055/8400',
            'lunation_length'          =>  '248057/8400',
            'anomalistic_month_length' =>  '23145819/840000', # 27.0 + 4658.19 / 8400,
          # 'rissei'                   =>  'C',
            's'                        => [
              # 先後數  朓朒数    立成b    立成c
              [     0.0,     0, +33.4511, -0.3695], # 冬至
              [ -6000.0,  +449, +28.0389, -0.3606], # 小寒
              [-11000.0,  +823, +22.6998, -0.3519], # 大寒
              [-15000.0, +1122, +17.8923, -0.4068], # 立春
              [-18000.0, +1346, +11.7966, -0.3998], # 雨水
              [-19800.0, +1481,  +5.7986, -0.3998], # 啓蟄
              [-20400.0, +1526,  -0.2433, -0.3779], # 春分
              [-19800.0, +1481,  -6.1254, -0.3634], # 清明
              [-18000.0, +1346, -12.2048, -0.2987], # 穀雨
              [-15000.0, +1122, -16.9060, -0.2919], # 立夏
              [-11000.0,  +823, -21.5362, -0.2854], # 小満
              [ -6000.0,  +449, -26.0498, -0.2854], # 芒種
              [     0.0,     0, -30.3119, +0.2854], # 夏至
              [ +6000.0,  -449, -25.8126, +0.2919], # 小暑
              [+11000.0,  -823, -21.2454, +0.2987], # 大暑
              [+15000.0, -1122, -17.0296, +0.3634], # 立秋
              [+18000.0, -1346, -11.4744, +0.3779], # 処暑
              [+19800.0, -1481,  -5.6429, +0.3779], # 白露
              [+20400.0, -1526,  +0.1432, +0.3998], # 秋分
              [+19800.0, -1481,  +6.1488, +0.4068], # 寒露
              [+18000.0, -1346, +12.6336, +0.3519], # 霜降
              [+15000.0, -1122, +17.8043, +0.3606], # 立冬
              [+11000.0,  -823, +23.0590, +0.3695], # 小雪
              [ +6000.0,  -449, +28.4618, +0.3695], # 大雪
            ],
            'm'                       => [
              #(変日差) 損益率
              [ 8400.0,   +830],                    # 進１日
              [ 8400.0,   +726],                    #   ２日
              [ 8400.0,   +606],                    #   ３日
              [ 8400.0,   +471],                    #   ４日
              [ 8400.0,   +337],                    #   ５日
              [ 8400.0,   +202],                    #   ６日
              [ 7465.0,    +53],                    #   ７日
              [  935.0,     -7],                    #   ７日
              [ 8400.0,    -82],                    #   ８日
              [ 8400.0,   -224],                    #   ９日
              [ 8400.0,   -366],                    #   10日
              [ 8400.0,   -509],                    #   11日
              [ 8400.0,   -643],                    #   12日
              [ 8400.0,   -748],                    #   13日
              [ 6529.095, -646],                    #   14日
              [ 8400.0,   -830],                    # 退１日
              [ 8400.0,   -726],                    #   ２日
              [ 8400.0,   -598],                    #   ３日
              [ 8400.0,   -464],                    #   ４日
              [ 8400.0,   -329],                    #   ５日
              [ 8400.0,   -195],                    #   ６日
              [ 7465.0,    -53],                    #   ７日
              [  935.0,     +7],                    #   ７日
              [ 8400.0,    +82],                    #   ８日
              [ 8400.0,   +225],                    #   ９日
              [ 8400.0,   +366],                    #   10日
              [ 8400.0,   +501],                    #   11日
              [ 8400.0,   +628],                    #   12日
              [ 8400.0,   +740],                    #   13日
              [ 6529.095, +646]                     #   14日
            ]
         }]
        },
        'doyo'   => (Rational( 1, 2) + 1468) / 8400
       }
      ],

      [ChineseLuniSolar,
        'name:[崇玄暦=]',
        'time_basis:+00,+#{P:06}',
        {'formula'=>['12S', '1L'].map {|f| [
          Ephemeris::ChineseTrueLunation, {
            'formula'                  => f,
            'day_epoch'                => -19701911689,
            'year_length'              => '4930801/13500',     # 365.0+3301/13500(通法)
            'lunation_length'          =>  '398663/13500',     #  29.0+7163/13500
            'anomalistic_month_length' =>  '37198697/1350000', #  27.0+7486.97(轉終日)/13500
            'rissei'                   =>  'c',
            's'                        => [
              # 盈縮分     朓朒積
              [     0*1.35,     0], # 冬至
              [ -7740*1.35,  +782], # 小寒
              [-13809*1.35, +1395], # 大寒
              [-18381*1.35, +1857], # 立春
              [-21631*1.35, +2185], # 雨水
              [-23608*1.35, +2385], # 啓蟄
              [-24268*1.35, +2452], # 春分
              [-23608*1.35, +2385], # 清明
              [-21631*1.35, +2185], # 穀雨
              [-18381*1.35, +1857], # 立夏
              [-13809*1.35, +1395], # 小満
              [ -7740*1.35,  +782], # 芒種
              [     0*1.35,     0], # 夏至
              [ +7740*1.35,  -782], # 小暑
              [+13809*1.35, -1395], # 大暑
              [+18381*1.35, -1857], # 立秋
              [+21631*1.35, -2185], # 処暑
              [+23608*1.35, -2385], # 白露
              [+24268*1.35, -2452], # 秋分
              [+23608*1.35, -2385], # 寒露
              [+21631*1.35, -2185], # 霜降
              [+18381*1.35, -1857], # 立冬
              [+13809*1.35, -1395], # 小雪
              [ +7740*1.35,  -782], # 大雪
            ],
            'm'                       => [
              #(変日差) 損益率
              [13500.0,  +1319], #   １日
              [13500.0,  +1150], #   ２日
              [13500.0,   +978], #   ３日
              [13500.0,   +799], #   ４日
              [13500.0,   +617], #   ５日
              [13500.0,   +431], #   ６日
              [11996.75,  +213], #   ７日
              [ 1503.25,   -27], #   ７日
              [13500.0,   -285], #   ８日
              [13500.0,   -471], #   ９日
              [13500.0,   -650], #   10日
              [13500.0,   -840], #   11日
              [13500.0,  -1017], #   12日
              [13500.0,  -1185], #   13日
              [10493.5,  -1032], #   14日
              [ 3006.5,   -293], #   14日
              [13500.0,  -1284], #   15日
              [13500.0,  -1110], #   16日
              [13500.0,   -941], #   17日
              [13500.0,   -757], #   18日
              [13500.0,   -578], #   19日
              [13500.0,   -386], #   20日
              [ 8990.25,  -160], #   21日
              [ 4509.75,   +80], #   21日
              [13500.0,   +324], #   22日
              [13500.0,   +516], #   23日
              [13500.0,   +697], #   24日
              [13500.0,   +879], #   25日
              [13500.0,  +1053], #   26日
              [13500.0,  +1223], #   27日
              [ 7487.0,   +737]  #   28日
            ]
         }]
        }
       }
      ],

      [ChineseLuniSolar,
        'name:[授時暦]',
        {'formula'=>['12S', '1L'].map {|f| [
          Ephemeris::ChineseTrueLunation, _chinese_common.merge({
            'formula'                  => f,
            'year_delta'               => 1,   # 冬至年の変化率 / (10^(-6)日/年)
            'year_span'                => 100  # 冬至年の改訂周期 / 年
         })]
        }
       }
      ],

      [ChineseLuniSolar,
        'name:[大統暦]',
        {'formula'=>['12S', '1L'].map {|f| [
          Ephemeris::ChineseTrueLunation, _chinese_common.merge({
            'formula'                  => f,
            'year_delta'               => 0,   # 冬至年の変化率 / (10^(-6)日/年)
            'year_span'                => 1    # 冬至年の改訂周期 / 年
         })]
        }
       }
      ]
    ])]
  end
end
