# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014-2015 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

=begin

  References

 (1) http://calendars.wikia.com/wiki/Goddess_Lunar_Calendar
 (2) http://www.fractal-timewave.com/mmgc/mmgc.htm

=end

module When

  class BasicTypes::M17n

    Goddess = [self, [
      "locale:[=en:, ja, zh]",
      "names:[ Peter Meyer's Goddes Lunar Calendar=,  Peter Meyer のゴッデス暦=, *alias:Goddess=]",
      "[Goddess(MMG)=http://calendars.wikia.com/wiki/Goddess_Lunar_Calendar, ゴッデス暦(MMG), 女神曆(MMG), *alias:Goddess]",

      [self,
        "names:[month name=en:Month, 月の名前=ja:%%<月_(暦)>, 該月的名稱=, *alias:Month=]",
        "[Athena]", "[Brigid]", "[Cerridwen]", "[Diana ]",
        "[Epona ]", "[Freya ]", "[Gaea     ]", "[Hathor]",
        "[Inanna]", "[Juno  ]", "[Kore     ]", "[Lilith]",
        "[Maria ]"
      ]
    ]]
  end

  module CalendarTypes

    #
    # Goddess Calendar
    #
    Goddess =  [CyclicTableBased, {
      'label'         => 'Goddess::Goddess',
      'origin_of_LSC' => 2415611 - 180432,  # 1901-08-14 Base Cycle = No.1
      'note'          => [['_m:Calendar::Month'],
                          ['_co:Common::Week', '_n:Ephemeris/Notes::day::Moon_Age']],
      'indices'       => [
        When.Index({:unit=>470}),
        When.Index('Goddess::Month'),
        When::Coordinates::DefaultDayIndex,
      ],
      'rule_table' => {
        'T' => {'Rule'  =>(['L'] * 9 + ['S']) * 23 +
                          (['L'] * 4 + ['S']) *  2 +
                          (['L'] * 9 + ['S']) * 23},
        'L' => {'Length'=>[30, 29] * 6 + [30]},
        'S' => {'Length'=>[30, 29] * 6 + [29]}
      }
    }]
  end
end
