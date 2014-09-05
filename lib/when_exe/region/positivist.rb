# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When

  class BasicTypes::M17n

    Positivist = [self, [
      "locale:[=en:, ja=ja:, alias]",
      "names:[Positivist=]",
      "[Positivist=en:Positivist_calendar, オーギュスト・コントの暦=ja:%%<13の月の暦>#%.<実証暦>]"
    ]]
  end

  #
  # Positivist Week
  #
  class CalendarNote::PositivistWeek < CalendarNote::Week

    #
    # Positivist Note
    #
    Notes = [When::BasicTypes::M17n, [
      "locale:[=en:, ja=ja:, alias]",
      "names:[Positivist]",

      # Notes for year ----------------------------
      [When::BasicTypes::M17n,
        "names:[year]"
      ],

      # Notes for month ----------------------------
      [When::BasicTypes::M17n,
        "names:[month]",
        [When::BasicTypes::M17n,
          "names:[Month]",
          "[Moses,                                      モーセ                                              ]",
          "[Homer,                                      ホメーロス                                          ]",
          "[Aristotle,                                  アリストテレス                                      ]",
          "[Archimedes,                                 アルキメデス                                        ]",
          "[Caesar=en:Julius_Caesar,                    カエサル=ja:%%<ガイウス・ユリウス・カエサル>        ]",
          "[Saint Paul=en:Paul_of_Tarsus,               パウロ                                              ]",
          "[Charlemagne,                                シャルルマーニュ=ja:%%<カール大帝>                  ]",
          "[Dante=en:Dante_Alighieri,                   ダンテ=ja:%%<ダンテ・アリギエーリ>                  ]",
          "[Gutenberg=en:Johann_Gutenberg,              グーテンベルク=ja:%%<ヨハネス・グーテンベルク>      ]",
          "[Shakespeare=en:William_Shakespeare,         シェイクスピア=ja:%%<ウィリアム・シェイクスピア>    ]",
          "[Descartes=en:%%<René_Descartes>,            デカルト=ja:%%<ルネ・デカルト>                      ]",
          "[Frederick=en:Frederick_II_of_Prussia,       フリードリヒ=ja:%%<フリードリヒ2世 (プロイセン王)>  ]",
          "[Bichat=en:%%<Marie_François_Xavier Bichat>, ビシャ=ja:%%<マリー・フランソワ・クサヴィエ・ビシャ>]"
        ]
      ],

      # Notes for day ----------------------------
      [When::BasicTypes::M17n,
        "names:[day]",
        [When::BasicTypes::M17n,
          "names:[Week]",
          [DayOfWeek, "label:[Monday,                  月曜日, /date/day_names/1]", {'delta'=>  7}],
          [DayOfWeek, "label:[Tuesday,                 火曜日, /date/day_names/2]", {'delta'=>  7}],
          [DayOfWeek, "label:[Wednesday,               水曜日, /date/day_names/3]", {'delta'=>  7}],
          [DayOfWeek, "label:[Thursday,                木曜日, /date/day_names/4]", {'delta'=>  7}],
          [DayOfWeek, "label:[Friday,                  金曜日, /date/day_names/5]", {'delta'=>  7}],
          [DayOfWeek, "label:[Saturday,                土曜日, /date/day_names/6]", {'delta'=>  7}],
          [DayOfWeek, "label:[Sunday,                  日曜日, /date/day_names/0]", {'delta'=>  7}],
          [DayOfWeek, "label:[Festival_of_the_Dead,    祖先の祭=]", {'delta'=> 366}],
          [DayOfWeek, "label:[Festival_of_Holy_Women=, 聖女の祭=]", {'delta'=>1461}]
        ],

        "[Common_Week]"
      ]
    ]]

    fixed_week_definitions

  end

  module CalendarTypes
    #
    # Positivist calendar based on Gregorian calendar
    #
    Positivist =  [YearLengthTableBased, {
      'label'   => 'Positivist::Positivist',
      'indices' => [
          When.Index('PositivistWeekNotes::month::Month', {:unit =>13}),
         When::Coordinates::DefaultDayIndex
        ],
      'origin_of_MSC'    => -1788,
      'diff_to_CE'       =>     0,
      'rule_table'       => {
        365  => {'Length'=>[28]*12 + [29]},
        366  => {'Length'=>[28]*12 + [30]}
      },
      'note'   => 'PositivistWeek'
    }]
  end
end
