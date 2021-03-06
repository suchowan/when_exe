# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2021 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When

  class BasicTypes::M17n

    World = [self, [
      "locale:[=en:, ja=ja:, zh=zh:, alias]",
      "names:[World=en:The_World_Calendar, 世界暦, 世界曆]"
    ]]
  end

  #
  # 世界暦の暦週
  #
  class CalendarNote::WorldWeek < CalendarNote::Week

    #
    # 暦注要素の定義
    #
    Notes = [When::BasicTypes::M17n, [
      "locale:[=en:, ja=ja:, alias]",
      "names:[World, 世界暦]",

      # 年の暦注 ----------------------------
      [When::BasicTypes::M17n,
        "names:[note for year=, 年の暦注=, *year]"
      ],

      # 月の暦注 ----------------------------
      [When::BasicTypes::M17n,
        "names:[note for month=, 月の暦注=, *month]",
        [When::BasicTypes::M17n,
          "names:[month name=en:Month, 月の名前=ja:%%<月_(暦)>, zh:該月的名稱=, *alias:Month=]"
        ]
      ],

      # 日の暦注 ----------------------------
      [When::BasicTypes::M17n,
        "names:[note for day=, 日の暦注=, *day]",
        [When::BasicTypes::M17n,
          "names:[Week, 週, zh:星期]",
          [DayOfWeek, "label:[Sunday,     日曜日, /date/day_names/0]", {'delta'=>7}],
          [DayOfWeek, "label:[Monday,     月曜日, /date/day_names/1]", {'delta'=>7}],
          [DayOfWeek, "label:[Tuesday,    火曜日, /date/day_names/2]", {'delta'=>7}],
          [DayOfWeek, "label:[Wednesday,  水曜日, /date/day_names/3]", {'delta'=>7}],
          [DayOfWeek, "label:[Thursday,   木曜日, /date/day_names/4]", {'delta'=>7}],
          [DayOfWeek, "label:[Friday,     金曜日, /date/day_names/5]", {'delta'=>7}],
          [DayOfWeek, "label:[Saturday,   土曜日, /date/day_names/6]", {'delta'=>7}],
          [DayOfWeek, "label:[Worldsday=en:The_World_Calendar#Features, 週外日=]", {'delta'=>366}],
        ],

        "[Common_Week=]"
      ]
    ]]

    # @private
    FirstDayOfWeek = [0, 3, 5] * 4

    # @private
    ExtraDayInYear = {
      [ 6, 31] => 7,
      [12, 31] => 7
    }

    # @private
    WeekLength = {
      [ 5, 31] => 8,
      [ 6, 31] => 8,
      [11, 31] => 8,
      [12, 31] => 8
    }

    # 当日または直前の worldsday の日
    # @param [When::TM::TemporalPosition] date
    # @param [nil] parameter 未使用
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
    #   @param [When::TM::TemporalPosition] date
    #   @param [nil] parameter 未使用
    #   @return [When::TM::TemporalPosition]
    #   @note week_day は sunday, monday, tuesday, wednesday, thursday, friday, saturday に読み替えてください。

    # @private
    7.times do |k|
      name = When.CalendarNote('WorldWeek/Notes::day::Week')[k].to_s.downcase
      module_eval %Q{
        def #{name}(date, parameter=nil)
          event_name = 'from_#{name}'
          date  = When.Calendar('World').jul_trans(date, {:events=>[event_name], :precision=>When::DAY})
          y,m,d = date.cal_date
          dow   = (m % 6 == 0 && d == 31) ? 7-#{k} : ([4,6,2][m % 3] + d - #{k}) % 7
          return date if dow == 0
          dow  += 1 if d <= dow && (m == 1 || m == 7 && When.Calendar('World')._sum([y]) == 366)
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
    # @param [When::TM::CalDate] base
    #
    # @return [Hash<:value=>When::CalendarNote::Week::DayOfWeek, :position=>Array<Integer>>]
    #
    def week(date, base=nil)
      date    = _to_date_for_note(date)
      y, m, d = date.cal_date
      index   = ExtraDayInYear[[m,d]] || (FirstDayOfWeek[m-1] + d - 1) % 7
      length  = WeekLength[[m, (base||date).length(When::MONTH)]] || 7
      {:value=>@days_of_week[index], :position=>[index, length]}
    end

    #
    # 暦日を当該暦注計算用クラスに変換
    #
    # @private
    def _to_date_for_note(date)
      date = When::World ^ date unless date.frame.equal?(When::World)
      date
    end

    private

    # オブジェクトの正規化
    # @private
    def _normalize(args=[], options={})
      @event ||= 'sunday'
      super
    end
  end

  module CalendarTypes
    #
    # World calendar based on Gregorian calendar
    #
    World =  [SolarYearTableBased, {
      'label'   => 'World',
      'rule_table'       => {
        365  => {'Length'=>[31,30,30] * 3 + [31,30,31]},
        366  => {'Length'=>[31,30,30,31,30,31] * 2}
      },
      'note'   => 'WorldWeek'
    }]
  end
end
