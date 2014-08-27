# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When

  class BasicTypes::M17n

    InternationalFixed = [self, [
      "locale:[=en:, ja=ja:, alias]",
      "names:[InternationalFixed=]",
      "[InternationalFixed=en:International_Fixed_Calendar, 国際固定暦]"
    ]]
  end

  #
  # InternationalFixed Week
  #
  class CalendarNote::InternationalFixedWeek < CalendarNote::Week

    #
    # InternationalFixed Note
    #
    Notes = [When::BasicTypes::M17n, [
      "locale:[=en:, ja=ja:, alias]",
      "names:[InternationalFixed]",

      # Notes for year ----------------------------
      [When::BasicTypes::M17n,
        "names:[year]"
      ],

      # Notes for month ----------------------------
      [When::BasicTypes::M17n,
        "names:[month]",
        [When::BasicTypes::M17n,
          "names:[Month]",
          "[January,   1月, /date/month_names/1] ",
          "[February,  2月, /date/month_names/2] ",
          "[March,     3月, /date/month_names/3] ",
          "[April,     4月, /date/month_names/4] ",
          "[May,       5月, /date/month_names/5] ",
          "[June,      6月, /date/month_names/6] ",
          "[Sol,       7月                     ] ",
          "[July,      8月, /date/month_names/7] ",
          "[August,    9月, /date/month_names/8] ",
          "[September,10月, /date/month_names/9] ",
          "[October,  11月, /date/month_names/10]",
          "[November, 12月, /date/month_names/11]",
          "[December, 13月, /date/month_names/12]"
        ]
      ],

      # Notes for day ----------------------------
      [When::BasicTypes::M17n,
        "names:[day]",
        [When::BasicTypes::M17n,
          "names:[Week]",
          [DayOfWeek, "label:[Sunday,    日曜日 ]", {'delta'=>  7}],
          [DayOfWeek, "label:[Monday,    月曜日 ]", {'delta'=>  7}],
          [DayOfWeek, "label:[Tuesday,   火曜日 ]", {'delta'=>  7}],
          [DayOfWeek, "label:[Wednesday, 水曜日 ]", {'delta'=>  7}],
          [DayOfWeek, "label:[Thursday,  木曜日 ]", {'delta'=>  7}],
          [DayOfWeek, "label:[Friday,    金曜日 ]", {'delta'=>  7}],
          [DayOfWeek, "label:[Saturday,  土曜日 ]", {'delta'=>  7}],
          [DayOfWeek, "label:[OutOfWeek=,週外日=]", {'delta'=>197}]
        ],

        "[Common_Week]"
      ]
    ]]

    # Week_day of just or before specified day
    # @method week_day(date, parameter=nil)
    #   @param [When::TM::TemporalPosition] date
    #   @param [nil] parameter not used
    #   @return [When::TM::TemporalPosition]
    #   @note Please replace week_day to sunday, monday, tuesday, wednesday, thursday, friday, saturday

    # @private
    7.times do |k|
      name = When.CalendarNote('InternationalFixedWeek/Notes::day::Week')[k].to_s.downcase
      module_eval %Q{
        def #{name}(date, parameter=nil)
          event_name = 'from_#{name}'
          date  = When::InternationalFixed.jul_trans(date, {:events=>[event_name], :precision=>When::DAY})
          y,m,d = date.cal_date
          dow   = d <= 28 ? (d-1) % 7 : d - 22
          return date if dow == 0
          date -= When::TM::PeriodDuration.new([0,0,dow])
          date.events = [event_name]
          date
        end
      }
    end

    #
    # What day is it the specified date?
    #
    # @param [When::TM::TemporalPosition] date
    # @param [When::TM::CalDate] base
    #
    # @return [Hash<:value=>When::CalendarNote::Week::DayOfWeek, :position=>Array<Integer>>]
    #
    def week(date, base=nil)
      date    = _to_date_for_note(date)
      y, m, d = date.cal_date
      index   = d <= 28 ? (d-1) % 7 : d - 22
      length  = (base||date).length(When::MONTH) - 21
      {:value=>@days_of_week[index], :position=>[index, length]}
    end

    #
    # convert any date to InternationalFixed calendar date
    #
    # @private
    def _to_date_for_note(date)
      date = When::InternationalFixed ^ date unless date.frame.equal?(When::InternationalFixed)
      date
    end

    private

    # Normalization fo object
    # @private
    def _normalize(args=[], options={})
      @event ||= 'sunday'
      super
    end
  end

  module CalendarTypes
    #
    # InternationalFixed calendar based on Gregorian calendar
    #
    InternationalFixed =  [YearLengthTableBased, {
      'label'   => 'InternationalFixed::InternationalFixed',
      'indices' => [
          When.Index('InternationalFixedWeekNotes::month::Month', {:unit =>13}),
         When::Coordinates::DefaultDayIndex
        ],
      'rule_table'       => {
        365  => {'Length'=>[28]*12 + [29]},
        366  => {'Length'=>[28]* 5 + [29] + [28] *6 + [29]}
      },
      'note'   => 'InternationalFixedWeek'
    }]
  end
end
