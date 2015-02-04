# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014-2015 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

class When::BasicTypes::M17n

  Russian = [self, [
    "locale:[=en:, ja=ja:, alias]",
    "names:[Russia, ロシア]",
    "[Moscow, モスクワ]",
    "[Saint_Petersburg, サンクトペテルブルク]",
    "[Vladivostok, ウラジオストク]"
  ]]
end

class When::CalendarNote

  #
  # 標準の暦注 ＋ 五曜
  #
  CommonWithSovietFiveDay = [['_m:Calendar::Month'], ['Common::Week', '_n:SovietFiveDayWeek/Notes::day::FiveDay']]

  #
  # 標準の暦注 ＋ 六曜
  #
  CommonWithSovietSixDay  = [['_m:Calendar::Month'], ['Common::Week', '_n:SovietSixDayWeek/Notes::day::SixDay']]

  #
  # 五曜
  #
  class SovietFiveDayWeek < Week

    Holidays = {
      [1,22] => 5, [2,29] => 6, [5,1] => 5, [5,2] => 5, [11,7] => 5, [11,8] => 5
    }

    FirstDay = [0, 0, 3, 4, 4, 3, 3, 4, 0, 0, 1, 4]

    SkipDay  = {
      1 => [23,1], 5 => [3,2], 11 => [9,2]
    }


    #
    # 暦注要素の定義
    #
    Notes = [When::BasicTypes::M17n, [
      "locale:[=en:, ja=ja:, alias]",
      "names:[SovietFiveDay]",

      # 日の暦注 ----------------------------
      [When::BasicTypes::M17n,
        "names:[day]",
        [When::BasicTypes::M17n,
          "names:[FiveDay, 五曜]",
          [DayOfWeek, "label:[I=      ]", {'delta'=>5}],
          [DayOfWeek, "label:[II=     ]", {'delta'=>5}],
          [DayOfWeek, "label:[III=    ]", {'delta'=>5}],
          [DayOfWeek, "label:[IV=     ]", {'delta'=>5}],
          [DayOfWeek, "label:[V=      ]", {'delta'=>5}],
          [DayOfWeek, "label:[Holiday=]", {'delta'=>190}],
          [DayOfWeek, "label:[Leapday=]", {'delta'=>1461}]
        ]
      ]
    ]]

    #
    # この日は何曜？
    #
    # @param [When::TM::TemporalPosition] date
    # @param [When::TM::CalDate] base (not used)
    #
    # @return [Hash<:value=>When::CalendarNote::Week::DayOfWeek, :position=>Array<Integer>>]
    #
    def fiveday(date, base=nil)
      date  = _to_date_for_note(date)
      y,m,d = date.cal_date
      index = fiveday_index(m,d)
      {:value=>@days_of_week[index], :position=>[index, 7]}
    end
    alias :week :fiveday

    # @private
    def first(date, base=nil)
      count = 0
      d0 = d1 = _to_date_for_note(date)
      r0 = r1 = nil
      loop do
        y,m,d = d1.cal_date
        r1    = fiveday_index(m,d)
        break if r1 == 0
        d0 = d1
        r0 = r1
        d1 = d0 - When::P1D
        count += 1
      end
      date -= count if count > 0
      date.events = [@days_of_week[r1]]
      date
    end

    # @private
    def fiveday_index(m,d)
      index = Holidays[[m,d]]
      return index if index
      day, shift = SkipDay[m]
      d -= shift if day && d >= day
      (FirstDay[m-1] + d - 1) % 5
    end

    # @private
    def first_delta(parameter=nil)
      When::P5D
    end

    #
    # 暦日をグレゴリオ暦日に変換
    #
    # @private
    def _to_date_for_note(date)
      return date if date.frame.kind_of?(When::CalendarTypes::Gregorian)
      return When::Gregorian ^ date
    end

    private

    # オブジェクトの正規化
    # @private
    def _normalize(args=[], options={})
      @days_of_week ||= When.CalendarNote("SovietFiveDayWeek/Notes::day::FiveDay")
      @event        ||= 'first'
      super
    end
  end

  #
  # 六曜
  #
  class SovietSixDayWeek < Week

    # @private
    #             1 2 3 4 5 6 7 8 9 X N D
    WeekLength = [7,6,7,6,7,6,7,7,6,7,6,7]

    #
    # 暦注要素の定義
    #
    Notes = [When::BasicTypes::M17n, [
      "locale:[=en:, ja=ja:, alias]",
      "names:[SovietSixDay]",

      # 日の暦注 ----------------------------
      [When::BasicTypes::M17n,
        "names:[day]",
        [When::BasicTypes::M17n,
          "names:[SixDay, 六曜]",
          [DayOfWeek, "label:[Первый=      ]", {'delta'=>6}],
          [DayOfWeek, "label:[Второй=      ]", {'delta'=>6}],
          [DayOfWeek, "label:[Третий=      ]", {'delta'=>6}],
          [DayOfWeek, "label:[Четвертый=]", {'delta'=>6}],
          [DayOfWeek, "label:[Пятый=        ]", {'delta'=>6}],
          [DayOfWeek, "label:[Шестой=      ]", {'delta'=>6}],
          [DayOfWeek, "label:[Out of week=       ]", {'delta'=>6}]
        ]
      ]
    ]]

    #
    # この日は何曜？
    #
    # @param [When::TM::TemporalPosition] date
    # @param [When::TM::CalDate] base (not used)
    #
    # @return [Hash<:value=>When::CalendarNote::Week::DayOfWeek, :position=>Array<Integer>>]
    #
    def sixday(date, base=nil)
      date  = _to_date_for_note(date)
      dow   = date.cal_date[When::DAY-1]
      index = dow == 31 ? 6 : (dow - 1) % 6
      {:value=>@days_of_week[index], :position=>[index, WeekLength[(base||date).cal_date[When::MONTH-1]-1]]}
    end
    alias :week :sixday

    # @private
    def first(date, base=nil)
      dow   = _to_date_for_note(date).cal_date[When::DAY-1]
      index = dow == 31 ? 6 : (dow - 1) % 6
      date -= index if index > 0
      date.events = [@days_of_week[index]]
      date
    end

    # @private
    def first_delta(parameter=nil)
      When::P6D
    end

    #
    # 暦日をグレゴリオ暦日に変換
    #
    # @private
    def _to_date_for_note(date)
      return date if date.frame.kind_of?(When::CalendarTypes::Gregorian)
      return When::Gregorian ^ date
    end

    private

    # オブジェクトの正規化
    # @private
    def _normalize(args=[], options={})
      @days_of_week ||= When.CalendarNote("SovietSixDayWeek/Notes::day::SixDay")
      @event        ||= 'first'
      super
    end
  end
end
