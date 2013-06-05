# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When

  class BasicTypes::M17n

    ChineseTerms = [self, [
      "namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/]",
      "locale:[=ja:, en=en:, alias]",
      "names:[ChineseTerms]",
      "[中国太陽暦(節月)=ja:%E4%BA%8C%E5%8D%81%E5%9B%9B%E7%AF%80%E6%B0%97#.E6.9A.A6.E6.9C.88.E3.81.A8.E7.AF.80.E6.9C.88, *ChineseSolar=en:Solar_term]",
      "[中国太陰太陽暦=ja:%E4%B8%AD%E5%9B%BD%E6%9A%A6, *ChineseLuniSolar=en:Chinese_calendar]",
      "[彝暦=ja:%E3%82%A4%E6%97%8F, *Yi=en:Yi_people]",

      [self,
        "names:[月=ja:%E6%9C%88_(%E6%9A%A6), *Month]",
        "[正月,   1st Month= ]",
        "[二月,   2nd Month= ]",
        "[三月,   3rd Month= ]",
        "[四月,   4th Month= ]",
        "[五月,   5th Month= ]",
        "[六月,   6th Month= ]",
        "[七月,   7th Month= ]",
        "[八月,   8th Month= ]",
        "[九月,   9th Month= ]",
        "[十月,   10th Month=]",
        "[十一月, 11th Month=]",
        "[十二月, 12th Month=]"
      ],

      [self,
        "names:[月=ja:%E6%9C%88_(%E6%9A%A6), *MonthA]",
        "[一月,   1st Month= ]",
        "[二月,   2nd Month= ]",
        "[三月,   3rd Month= ]",
        "[四月,   4th Month= ]",
        "[五月,   5th Month= ]",
        "[六月,   6th Month= ]",
        "[七月,   7th Month= ]",
        "[八月,   8th Month= ]",
        "[九月,   9th Month= ]",
        "[十月,   10th Month=]",
        "[正月,   New Year Month=]",
        "[臘月,   12th Month=]"
      ],

      [self,
        "names:[月=ja:%E6%9C%88_(%E6%9A%A6), *MonthB]",
        "[建寅月, 3rd Month= ]",
        "[建卯月, 4th Month= ]",
        "[建辰月, 5th Month= ]",
        "[建巳月, 6th Month= ]",
        "[建午月, 7th Month= ]",
        "[建未月, 8th Month= ]",
        "[建申月, 9th Month= ]",
        "[建酉月, 10th Month ]",
        "[建戌月, 11th Month ]",
        "[建亥月, 12th Month=]",
        "[建子月, 1st Month= ]",
        "[建丑月, 2nd Month= ]"
      ]
    ]]

    YiTerms = [self, [
      "namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/]",
      "locale:[=ja:, en=en:, alias]",
      "names:[YiTerms]",

      [self,
        "names:[月=ja:%E6%9C%88_(%E6%9A%A6), *Month]",
        "[木公月, 1st Month= ]",
        "[木母月, 2nd Month= ]",
        "[火公月, 3rd Month= ]",
        "[火母月, 4th Month= ]",
        "[土公月, 5th Month= ]",
        "[土母月, 6th Month= ]",
        "[銅公月, 7th Month= ]",
        "[銅母月, 8th Month= ]",
        "[水公月, 9th Month= ]",
        "[水母月, 10th Month=]",
        "[過年日, end of year days=]"
      ]
    ]]
  end

  module Coordinates

    # Yi years
    Yi = [When::BasicTypes::M17n, [
      "namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/]",
      "locale:[=ja:, en=en:, alias]",
      "names:[Yi]",

      [Residue,
        "label:[YearName]", "divisor:8", "year:0",
        [Residue, "label:[東北之年=, NorthEastYear=]", "remainder:  0"],
        [Residue, "label:[東方之年=, EastYear=     ]", "remainder:  1"],
        [Residue, "label:[東南之年=, SouthEastYear=]", "remainder:  2"],
        [Residue, "label:[南方之年=, SouthYear=    ]", "remainder:  3"],
        [Residue, "label:[西南之年=, SouthWestYear=]", "remainder:  4"],
        [Residue, "label:[西方之年=, WestYear=     ]", "remainder:  5"],
        [Residue, "label:[西北之年=, NorthWestYear=]", "remainder:  6"],
        [Residue, "label:[北方之年=, NorthYear=    ]", "remainder:  7"]
      ]
    ]]
  end

  module Ephemeris

    #
    # Chinese Luni-Solar Calendar Formula for True Lunation Type
    #
    class ChineseTrueLunation < MeanLunation

      # 太陽の位置補正表
      # @return [Array<Array< 入気定日加減数, 朓朒数, 損益率, 損益率増分 >>]
      attr_reader :s

      # 月の位置補正表
      # @return [Array<Array< 区間の時間／分, 損益率 >>]
      attr_reader :m

      # 近点月
      # @return [Numeric]
      attr_reader :anomalistic_month_length

      # 元期の近点離隔
       # @return [Numeric]
     attr_reader :anomalistic_month_shift

      private

      # 周期番号 -> 日時
      #
      # @param [Numeric] cn 周期番号
      #
      # @return [Numeric] ユリウス日
      #
      def cn_to_time_(cn, time0=nil)
        time = super
        return time unless @formula == '1L'
        t = time - @day_epoch
        time + (delta_s(t.divmod(@year_length)[1]) + delta_m(t.divmod(@anomalistic_month_length)[1])).to_r / @denominator
      end

      #
      # 朔の日時の太陽運動の不斉による補正
      #
      # @param [Numeric] t 直前の冬至からの日数
      #
      # @return [Numeric] 補正量 / @denominator
      #
      def delta_s(t)

        tt = t

        t0, a, b, c = nil
        @s.each do |v|
          t0, a, b, c = v
          break if t <= t0
          t -= t0
        end

        # ２４気からの日数 (大余, 小余)
        t, dt = t.divmod(1)
        dt    = (dt * @denominator).to_i

        # 損益率
        b0 = (b + c * t).to_i

        # 朓朒数
        a0 = (a + b * t + c * t * (t-1.0)/2).to_i

        # 補正値
        a0 + (b0.to_f * dt / @denominator + 0.5).floor
      end

      #
      # 朔の日時の月運動の不斉による補正
      #
      # @param [Numeric] t 直前の遠/近地点からの日数
      #
      # @return [Numeric] 補正量 / @denominator
      #
      def delta_m(t)

        tt = t

        t *= @denominator
        a0 = b0 = t0 = 0
        @m.each do |v|
          t0, b0 = v
          break if t <= t0
          t  -= t0
          a0 += b0
        end

        # 補正値
        a0 + (b0.to_f * t.to_i / t0.to_i + 0.5).floor
      end

      # オブジェクトの正規化
      def _normalize(args=[], options={})
        super
        if @formula == '1L'
          @anomalistic_month_length =  @anomalistic_month_length.to_r
          @anomalistic_month_shift  = (@anomalistic_month_shift||0).to_r
          (0...@s.size).each do |i|
            @s[i-1][1,0] = @year_length / @s.size + (@s[i][0]-@s[i-1][0]) / @denominator
          end
          (0...@s.size).each do |i|
            @s[i].shift
          end
        end
      end
    end
  end

  module CalendarTypes

    #
    # Chinese Solar Calendar
    #
    class ChineseSolar < EphemerisBasedSolar

      private

      # オブジェクトの正規化
      #
      #   @formula      = 太陽黄経の計算に用いるEphemeris
      #
      def _normalize(args=[], options={})
        @label            ||= When.Resource('_m:ChineseTerms::ChineseSolar')
        @formula          ||= ['Formula']
        @formula            = Array(@formula)
        @formula           *= 2 if @formula.length == 1
        @formula[0]        += (@formula[0] =~ /\?/ ? '&' : '?') + 'formula=12S' if @formula[0].kind_of?(String)
        @formula[1]        += (@formula[1] =~ /\?/ ? '&' : '?') + 'formula=1L'  if @formula[1].kind_of?(String)
        @timezone         ||=  0
        @note             ||= When.CalendarNote('ChineseNotes')
        @indices          ||= [
            When::Coordinates::Index.new({:trunk=>When.Resource('_m:ChineseTerms::Month::*')}),
            When::Coordinates::Index.new
          ]
        super
      end
    end

    #
    # Chinese Luni-Solar Calendar
    #
    class ChineseLuniSolar < EphemerisBasedLuniSolar

      private

      # オブジェクトの正規化
      #
      #   @cycle_offset = 雨水の場合 -1
      #   @formula      = 太陽黄経および月の位相の計算に用いるEphemeris
      #   @timezone[1]  = 進朔量
      #
      def _normalize(args=[], options={})
        @label            ||= When.Resource('_m:ChineseTerms::ChineseLuniSolar')
        @formula          ||= ['Formula']
        @formula            = Array(@formula)
        @formula           *= 2 if @formula.length == 1
        @formula[0]        += (@formula[0] =~ /\?/ ? '&' : '?') + 'formula=12S' if @formula[0].kind_of?(String)
        @formula[1]        += (@formula[1] =~ /\?/ ? '&' : '?') + 'formula=1L'  if @formula[1].kind_of?(String)
        @vernal_month     ||=  2
        @cycle_offset     ||=  @vernal_month - 3
        @base_month       ||= 11
        @intercalary_span ||= 12
        @intercalary_span   =  @intercalary_span.to_i
        @intercalary_month  = (@intercalary_month.to_i - @base_month) % 12 + 1 if @intercalary_month
        @timezone         ||= 0
        @note             ||= When.CalendarNote('ChineseNotes')
        @indices          ||= [
            When::Coordinates::Index.new({:branch=>{1=>When.Resource('_m:CalendarTerms::閏')},
                                          :trunk=>When.Resource('_m:ChineseTerms::Month::*')}),
            When::Coordinates::Index.new
          ]
        super
      end

      # 正月の通月
      #
      # @param  [Integer] y 年
      #
      # @return [Numeric] 正月の通月
      #
      def _new_year_month_(y)
        return _base_month(y) if @base_month == 1
        intercalary = 0
        _ids([y-1]).each do |v|
          unless v.branch == 0
            intercalary = v.trunk
            break
          end
        end
        _base_month(y) - @base_month + (intercalary>=@base_month ? 14 : 13)
      end

      # 天正冬至月の通月
      #
      # @param  [Integer] y 年
      #
      # @return [Numeric] 天正冬至月の通月
      #
      def _base_month_(y)
        (Residue.mod((@formula[0].cn_to_time(12*(y-1) + @base_month - @vernal_month) +
          0.5 + @timezone[0]).floor) {|m|
          _new_month(m)
        })[0]
      end

      # 暦年の翻訳表の取得
      #
      # @param [Array<Numeric>] date ( 年 )
      #
      # @return [When::Coordinates::Pair] 暦年の翻訳表
      #
      def _ids_(date)
        y = +date[0]
        return _base_ids(y) if @base_month == 1
        (_base_ids(y).dup.delete_if {|v| v.trunk >= @base_month}) + (_base_ids(y+1).dup.delete_if {|v| v.trunk < @base_month})
      end

      # 天正冬至月から1年分の翻訳表の取得
      #
      # @param [Numeric] y 年
      #
      # @return [When::Coordinates::Pair]
      #     天正冬至月から1年分の翻訳表
      #
      def _base_ids_(y)
        _intercalary_pattern(y,12)[1..-1].inject([Pair._force_pair(@base_month, 0)]) do |base_ids, flag|
          base_ids << (flag ? Pair._force_pair(base_ids[-1].trunk, 1) : Pair._force_pair(base_ids[-1].trunk % 12 + 1, 0))
        end
      end

      # 天正冬至月から1年分の閏月のパターンの取得
      #
      # @param [Numeric] y 年
      #
      # @return [Boolean]
      #   [ true  - 閏月である ]
      #   [ false - 閏月でない ]
      #
      def _intercalary_pattern(y, n)
        m0 = _base_month(y)
        m1 = _base_month(y + n/12.0)
        return Array.new(n, false) if m1-m0 == n
        return Array.new(n+1) {|i| i==@intercalary_month} if @intercalary_month # for 四分暦
        return _intercalary_pattern(y, n/2) + _intercalary_pattern(y + n/24.0, n/2) if n > @intercalary_span
        flags = Array.new(n+1, false)
        n.times do |i|
          m0 += 1
          if _intercalary?(m0)
            flags[i+1] = true
            return flags
          end
        end
        raise ArgumentError, "Intercalary month not found"
      end

      #  指定の月の中気の有無
      #
      # @param [Numeric] m 通月
      #
      # @return [Boolean]
      #   [ true  - 中気無し ]
      #   [ false - 中気有り ]
      #
      def _intercalary?(m)
        e = _new_month(m+1) - 1
        d = Residue.mod(e) {|n| _new_epoch(n)}
        e - d[1] < _new_month(m)
      end
    end

    Chinese = [When::BasicTypes::M17n, [
      "namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/]",
      "locale:[=ja:, en=en:, alias]",
      "area:[中国,China]",

      [ChineseLuniSolar,
        'name:[黄帝暦]',
        'formula:MeanLunation?year_length=1461/4&lunation_length=27759/940&day_epoch=1228331',
        'intercalary_month:12'
      ],

      [ChineseLuniSolar,
        'name:[顓頊暦]',
        'formula:MeanLunation?year_length=1461/4&lunation_length=27759/940&day_epoch=1171396&longitude_shift=-1/8',
        'timezone:0,+12',
        'intercalary_month:9'
      ],

      [ChineseLuniSolar,
        'name:[夏暦]',
        'formula:MeanLunation?year_length=1461/4&lunation_length=27759/940&day_epoch=1328411',
        'intercalary_month:12'
      ],

      [ChineseLuniSolar,
        'name:[殷暦]',
        'formula:MeanLunation?year_length=1461/4&lunation_length=27759/940&day_epoch=1149071',
        'intercalary_month:12'
      ],

      [ChineseLuniSolar,
        'name:[周暦]',
        'formula:MeanLunation?year_length=1461/4&lunation_length=27759/940&day_epoch=1128251',
        'intercalary_month:12'
      ],

      [ChineseLuniSolar,
        'name:[魯暦]',
        'formula:MeanLunation?year_length=1461/4&lunation_length=27759/940&day_epoch=1048991',
        'intercalary_month:12'
      ],

      [ChineseLuniSolar,
        'name:[太初暦]',
        'formula:MeanLunation?year_length=562120/1539&lunation_length=2392/81&day_epoch=1683431'
      ],

      [ChineseLuniSolar,
        'name:[四分暦]',
        'formula:MeanLunation?year_length=1461/4&lunation_length=27759/940&day_epoch=1662611'
      ],

      [ChineseLuniSolar,
        'name:[乾象暦]',
        'formula:MeanLunation?year_length=215130/589&lunation_length=43026/1457&day_epoch=-898129'
      ],

      [ChineseLuniSolar,
        'name:[景初暦]',
        'formula:MeanLunation?year_length=673150/1843&lunation_length=134630/4559&day_epoch=+330191'
      ],

      [ChineseLuniSolar,
        'name:[三紀暦]',
        'formula:MeanLunation?year_length=895220/2451&lunation_length=179044/6063&day_epoch=-28760989'
      ],

      [ChineseLuniSolar,
        'name:[玄始暦]',
        'formula:MeanLunation?year_length=2629759/7200&lunation_length=2629759/89052&day_epoch=-20568349'
      ],

      [ChineseLuniSolar,
        'name:[元嘉暦]',
        'formula:MeanLunation?year_length=111035/304&lunation_length=22207/752&day_epoch=-200089&longitude_shift=-1/12' # 春分の1ヶ月前
      ],

      [ChineseLuniSolar,
        'name:[大明暦]',
        'formula:MeanLunation?year_length=14423804/39491&lunation_length=116321/3939&day_epoch=-17080189'
      ],

      [ChineseLuniSolar,
        'name:[正光暦]',
        'formula:MeanLunation?year_length=2213377/6060&lunation_length=2213377/74952&day_epoch=-59357929'
      ],

      [ChineseLuniSolar,
        'name:[興和暦]',
        'formula:MeanLunation?year_length=6158017/16860&lunation_length=6158017/208530&day_epoch=-105462049'
      ],

      [ChineseLuniSolar,
        'name:[天保暦]',
        'formula:MeanLunation?year_length=8641687/23660&lunation_length=8641687/292635&day_epoch=-38447089'
      ],

      [ChineseLuniSolar,
        'name:[天和暦]',
        'formula:MeanLunation?year_length=8568631/23460&lunation_length=8568631/290160&day_epoch=-317950249'
      ],

      [ChineseLuniSolar,
        'name:[大象暦]',
        'formula:MeanLunation?year_length=4745247/12992&lunation_length=1581749/53563&day_epoch=-13244449'
      ],

      [ChineseLuniSolar,
        'name:[開皇暦]',
        'formula:MeanLunation?year_length=37605463/102960&lunation_length=5372209/181920&day_epoch=-1506155749'
      ],

      [ChineseLuniSolar,
        'name:[大業暦]',
        'formula:MeanLunation?year_length=15573963/42640&lunation_length=33783/1144&day_epoch=-519493909'
      ],

      [ChineseLuniSolar,
        'name:[儀鳳暦]',
        'formula:MeanLunation?year_length=122357/335&lunation_length=39571/1340&day_epoch=-96608689'
      ],

      [ChineseLuniSolar,
        'name:[麟徳暦]',
        {'formula'=>['12S', '1L'].map {|f|
          Ephemeris::ChineseTrueLunation.new({
            'formula'                  => f,
            'day_epoch'                => -96608689,
            'year_length'              => '122357/335',
            'lunation_length'          =>  '39571/1340',
            'anomalistic_month_length' =>  '443077/16080', # 27.0 + (743.0+1.0/12)/1340,
            's'                        => [
              [    0.0,     0,  +3.9546, -0.0372], # 冬至
              [ -722.0,   +54,  +3.4091, -0.0372], # 大寒
              [-1340.0,  +100,  +2.8636, -0.0372], # 小寒
              [-1854.0,  +138,  +2.3181, +0.0372], # 立春
              [-2368.0,  +176,  +2.8636, +0.0372], # 雨水
              [-2986.0,  +222,  +3.4091, +0.0372], # 啓蟄
              [-3708.0,  +276,  -3.7220, +0.0329], # 春分
              [-2986.0,  +222,  -3.2086, +0.0329], # 清明
              [-2368.0,  +176,  -2.6952, +0.0329], # 穀雨
              [-1854.0,  +138,  -2.1818, -0.0329], # 立夏
              [-1340.0,  +100,  -2.6952, -0.0329], # 小満
              [ -722.0,   +54,  -3.2086, -0.0329], # 芒種
              [    0.0,     0,  -3.7220, +0.0329], # 夏至
              [ +722.0,   -54,  -3.2086, +0.0329], # 小暑
              [+1340.0,  -100,  -2.6952, +0.0329], # 大暑
              [+1854.0,  -138,  -2.1818, -0.0329], # 立秋
              [+2368.0,  -176,  -2.6952, -0.0329], # 処暑
              [+2986.0,  -222,  -3.2086, -0.0329], # 白露
              [+3708.0,  -276,  +3.9546, -0.0372], # 秋分
              [+2986.0,  -222,  +3.4091, -0.0372], # 寒露
              [+2368.0,  -176,  +2.8636, -0.0372], # 霜降
              [+1854.0,  -138,  +2.3181, +0.0372], # 立冬
              [+1340.0,  -100,  +2.8636, +0.0372], # 小雪
              [ +722.0,   -54,  +3.4091, +0.0372], # 大雪
            ],
            'm'                       => [
              [1340.0,   -134],                    #   １日
              [1340.0,   -117],                    #   ２日
              [1340.0,    -99],                    #   ３日
              [1340.0,    -78],                    #   ４日
              [1340.0,    -56],                    #   ５日
              [1340.0,    -33],                    #   ６日
              [1191.0,     -9],                    #   ７日
              [ 149.0,      0],                    #   ７日
              [1340.0,    +14],                    #   ８日
              [1340.0,    +38],                    #   ９日
              [1340.0,    +62],                    #   10日
              [1340.0,    +85],                    #   11日
              [1340.0,   +104],                    #   12日
              [1340.0,   +121],                    #   13日
              [1042.0,   +102],                    #   14日
              [ 298.0,    +29],                    #   14日
              [1340.0,   +128],                    #   15日
              [1340.0,   +115],                    #   16日
              [1340.0,    +95],                    #   17日
              [1340.0,    +74],                    #   18日
              [1340.0,    +52],                    #   19日
              [1340.0,    +28],                    #   20日
              [ 892.0,     +4],                    #   21日
              [ 448.0,      0],                    #   21日
              [1340.0,    -20],                    #   22日
              [1340.0,    -44],                    #   23日
              [1340.0,    -68],                    #   24日
              [1340.0,    -89],                    #   25日
              [1340.0,   -108],                    #   26日
              [1340.0,   -125],                    #   27日
              [ 743.0+1.0/12, -71]                 #   28日
            ]
          })
        }}
      ],

      [ChineseLuniSolar,
        'name:[大衍暦]',
        'timezone:0,+6',
        {'formula'=>['12S', '1L'].map {|f|
          Ephemeris::ChineseTrueLunation.new({
            'formula'                  => f,
            'day_epoch'                => -35412747829,
            'year_length'              => '1110343/3040',
            'lunation_length'          =>   '89773/3040',
            'anomalistic_month_length' =>  '6701279/243200', # 27.0 +(1685.0+79.0/80)/3040,
            'anomalistic_month_shift'  =>  '1/2',
            's'                        => [
              [    0.0,     0, +13.4524, -0.1886], # 冬至
              [-2353.0,  +176, +10.5564, -0.1634], # 大寒
              [-4198.0,  +314,  +8.0408, -0.1446], # 小寒
              [-5588.0,  +418,  +5.8160, -0.1318], # 立春
              [-6564.0,  +491,  +3.7987, -0.1240], # 雨水
              [-7152.0,  +535,  +1.9265, -0.1240], # 啓蟄
              [-7366.0,  +551,  -0.2048, -0.1178], # 春分
              [-7152.0,  +535,  -1.9968, -0.1190], # 清明
              [-6564.0,  +491,  -3.7956, -0.1240], # 穀雨
              [-5588.0,  +418,  -5.6626, -0.1324], # 立夏
              [-4198.0,  +314,  -7.6555, -0.1436], # 小満
              [-2353.0,  +176,  -9.9405, -0.1436], # 芒種
              [    0.0,     0, -12.0819, +0.1436], # 夏至
              [+2353.0,  -176,  -9.7018, +0.1324], # 小暑
              [+4198.0,  -314,  -7.5450, +0.1240], # 大暑
              [+5588.0,  -418,  -5.5634, +0.1190], # 立秋
              [+6564.0,  -491,  -3.7038, +0.1178], # 処暑
              [+7152.0,  -535,  -1.8954, +0.1178], # 白露
              [+7366.0,  -551,  +0.1783, +0.1240], # 秋分
              [+7152.0,  -535,  +2.0042, +0.1318], # 寒露
              [+6564.0,  -491,  +3.8950, +0.1446], # 霜降
              [+5588.0,  -418,  +5.9214, +0.1634], # 立冬
              [+4198.0,  -314,  +8.1610, +0.1886], # 小雪
              [+2353.0,  -176, +10.9010, +0.1886], # 大雪
            ],
            'm'                       => [
              [3040.0,   +297],                    #   １日
              [3040.0,   +259],                    #   ２日
              [3040.0,   +220],                    #   ３日
              [3040.0,   +180],                    #   ４日
              [3040.0,   +139],                    #   ５日
              [3040.0,    +97],                    #   ６日
              [2701.0,    +48],                    #   ７日
              [ 339.0,     -6],                    #   ７日
              [3040.0,    -64],                    #   ８日
              [3040.0,   -106],                    #   ９日
              [3040.0,   -148],                    #   10日
              [3040.0,   -189],                    #   11日
              [3040.0,   -229],                    #   12日
              [3040.0,   -267],                    #   13日
              [2363.0,   -231],                    #   14日
              [ 677.0,    -66],                    #   14日
              [3040.0,   -289],                    #   15日
              [3040.0,   -250],                    #   16日
              [3040.0,   -211],                    #   17日
              [3040.0,   -171],                    #   18日
              [3040.0,   -130],                    #   19日
              [3040.0,    -87],                    #   20日
              [2024.0,    -36],                    #   21日
              [1016.0,    +18],                    #   21日
              [3040.0,    +73],                    #   22日
              [3040.0,   +116],                    #   23日
              [3040.0,   +157],                    #   24日
              [3040.0,   +198],                    #   25日
              [3040.0,   +237],                    #   26日
              [3040.0,   +276],                    #   27日
              [1686.0,   +165]                     #   28日
            ]
          })
        }}
      ],

      [ChineseLuniSolar,
        'name:[五紀暦]',
        'timezone:0,+6',
        {'formula'=>['12S', '1L'].map {|f|
          Ephemeris::ChineseTrueLunation.new({
            'formula'                  => f,
            'day_epoch'                => -96608689,
            'year_length'              => '122357/335',
            'lunation_length'          =>  '39571/1340',
            'anomalistic_month_length' =>  '1366156/49580', # 27.0 + (743.0+5.0/37)/1340,
            's'                        => [
              [    0.0,     0,  +5.9668, -0.0843], # 冬至
              [-1037.0,   +78,  +4.6652, -0.0721], # 大寒
              [-1850.0,  +139,  +3.5656, -0.0653], # 小寒
              [-2463.0,  +185,  +2.5583, -0.0590], # 立春
              [-2893.0,  +217,  +1.6375, -0.0532], # 雨水
              [-3152.0,  +236,  +0.8384, -0.0532], # 啓蟄
              [-3246.0,  +243,  -0.0972, -0.0505], # 春分
              [-3152.0,  +236,  -0.8480, -0.0534], # 清明
              [-2893.0,  +217,  -1.6517, -0.0561], # 穀雨
              [-2463.0,  +185,  -2.5057, -0.0584], # 立夏
              [-1850.0,  +139,  -3.3781, -0.0643], # 小満
              [-1037.0,   +78,  -4.3954, -0.0643], # 芒種
              [    0.0,     0,  -5.3592, +0.0643], # 夏至
              [+1037.0,   -78,  -4.2877, +0.0584], # 小暑
              [+1850.0,  -139,  -3.3459, +0.0561], # 大暑
              [+2463.0,  -185,  -2.4475, +0.0534], # 立秋
              [+2893.0,  -217,  -1.5966, +0.0505], # 処暑
              [+3152.0,  -236,  -0.8185, +0.0505], # 白露
              [+3246.0,  -243,  +0.0858, +0.0532], # 秋分
              [+3152.0,  -236,  +0.8505, +0.0590], # 寒露
              [+2893.0,  -217,  +1.6943, +0.0653], # 霜降
              [+2463.0,  -185,  +2.6205, +0.0721], # 立冬
              [+1850.0,  -139,  +3.6007, +0.0843], # 小雪
              [+1037.0,   -78,  +4.8330, +0.0843], # 大雪
            ],
            'm'                       => [
              [1340.0,   -135],                    #   １日
              [1340.0,   -117],                    #   ２日
              [1340.0,    -99],                    #   ３日
              [1340.0,    -78],                    #   ４日
              [1340.0,    -56],                    #   ５日
              [1340.0,    -33],                    #   ６日
              [1191.0,     -8],                    #   ７日
              [ 149.0,     +1],                    #   ７日
              [1340.0,    +14],                    #   ８日
              [1340.0,    +38],                    #   ９日
              [1340.0,    +62],                    #   10日
              [1340.0,    +85],                    #   11日
              [1340.0,   +103],                    #   12日
              [1340.0,   +118],                    #   13日
              [1042.0,   +105],                    #   14日
              [ 298.0,    +30],                    #   14日
              [1340.0,   +128],                    #   15日
              [1340.0,   +115],                    #   16日
              [1340.0,    +95],                    #   17日
              [1340.0,    +74],                    #   18日
              [1340.0,    +52],                    #   19日
              [1340.0,    +28],                    #   20日
              [ 892.0,     +6],                    #   21日
              [ 448.0,     -3],                    #   21日
              [1340.0,    -20],                    #   22日
              [1340.0,    -42],                    #   23日
              [1340.0,    -65],                    #   24日
              [1340.0,    -89],                    #   25日
              [1340.0,   -109],                    #   26日
              [1340.0,   -125],                    #   27日
              [ 743.0+5.0/37, -75]                 #   28日
            ]
          })
        }}
      ],

      [ChineseLuniSolar,
        'name:[宣明暦]',
        'timezone:0,+6',
        {'formula'=>['12S', '1L'].map {|f|
          Ephemeris::ChineseTrueLunation.new({
            'formula'                  => f,
            'day_epoch'                => -2580308749,
            'year_length'              => '3068055/8400',
            'lunation_length'          =>  '248057/8400',
            'anomalistic_month_length' =>  '23145819/840000', # 27.0 + 4658.19 / 8400,
            'anomalistic_month_shift'  =>  '1/2',
            's'                        => [
              [     0.0,     0, +33.4511, -0.3695], # 冬至
              [ -6000.0,  +449, +28.0389, -0.3606], # 大寒
              [-11000.0,  +823, +22.6998, -0.3519], # 小寒
              [-15000.0, +1122, +17.8923, -0.4068], # 立春
              [-18000.0, +1346, +11.7966, -0.3998], # 雨水
              [-19800.0, +1481,  +5.7986, -0.3998], # 啓蟄
              [-20400.0, +1526,  -0.2433, -0.3779], # 春分
              [-19800.0, +1481,  -6.1254, -0.3634], # 清明
              [-18000.0, +1346, -12.2048, -0.2987], # 穀雨
              [-15000.0, +1122, -16.9060, -0.2919], # 立夏
              [-11000.0,  +823, -21.5362, -0.2854], # 小満
              [ -6000.0,  +449, -26.0498, -0.2854], # 芒種
              [     0.0,     0, -30.3119, +0.2854], # 夏至
              [ +6000.0,  -449, -25.8126, +0.2919], # 小暑
              [+11000.0,  -823, -21.2454, +0.2987], # 大暑
              [+15000.0, -1122, -17.0296, +0.3634], # 立秋
              [+18000.0, -1346, -11.4744, +0.3779], # 処暑
              [+19800.0, -1481,  -5.6429, +0.3779], # 白露
              [+20400.0, -1526,  +0.1432, +0.3998], # 秋分
              [+19800.0, -1481,  +6.1488, +0.4068], # 寒露
              [+18000.0, -1346, +12.6336, +0.3519], # 霜降
              [+15000.0, -1122, +17.8043, +0.3606], # 立冬
              [+11000.0,  -823, +23.0590, +0.3695], # 小雪
              [ +6000.0,  -449, +28.4618, +0.3695], # 大雪
            ],
            'm'                       => [
              [ 8400.0,   +830],                    # 進１日
              [ 8400.0,   +726],                    #   ２日
              [ 8400.0,   +606],                    #   ３日
              [ 8400.0,   +471],                    #   ４日
              [ 8400.0,   +337],                    #   ５日
              [ 8400.0,   +202],                    #   ６日
              [ 7465.0,    +53],                    #   ７日
              [  935.0,     -7],                    #   ７日
              [ 8400.0,    -82],                    #   ８日
              [ 8400.0,   -224],                    #   ９日
              [ 8400.0,   -366],                    #   10日
              [ 8400.0,   -509],                    #   11日
              [ 8400.0,   -643],                    #   12日
              [ 8400.0,   -748],                    #   13日
              [ 6529.095, -646],                    #   14日
              [ 8400.0,   -830],                    # 退１日
              [ 8400.0,   -726],                    #   ２日
              [ 8400.0,   -598],                    #   ３日
              [ 8400.0,   -464],                    #   ４日
              [ 8400.0,   -329],                    #   ５日
              [ 8400.0,   -195],                    #   ６日
              [ 7465.0,    -53],                    #   ７日
              [  935.0,     +7],                    #   ７日
              [ 8400.0,    +82],                    #   ８日
              [ 8400.0,   +225],                    #   ９日
              [ 8400.0,   +366],                    #   10日
              [ 8400.0,   +501],                    #   11日
              [ 8400.0,   +628],                    #   12日
              [ 8400.0,   +740],                    #   13日
              [ 6529.095, +646]                     #   14日
            ]
          })
        }}
      ],

      [ChineseSolar,
        'name:[前貞享暦(節月)]',
        'formula:VariableYearLengthMethod?day_epoch=2336118.675000&year_epoch=1684&year_length=365.241696&year_delta=1'
      ],

      [ChineseSolar,
        'name:[貞享暦(節月)]',
        'formula:VariableYearLengthMethod?day_epoch=2336118.689990&year_epoch=1684&year_length=365.241696&year_delta=1'
      ],

      [ChineseSolar,
        'name:[前々宝暦暦(節月)]',
        'formula:VariableYearLengthMethod?day_epoch=2336118.903800&year_epoch=1684&year_length=365.241696&year_delta=1'
      ],

      [ChineseSolar,
        'name:[前宝暦暦(節月)]',
        'formula:VariableYearLengthMethod?day_epoch=2336118.622300&year_epoch=1684&year_length=365.241696&year_delta=1'
      ],

      [ChineseSolar,
        'name:[宝暦暦(節月)]',
        'formula:VariableYearLengthMethod?day_epoch=2336118.622100&year_epoch=1684&year_length=365.241696&year_delta=1'
      ],

      [ChineseSolar,
        'name:[修正宝暦暦(節月)]',
        'formula:VariableYearLengthMethod?day_epoch=2336118.762200&year_epoch=1684&year_length=365.241766&year_delta=1'
      ],

      [ChineseSolar,
        'name:[寛政暦(節月)]',
        'formula:VariableYearLengthMethod?day_epoch=2336118.720200&year_epoch=1684&year_length=365.242360&year_delta=0'
      ]
    ].inject([]) {|list, cal|
      if cal.kind_of?(Array) && cal[0] == ChineseLuniSolar
        twin       = cal.dup
        twin[0..1] = [ChineseSolar, cal[1].sub(/\]/, '(節月)]')]
        list << cal << twin
      else
        list << cal
      end
    }]

    #
    # 太平天国 2.1.1-3.2.30
    #
    TenrekiA =  [CyclicTableBased, {
      'origin_of_LSC'  =>  2397523,
      'origin_of_MSC'  =>  1852,
      'indices' => [
         When::Coordinates::Index.new({:unit =>12, :trunk=>When.Resource('_m:ChineseTerms::Month::*')}),
         When::Coordinates::Index.new
       ],
      'rule_table'     => {
        'T' => {'Rule'  =>[365]},
        365 => {'Length'=>[31,30]*5 + [30]*2}
      }
    }]

    #
    # 太平天国 3.3.1-
    #
    TenrekiB =  [CyclicTableBased, {
      'origin_of_LSC'  =>  2397522,
      'origin_of_MSC'  =>  1852,
      'indices' => [
         When::Coordinates::Index.new({:unit  =>12, :trunk=>When.Resource('_m:ChineseTerms::Month::*')}),
         When::Coordinates::Index.new({:shift => 1})
       ],
      'rule_table'     => {
        'T' => {'Rule'  =>[366]},
        366 => {'Length'=>[31,30]*6}
      },
      'note' => 'DefaultNotes'
    }]

    #
    # 彝
    #
    Yi =  [CyclicTableBased, {
      'label'   => When.Resource('_m:ChineseTerms::Yi'),
      'origin_of_LSC'  =>  1721431,
      'origin_of_MSC'  =>  1,
      'indices' => [
         When::Coordinates::Index.new({:unit  =>11, :trunk=>When.Resource('_m:YiTerms::Month::*')}),
         When::Coordinates::Index.new
       ],
      'rule_table'     => {
        'T' => {'Rule'  =>[365, 365, 365, 366]},
        365 => {'Length'=>[36]*10 + [5]},
        366 => {'Length'=>[36]*10 + [6]}
      },
      'note' => 'YiNotes'
    }]
  end
end
