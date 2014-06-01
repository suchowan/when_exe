# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

=begin

  References

 (1) http://calendars.wikia.com/wiki/Yerm_Lunar_Calendar
 (2) http://www.hermetic.ch/cal_stud/palmen/yerm1.htm

=end

module When

  class BasicTypes::M17n

    YermTerms = [self, [
      "namespace:[en=http://en.wikipedia.org/wiki/]",
      "locale:[=en:, ja]",
      "names:[YermTerms=]",
      "[YermLunar=http://calendars.wikia.com/wiki/Yerm_Lunar_Calendar, ヤーム]",

      [Coordinates::Residue, "label:[Yerm=]", "divisor:52", "year:0", "format:[%s=]"] +
      (1..52).to_a.map {|y|  [Coordinates::Residue, "label:[Yerm #{y}=]", "remainder:#{y-1}"]},
      [self, "names:[Month]"] + (1..17).to_a.map {|m| "Month #{m}"},
      [self, "names:[Night]"] + (1..30).to_a.map {|m| "Night #{m}"}
    ]]
  end

  class CalendarNote
    YermNotes = [['_m:YermTerms::Yerm'], ['_m:CalendarTerms::Month'], ['CommonResidue::Week']]
  end

  module CalendarTypes

    #
    # Yerm Lunar Calendar
    #
    Yerm =  [CyclicTableBased, {
      'label'         => Parts::Resource._instance('_m:YermTerms::YermLunar'),
      'origin_of_LSC' => 1948379 - 25101,  # 622-05-16 Base Cycle = No.1
      'indices'       => [
        When.Index('Yerm', 'Yerm', {:unit =>52}),
        When.Index('Yerm', 'Month'),
        When.Index('Yerm', 'Night'),
      ],
      'rule_table' => {
        'T' => {'Rule'  =>['L', 'L', 'S'] * 17 + ['L']},
        'L' => {'Length'=>[30, 29] * 8 + [30]},
        'S' => {'Length'=>[30, 29] * 7 + [30]}
      },
      'note' => 'YermNotes'
    }]
  end
end
