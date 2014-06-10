# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  class BasicTypes::M17n

    Iranian = [self, [
      "namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/, ar=http://ar.wikipedia.org/wiki/]",
      "locale:[=en:, ja=ja:, ar=ar:, alias=ja:]",
      "names:[Iranian=]",
      "[SolarHijri=en:Iranian_calendars#Modern_calendar:_Solar_Hijri_.28SH.29, ヘジラ太陽暦=ja:%%<イラン暦>]",
      "[SolarHijriAlgorithmic=en:Solar_Hijri_calendar#Solar_Hijri_algorithmic_calendar, ヘジラ太陽暦=ja:%%<イラン暦>]",
      "[Jalali=en:http://en.wikipedia.org/wiki/Jalali_calendar, ジャラーリー暦]",

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
        "[Esfand=,      エスファンド=,         اسفند=,   スプンタ・アールマティ]"
      ]
    ]]
  end

  module Coordinates

    # Location of cities in Iran
    Iranian = [When::BasicTypes::M17n, [
      "namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/]",
      "locale:[=en:, ja=ja:, alias]",
      "names:[Iranian]",
      [Spatial, "long:51.4045E", "lat:32.3905N", "label:[Isfahan, エスファハーン]"],
      [Spatial, "long:51.2523E", "lat:35.4146N", "label:[Tehran,  テヘラン      ]"]
    ]]
  end

  class TM::CalendarEra

    # イラン暦
     Iranian = [self, [
      "namespace:[en=http://en.wikipedia.org/wiki/]",
      "area:[Iranian]",
      ["[Anno_Persico=en:Iranian_calendars,*alias:AP]1.1.1", "Calendar Epoch", "01-01-01^SolarHijri"],
    ]]
  end

  module CalendarTypes

    #
    # Solar Hijri Calendar
    #
    SolarHijri =  [YearLengthTableBased, {
      'label'   => 'Iranian::SolarHijri',
      'indices' => [
         When.Index('Iranian::Month', {:unit =>12}),
         When::Coordinates::DefaultDayIndex
       ],
       'origin_of_MSC' => -621,
       'epoch_in_CE'   => 0,
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
    SolarHijriAlgorithmic =  [CyclicTableBased, {
      'label'   => 'Iranian::SolarHijriAlgorithmic',
      'indices' => [
         When.Index('Iranian::Month', {:unit =>12}),
         When::Coordinates::DefaultDayIndex
       ],
       'origin_of_LSC' => 1948321 + 173125,
       'origin_of_MSC' => 475,
       'epoch_in_CE'   => 622+474,
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
    Jalali =  [HinduSolar, {
      'label'   => 'Iranian::Jalali',
      'indices' => [
         When.Index('Iranian::Month', {:unit =>12}),
         When::Coordinates::DefaultDayIndex
       ],
      'type'    => 'SBH'
    }]
  end
end
