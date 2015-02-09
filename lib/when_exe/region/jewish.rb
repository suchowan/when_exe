# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2015 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  class BasicTypes::M17n

    Jewish = [self, [
      "locale:[=en:, ja=ja:, zh=zh:, alias]",
      "names:[Jewish=en:Hebrew_calendar, ユダヤ暦, 希伯來曆]",

      [self,
        "names:[IntercalaryMonth=en:Intercalation, 閏月]",
        "[%s I=,  第１=, 第一=]",
        "[%s II=, 第２=, 第二=]",
      ],

      [self,
        "names:[Month, 月=ja:%%<月_(暦)>]",
        "[Tishrei,  ティシュリー=,   提斯利月]",
        "[Cheshvan, マルヘシュバン=, 瑪西班月]",
        "[Kislev,   キスレーヴ=,     基斯流月]",
        "[Tevet,    テベット=,       提別月  ]",
        "[Shevat,   シュバット=,     細罷特月]",
        "[Adar,     アダル,          亞達月  ]",
        "[Nisan,    ニサン=,         尼散月  ]",
        "[Iyar,     イヤール=,       以珥月  ]",
        "[Sivan,    シバン=,         西彎月  ]",
        "[Tammuz,   タムーズ=,       搭模斯月]",
        "[Av,       アブ=,           埃波月  ]",
        "[Elul,     エルール=,       以祿月  ]"
      ]
    ]]
  end

  class TM::CalendarEra

    #
    # Anno Mundi epoch
    #
    Jewish = [self, [
      "locale:[=en:, ja=ja:, alias]",
      "area:[Israel, イスラエル]",
      ["[AnnoMundi=en:Anno_Mundi, ユダヤ紀元, *alias:HY]1.1.1", '@CE', "01-01-01^Jewish"],
    ]]
  end

  module CalendarTypes

    #
    # Jewish Calendar
    #
    class Jewish < TableBased

      include Lunar

      private

      # オブジェクトの正規化
      def _normalize(args=[], options={})
        @label = 'Jewish'

        # Default Parameters
        Rational
        @epoch_in_CE   ||= -3760
        @origin_of_MSC ||=  3761
        @origin_of_LSC ||= 1721300 + Rational(  9415,  98496)
        @mean_month    ||=      29 + Rational(261307, 492480)
        @leap_period   ||=   19
        @leap_number   ||=    7
        @leap_base     ||=    1

        # Derived Parameters
        @no_leap_number  = @leap_period - @leap_number
        @date_shift      = @mean_month  / @leap_period
        @mean_year       = 12 * @mean_month  + @leap_number * @date_shift

        # Month & Day Index
        @indices ||= [
          When.Index('Jewish::Month', {:branch=>{-1=>When.Resource('_m:Jewish::IntercalaryMonth::*')[0],
                                                  1=>When.Resource('_m:Jewish::IntercalaryMonth::*')[1]}}),
          When::Coordinates::DefaultDayIndex
        ]

        # Month & Day Arrangement
        @rule_table ||= {
          353 => {'Length'=>[30,29,29,29]    + [30,29]*4, 'IDs'=>'1,2,3,4,5,6,7,8,9,10,11,12'   },
          354 => {'Length'=>[30,29,30,29]    + [30,29]*4, 'IDs'=>'1,2,3,4,5,6,7,8,9,10,11,12'   },
          355 => {'Length'=>[30,30,30,29]    + [30,29]*4, 'IDs'=>'1,2,3,4,5,6,7,8,9,10,11,12'   },
          383 => {'Length'=>[30,29,29,29,30] + [30,29]*4, 'IDs'=>'1,2,3,4,5,6*,6=,7,8,9,10,11,12'},
          384 => {'Length'=>[30,29,30,29,30] + [30,29]*4, 'IDs'=>'1,2,3,4,5,6*,6=,7,8,9,10,11,12'},
          385 => {'Length'=>[30,30,30,29,30] + [30,29]*4, 'IDs'=>'1,2,3,4,5,6*,6=,7,8,9,10,11,12'}
        }

        super
      end

      # 年初の通日
      #
      # @param [Array<Numeric>] date ( 年 )
      #
      # @return [Integer] 年初の通日
      #
      def _sdn_(date)
        y      = +date[0]
        g      = (((y + @leap_base) % @leap_period) * @no_leap_number) % @leap_period
        sdn, f = (y * @mean_year  + g * @date_shift + @origin_of_LSC).divmod(1)

        case sdn % 7
        when 2,4,6 # Wed, Fri, Sun
          sdn += 1
        when 0     # Mon
          sdn += 1 if ((f >= Rational(23269, 25920)) && (g > 11))
        when 1     # Tue
          sdn += 2 if ((f >= Rational( 1367,  2160)) && (g >  6))
        else       # Thu, Sat
        end
        return sdn
      end
    end

    #
    # Hebrew Calendar (alias of Jewish Calendar)
    #
    Hebrew = Jewish
  end
end
