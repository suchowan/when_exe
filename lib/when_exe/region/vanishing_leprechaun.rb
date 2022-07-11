# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014-2022 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When

  class BasicTypes::M17n

    VanishingLeprechaun = [self, [
      "locale:[=en:, ja]",
      "names:[VanishingLeprechaun=https://suchowan.seesaa.net/article/201110article_12.html, 消える小妖精=]"
    ]]
  end

  module CalendarTypes

    class VanishingLeprechaun < EphemerisBased

      # 月初の通日
      #
      # @param  [Integer] m 通月
      #
      # @return [Integer] 月初の通日
      #
      def _new_month_(m)
        div, mod = m.divmod(@cycle_months)
        div * @cycle_days + @offset_table[m % @cycle_months] + @origin_of_LSC
      end

      private

      #
      # Object Normalization
      #
      def _normalize(args=[], options={})
        @label         ||= 'VanishingLeprechaun::VanishingLeprechaun'
        @note          ||= [['_m:Calendar::Month'],
                            ['_co:Common::Week', '_n:Ephemeris/Notes::day::SolarTerm']]
        @origin_of_LSC ||= -372154
        @origin_of_MSC ||=   -5731
        @epoch_in_CE   ||=       0
        _normal = [31] * 5 + [30] * 7
        _leap   = [31] * 6 + [30] * 6
        _length_table = ((_normal * 3 + _leap) * 4 + _normal + ((_normal * 3 + _leap) * 4)) * 53 + [30]
        @offset_table = _length_table.inject([0]) {|sum,len| sum << (sum.last + len)}
        @cycle_days   = @offset_table.pop
        @cycle_months = @offset_table.length
        super
      end
    end
  end
end
