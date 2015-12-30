# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2015 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

require 'when_exe/ephemeris/notes'

module  When

  class BasicTypes::M17n

    #
    # 節日の名称
    #
    ChineseLuniSolarHoliday = [self, [
      "locale:[=ja:, en=en:, zh=zh:, alias=ja:]",
      "names:[節日=,          *Holiday=,                歲時節日=]", # 節句など
      "[元日,                 New Year's Day,           春節     ]",
      "[人日,                 Renri,                    人日     ]",
      "[小正月,               First Full Moon Festival, 元宵節   ]",
      "[弥生節句=ja:%%<上巳>, Double Third Festival=,   上巳節   ]",
      "[端午節句=ja:%%<端午>, Double Fifth Festival=,   端午節   ]",
      "[七夕節句=ja:%%<七夕>, Qixi Festival,            七夕     ]",
      "[お盆,                 Bon Festival,             中元節   ]",
      "[田実節句=ja:%%<八朔>, Hassaku=,                 八朔=    ]",
      "[重陽節句,             Double Ninth Festival,    重陽節   ]"
    ]]
  end

  class CalendarNote

    #
    # 暦月の暦注
    #
    class ChineseLuniSolar < self

      #
      # 節日の日付
      #
      Holidays = {
        [1, 1] => When.M17n('ChineseLuniSolarHoliday::元日'),
        [1, 7] => When.M17n('ChineseLuniSolarHoliday::人日'),
        [1,15] => When.M17n('ChineseLuniSolarHoliday::小正月'),
        [3, 3] => When.M17n('ChineseLuniSolarHoliday::弥生節句'),
        [5, 5] => When.M17n('ChineseLuniSolarHoliday::端午節句'),
        [7, 7] => When.M17n('ChineseLuniSolarHoliday::七夕節句'),
        [7,15] => When.M17n('ChineseLuniSolarHoliday::お盆'),
        [8, 1] => When.M17n('ChineseLuniSolarHoliday::田実節句'),
        [9, 9] => When.M17n('ChineseLuniSolarHoliday::重陽節句')
      }

      #
      # 年月日の暦注
      #
      Notes = [When::BasicTypes::M17n, [
        "locale:[=ja:, en=en:, zh=zh:, alias=en:]",
        "names:[暦月の暦注=, LuniSolarNote=]",

        # 年の暦注 ----------------------------
        [When::BasicTypes::M17n,
          "names:[年の暦注=, note for year=, prefix:YearNote=, *alias:year=]",
          [When::BasicTypes::M17n,
            "names:[年の暦注=, note for year=, *alias:Year=]"
          ]
        ],

        # 月の暦注 ----------------------------
        [When::BasicTypes::M17n,
          "names:[月の暦注=, note for month=, prefix:MonthNote=, *alias:month=]",
          [When::BasicTypes::M17n,
            "names:[月の名前=ja:%%<月_(暦)>, month name=en:Month, 該月的名稱=, *alias:Month=]"
          ]
        ],

        # 日の暦注 ----------------------------
        [When::BasicTypes::M17n,
          "names:[日の暦注=, note for day=, prefix:DayNote=, *alias:day]",
           "[週,         *Week,                           星期      ]", # 七曜
           "[干支,       *StemBranch=en:Sexagenary_cycle, 干支      ]", # 六十干支
           "[二十四節気, *SolarTerm=en:Solar_term,        節気=zh:%%<节气>]", # 二十四節気
           "[没=,        *Motsu=,                         没=       ]", # 没
           "[節日=,      *Holiday=,                       歲時節日= ]"  # 節句など
        ]
      ]]

      #
      # 年の干支
      #
      # @param [When::TM::TemporalPosition] date
      # @param [Hash] options dummy
      #
      # @return [When::Coordinates::Residue] 六十干支
      #
      def year(date, options={})
        When.Resource('_co:Common::干支')[(date.most_significant_coordinate-4) % 60]
      end

      #
      # 七曜
      #
      # @param [When::TM::TemporalPosition] date
      # @param [Hash] options dummy
      #
      # @return [When::Coordinates::Residue] 七曜
      #
      def week(date, options={})
        When.Resource('_co:Common::Week')[date.to_i % 7]
      end

      #
      # 日の干支
      #
      # @param [When::TM::TemporalPosition] date
      # @param [Hash] options dummy
      #
      # @return [When::Coordinates::Residue] 六十干支
      #
      def stembranch(date, options={})
        When.Resource('_co:Common::干支')[(date.to_i-11) % 60]
      end

      #
      # 二十四節気
      #
      # @param [When::TM::TemporalPosition] date
      # @param [Hash] options dummy
      #
      # @return [When::Coordinates::Residue] 二十四節気 or nil
      #
      def solarterm(date, options={})
        _day_notes(date, options)['二十四節気']
      end

      #
      # 没
      #
      # @param [When::TM::TemporalPosition] date
      # @param [Hash] options dummy
      #
      # @return [When::BasicTypes::M17n] 没 or nil
      #
      def motsu(date, options={})
        _day_notes(date, options)['没']
      end

      #
      # 節
      #
      # @param [When::TM::TemporalPosition] date
      # @param [Hash] options dummy
      #
      # @return [When::BasicTypes::M17n] 節 or nil
      #
      def holiday(date, options={})
        Holidays[[+date.cal_date[When::MONTH-1], date.cal_date[When::DAY-1]]]
      end

      # オブジェクトの正規化
      def _normalize(args=[], options={})
        @_all_keys  ||= [%w(Year), %w(Month), %w(Week StemBranch SolarTerm Holiday)]
        super
      end

      #
      # 日の暦注
      #
      # @param [When::TM::TemporalPosition] date
      # @param [Hash] options dummy
      #
      # @return [Hash] 暦注名=>暦注値
      #
      def _day_notes(date, options={})
        s_date = When.when?(date.to_cal_date.to_s,
          {:frame=>date.frame,
           :clock=>(date.frame.kind_of?(When::CalendarTypes::EphemerisBasedSolar) || !date.frame.twin ?
              date.frame :
              When.Calendar(date.frame.twin))._time_basis[0]
          })

        # 没
        notes   = {}
        longitude, motsu = SolarTerms.new('formula'=>date.frame.formula[0]).position(s_date)
        if motsu == 0
          notes['没'] = '没' unless date.most_significant_coordinate >= 1685 && date.frame.iri =~ /JapaneseTwin/
          return notes
        end

        # 廿四節気
        div, mod = longitude.divmod(15)
        if mod == 0
          note = (div - 21) % 24
          div, mod = note.divmod(2)
          notes['二十四節気'] ||= 
           When.Resource(date.frame.iri =~ /戊寅|麟徳|儀鳳/ ? '_co:Common?V=0618' : '_co:Common')['二十四節気::*'][(note-3) % 24]
        end
        notes
      end
    end

    #
    # 節月の暦注
    #
    class ChineseSolar < ChineseLuniSolar

      #
      # 年月日の暦注
      #
      Notes = ChineseLuniSolar::Notes

      # オブジェクトの正規化
      def _normalize(args=[], options={})
        @_all_keys  ||= [%w(Year), %w(Month), %w(Week StemBranch SolarTerm Motsu)]
        super
      end
    end
  end
end
