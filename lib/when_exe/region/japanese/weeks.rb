# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014-2017 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

class When::CalendarNote

  #
  # 標準の暦注 ＋ 六曜
  #
  CommonWithRokuyo = [['_m:Calendar::Month'], ['Common::Week', '_n:RokuyoWeek/Notes::day::Rokuyo']]

  #
  # 六曜
  #
  class RokuyoWeek < Week

    #
    # 暦注要素の定義
    #
    Notes = [When::BasicTypes::M17n, [
      "locale:[=en:, ja=ja:, zh=ja:, alias]",
      "names:[Rokuyo=]",

      # 日の暦注 ----------------------------
      [When::BasicTypes::M17n,
        "names:[day]",
        [When::BasicTypes::M17n,
          "names:[Rokuyo=, 六曜, 六曜=zh:%%<六曜>]",
          [DayOfWeek, "label:[Taian=,      *大安=ja:%%<六曜>#%.<大安>, 大安=ja:%%<六曜>#%.<大安>]", {'delta'=>6}],
          [DayOfWeek, "label:[Shakko=,     *赤口=ja:%%<六曜>#%.<赤口>, 赤口=ja:%%<六曜>#%.<赤口>]", {'delta'=>6}],
          [DayOfWeek, "label:[Sensho=,     *先勝=ja:%%<六曜>#%.<先勝>, 先勝=ja:%%<六曜>#%.<先勝>]", {'delta'=>6}],
          [DayOfWeek, "label:[Tomobiki=,   *友引=ja:%%<六曜>#%.<友引>, 友引=ja:%%<六曜>#%.<友引>]", {'delta'=>6}],
          [DayOfWeek, "label:[Sembu=,      *先負=ja:%%<六曜>#%.<先負>, 先負=ja:%%<六曜>#%.<先負>]", {'delta'=>6}],
          [DayOfWeek, "label:[Butsumetsu=, *仏滅=ja:%%<六曜>#%.<仏滅>, 仏滅=zh:%%<佛滅日>]", {'delta'=>6}]
        ]
      ]
    ]]

    #
    # この日は何曜？
    #
    # @param [When::TM::TemporalPosition] date
    # @param [When::TM::CalDate] base (not used)
    #
    # @return [Hash<:value=>When::CalendarNote::Week::DayOfWeek, :position=>Array<Integer>>]
    #
    def rokuyo(date, base=nil)
      date    = _to_date_for_note(date)
      y, m, d = date.cal_date
      index   = rokuyo_index(m,d)
      {:value=>@days_of_week[index], :position=>[index, 6]}
    end
    alias :week :rokuyo

    # @private
    def rokuyo_value(m,d)
      @days_of_week[rokuyo_index(m,d)]
    end

    # @private
    def rokuyo_index(m,d)
      (m*1 + d) % 6
    end

    # @private
    def taian(date, base=nil)
      count = 0
      d0 = d1 = _to_date_for_note(date)
      r0 = r1 = nil
      loop do
        y,m,d = d1.cal_date
        r1    = rokuyo_index(m,d)
        break if r1 == 0
        if r0 && r1 > r0
          r1     = r0
          count -= 1
          break
        end
        d0 = d1
        r0 = r1
        d1 = d0 - When::P1D
        count += 1
      end
      date -= count if count > 0
      date.events = [@days_of_week[r1]]
      date
    end

    #
    # 暦日を太陰太陽暦日に変換
    #
    # @private
    def _to_date_for_note(date)
      return date if date.frame.kind_of?(When::CalendarTypes::ChineseLuniSolar)
      return When::Japanese ^ date if date.most_significant_coordinate >= 1873
      return Japanese._to_japanese_date(date)
    end

    private

    # オブジェクトの正規化
    # @private
    def _normalize(args=[], options={})
      @days_of_week ||= When.CalendarNote("RokuyoWeek/Notes::day::Rokuyo")
      @event        ||= 'taian'
      super
    end
  end
end
