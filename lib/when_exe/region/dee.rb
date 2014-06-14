# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When

  class BasicTypes::M17n

    Dee = [self, [
      "namespace:[en=http://www.hermetic.ch/cal_stud/]",
      "locale:[=en:, ja]",
      "names:[Dee=en:dee-cecil-calendar.htm, ディー暦=]",
      "[DeeCecil=en:dee-cecil-calendar.htm, ディー-セシル暦=]"
    ]]
  end

  module CalendarTypes

    _rule_table = {
      'T' => {'Rule'  =>(0...33).to_a.map {|year| (year % 33) % 4 == 3 ? 366 : 365}},
      365 => {'Length'=>[31,28] + [31,30,31,30,31] * 2},
      366 => {'Length'=>[31,29] + [31,30,31,30,31] * 2}
    }

    #
    # Dee Calendar
    #
    Dee = [CyclicTableBased, {
      'label'         => 'Dee',
      'origin_of_LSC' => 1721425,
      'origin_of_MSC' => 1,
      'rule_table'    => _rule_table
    }]

    #
    # DeeCecil Calendar
    #
    DeeCecil = [CyclicTableBased, {
      'label'         => 'Dee::DeeCecil',
      'origin_of_LSC' => 1721426,
      'origin_of_MSC' => 1,
      'rule_table'    => _rule_table
    }]
  end
end
