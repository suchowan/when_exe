# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  class BasicTypes::M17n

    BalineseTerms = [self, [
      "namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/]",
      "locale:[=en:, ja=ja:, alias]",
      "names:[BalineseTerms]",
      "[BalineseLuniSolar=, バリ・サカ暦=]",
      "[Tenganan=, テンガナン暦=]",

      [self,
        "names:[IntercalaryMonth=en:Intercalation, 閏月]",
        "[%s Suklapaksa=,      %s 白分=  ]",
        "[%s Krsnapaksa=,      %s 黒分=  ]",
        "[Mala %s Suklapaksa=, 閏%s 白分=]",
        "[Mala %s Krsnapaksa=, 閏%s 黒分=]"
      ],

      [self,
        "names:[IntercalaryDay=en:Intercalation, 閏日=ja:%%<閏>]",
        "[Double %s=,           欠=       ]"
      ],

      [self,
        "names:[HinduMonth=, ヒンドゥ月=]",
        "[Kelima=,    5月=]",
        "[Kenem=,     6月=]",
        "[Kepitu=,    7月=]",
        "[Kewulu=,    8月=]",
        "[Kesanga=,   9月=]",
        "[Kedasa=,   10月=]",
        "[Jiyestha=, 11月=]",
        "[Sadha=,    12月=]",
        "[Kasa=,      1月=]",
        "[Karo=,      2月=]",
        "[Ketiga=,    3月=]",
        "[Kapat=,     4月=]"
      ],

      [self,
        "names:[TengananMonth=, テンガナン月=]",
        "[Kelima=,      5月=]",
        "[Kanem=,       6月=]",
        "[Kepitu=,      7月=]",
        "[Kolu=,        8月=]",
        "[Kesanga=,     9月=]",
        "[Kedasa=,     10月=]",
        "[Desta=,      11月=]",
        "[Sadda=,      12月=]",
        "[Kasa=,        1月=]",
        "[Karo=,        2月=]",
        "[Ketiga=,      3月=]",
        "[Kapat=,       4月=]",
        "[Kapat Sep=, 閏4月=]"
      ]
    ]]
  end

  module Coordinates

    # Balinese Residues

    #
    # ウク周期
    #
    class Wuku < Residue

      # Urip 7
      Urip7    = [ 5, 4, 3, 7, 8, 6, 9]

      # Urip 5
      Urip5    = [ 9, 7, 4, 8, 5]

      # 2日週
      Dwiwara  = (0...35).to_a.map {|d| (Urip7[d % 7] + Urip5[d % 5]) %  2}

      # 10日週
      Dasawara = (0...35).to_a.map {|d| (Urip7[d % 7] + Urip5[d % 5]) % 10}

      # Watek
      Watek    = (0...35).to_a.map {|d|  Urip7[d % 7] + Urip5[d % 5] - 7  }

      # 2日週
      # @return [When::BasicTypes::M17n]
      def dwiwara
        When.CalendarNote('BalineseNote/NoteObjects')['day']['Dwiwara'][Dwiwara[@remainder % 35]]
      end

      # 4日週
      # @return [When::BasicTypes::M17n]
      def tjaturwara
        index = (@remainder + 137) % 210
        When.CalendarNote('BalineseNote/NoteObjects')['day']['Tjaturwara'][index >= 208 ? 2 : (index-1) % 4]
      end

      # 8日週
      # @return [When::BasicTypes::M17n]
      def astawara
        index = (@remainder + 137) % 210
        When.CalendarNote('BalineseNote/NoteObjects')['day']['Astawara'][index >= 208 ? 6 : (index-1) % 8]
      end

      # 9日週
      # @return [When::BasicTypes::M17n]
      def sangawara
        index = @remainder - 3
        When.CalendarNote('BalineseNote/NoteObjects')['day']['Sangawara'][index < 0 ? 0 : index % 9]
      end

      # 10日週
      # @return [When::BasicTypes::M17n]
      def dasawara
        When.CalendarNote('BalineseNote/NoteObjects')['day']['Dasawara'][Dasawara[@remainder % 35]]
      end

      # Watek
      # @return [When::BasicTypes::M17n]
      def watek
        When.CalendarNote('BalineseNote/NoteObjects')['day']['Watek'][Watek[@remainder % 35]]
      end
    end
  end

  class TM::CalendarEra

    #
    # バリのサカ暦
    #
    BalineseLuniSolar = [self, [
      "namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/]",
      "locale:[=en:, ja=ja:, alias]",
      "period:[BalineseLuniSolar=, バリ・サカ暦=]",
      ["[SE=, サカ暦=, alias:Balinese_Saka_Era]1887-07<13", "Calendar Epoch", "1965-07<13^BalineseLuniSolar1965",
                                                            "1971-07-04^BalineseLuniSolar1971",
                                                            "1993-07-08^BalineseLuniSolar1993",
                                                            "2000-06<10^BalineseLuniSolar2000",
                                                            "2003-07<14^BalineseLuniSolar2003", '+Infinity']
    ]]
  end

  module CalendarTypes

    #
    # Balinese Luni-Solar Calendar
    #
    class BalineseLuniSolar  < HinduLuniSolar

      # protected

      # 朔望日 -> 年・月・日
      #
      # @param [Numeric] tithi 朔望日(月の位相 / (CIRCLE/30))
      #
      # @return [Array<Numeric>] ( y, m, d )
      #   [ y - 年(Integer) ]
      #   [ m - 月(When::Coordinates::Pair) ]
      #   [ d - 日(Integer) ]
      #
      def _tithi_to_coordinates(tithi)
        @tabular._encode(@tabular._number_to_coordinates(tithi.to_i))
      end

      # 日時要素の翻訳表の取得
      #
      # @overload _ids_(date)
      #   @param [Array<Numeric>] date ( 年 )
      #   @return [Array<When::Coordinates::Pair>] 1年の月の配置の翻訳表
      #
      # @overload _ids_(date)
      #   @param [Array<Numeric>] date ( 年 月 )
      #   @return [Array<When::Coordinates::Pair>] 1月の日の配置の翻訳表
      #   @note 月は 0 始まりの通番
      #
      def _ids_(date)
        y, m = date
        m ? super : @tabular._ids(date)
      end

      private

      # オブジェクトの正規化
      #
      #    @tabular     = 19年7閏のパターンを与える tithi に対する Calendar
      #    @formula[-1] = 位相の計算に用いる月の Ephemeris
      #
      def _normalize(args=[], options={})

        intercalary_month = When.Resource('_m:BalineseTerms::IntercalaryMonth::*')
        intercalary_day   = When.Resource('_m:BalineseTerms::IntercalaryDay::*')
        month_index = Coordinates::Index.new({:branch=>{ 0   => intercalary_month[0],  #   白分
                                                        +0.5 => intercalary_month[1],  #   黒分
                                                        +1   => intercalary_month[2],  # 閏白分
                                                        +1.5 => intercalary_month[3]}, # 閏黒分
                                              :trunk=>When.Resource('_m:BalineseTerms::HinduMonth::*'),
                                              :shift=>+8})

        @origin_of_MSC = 0

        @tabular = CyclicTableBased.new({
          'indices'    => [month_index, Coordinates::Index.new],
          'rule_table' => @rule_table
        })

        @formula = [Ephemeris::MeanLunation.new(
          {
           'day_epoch'       => @day_epoch,
           'longitude_shift' => '-1/12', # 雨水
           'long'            => 360.0 / 63 * @day_border.to_i,
           'formula'         => '2L',
           'year_length'     => '222075/608',
           'lunation_length' => '945/32'
        })]

        @indices    = [month_index, Coordinates::Index.new({:branch=>{-2=>intercalary_day[0]}})]

        @note       = When.CalendarNote(@note || 'BalineseNote')
        super
      end
    end

    intercalary_pattern_1 = {# 17  18  0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16
      'T'  => {'Rule'  =>[  'N','N','D','N','N','S','N','N','D','N','S','N','N','D','N','N','S','N','S']},
      'N'  => {'Length'  =>[15]*24, 'IDs' => '10,10<,11,11<,12,12<,1,1<,2,2<,3,3<,4,4<,5,5<,6,6<,7,7<,8,8<,9,9<'},
      'D'  => {'Length'  =>[15]*26, 'IDs' => '10,10<,11,11<,11=,11>,12,12<,1,1<,2,2<,3,3<,4,4<,5,5<,6,6<,7,7<,8,8<,9,9<'},
      'S'  => {'Length'  =>[15]*26, 'IDs' => '10,10<,11,11<,12,12<,12=,12>,1,1<,2,2<,3,3<,4,4<,5,5<,6,6<,7,7<,8,8<,9,9<'}
    }

    intercalary_pattern_2 = {# 17  18  0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16
      'T'  => {'Rule'  =>[   'N','S','N','N','D','N','3','N','N','1','N','N','D','N','N','K','N','2','N']},
      'N'  => {'Length'  =>[15]*24, 'IDs' => '10,10<,11,11<,12,12<,1,1<,2,2<,3,3<,4,4<,5,5<,6,6<,7,7<,8,8<,9,9<'},
      'K'  => {'Length'  =>[15]*26, 'IDs' => '10,10<,10=,10>,11,11<,12,12<,1,1<,2,2<,3,3<,4,4<,5,5<,6,6<,7,7<,8,8<,9,9<'},
      'D'  => {'Length'  =>[15]*26, 'IDs' => '10,10<,11,11<,11=,11>,12,12<,1,1<,2,2<,3,3<,4,4<,5,5<,6,6<,7,7<,8,8<,9,9<'},
      'S'  => {'Length'  =>[15]*26, 'IDs' => '10,10<,11,11<,12,12<,12=,12>,1,1<,2,2<,3,3<,4,4<,5,5<,6,6<,7,7<,8,8<,9,9<'},
      '1'  => {'Length'  =>[15]*26, 'IDs' => '10,10<,11,11<,12,12<,1,1<,1=,1>,2,2<,3,3<,4,4<,5,5<,6,6<,7,7<,8,8<,9,9<'},
      '2'  => {'Length'  =>[15]*26, 'IDs' => '10,10<,11,11<,12,12<,1,1<,2,2<,2=,2>,3,3<,4,4<,5,5<,6,6<,7,7<,8,8<,9,9<'},
      '3'  => {'Length'  =>[15]*26, 'IDs' => '10,10<,11,11<,12,12<,1,1<,2,2<,3,3<,3=,3>,4,4<,5,5<,6,6<,7,7<,8,8<,9,9<'}
    }

    BalineseLuniSolar1965 = [BalineseLuniSolar, {
      'day_epoch'  => 1749594, # CE78-02-16
      'day_border' => 0,       # Friday
      'rule_table' => intercalary_pattern_1
    }]

    BalineseLuniSolar1971 = [BalineseLuniSolar, {
      'day_epoch'  => 1749594, # CE78-02-16
      'day_border' => -23,     # Wednesday
      'rule_table' => intercalary_pattern_1
    }]

    BalineseLuniSolar1993 = [BalineseLuniSolar, {
      'day_epoch'  => 1749594, # CE78-02-16
      'day_border' => -23,     # Wednesday
      'rule_table' => intercalary_pattern_2
    }]

    BalineseLuniSolar2000 = [BalineseLuniSolar, {
      'day_epoch'  => 1749593, # CE78-02-15
      'day_border' => -23,     # Tuesday
      'rule_table' => intercalary_pattern_2
    }]

    BalineseLuniSolar2003 = [BalineseLuniSolar, {
      'day_epoch'  => 1749593, # CE78-02-15
      'day_border' => -23,     # Tuesday
      'rule_table' => intercalary_pattern_1
    }]

    #
    # Tenganan Calendar
    #
    Tenganan = [CyclicTableBased, {
      'label' => When.Resource('_m:BalineseTerms::Tenganan'),
      'origin_of_LSC' =>  1095 * 1573 - 381,
      'origin_of_MSC' =>  1,
      'indices' => [
         When::Coordinates::Index.new({:trunk=>When.Resource('_m:BalineseTerms::TengananMonth::*')}),
         When::Coordinates::DefaultDayIndex
       ],
      'rule_table' => {
        'T'  => {'Rule'  =>[360, 379, 356]},
        360  => {'Length'=>[30] * 12},
        379  => {'Length'=>[30] * 6 + [26] * 2 + [30] * 4 + [27]},
        356  => {'Length'=>[30] * 6 + [28] * 2 + [30] * 4 }
      }
    }]

    #
    # バリ暦の暦注
    #
    class CalendarNote::BalineseNote < CalendarNote

      NoteObjects = [When::BasicTypes::M17n, [
        "namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/]",
        "locale:[=en:, ja=ja:, alias]",
        "names:[Balinese]",

        # 年の暦注 ----------------------------
        [When::BasicTypes::M17n,
          "names:[year]"
        ],

        # 月の暦注 ----------------------------
        [When::BasicTypes::M17n,
          "names:[month]",
          [When::BasicTypes::M17n,
            "names:[Month]"
          ]
        ],

        # 日の暦注 ----------------------------
        [When::BasicTypes::M17n,
          "names:[day]",

          [When::BasicTypes::M17n,
            "names:[Hari=, 日名=]",

            [When::BasicTypes::M17n,
              "names:[Suklapaksa=, 白分=]",
              "[Lidi=   ]",
              "[Kuda=   ]",
              "[Kidang= ]",
              "[Macan=  ]",
              "[Kucing= ]",
              "[Sampi=  ]",
              "[Kerbau= ]",
              "[Tikus=  ]",
              "[Debu=   ]",
              "[Anjing= ]",
              "[Naga=   ]",
              "[Kambing=]",
              "[Mayang= ]",
              "[Gajah=  ]",
              "[Singa=  ]"
            ],

            [When::BasicTypes::M17n,
              "names:[Krsnapaksa=, 黒分=]",
              "[Ikan=   ]",
              "[Lilin=  ]",
              "[Ulung=  ]",
              "[Kelapa= ]",
              "[Banteng=]",
              "[Hantu=  ]",
              "[Areng=  ]",
              "[Udang=  ]",
              "[Semudra=]",
              "[Pare=   ]",
              "[Madu=   ]",
              "[Kala=   ]",
              "[Ular=   ]",
              "[Padi=   ]",
              "[Ulat=   ]"
            ]
          ],

          [When::BasicTypes::M17n,
            "names:[Dwiwara=, 2日週=]",
            "[Menga=]", #  0
            "[Pepet=]"  #  1
          ],

          [When::Coordinates::Residue,
            "label:[Triwara=, 3日週=]", "divisor:3", "day:2",
            [When::Coordinates::Residue, "label:[Pasah=       ]", "remainder:  0"],
            [When::Coordinates::Residue, "label:[Gelang Tegeh=]", "remainder:  1"],
            [When::Coordinates::Residue, "label:[Kajeng=      ]", "remainder:  2"]
          ],

          [When::BasicTypes::M17n,
            "names:[Tjaturwara=, 4日週=]",
            "[Sri=   ]",
            "[Laba=  ]",
            "[Jaya=  ]",
            "[Menala=]"
          ],

          [When::Coordinates::Residue,
            "label:[Pantjawara=, 5日週=]", "divisor:5", "day:1",
            [When::Coordinates::Residue, "label:[Paing= ]", "remainder:  0"],
            [When::Coordinates::Residue, "label:[Pon=   ]", "remainder:  1"],
            [When::Coordinates::Residue, "label:[Wage=  ]", "remainder:  2"],
            [When::Coordinates::Residue, "label:[Kliwon=]", "remainder:  3"],
            [When::Coordinates::Residue, "label:[Umanis=]", "remainder:  4"]
          ],

          [When::Coordinates::Residue,
            "label:[Perinkelan=, 六曜=]", "divisor:6", "day:2",
            [When::Coordinates::Residue, "label:[Tungleh=]", "remainder:  0"],
            [When::Coordinates::Residue, "label:[Aryang= ]", "remainder:  1"],
            [When::Coordinates::Residue, "label:[Urukung=]", "remainder:  2"],
            [When::Coordinates::Residue, "label:[Paniron=]", "remainder:  3"],
            [When::Coordinates::Residue, "label:[Was=    ]", "remainder:  4"],
            [When::Coordinates::Residue, "label:[Maulu=  ]", "remainder:  5"]
          ],

          [When::Coordinates::Residue,
            "label:[Sadwara=, 6日週=]", "divisor:6", "day:2",
            [When::Coordinates::Residue, "label:[Mina= ]", "remainder:  0"],
            [When::Coordinates::Residue, "label:[Taru= ]", "remainder:  1"],
            [When::Coordinates::Residue, "label:[Sato= ]", "remainder:  2"],
            [When::Coordinates::Residue, "label:[Patra=]", "remainder:  3"],
            [When::Coordinates::Residue, "label:[Wong= ]", "remainder:  4"],
            [When::Coordinates::Residue, "label:[Paksi=]", "remainder:  5"]
          ],

          [When::Coordinates::Residue,
            "label:[Septawara=, 7日週=]", "divisor:7", "day:6",
            [When::Coordinates::Residue, "label:[Reditē=   ]", "remainder:  0"],
            [When::Coordinates::Residue, "label:[Coma=     ]", "remainder:  1"],
            [When::Coordinates::Residue, "label:[Anggara=  ]", "remainder:  2"],
            [When::Coordinates::Residue, "label:[Buda=     ]", "remainder:  3"],
            [When::Coordinates::Residue, "label:[Wraspati= ]", "remainder:  4"],
            [When::Coordinates::Residue, "label:[Sukra=    ]", "remainder:  5"],
            [When::Coordinates::Residue, "label:[Saniscara=]", "remainder:  6"]
          ],

          [When::BasicTypes::M17n,
            "names:[Astawara=, 8日週=]",
            "[Sri=   ]",
            "[Indra= ]",
            "[Guru=  ]",
            "[Yama=  ]",
            "[Ludra= ]",
            "[Brahma=]",
            "[Kala=  ]",
            "[Uma=   ]"
          ],

          [When::BasicTypes::M17n,
            "names:[Sangawara=, 9日週=]",
            "[Dangu=  ]",
            "[Jangur= ]",
            "[Gigis=  ]",
            "[Nohan=  ]",
            "[Ogan=   ]",
            "[Erangan=]",
            "[Urungan=]",
            "[Tulus=  ]",
            "[Dadi=   ]"
          ],

          [When::BasicTypes::M17n,
            "names:[Dasawara=, 10日週=]",
            "[Pandita]", #  0
            "[Pati   ]", #  1
            "[Suka   ]", #  2
            "[Duka   ]", #  3
            "[Sri    ]", #  4
            "[Manuh  ]", #  5
            "[Manusa ]", #  6
            "[Raja   ]", #  7
            "[Dewa   ]", #  8
            "[Raksasa]"  #  9
          ],

          [When::Coordinates::Residue,
            "label:[Ingkel=]", "divisor:42", "day:20",
            [When::Coordinates::Residue, "label:[Wong= ]", "remainder:  0"],
            [When::Coordinates::Residue, "label:[Sato= ]", "remainder:  7"],
            [When::Coordinates::Residue, "label:[Mina= ]", "remainder: 14"],
            [When::Coordinates::Residue, "label:[Manuk=]", "remainder: 21"],
            [When::Coordinates::Residue, "label:[Taru= ]", "remainder: 28"],
            [When::Coordinates::Residue, "label:[Buku= ]", "remainder: 35"]
          ],

          [When::BasicTypes::M17n,
            "names:[Watek=]",
            "[Watu-Lembu=  ]", #  7
            "[Buta-Lintah= ]", #  8
            "[Suku-Uler=   ]", #  9
            "[Wong-Gajah=  ]", # 10
            "[Gajah-Lembu= ]", # 11
            "[Watu-Lintah= ]", # 12
            "[Buta-Uler=   ]", # 13
            "[Suku-Gajah=  ]", # 14
            "[Wong-Lembu=  ]", # 15
            "[Gajah-Lintah=]", # 16
            "[Watu-Uler=   ]", # 17
            "[Buta-Gajah=  ]"  # 18
          ],

          [When::Coordinates::Residue,
            "label:[Lintang=]", "divisor:35", "day:6",
            [When::Coordinates::Residue, "label:[Gajah=           ]", "remainder:  0"],
            [When::Coordinates::Residue, "label:[Kiriman=         ]", "remainder:  1"],
            [When::Coordinates::Residue, "label:[Jong Sarat=      ]", "remainder:  2"],
            [When::Coordinates::Residue, "label:[Tiwa-Tiwa=       ]", "remainder:  3"],
            [When::Coordinates::Residue, "label:[Sangkatikel=     ]", "remainder:  4"],
            [When::Coordinates::Residue, "label:[Bubu bolong=     ]", "remainder:  5"],
            [When::Coordinates::Residue, "label:[Sungenge=        ]", "remainder:  6"],
            [When::Coordinates::Residue, "label:[Uluku=           ]", "remainder:  7"],
            [When::Coordinates::Residue, "label:[Pedati=          ]", "remainder:  8"],
            [When::Coordinates::Residue, "label:[Kuda=            ]", "remainder:  9"],
            [When::Coordinates::Residue, "label:[Gajah-Mina=      ]", "remainder: 10"],
            [When::Coordinates::Residue, "label:[Bade=            ]", "remainder: 11"],
            [When::Coordinates::Residue, "label:[Maglut=          ]", "remainder: 12"],
            [When::Coordinates::Residue, "label:[Paglangan=       ]", "remainder: 13"],
            [When::Coordinates::Residue, "label:[Kala Sungsang=   ]", "remainder: 14"],
            [When::Coordinates::Residue, "label:[Kukus=           ]", "remainder: 15"],
            [When::Coordinates::Residue, "label:[Asu=             ]", "remainder: 16"],
            [When::Coordinates::Residue, "label:[Kartika=         ]", "remainder: 17"],
            [When::Coordinates::Residue, "label:[Naga=            ]", "remainder: 18"],
            [When::Coordinates::Residue, "label:[Banyakangrem=    ]", "remainder: 19"],
            [When::Coordinates::Residue, "label:[Ru=              ]", "remainder: 20"],
            [When::Coordinates::Residue, "label:[Patrem=          ]", "remainder: 21"],
            [When::Coordinates::Residue, "label:[Lembu=           ]", "remainder: 22"],
            [When::Coordinates::Residue, "label:[Dpat=            ]", "remainder: 23"],
            [When::Coordinates::Residue, "label:[Tangis=          ]", "remainder: 24"],
            [When::Coordinates::Residue, "label:[Salar Ukur=      ]", "remainder: 25"],
            [When::Coordinates::Residue, "label:[Prahu Pgat=      ]", "remainder: 26"],
            [When::Coordinates::Residue, "label:[Pwuhu atarung=   ]", "remainder: 27"],
            [When::Coordinates::Residue, "label:[Lawean=          ]", "remainder: 28"],
            [When::Coordinates::Residue, "label:[Kelapa=          ]", "remainder: 29"],
            [When::Coordinates::Residue, "label:[Yuyu=            ]", "remainder: 30"],
            [When::Coordinates::Residue, "label:[Lumbung=         ]", "remainder: 31"],
            [When::Coordinates::Residue, "label:[Kumba=           ]", "remainder: 32"],
            [When::Coordinates::Residue, "label:[Udang=           ]", "remainder: 33"],
            [When::Coordinates::Residue, "label:[Bgoong=          ]", "remainder: 34"]
          ],

          [When::Coordinates::Wuku,
            "label:[Wuku=]", "divisor:210", "day:146",
            [When::Coordinates::Wuku, "label:[Sinta=       ]", "remainder:  0"],
            [When::Coordinates::Wuku, "label:[Landep=      ]", "remainder:  7"],
            [When::Coordinates::Wuku, "label:[Ukir=        ]", "remainder: 14"],
            [When::Coordinates::Wuku, "label:[Kurantir=    ]", "remainder: 21"],
            [When::Coordinates::Wuku, "label:[Tulu=        ]", "remainder: 28"],
            [When::Coordinates::Wuku, "label:[Gumbreg=     ]", "remainder: 35"],
            [When::Coordinates::Wuku, "label:[Wariga=      ]", "remainder: 42"],
            [When::Coordinates::Wuku, "label:[Warigadian=  ]", "remainder: 49"],
            [When::Coordinates::Wuku, "label:[Julungwangi= ]", "remainder: 56"],
            [When::Coordinates::Wuku, "label:[Sungsang=    ]", "remainder: 63"],
            [When::Coordinates::Wuku, "label:[Dunggulan=   ]", "remainder: 70"],
            [When::Coordinates::Wuku, "label:[Kuningan=    ]", "remainder: 77"],
            [When::Coordinates::Wuku, "label:[Langkir=     ]", "remainder: 84"],
            [When::Coordinates::Wuku, "label:[Medangsiya=  ]", "remainder: 91"],
            [When::Coordinates::Wuku, "label:[Pujut=       ]", "remainder: 98"],
            [When::Coordinates::Wuku, "label:[Pahang=      ]", "remainder:105"],
            [When::Coordinates::Wuku, "label:[Krulut=      ]", "remainder:112"],
            [When::Coordinates::Wuku, "label:[Merakih=     ]", "remainder:119"],
            [When::Coordinates::Wuku, "label:[Tambir=      ]", "remainder:126"],
            [When::Coordinates::Wuku, "label:[Medangkungan=]", "remainder:133"],
            [When::Coordinates::Wuku, "label:[Matal=       ]", "remainder:140"],
            [When::Coordinates::Wuku, "label:[Uye=         ]", "remainder:147"],
            [When::Coordinates::Wuku, "label:[Menail=      ]", "remainder:154"],
            [When::Coordinates::Wuku, "label:[Prangbakat=  ]", "remainder:161"],
            [When::Coordinates::Wuku, "label:[Bala=        ]", "remainder:168"],
            [When::Coordinates::Wuku, "label:[Ugu=         ]", "remainder:175"],
            [When::Coordinates::Wuku, "label:[Wayang=      ]", "remainder:182"],
            [When::Coordinates::Wuku, "label:[Kelawu=      ]", "remainder:189"],
            [When::Coordinates::Wuku, "label:[Dukut=       ]", "remainder:196"],
            [When::Coordinates::Wuku, "label:[Watugunung=  ]", "remainder:203"]
          ]
        ]
      ]]

      #
      # When::Coordinates::Residue へ処理を委譲する暦注
      #
      # @private
      When.CalendarNote('BalineseNote/NoteObjects')['day::*'].each do |cood|
        case cood
        when Coordinates::Residue
          module_eval %Q{
            def #{cood.label.to_s.downcase}(date, parameter=nil)
              When.CalendarNote('BalineseNote/NoteObjects')['day']['#{cood.label.to_s}'] % date
            end
          }
        when BasicTypes::M17n
          module_eval %Q{
            def #{cood.to_s.downcase}(date, parameter=nil)
              (When.CalendarNote('BalineseNote/NoteObjects')['day']['Wuku'] % date).#{cood.to_s.downcase}
            end
          }
        end
      end

      #
      # 任意の暦をバリ暦日に変換
      #
      # @private
      def _to_date_for_note(date)
        return date if date.frame.kind_of?(When::CalendarTypes::BalineseLuniSolar)
        (date ^ When.era(:period=>'BalineseLuniSolar')).each do |list|
          return list[0] if list[0]
        end
        nil
      end

      # バリ暦日の「日名」
      #
      # @param [When::TM::TemporalPosition] date 「日名」を求める日付
      # @param [nil] parameter 未使用
      #
      # @return [When::BasicTypes::M17n] 「日名」(欠日の場合は2日分を'/'で連結)
      #
      def hari(date, parameter=nil)
        y, m, d = _to_date_for_note(date).cal_date
        thiti     = [d * 1 - 1]
        thiti[0] += 15 unless [0,1,nil].include?(m * 0)
        thiti << (thiti[0] + 1) % 30 if d * 0 == -2
        table = When.CalendarNote('BalineseNote/NoteObjects')['day']['Hari']
        thiti.map {|t| table[t / 15][t % 15]}.join('/')
      end

      private

      # オブジェクトの正規化
      def _normalize(args=[], options={})
        @event   = 'hari'
        @prime ||= [%w(Month), %w(Pantjawara Perinkelan Septawara Wuku)]
        super
      end
    end
  end
end
