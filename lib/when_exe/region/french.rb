# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  class BasicTypes::M17n

    French = [self, [
      "locale:[=en:, ja=ja:, alias]",
      "names:[French=]",
      "[FrenchRepublican=en:French_Republican_Calendar, フランス共和暦=ja:%%<フランス革命暦>]",

      [self,
        "names:[Month, 月=ja:%%<月_(暦)>]",
        "[Vendémiaire,    ヴァンデミエール=,       葡萄月=]",
        "[Brumaire,       ブリュメール=,           霧月=  ]",
        "[Frimaire,       フリメール=,             霜月=  ]",
        "[Nivôse,         ニヴォーズ=,             雪月=  ]",
        "[Pluviôse,       プリュヴィオーズ=,       雨月=  ]",
        "[Ventôse,        ヴァントーズ=,           風月=  ]",
        "[Germinal,       ジェルミナル=,           芽月=  ]",
        "[Floréal,        フロレアル=,             花月=  ]",
        "[Prairial,       プレリアル=,             牧草月=]",
        "[Messidor,       メスィドール=,           収穫月=]",
        "[Thermidor,      テルミドール=,           熱月=  ]",
        "[Fructidor,      フリュクティドール=,     果実月=]",
        "[Sansculottides, サン・キュロットの休日=, 予備日=]"
      ]
    ]]
  end

  module CalendarTypes

    #
    # French Calendar
    #
    FrenchRepublican =  [YearLengthTableBased, {
      'label'   => 'French::FrenchRepublican',
      'indices' => [
         When.Index('French::Month', {:unit =>13}),
         When::Coordinates::DefaultDayIndex
       ],
       'origin_of_MSC' => -1791,
       'epoch_in_CE'   => +1,
       'cycle_offset'  => Rational(1,2),
       'time_basis'    => '+00:09:20',
       'rule_table'    => {
         365 => {'Length'=>[30] * 12 + [5]},
         366 => {'Length'=>[30] * 12 + [6]}
        }
    }]
  end
end
