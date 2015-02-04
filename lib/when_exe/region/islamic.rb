# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2015 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  class BasicTypes::M17n

    Islamic = [self, [
      "locale:[=en:, ja=ja:, ar=ar:, alias]",
      "names:[Islamic=]",
      "[TabularIslamic=en:Islamic_calendar, イスラーム暦(30年周期)=ja:%%<ヒジュラ暦>]",
      "[EphemerisBasedIslamic=en:Islamic_calendar, イスラーム暦=ja:%%<ヒジュラ暦>]",

      [self,
        "names:[Month, 月=ja:%%<月_(暦)>]",
        "[Muharram,                         ムハッラム=,                   محرم]",
        "[Safar,                            サファル=,                     صفر]",
        "[Rabi'_al-awwal,                   ラビーウ・アル＝アウワル=,     ربيع الأول]",
        "[Rabi'_al-thani,                   ラビーウ・アル＝サーニー=,     ربيع الآخر]",
        "[Jumada_al-awwal,                  ジュマーダー・アル＝アウワル=, جمادى الأولى]",
        "[Jumada_al-Thani,                  ジュマーダー・アル＝サーニー=, جمادى الآخرة]",
        "[Rajab,                            ラジャブ=,                     رجب]",
        "[Sha'aban,                         シャアバーン=,                 شعبان]",
        "[Ramadan=en:Ramadan_(calendar_month), ラマダーン,                 رمضان]",
        "[Shawwal,                          シャウワール=,                 شوال]",
        "[Dhu_al-Qi'dah,                    ズー・アル＝カーイダ=,         ذو القعدة]",
        "[Dhu_al-Hijjah,                    ズー・アル＝ヒッジャ=,         ذو الحجة]"
      ]
    ]]
  end

  class TM::CalendarEra

    # ヒジュラ紀元
     Hijra = [self, [
      "area:[Islamic=]",
      ["[AfterHijra=en:Islamic_calendar,*alias:AH]1.1.1", '@CE', "01-01-01^TabularIslamic"],
    ]]
  end

  module CalendarTypes

    #
    # Tabular Islamic Calendar
    #
    TabularIslamic =  [CyclicTableBased, {
      'label' => 'Islamic::TabularIslamic',
      'origin_of_LSC'  =>  1948440-354,
      'indices' => [
         When.Index('Islamic::Month', {:unit =>12}),
         When::Coordinates::DefaultDayIndex
       ],
      'rule_table'     => {
        'T' => {'Rule'  =>[['L',2], 'S', ['L',3], 'S', ['L',2], 'S', 'L']},
        'L' => {'Rule'  =>[354, 354, 355]},
        'S' => {'Rule'  =>[354, 355]},
        354 => {'Length'=>[30,29] * 6           },
        355 => {'Length'=>[30,29] * 5 + [30] * 2}
      }
    }]

    # 月日の配当が新月の初見によって決定される純太陰暦
    #
    #   Calendar based on the first visibilty of new moon
    #
    class EphemerisBasedIslamic < EphemerisBasedLunar

      #protected

      # 月初の通日
      #
      # @param  [Integer] m 通月
      #
      # @return [Integer] 月初の通日
      #
      def _new_month_(m)
        jdn  = (@formula[-1].cn_to_time(m + @cycle_offset) + 0.5 + 
                @location.long / (When::Coordinates::Spatial::DEGREE * 360)).floor - 1
        jdn += 1 while @formula[-1].moon_visibility(jdn) < 0
        return jdn
      end

      private

      # オブジェクトの正規化
      #    @label          = 暦法名
      #    @cycle_offset   = Goldstein Number に対する暦元の補正
      #
      def _normalize(args=[], options={})
        @label        ||= 'Islamic::EphemerisBasedIslamic'
        @indices      ||= [
          When.Index('Islamic::Month', {:unit =>12}),
          When::Coordinates::DefaultDayIndex
        ]
        super
      end
    end
  end
end
