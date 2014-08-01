# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When

  class BasicTypes::M17n

    Roman = [self, [
      "locale:[=en:, ja=ja:, alias]",
      "names:[Roman=]",

      # Remarks
      '[based on Chris Bennett "Roman Dates" (Retrieved 2013-05-13)=http://www.tyndalehouse.com/Egypt/ptolemies/chron/roman/chron_rom_intro_fr.htm,' +
       '典拠 - Chris Bennett "Roman Dates" (2013-05-13 閲覧)=]',

      [self, # ..CE-44 / ..BCE45
        "names:[MonthA=en:Month, 月=ja:%%<月_(暦)>]",
        "[Ianuarius,    1月]",
        "[Februarius,   2月]",
        "[Martius,      3月]",
        "[Aprilis,      4月]",
        "[Maius,        5月]",
        "[Iunius,       6月]",
        "[Quintilis,  旧7月=]",
        "[Sextilis,   旧8月=]",
        "[September,    9月]",
        "[October,     10月]",
        "[November,    11月]",
        "[December,    12月]" 
      ],

      [self, # CE-43..CE-8 / BCE44..BCE9
        "names:[MonthB=en:Month, 月=ja:%%<月_(暦)>]",
        "[Ianuarius,    1月]",
        "[Februarius,   2月]",
        "[Martius,      3月]",
        "[Aprilis,      4月]",
        "[Maius,        5月]",
        "[Iunius,       6月]",
        "[Iulius,       7月]",
        "[Sextilis,   旧8月=]",
        "[September,    9月]",
        "[October,     10月]",
        "[November,    11月]",
        "[December,    12月]"
      ],

      [self, # CE-7..CE36, CE41.. / BCE8..CE36, CE41..
        "names:[Month, 月=ja:%%<月_(暦)>]",
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
        "names:[MonthD=en:Month, 月=ja:%%<月_(暦)>]",
        "[Ianuarius,    1月]",
        "[Februarius,   2月]",
        "[Martius,      3月]",
        "[Aprilis,      4月]",
        "[Maius,        5月]",
        "[Iunius,       6月]",
        "[Iulius,       7月]",
        "[Augustus,     8月]",
        "[Germanicus, 新9月=]",
        "[October,     10月]",
        "[November,    11月]",
        "[December,    12月]"
      ],

      # %0s は“閏”の表記を抑制する指定となっている
      [self, # Intercalary Months
        "names:[IntercalaryMonth=en:Intercalation, 閏月]",
        "[%0sIntercalaris=en:Roman_calendar#Calendar_of_Numa,"      +
         "閏月%0s=ja:%%<ローマ暦>#%.<末期のローマ暦>]",
        "[%0sIntercalaris Prior=en:Julian_calendar#Realignment_of_the_year,"     +
         "第１閏月%0s=ja:%%<ローマ暦>#%.<末期のローマ暦>]",
        "[%0sIntercalaris Posterior=en:Julian_calendar#Realignment_of_the_year," +
         "第２閏月%0s=ja:%%<ローマ暦>#%.<末期のローマ暦>]",
      ]
    ]]
  end

  class TM::CalendarEra

    # From http://en.wikipedia.org/wiki/Julian_calendar#Sacrobosco.27s_theory_on_month_lengths
    Julian = [self, [
      "locale:[=en:, ja=ja:, alias]",
      "period:[Roman=en:Roman_calendar, ローマ暦]",
      ["[AUC=en:Ab_urbe_condita, 建国紀元=ja:%%<ローマ建国紀元>, alias:Ab_urbe_condita]709.1.1",
       '@CE', "-44-01-01^JulianA",
               "-7-03-01^JulianB",
                "8-01-01^JulianC", "476-09-04"]
    ]]

    # From Chris Bennett, http://www.tyndalehouse.com/Egypt/ptolemies/chron/roman/chron_rom_intro_fr.htm
    Roman = [self, [
      "locale:[=en:, ja=ja:, alias]",
      "period:[Roman=en:Roman_calendar, ローマ暦]",
      ["[AUC=en:Ab_urbe_condita, 建国紀元=ja:%%<ローマ建国紀元>, alias:Ab_urbe_condita]492.5.1",
       '@CE', "-261-05-01^RomanA?border=0-5-1",
              "-221-03-01^RomanA?border=0-3-1",
              "-152-01-01^RomanA",
               "-43-01-01^RomanB",
                "-7-01-01^RomanC",
                "37-01-01^RomanD",
                "41-01-01^Roman", "476-09-04"]
    ]]

  end

  module CalendarTypes

    # From http://en.wikipedia.org/wiki/Julian_calendar#Sacrobosco.27s_theory_on_month_lengths
    _Index0     = When::Coordinates::DefaultDayIndex
    _IndicesB12 = [When.Index('Roman::MonthB', {:unit=>12}), _Index0]
    _Indices12  = [When.Index('Roman::Month',  {:unit=>12}), _Index0]

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
      'note' => 'Roman'
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
      'note' => 'Roman'
    }]

    #
    # Julian Calendar C : CE8-
    #
    JulianC =  [Julian, {
      'indices' => _Indices12,
      'note'    => 'Roman'
    }]

    # From Chris Bennett, http://www.tyndalehouse.com/Egypt/ptolemies/chron/roman/chron_rom_intro_fr.htm
    #
    # Roman Calendar BCE262-(CE60)-CE480
    #
    # _ID_N = '1,2,3,4,5,6,7,8,9,10,11,12'
    _ID_L = '1,2,2=,3,4,5,6,7,8,9,10,11,12'
    _ID_J = '1,2,2=,3,4,5,6,7,8,9,10,11,11<,11>,12'
    _Branch = {
        1=>When.Resource('_m:Roman::IntercalaryMonth::*')[0],
      0.5=>When.Resource('_m:Roman::IntercalaryMonth::*')[1],
      1.5=>When.Resource('_m:Roman::IntercalaryMonth::*')[2]
    }
    _IndicesA = [When.Index('Roman::MonthA', {:branch=>_Branch}), _Index0]
    _IndicesB = [When.Index('Roman::MonthB', {:branch=>_Branch}), _Index0]
    _Indices  = [When.Index('Roman::Month',  {:branch=>_Branch}), _Index0]
    _IndicesD = [When.Index('Roman::MonthD', {:branch=>_Branch}), _Index0]
    _remarks  = When.M17n('Roman::based on Chris Bennett "Roman Dates" (Retrieved 2013-05-13)')
    # @private
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
      'note' => 'Roman'
    }
    # @private
    RomanA =  [CyclicTableBased, Options.merge({'remarks'=>_remarks, 'indices' => _IndicesA})]
    # @private
    RomanB =  [CyclicTableBased, Options.merge({'remarks'=>_remarks, 'indices' => _IndicesB})]
    # @private
    RomanC =  [CyclicTableBased, Options.merge({'remarks'=>_remarks                        })]
    # @private
    RomanD =  [CyclicTableBased, Options.merge({'remarks'=>_remarks, 'indices' => _IndicesD})]
    # @private
    Roman  =  [CyclicTableBased, Options]
  end

  #
  # 古代ローマの暦注
  #
  class CalendarNote::Roman < CalendarNote

    Notes = [When::BasicTypes::M17n, [
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
          "label:[Indiction, インディクション]", "divisor:15", "year:-2", "format:[%s=]",
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
      name.size <= 3 ? name : name[/\A...[^caeiou]*/] + '.'
    end
  end
end
