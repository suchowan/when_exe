# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When

  class BasicTypes::M17n

    Discordian = [self, [
      "namespace:[en=http://en.wikipedia.org/wiki/]",
      "locale:[=en:, ja]",
      "names:[Discordian=en:Discordian_calendar, ディスコーディアン暦=]",
      [self,
        "names:[IntercalaryDay=en:Intercalation, 閏日=ja:%%<閏>]",
        "[%0sSt. Tib's Day=, %0s閏日=]"
      ],
    ]]
  end

  #
  # Discordian Note
  #
  class CalendarNote::Discordian < CalendarNote

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
          "names:[Erisian_week=]",
          "[Sweetmorn=         ]",
          "[Boomtime=          ]",
          "[Pungenday=         ]",
          "[Prickle-Prickle=   ]",
          "[Setting Orange=    ]"
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
        ]
      ]
    ]]

    # Erisian week
    #
    # @param [When::TM::CalDate] date
    #
    # @return [String]
    #
    def erisian_week(date)
      y, m, d = date.cal_date
      return nil unless  d * 0 == 0
      When.CalendarNote('Discordian/Notes::day::Erisian_week::*')[((m-1)*73+d*1-1) % 5]
    end

    #  Holyday
    #
    # @param [When::TM::CalDate] date
    #
    # @return [String]
    #
    def holyday(date)
      y, m, d = date.cal_date
      index =
        case d
        when  5 ;  1
        when 50 ;  2
        else    ;  d * 0 - 1
        end
      return nil if index == -1
      When.CalendarNote('Discordian/Notes::day::Holyday::*')[(m-1)*2+index]
    end
  end

  module CalendarTypes

    #
    # Discordian Calendar
    #
    class Discordian < TableBased

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
        @epoch_in_CE   ||= -1166
        @note          ||= 'Discordian'
        @engine        ||= 'Gregorian'
        @engine          = When.Calendar(@engine)
        @indices       ||= [
          When.Index('DiscordianNotes::month::Month', {:unit =>5}),
          When.Index({:branch=>{1=>When.M17n('Discordian::IntercalaryDay')[0]}})
        ]
        @rule_table ||= {
          365 => {'Length'=>        [73]*5},
          366 => {'Length'=> [74] + [73]*4}
        }
        super
      end

      # first day of year
      #
      def _sdn_(date)
        year = +date[0] + @epoch_in_CE
        @engine._coordinates_to_number(year, 0, 0)
      end

      #
      # day arrangement pattern
      #
      def _ids_(date)
        y, m = date
        return super unless m
        return Normal_IDS unless m == 0
        year = +y + @epoch_in_CE
        @engine._length([year,1]) == 28 ?  Normal_IDS : Long_IDS
      end
    end
  end
end
