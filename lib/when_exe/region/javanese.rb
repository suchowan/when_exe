# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2015 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  class BasicTypes::M17n

    Javanese = [self, [
      "locale:[=en:, ja=ja:, zh=zh:, alias]",
      "names:[Javanese=en:Java, ジャワ=ja:ジャワ島, 爪哇=zh:爪哇岛]",
      "[JavaneseLunar=, ジャワ・イスラーム暦=, 爪哇伊斯蘭曆=]",
      "[Pranatamangsa=, プラノトモンソ=]",

      [self,
        "names:[HinduMonth=, ヒンドゥ月=, 印度月=]",
        "[Kalima=,      5月=]",
        "[Kanem=,       6月=]",
        "[Kapitu=,      7月=]",
        "[Kawolu=,      8月=]",
        "[Kasanga=,     9月=]",
        "[Kasapuluh=,  10月=]",
        "[Dhestal=,    11月=]",
        "[Sadha=,      12月=]",
        "[Kasa=,        1月=]",
        "[Karo=,        2月=]",
        "[Katelu=,      3月=]",
        "[Kapat=,       4月=]"
      ],

      [self,
        "names:[IslamicMonth=, イスラーム月=, 伊斯蘭月=]",
        "[Suro=,        1月=]",
        "[Sapar=,       2月=]",
        "[Mulud=,       3月=]",
        "[Bakdomulud=,  4月=]",
        "[Jumadilawal=, 5月=]",
        "[Jumadilakir=, 6月=]",
        "[Rejeb=,       7月=]",
        "[Ruwah=,       8月=]",
        "[Poso=,        9月=]",
        "[Sawal=,      10月=]",
        "[Dulkaidah=,  11月=]",
        "[Besar=,      12月=]"
      ]
    ]]
  end

  class CalendarNote
    Javanese = [['Javanese::Windu'], ['_m:Calendar::Month'],
                ['Javanese::Pasaran', 'Javanese::Paringkelan', 'Javanese::Week', 'Javanese::Wuku']]
  end

  module Coordinates

    # Javanese Residues
    Javanese = [When::BasicTypes::M17n, [
      "locale:[=en:, ja=ja:, alias]",
      "names:[Javanese=en:Java, ジャワ=ja:ジャワ島, zh:爪哇=zh:爪哇岛]",

      [Residue,
        "label:[Windu=, ウィンドゥ=]", "divisor:8", "year:3",
        [Residue, "label:[Alip=   ]", "remainder:  0"],
        [Residue, "label:[Ehe=    ]", "remainder:  1"],
        [Residue, "label:[Jimawal=]", "remainder:  2"],
        [Residue, "label:[Je=     ]", "remainder:  3"],
        [Residue, "label:[Dal=    ]", "remainder:  4"],
        [Residue, "label:[Be=     ]", "remainder:  5"],
        [Residue, "label:[Wawu=   ]", "remainder:  6"],
        [Residue, "label:[Jimakir=]", "remainder:  7"]
      ],

      [Residue,
        "label:[Pasaran=, 五曜=]", "divisor:5", "day:1",
        [Residue, "label:[Paing=  ]", "remainder:  0"],
        [Residue, "label:[Pon=    ]", "remainder:  1"],
        [Residue, "label:[Wage=   ]", "remainder:  2"],
        [Residue, "label:[Kliwon= ]", "remainder:  3"],
        [Residue, "label:[Legi=   ]", "remainder:  4"]
      ],

      [Residue,
        "label:[Paringkelan=, 六曜=]", "divisor:6", "day:2",
        [Residue, "label:[Tungle=   ]", "remainder:  0"],
        [Residue, "label:[Aryang=   ]", "remainder:  1"],
        [Residue, "label:[Warukung= ]", "remainder:  2"],
        [Residue, "label:[Paningron=]", "remainder:  3"],
        [Residue, "label:[Uwas=     ]", "remainder:  4"],
        [Residue, "label:[Mawulu=   ]", "remainder:  5"]
      ],

      [Residue,
        "label:[Week=, 七曜=]", "divisor:7", "day:6",
        [Residue, "label:[Minggu=]", "remainder:  0"],
        [Residue, "label:[Senin= ]", "remainder:  1"],
        [Residue, "label:[Selasa=]", "remainder:  2"],
        [Residue, "label:[Rabu=  ]", "remainder:  3"],
        [Residue, "label:[Kamis= ]", "remainder:  4"],
        [Residue, "label:[Jumat= ]", "remainder:  5"],
        [Residue, "label:[Sabtu= ]", "remainder:  6"]
      ],

      [Residue,
        "label:[Wuku=, ウク週=]", "divisor:210", "day:146",
        [Residue, "label:[Sinto=       ]", "remainder:  0"],
        [Residue, "label:[Landep=      ]", "remainder:  7"],
        [Residue, "label:[Wukir=       ]", "remainder: 14"],
        [Residue, "label:[Kurantil=    ]", "remainder: 21"],
        [Residue, "label:[Tolu=        ]", "remainder: 28"],
        [Residue, "label:[Gumbrek=     ]", "remainder: 35"],
        [Residue, "label:[Warigalit=   ]", "remainder: 42"],
        [Residue, "label:[Warigagung=  ]", "remainder: 49"],
        [Residue, "label:[Julungwangi= ]", "remainder: 56"],
        [Residue, "label:[Sungsang=    ]", "remainder: 63"],
        [Residue, "label:[Galungan=    ]", "remainder: 70"],
        [Residue, "label:[Kuningan=    ]", "remainder: 77"],
        [Residue, "label:[Langkir=     ]", "remainder: 84"],
        [Residue, "label:[Mondosijo=   ]", "remainder: 91"],
        [Residue, "label:[Julungpujut= ]", "remainder: 98"],
        [Residue, "label:[Pahang=      ]", "remainder:105"],
        [Residue, "label:[Kuruwekut=   ]", "remainder:112"],
        [Residue, "label:[Marakeh=     ]", "remainder:119"],
        [Residue, "label:[Tambir=      ]", "remainder:126"],
        [Residue, "label:[Medangkungan=]", "remainder:133"],
        [Residue, "label:[Maktal=      ]", "remainder:140"],
        [Residue, "label:[Waye=        ]", "remainder:147"],
        [Residue, "label:[Menahil=     ]", "remainder:154"],
        [Residue, "label:[Prangbakat=  ]", "remainder:161"],
        [Residue, "label:[Bolo=        ]", "remainder:168"],
        [Residue, "label:[Wugu=        ]", "remainder:175"],
        [Residue, "label:[Wayang=      ]", "remainder:182"],
        [Residue, "label:[Kulawu=      ]", "remainder:189"],
        [Residue, "label:[Dukut=       ]", "remainder:196"],
        [Residue, "label:[Watugunung=  ]", "remainder:203"]
      ]
   ]]
  end

  class TM::CalendarEra

    # サカ紀元
     JavaneseLunar = [self, [
      "locale:[=en:, ja=ja:, zh=zh:, alias]",
      "period:[JavaneseLunar=, ジャワ・イスラーム暦=, 爪哇伊斯蘭曆=]",
      ["[SE=, サカ暦=, 塞種紀元=, alias:Javanese_Saka_Era]1547.1.1", '@CE', "1035-01-01^Javanese1547",
							 "1163-01-01^Javanese1675",
							 "1237-01-01^Javanese1749", '+Infinity']
    ]]
  end

  module CalendarTypes

    #
    # Javanese Calendar (SE1547-1674) : Dal年 - 閏年
    #
    Javanese1547 =  [CyclicTableBased, {
      'origin_of_LSC' =>  2317690,
      'origin_of_MSC' =>     1555-512,
      'indices' => [
         When.Index('Javanese::IslamicMonth', {:unit =>12}),
         When::Coordinates::DefaultDayIndex
      ],
      'rule_table'    => {
        'T'   => {'Rule'  =>[354, 355, 354, 354, 355, 354, 354, 355]*15, 'Days' => (354*8+3)*15-1},
        354   => {'Length'=>[30,29] * 6           },
        355   => {'Length'=>[30,29] * 5 + [30] * 2}
      },
      'note'  => 'Javanese'
    }]

    #
    # Javanese Calendar (SE1675-1748) : Dal年 - 平年
    #
    Javanese1675 =  [CyclicTableBased, {
      'origin_of_LSC' =>  2360214,
      'origin_of_MSC' =>     1675-512,
      'indices' => [
         When.Index('Javanese::IslamicMonth', {:unit =>12}),
         When::Coordinates::DefaultDayIndex
       ],
      'rule_table'    => {
        'T'   => {'Rule'  =>[354, 355, 354, 355, 354, 354, 354, 355]*15, 'Days' => (354*8+3)*15-1},
        354   => {'Length'=>[30,29] * 6                 },
        355   => {'Length'=>[30,29] * 5 + [30] * 2      }
      },
      'note'  => 'Javanese'
    }]

    #
    # Javanese Calendar (SE1749-) : Dal年 - 平年,月日別配当
    #
    Javanese1749 =  [CyclicTableBased, {
      'origin_of_LSC' =>  2385728,
      'origin_of_MSC' =>     1747-512,
      'indices' => [
         When.Index('Javanese::IslamicMonth', {:unit =>12}),
         When::Coordinates::DefaultDayIndex
       ],
      'rule_table'    => {
        'T'   => {'Rule'  =>[354, 355, 354, 355, 'D', 354, 354, 355]*15, 'Days' => (354*8+3)*15-1},
        354   => {'Length'=>[30,29] * 6                 },
        'D'   => {'Length'=>[30]*2+[29]*3+[29,30]*3+[30]},
        355   => {'Length'=>[30,29] * 5 + [30] * 2      }
      },
      'note'  => 'Javanese'
    }]

    #
    # Pranatamangsa
    #
    Pranatamangsa =  [CyclicTableBased, {
      'label'         => 'Javanese::Pranatamangsa',
      'origin_of_LSC' => 1721232,
      'origin_of_MSC' =>   -1854,
      'indices' => [
         When.Index('Javanese::HinduMonth', {:unit =>12, :shift=>8}),
         When::Coordinates::DefaultDayIndex
       ],
      'rule_table'     => {
        'T'  => {'Rule'  =>['LC', 'SC', 'SC', 'SC']},
        'SC' => {'Rule'  =>[365]*4 + [366, 365, 365, 365]*24},
        'LC' => {'Rule'  =>[366, 365, 365, 365]*25},
        365  => {'Length'=>[41, 23, 24, 25, 27, 43, 43, 26, 25, 24, 23, 41]},
        366  => {'Length'=>[41, 23, 24, 25, 27, 43, 43, 27, 25, 24, 23, 41]}
      }
    }]
  end
end
