# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When

  class BasicTypes::M17n

    RomanTerms = [self, [
      "namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/]",
      "locale:[=en:, ja=ja:, alias]",
      "names:[RomanTerms]",

      [self, # ..CE-44 / ..BCE45
        "names:[MonthA, 月=ja:%E6%9C%88_(%E6%9A%A6)]",
        "[Ianuarius,    1月]",
        "[Februarius,   2月]",
        "[Martius,      3月]",
        "[Aprilis,      4月]",
        "[Maius,        5月]",
        "[Iunius,       6月]",
        "[Quintilis,  旧7月]",
        "[Sextilis,   旧8月]",
        "[September,    9月]",
        "[October,     10月]",
        "[November,    11月]",
        "[December,    12月]" 
      ],

      [self, # CE-43..CE-8 / BCE44..BCE9
        "names:[MonthB, 月=ja:%E6%9C%88_(%E6%9A%A6)]",
        "[Ianuarius,    1月]",
        "[Februarius,   2月]",
        "[Martius,      3月]",
        "[Aprilis,      4月]",
        "[Maius,        5月]",
        "[Iunius,       6月]",
        "[Iulius,       7月]",
        "[Sextilis,   旧8月]",
        "[September,    9月]",
        "[October,     10月]",
        "[November,    11月]",
        "[December,    12月]"
      ],

      [self, # CE-7..CE36, CE41.. / BCE8..CE36, CE41..
        "names:[Month, 月=ja:%E6%9C%88_(%E6%9A%A6)]",
        "[Ianuarius,    1月]",
        "[Februarius,   2月]",
        "[Martius,      3月]",
        "[Aprilis,      4月]",
        "[Maius,        5月]",
        "[Iunius,       6月]",
        "[Iulius,       7月]",
        "[Augustus,     8月]",
        "[September,    9月]",
        "[October,     10月]",
        "[November,    11月]",
        "[December,    12月]"
      ],

      [self, # CE37..CE40
        "names:[MonthC, 月=ja:%E6%9C%88_(%E6%9A%A6)]",
        "[Ianuarius,    1月]",
        "[Februarius,   2月]",
        "[Martius,      3月]",
        "[Aprilis,      4月]",
        "[Maius,        5月]",
        "[Iunius,       6月]",
        "[Iulius,       7月]",
        "[Augustus,     8月]",
        "[Germanicus, 新9月]",
        "[October,     10月]",
        "[November,    11月]",
        "[December,    12月]"
      ],

      [self, # Intercalary Months
        "names:[IntercalaryMonth=en:Intercalation, 閏月]",
        "[%0sIntercalaris=en:Roman_calendar#Calendar_of_Numa,"      +
         "閏月%0s=ja:%E3%83%AD%E3%83%BC%E3%83%9E%E6%9A%A6#.E6.9C.AB.E6.9C.9F.E3.81.AE.E3.83.AD.E3.83.BC.E3.83.9E.E6.9A.A6]",
        "[%0sIntercalaris Prior=en:Julian_calendar#Realignment_of_the_year,"     +
         "第１閏月%0s=ja:%E3%83%AD%E3%83%BC%E3%83%9E%E6%9A%A6#.E6.9C.AB.E6.9C.9F.E3.81.AE.E3.83.AD.E3.83.BC.E3.83.9E.E6.9A.A6]",
        "[%0sIntercalaris Posterior=en:Julian_calendar#Realignment_of_the_year," +
         "第２閏月%0s=ja:%E3%83%AD%E3%83%BC%E3%83%9E%E6%9A%A6#.E6.9C.AB.E6.9C.9F.E3.81.AE.E3.83.AD.E3.83.BC.E3.83.9E.E6.9A.A6]",
      ]
    ]]
  end

  class TM::CalendarEra

    # From http://en.wikipedia.org/wiki/Julian_calendar#Sacrobosco.27s_theory_on_month_lengths
    Julian = [self, [
      "namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/]",
      "locale:[=en:, ja=ja:, alias]",
      "period:[Roman=en:Roman_calendar, ローマ暦=ja:%E3%83%AD%E3%83%BC%E3%83%9E%E6%9A%A6]",
      ["[AUC=en:Ab_urbe_condita, 建国紀元=ja:%E3%83%AD%E3%83%BC%E3%83%9E%E5%BB%BA%E5%9B%BD%E7%B4%80%E5%85%83, alias:Ab_urbe_condita]709.1.1",
       "Calendar Epoch", "-44-01-01^JulianA",
                          "-7-03-01^JulianB",
                           "8-01-01^JulianC", "476-09-04"]
    ]]

    # From http://www.tyndalehouse.com/Egypt/ptolemies/chron/roman/chron_rom_intro_fr.htm
    Roman = [self, [
      "namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/]",
      "locale:[=en:, ja=ja:, alias]",
      "period:[Roman=en:Roman_calendar, ローマ暦=ja:%E3%83%AD%E3%83%BC%E3%83%9E%E6%9A%A6]",
      ["[AUC=en:Ab_urbe_condita, 建国紀元=ja:%E3%83%AD%E3%83%BC%E3%83%9E%E5%BB%BA%E5%9B%BD%E7%B4%80%E5%85%83, alias:Ab_urbe_condita]492.5.1",
       "Calendar Epoch", "-261-05-01^RomanA?border=0-5-1",
                         "-221-03-01^RomanA?border=0-3-1",
                         "-152-01-01^RomanA",
                          "-43-01-01^RomanB",
                           "-7-01-01^Roman",
                           "37-01-01^RomanC",
                           "41-01-01^Roman", "476-09-04"]
    ]]

  end

  module CalendarTypes

    # From http://en.wikipedia.org/wiki/Julian_calendar#Sacrobosco.27s_theory_on_month_lengths
    _Index0     = Coordinates::Index.new
    _IndicesB12 = [Coordinates::Index.new({:unit=>12, :trunk=>When.Resource('_m:RomanTerms::MonthB::*')}), _Index0]
    _Indices12  = [Coordinates::Index.new({:unit=>12, :trunk=>When.Resource('_m:RomanTerms::Month::*')}),  _Index0]

    #
    # Julian Calendar A : BCE45-BCE8
    #
    JulianA =  [CyclicTableBased, {
      'origin_of_LSC'  =>  1704987,
      'origin_of_MSC'  =>  -44,
      'indices' => _IndicesB12,
      'rule_table'     => {
        'T' => {'Rule'  =>[365,366,365]},
        365 => {'Length'=>[31,29] + [31,30]*5},
        366 => {'Length'=>[31,30] + [31,30]*5}
      },
      'note' => 'RomanNote'
    }]

    #
    # Julian Calendar B : BCE8-CE7
    #
    JulianB =  [CyclicTableBased, {
      'origin_of_LSC'  =>  1704987+13,
      'origin_of_MSC'  =>  -44,
      'indices' => _IndicesB12,
      'rule_table'     => {
        'T' => {'Rule'  =>[365]},
        365 => {'Length'=>[31,28] + [31,30,31,30,31]*2}
      },
      'note' => 'RomanNote'
    }]

    #
    # Julian Calendar C : CE8-
    #
    JulianC =  [Julian, {
      'indices' => _Indices12,
      'note' => 'RomanNote'
    }]

    # From http://www.tyndalehouse.com/Egypt/ptolemies/chron/roman/chron_rom_intro_fr.htm
    #
    # Roman Calendar BCE262-(CE60)-CE480
    #
    # _ID_N = '1,2,3,4,5,6,7,8,9,10,11,12'
    _ID_L = '1,2,2=,3,4,5,6,7,8,9,10,11,12'
    _ID_J = '1,2,2=,3,4,5,6,7,8,9,10,11,11<,11>,12'
    _Branch = {
        1=>When.Resource('_m:RomanTerms::IntercalaryMonth::*')[0],
      0.5=>When.Resource('_m:RomanTerms::IntercalaryMonth::*')[1],
      1.5=>When.Resource('_m:RomanTerms::IntercalaryMonth::*')[2]
    }
    _IndicesA = [Coordinates::Index.new({:branch=>_Branch, :trunk=>When.Resource('_m:RomanTerms::MonthA::*')}), _Index0]
    _IndicesB = [Coordinates::Index.new({:branch=>_Branch, :trunk=>When.Resource('_m:RomanTerms::MonthB::*')}), _Index0]
    _Indices  = [Coordinates::Index.new({:branch=>_Branch, :trunk=>When.Resource('_m:RomanTerms::Month::*')}),  _Index0]
    _IndicesC = [Coordinates::Index.new({:branch=>_Branch, :trunk=>When.Resource('_m:RomanTerms::MonthC::*')}), _Index0]
    Options = {
      'origin_of_LSC'  =>  1625698,
      'origin_of_MSC'  =>  -261,
      'indices' => _Indices,
      'rule_table'     => {
        'T' => {'Rule' =>      %w(                                                       A C  A B A C A B A C A B
          A C A B A C A B A C  A B A C A B A C A B  A C A B A C A B A C  A B A A C B A A A A  C A A A B A C A A B
          A A A A A A A A A A  C A C A B C A C A B  C A C A C A B C A C  A C A A B C A B C A  B C A B C A C A C A
          C A C A C A C A C A  C A A C A C A C A C  A C A C A C A C A C  A C A C A C A A C A  A C A A C A A C A A
          C A C A C A C A C A  C A C A A C A C A C  A C A C A C A C A C  A C A C A A C A A C  A A C A A B A A C A
          A A A A J N L N N L  N N L N N L N N L N  N L N N L N N L N N  L N N L N N L N N L  N N L N N N N N N N) +
          %w(N N N L) * 120
        },
        'A' => {'Length'=>[29, 28, 31, 29, 31, 29, 31, 29, 29, 31, 29, 29]},
        'B' => {'Length'=>[29, 23, 27, 31, 29, 31, 29, 31, 29, 29, 31, 29, 29],         'IDs'=>_ID_L},
        'C' => {'Length'=>[29, 24, 27, 31, 29, 31, 29, 31, 29, 29, 31, 29, 29],         'IDs'=>_ID_L},
        'J' => {'Length'=>[29, 24, 27, 31, 29, 31, 29, 31, 29, 29, 31, 34, 31, 31, 29], 'IDs'=>_ID_J},
        'N' => {'Length'=>[31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]},
        'L' => {'Length'=>[31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]},
      },
      'note' => 'RomanNote'
    }
    RomanA =  [CyclicTableBased, Options.merge({'indices' => _IndicesA})]
    RomanB =  [CyclicTableBased, Options.merge({'indices' => _IndicesB})]
    Roman  =  [CyclicTableBased, Options]
    RomanC =  [CyclicTableBased, Options.merge({'indices' => _IndicesC})]

    #
    # 古代ローマの暦注
    #
    class CalendarNote::RomanNote < CalendarNote

      NoteObjects = [When::BasicTypes::M17n, [
        "namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/]",
        "locale:[=en:, ja=ja:, alias]",
        "names:[Roman]",

        # 年の暦注 ----------------------------
        [When::BasicTypes::M17n,
          "names:[year]",

          [When::Coordinates::Residue,
            "label:[Solar=en:Solar_cycle_(calendar), 太陽章=]", "divisor:28", "year:-8",
          ],

          [When::Coordinates::Residue,
            "label:[Metonic=en:Metonic_cycle, 太陰章=]", "divisor:19", "year:0",
          ],

          [When::Coordinates::Residue,
            "label:[Indiction, インディクション]", "divisor:15", "year:-2",
            [When::Coordinates::Residue, "label:[I=   ]", "remainder:  0"],
            [When::Coordinates::Residue, "label:[II=  ]", "remainder:  1"],
            [When::Coordinates::Residue, "label:[III= ]", "remainder:  2"],
            [When::Coordinates::Residue, "label:[IV=  ]", "remainder:  3"],
            [When::Coordinates::Residue, "label:[V=   ]", "remainder:  4"],
            [When::Coordinates::Residue, "label:[VI=  ]", "remainder:  5"],
            [When::Coordinates::Residue, "label:[VII= ]", "remainder:  6"],
            [When::Coordinates::Residue, "label:[VIII=]", "remainder:  7"],
            [When::Coordinates::Residue, "label:[IX=  ]", "remainder:  8"],
            [When::Coordinates::Residue, "label:[X=   ]", "remainder:  9"],
            [When::Coordinates::Residue, "label:[XI=  ]", "remainder: 10"],
            [When::Coordinates::Residue, "label:[XII= ]", "remainder: 11"],
            [When::Coordinates::Residue, "label:[XIII=]", "remainder: 12"],
            [When::Coordinates::Residue, "label:[XIV= ]", "remainder: 13"],
            [When::Coordinates::Residue, "label:[XV=  ]", "remainder: 14"],
          ]
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
            "names:[Nomen]"
          ]
        ]
      ]]

      Order = [
        'a.d. bis VI',
        'prid.',    'a.d. III',  'a.d. IV',    'a.d. V',   'a.d. VI',   'a.d. VII', 'a.d. VIII', 
        'a.d. IX',  'a.d. X',    'a.d. XI',    'a.d. XII', 'a.d. XIII', 'a.d. XIV', 'a.d. XV', 
        'a.d. XVI', 'a.d. XVII', 'a.d. XVIII', 'a.d. XIX', 'a.d. XX',   'a.d. XXI', 'a.d. XXII'
      ]

      LongMonths = [3, 5, 7, 10, When.Pair(11,0.5), When.Pair(11,1.5)]
      LongType   = [1, 2..6, 7, 8..14, 15]
      ShortType  = [1, 2..4, 5, 6..12, 13]

      # 暦注 - 日の名前
      #
      # @param [When::TM::CalDate] date
      #
      # @return [String]
      #
      def nomen(date)
        y, m, d = date.cal_date
        month_name = _abbr_of_month(date)
        kal, to_nonae, nonae, to_idus, idus = LongMonths.include?(m) ? LongType : ShortType
        case d
        when kal      ; return                     'Kal. ' + month_name
        when to_nonae ; return Order[nonae - d] + ' Non. ' + month_name
        when nonae    ; return                     'Non. ' + month_name
        when to_idus  ; return Order[idus  - d] + ' Id. '  + month_name
        when idus     ; return                     'Id. '  + month_name
        end
        this_month = date.floor(When::MONTH)
        next_month = this_month.succ
        month_name = _abbr_of_month(next_month)
        rest = next_month.to_i - date.to_i
        if m == 2 && next_month.to_i - this_month.to_i == 29
          return Order[0] + ' Kal. ' + month_name if rest == 5
          rest -= 1 if rest > 5
        end
        return Order[rest] + ' Kal. ' + month_name
      end

      private

      # オブジェクトの正規化
      def _normalize(args=[], options={})
       @event = 'nomen'
       super
      end

      # 日の省略名
      def _abbr_of_month(month)
        name = month.name('month').to_s
        return name.sub(/ (..).*/, ' \1.') if name.sub!(/Intercalaris(.*)?/, 'Int.\1')
        name.size <= 3 ? name : name[/^...[^caeiou]*/] + '.'
      end
    end
  end
end
