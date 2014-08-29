# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When

  class BasicTypes::M17n

    Pax = [self, [
      "locale:[=en:, ja]",
      "names:[Pax=]",
      "[Pax=en:Pax_Calendar, パックス暦=ja:%%<13の月の暦>#%.<パックス暦>]",

      # %0s は“閏”の表記を抑制する指定となっている
      [self,
        "names:[Month, 月=ja:%%<月_(暦)>]",
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
        "[Columbus, 12月                      ]",
        "[December, 13月, /date/month_names/12]",
        "[%0sPax=en:Pax_Calendar, %0sパックス=ja:%%<13の月の暦>#%.<パックス暦>]" # Leap week
      ]
    ]]
  end

  module CalendarTypes

    #
    # Pax Calendar
    #
    Pax = [CyclicTableBased, {
      'label'            => 'Pax::Pax',
      'origin_of_LSC'    => 1721061,
      'indices'          => [
        When.Index('Pax::Month', {:branch=>{+1=>When.Resource('_m:Pax::Month::*')[13]}}),
        When::Coordinates::DefaultDayIndex
      ],
      'rule_table'       => {
        'T'  => {'Rule'  =>[364] + (1...400).to_a.map {|year|
          yy = year % 100
          (yy % 6) == 0 || yy==99 ? 371 : 364
        }},
        364  => {'Length'=>[28] * 13,          'IDs'=>'1,2,3,4,5,6,7,8,9,10,11,12,13'},
        371  => {'Length'=>[28] * 12 + [7,28], 'IDs'=>'1,2,3,4,5,6,7,8,9,10,11,12,12=,13'}
      }
    }]
  end
end
