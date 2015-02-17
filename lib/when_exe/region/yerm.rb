# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014-2015 Takashi SUGA

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
      "locale:[=en:, ja]",
      "names:[Karl Palmen's Yerm Lunar Calednar=, Karl Palmen のヤーム暦=, *Yerm=]",
      "[YermLunar=http://calendars.wikia.com/wiki/Yerm_Lunar_Calendar, ヤーム=]",

      [Coordinates::Residue, "label:[yerm=]", "divisor:52", "year:0", "format:[%s=]"] +
      (1..52).to_a.map {|y|  [Coordinates::Residue, "label:[Yerm #{y}=]", "remainder:#{y-1}"]},
      [self, "names:[month number=en:Month, 月の番号=ja:%%<月_(暦)>, zh:該月的數=, *alias:month=]"] + (1..17).to_a.map {|m| "Month #{m}"},
      [self, "names:[night]"] + (1..30).to_a.map {|m| "Night #{m}"}
    ]]
  end

  module CalendarTypes

    #
    # Yerm Lunar Calendar
    #
    class Yerm < CyclicTableBased

      #
      # Analyze notation with crescent
      #
      # @param [String] source Notation with crescents
      # @param [Array<Integer>] abbr Upper default elements (default - today's Yerm date)
      #
      # @return [String] Notation with hyphens
      #
      def self.parse(source, abbr=nil)
        c, y, m, d = abbr || (When::Yerm^When.today).cal_date
        case source
        when /\A(-?\d+)[-\(](\d+)\((\d+)\((\d+)\z/; c, y, m, d = [$1, $2, $3, $4]
        when /\A(-?\d+)-(\d+)\((\d+)\z/           ; c, y, m, d = [$1, $2, $3    ]
        when /\A(-?\d+)-(\d+)\z/                  ; c, y, m, d = [$1, $2        ]
        when /\A(-?\d+)-\z/                       ; c, y, m, d = [$1            ]
        when /\A(\d+)\((\d+)\((\d+)\z/            ;    y, m, d = [    $1, $2, $3]
        when /\A(\d+)\((\d+)\z/                   ;       m, d = [        $1, $2]
        when /\A(\d+)\z/                          ;          d =              $1

        when /\A(-?\d+)-(\d+)\)(\d+)\)(\d+)\z/    ; c, y, m, d = [$1, $4, $3, $2]

        when /\A(\d+)\)(\d+)\)(\d+)[-\)](-?\d+)\z/; c, y, m, d = [$4, $3, $2, $1]
        when /\A(\d+)\)(\d+)-(-?\d+)\z/           ; c, y, m, d = [$3, $2, $1    ]
        when /\A(\d+)-(-\d+)\z/                   ; c, y, m, d = [$2, $1        ]
        when /\A(-\d+)\z/                         ; c, y, m, d = [$1            ]
        when /\A(\d+)\)(\d+)\)(\d+)\z/            ;    y, m, d = [    $3, $2, $1]
        when /\A(\d+)\)(\d+)\z/                   ;       m, d = [        $2, $1]
        else                                      ; c, y, m, d = [              ]
        end

        ordered = [c, y, m, d]
        ordered.pop until ordered.last || ordered.empty?
        raise ArgumentError, "can't parse #{source}" if ordered.empty? || ordered.include?(nil)
        ordered.map {|n| n.to_s}.join('-')
      end

      private

      #
      # Object Normalization
      #
      def _normalize(args=[], options={})
        @label         ||= 'Yerm::YermLunar'
        @origin_of_LSC ||= 1948379 - 25101 # 622-05-16 Base Cycle = No.1
        @note          ||= [['_m:Yerm::yerm'],
                            ['_m:Calendar::Month'],
                            ['_co:Common::Week', '_n:Ephemeris/Notes::day::Moon_Age']]
        @indices       ||= [
          When.Index('Yerm::yerm', {:unit =>52}),
          When.Index('Yerm::month'),
          When.Index('Yerm::night')
        ]
        @rule_table    ||= {
          'T' => {'Rule'  =>['L', 'L', 'S'] * 17 + ['L']},
          'L' => {'Length'=>[30, 29] * 8 + [30]},
          'S' => {'Length'=>[30, 29] * 7 + [30]}
        }
        @strftime = @strftime && @strftime.upcase == 'REVERSE' ? '%d)%m)%y' : '%y(%m(%d'
        super
      end
    end
  end
end
