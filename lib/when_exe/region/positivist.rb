# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When

  class BasicTypes::M17n

    Positivist = [self, [
      "locale:[=en:, ja=ja:, alias]",
      "names:[Positivist=]",
      "[Positivist=en:Positivist_calendar, オーギュスト・コントの暦]"
    ]]
  end

  #
  # Positivist Week
  #
  class CalendarNote::PositivistWeek < CalendarNote::Week

    #
    # Positivist Note
    #
    Notes = [When::BasicTypes::M17n, [
      "locale:[=en:, ja=ja:, alias]",
      "names:[Positivist]",

      # Notes for year ----------------------------
      [When::BasicTypes::M17n,
        "names:[year]"
      ],

      # Notes for month ----------------------------
      [When::BasicTypes::M17n,
        "names:[month]",
        [When::BasicTypes::M17n,
          "names:[Month]",
          "[Moses,                                      モーセ                                              ]",
          "[Homer,                                      ホメーロス                                          ]",
          "[Aristotle,                                  アリストテレス                                      ]",
          "[Archimedes,                                 アルキメデス                                        ]",
          "[Caesar=en:Julius_Caesar,                    カエサル=ja:%%<ガイウス・ユリウス・カエサル>        ]",
          "[Saint Paul=en:Paul_of_Tarsus,               パウロ                                              ]",
          "[Charlemagne,                                シャルルマーニュ=ja:%%<カール大帝>                  ]",
          "[Dante=en:Dante_Alighieri,                   ダンテ=ja:%%<ダンテ・アリギエーリ>                  ]",
          "[Gutenberg=en:Johann_Gutenberg,              グーテンベルク=ja:%%<ヨハネス・グーテンベルク>      ]",
          "[Shakespeare=en:William_Shakespeare,         シェイクスピア=ja:%%<ウィリアム・シェイクスピア>    ]",
          "[Descartes=en:%%<René_Descartes>,            デカルト=ja:%%<ルネ・デカルト>                      ]",
          "[Frederick=en:Frederick_II_of_Prussia,       フリードリヒ=ja:%%<フリードリヒ2世 (プロイセン王)>  ]",
          "[Bichat=en:%%<Marie_François_Xavier Bichat>, ビシャ=ja:%%<マリー・フランソワ・クサヴィエ・ビシャ>]"
        ]
      ],

      # Notes for day ----------------------------
      [When::BasicTypes::M17n,
        "names:[day]",
        [When::BasicTypes::M17n,
          "names:[Week]",
          [DayOfWeek, "label:[Monday,                   月曜日   ]", {'delta'=>  7}],
          [DayOfWeek, "label:[Tuesday,                  火曜日   ]", {'delta'=>  7}],
          [DayOfWeek, "label:[Wednesday,                水曜日   ]", {'delta'=>  7}],
          [DayOfWeek, "label:[Thursday,                 木曜日   ]", {'delta'=>  7}],
          [DayOfWeek, "label:[Friday,                   金曜日   ]", {'delta'=>  7}],
          [DayOfWeek, "label:[Saturday,                 土曜日   ]", {'delta'=>  7}],
          [DayOfWeek, "label:[Sunday,                   日曜日   ]", {'delta'=>  7}],
          [DayOfWeek, "label:[Festival_of_the_Dead ,    祖先の祭=]", {'delta'=>365}],
          [DayOfWeek, "label:[Festival_of_Holy_Women= , 聖女の祭=]", {'delta'=>365}]
        ],

        "[Common_Week]"
      ]
    ]]

    # Week_day of just or before specified day
    # @method week_day(date, parameter=nil)
    #   @param [When::TM::TemporalPosition] date
    #   @param [nil] parameter not used
    #   @return [When::TM::TemporalPosition]
    #   @note Please replace week_day to monday, tuesday, wednesday, thursday, friday, saturday, sunday

    # @private
    7.times do |k|
      name = When.CalendarNote('PositivistWeek/Notes::day::Week')[k].to_s.downcase
      module_eval %Q{
        def #{name}(date, parameter=nil)
          event_name = 'from_#{name}'
          date  = When::Positivist.jul_trans(date, {:events=>[event_name], :precision=>When::DAY})
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
    # convert any date to Positivist calendar date
    #
    # @private
    def _to_date_for_note(date)
      date = When::Positivist ^ date unless date.frame.equal?(When::Positivist)
      date
    end

    private

    # Normalization fo object
    # @private
    def _normalize(args=[], options={})
      @event ||= 'monday'
      super
    end
  end

  module CalendarTypes
    #
    # Positivist calendar based on Gregorian calendar
    #
    Positivist =  [YearLengthTableBased, {
      'label'   => 'Positivist::Positivist',
      'indices' => [
          When.Index('PositivistWeekNotes::month::Month', {:unit =>13}),
         When::Coordinates::DefaultDayIndex
        ],
      'origin_of_MSC'    => -1788,
      'diff_to_CE'       =>     0,
      'rule_table'       => {
        365  => {'Length'=>[28]*12 + [29]},
        366  => {'Length'=>[28]*12 + [30]}
      },
      'note'   => 'PositivistWeek'
    }]
  end
end
