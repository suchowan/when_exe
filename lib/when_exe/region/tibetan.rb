# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2015 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  class BasicTypes::M17n

    Tibetan = [self, [
      "locale:[=en:, ja=ja:, zh=zh:, hi=hi:, alias]",
      "names:[Tibetan=en:Tibetan_calendar, 時輪暦=ja:%%<チベット暦>, 藏曆]",

      [self,
        "names:[Month=, 月=, *alias:IntercalaryMonth=en:Intercalation]",
        "[%s=,        %s宿月=,   %s宿月=,   _IAST_=]",
        "[adhika %s=, 閏%s宿月=, 閏%s宿月=, _IAST_=]"
      ],

      [self,
        "names:[IntercalaryDay=en:Intercalation, 閏日=ja:%%<閏>]",
        "[%s and next day=, %sと翌日=, %s和第二天=]",
        "[Intercalary %s=,  重%s=,     重%s=      ]"
      ],

      [self,
        "names:[Month, 月=ja:%%<月_(暦)>]",
        "[Mārgaśīra=en:Margashirsha,   觜=ja:%%<觜宿>, 觜=zh:%%<觜宿>, _IAST_=]",
        "[Pauṣa=en:Pausha,             鬼=ja:%%<鬼宿>, 鬼=zh:%%<鬼宿>, _IAST_=]",
        "[Māgha=en:Maagha,             星=ja:%%<星宿>, 星=zh:%%<星宿>, _IAST_=]",
        "[Phālguna=en:Phalguna,        翼=ja:%%<翼宿>, 翼=zh:%%<翼宿>, _IAST_=]",
        "[Caitra=en:Chaitra,           角=ja:%%<角宿>, 角=zh:%%<角宿>, _IAST_=]",
        "[Vaiśākha=en:Vaisakha,        氐=ja:%%<氐宿>, 氐=zh:%%<氐宿>, _IAST_=]",
        "[Jyaiṣṭha=en:Jyeshta,         心=ja:%%<心宿>, 心=zh:%%<心宿>, _IAST_=]",
        "[Āṣāḍha=en:Aashaadha,         箕=ja:%%<箕宿>, 箕=zh:%%<箕宿>, _IAST_=]",
        "[Śrāvaṇa=en:Shraavana,        牛=ja:%%<牛宿>, 牛=zh:%%<牛宿>, _IAST_=]",
        "[Bhādrapada=en:Bhadrapada,    室=ja:%%<室宿>, 室=zh:%%<室宿>, _IAST_=]",
        "[Āśvina=en:Ashwin,            婁=ja:%%<婁宿>, 婁=zh:%%<婁宿>, _IAST_=]",
        "[Kārttika=en:Kartika_(month), 昴=ja:%%<昴宿>, 昴=zh:%%<昴宿>, _IAST_=]"
      ]
    ]]
  end

  module Coordinates
  
    # 六十干支
    Tibetan = [When::BasicTypes::M17n, [
      "locale:[=en:, ja=ja:, alias]",
      "names:[Tibetan]",
  
      [StemBranch,
        "label:[Stem-Branch, *干支]", "divisor:60", "day:11", "year:4",
        [StemBranch, "label:[Wood-Rat=,      *木男鼠=]", "remainder: 0"],
        [StemBranch, "label:[Wood-Ox=,       *木女牛=]", "remainder: 1"],
        [StemBranch, "label:[Fire-Tiger=,    *火男虎=]", "remainder: 2"],
        [StemBranch, "label:[Fire-Rabbit=,   *火女兎=]", "remainder: 3"],
        [StemBranch, "label:[Earth-Dragon=,  *土男龍=]", "remainder: 4"],
        [StemBranch, "label:[Earth-Snake=,   *土女蛇=]", "remainder: 5"],
        [StemBranch, "label:[Iron-Horse=,    *金男馬=]", "remainder: 6"],
        [StemBranch, "label:[Iron-Goat=,     *金女羊=]", "remainder: 7"],
        [StemBranch, "label:[Water-Monkey=,  *水男猴=]", "remainder: 8"],
        [StemBranch, "label:[Water-Rooster=, *水女鷄=]", "remainder: 9"],
        [StemBranch, "label:[Wood-Dog=,      *木男狗=]", "remainder:10"],
        [StemBranch, "label:[Wood-Pig=,      *木女猪=]", "remainder:11"],
        [StemBranch, "label:[Fire-Rat=,      *火男鼠=]", "remainder:12"],
        [StemBranch, "label:[Fire-Ox=,       *火女牛=]", "remainder:13"],
        [StemBranch, "label:[Earth-Tiger=,   *土男虎=]", "remainder:14"],
        [StemBranch, "label:[Earth-Rabbit=,  *土女兎=]", "remainder:15"],
        [StemBranch, "label:[Iron-Dragon=,   *金男龍=]", "remainder:16"],
        [StemBranch, "label:[Iron-Snake=,    *金女蛇=]", "remainder:17"],
        [StemBranch, "label:[Water-Horse=,   *水男馬=]", "remainder:18"],
        [StemBranch, "label:[Water-Goat=,    *水女羊=]", "remainder:19"],
        [StemBranch, "label:[Wood-Monkey=,   *木男猴=]", "remainder:20"],
        [StemBranch, "label:[Wood-Rooster=,  *木女鷄=]", "remainder:21"],
        [StemBranch, "label:[Fire-Dog=,      *火男狗=]", "remainder:22"],
        [StemBranch, "label:[Fire-Pig=,      *火女猪=]", "remainder:23"],
        [StemBranch, "label:[Earth-Rat=,     *土男鼠=]", "remainder:24"],
        [StemBranch, "label:[Earth-Ox=,      *土女牛=]", "remainder:25"],
        [StemBranch, "label:[Iron-Tiger=,    *金男虎=]", "remainder:26"],
        [StemBranch, "label:[Iron-Rabbit=,   *金女兎=]", "remainder:27"],
        [StemBranch, "label:[Water-Dragon=,  *水男龍=]", "remainder:28"],
        [StemBranch, "label:[Water-Snake=,   *水女蛇=]", "remainder:29"],
        [StemBranch, "label:[Wood-Horse=,    *木男馬=]", "remainder:30"],
        [StemBranch, "label:[Wood-Goat=,     *木女羊=]", "remainder:31"],
        [StemBranch, "label:[Fire-Monkey=,   *火男猴=]", "remainder:32"],
        [StemBranch, "label:[Fire-Rooster=,  *火女鷄=]", "remainder:33"],
        [StemBranch, "label:[Earth-Dog=,     *土男狗=]", "remainder:34"],
        [StemBranch, "label:[Earth-Pig=,     *土女猪=]", "remainder:35"],
        [StemBranch, "label:[Iron-Rat=,      *金男鼠=]", "remainder:36"],
        [StemBranch, "label:[Iron-Ox=,       *金女牛=]", "remainder:37"],
        [StemBranch, "label:[Water-Tiger=,   *水男虎=]", "remainder:38"],
        [StemBranch, "label:[Water-Rabbit=,  *水女兎=]", "remainder:39"],
        [StemBranch, "label:[Wood-Dragon=,   *木男龍=]", "remainder:40"],
        [StemBranch, "label:[Wood-Snake=,    *木女蛇=]", "remainder:41"],
        [StemBranch, "label:[Fire-Horse=,    *火男馬=]", "remainder:42"],
        [StemBranch, "label:[Fire-Goat=,     *火女羊=]", "remainder:43"],
        [StemBranch, "label:[Earth-Monkey=,  *土男猴=]", "remainder:44"],
        [StemBranch, "label:[Earth-Rooster=, *土女鷄=]", "remainder:45"],
        [StemBranch, "label:[Iron-Dog=,      *金男狗=]", "remainder:46"],
        [StemBranch, "label:[Iron-Pig=,      *金女猪=]", "remainder:47"],
        [StemBranch, "label:[Water-Rat=,     *水男鼠=]", "remainder:48"],
        [StemBranch, "label:[Water-Ox=,      *水女牛=]", "remainder:49"],
        [StemBranch, "label:[Wood-Tiger=,    *木男虎=]", "remainder:50"],
        [StemBranch, "label:[Wood-Rabbit=,   *木女兎=]", "remainder:51"],
        [StemBranch, "label:[Fire-Dragon=,   *火男龍=]", "remainder:52"],
        [StemBranch, "label:[Fire-Snake=,    *火女蛇=]", "remainder:53"],
        [StemBranch, "label:[Earth-Horse=,   *土男馬=]", "remainder:54"],
        [StemBranch, "label:[Earth-Goat=,    *土女羊=]", "remainder:55"],
        [StemBranch, "label:[Iron-Monkey=,   *金男猴=]", "remainder:56"],
        [StemBranch, "label:[Iron-Rooster=,  *金女鷄=]", "remainder:57"],
        [StemBranch, "label:[Water-Dog=,     *水男狗=]", "remainder:58"],
        [StemBranch, "label:[Water-Pig=,     *水女猪=]", "remainder:59"]
      ]
    ]]
  end

  class CalendarNote
    Tibetan = [['Tibetan::干支'], ['_m:Calendar::Month'], ['Common::Week']]
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
        intercalary_month = When.Resource('_m:Tibetan::IntercalaryMonth::*')
        intercalary_day   = When.Resource('_m:Tibetan::IntercalaryDay::*')
      # trunk_of_day      = (1..30).to_a.map {|d| When.m17n(d.to_s)}
        @indices ||= @index_of_MSC && @index_of_MSC.to_i == 1 ? 
          [
            When.Index({:unit=>60}),
            When.Index('Tibetan::Month', {:branch=>{0=>intercalary_month[0], 1=>intercalary_month[1]}, :shift=>2}),
            When.Index({:branch=>{-2=>intercalary_day[0], +1=>intercalary_day[1]}})
          ] :
          [
            When.Index('Tibetan::Month', {:branch=>{0=>intercalary_month[0], 1=>intercalary_month[1]}, :shift=>2}),
            When.Index({:branch=>{-2=>intercalary_day[0], +1=>intercalary_day[1]}})
          ]
        @label      ||= 'Tibetan::Tibetan'
        @diff_to_CE ||= 0
        @type       ||= 1
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
        @note = 'Tibetan'
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
