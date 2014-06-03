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

    Yerm = [self, [
      "namespace:[en=http://en.wikipedia.org/wiki/]",
      "locale:[=en:, ja]",
      "names:[Yerm=]",
      "[YermLunar=http://calendars.wikia.com/wiki/Yerm_Lunar_Calendar, ヤーム]",

      [Coordinates::Residue, "label:[yerm=]", "divisor:52", "year:0", "format:[%s=]"] +
      (1..52).to_a.map {|y|  [Coordinates::Residue, "label:[Yerm #{y}=]", "remainder:#{y-1}"]},
      [self, "names:[month]"] + (1..17).to_a.map {|m| "Month #{m}"},
      [self, "names:[night]"] + (1..30).to_a.map {|m| "Night #{m}"}
    ]]
  end

  class CalendarNote
    Yerm = [['_m:Yerm::yerm'], ['_m:Calendar::Month'], ['Common::Week']]
  end

  module CalendarTypes

    #
    # Yerm Lunar Calendar
    #
    Yerm =  [CyclicTableBased, {
      'label'         => 'Yerm::YermLunar',
      'origin_of_LSC' => 1948379 - 25101,  # 622-05-16 Base Cycle = No.1
      'indices'       => [
        When.Index('Yerm::yerm', {:unit =>52}),
        When.Index('Yerm::month'),
        When.Index('Yerm::night')
      ],
      'rule_table' => {
        'T' => {'Rule'  =>['L', 'L', 'S'] * 17 + ['L']},
        'L' => {'Length'=>[30, 29] * 8 + [30]},
        'S' => {'Length'=>[30, 29] * 7 + [30]}
      },
      'note' => 'Yerm'
    }]
  end
end
