# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  class BasicTypes::M17n

    IranianTerms = [self, [
      "namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/, ar=http://ar.wikipedia.org/wiki/]",
      "locale:[=en:, ja=ja:, ar=ar:, alias=ja:]",
      "names:[IranianTerms]",
      "[SolarHejri=en:Iranian_calendars#Modern_calendar_.28Solar_Hejri.29, ヘジラ太陽暦=ja:%%<イラン暦>]",

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

  class TM::CalendarEra

    # イラン暦
     Iranian = [self, [
      "namespace:[en=http://en.wikipedia.org/wiki/]",
      "area:[Iranian]",
      ["[Anno_Persico=en:Iranian_calendars,*alias:AP]1.1.1", "Calendar Epoch", "01-01-01^SolarHejri"],
    ]]
  end

  module CalendarTypes

    #
    # Solar Hejri Calendar
    #
    SolarHejri =  [YearLengthTableBased, {
      'label'   => When.Resource('_m:IranianTerms::SolarHejri'),
      'indices' => [
         When::Coordinates::Index.new({:unit =>12, :trunk=>When.Resource('_m:IranianTerms::Month::*')}),
         When::Coordinates::DefaultDayIndex
       ],
       'origin_of_MSC' => -621,
       'epoch_in_CE'   => 0,
       'cycle_offset'  => 0,
       'timezone'      => 12 + 3 + Rational(1,2),
       'rule_table'    => {
         365 => {'Length'=>[31] * 6 + [30] * 5 + [29]},
         366 => {'Length'=>[31] * 6 + [30] * 6}
       }
    }]
  end
end
