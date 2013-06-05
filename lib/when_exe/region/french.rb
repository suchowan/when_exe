# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  class BasicTypes::M17n

    FrenchTerms = [self, [
      "namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/]",
      "locale:[=en:, ja=ja:, alias]",
      "names:[FrenchTerms]",

      [self,
        "names:[Month, 月=ja:%E6%9C%88_(%E6%9A%A6)]",
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

  class TM::CalendarEra

    # フランス共和暦
     French = [self, [
      "namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/]",
      "locale:[=en:, ja=ja:, alias]",
      "period:[FrenchRepublican=en:French_Republican_Calendar, フランス共和暦=ja:%E3%83%95%E3%83%A9%E3%83%B3%E3%82%B9%E5%85%B1%E5%92%8C%E6%9A%A6]",
      ["[FRE=en:French_Republican_Calendar, 共和暦=ja:%E3%83%95%E3%83%A9%E3%83%B3%E3%82%B9%E5%85%B1%E5%92%8C%E6%9A%A6, alias:Republican_Era]1.1.1",
       "Calendar Epoch", "1793-01-01^FrenchRepublican", "1806-04-11"],
    ]]
  end

  module CalendarTypes

    #
    # French Calendar
    #
    FrenchRepublican =  [YearLengthTableBased, {
      'indices' => [
         When::Coordinates::Index.new({:unit =>13, :trunk=>When.Resource('_m:FrenchTerms::Month::*')}),
         When::Coordinates::Index.new
       ],
       'origin_of_MSC' => +1,
       'cycle_offset'  => Rational(1,2),
       'timezone'      => (2 + Rational(20,60)) / 15,
       'rule_table'    => {
         365 => {'Length'=>[30] * 12 + [5]},
         366 => {'Length'=>[30] * 12 + [6]}
        }
    }]
  end
end
