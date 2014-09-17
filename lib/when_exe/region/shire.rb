# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  class BasicTypes::M17n

    Shire = [self, [
      "namespace:[cal=http://en.wikipedia.org/wiki/Middle-earth_calendar#]",
      "locale:[=en:, ja=ja:, alias]",
      "names:[Shire=]",
      "[Shire=en:The_Lord_of_the_Rings, ホビット庄暦=ja:%%<指輪物語>]",

      [self,
        "names:[Festival=,                 祭=                ]",
        "[%0sYule=en:Yule,                 %0sユール祭=       ]",
        "[%0sLithe=cal:Hobbit_calendar,    %0sライズ祭=       ]",
      ],

      [self,
        "names:[Month, 月=ja:%%<月_(暦)>]",
        "[Yule=en:Yule,                    ユール祭=          ]",
        "[Afteryule=en:Yule,               ユール後月=        ]",
        "[Solmath=cal:Hobbit_calendar,     ソマス=            ]",
        "[Rethe=cal:Hobbit_calendar,       レセ=              ]",
        "[Astron=cal:Hobbit_calendar,      アストロン=        ]",
        "[Thrimidge=cal:Hobbit_calendar,   スリミッジ=        ]",
        "[Forelithe=cal:Hobbit_calendar,   ライズ前月=        ]",
        "[Afterlithe=cal:Hobbit_calendar,  ライズ後月=        ]",
        "[Wedmath=cal:Hobbit_calendar,     ウェドマス=        ]",
        "[Halimath=cal:Hobbit_calendar,    ハリマス=          ]",
        "[Winterfilth=cal:Hobbit_calendar, ウィンターフィルス=]",
        "[Blotmath=cal:Hobbit_calendar,    ブロドマス=        ]",
        "[Foreyule=en:Yule,                ユール前月=        ]"
      ]
    ]]
  end

  #
  # ホビット庄暦の暦週
  #
  class CalendarNote::ShireWeek < CalendarNote::Week

    Notes = [When::BasicTypes::M17n, [
      "locale:[=en:, ja=ja:, alias]",
      "names:[Shire]",

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
          [DayOfWeek, "label:[Saturday,     土曜日]", {'delta'=>7}],
          [DayOfWeek, "label:[Sunday,       日曜日]", {'delta'=>7}],
          [DayOfWeek, "label:[Monday,       月曜日]", {'delta'=>7}],
          [DayOfWeek, "label:[Tuesday,      火曜日]", {'delta'=>7}],
          [DayOfWeek, "label:[Wednesday,    水曜日]", {'delta'=>7}],
          [DayOfWeek, "label:[Thursday,     木曜日]", {'delta'=>7}],
          [DayOfWeek, "label:[Friday,       金曜日]", {'delta'=>7}],
          [DayOfWeek, "label:[lithe,        中日= ]", {'delta'=> 365}],
          [DayOfWeek, "label:[double,       重日= ]", {'delta'=>1827}]
        ],

        "[Common_Week]"
      ]
    ]]

    # @private
    FirstDayOfWeek  = [6, 1, 3, 5, 0, 2, 4] * 2

    # @private
    ExtraDayInYear = {
      [ 8, 2] => 7,
      [ 8, 4] => 0
    }

    # @private
    WeekLength = {
      [ 8, 3] => 8,
      [ 8, 4] => 9
    }

    # 当日または直前の lithe の日
    # @param date [When::TM::TemporalPosition]
    # @param parameter [nil] 未使用
    # @return [When::TM::TemporalPosition]
    #
    def lithe(date, parameter=nil)
      event_name = 'lithe'
      date  = date.frame.jul_trans(date, {:events=>[event_name]})
      y,m,d = date.cal_date
      m = date.frame.send(:_to_index,[y,m]) + 1
      h,n   = (m+5).divmod(7)
      dow   = 182 * h[0] + 30 * n + d + 1
      if m==8
        case d
        when 2 ; dow = 0
        when 3 ; dow = date.frame._sum([y]) == 365 ? 1 : 0
        when 4 ; dow = 1
        end
      end
      return date if dow == 0
      date += When::TM::PeriodDuration.new([0,0,-dow])
      date.events = [event_name]
      date
    end

    # 当日または直前の week_day の日
    # @method week_day(date, parameter=nil)
    #   @param [When::TM::TemporalPosition] date
    #   @param [nil] parameter 未使用
    #   @return [When::TM::TemporalPosition]
    #   @note week_day は saturday, sunday, monday, tuesday, wednesday, thursday, friday に読み替えてください。

    # @private
    7.times do |k|
      name = When.CalendarNote('ShireWeek/Notes::day::Week')[k].to_s.downcase
      module_eval %Q{
        def #{name}(date, parameter=nil)
          event_name = 'from_#{name}'
          date  = date.frame.jul_trans(date, {:events=>[event_name], :precision=>When::DAY})
          y,m,d = date.cal_date
          m = date.frame.send(:_to_index, [y,m]) + 1
          h,n   = (m+5).divmod(7)
          dow   = (182 * h[0] + 30 * n + d - #{k}) % 7
          case m
          when 8
            case d
            when 2 ; dow = 7 - #{k}
            when 3 ; dow = (date.frame._sum([y]) == 365 && #{k} == 0) ? 0 : 8 - #{k}
            when 4 ; dow = #{k} == 0 ? 0 : 9 - #{k}
            end
          when 9
            dow += (date.frame._sum([y]) == 365) ? 1 : 2 if d < #{k}
          end
          return date if dow == 0
          date += When::TM::PeriodDuration.new([0,0,-dow])
          date.events = [event_name]
          date
        end
      }
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
      date    = _to_date_for_note(date)
      y, m, d = date.cal_date
      m = date.frame.send(:_to_index, [y,m]) + 1
      length  = WeekLength[[m, date.length(When::MONTH)]] || 7
      index   = length == 8 ? 0 : 8 if [m,d] == [8,3]
      index ||= ExtraDayInYear[[m,d]] || (FirstDayOfWeek[m-1] + d - 1) % 7
      {:value=>@days_of_week[index], :position=>[index, length]}
    end

    #
    # 暦日を当該暦注計算用クラスに変換
    #
    # @private
    def _to_date_for_note(date)
      date = When::Shire ^ date unless date.frame.label.to_s == 'Shire'
      date
    end

    # オブジェクトの正規化
    # @private
    def _normalize(args=[], options={})
      @event ||= 'saturday'
      super
    end
  end

  module CalendarTypes

    _shire_indices = [
      When.Index('Shire::Month', {:base  => 0,
                                  :branch=>{1=>When.Resource('_m:Shire::Festival::*')[1]}}),
      When::Coordinates::DefaultDayIndex
    ]

    _IDs = '0,1,2,3,4,5,6,6=,7,8,9,10,11,12'

    #
    # Shire Calendar based on summer solstice date
    #
    Shire =  [SolarYearTableBased, {
      'label'   => 'Shire::Shire',
      'indices' => _shire_indices,
      'border'       => '00-00-02',
      'engine_day'   =>   -9,           # Jun 1st is 01-09
      'day_offset'   => -183,           # the day 183 days before summer solstice
      'cycle_offset' => Rational(1,4),  # summer solstice
    # 'time_basis'   => '+09:00',       # JST
      'rule_table'   => {
        365 => {'Length'=>[2]+[30]*6+[3]+[30]*6, 'IDs'=>_IDs},
        366 => {'Length'=>[2]+[30]*6+[4]+[30]*6, 'IDs'=>_IDs}
      },
      'note'   => 'ShireWeek'
    }]
  end
end
