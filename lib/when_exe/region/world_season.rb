# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When

  class BasicTypes::M17n

    WorldSeason = [self, [
      "locale:[=en:, ja=ja:, alias]",
      "names:[WorldSeason=]",
      "[WorldSeason=http://calendars.wikia.com/wiki/World_Season_Calendar, アシモフの季節暦=]"
    ]]
  end

  #
  # WorldSeason Week
  #
  class CalendarNote::WorldSeasonWeek < CalendarNote::Week

    #
    # WorldSeason Note
    #
    Notes = [When::BasicTypes::M17n, [
      "locale:[=en:, ja=ja:, alias]",
      "names:[WorldSeason]",

      # Notes for year ----------------------------
      [When::BasicTypes::M17n,
        "names:[year]"
      ],

      # Notes for month ----------------------------
      [When::BasicTypes::M17n,
        "names:[month]",
        [When::BasicTypes::M17n,
          "names:[Month]",
          "[A=] ",
          "[B=] ",
          "[C=] ",
          "[D=] "
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
          [DayOfWeek, "label:[OutOfWeek=,週外日=]", {'delta'=>366}]
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
      name = When.CalendarNote('WorldSeasonWeek/Notes::day::Week')[k].to_s.downcase
      module_eval %Q{
        def #{name}(date, parameter=nil)
          event_name = 'from_#{name}'
          date  = When::WorldSeason.jul_trans(date, {:events=>[event_name], :precision=>When::DAY})
          y,m,d = date.cal_date
          dow   = d <= 91 ? (d-1) % 7 : d - 85
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
      index   = d <= 91 ? (d-1) % 7 : d - 85
      length  = (base||date).length(When::MONTH) - 84
      {:value=>@days_of_week[index], :position=>[index, length]}
    end

    #
    # convert any date to WorldSeason calendar date
    #
    # @private
    def _to_date_for_note(date)
      date = When::WorldSeason ^ date unless date.frame.equal?(When::WorldSeason)
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
    # WorldSeason calendar based on Gregorian calendar
    #
    WorldSeason =  [YearLengthTableBased, {
      'label'   => 'WorldSeason::WorldSeason',
      'indices' => [
          When.Index('WorldSeasonWeekNotes::month::Month', {:unit =>4}),
         When::Coordinates::DefaultDayIndex
        ],
      'engine_day'       => -11, # 11th day before new year
      'rule_table'       => {
        365  => {'Length'=>[91] * 3 + [92]},
        366  => {'Length'=>[91, 92] * 2}
      },
      'note'   => 'WorldSeasonWeek'
    }]
  end
end
