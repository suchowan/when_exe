# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When

  class BasicTypes::M17n

    Christian = [self, [
      "locale:[=en:, ja=ja:, alias]",
      "names:[Christian=]",
      "[Julian=en:Julian_calendar,                ユリウス暦    ]",
      "[Gregorian=en:Gregorian_calendar,          グレゴリオ暦  ]",
      "[RevisedJulian=en:Revised_Julian_calendar, 修正ユリウス暦]",
      "[Swedish=en:Swedish_calendar,              スウェーデン暦]",
      "[Civil in the West=en:Civil_calendar, 西暦, *alias:Civil]"
    ]]
  end

  class TM::CalendarEra
    # Anno Mundi Era
    Byzantine = [self, [
      "locale:[=en:, ja=ja:, alias]",
      "period:[Byzantine=en:Byzantine_calendar, ビザンティン暦=ja:%%<世界創造紀元>]",
      ["[AM=en:Anno_Mundi, 世界創造紀元, alias:Anno_Mundi]6497*9.1",
       '@CE', "989*09-01^Julian?border=0*9-1&note=Roman", "1453-5-29"]
    ]]
  end

  module CalendarTypes

    #
    # Christian Base Calendar
    #
    class Christian < When::TM::Calendar

      # デフォルトの改暦日付(ユリウス通日)
      # 
      # @private
      DefaultReformDate = 2299161 # 1582-10-15

      # @private
      # 
      # ::Date オブジェクトに対応する暦法名
      # (require 'Date' されていることの保証は呼び出し側)
      #
      def self._default_start(date)
        case date.start
        when ::Date::JULIAN    ; 'Julian'
        when ::Date::GREGORIAN ; 'Gregorian'
        else                   ; "Civil?reform_jdn=#{date.start}"
        end
      end

      # 年月日 -> 通日
      #
      # @see When::CalendarTypes::TableBased#_coordinates_to_number
      #
      def _coordinates_to_number(y,m,d)
        m = (+m + 10) % 12
        y =  +y + 4716 - m / 10
        a = (1461*y.to_i    ).div(4)
        b = ( 153*m.to_i + 2).div(5)
        return a + b + (+d) - 1401
      end

      # 通日 - > 年月日
      #
      # @see When::CalendarTypes::TableBased#_number_to_coordinates
      #
      def _number_to_coordinates(jdn)
        j    =   jdn.to_i + 1401
        y, t =  (4*j + 3).divmod(1461)
        t    =   t.div(4)
        m, d =  (5*t + 2).divmod(153)
        d    =   d.div(5)
        m    =  (m+2) % 12
        y    =  y - 4716 + (13-m) / 12
        return [y,m,d]
      end

      # 暦要素数
      #
      # @see When::CalendarTypes::TableBased#_length
      #
      def _length(date)
        yy, mm = date
        return super unless(mm)
        return ((yy % 4) == 0) ? 29 : 28 if (mm == 1)
        return (((((mm + 10) % 12) % 5) % 2) == 0) ? 31 : 30
      end

      # 復活祭の遅延日数
      # 
      # @private
      def _easter_delay(year)
        0
      end

      private

      def _normalize(args=[], options={})
        raise TypeError, "#{self.class} is abstract class" unless @label
        @note = When.CalendarNote(@note || 'Christian')
        @diff_to_CE ||= 0
        super
      end
    end

    #
    # Julian Calendar
    #
    class Julian < Christian

      # 太陰方程式
      #
      # @param [Numeric] year 西暦の年数
      # @return [Integer] 0 (ユリウス暦では補正なし)
      #
      def _lunar_equation(year)
        0
      end

      # @private
      #
      # 対応する ::Date の start 属性
      def _default_start
        ::Date::JULIAN
      end

      private

      def _normalize(args=[], options={})
        @label ||= 'Christian::Julian'
        super
      end
    end

    #
    # Swedish Calendar
    #
    class Swedish < Julian

      # デフォルトの改暦日付(ユリウス通日)
      # 
      # @private
      DefaultReformDate = 2361390 # 1753-03-01

      # @private
      #           Julian -  17000229  17120229
      SwedishCalendarRange = 2342042...2346425

      # @private
      ExtraDate = [1712,1,29]

      # @private
      Length = {
        [1700, nil] => 365,
        [1700,   1] =>  28,
        [1712, nil] => 367,
        [1712,   1] =>  30
      }

      # Ref: http://www.ortelius.de/kalender/east_en.php
      # @private
      EasterDelay = {
        1741 =>  -7,
        1742 => -35,
        1744 =>  -7,
        1745 =>  -7,
        1747 => -28,
        1748 =>  -7,
        1750 => -28,
        1751 =>  -7,
        1752 =>  -7,
        1802 =>  +7,
        1805 =>  +7,
        1818 =>  +7
      }

      # 年月日 -> 通日
      #
      # @see When::CalendarTypes::TableBased#_coordinates_to_number
      #
      def _coordinates_to_number(y,m,d)
        jdn = super
        return SwedishCalendarRange.last if [+y, m, d] == ExtraDate
        SwedishCalendarRange.include?(jdn-1) ? jdn-1 : jdn
      end

      # 通日 - > 年月日
      #
      # @see When::CalendarTypes::TableBased#_number_to_coordinates
      #
      def _number_to_coordinates(jdn)
        return ExtraDate.dup if jdn == SwedishCalendarRange.last
        super(SwedishCalendarRange.include?(jdn) ? jdn+1 : jdn)
      end

      # 暦要素数
      #
      # @see When::CalendarTypes::TableBased#_length
      #
      def _length(date)
        y, m = date
        Length[[+y,m]] || super
      end

      # 復活祭の遅延日数
      # 
      # @private
      def _easter_delay(year)
        EasterDelay[year] || 0
      end

      private

      def _normalize(args=[], options={})
        @label ||= 'Christian::Swedish'
        super
      end
    end

    #
    # Variation of Christian Calendar
    #
    class ReformVariation < Christian

      # 年月日 -> 通日
      #
      # @see When::CalendarTypes::TableBased#_coordinates_to_number
      #
      def _coordinates_to_number(y,m,d)
        super - _diff_from_century(((m < 2) ? +y-1 : +y).to_i.div(100))
      end

      # 通日 - > 年月日
      #
      # @see When::CalendarTypes::TableBased#_number_to_coordinates
      #
      def _number_to_coordinates(jdn)
        super(jdn + _diff_from_century(_century_from_jdn(jdn)))
      end

      # 暦要素数
      #
      # @see When::CalendarTypes::TableBased#_length
      #
      def _length(date)
        yy, mm = date
        return super unless mm == 1 # ２月でなければユリウス暦と同じ
        cc, yy = yy.divmod(100)
        return super unless yy == 0 # 100で割り切れない年はユリウス暦と同じ
        29 - (_diff_from_century(cc) - _diff_from_century(cc-1))
      end

      # 太陰方程式
      #
      # @param [Numeric] year 西暦の年数
      # @return [Integer] 19年7閏のペースに対する満月の日付の補正量
      # @note 太陽暦日の補正も、本メソッドで行う
      #
      def _lunar_equation(year)
        h = +year.div(100)
        (8*(h+11)).div(25) - (_diff_from_century(h) + 5)
      end
    end

    #
    # Gregorian Calendar
    #
    class Gregorian < ReformVariation

      # 百年代 - > ユリウス暦とグレゴリオ暦の差
      #
      # @param [Integer] century 百年代
      #
      # @return [Integer] ユリウス暦とグレゴリオ暦の差
      #
      def _diff_from_century(century)
        (3*(century-3)).div(4)+1
      end

      # 通日 - > 百年代
      #
      # @param [Integer] jdn 通日
      #
      # @return [Integer] 百年代
      #
      def _century_from_jdn(jdn)
        (4 * jdn - 6884477).div(146097)
      end

      private

      def _normalize(args=[], options={})
        @label ||= 'Christian::Gregorian'
        super
      end
    end

    #
    # Revised Julian Calendar
    #
    class RevisedJulian < ReformVariation

      # デフォルトの改暦日付(ユリウス通日)
      # 
      # @private
      DefaultReformDate = 2423707 # 1923-10-14

      # 百年代 - > ユリウス暦と修正ユリウス暦の差
      #
      # @param [Integer] century 百年代
      #
      # @return [Integer] ユリウス暦と修正ユリウス暦の差
      #
      def _diff_from_century(century)
        (7*(century-1)).div(9)-1
      end

      # 通日 - > 百年代
      #
      # @param [Integer] jdn 通日
      #
      # @return [Integer] 百年代
      #
      def _century_from_jdn(jdn)
        (9 * jdn - 15490078).div(328718)
      end

      private

      def _normalize(args=[], options={})
        @label ||= 'Christian::RevisedJulian'
      # @diff  ||= [-2, -1, -1, 0, 1, 2, 2, 3, 4, 5] # 1～10世紀の各世紀のユリウス暦と差の日数
        super
      end
    end

    #
    # Civil Calendar
    #
    class Civil < Gregorian

      #
      # 改暦日付
      #
      # @return [Integer]
      #
      attr_reader :reform_jdn

      # @private
      #
      # 対応する ::Date の start 属性
      alias :_default_start :reform_jdn

      #
      # 年初の最初の定義の年
      #
      # @return [Integer] 年初の最初の定義の年
      # @return nil
      #
      def first_year_of_border
        return nil unless @border.kind_of?(When::Coordinates::MultiBorder)
        year = @border.borders[-1][:key]
        year.kind_of?(Integer) ? year : nil
      end

      # 年月日 -> 通日
      #
      # @see When::CalendarTypes::TableBased#_coordinates_to_number
      #
      def _coordinates_to_number(y,m,d)
        skip, limit = @the_length[[y,m]]
        d += skip if skip && d >= limit
        jdn  = @new._coordinates_to_number(y,m,d)
        jdn >= @reform_jdn ? jdn :  @old._coordinates_to_number(y + @origin_of_MSC - @old.origin_of_MSC, m, d)
      end

      # 通日 - > 年月日
      #
      # @see When::CalendarTypes::TableBased#_number_to_coordinates
      #
      def _number_to_coordinates(jdn)
        if jdn >= @reform_jdn
          date     = @new._number_to_coordinates(jdn)
        else
          date     = @old._number_to_coordinates(jdn)
          date[0] -= @origin_of_MSC - @old.origin_of_MSC
        end
        skip, limit = @the_length[date[0..-2]]
        date[2] -= skip if skip && date[2] >= limit
        date
      end

      # 暦要素数
      #
      # @see When::CalendarTypes::TableBased#_length
      #
      def _length(date)
        return @the_length[date][2] if @the_length[date]
        yy, mm = date
        (yy >  @reform_date[0]) ||
        (yy == @reform_date[0] && (!mm || mm >= @reform_date[1])) ?
          @new._length(date) :
          @old._length([yy + @origin_of_MSC - @old.origin_of_MSC, mm])
      end

      # 太陰方程式
      #
      # @param [Numeric] year 西暦の年数
      # @return [Integer] 19年7閏のペースに対する満月の日付の補正量
      # @note 太陽暦日の補正も、本メソッドで行う
      #
      def _lunar_equation(year)
        year >= @the_easter ? @new._lunar_equation(year) : @old._lunar_equation(year)
      end

      # 復活祭の遅延日数
      # 
      # @private
      def _easter_delay(year)
        @old._easter_delay(year)
      end

      private

      # オブジェクトの正規化
      #
      #   @old         = 改暦前の暦法(デフォルトはユリウス暦)
      #   @new         = 改暦後の暦法(デフォルトはグレゴリオ暦)
      #   @reform_date = 改暦日付(月日は 1 オリジンで指定し、0 オリジンに直して保持)
      #   @reform_jdn  = 改暦日付のユリウス通日
      #   @reform      = reform_date か reform_jdn を内容で判別し、どちらかに反映する
      #   @the_easter  = 新暦法の復活祭計算の適用を始める年
      #   @the_length  = 通常と異なる日付となる年月の情報({[年,月]=>[スキップした日数, スキップし始める日, 月の日数]})
      #
      def _normalize(args=[], options={})
        @label   ||= 'Christian::Civil'

        # 前後の暦法
        @old       = When.Calendar(@old || 'Julian')
        @new       = When.Calendar(@new || 'Gregorian')
        @indices ||= @old.indices

        # 改暦日付 (0 オリジン)
        @reform = When::Coordinates::Pair._en_pair_date_time(@reform) if @reform.kind_of?(String)
        case @reform.length
        when 0 ;
        when 1 ; @reform_jdn  = @reform[0]
        else   ; @reform_date = @reform
        end if @reform.kind_of?(Array)

        if @reform_date
          @reform_date  = When::Coordinates::Pair._en_pair_date_time(@reform_date) if @reform_date.kind_of?(String)
          @reform_date  = @reform_date.map {|c| c.to_i}
          (1..2).each {|i| @reform_date[i] = @reform_date[i] ? @reform_date[i] - 1 : 0 }
          @reform_jdn   = @new._coordinates_to_number(*@reform_date)
        else
          @reform_jdn ||= [@old.class::DefaultReformDate, @new.class::DefaultReformDate].max
          @reform_jdn   = @reform_jdn.to_i
          @reform_date  = @new._number_to_coordinates(@reform_jdn)
        end
        last_date   = @old._number_to_coordinates(@reform_jdn-1)

        # 復活祭との前後関係
        @the_easter = @reform_jdn > When.CalendarNote('Christian').easter(@reform_date[0], @new) ? @reform_date[0]+1 : @reform_date[0]

        # 月の日数
        this_month  = @reform_date[0..1]
        new_length  = @new._length(this_month)
        @the_length = {}
        if @reform_date[1] == last_date[1] # 同一月内に閉じた改暦
          skipped_length = @reform_date[2] - last_date[2] - 1
          @the_length[this_month] = [skipped_length, last_date[2]+1, new_length-skipped_length]
        else
          last_month = [(@reform_date[1] > last_date[1] ? @reform_date[0] : @reform_date[0]-1), last_date[1]]
          @the_length[this_month] = [@reform_date[2], 0, new_length - @reform_date[2]]
          @the_length[last_month] = [false, false, last_date[2]+1]
        end

        super
      end

      #
      # 整数のindex化
      #
      def _to_index(date)
        digit = date[-1] - @base[date.length-1]
        skip, limit = @the_length[date[0..-2]]
        skip && digit >= limit ? digit-skip : digit
      end

      #
      # indexの整数化
      #
      def _from_index(date)
        digit = date[-1]
        skip, limit = @the_length[date[0..-2]] 
        (skip && digit >= limit ? digit+skip : digit)+@base[date.length-1]
      end
    end
  end

  module Coordinates

    #
    # 日時要素の境界 - 復活祭
    #
    class Easter < Border

      # 境界の取得
      #
      # @param [Array<Numeric>] date 境界を計算する年
      # @param [When::TM::ReferenceSystem] frame 使用する暦法
      #
      # @return [Array<Numeric>] その年の境界
      #
      def border(date=[], frame=When::Gregorian)
        frame._encode(frame._number_to_coordinates(frame.note.easter(date[0], frame)), false)
      end

      private

      # 要素の正規化
      def _normalize(args=[], options={})
        @border = [0,0,0]
      end
    end
  end

  #
  # キリスト教の暦注(クリスマスと復活祭)
  #
  class CalendarNote::Christian < CalendarNote

    Notes = [When::BasicTypes::M17n, [
      "locale:[=en:, ja=ja:, alias]",
      "names:[Christian]",

      # 年の暦注 ----------------------------
      [When::BasicTypes::M17n,
        "names:[year]"
      ],

      # 月の暦注 ----------------------------
      [When::BasicTypes::M17n,
        "names:[month]",
        [When::BasicTypes::M17n,
          "names:[Month]"
        ]
      ],

      # 日の暦注 ----------------------------
      [When::BasicTypes::M17n,
        "names:[day]",
        [When::BasicTypes::M17n, "names:[Week,           七曜]"      ],
        [When::BasicTypes::M17n, "names:[Easter,         復活祭]"    ],
        [When::BasicTypes::M17n, "names:[Christmas,      クリスマス]"],
        [When::BasicTypes::M17n, "names:[Fixed_feast=,   固定祝日=]" ],
        [When::BasicTypes::M17n, "names:[Moveable_feast, 移動祝日]"  ]
      ]
    ]]

    # 固定祝日
    Fixed_feasts = {
      [ 1,  6] => "Epiphany",
      [ 3,  1] => "St.David's Day",
      [ 3, 17] => "St.Patrick's Day",
      [ 3, 25] => "Annunciation-Lady Day",
      [ 4, 23] => "St.George's Day",
      [ 6, 24] => "Midsummer Day",
      [ 9, 14] => "Holy Cross Day",
      [ 9, 29] => "Michaelmas Day",
      [11, 30] => "St.Andrew's Day",
      [12, 13] => "St.Lucia's Day",
      [12, 21] => "St.Thomas's Day",
    # [12, 25] => "Christmas Day"
    }

    # 移動祝日 (日付と曜日による)
    moveable_feasts = {}
    [[[ 9, 15, 2], "III Quatember"],
     [[11, 27, 6], "Advent Sunday"],
     [[12, 14, 2], "IV Quatember" ]].each do |pair|
      date, name = pair
      7.times do
        moveable_feasts[date.dup] = name
        date[1] += 1
        if date[1] > 30
          date[0] += 1
          date[1]  = 1
        end
      end
    end

    # 移動祝日
    Moveable_feasts = {
      # 復活祭からの日数による
      -63 => "Septuagesima Sunday",
      -56 => "Sexagesima Sunday",
      -49 => "Quinquagesima Sunday",
      -46 => "Ash Wednesday",
      -42 => "Quadragesima Sunday",
      -40 => "I Quatember",
      -35 => "Reminizer Sunday",
      -28 => "Oculi Sunday",
      -21 => "Laetare Sunday",
      -14 => "Judica Sunday",
       -7 => "Palmarum",
       -2 => "Good Friday",
    #   0 => "Easter Day",
        7 => "Low Sunday",
       35 => "Rogation Sunday",
       39 => "Ascension Day",
       49 => "Whitsunday",
       53 => "II Quatember",
       56 => "Trinity Sunday",
       60 => "Corpus Christi",
    }.update(moveable_feasts) 

    #
    # 暦法によってイベントの動作を変えるか否か
    #
    CalendarDepend = true

    # 週日補正フラグ
    # @return [Integer]
    attr_reader :w

    # 最も遅い満月の3月0日からの日数
    # @return [Integer]
    attr_reader :d

    # クリスマスの3月0日からの日数
    # @return [Integer]
    attr_reader :x

    # 平年数
    # @return [Integer]
    attr_reader :n

    # 置閏周期
    # @return [Integer]
    attr_reader :s

    # 月の位相の補正
    # @return [Integer]
    attr_reader :c

    # ガード
    # @return [Integer]
    attr_reader :g

    # ベース
    # @return [Integer]
    attr_reader :b

    # 満月補正フラグ
    # @return [Integer]
    attr_reader :f

    # 七曜
    #
    # @param [When::TM::TemporalPosition] date
    # @param [When::TM::CalDate] base (not used)
    #
    # @return [When::Coordinates::Residue] 七曜
    #
    def week(date, base=nil)
      When.Residue('Week')[date.to_i % 7]
    end

    # クリスマス
    #
    # @param [Numeric] date 西暦の年数
    # @param [When::TM::TemporalPosition] date
    # @param [When::TM::ReferenceSystem] frame 使用する暦法(デフォルトは When::Gregorian)
    #
    # @return [Integer]           クリスマスのユリウス通日(dateが西暦の年数の場合)
    # @return [When::TM::CalDate] クリスマスのWhen::TM::CalDate(yearがWhen::TM::TemporalPositionの場合)
    #
    def christmas(date, frame=nil)
      _event(date, 'christmas', frame) do |year, frame|
        @x - 1 + frame._coordinates_to_number(year, 2, 0)
      end
    end

    # 復活祭
    #
    # @param [Numeric] date 西暦の年数
    # @param [When::TM::TemporalPosition] date
    # @param [When::TM::ReferenceSystem] frame 使用する暦法(デフォルトは When::Gregorian)
    #
    # @return [Integer]           復活祭のユリウス通日(dateが西暦の年数の場合)
    # @return [When::TM::CalDate] 復活祭のWhen::TM::CalDate(yearがWhen::TM::TemporalPositionの場合)
    #
    def easter(date, frame=nil)
      _event(date, 'easter', frame) do |year, frame|
        golden = (year+@b) % @s + 1
        m      = (frame._lunar_equation(year) + 11*golden + @c) % 30
        if @f == 0
          m += 1 if m==0 || m==1 && golden>=@n
        else
          m += (golden-1) / @f
          m -= 30 if m>=@n
        end
        result  = frame._coordinates_to_number(year, 2, 0) + @d - 1 - m
        result += @g - (result-@w) % 7 if @w<7
        result + frame._easter_delay(year)
      end
    end

    #   イベントの標準的な間隔を返す
    # @private
    def _delta(parameter=nil)
      return When::P1Y
    end

    # @private
    alias :christmas_delta :_delta

    # @private
    alias :easter_delta    :_delta

    # 固定祝日
    #
    # @param [When::TM::TemporalPosition] date
    # @param [When::TM::ReferenceSystem] frame 使用する暦法(デフォルトは When::Gregorian)
    #
    # @return [String] 祝日の名称
    # @return [nil]    祝日に該当しない
    #
    def fixed_feast(date, frame=nil)
      date = When.Calendar(frame||'Gregorian') ^ date unless date.frame.kind_of?(When::CalendarTypes::Christian)
      Fixed_feasts[date.cal_date[-2..-1]]
    end

    # 移動祝日
    #
    # @param [When::TM::TemporalPosition] date
    # @param [When::TM::ReferenceSystem] frame 使用する暦法(デフォルトは When::Gregorian)
    #
    # @return [String] 祝日の名称
    # @return [nil]    祝日に該当しない
    #
    def moveable_feast(date, frame=nil)
      result = Moveable_feasts[date.to_i - easter(date, frame).to_i]
      return result if result
      date = When.Calendar(frame||'Gregorian') ^ date unless date.frame.kind_of?(When::CalendarTypes::Christian)
      Moveable_feasts[date.cal_date[-2..-1] + [date.to_i % 7]]
    end

    private

    # オブジェクトの正規化
    #   w - 週日補正フラグ(デフォルト  6)
    #   d - 最も遅い満月  (デフォルト 3月0日から 50日)
    #   x - クリスマス    (デフォルト 3月0日から300日)
    #   n - 平年数        (デフォルト 12)
    #   s - 置閏周期      (デフォルト 19)
    #   c - 月の位相の補正(デフォルト  3)
    #   g - ガード        (デフォルト  7)
    #   b - ベース        (デフォルト  0)
    #   f - 満月補正フラグ(デフォルト  0)
    def _normalize(args=[], options={})
      w, d, x, n, s, c, g, b, f = args
      @w = (w || @w ||   6).to_i
      @d = (d || @d ||  50).to_i
      @x = (x || @x || 300).to_i
      @n = (n || @n ||  12).to_i
      @s = (s || @s ||  19).to_i
      @c = (c || @c ||   3).to_i
      @g = (g || @g ||   7).to_i
      @b = (b || @b ||   0).to_i
      @f = (f || @f ||   0).to_i
      @event   = 'easter'
      @prime ||= [['Month'], ['Week']]
      super
    end

    #
    # 任意の暦をグレゴリオorユリウス暦日に変換
    #
    def _to_date_for_note(date)
      return When.Calendar(When::CalendarTypes::Christian._default_start(date)) ^ date if ::Object.const_defined?(:Date) &&
                                                                                          ::Date.method_defined?(:+) && date.kind_of?(::Date)
      return When::Gregorian ^ date if date.kind_of?(::Time)
      return date if date.frame.kind_of?(When::CalendarTypes::Christian)
      When.Calendar(date.frame.iri =~ /Coptic/ || date.to_i < 2299161 ? 'Julian' : 'Gregorian') ^ date
    end

    # 当該年のイベントの日付
    #   date       : 西暦の年数 or When::TM::(Temporal)Position
    #   event      : イベント名 (String)
    #   frame      : 暦法(デフォルトは When:Gregorian)
    #
    # @return [Integer]           イベントのユリウス通日(dateが西暦の年数の場合)
    # @return [When::TM::CalDate] イベントのWhen::TM::CalDate(yearがWhen::TM::(Temporal)Positionの場合)
    #
    def _event(date, event, frame=nil)
      case date
      when Numeric
        year    = date * 1
      when When::TimeValue
        options = date._attr
        options[:precision] = When::DAY
        options[:events]    = [event]
        if frame
          frame = When.Calendar(frame)
          date  = frame.jul_trans(date, options)
        else
          frame = date.frame
        end
        year = date.most_significant_coordinate * 1
      else
        raise TypeError, "Irregal date type: #{date.class}"
      end
      frame ||= When::Gregorian
      result  = yield(year, frame)
      return result if date.kind_of?(Numeric)
      return frame.jul_trans(result, options)
    end
  end
end
