# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2017 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  class BasicTypes::M17n

    SaudiArabia = [self, [
      "locale:[=en:, ja=ja:, zh=zh:, alias]",
      "names:[SaudiArabia=en:Saudi_Arabia, サウジアラビア, 沙特阿拉伯]",
      "[UmmalquraSolar=http://www.staff.science.uu.nl/~gent0113/islam/ummalqura_solar.htm, サウジアラビア太陽暦=, 沙特阿拉伯太陽曆, era:AH=]",

      [self,
        "locale:[=en:, ja=ja:, alias=en:]",
        "names:[month name named after the zodiac=, 黄道十二宮にちなむ月名=, zh:對應於黃道十二宮月份名稱=, *alias:SolarMonth=]",
        "[al-Mīzān=,     天秤宮,     Libra      ]",
        "[al-ʿAqrab=,    天蝎宮,     Scorpio    ]",
        "[al-Qaws=,      人馬宮,     Sagittarius]",
        "[al-Jady=,      磨羯宮,     Capricorn  ]",
        "[al-Dalw=,      宝瓶宮,     Aquarius   ]",
        "[al-Ḥūt=,       双魚宮,     Pisces     ]",
        "[al-Ḥamal=,     白羊宮,     Aries      ]",
        "[al-Thawr=,     金牛宮,     Taurus     ]",
        "[al-Jawzāʾ=,    双児宮,     Gemini     ]",
        "[al-Saraṭān=,   巨蟹宮,     Cancer     ]",
        "[al-Asad=,      獅子宮,     Leo        ]",
        "[al-Sunbula=,   処女宮,     Virgo      ]"
      ],

    ]]
  end

  module CalendarTypes

    #
    # Ummalqura Solar Calendar
    #
    UmmalquraSolar = [SolarYearTableBased, {
      'label'   =>  'SaudiArabia::UmmalquraSolar',
      'origin_of_MSC' => -621,
      'diff_to_CE'    =>    0,
      'engine_month'  =>    9,
      'engine_day'    =>   23,
      'indices' => [
        When.Index('SaudiArabia::SolarMonth', {:unit=>12}),
        When::Coordinates::DefaultDayIndex
      ],
      'rule_table'    => {
        365 => {'Length'=> [30]*5 + [29] + [31]*6},
        366 => {'Length'=> [30]*6        + [31]*6}
      }
    }]
  end
end
