# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2015 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When

  class BasicTypes::M17n

    Coptic = [self, [
      "locale:[=en:, ja=ja:, zh=zh:, alias]",
      "names:[Coptic=]",
      "[Coptic=en:Coptic_calendar,       コプト暦,                           科普特曆     ]",
      "[Ethiopian=en:Ethiopian_calendar, エチオピア暦=en:Ethiopian_calendar, 埃塞俄比亞曆=]",
      "[Egyptian=en:Egypt,               エジプト,                           埃及         ]",
      "[Ptolemaic=en:Ptolemaic_dynasty,  プトレマイオス朝,                   托勒密王朝   ]",

      # Remarks
      '[based on Chris Bennett "Egyptian Dates" (Retrieved 2014-06-29)=http://www.tyndalehouse.com/Egypt/ptolemies/chron/egyptian/chron_eg_intro.htm,' +
       '典拠 - Chris Bennett "Egyptian Dates" (2014-06-29 閲覧)=]',

      [self,
        "names:[EgyptianMonth=, 月=ja:%%<月_(暦)>]",
        "[tut=,      トート=      ]",
        "[baba=,     バーバ=      ]",
        "[hatur=,    ハートール=  ]",
        "[kiyahak=,  キヤハーク=  ]",
        "[tuba=,     トーバ=      ]",
        "[amshir=,   アムシール=  ]",
        "[baramhat=, バラムハート=]",
        "[barmuda=,  バルムーダ=  ]",
        "[bashans=,  バシャンス=  ]",
        "[ba'una=,   バウーナ=    ]",
        "[abib=,     アビーブ=    ]",
        "[misra=,    ミスラー=    ]",
        "[epagomen=, エパゴメネ=  ]"
      ],

      [self,
        "names:[EthiopianMonth=, 月=ja:%%<月_(暦)>]",
        "[Mäskäräm=, マスカラム=  ]",
        "[Ṭəqəmt=,   テケルト=    ]",
        "[Ḫədar=,    ヘダル=      ]",
        "[Taḫśaś=,   ターサス=    ]",
        "[Ṭərr=,     テル=        ]",
        "[Yäkatit=,  イェカティト=]",
        "[Mägabit=,  メガビト=    ]",
        "[Miyazya=,  ミアジア=    ]",
        "[Gənbot=,   ゲエンポト=  ]",
        "[Säne=,     セネ=        ]",
        "[Ḥamle=,    ハムレ=      ]",
        "[Nähase=,   ネハッセ=    ]",
        "[Ṗagʷəmen=, パゴウメン=  ]"
      ]
    ]]
  end

  module CalendarTypes

    _egyptian_month_indices  = [
      When.Index('Coptic::EgyptianMonth', {:unit =>13}),
      When::Coordinates::DefaultDayIndex
    ]

    _ethiopian_month_indices = [
      When.Index('Coptic::EthiopianMonth', {:unit =>13}),
      When::Coordinates::DefaultDayIndex
    ]

    #
    # Coptic Calendar in Egypt and Ethiopia
    #
    Coptic =  [{'Epoch'=>{'284Y'=>{'origin_of_MSC' =>   1},
                            '0Y'=>{'origin_of_MSC' => 285},
                            '8Y'=>{'origin_of_MSC' => 277,
                                   'label'         => 'Coptic::Ethiopian',
                                   'indices'       => _ethiopian_month_indices}}}, CyclicTableBased, {
      'label'         => 'Coptic::Coptic',
      'origin_of_LSC' => 1825030,
      'origin_of_MSC' =>       1,
      'diff_to_CE'    =>     285,
      'indices'       => _egyptian_month_indices,
      'rule_table' => {
        'T' => {'Rule'  =>[365,365,366,365]},
        365 => {'Length'=>[30]*12+[5]},
        366 => {'Length'=>[30]*12+[6]}
      }
    }]

    #
    # Egyptian Calendar based on Chris Bennett, http://www.tyndalehouse.com/Egypt/ptolemies/chron/babylonian/chron_bab_intro_fr.htm
    #
    Ptolemaic =  [CyclicTableBased, {
      'label'         => 'Coptic::Ptolemaic',
      'remarks'       => When.M17n('Coptic::based on Chris Bennett "Egyptian Dates" (Retrieved 2014-06-29)'),
      'origin_of_LSC' => 1600478,
      'origin_of_MSC' =>    -330,
      'indices'       => _egyptian_month_indices,
      'rule_table' => {
        'T' => {'Rule'  =>[365]},
        365 => {'Length'=>[30]*12+[5]}
      }
    }]
  end
end
