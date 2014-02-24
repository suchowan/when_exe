# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  class BasicTypes::M17n

    ShireTerms = [self, [
      "namespace:[en=http://en.wikipedia.org/wiki/, " +
                 "ja=http://ja.wikipedia.org/wiki/, " +
                 "cal=http://en.wikipedia.org/wiki/Middle-earth_calendar]",
      "locale:[=en:, ja=ja:, alias]",
      "names:[ShireTerms]",
      "[Shire=en:The_Lord_of_the_Rings, ホビット庄暦=ja:%%<指輪物語>]",

      [self,
        "names:[Month, 月=ja:%%<月_(暦)>]",
        "[Yule=en:Yule,      ユール祭=          ]",
        "[Afteryule=en:Yule, ユール後月=        ]",
        "[Solmath=cal,       ソマス=            ]",
        "[Rethe=cal,         レセ=              ]",
        "[Astron=cal,        アストロン=        ]",
        "[Thrimidge=cal,     スリミッジ=        ]",
        "[Forelithe=cal,     ライズ前月=        ]",
        "[Lithe=cal,         ライズ祭=          ]",
        "[Afterlithe=cal,    ライズ後月=        ]",
        "[Wedmath=cal,       ウェドマス=        ]",
        "[Halimath=cal,      ハリマス=          ]",
        "[Winterfilth=cal,   ウィンターフィルス=]",
        "[Blotmath=cal,      ブロドマス=        ]",
        "[Foreyule=en:Yule,  ユール前月=        ]"
      ]
    ]]
  end

  module CalendarTypes

    #
    # ホビット庄暦の暦週
    #
    class CalendarNote::ShireWeek < CalendarNote

      NoteObjects = [When::BasicTypes::M17n, [
        "namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/]",
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
            "[Saturday,     土曜日]",
            "[Sunday,       日曜日]",
            "[Monday,       月曜日]",
            "[Tuesday,      火曜日]",
            "[Wednesday,    水曜日]",
            "[Thursday,     木曜日]",
            "[Friday,       金曜日]",
            "[lithe,        中日= ]",
            "[double,       重日= ]"
          ]
        ]
      ]]

      # イベントの標準的な間隔を返す
      # @private
      def _delta(parameter=nil)
        return When::DurationP1W
      end

      # @private
      def lithe_delta(parameter=nil)
        return When::TM::PeriodDuration.new([0,0,7*52+1])
      end

      # 当日または直前の lithe の日
      # @param date [When::TM::TemporalPosition]
      # @param parameter [nil] 未使用
      # @return [When::TM::TemporalPosition]
      #
      def lithe(date, parameter=nil)
        event_name = 'lithe'
        date  = date.frame.jul_trans(date, {:events=>[event_name]})
        y,m,d = date.cal_date
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
      #   @param date [When::TM::TemporalPosition]
      #   @param parameter [nil] 未使用
      #   @return [When::TM::TemporalPosition]
      #   @note week_day は saturday, sunday, monday, tuesday, wednesday, thursday, friday に読み替えてください。

      # @private
      7.times do |k|
        name = When.CalendarNote('ShireWeek/NoteObjects::day::Week')[k].to_s.downcase
        module_eval %Q{
          def #{name}(date, parameter=nil)
            event_name = 'from_#{name}'
            date  = date.frame.jul_trans(date, {:events=>[event_name], :precision=>When::DAY})
            y,m,d = date.cal_date
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

          alias :#{name}_delta :_delta
        }
      end

      alias :week :saturday

      # Enumeratorの生成
      #
      # @param [When::TM::TemporalPosition] first 始点
      # @param [Symbol] direction
      #   [ :forward - 昇順 ]
      #   [ :reverse - 降順 ]
      # @param [String] event イベント名
      # @param [Integer] count_limit 繰り返し回数(デフォルトは指定なし)
      #
      # @return [When::CalendarTypes::ShireWeek::Enumerator]
      #
      def enum_for(first, direction=:forward, event=@event, count_limit=nil)
        Enumerator.new(self, first, direction, event, count_limit)
      end
      alias :to_enum :enum_for

      # オブジェクトの正規化
      # @private
      def _normalize(args=[], options={})
        @event ||= 'saturday'
        super
      end

      #
      # イベントを取得する Enumerator
      #
      class Enumerator < CalendarNote::Enumerator

        #
        # 次のイベントを得る
        #
        # @return [When::TM::TemporalPosition]
        #
        def succ
          value = @current
          plus  = @delta.sign > 0
          if @current==:first
            @first   = event_eval(@first) unless plus
            @current = @first
          else
            if plus
              @current = event_eval(@current + @delta)
            else
              @last    = event_eval(@current - When.Duration('P1D'))
              @current = event_eval(@current + @delta)
              unless [@current.to_i, value.to_i].include?(@last.to_i) 
                @current = @last
                return value
              end
            end
            @current = event_eval(@current + @delta * 2) if @current.to_i == value.to_i
          end
          return value
        end
      end
    end

    #
    # Shire Calendar based on summer solstice date
    #
    Shire =  [YearLengthTableBased, {
      'label'   => When.Resource('_m:ShireTerms::Shire'),
      'indices' => [
         Coordinates::Index.new({:unit=>14, :trunk=>When.Resource('_m:ShireTerms::Month::*')}),
         Coordinates::DefaultDayIndex
       ],
      'border'       => '00-01-02',
      'day_offset'   => -183,           # the day 183 days before summer solstice
      'cycle_offset' => Rational(1,4),  # summer solstice
      'time_basis'   => '+09:00',       # JST
      'rule_table'   => {
        365 => {'Length'=>[2]+[30]*6+[3]+[30]*6},
        366 => {'Length'=>[2]+[30]*6+[4]+[30]*6}
      },
      'note'   => 'ShireWeek'
    }]

    #
    # Shire Calendar based on Gregorian Date
    #
    ShireG =  [CyclicTableBased, {
      'label'   => When.Resource('_m:ShireTerms::Shire'),
      'origin_of_LSC' => 1721060-10,
      'indices' => [
        Coordinates::Index.new({:unit=>14, :trunk=>When.Resource('_m:ShireTerms::Month::*')}),
        Coordinates::DefaultDayIndex
      ],
      'border'     => '00-01-02',
      'rule_table' => {
        'T'  => {'Rule'  =>['LC', 'SC', 'SC', 'SC']},
        'SC' => {'Rule'  =>[365]*4 + [366, 365, 365, 365]*24},
        'LC' => {'Rule'  =>[366, 365, 365, 365]*25},
        365 => {'Length'=>[2]+[30]*6+[3]+[30]*6},
        366 => {'Length'=>[2]+[30]*6+[4]+[30]*6}
      },
      'note'   => 'ShireWeek'
    }]
  end
end
