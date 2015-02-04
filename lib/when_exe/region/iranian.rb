# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2015 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  class BasicTypes::M17n

    Iranian = [self, [
      "locale:[=en:, ja=ja:, ar=ar:, alias=ja:]",
      "names:[Iranian=]",
      "[SolarHijri=en:Solar_Hijri_calendar#Details_of_the_modern_calendar, ヘジラ太陽暦=ja:%%<イラン暦>]",
      "[SolarHijri (Combined)=en:Solar_Hijri_calendar#Details_of_the_modern_calendar, ヘジラ太陽暦(多種接続)=ja:%%<イラン暦>]",
      "[SolarHijriAlgorithmic=en:Solar_Hijri_calendar#Solar_Hijri_algorithmic_calendar, ヘジラ太陽暦(2820年周期)=ja:%%<イラン暦>]",
      "[Jalali=en:Jalali_calendar, ジャラーリー暦]",
      "[JalaliAlgorithmic=en:Jalali_calendar, ジャラーリー暦(2820年周期)=ja:%%<ジャラーリー暦>]",
      "[Borji=, ボルジ暦=]",

      [self,
        "names:[Month, 月=ja:%%<月_(暦)>]",
        "[Farvardīn=,   ファルヴァルディーン=, فروردین=,  フラワシ             ]",
        "[Ordībehesht=, オルディーベヘシュト=, اردیبهشت=, アシャ・ワヒシュタ   ]",
        "[Khordād=,     ホルダード=,           خرداد=,     ハルワタート        ]",
        "[Tīr=,         ティール=,             تیر=,       ティシュトリヤ      ]",
        "[Mordād=,      モルダード=,           مرداد=,     アムルタート        ]",
        "[Shahrīvar=,   シャハリーヴァル=,     شهریور=,   フシャスラ・ワルヤ   ]",
        "[Mehr=,        メフル=,               مهر=,       ミスラ              ]",
        "[Ābān=,        アーバーン=,           آبان=,      アープ              ]",
        "[Āzar=,        アーザル=,             آذر=,       アータル            ]",
        "[Dei=,         デイ=,                 دی=,        アフラ・マズダー    ]",
        "[Bahman=,      バフマン=,             بهمن=,      ウォフ・マナフ      ]",
        "[Esfand=,      エスファンド=,         اسفند=,   スプンタ・アールマティ]",
        "[Andarjah=]"
      ],

      [self,
        "names:[Sign=en:Astrological_sign, 十二宮]",
        "[Hamal=,   白羊宮]",
        "[Thur=,    金牛宮]",
        "[Jawzā=,   双児宮]",
        "[Saratān=, 巨蟹宮]",
        "[Asad=,    獅子宮]",
        "[Sunbula=, 処女宮]",
        "[Mizān=,   天秤宮]",
        "['Aqrab=,  天蝎宮]",
        "[Qaws=,    人馬宮]",
        "[Jadi=,    磨羯宮]",
        "[Dalw=,    宝瓶宮]",
        "[Hūt=,     双魚宮]"
      ]
    ]]
  end

  module Coordinates

    # Location of cities in Iran
    Iranian = [When::BasicTypes::M17n, [
      "locale:[=en:, ja=ja:, alias]",
      "names:[Iranian]",
      [Spatial, "long:51.4045E", "lat:32.3905N", "label:[Isfahan, エスファハーン]"],
      [Spatial, "long:51.2523E", "lat:35.4146N", "label:[Tehran,  テヘラン      ]"]
    ]]
  end

  class TM::CalendarEra

    # イラン暦
    Iranian = [self, [
      "area:[Iranian]",
      ["[Anno_Persico=en:Iranian_calendars,*alias:AP]1.1.1",  '@CE', "0001-01-01^TableBasedJalali",
								     "1230-01-01^Borji",
								     "1304-01-01^SolarHijri", ""],
      ["[Anno_Cyrus=,*alias:AC]2535.1.1",		      "",    "1355-01-01^SolarHijri"],
      ["[Anno_Hijra=en:Iranian_calendars,*alias:AH]1357.6.5", "@CR", "1357-06-05^SolarHijri"]
    ]]
  end

  module CalendarTypes

    _indicesM = [
      When.Index('Iranian::Month', {:unit =>12}),
      When::Coordinates::DefaultDayIndex
    ]

    _indicesJ = [
      When.Index('Iranian::Month', {:unit =>13}),
      When::Coordinates::DefaultDayIndex
    ]

    _indicesS = [
      When.Index('Iranian::Sign', {:unit =>12}),
      When::Coordinates::DefaultDayIndex
    ]

    #
    # Solar Hijri Calendar
    #
    SolarHijri = [SolarYearTableBased, {
      'label'         => 'Iranian::SolarHijri',
      'indices'       => _indicesM,
      'origin_of_MSC' => -621,
      'epoch_in_CE'   =>  621,
      'cycle_offset'  => 0,
      'time_basis'    => '+15:30',
      'rule_table'    => {
        365 => {'Length'=>[31] * 6 + [30] * 5 + [29]},
        366 => {'Length'=>[31] * 6 + [30] * 6}
      }
    }]

    #
    # Solar Hijri Algorithmic Calendar
    #
    SolarHijriAlgorithmic = [CyclicTableBased, {
      'label'         => 'Iranian::SolarHijriAlgorithmic',
      'indices'       => _indicesM,
      'origin_of_LSC' => 1948321 + 173125,
      'origin_of_MSC' => 475,
      'epoch_in_CE'   => 621,
      'rule_table'    => {
        'T'    => {'Rule' =>['C128'] * 21 + ['C132']},
        'C128' => {'Rule' =>['C29'] + ['C33'] * 3},
        'C132' => {'Rule' =>['C29'] + ['C33'] * 2 + ['C37']},
        'C29'  => {'Rule' =>[365] + ([365] * 3 + [366]) * 7},
        'C33'  => {'Rule' =>[365] + ([365] * 3 + [366]) * 8},
        'C37'  => {'Rule' =>[365] + ([365] * 3 + [366]) * 9},
         365   => {'Length'=>[31] * 6 + [30] * 5 + [29]},
         366   => {'Length'=>[31] * 6 + [30] * 6}
      }
    }]

    #
    # Jalali Calendar
    #
    Jalali = [HinduSolar, {
      'label'   => 'Iranian::Jalali',
      'indices' => _indicesM,
      'type'    => 'SBH'
    }]

    #
    # Table Based Jalali Calendar
    #
    TableBasedJalali = [CyclicTableBased, {
      'label'         => 'Iranian::JalaliAlgorithmic',
      'indices'       => _indicesJ,
      'origin_of_LSC' => 1948321 + 173125,
      'origin_of_MSC' => 475,
      'epoch_in_CE'   => 621,
      'rule_table'    => {
        'T'    => {'Rule' =>['C128'] * 21 + ['C132']},
        'C128' => {'Rule' =>['C29'] + ['C33'] * 3},
        'C132' => {'Rule' =>['C29'] + ['C33'] * 2 + ['C37']},
        'C29'  => {'Rule' =>[365] + ([365] * 3 + [366]) * 7},
        'C33'  => {'Rule' =>[365] + ([365] * 3 + [366]) * 8},
        'C37'  => {'Rule' =>[365] + ([365] * 3 + [366]) * 9},
         365   => {'Length'=>[30] * 12 + [5]},
         366   => {'Length'=>[30] * 12 + [6]}
      }
    }]

    #
    # Borji Calendar
    #
    Borji = [EphemerisBasedSolar, {
      'label'         => 'Iranian::Borji',
      'indices'       => _indicesS,
      'origin_of_MSC' => -621,
      'epoch_in_CE'   =>  621,
      'cycle_offset'  => 0,
      'time_basis'    => '+15:30'
    }]

    #
    # Table Based Borji Calendar
    #
    TableBasedBorji = [PatternTableBasedSolar, {
      'label'         => 'Iranian::SolarHijri (Combined)',
      'indices'       => _indicesM,
      'origin_of_MSC' => 1230,
      'origin_of_LSC' => 2397203,
      'epoch_in_CE'   =>  621,
      'before'        => 'Borji',
      'after'         => 'SolarHijriAlgorithmic',
      'rule_table'=> %w(
	112111000900	011211000900	012111190900	111121009090	111211000900
	011211000900	012111190900	111120109090	111211009000	011211000900
	012111190900	021120109090	111211009090	111211000900	012111190900
	012120109090	111211009090	111211000900	012111190900	012120109090
	111121009090	111211000900	012111000900	012111109090	111121009090
	111211000900	011211000900	012111109090	111121009090	111211000900
	011211000900	012111109900	111121009090	111211000900	011211000900
	012111109900	111121009090	111211000900	011211000900	012111190900
	111120109090	111211009000	011211000900	012111190900	012120109090
	111211009090	111211000900	012111190900	012120109090	111121009090
	111211000900	012111190900	012111109090	111121009090	111211000900
	011211000900	012111109090	111121009090	111211000900	011211000900
	012111109090	111121009090	111211000900	011211000900	012111109090
	111121009090	111211000900	011211000900	012111109900	111120109090
	111211000900	011211000900	012111190900	012120109090)
    }]
  end
end
