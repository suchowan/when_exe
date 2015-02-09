# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2013-2015 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When

  class BasicTypes::M17n

    Martian = [self, [
      "locale:[=en:, ja=ja:, zh=zh:, alias]",
      "names:[Martian=]",
      "[Darian=en:Darian_calendar, ダリアン暦, 大流士火星曆]",

      [self,
        "names:[DarianMonth=, 月=ja:%%<月_(暦)>]",
        "[Sagittarius, いて=    ]",
        "[Dhanus=,     人馬=    ]",
        "[Capricornus, やぎ=    ]",
        "[Makara=,     磨羯=    ]",
        "[Aquarius,    みずがめ=]",
        "[Kumbha=,     宝瓶=    ]",
        "[Pisces,      うお=    ]",
        "[Mina=,       双魚=    ]",
        "[Aries,       おひつじ=]",
        "[Mesha=,      白羊=    ]",
        "[Taurus,      おうし=  ]",
        "[Rishabha=,   金牛=    ]",
        "[Gemini,      ふたご=  ]",
        "[Mithuna=,    双児=    ]",
        "[Cancer,      かに=    ]",
        "[Karka=,      巨蟹=    ]",
        "[Leo,         しし=    ]",
        "[Simha=,      獅子=    ]",
        "[Virgo,       おとめ=  ]",
        "[Kanya=,      処女=    ]",
        "[Libra,       てんびん=]",
        "[Tula=,       天秤=    ]",
        "[Scorpius,    さそり=  ]",
        "[Vrishika=,   天蠍=    ]"
      ]
    ]]
  end

  module TimeStandard

    #
    #  Martian Time, Coordinated
    #
    class MartianTimeCoordinated < TimeStandard

      J2000Jan6 = 2451549.5
      Ratio     = 1.02749125
      MTC0      = 44796.0 - 0.0002 - 0.5

      # 当該時刻系の日付を dynamical date に変換する
      #
      # @param [Numeric] date 当該時刻系の日付
      #
      # @return [Numeric] dynamical date
      #
      def to_dynamical_date(date)
        (date - @mtc0) * Ratio + J2000Jan6
      end

      # dynamical date を当該時刻系の日付に変換する
      #
      # @param [Numeric] date dynamical date
      #
      # @return [Numeric] 当該時刻系の日付
      #
      def from_dynamical_date(date)
        (date - J2000Jan6) / Ratio + @mtc0
      end

      # universal time を dynamical time に変換する
      #
      # @param [Numeric] time universal time
      #
      # @return [Numeric] dynamical time
      #
      def to_dynamical_time(time)
        When::TM::JulianDate._d_to_t(
          to_dynamical_date(
            When::TM::JulianDate._t_to_d(time)))
      end

      # dynamical time を universal time に変換する
      #
      # @param [Numeric] time dynamical time
      #
      # @return [Numeric] universal time
      #
      def from_dynamical_time(time)
        When::TM::JulianDate._d_to_t(
          from_dynamical_date(
            When::TM::JulianDate._t_to_d(time)))
      end

      private

      # オブジェクトの正規化
      def _normalize(args=[], options={})
        @location = When.Resource(@location || '_l:long=0&lat=0&datum=Mars')
        @mtc0     = MTC0 + @location.long / (360.0 * When::Coordinates::Spatial::DEGREE)
        super
      end
    end
  end

  class CalendarNote

    #
    # Darian Week
    #
    class DarianWeek < WorldWeek

      Notes = [When::BasicTypes::M17n, [
        "locale:[=en:, ja=ja:, alias]",
        "names:[Darian]",

        # 年の暦注 ----------------------------
        [When::BasicTypes::M17n,
          "names:[year]"
        ],

        # 月の暦注 ----------------------------
        [When::BasicTypes::M17n,
          "names:[month]",
          [When::BasicTypes::M17n,
            "names:[Month]"
          ]
        ],

        # 日の暦注 ----------------------------
        [When::BasicTypes::M17n,
          "names:[day]",
          [When::BasicTypes::M17n,
            "names:[Week]",
            [DayOfWeek, "label:[Solis=,    日曜日]", {'delta'=>7}],
            [DayOfWeek, "label:[Lunae=,    月曜日]", {'delta'=>7}],
            [DayOfWeek, "label:[Martis=,   火曜日]", {'delta'=>7}],
            [DayOfWeek, "label:[Mercurii=, 水曜日]", {'delta'=>7}],
            [DayOfWeek, "label:[Jovis=,    木曜日]", {'delta'=>7}],
            [DayOfWeek, "label:[Veneris=,  金曜日]", {'delta'=>7}],
            [DayOfWeek, "label:[Saturni=,  土曜日]", {'delta'=>7}]
          ]
        ]
      ]]

      #
      # 当日または直前の solis の日
      #
      # @param date [When::TM::TemporalPosition]
      # @param parameter [nil] 未使用
      #
      # @return [When::TM::TemporalPosition]
      #
      def solis(date, parameter=nil)
        date  = When.Calendar('Darian').jul_trans(date, {:events=>['from_solis']})
        y,m,d = date.cal_date
        dow   = (d-1) % 7
        return date if dow == 0
        date += When::TM::PeriodDuration.new([0,0,-dow])
        date.events = ['from_solis']
        date
      end

      #
      # この日は何曜？
      #
      # @param [When::TM::TemporalPosition] date
      # @param [When::TM::CalDate] base (not used)
      #
      # @return [Hash<:value=>When::CalendarNote::Week::DayOfWeek, :position=>Array<Integer>>]
      #
      def week(date, base=nil)
        date  = _to_date_for_note(date)
        index = (date.cal_date.last - 1) % 7
        {:value=>@days_of_week[index], :position=>[index, 7]}
      end

      #
      # 曜日の名前の一覧
      #
      # @param [When::TM::TemporalPosition] date (ダミー)
      #
      # @return [Array<When::CalendarNote::Week::DayOfWeek>]
      #
      def week_labels(date)
        @days_of_week.child
      end

      #
      # 暦日を当該暦注計算用クラスに変換
      #
      # @private
      def _to_date_for_note(date)
        date = When::Darian ^ date unless date.frame.label.to_s == 'Darian'
        date
      end

      private

      # オブジェクトの正規化
      def _normalize(args=[], options={})
        @event  ||= 'solis'
        super
      end
    end
  end

  module CalendarTypes

    #
    # Martian Time, Coordinated
    #
    class MTC < UTC

      private

      # オブジェクトの正規化
      def _normalize(args=[], options={})
        label  = 'MTC'
        long   = @long||0
        label += "?long=#{long}" unless long.to_f == 0
        @label = m17n(label)
        @time_standard = When.Resource("_t:MartianTimeCoordinated?location=(_l:long=#{long}&datum=Mars)")
        super
      end
    end

    #
    # Darian Calendar
    #
    Darian =  [CyclicTableBased, {
      'label'         => 'Martian::Darian',
      'time_basis'    => 'MTC',
      'origin_of_LSC' =>  -94798,
      'indices' => [
         When.Index('Martian::DarianMonth', {:unit =>24}),
         When::Coordinates::DefaultDayIndex
       ],
      'rule_table' => {
        'T'             => {'Rule' =>['LongCentury', ['ShortCentury', 4]]},
        'LongCentury'   => {'Rule' =>[               ['LongDecade',  10]]},
        'ShortCentury'  => {'Rule' =>['ShortDecade', ['LongDecade',   9]]},
        'LongDecade'    => {'Rule' =>[669] * 2 + [668, 669] * 4 }, 
        'ShortDecade'   => {'Rule' =>            [668, 669] * 5 },
        668  => {'Length'=>[28, 28, 28, 28, 28, 27] * 4           },
        669  => {'Length'=>[28, 28, 28, 28, 28, 27] * 3 + [28] * 6}
      },
      'note'   => 'DarianWeek'
    }]
  end
end
