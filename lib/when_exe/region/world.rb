# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When

  class BasicTypes::M17n

    WorldTerms = [self, [
      "namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/]",
      "locale:[=en:, ja=ja:, alias]",
      "names:[WorldTerms]",
      "[World=en:The_World_Calendar, 世界暦]"
    ]]
  end

  class TM::CalendarEra

    World = [self, [
      "namespace:[en=http://en.wikipedia.org/wiki/]",
      "area:[Common]",
      ["[BCE=en:BCE_(disambiguation), alias:BeforeCommonEra]0.1.1"],
      ["[CE=en:Common_Era, alias:CommonEra]1.1.1", "Calendar Epoch", "01-01-01^World"]
    ]]
  end

  module CalendarTypes

    #
    # 世界暦の暦週
    #
    class CalendarNote::WorldWeek < CalendarNote

      NoteObjects = [When::BasicTypes::M17n, [
        "namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/]",
        "locale:[=en:, ja=ja:, alias]",
        "names:[World]",

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
            "[Sunday,    日曜日]",
            "[Monday,    月曜日]",
            "[Tuesday,   火曜日]",
            "[Wednesday, 水曜日]",
            "[Thursday,  木曜日]",
            "[Friday,    金曜日]",
            "[Saturday,  土曜日]",
            "[Worldsday, 無曜日]"
          ]
        ]
      ]]

      # イベントの標準的な間隔を返す
      # @private
      def _delta(parameter=nil)
        return When::DurationP1W
      end

      # @private
      def worldsday_delta(parameter=nil)
        return When::TM::PeriodDuration.new([0,0,7*26+1])
      end

      # 当日または直前の worldsday の日
      # @param date [When::TM::TemporalPosition]
      # @param parameter [nil] 未使用
      # @return [When::TM::TemporalPosition]
      #
      def worldsday(date, parameter=nil)
        event_name = 'worldsday'
        date  = When.Calendar('World').jul_trans(date, {:events=>event_name})
        y,m,d = date.cal_date
        h, m  = (m-1).divmod(6)
        return date if m == 5 && d == 31
        dow   = [0, 31, 61, 91, 122, 152][m] + d
        dow  += 182 if h == 1 && When.Calendar('World')._sum([y]) == 365
        date += When::TM::PeriodDuration.new([0,0,-dow])
        date.events = [event_name]
        date
      end

      # 当日または直前の week_day の日
      # @method week_day(date, parameter=nil)
      #   @param date [When::TM::TemporalPosition]
      #   @param parameter [nil] 未使用
      #   @return [When::TM::TemporalPosition]
      #   @note week_day は sunday, monday, tuesday, wednesday, thursday, friday, saturday に読み替えてください。

      # @private
      7.times do |k|
        name = When.CalendarNote('WorldWeek/NoteObjects::day::Week')[k].to_s.downcase
        module_eval %Q{
          def #{name}(date, parameter=nil)
            event_name = 'from_#{name}'
            date  = When.Calendar('World').jul_trans(date, {:events=>[event_name]})
            y,m,d = date.cal_date
            dow   = (m % 6 == 0 && d == 31) ? 7-#{k} : ([4,6,2][m % 3] + d - #{k}) % 7
            return date if dow == 0
            dow  += 1 if d <= dow && (m == 1 || m == 7 && When.Calendar('World')._sum([y]) == 366)
            date += When::TM::PeriodDuration.new([0,0,-dow])
            date.events = [event_name]
            date
          end

          alias :#{name}_delta :_delta
        }
      end

      alias :week :sunday

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
      def enum_for(first, direction=:forward, event=nil, count_limit=nil)
        Enumerator.new(self, first, direction, event||@event, count_limit)
      end
      alias :to_enum :enum_for

      # オブジェクトの正規化
      # @private
      def _normalize(args=[], options={})
        @event ||= 'sunday'
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
          if @current==:first
            @first   = event_eval(@first) if @delta.sign < 0
            @current = @first
          else
            @current = event_eval(@current + @delta)
            @current = event_eval(@current + @delta * 2) if @current.to_i == value.to_i
          end
          return value
        end
      end
    end

    #
    # World calendar based on Gregorian calendar
    #
    World =  [CyclicTableBased, {
      'label'   => When.Resource('_m:WorldTerms::World'),
      'origin_of_LSC'  => 1721060,
      'indices' => [
         Coordinates::Index.new({:unit =>12, :trunk=>When.Resource('_m:CalendarTerms::Month::*')}),
         Coordinates::DefaultDayIndex
       ],
      'rule_table'      => {
        'T'  => {'Rule'  =>['LC', 'SC', 'SC', 'SC']},
        'SC' => {'Rule'  =>[365]*4 + [366, 365, 365, 365]*24},
        'LC' => {'Rule'  =>[366, 365, 365, 365]*25},
        365  => {'Length'=>[31,30,30]*3 + [31,30,31]},
        366  => {'Length'=>[31,30,30,31,30,31] *2}
      },
      'note'   => 'WorldWeek'
    }]
  end
end
