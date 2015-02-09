# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2015 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  class BasicTypes::M17n

    Islamic = [self, [
      "locale:[=en:, ja=ja:, zh=zh:, ar=ar:, alias]",
      "names:[Islamic=en:Islamic_calendar, イスラーム暦=ja:%%<ヒジュラ暦>, 伊斯蘭曆]",
      "[TabularIslamic=en:Islamic_calendar, イスラーム暦(30年周期)=ja:%%<ヒジュラ暦>, 伊斯蘭曆]",
      "[EphemerisBasedIslamic=en:Islamic_calendar, イスラーム暦=ja:%%<ヒジュラ暦>, 伊斯蘭曆]",

      [self,
        "names:[Month, 月=ja:%%<月_(暦)>]",
        "[Muharram,                         ムハッラム=,                  穆哈蘭姆月,       محرم]",
        "[Safar,                            サファル=,                    色法爾月,         صفر]",
        "[Rabi'_al-awwal,                   ラビーウ・アル＝アウワル=,    賴比爾·敖外魯月,  ربيع الأول]",
        "[Rabi'_al-thani,                   ラビーウ・アル＝サーニー=,    賴比爾·阿色尼月,  ربيع الآخر]",
        "[Jumada_al-awwal,                  ジュマーダー・アル＝アウワル=,主馬達·敖外魯月=, جمادى الأولى]",
        "[Jumada_al-Thani,                  ジュマーダー・アル＝サーニー=,主馬達·阿色尼月=, جمادى الآخرة]",
        "[Rajab,                            ラジャブ=,                    賴哲卜月=,        رجب]",
        "[Sha'aban,                         シャアバーン=,                舍爾邦月,         شعبان]",
        "[Ramadan=en:Ramadan_(calendar_month), ラマダーン,                賴買丹月,         رمضان]",
        "[Shawwal,                          シャウワール=,                閃瓦魯月,         شوال]",
        "[Dhu_al-Qi'dah,                    ズー・アル＝カーイダ=,        都爾喀爾德月=,    ذو القعدة]",
        "[Dhu_al-Hijjah,                    ズー・アル＝ヒッジャ=,        都爾黑哲月,       ذو الحجة]"
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
