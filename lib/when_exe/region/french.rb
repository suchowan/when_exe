# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2015 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  class BasicTypes::M17n

    French = [self, [
      "locale:[=en:, ja=ja:, zh=zh:, alias]",
      "names:[French=]",
      "[FrenchRepublican=en:French_Republican_Calendar,              フランス共和暦=ja:%%<フランス革命暦>,              法國共和曆]",
      "[FrenchRepublican (Romme)=en:French_Republican_Calendar,      フランス共和暦 (Romme)=ja:%%<フランス革命暦>,      法國共和曆 (Romme)=zh:%%<法國共和曆>]",
      "[FrenchRepublican (Continuous)=en:French_Republican_Calendar, フランス共和暦 (Continuous)=ja:%%<フランス革命暦>, 法國共和曆 (Continuous)=zh:%%<法國共和曆>]",
      "[FrenchRepublican (128)=en:French_Republican_Calendar,        フランス共和暦 (128)=ja:%%<フランス革命暦>,        法國共和曆 (128)=zh:%%<法國共和曆>]",

      [self,
        "names:[Month, 月=ja:%%<月_(暦)>]",
        "[Vendémiaire,    ヴァンデミエール=,       霞月, 葡萄月=]",
        "[Brumaire,       ブリュメール=,           霧月, 霧月=  ]",
        "[Frimaire,       フリメール=,             霜月, 霜月=  ]",
        "[Nivôse,         ニヴォーズ=,             雪月, 雪月=  ]",
        "[Pluviôse,       プリュヴィオーズ=,       雨月, 雨月=  ]",
        "[Ventôse,        ヴァントーズ=,           風月, 風月=  ]",
        "[Germinal,       ジェルミナル=,           芽月, 芽月=  ]",
        "[Floréal,        フロレアル=,             花月, 花月=  ]",
        "[Prairial,       プレリアル=,             牧月, 牧草月=]",
        "[Messidor,       メスィドール=,           獲月, 収穫月=]",
        "[Thermidor,      テルミドール=,           熱月, 熱月=  ]",
        "[Fructidor,      フリュクティドール=,     菓月, 果実月=]",
        "[Sansculottides, サン・キュロットの休日=, 其他日子=, 予備日=]"
      ]
    ]]
  end

  module CalendarTypes

    _rule_table400 = {
      'T'  => {'Rule'  =>(16...416).to_a.map {|y|
        y % 400 == 0 ? 366 :
        y % 100 == 0 ? 365 :
        y %   4 == 0 ? 366 :
                       365
      }},
      365 => {'Length'=>[30] * 12 + [5]},
      366 => {'Length'=>[30] * 12 + [6]}
    }

    _rule_table128 = {
      'T'  => {'Rule'  =>(20...148).to_a.map {|y|
        y % 128 == 0 ? 365 :
        y %   4 == 0 ? 366 :
                       365
      }},
      365 => {'Length'=>[30] * 12 + [5]},
      366 => {'Length'=>[30] * 12 + [6]}
    }

    #
    # French Calendar
    #
    FrenchRepublican = [SolarYearTableBased, {
      'label'   => 'French::FrenchRepublican',
      'indices' => [
         When.Index('French::Month', {:unit =>13}),
         When::Coordinates::DefaultDayIndex
       ],
       'origin_of_MSC' => -1791,
       'epoch_in_CE'   => +1792,
       'cycle_offset'  => Rational(1,2),
       'time_basis'    => '+00:09:20',
       'rule_table'    => {
         365 => {'Length'=>[30] * 12 + [5]},
         366 => {'Length'=>[30] * 12 + [6]}
       }
    }]

    #
    # FrenchRepublicanRomme
    #
    FrenchRepublicanRomme = [CyclicTableBased, {
      'label'   => 'French::FrenchRepublican (Romme)',
      'origin_of_LSC' => 2381318,
      'origin_of_MSC' => 16,
      'before'        => 'FrenchRepublican',
      'indices' => [
         When.Index('French::Month', {:unit =>13}),
         When::Coordinates::DefaultDayIndex
       ],
      'rule_table'    => _rule_table400
    }]

    #
    # FrenchRepublicanContinuous
    #
    FrenchRepublicanContinuous = [CyclicTableBased, {
      'label'   => 'French::FrenchRepublican (Continuous)',
      'origin_of_LSC' => 2380953,
      'origin_of_MSC' => 15,
      'before'        => 'FrenchRepublican',
      'indices' => [
         When.Index('French::Month', {:unit =>13}),
         When::Coordinates::DefaultDayIndex
       ],
      'rule_table'    => _rule_table400
    }]

    #
    # FrenchRepublicanTropical
    #
    FrenchRepublicanTropical = [CyclicTableBased, {
      'label'   => 'French::FrenchRepublican (128)',
      'origin_of_LSC' => 2382779,
      'origin_of_MSC' => 20,
      'before'        => 'FrenchRepublican',
      'indices' => [
         When.Index('French::Month', {:unit =>13}),
         When::Coordinates::DefaultDayIndex
       ],
      'rule_table'    => _rule_table128
    }]

  end
end
