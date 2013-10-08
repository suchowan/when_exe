# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When

  class BasicTypes::M17n

    ChristianTerms = [self, [
      "namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/]",
      "locale:[=en:, ja=ja:, alias]",
      "names:[ChristianTerms]",
      "[Julian=en:Julian_calendar,       ユリウス暦  ]",
      "[Gregorian=en:Gregorian_calendar, グレゴリオ暦]",
      "[Civil=en:Civil_calendar,         西暦        ]",
      "[Coptic=en:Coptic_calendar,       コプト暦    ]",
      "[Ethiopian=en:Ethiopian_calendar, エチオピア暦=en:Ethiopian_calendar]",

      [self,
        "names:[EgyptianMonth, 月=ja:%%<月_(暦)>]",
        "[tut=,      トート=      ]",
        "[baba=,     バーバ=      ]",
        "[hatur=,    ハートール=  ]",
        "[kiyahak=,  キヤハーク=  ]",
        "[tuba=,     トーバ=      ]",
        "[amshir=,   アムシール=  ]",
        "[baramhat=, バラムハート=]",
        "[barmuda=,  バルムーダ=  ]",
        "[bashans=,  バシャンス=  ]",
        "[ba'una=,   バウーナ=    ]",
        "[abib=,     アビーブ=    ]",
        "[misra=,    ミスラー=    ]",
        "[epagomen=, エパゴメネ=  ]"
      ],

      [self,
        "names:[EthiopianMonth, 月=ja:%%<月_(暦)>]",
        "[Mäskäräm=, マスカラム=  ]",
        "[Ṭəqəmt=,   テケルト=    ]",
        "[Ḫədar=,    ヘダル=      ]",
        "[Taḫśaś=,   ターサス=    ]",
        "[Ṭərr=,     テル=        ]",
        "[Yäkatit=,  イェカティト=]",
        "[Mägabit=,  メガビト=    ]",
        "[Miyazya=,  ミアジア=    ]",
        "[Gənbot=,   ゲエンポト=  ]",
        "[Säne=,     セネ=        ]",
        "[Ḥamle=,    ハムレ=      ]",
        "[Nähase=,   ネハッセ=    ]",
        "[Ṗagʷəmen=, パゴウメン=  ]"
      ]
    ]]
  end

  class TM::CalendarEra
    # Anno Mundi Era
    Byzantine = [self, [
      "namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/]",
      "locale:[=en:, ja=ja:, alias]",
      "period:[Byzantine=en:Byzantine_calendar, ビザンティン暦=ja:%%<世界創造紀元>]",
      ["[AM=en:Anno_Mundi, 世界創造紀元, alias:Anno_Mundi]6497.9.1",
       "Calendar Epoch", "989-09-01^Julian?border=[-1,9,1]&note=RomanNote", "1453=5-29"]
    ]]
  end

  module CalendarTypes

    #
    # Coptic Calendar in Egypt
    #
    EgyptianCoptic =  [CyclicTableBased, {
      'label'         => Parts::Resource._instance('_m:ChristianTerms::Coptic'),
      'origin_of_LSC' => 1825030,
      'origin_of_MSC' =>       1,
      'epoch_in_CE'   =>     285,
      'indices' => [
         When::Coordinates::Index.new({:unit =>13,
                                       :trunk=>When::Parts::Resource._instance('_m:ChristianTerms::EgyptianMonth::*')}),
         When::Coordinates::Index.new
       ],
      'rule_table' => {
        'T' => {'Rule'  =>[366,365,365,365]},
        365 => {'Length'=>[30]*12+[5]},
        366 => {'Length'=>[30]*12+[6]}
      }
    }]

    #
    # Coptic Calendar in Ethiopia
    #
    EthiopianCoptic =  [CyclicTableBased, {
      'label'         => Parts::Resource._instance('_m:ChristianTerms::Ethiopian'),
      'origin_of_LSC' => 1825030,
      'origin_of_MSC' =>     277,
      'epoch_in_CE'   =>     285,
      'indices' => [
         When::Coordinates::Index.new({:unit =>13,
                                       :trunk=>When::Parts::Resource._instance('_m:ChristianTerms::EthiopianMonth::*')}),
         When::Coordinates::Index.new
       ],
      'rule_table' => {
        'T' => {'Rule'  =>[366,365,365,365]},
        365 => {'Length'=>[30]*12+[5]},
        366 => {'Length'=>[30]*12+[6]}
      }
    }]

    #
    # Julian Calendar
    #
    class Julian < When::TM::Calendar

      # 年月日 -> 通日
      #
      # @param  [Numeric] y 年
      # @param  [Integer] m 月 (0 始まり)
      # @param  [Integer] d 日 (0 始まり)
      #
      # @return [Integer] 通日
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
      # @param  [Integer] jdn 通日
      #
      # @return [Array<Integer>] ( y, m, d )
      #   [ y 年 ]
      #   [ m 月 (0 始まり) ]
      #   [ d 日 (0 始まり) ]
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
      # @overload _length(date)
      #   @param [Array<Integer>] date ( 年 )
      #   @return [Integer] 12 (=その年の月数)
      #
      # @overload _length(date)
      #   @param [Array<Integer>] date ( 年, 月 )
      #   @note 月は 0 始まりの通番
      #   @return [Integer] その年月の日数
      #
      def _length(date)
        yy, mm = date
        return super unless(mm)
        return ((yy % 4) == 0) ? 29 : 28 if (mm == 1)
        return (((((mm + 10) % 12) % 5) % 2) == 0) ? 31 : 30
      end

      # 太陰方程式
      #
      # @param [Numeric] year 西暦の年数
      # @return [Integer] 0 (ユリウス暦では補正なし)
      #
      def _lunar_equation(year)
        0
      end

      private

      def _normalize(args=[], options={})
        @label   ||= When.Resource('_m:ChristianTerms::Julian')
        @note      = When.CalendarNote(@note || 'Christian')
        @indices ||= [
           Index.new({:unit =>12,
                      :trunk=>m17n('[::_m:CalendarTerms::Month::*]')}),

           DefaultDayIndex
        ]
        super
      end
    end

    #
    # Gregorian Calendar
    #
    class Gregorian < Julian

      # 通日 - > ユリウス暦とグレゴリオ暦の差
      #
      # @param [Integer] jdn 通日
      #
      # @return [Integer] ユリウス暦とグレゴリオ暦の差
      #
      def self.diff(jdn)
        div, mod = (jdn - 77528).divmod(36524.25)
        c = div - 45
        (3*(c-3)).div(4)+1
      end

      # 年月日 -> 通日
      #
      # @param  [Numeric] y 年
      # @param  [Integer] m 月 (0 始まり)
      # @param  [Integer] d 日 (0 始まり)
      #
      # @return [Integer] 通日
      #
      def _coordinates_to_number(y,m,d)
        c = ((m < 2) ? +y-1 : +y).to_i.div(100)
        super - ((3*(c-3)).div(4)+1)
      end

      # 通日 - > 年月日
      #
      # @param  [Integer] jdn 通日
      #
      # @return [Array<Integer>] [ y, m, d ]
      #   y 年
      #   m 月 (0 始まり)
      #   d 日 (0 始まり)
      #
      def _number_to_coordinates(jdn)
        super(jdn + Gregorian.diff(jdn))
      end

      # 暦要素数
      #
      # @overload _length(date)
      #   @param [Array<Integer>] date ( 年 )
      #   @return [Integer] 12 (=その年の月数)
      #
      # @overload _length(date)
      #   @param [Array<Integer>] date ( 年, 月 )
      #   @note 月は 0 始まりの通番
      #   @return [Integer] その年月の日数
      #
      def _length(date)
        yy, mm = date
        return 28 if (((yy % 400) != 0) && ((yy % 100) == 0) && (mm == 1))
        return super
      end

      # 太陰方程式
      #
      # @param [Numeric] year 西暦の年数
      # @return [Integer] 19年7閏のペースに対する満月の日付の補正量
      # @note 太陽暦日の補正も、本メソッドで行う
      #
      def _lunar_equation(year)
        h = +year.div(100)
        -h + h.div(4) + (8*(h+11)).div(25) - 3
      end

      private

      def _normalize(args=[], options={})
        @label ||= When.Resource('_m:ChristianTerms::Gregorian')
        super
      end
    end

    #
    # Civil Calendar
    #
    class Civil < Gregorian

      #
      # グレゴリオ暦への改暦日付
      #
      # @return [Integer]
      #
      attr_reader :reform_jdn

      #
      # 年初の最初の定義の年
      #
      # @return [Integer] 年初の最初の定義の年
      # @return nil
      #
      def first_year_of_border
        return nil unless @border.kind_of?(When::CalendarTypes::MultiBorder)
        year = @border.borders[-1][:key]
        year.kind_of?(Integer) ? year : nil
      end

      # 年月日 -> 通日
      #
      # @param  [Numeric] y 年
      # @param  [Integer] m 月 (0 始まり)
      # @param  [Integer] d 日 (0 始まり)
      #
      # @return [Integer] 通日
      #
      def _coordinates_to_number(y,m,d)
        skip, limit = @the_length[[y,m]]
        d += skip if skip && d >= limit
        jdn  = super(y,m,d)
        jdn >= @reform_jdn ? jdn :  @past._coordinates_to_number(y + @origin_of_MSC - @past.origin_of_MSC, m, d)
      end

      # 通日 - > 年月日
      #
      # @param  [Integer] jdn 通日
      #
      # @return [Array<Integer>] ( y, m, d )
      #   [ y 年 ]
      #   [ m 月 (0 始まり) ]
      #   [ d 日 (0 始まり) ]
      #
      def _number_to_coordinates(jdn)
        if jdn >= @reform_jdn
          date     = super
        else
          date     = @past._number_to_coordinates(jdn)
          date[0] -= @origin_of_MSC - @past.origin_of_MSC
        end
        skip, limit = @the_length[date[0..-2]]
        date[2] -= skip if skip && date[2] >= limit
        date
      end

      # 暦要素数
      #
      # @overload _length(date)
      #   @param [Array<Integer>] date ( 年 )
      #   @return [Integer] 12 (=その年の月数)
      #
      # @overload _length(date)
      #   @param [Array<Integer>] date ( 年, 月 )
      #   @note 月は 0 始まりの通番
      #   @return [Integer] その年月の日数
      #
      def _length(date)
        return @the_length[date][2] if @the_length[date]
        yy, mm = date
        (yy >  @reform_date[0]) ||
        (yy == @reform_date[0] && (!mm || mm >= @reform_date[1])) ?
          super :
          @past._length([yy + @origin_of_MSC - @past.origin_of_MSC, mm])
      end

      # 太陰方程式
      #
      # @param [Numeric] year 西暦の年数
      # @return [Integer] 19年7閏のペースに対する満月の日付の補正量
      # @note 太陽暦日の補正も、本メソッドで行う
      #
      def _lunar_equation(year)
        year >= @the_easter ? super : 0
      end

      private

      # オブジェクトの正規化
      #
      #   @past        = グレゴリオ暦への改暦前の暦法
      #   @reform_date = 改暦日付(月日は 1 オリジンで指定し、0 オリジンに直して保持)
      #   @reform_jdn  = 改暦日付のユリウス通日
      #   @the_easter  = グレゴリオ暦の復活祭計算の適用を始める年
      #   @the_length  = 通常と異なる日付となる年月の情報({[年,月]=>[スキップした日数, スキップし始める日, 月の日数]})
      #
      def _normalize(args=[], options={})
        @label     ||= When.Resource('_m:ChristianTerms::Civil')

        # 前後の暦法
        @past        = When.Calendar(@past || 'Julian')
        gregorian    = When.Calendar('Gregorian')
        @indices   ||= @past.indices

        # 改暦日付 (0 オリジン)
        if @reform_date
          @reform_date  = When::Coordinates::Pair._en_pair_date_time(@reform_date) if @reform_date.kind_of?(String)
          @reform_date  = @reform_date.map {|c| c.to_i}
          (1..2).each {|i| @reform_date[i] = @reform_date[i] ? @reform_date[i] - 1 : 0 }
          @reform_jdn   = gregorian._coordinates_to_number(*@reform_date)
        else
          @reform_jdn ||= 2299161 # 1582-10-15
          @reform_jdn   = @reform_jdn.to_i
          @reform_date  = gregorian._number_to_coordinates(@reform_jdn)
        end
        last_date    = @past._number_to_coordinates(@reform_jdn-1)

        # 復活祭との前後関係
        @the_easter = @reform_jdn > When.CalendarNote('Christian').easter(@reform_date[0], gregorian) ? @reform_date[0]+1 : @reform_date[0]

        # 月の日数
        this_month   = @reform_date[0..1]
        greg_length  = gregorian._length(this_month)
        @the_length  = {}
        if @reform_date[1] == last_date[1] # 同一月内に閉じた改暦
          skipped_length = @reform_date[2] - last_date[2] - 1
          @the_length[this_month] = [skipped_length, last_date[2]+1, greg_length-skipped_length]
        else
          last_month = [(@reform_date[1] > last_date[1] ? @reform_date[0] : @reform_date[0]-1), last_date[1]]
          @the_length[this_month] = [@reform_date[2], 0, greg_length - @reform_date[2]]
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
      def border(date=[], frame=When.Calendar('Gregorian'))
        frame._encode(frame._number_to_coordinates(frame.note.easter(date[0], frame)), false)
      end

      private

      # 要素の正規化
      def _normalize(args=[], options={})
        @border = [0,0,0]
      end
    end

    #
    # キリスト教の暦注(クリスマスと復活祭)
    #
    class CalendarNote::Christian < CalendarNote

      NoteObjects = [When::BasicTypes::M17n, [
        "namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/]",
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
          [When::BasicTypes::M17n, "names:[Easter,    復活祭]"    ],
          [When::BasicTypes::M17n, "names:[Christmas, クリスマス]"]
        ]
      ]]

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

      # クリスマス
      #
      # @param [Numeric] date 西暦の年数
      # @param [When::TM::TemporalPosition] date
      # @param [When::TM::ReferenceSystem] frame 使用する暦法(デフォルトは When.Resource('_c:Gregorian'))
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
      # @param [When::TM::ReferenceSystem] frame 使用する暦法(デフォルトは When.Resource('_c:Gregorian'))
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
          result
        end
      end

      #   イベントの標準的な間隔を返す
      # @private
      def _delta(parameter=nil)
        return When::DurationP1Y
      end

      # @private
      alias :christmas_delta :_delta

      # @private
      alias :easter_delta    :_delta

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
        @prime ||= [['Month'], nil]
        super
      end

      #
      # 任意の暦をグレゴリオorユリウス暦日に変換
      #
      def _to_date_for_note(date)
        return date if date.frame.kind_of?(When::CalendarTypes::Julian)
        When.Calendar(date.to_i < 2299161 ? 'Julian' : 'Gregorian') ^ date
      end

      # 当該年のイベントの日付
      #   date       : 西暦の年数 or When::TM::(Temporal)Position
      #   event      : イベント名 (String)
      #   frame      : 暦法(デフォルトは When.Resource('_c:Gregorian'))
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
        frame ||= When.Resource('_c:Gregorian')
        result  = yield(year, frame)
        return result if date.kind_of?(Numeric)
        return frame.jul_trans(result, options)
      end
    end
  end
end
