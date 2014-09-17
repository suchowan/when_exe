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
          [DayOfWeek, "label:[Sunday,     日曜日, /date/day_names/0]", {'delta'=>  7}],
          [DayOfWeek, "label:[Monday,     月曜日, /date/day_names/1]", {'delta'=>  7}],
          [DayOfWeek, "label:[Tuesday,    火曜日, /date/day_names/2]", {'delta'=>  7}],
          [DayOfWeek, "label:[Wednesday,  水曜日, /date/day_names/3]", {'delta'=>  7}],
          [DayOfWeek, "label:[Thursday,   木曜日, /date/day_names/4]", {'delta'=>  7}],
          [DayOfWeek, "label:[Friday,     金曜日, /date/day_names/5]", {'delta'=>  7}],
          [DayOfWeek, "label:[Saturday,   土曜日, /date/day_names/6]", {'delta'=>  7}],
          [DayOfWeek, "label:[OutOfWeek=, 週外日=]", {'delta'=>366}]
        ],

        "[Common_Week=]"
      ]
    ]]

    fixed_week_definitions(7*13)

  end

  module CalendarTypes
    #
    # WorldSeason calendar based on Gregorian calendar
    #
    WorldSeason =  [SolarYearTableBased, {
      'label'   => 'WorldSeason::WorldSeason',
      'indices' => [
          When.Index('WorldSeasonWeekNotes::month::Month', {:unit =>4}),
         When::Coordinates::DefaultDayIndex
        ],
      'engine_day'       => -10, # 11th day before new year
      'rule_table'       => {
        365  => {'Length'=>[91] * 3 + [92]},
        366  => {'Length'=>[91, 92] * 2}
      },
      'note'   => 'WorldSeasonWeek'
    }]
  end
end
