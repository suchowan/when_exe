# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When

  class BasicTypes::M17n

    Discordian = [self, [
      "locale:[=en:, ja]",
      "names:[Discordian=en:Discordian_calendar, ディスコーディアン暦=]",
      [self,
        "names:[IntercalaryDay=en:Intercalation, 閏日=ja:%%<閏>]",
        "[%0sSt. Tib's Day=, %0s閏日=]"
      ]
    ]]
  end

  #
  # Discordian Note
  #
  class CalendarNote::DiscordianWeek < CalendarNote::Week

    Notes = [When::BasicTypes::M17n, [
      "namespace:[en=http://en.wiktionary.org/wiki/]",
      "locale:[=en:]",
      "names:[Discordian]",

      # Notes for year ----------------------------
      [When::BasicTypes::M17n,
        "names:[year]"
      ],

      # Notes for month ----------------------------
      [When::BasicTypes::M17n,
        "names:[month]",
        [When::BasicTypes::M17n,
          "names:[Month]",
          "[Chaos=en:chaos            ]",
          "[Discord=en:discord        ]",
          "[Confusion=en:confusion    ]",
          "[Bureaucracy               ]",
          "[The Aftermath=en:aftermath]"
        ]
      ],

      # Notes for day ----------------------------
      [When::BasicTypes::M17n,
        "names:[day]",
        [When::BasicTypes::M17n,
          "names:[Week]",
          [DayOfWeek, "label:[Sweetmorn=      ]", {'delta'=>5}],
          [DayOfWeek, "label:[Boomtime=       ]", {'delta'=>5}],
          [DayOfWeek, "label:[Pungenday=      ]", {'delta'=>5}],
          [DayOfWeek, "label:[Prickle-Prickle=]", {'delta'=>5}],
          [DayOfWeek, "label:[Setting Orange= ]", {'delta'=>5}],
          [DayOfWeek, "label:[Out of Week=    ]", {'delta'=>1461}]
        ],

        [When::BasicTypes::M17n,
          "names:[Holyday=]",
          "[St. Tib's Day=]", # 02-29 St. Tib's Day
          "[Mungday=      ]", # 01-05 Chaos 5
          "[Chaoflux=     ]", # 02-19 Chaos 50
          "[Mojoday=      ]", # 03-19 Discord 5
          "[Discoflux=    ]", # 05-03 Discord 50
          "[Syaday=       ]", # 05-31 Confusion 5
          "[Confuflux=    ]", # 07-15 Confusion 50
          "[Zaraday=      ]", # 08-12 Bureaucracy 5
          "[Bureflux=     ]", # 09-26 Bureaucracy 50
          "[Maladay=      ]", # 10-24 The Aftermath 5
          "[Afflux=       ]"  # 12-08 The Aftermath 50
        ],

        "[Common_Week]"
      ]
    ]]

    # @private
    IndexOfWeek = [0, 1, 2, 3, 5, 4]

    # Just or last sweetmorn
    #
    # @param [When::TM::TemporalPosition] date
    # @param [nil] parameter (not used)
    #
    # @return [When::TM::TemporalPosition]
    #
    def sweetmorn(date, parameter=nil)
      date  = _to_date_for_note(date)
      y,m,d = date.cal_date
      date -= When::P1D if date.length(When::MONTH) == 74 && +d == 60
      dow   = ((m-1)*73+d*1-1) % 5
      date -= When::P1D * dow unless dow == 0
      date.events = [@days_of_week[0]]
      date
    end

    # Erisian week
    #
    # @param [When::TM::CalDate] date
    # @param [When::TM::CalDate] base
    #
    # @return [String]
    #
    def week(date, base=nil)
      date   = _to_date_for_note(date)
      y,m,d  = date.cal_date
      dow    = d*0 == 0 ? ((m-1)*73+d*1-1) % 5 : 5
      length = (base || date).length(When::MONTH) == 73 ? 5 : 6
      index  = length == 5 ? dow : IndexOfWeek[dow]
      {:value=>@days_of_week[dow], :position=>[index,length]}
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
      date.length(When::MONTH) == 73 ?
        @days_of_week.child[0...5] :
        @days_of_week.child[0...4] + [@days_of_week.child[5]] + [@days_of_week.child[4]]
    end

    #  Holyday
    #
    # @param [When::TM::CalDate] date
    #
    # @return [String]
    #
    def holyday(date)
      date    = _to_date_for_note(date)
      y, m, d = date.cal_date
      index =
        case +d
        when  5 ;  1
        when 50 ;  2
        else    ;  d * 0 - 1
        end
      return nil if index == -1
      When.CalendarNote('DiscordianWeek/Notes::day::Holyday::*')[(m-1)*2+index]
    end

    #
    # convert date to Discordian date
    #
    # @private
    def _to_date_for_note(date)
      date = When::Discordian ^ date unless date.frame.label.to_s == 'Discordian'
      date
    end

    private

    # object normalization
    #
    # @private
    def _normalize(args=[], options={})
      @event ||= 'sweetmorn'
      super
    end
  end

  module CalendarTypes

    #
    # Discordian Calendar
    #
    class Discordian < SolarYearTableBased

      # @private
      Normal_IDS = (1..73).to_a

      # @private
      Long_IDS   = (1..59).to_a + [When.Pair(59,1)] + (60..73).to_a

      private

      #
      # Object Normalization
      #
      def _normalize(args=[], options={})
        @label         ||= 'Discordian'
        @indices       ||= [
          When.Index('DiscordianWeekNotes::month::Month', {:unit =>5}),
          When.Index({:branch=>{1=>When.M17n('Discordian::IntercalaryDay')[0]}})
        ]
        @origin_of_MSC ||= +1166
        @diff_to_CE    ||=     0
        @note          ||= 'DiscordianWeek'
        @rule_table ||= {
          365 => {'Length'=>        [73]*5},
          366 => {'Length'=> [74] + [73]*4}
        }
        super
      end

      #
      # day arrangement pattern
      #
      def _ids_(date)
        y, m = date
        case m
        when nil ; super
        when 0   ; @engine._length([+y, 1]) == 28 ?  Normal_IDS : Long_IDS
        else     ; Normal_IDS
        end
      end
    end
  end
end
