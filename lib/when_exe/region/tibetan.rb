# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2012 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  class BasicTypes::M17n

    TibetanTerms = [self, [
      "namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/]",
      "locale:[=en:, ja=ja:, alias]",
      "names:[TibetanTerms]",
      "[Tibetan=en:Tibetan_calendar, 時輪暦=ja:%E3%83%81%E3%83%99%E3%83%83%E3%83%88%E6%9A%A6]",

      [self,
        "names:[IntercalaryMonth=en:Intercalation, 閏月]",
        "[%s=,       %s宿月=  ]",
        "[Adika %s=, 閏%s宿月=]"
      ],

      [self,
        "names:[IntercalaryDay=en:Intercalation, 閏日=ja:%E9%96%8F]",
        "[Double %s=,      欠=]",
        "[Intercalary %s=, 重=]"
      ],

      [self,
        "names:[Month, 月=ja:%E6%9C%88_(%E6%9A%A6)]",
        "[Margasirsa, 觜=]",
        "[Pausha,     鬼=]",
        "[Magha,      星=]",
        "[Phalguna,   翼=]",
        "[Chaitra,    角=]",
        "[Vaisakha,   氐=]",
        "[Jyeshta,    心=]",
        "[Ashada,     箕=]",
        "[Sravana,    牛=]",
        "[Bhadrapada, 室=]",
        "[Asvina,     婁=]",
        "[Kartika,    昴=]"
      ]
    ]]
  end

  module CalendarTypes

    #
    # Tibetan Calendar
    #
    class Tibetan < EphemerisBasedLuniSolar

      #
      # 定数
      #
      Y0 = 1827           # 元期の西暦年
      D0 = 2388440        # 元期のユリウス日
      V0 = (6.0+45/60.0)  # 白羊宮入りのオフセット
      Am = (2.0+1.0/126)  # 月の近地点

      Rem  = 1            # 余りのインデックス
      Quot = 0            # 商のインデックス
      Ddd  = 0            # 差分のインデックス
      Sum  = 1            # 積算値のインデックス
      Jm = [              # 月の中心差
        [ 5, 0], [ 5, 5], [ 5,10], [ 5,15], [ 4,19], [ 3,22], [ 2,24],
        [ 1,25], [-1,24], [-2,22], [-3,19], [-4,15], [-5,10], [-5, 5],
        [-5, 0], [-5,-5]
      ]
      Js = [   # 太陽の中心差
        [ 6, 0], [ 6, 6], [ 4,10], [ 1,11], [-1,10], [-4, 6], [-6, 0],
        [-6,-6]
      ]

      private

      # オブジェクトの正規化
      #
      #    @type      = 体系派なら 1, 作用派なら 2
      #    @parameter = 太陽と月の位相計算用のテーブル
      #
      def _normalize(args=[], options={})
        intercalary_month = When.Resource('_m:TibetanTerms::IntercalaryMonth::*')
        intercalary_day   = When.Resource('_m:TibetanTerms::IntercalaryDay::*')
        @indices ||= [
          Coordinates::Index.new({:branch=>{0=>intercalary_month[0], 1=>intercalary_month[1]},
                                  :trunk=>When.Resource('_m:TibetanTerms::Month::*'), :shift=>2}),
          Coordinates::Index.new({:branch=>{-2=>intercalary_day[0], -1=>intercalary_day[1]}})
        ]
        @label       ||= When.Resource('_m:TibetanTerms::Tibetan')
        @epoch_in_CE ||= 0
        @type        ||= 1
        @parameter = case @type.to_i
          when 1
            {'M0'=>(60+15),
             'Wo'=>Z(29,31,50,0,480),
             'W0'=>Z( 3,37,43,2,140),
             'Wd'=>Z( 0,59, 3,4, 16),
             'So'=>K( 2,10,58,1, 17),
             'S0'=>K(24,59, 6,1, 41),
             'Sd'=>K( 0, 4,21,5, 43),
             'A0'=>22.0
            }
          when 2
            {'M0'=>(64+15),
             'Wo'=>Z(29,31,50,0,  0),
             'W0'=>Z( 3,21,20,0,  0),
             'Wd'=>Z( 0,59, 3,4,  0),
             'So'=>L( 2,10,58,2, 10),
             'S0'=>L(25,42,12,1, 11),
             'Sd'=>L( 0, 4,21,5,  9),
             'A0'=>(22.0+28.0/126)
            }
          end
        super
      end

      # @private
      def Z(z,q,d,m,s)
        ((((s/707.0+m)/6.0+d)/60.0+q)/60.0+z)
      end

      # @private
      def K(k,q,d,m,s)
        ((((s/67.0+m)/6.0+d)/60.0+q)/60.0+k)
      end

      # @private
      def L(k,q,d,m,s)
        ((((s/13.0+m)/6.0+d)/60.0+q)/60.0+k)
      end

      #
      # 太陽または月の位置の中心差による差分
      # @private
      def _sn(t,m,p)
        t0 = t.floor
        r  = t0.divmod(m)
        s  = (1.0/60.0)
        s  = -s unless r[Quot] % 2 == 0
        return s * (p[r[Rem]][Sum] + (t-t0) * p[r[Rem]+1][Ddd])
      end

      # 積月計算
      #
      # @param  [Integer] y 年
      # @param  [Integer] m 年(デフォルト 0)
      #
      # @return [Integer] 積月
      #
      #   m に 0 以外を指定することで、積月の跳び(閏)を検出できる
      #
      def _new_year_month_(y, m=0)
        mm = (y-Y0) * 12 + (m - 2)
        mm += (mm * 2 + @parameter['M0']).divmod(65)[Quot]
        return mm
      end

      # 月初の通日
      #
      # @param  [Integer] m 通月
      #
      # @return [Integer] 月初の通日
      #
      def _new_month_(m)
        sdn = [0,-1].map {|d| _new_month_day(m, d)}
        sdn[0]-sdn[1] == 1 ? sdn[0] : sdn[0]-1
      end

      #
      # 積日計算
      #
      # @param  [Integer] m 通月
      # @param  [Integer] d 日
      #
      # @return [Integer] 積日
      #
      #   積日の跳び(重日)、ダブり(欠日)を検出できる
      #
      def _new_month_day_(m, d)
        d   += 1
        w    = m * @parameter['Wo'] + @parameter['W0'] + d * @parameter['Wd']  # 中曜
        s    = m * @parameter['So'] + @parameter['S0'] + d * @parameter['Sd']  # 中日
        sdn  = D0 + w
        sdn += _sn(m*Am+@parameter['A0']+d, 14, Jm)
        sdn -= _sn((s-V0)*(60.0/135.0), 6, Js)
        return sdn.floor
      end

      #
      # 日時要素の翻訳表の取得
      #
      # @overload _ids_(date)
      #   @param [Array<Numeric>] date ( 年 )
      #   @return [Array<When::Coordinates::Pair>] 1年の月の配置の翻訳表
      #
      # @overload _ids_(date)
      #   @param [Array<Numeric>] date ( 年 月 )
      #   @return [Array<When::Coordinates::Pair>] 1月の日の配置の翻訳表
      #   @note 月は 0 始まりの通番
      #
      def _ids_(date)
        y, m = date
        y    = +y
        mm   = _new_year_month(y)
        return (_table(mm, 12, 0, 1) {|i| _new_year_month(y,i)}) unless m
        mm  += m
        table = _table(_new_month_day(mm,0), 30, 1, 0) {|i| _new_month_day(mm,i)}
        table[1,0] =  Pair._force_pair(1,1) unless _new_month(mm) == _new_month_day(mm,0)
        return table
      end

      # 日時要素の翻訳表の作成
      # @private
      def _table(b0, n, k0, k1)
        table = [Pair._force_pair(1,0)]
        (1..n).each do |i|
          b1 = yield(i)
          case b1-b0
          when 0 ; table[-1] = Pair._force_pair(i, -2)
          when 1 ; table << Pair._force_pair(i+1, 0 )
          when 2 ; table << Pair._force_pair(i+k0,k1) << Pair._force_pair(i+1, k0)
          else   ; raise ArgumentError, "Irregal date span: #{b1-b0}"
          end
          b0 =  b1
        end
        table.pop while table[-1].trunk > n
        return table
      end
    end
  end
end
