# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

=begin

  References

 (1) http://en.wikipedia.org/wiki/Zoroastrian_calendar
 (2) http://www.moonwise.co.uk/year/1375zoroastrian.htm
 (3) http://www.zoroastrian.org/articles/nowruz.htm

=end

module When
  class BasicTypes::M17n

    Zoroastrian = [self, [
      "namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/, ar=http://ar.wikipedia.org/wiki/]",
      "locale:[=en:, ja=ja:, ar=ar:, alias=ja:]",
      "names:[Zoroastrian=]",
      "[Zoroastrian=en:Zoroastrian_calendar#The_reckoning_of_years,   ゾロアスター暦=  ]",
      "[Qadimi=en:Zoroastrian_calendar#The_Qadimi_calendar ,          カディミ暦=      ]",
      "[Shahanshahi=en:Zoroastrian_calendar#The_Shahanshahi_calendar, シャハンシャヒ暦=]",
      "[Fasli=en:Zoroastrian_calendar#The_Fasli_calendar ,            ファスリ暦=      ]"
    ]]
  end

  #
  # ゾロアスター暦の暦注
  #
  class CalendarNote::Zoroastrian < CalendarNote

    Notes = [When::BasicTypes::M17n, [
      "namespace:[en=http://en.wikipedia.org/wiki/]",
      "locale:[=en:]",
      "names:[Zoroastrian]",

      # 年の暦注 ----------------------------
      [When::BasicTypes::M17n,
        "names:[year]",
      ],

      # 月の暦注 ----------------------------
      [When::BasicTypes::M17n,
        "names:[month]",
        [When::BasicTypes::M17n,
          "names:[Month]",
          "[Fravardin=   ]",
          "[Ardibehest=  ]",
          "[Khordad=     ]",
          "[Tir=         ]",
          "[Amardad=     ]",
          "[Shehrevar=   ]",
          "[Meher=       ]",
          "[Avan=        ]",
          "[Adar=        ]",
          "[Dae=         ]",
          "[Bahman=      ]",
          "[Aspandarmad= ]",
          "[Gatha Days=  ]"
        ]
      ],

      # 日の暦注 ----------------------------
      [When::BasicTypes::M17n,
        "names:[day]",
        [When::BasicTypes::M17n,
          "names:[divinity]",
          "[Hormazd=        ]", # 01
          "[Bahman=         ]", # 02
          "[Ardibehest=     ]", # 03
          "[Shehrevar=      ]", # 04
          "[Aspandarmad=    ]", # 05
          "[Khordad=        ]", # 06
          "[Amardad=        ]", # 07
          "[Daepadar=       ]", # 08
          "[Adar=           ]", # 09
          "[Avan=           ]", # 10
          "[Khorshed=       ]", # 11
          "[Mohor=          ]", # 12
          "[Tir=            ]", # 13
          "[Gosh=           ]", # 14
          "[Daepmeher=      ]", # 15
          "[Meher=          ]", # 16
          "[Srosh=          ]", # 17
          "[Rashne=         ]", # 18
          "[Fravardin=      ]", # 19
          "[Behram=         ]", # 20
          "[Ram=            ]", # 21
          "[Govad=          ]", # 22
          "[Daepdin=        ]", # 23
          "[Din=            ]", # 24
          "[Ashishvangh=    ]", # 25
          "[Ashtad=         ]", # 26
          "[Asman=          ]", # 27
          "[Zamyad=         ]", # 28
          "[Mahrespand=     ]", # 29
          "[Aneran=         ]", # 30
          "[Ahunavad=       ]", # 31
          "[Ushtavad=       ]", # 32
          "[Spentomad=      ]", # 33
          "[Vohukhshathra=  ]", # 34
          "[Vahishtoist=    ]", # 35
          "[intercalary day=]"  # 36
        ]
      ]
    ]]

    # 暦注 - 日の名前
    #
    # @param [When::TM::CalDate] date
    #
    # @return [String]
    #
    def divinity(date)
      y, m, d = date.cal_date
      When.CalendarNote('Zoroastrian/Notes::day::divinity::*')[m <= 12 ? d-1 : d+29]
    end
  end

  module CalendarTypes

    #
    # Zoroastrian Calendar
    #
    Zoroastrian =  [CyclicTableBased, {
      'label'   => 'Zoroastrian::Zoroastrian',
      'indices' => [
         When.Index('ZoroastrianNotes::month::Month', {:unit =>13}),
         When::Coordinates::DefaultDayIndex
       ],
      'origin_of_MSC' => 1,
      'origin_of_LSC' => 1952063 + 5 - 365 * 1020,
      'epoch_in_CE'   => 31,
      'rule_table'    => {
        'T' => {'Rule'  =>[365]},
        365 => {'Length'=>[30]*12+[5]}
      },
     'note' => 'Zoroastrian'
    }]

    #
    # Qadimi Calendar
    #
    Qadimi =  [CyclicTableBased, {
      'label'   => 'Zoroastrian::Qadimi',
      'indices' => [
         When.Index('ZoroastrianNotes::month::Month', {:unit =>13}),
         When::Coordinates::DefaultDayIndex
       ],
      'origin_of_MSC' => 1,
      'origin_of_LSC' => 1952063,
      'epoch_in_CE'   => 31,
      'rule_table'    => {
        'T' => {'Rule'  =>[365]},
        365 => {'Length'=>[30]*12+[5]}
      },
     'note' => 'Zoroastrian'
    }]

    #
    # Shahanshahi Calendar
    #
    Shahanshahi =  [CyclicTableBased, {
      'label'   => 'Zoroastrian::Shahanshahi',
      'indices' => [
         When.Index('ZoroastrianNotes::month::Month', {:unit =>13}),
         When::Coordinates::DefaultDayIndex
       ],
      'origin_of_MSC' => 1,
      'origin_of_LSC' => 1952063 + 30,
      'epoch_in_CE'   => 31,
      'rule_table'    => {
        'T' => {'Rule'  =>[365]},
        365 => {'Length'=>[30]*12+[5]}
      },
     'note' => 'Zoroastrian'
    }]

    #
    # Fasli Calendar
    #
    Fasli =  [{'Epoch'=>{
                 'ZRE'=>{'origin_of_MSC'=>1737},
                 'YZ' =>{'origin_of_MSC'=>-630}
              }}, Bahai, {
      'label'   => 'Zoroastrian::Fasli',
      'indices' => [
         When.Index('ZoroastrianNotes::month::Month', {:unit =>13}),
         When::Coordinates::DefaultDayIndex
      ],
      'origin_of_MSC' => -630,
      'epoch_in_CE'   =>  0,
      'rule_table'    => {
        365 => {'Length'=>[30] * 12 + [5]},
        366 => {'Length'=>[30] * 12 + [6]}
      },
      'note' => 'Zoroastrian'
    }]
  end
end
