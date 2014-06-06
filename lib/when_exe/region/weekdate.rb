# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When

  class BasicTypes::M17n

    WeekDate = [self, [
      "namespace:[en=http://en.wikipedia.org/wiki/]",
      "locale:[=en:, ja]",
      "names:[WeekDate=en:ISO_week_date, 暦週=]",
      [self, "names:[week]"] + (1...100).to_a.map {|m| "Week #{m}"},
    ]]
  end

  module CalendarTypes

    #
    # Week Date Calendar
    #
    class WeekDate < TableBased

      private

      #
      # Object Normalization
      #
      def _normalize(args=[], options={})
        @label    ||= 'WeekDate'
        @period   ||= 7  # length of week
        @first    ||= 0  # first day of week 
        @margin   ||= 3  # first day of year
        @strftime ||= @period < 10 ? '%Y-W%m-%q' : '%Y-W%m-%d'
        @engine   ||= 'Gregorian'
        @engine     = When.Calendar(@engine)
        @indices  ||= [
          When.Index('WeekDate::week'),
          When::Coordinates::DefaultDayIndex
        ]
        @rule_table ||= _generate_rule
        raise ArgumentError, 'Too many weeks in a year' if @rule_table.keys.max / @period >= 100
        super
      end

      # 年初の通日
      #
      # @param [Array<Numeric>] date ( 年 )
      #
      # @return [Integer] 年初の通日
      #
      def _sdn_(date)
        year  = +date[0] - @engine.origin_of_MSC
        sdn0  =  @margin + @engine._coordinates_to_number(year, 0, 0)
        sdn1  =  @first  + @period * sdn0.div(@period)
        sdn1 -=  @period if sdn1 > sdn0
        sdn1
      end

      # @private
      def _generate_rule
        hash = {}
        _week_number_range.each do |length|
          hash[@period * length] = {'Length'=>[@period] * length}
        end
        hash
      end

      # @private
      def _week_number_range
        return 52..53 if @engine.kind_of?(When::CalendarTypes::Christian)
        starts  = (0..19).to_a.map {|year| @engine._coordinates_to_number(year, 0, 0)}
        lengths = (0..18).to_a.map {|year| starts[year+1] - starts[year]}
        (lengths.min / @period)..((lengths.max + @period - 1) / @period)
      end
    end
  end
end
