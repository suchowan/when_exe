# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When

  class BasicTypes::M17n

    ArmenianTerms = [self, [
      "namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/]",
      "locale:[=en:, ja=ja:, alias]",
      "names:[ArmenianTerms=]",
      "[Armenian=en:Armenian_calendar, アルメニア暦=]",

      [self,
        "names:[Month=, 月=ja:%%<月_(暦)>]",
        "[nawasard= ]",
        "[hoṙi=     ]",
        "[sahmi=    ]",
        "[trē=      ]",
        "[kʿałocʿ=  ]",
        "[aracʿ=    ]",
        "[mehekan=  ]",
        "[areg=     ]",
        "[ahekan=   ]",
        "[mareri=   ]",
        "[margacʿ=  ]",
        "[hroticʿ=  ]",
        "[epagomenê=]"
      ]
    ]]
  end

  module CalendarTypes

    #
    # Armenian Calendar
    #
    Armenian =  [CyclicTableBased, {
      'label'         => Parts::Resource._instance('_m:ArmenianTerms::Armenian'),
      'origin_of_LSC' => 1922868,
      'origin_of_MSC' =>       1,
      'epoch_in_CE'   =>     552,
      'indices'       => [
        When::Coordinates::Index.new({:unit =>13, :trunk=>When::Parts::Resource._instance('_m:ArmenianTerms::Month::*')}),
        When::Coordinates::Index.new
      ],
      'rule_table' => {
        'T' => {'Rule'  =>[365]},
        365 => {'Length'=>[30]*12+[5]}
      }
    }]
  end
end
