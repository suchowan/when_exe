# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When

  class BasicTypes::M17n

    Symmetry = [self, [
      "locale:[=en:, ja]",
      "names:[Symmetry=]",
      "[Sym454=en:Symmetry454, 対称454暦=]",
      "[Sym010=http://individual.utoronto.ca/kalendis/classic.htm, 対称010暦=]"
    ]]
  end

  module CalendarTypes

    _pattern = (0...293).to_a.map {|year| (52 * year + 146) % 293 < 52 ? 371 : 364}

    #
    # Symmetry 454 Calendar
    #
    Sym454 =  [CyclicTableBased, {
      'label'   => 'Symmetry::Sym454',
      'origin_of_LSC'  => 1721062,
      'rule_table'       => {
        'T'  => {'Rule'  =>_pattern},
        364  => {'Length'=>[28,35,28] * 4},
        371  => {'Length'=>[28,35,28] * 3 + [28,35,35]}
      }
    }]

    #
    # Symmetry 010 Calendar
    #
    Sym010 =  [CyclicTableBased, {
      'label'   => 'Symmetry::Sym010',
      'origin_of_LSC'  => 1721062,
      'rule_table'       => {
        'T'  => {'Rule'  =>_pattern},
        364  => {'Length'=>[30,31,30] * 4},
        371  => {'Length'=>[30,31,30] * 3 + [30,31,37]}
      }
    }]
  end
end
