# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When

  class BasicTypes::M17n

    Tranquility = [self, [
      "locale:[=en:, ja=ja:, alias]",
      "names:[Tranquility=]",
      "[Tranquility=en:Tranquility_Calendar, 静かの海の暦=]",

      [self,
        "names:[IntercalaryDay=en:Intercalation, 閏日=ja:%%<閏>]",
        "[%0sAldrin Day=, %0s閏日=]"
      ]
    ]]
  end

  #
  # Tranquility Week
  #
  class CalendarNote::TranquilityWeek < CalendarNote::Week

    #
    # Tranquility Note
    #
    Notes = [When::BasicTypes::M17n, [
      "locale:[=en:, ja=ja:, alias]",
      "names:[Tranquility]",

      # Notes for year ----------------------------
      [When::BasicTypes::M17n,
        "names:[year]"
      ],

      # Notes for month ----------------------------
      [When::BasicTypes::M17n,
        "names:[month]",
        [When::BasicTypes::M17n,
          "names:[Month]",
          "[Archimedes,                        アルキメデス                                         ]",
          "[Brahe=en:Tycho_Brahe,              ブラーエ=ja:%%<ティコ・ブラーエ>                     ]",
          "[Copernicus=en:Nicolaus_Copernicus, コペルニクス=ja:%%<ニコラウス・コペルニクス>         ]",
          "[Darwin=en:Charles_Darwin,          ダーウィン=ja:%%<チャールズ・ダーウィン>             ]",
          "[Einstein=en:Albert_Einstein,       アインシュタイン=ja:%%<アルベルト・アインシュタイン> ]",
          "[Faraday=en:Michael_Faraday,        ファラデー=ja:%%<マイケル・ファラデー>               ]",
          "[Galileo=en:Galileo_Galilei,        ガリレオ=ja:%%<ガリレオ・ガリレイ>                   ]",
          "[Hippocrates,                       ヒポクラテス                                         ]",
          "[Imhotep,                           イムホテプ                                           ]",
          "[Jung=en:Carl_Jung,                 ユング=ja:%%<カール・グスタフ・ユング>               ]",
          "[Kepler=en:Johannes_Kepler,         ケプラー=ja:%%<ヨハネス・ケプラー>                   ]",
          "[Lavoisier=en:Antoine_Lavoisier,    ラヴォアジエ=ja:%%<アントワーヌ・ラヴォアジエ>       ]",
          "[Mendel=en:Gregor_Mendel,           メンデル=ja:%%<グレゴール・ヨハン・メンデル>         ]"
        ]
      ],

      # Notes for day ----------------------------
      [When::BasicTypes::M17n,
        "names:[day]",
        [When::BasicTypes::M17n,
          "names:[Week]",
          [DayOfWeek, "label:[Friday,    金曜日]", {'delta'=>  7}],
          [DayOfWeek, "label:[Saturday,  土曜日]", {'delta'=>  7}],
          [DayOfWeek, "label:[Sunday,    日曜日]", {'delta'=>  7}],
          [DayOfWeek, "label:[Monday,    月曜日]", {'delta'=>  7}],
          [DayOfWeek, "label:[Tuesday,   火曜日]", {'delta'=>  7}],
          [DayOfWeek, "label:[Wednesday, 水曜日]", {'delta'=>  7}],
          [DayOfWeek, "label:[Thursday,  木曜日]", {'delta'=>  7}],
          [DayOfWeek, "label:[Armstrong Day=en:Neil_Armstrong, アームストロングの日=ja:%%<ニール・アームストロング>]", {'delta'=> 365}],
          [DayOfWeek, "label:[Aldrin Day=en:Buzz_Aldrin,       オルドリンの日=ja:%%<バズ・オルドリン>]",               {'delta'=>1461}]
        ],

        "[Common_Week]"
      ]
    ]]

    # @private
    IndexOfWeek = [0, 1, 2, 3, 4, 5, 7, nil, 6]

    # Just or last friday
    #
    # @param [When::TM::TemporalPosition] date
    # @param [nil] parameter (not used)
    #
    # @return [When::TM::TemporalPosition]
    #
    def friday(date, parameter=nil)
      date  = _to_date_for_note(date)
      y,m,d = date.cal_date
      dow   = (+d-1) % 7
      if date.length(When::MONTH) == 29 && +d >= 28
        dow = (m == 8) ? (d*1 == 27 ? 6 : 7) :
                         (d   == 28 ? 6 : 7)
      end
      date -= When::P1D * dow unless dow == 0
      date.events = [@days_of_week[0]]
      date
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
      date   = _to_date_for_note(date)
      y,m,d  = date.cal_date
      dow    = d*0 == 0 ? (d<=28 ? (d-1) % 7 : d-22) : 8
      length = (base||date).length(When::MONTH) - 21
      index  = (length == 7 || m == 13) ? dow : IndexOfWeek[dow]
      {:value=>@days_of_week[dow], :position=>[index, length]}
    end

    #
    # Week labels
    #
    # @param [When::TM::TemporalPosition] date
    #
    # @return [Array<When::CalendarNote::Week::DayOfWeek>]
    #
    def week_labels(date)
      date = _to_date_for_note(date)
      date.length(When::MONTH) == 28 ? @days_of_week.child[0...7] :
      date.month == 13               ? @days_of_week.child[0...8] :
                                       @days_of_week.child[0...6] + [@days_of_week.child[8], @days_of_week.child[6]]
    end

    #
    # convert any date to Tranquility calendar date
    #
    # @private
    def _to_date_for_note(date)
      date = When::Tranquility ^ date unless date.frame.equal?(When::Tranquility)
      date
    end

    private

    # Normalization fo object
    # @private
    def _normalize(args=[], options={})
      @event ||= 'friday'
      super
    end
  end

  module CalendarTypes

    #
    # Tranquility calendar based on Gregorian calendar
    #
    class Tranquility < YearLengthTableBased

      # @private
      Normal_IDS = (1..28).to_a

      # @private
      Long_IDS   = (1..29).to_a

      # @private
      Leap_IDS   = (1..27).to_a + [When.Pair(27,1), 28]

      private

      #
      # Object Normalization
      #
      def _normalize(args=[], options={})
        @label         ||= 'Tranquility::Tranquility'
        @indices       ||= [
          When.Index('TranquilityWeekNotes::month::Month', {:unit =>13}),
          When.Index({:branch=>{1=>When.M17n('Tranquility::IntercalaryDay')[0]}})
        ]
        @origin_of_MSC ||= -1968
        @diff_to_CE    ||=     0
        @engine_month  ||=     6 # July
        @engine_day    ||=    20 # 21st
        @rule_table    ||= {
          365 => {'Length'=>[28]*12 + [29]},
          366 => {'Length'=>[28]*7  + [29] + [28]*4 + [29]}
        }
        @note          ||= 'TranquilityWeek'
        super
      end

      #
      # day arrangement pattern
      #
      def _ids_(date)
        y, m = date
        case m
        when nil ; super
        when 12  ; Long_IDS
        when  7  ; @engine._length([+y-@origin_of_MSC+1,1]) == 28 ?  Normal_IDS : Leap_IDS
        else     ; Normal_IDS
        end
      end
    end
  end
end
