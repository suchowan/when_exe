# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014-2015 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When

  class BasicTypes::M17n

    HankeHenry = [self, [
      "locale:[=en:, ja]",
      "names:[HankeHenry=]",
      "[HankeHenry=en:Hanke-Henry_Permanent_Calendar, ハンキ＝ヘンリー暦=ja:%%<ハンキ＝ヘンリー・パーマネント・カレンダー>]",

      [self,
        "names:[month name=en:Month, 月の名前=ja:%%<月_(暦)>, zh:該月的名稱=, *alias:Month=]",
        "[January,   1月, /date/month_names/1] ",
        "[February,  2月, /date/month_names/2] ",
        "[March,     3月, /date/month_names/3] ",
        "[April,     4月, /date/month_names/4] ",
        "[May,       5月, /date/month_names/5] ",
        "[June,      6月, /date/month_names/6] ",
        "[July,      7月, /date/month_names/7] ",
        "[August,    8月, /date/month_names/8] ",
        "[September, 9月, /date/month_names/9] ",
        "[October,  10月, /date/month_names/10]",
        "[November, 11月, /date/month_names/11]",
        "[December, 12月, /date/month_names/12]",
        "[Xtra=en:Hanke-Henry_Permanent_Calendar, 追加週=ja:%%<ハンキ＝ヘンリー・パーマネント・カレンダー>]" # Leap week
      ]
    ]]
  end

  module CalendarTypes

    #
    # Hanke-Henry Calendar
    #
    HankeHenry = [CyclicTableBased, {
      'label'         => 'HankeHenry::HankeHenry',
      'origin_of_LSC' => 1721061,
      'indices'       => [
        When.Index('HankeHenry::Month'),
        When::Coordinates::DefaultDayIndex
      ],
      'rule_table'    => {
        'T'  => {'Rule'  =>(2000...2400).to_a.map {|year|
                  [When.tm_pos(year,1,1), When.tm_pos(year,12,31)].map {|date| date.to_i % 7}.include?(3) ? 371 : 364
                }},
        364  => {'Length'=>[30,30,31]*4},
        371  => {'Length'=>[30,30,31]*4 +[7]}
      }
    }]
  end
end
