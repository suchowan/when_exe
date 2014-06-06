# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2013-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  class BasicTypes::M17n

    Bahai = [self, [
      "namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/, ar=http://ar.wikipedia.org/wiki/]",
      "locale:[=en:, ar=ar:, alias=en:]",
      "names:[Bahai=]",
      "[Bahai=en:Bah%C3%A1%27%C3%AD_calendar, ja:バハーイー暦=ja:%%<バハーイー教>]",

      # %0s は“閏”の表記を抑制する指定となっている
      [self,
        "names:[Month, 月=ja:%%<月_(暦)>]",
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
      "namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/, ar=http://ar.wikipedia.org/wiki/]",
      "locale:[=en:, ar=ar:, alias=en:]",
      "names:[Bahai]",

      [Residue,
        "label:[YearName]", "divisor:19", "year:0", "format:[%1$s(%3$d)=]",
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

    #
    # Bahá'í Calendar
    #
    class Bahai < TableBased

      # 年初の通日 - グレゴリオ暦の３月21日を春分とする
      #
      # @param [Array<Numeric>] date ( 年 )
      #
      # @return [Numeric] 年初の通日
      #
      def gregorian_equinox(date)
        @engine._coordinates_to_number(+date[0], 2, 20)
      end

      # 年初の通日 - 太陽の天文学的な位置による春分に基づく
      #
      # @param [Array<Numeric>] date ( 年 )
      #
      # @return [Numeric] 年初の通日
      #
      def ephemeris_equinox(date)
        equinox_time = @engine.cn_to_time(+date[0])
        equinox_date = (equinox_time + 0.5 + @engine.long/360.0).floor
        sunset_time = @engine.sunset(equinox_date)
        (sunset_time <= equinox_time) ? equinox_date+1 : equinox_date
      end

      private

      ID = '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,18=,19'

      #
      # オブジェクトの正規化
      #
      def _normalize(args=[], options={})
        @label   ||= 'Bahai::Bahai'

        @indices ||= [
          When.Index({:unit =>19}),
          When.Index({:unit =>19}),
          When.Index('Bahai::Month', {:branch=>{+1=>When.Resource('_m:Bahai::Month::*')[19]}}),
          When::Coordinates::DefaultDayIndex
        ]
        @origin_of_MSC ||= -1844 + 19*19
        @rule_table    ||= {
          365 => {'Length'=>[19] * 18 + [4, 19], 'IDs'=>ID},
          366 => {'Length'=>[19] * 18 + [5, 19], 'IDs'=>ID}
        }
        @note ||= 'Bahai'

        super

        @engine ||= @location ?
          When::Ephemeris::Formula.new({:formula=>'1S', :location=>@location}) :
          When::Gregorian

        case @engine
        when When::Ephemeris::Formula; instance_eval('class << self; alias :_sdn_ :ephemeris_equinox; end')
        when When::TM::Calendar      ; instance_eval('class << self; alias :_sdn_ :gregorian_equinox; end')
        else                         ; raise ArgumentError, 'Engine not specified'
        end
      end
    end
  end
end
