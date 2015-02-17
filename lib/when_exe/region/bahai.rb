# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2013-2015 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  class BasicTypes::M17n

    Bahai = [self, [
      "locale:[=en:, ja=ja:, zh=zh:]",
      "names:[Bahai=en:Bah%C3%A1%27%C3%AD_calendar, バハーイー暦=ja:%%<バハーイー教>, 巴哈伊曆=zh:%%<巴哈伊曆法>]",

      # %0s は“閏”の表記を抑制する指定となっている
      [self,
        "locale:[=en:, ar=ar:, alias=en:]",
        "names:[month name=en:Month, ja:月の名前=ja:%%<月_(暦)>, zh:該月的名稱=, *alias:Month=]",
        "[Bahá=,      بهاء=,    Splendour=  ]", #  1
        "[Jalál=,     جلال=,    Glory=      ]", #  2
        "[Jamál=,     جمال=,    Beauty=     ]", #  3
        "[‘Aẓamat=,  عظمة=,    Grandeur=   ]", #  4
        "[Núr=,       نور=,     Light=      ]", #  5
        "[Raḥmat=,    رحمة=,    Mercy=      ]", #  6
        "[Kalimát=,   كلمات=,   Words=      ]", #  7
        "[Kamál=,     كمال=,    Perfection= ]", #  8
        "[Asmá’=,    اسماء=,   Names=      ]", #  9
        "[‘Izzat=,   عزة=,     Might=      ]", # 10
        "[Mashíyyat=, عزة=,     Will=       ]", # 11
        "[‘Ilm=,     علم=,     Knowledge=  ]", # 12
        "[Qudrat=,    قدرة=,    Power=      ]", # 13
        "[Qawl=,      قول=,     Speech=     ]", # 14
        "[Masá’il=,  مسائل=,   Questions=  ]", # 15
        "[Sharaf=,    شرف=,     Honour=     ]", # 16
        "[Sulṭán=,    سلطان=,   Sovereignty=]", # 17
        "[Mulk=,      ملك=,     Dominion=   ]", # 18
        "[‘Alá’=,   علاء=,    Loftiness=  ]", # 19
        "[%0sAyyám-i-Há=en:Ayy%C3%A1m-i-H%C3%A1, %0sايام الهاء=, %0sThe Days of Há=]" # Intercalary days
      ]
    ]]
  end

  class CalendarNote
    Bahai = [['Bahai::YearName'], ['_m:Bahai::Month'], ['Common::Week']]
  end

  module Coordinates

    # Bahai years
    Bahai = [When::BasicTypes::M17n, [
      "locale:[=en:, ar=ar:, alias=en:]",
      "names:[Bahá'í Faith, بهائية, ja:バハーイー教, *alias:Bahai=]",

      [Residue,
        "label:[year name=, ja:年の名前=, zh:該年的名稱=, *alias:YearName=]",
        "divisor:19", "year:1", "format:[%1$s(%3$d)=, (%3$d)%1$s=]",
        [Residue, "label:[Alif=,   ألف=,   A=            ]", "remainder:  0"],
        [Residue, "label:[Bá=,     باء=,   B=            ]", "remainder:  1"],
        [Residue, "label:[Ab=,     أب=,    Father=       ]", "remainder:  2"],
        [Residue, "label:[Dál=,    دﺍﻝ=,   D=            ]", "remainder:  3"],
        [Residue, "label:[Báb=,    باب=,   Gate=         ]", "remainder:  4"],
        [Residue, "label:[Váv=,    وﺍو=,   V=            ]", "remainder:  5"],
        [Residue, "label:[Abad=,   أبد=,   Eternity=     ]", "remainder:  6"],
        [Residue, "label:[Jád=,    جاد=,   Generosity=   ]", "remainder:  7"],
        [Residue, "label:[Bahá'=,  بهاء=,  Splendour=    ]", "remainder:  8"],
        [Residue, "label:[Ḥubb=,   حب=,    Love=         ]", "remainder:  9"],
        [Residue, "label:[Bahháj=, بهاج=,  Delightful=   ]", "remainder: 10"],
        [Residue, "label:[Javáb=,  جواب=,  Answer=       ]", "remainder: 11"],
        [Residue, "label:[Aḥad=,   احد=,   Single=       ]", "remainder: 12"],
        [Residue, "label:[Vahháb=, بهاء=,  Bountiful=    ]", "remainder: 13"],
        [Residue, "label:[Vidád=,  وداد=,  Affection=    ]", "remainder: 14"],
        [Residue, "label:[Badí‘=, بدیع=,  Beginning=    ]", "remainder: 15"],
        [Residue, "label:[Bahí=,   بهي=,   Luminous=     ]", "remainder: 16"],
        [Residue, "label:[Abhá=,   ابهى=,  Most Luminous=]", "remainder: 17"],
        [Residue, "label:[Váḥid=,  واحد=,  Unity=        ]", "remainder: 18"]
      ]
    ]]
  end

  module CalendarTypes

    _ID      = '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,18=,19'
    _Indices = [
      When.Index({:unit =>19}),
      When.Index({:unit =>19}),
      When.Index('Bahai::Month', {:branch=>{+1=>When.Resource('_m:Bahai::Month::*')[19]}}),
      When::Coordinates::DefaultDayIndex
    ]

    #
    # Bahá'í Calendar
    #
    Bahai = [SolarYearTableBasedWithSunset, {
      'label'           => 'Bahai',
      'indices'         => _Indices,
      'origin_of_MSC'   => -1844 + 19*19,
      'diff_to_CE'      =>  0,
      'engine_month'    =>  3,
      'engine_day'      => 21,
      'rule_table'      => {
        365 => {'Length'=>[19] * 18 + [4, 19], 'IDs'=>_ID},
        366 => {'Length'=>[19] * 18 + [5, 19], 'IDs'=>_ID}
      },
      'note' => 'Bahai'
    }]
  end
end
