# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2021 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When

  module Coordinates

    # Location of cities in China
    Chinese = [When::BasicTypes::M17n, [
      "locale:[=ja:, en=en:, zh=zh:, alias]",
      "names:[中国, *China, 中國]",
      [Spatial,"long:116.2329E", "lat:39.5420N", "label:[北京, *Beijing]"]
    ]]
  end

  class BasicTypes::M17n

    Chinese = [self, [
      "locale:[=ja:, en=en:, zh=zh:, alias]",
      "names:[中国, *China, 中國]",
      "[中国太陽暦(節月)=ja:%%<二十四節気>#%.<暦月と節月>, *ChineseSolar=en:Solar_term], 中國太陽暦(節月)=ja:%%<二十四節気>#%.<暦月と節月>",
      "[中国太陰太陽暦=ja:%%<中国暦>, *ChineseLuniSolar=en:Chinese_calendar, 中國太陰太陽暦=zh:%%<農曆>]",
      "[彝暦=ja:%%<イ族>, *Yi=en:Yi_people, 彝曆=zh:%%<彝族>]",
      "[現代中国=, ModernChinese=, 現代中國=, *Modern=]",

      [self,
        "names:[月の名前=ja:%%<月_(暦)>, month name=en:Month, 該月的名稱=, *alias:Month]",
        "[正月=ja:%%<1月_(旧暦)>,    Month 1= ]",
        "[二月=ja:%%<2月_(旧暦)>,    Month 2= ]",
        "[三月=ja:%%<3月_(旧暦)>,    Month 3= ]",
        "[四月=ja:%%<4月_(旧暦)>,    Month 4= ]",
        "[五月=ja:%%<5月_(旧暦)>,    Month 5= ]",
        "[六月=ja:%%<6月_(旧暦)>,    Month 6= ]",
        "[七月=ja:%%<7月_(旧暦)>,    Month 7= ]",
        "[八月=ja:%%<8月_(旧暦)>,    Month 8= ]",
        "[九月=ja:%%<9月_(旧暦)>,    Month 9= ]",
        "[十月=ja:%%<10月_(旧暦)>,   Month 10=]",
        "[十一月=ja:%%<11月_(旧暦)>, Month 11=]",
        "[十二月=ja:%%<21月_(旧暦)>, Month 12=]"
      ],

      [self,
        "names:[月の名前=ja:%%<月_(暦)>, month name=en:Month, 該月的名稱=, *alias:MonthA=en:Month]",
        "[一月=ja:%%<1月_(旧暦)>,   Month 1= ]",
        "[二月=ja:%%<2月_(旧暦)>,   Month 2= ]",
        "[三月=ja:%%<3月_(旧暦)>,   Month 3= ]",
        "[四月=ja:%%<4月_(旧暦)>,   Month 4= ]",
        "[五月=ja:%%<5月_(旧暦)>,   Month 5= ]",
        "[六月=ja:%%<6月_(旧暦)>,   Month 6= ]",
        "[七月=ja:%%<7月_(旧暦)>,   Month 7= ]",
        "[八月=ja:%%<8月_(旧暦)>,   Month 8= ]",
        "[九月=ja:%%<9月_(旧暦)>,   Month 9= ]",
        "[十月=ja:%%<10月_(旧暦)>,  Month 10=]",
        "[正月=ja:%%<11月_(旧暦)>,  New Year Month=]",
        "[臘月=ja:%%<12月_(旧暦)>,  Month 12=]"
      ],

      [self,
        "names:[月の名前=ja:%%<月_(暦)>, month name=en:Month, 該月的名稱=, *alias:MonthB=en:Month]",
        "[建寅月=ja:%%<1月_(旧暦)>,  Month 3= ]",
        "[建卯月=ja:%%<2月_(旧暦)>,  Month 4= ]",
        "[建辰月=ja:%%<3月_(旧暦)>,  Month 5= ]",
        "[建巳月=ja:%%<4月_(旧暦)>,  Month 6= ]",
        "[建午月=ja:%%<5月_(旧暦)>,  Month 7= ]",
        "[建未月=ja:%%<6月_(旧暦)>,  Month 8= ]",
        "[建申月=ja:%%<7月_(旧暦)>,  Month 9= ]",
        "[建酉月=ja:%%<8月_(旧暦)>,  Month 10=]",
        "[建戌月=ja:%%<9月_(旧暦)>,  Month 11=]",
        "[建亥月=ja:%%<10月_(旧暦)>, Month 12=]",
        "[建子月=ja:%%<11月_(旧暦)>, Month 1= ]",
        "[建丑月=ja:%%<12月_(旧暦)>, Month 2= ]"
      ]
    ]]

    Yi = [self, [
      "locale:[=ja:, en=en:, zh=zh:, alias]",
      "names:[彝暦=ja:%%<イ族>, *Yi=en:Yi_people, 彝曆=zh:%%<彝族>]",

      [self,
        "names:[月の名前=ja:%%<月_(暦)>, month name=en:Month, 該月的名稱=, *alias:Month]",
        "[木公月=, Month 1= ]",
        "[木母月=, Month 2= ]",
        "[火公月=, Month 3= ]",
        "[火母月=, Month 4= ]",
        "[土公月=, Month 5= ]",
        "[土母月=, Month 6= ]",
        "[銅公月=, Month 7= ]",
        "[銅母月=, Month 8= ]",
        "[水公月=, Month 9= ]",
        "[水母月=, Month 10=]",
        "[過年日=, end of year days=]"
      ]
    ]]
  end

  module Coordinates

    # Yi years
    Yi = [When::BasicTypes::M17n, [
      "locale:[=ja:, en=en:, alias]",
      "names:[Yi]",

      [Residue,
        "label:[年の名前=, year name=, zh:該年的名稱=, *alias:YearName=]", "divisor:8", "year:0",
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

  class CalendarNote
    Yis = [['Yi::YearName'], ['_m:Calendar::Month'], ['Common::Week']]
  end

  module Ephemeris

    #
    # Chinese Luni-Solar Calendar Formula for True Lunation Type
    #
    class ChineseTrueLunation < MeanLunation

      #
      # 唐代のアルゴリズム
      #
      # @private
      module TangMethods

        # 太陽の位置補正表
        # @return [Array<Array< 入気定日加減数, 朓朒数, 損益率, 損益率増分 >>]
        #attr_reader :s

        # 月の位置補正表
        # @return [Array<Array< 区間の時間／分, 損益率 >>]
        #attr_reader :m

        #
        # 立成の初期化
        #
        def _initialize_rissei

          # 近点月
          @anomalistic_month_length =  @anomalistic_month_length.to_r

          # 計算式 C) のための繰り返し回数
          @repeat_count ||= @method.upcase == 'C' ? 2 : 1
          @repeat_count   = @repeat_count.to_i

          # 太陽の盈縮表の生成
          #   [先後數, 朓朒数, (初率b, 別差c)]
          #      ↓
          #   [区間の始めの冬至からの経過日数, 朓朒数, 初率b, 別差c]
          @s = @s.map {|item| item.dup}
          if @rissei # 立成の計算・比較
            puts "\n  ["+ @denominator.to_s + "]" if @rissei == @rissei.upcase
            (0...@s.size).each do |i|
              bc = send('_rissei_' + @rissei.downcase, i)
              @s[i] += bc if @s[i].size <= 2
              if @rissei == @rissei.upcase
                sq = (bc[0]-@s[i][2])**2 + (bc[1]-@s[i][3])**2
                puts '%9.1f,%5d,%9.4f,%8.4f,%6.2f' %
                  (@s[i] + [sq == 0 ? -Float::INFINITY : Math.log(sq)/Math.log(100)])
              end
            end
          end
          (0...@s.size).each do |i|
            @s[i-1][1,0] = @year_length / @s.size + (@s[i][0]-@s[i-1][0]) / @denominator
          end
          (0...@s.size).each do |i|
            @s[i].shift
          end

          # 月の遅速表の生成
          @m  = @m.map {|item| item.dup}
          sum = [0,0]
          (0...@m.size).each do |i|
            @m[i]  = _rissei_m(i, sum)
          end
        end

        # 月の立成 - 月の遅速表の生成 一行分
        #   [変日差, 損益率]
        #      ↓
        #   [変日(区間の終わりの遠/近地点からの経過日数), 区間の終わりの朓朒積, 区間の変日差/日, 区間の損益率]
        def _rissei_m(i, sum)
          [0,1].each {|k| sum[k] += @m[i][k]}
          [sum[0] / @denominator, sum[1], @m[i][0] / @denominator, @m[i][1]]
        end

        # 太陽の立成 - 戊寅元暦 １次補間
        def _rissei_a(k)
          tv = [0,1].map {|i| _tv_s(k+i)}
          [(tv[1][1]-tv[0][1]) / (tv[1][0]-tv[0][0]), 0.0]
        end

        # 太陽の立成 - 儀鳳暦
        def _rissei_b(k)
          v =
            if k % 3 < 2
              t   = [0,1,2].map {|n| @s[(k+n) % @s.size][1]}
              t01 = t[1] - t[0]
              t12 = t[2] - t[1]
              (t01 + t12) / 2.0 + t01 - t12
            else
              t   = [-1,0,1].map {|n| @s[(k+n) % @s.size][1]}
              t01 = t[1] - t[0]
              t12 = t[2] - t[1]
              t02 = t[2] - t[0]
              t02 / 2.0
            end
          r = v < 0 ? 12.0/(17*11) : 12.0/(16*11)
         # 初率b, 別差c
          [v * r, (t12-t01) * r * r]
        end

        # 太陽の立成 - 宣明暦 ２次補間
        def _rissei_c(k)
          i = [k, k+1, k+2, k % 6 == 5 ? -1 : 0]
          t0, v0 = _tv_s(i[0]+i[3])
          t1, v1 = _tv_s(i[1]+i[3])
          t2, v2 = _tv_s(i[2]+i[3])
          t01    = t1 - t0
          t02    = t2 - t0
          t12    = t2 - t1
          v01    = v1 - v0
          v02    = v2 - v0
          c      = (v02*t01 - v01*t02) / (t01*t02*t12) * 2
          b      = (v01 - t01*(t01-1)/2*c) / t01
          [b-t01*c*i[3], c]
        end

        # 日行盈縮
        #
        # @param [Integer] i 区間の番号
        #
        # @return [区間の始めの冬至からの経過日数, 朓朒数]
        #
        def _tv_s(i)
          [@year_length * i / @s.size + @s[i % @s.size][0] / @denominator, @s[i % @s.size][1]]
        end

        # 月行遅速
        #
        # @param [Numeric] t 直前の遠/近地点からの経過日数
        #
        # @return [区間の始めからの経過日数, 区間の始めの朓朒積, 区間の変日差/日, 区間の損益率, 次の区間の損益率]
        #
        def _tv_m(t)
          (0...@m.size).each do |i|
            next if t > @m[i][0]
            return [t - (@m[i][0] - @m[i][2]), @m[i][1] - @m[i][3], @m[i][2], @m[i][3], @m[(i+1) % @m.size][3]]
          end
        end
      end

      #
      # 日本暦日原典 計算 A)
      #
      # @private
      module MethodA

        include TangMethods

        private

        # 周期番号 -> 日時
        #
        # @param [Numeric] cn 周期番号
        #
        # @return [Numeric] ユリウス日
        #
        def cn_to_time_(cn, time0=nil)
          time = super
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

          dt, a0, t0, b0, b1 = _tv_m(t)

          # 補正値 (A式)
          a0 + (b0.to_f * dt / t0 + 0.5).floor
        end
      end

      #
      # 日本暦日原典 計算 C)
      #
      # @private
      module MethodC

        include TangMethods

        private

        # 周期番号 -> 日時
        #
        # @param [Numeric] cn 周期番号
        #
        # @return [Numeric] ユリウス日
        #
        def cn_to_time_(cn, time0=nil)
          time = super
          t    = time - @day_epoch
          t   += delta_s(t.divmod(@year_length)[1]) / @denominator
          d    = 0
          @repeat_count.times do
            d  = delta_m((t+d/@denominator).divmod(@anomalistic_month_length)[1])
          end
          t + @day_epoch + d / @denominator
        end

        #
        # 朔の日時の太陽運動の不斉による補正
        #
        # @param [Numeric] t 直前の冬至からの日数
        #
        # @return [Numeric] 補正量 / @denominator
        #
        def delta_s(t)

          t0, a, b, c = nil
          @s.each do |v|
            t0, a, b, c = v
            break if t <= t0
            t -= t0
          end

          # ２４気からの日数 (大余, 小余)
          t, dt = t.divmod(1)

          # 損益率
          b0 = b + c * t

          # 朓朒数
          a0 = a + b * t + c * t * (t-1)/2

          # 補正値
          a0 + b0 * dt
        end

        #
        # 朔の日時の月運動の不斉による補正
        #
        # @param [Numeric] t 直前の遠/近地点からの日数
        #
        # @return [Numeric] 補正量 / @denominator
        #
        def delta_m(t)

          #Sm, 遅速積, 区間長, Δ1, Δ2
          dt, a0, t0, b0, b1 = _tv_m(t)

          # 補正値 (B,C式)
          a0 + dt / t0 * ((b0+b1)/2.0 + 0.5*(1+t0-dt)*(b0-b1))
        end
      end

      #
      # 日本暦日原典 計算 B)
      #
      # @private
      MethodB = MethodC

      #
      # 戊寅元暦
      #
      # @private
      module MethodW

        include MethodA

        private

        # 太陽の立成 - 戊寅元暦 １次補間
        def _rissei_a(k)
          tv = [0,1].map {|i| _tv_s(k+i)}
          [(tv[1][1]-tv[0][1]) / (tv[1][0]-tv[0][0]).round.to_f, 0.0]
        end

        # 月の立成 - 月の遅速表の生成 一行分
        #   [変日差, 盈縮率]
        #      ↓
        #   [変日(区間の終わりの遠/近地点からの経過日数), 区間の始まりの盈縮積分, 区間の始まりの経過日数, 区間の損益率]
        def _rissei_m(i, sum)
          progress_difference = (-@m[i][1]*9037 / @m[i][0]).round.to_f
          progress = progress_difference + 8361
          line = [sum[1]*9037/progress, sum[0]/@denominator,
                      -(progress_difference*13006/28968).round * 28968 / progress]
          [0,1].each {|k| sum[k] += @m[i][k]}
          line.unshift(sum[0] / @denominator)
        end

        # 月行遅速
        #
        # @param [Numeric] t 直前の遠/近地点からの経過日数
        #
        # @return [区間の始めからの経過日数, 区間の始めの盈縮積分, 区間の変日差/日, 区間の損益率]
        #
        def _tv_m(t)
          (0...@m.size).each do |i|
            next if t > @m[i][0]
            return [t - @m[i][2], @m[i][1], 1.0, @m[i][3]]
          end
        end
      end

      #
      # 元明代のアルゴリズム
      #
      # @private
      module JujiMethods

        # 授時暦・大統暦
        module C
          def _shift_l(year); @year_span * (year / @year_span) end
          alias :_shift_s :_shift_l
        end

        # 貞享暦・宝暦暦
        module Y
          def _shift_l(year); year   end
          def _shift_s(year); year-1 end
        end

        # 寛政暦
        module D
          def _shift_l(year); year.div(10) * 10 end
          alias :_shift_s :_shift_l

          def _winter_solstice_(year)
            decade, year_in_decade = year.divmod(10)
            decade_floor = 10 *  decade      * (@year_length - (decade - 1) * 10 * @year_delta)
            decade_ceil  = 10 * (decade + 1) * (@year_length -  decade      * 10 * @year_delta)
            decade_floor + (decade_ceil - decade_floor) * year_in_decade / 10
          end
        end

        # 暦元天正冬至から当該年の天正冬至までの日数
        def _winter_solstice_(year)
          year * (@year_length - @year_delta  * _shift_s(year))
        end

        # 暦元天正冬至から当該年の近日点通過までの日数
        def _perihelion_(year)
          date = _winter_solstice_(year)
          return date unless @anomalistic_year_shift
          date + year * @precession + @anomalistic_year_shift
        end

        # 歳周(当該年の日数)
        def _year_length_(year)
          @year_length - 2 * @year_delta * _shift_l(year)
        end
      end

      #
      # 授時暦の平均太陽の計算
      #
      # @private
      module MethodS

        include JujiMethods

        # 日時 -> 周期番号
        #
        # @param [Numeric] t ユリウス日(Terrestrial Time)
        # @param [When::TM::TemporalPosition] t
        #
        # @return [Numeric] 周期番号
        #
        def time_to_cn(t, cn0=nil)
          cn0 ||= (t.to_f - @day_epoch) / @year_length + @year_epoch + @longitude_shift
          root(cn0 * 12, t.to_f) {|cn| cn_to_time(cn) }
        end

        # 周期番号 -> 日時(平気)
        #
        # @param [Numeric] cn 周期番号
        # @param [Numeric] time0 日時の初期近似値(ダミー)
        #
        # @return [Numeric] ユリウス日
        #
        def cn_to_time_(cn, time0=nil)
          year, mean_term = (cn / 12.0 - @longitude_shift - @year_epoch).divmod(1)
          @day_epoch + _winter_solstice(year) + _year_length_(year) * mean_term
        end
      end

      #
      # 授時暦の定朔の計算
      #
      # @private
      module MethodJ

        include JujiMethods

        # 周期番号 -> 日時(定朔)
        #
        # @param [Numeric] cn 周期番号
        # @param [Numeric] time0 日時の初期近似値(ダミー)
        #
        # @return [Numeric] ユリウス日
        #
        def cn_to_time_(cn, time0=nil)
          # 暦元天正冬至から当該経朔までの日数
          mean_lunation  = cn * @lunation_length - @lunation_shift

          # 当該経朔を含む近点年の暦元からの年数
          year  = (mean_lunation / @year_length).floor
          until (_perihelion(year)..._perihelion(year+1)).include?(mean_lunation)
            year += _perihelion(year) > mean_lunation ? -1 : +1
          end

          # 定朔
          solar_unit  = (_year_length(year) + (@anomalistic_year_shift ? @precession : 0))/ @year_length
          mean_motion = (@lunar_mean_motion - @solar_weight / solar_unit) * 10000_0000
          @day_epoch + mean_lunation - send('_anomaly_' + @anomaly_method.downcase, mean_lunation, year, solar_unit, mean_motion)
        end

        # 経朔 - 定朔 ( A 方式 - 階差)
        def _anomaly_a(mean_lunation, year, solar_unit, mean_motion)

          # 遅速差(月の中心差) / (日 / 10000_0000)
          gen   = ((mean_lunation + @anomalistic_month_shift) % @anomalistic_month_length) / @lunar_unit
          minus = gen - gen.floor
          plus  = 1 - minus
          lunar_anomalies = [-minus, 0, +plus].map {|diff|
            equation_of_centre(gen+diff, @m)
          }

          # 盈縮差(太陽の中心差) / (日 / 10000_0000)
          solar_anomalies = (@solar_weight == 0 ? [0] : [-minus * @lunar_unit, 0, plus * @lunar_unit]).map {|diff|
            solar_unit * equation_of_centre(((mean_lunation - _perihelion(year) + diff) / solar_unit) % @year_length, @s)
          }
          solar_anomalies = solar_anomalies * 3 if @solar_weight == 0

          # 経朔 - 定朔
          (lunar_anomalies[1] - solar_anomalies[1]) / (((lunar_anomalies[2] - lunar_anomalies[0]) -
                                                        (solar_anomalies[2] - solar_anomalies[0])) / @lunar_unit + mean_motion)
        end

        # 経朔 - 定朔 ( D 方式 - 差分)
        def _anomaly_d(mean_lunation, year, solar_unit, mean_motion)

          # 遅速差(月の中心差) / (日 / 10000_0000)
          lunar_anomalies = [0,1].map {|day|
            equation_of_centre(((mean_lunation + day + @anomalistic_month_shift) % @anomalistic_month_length) / @lunar_unit, @m)
          }

          # 盈縮差(太陽の中心差) / (日 / 10000_0000)
          solar_anomalies = (0..@solar_weight).to_a.map {|day|
            solar_unit * equation_of_centre(((mean_lunation + day - _perihelion(year)) / solar_unit) % @year_length, @s)
          }
          solar_anomalies[1] ||= solar_anomalies[0]

          # 経朔 - 定朔
          (lunar_anomalies[0] - solar_anomalies[0]) / ((lunar_anomalies[1] - lunar_anomalies[0]) -
                                                       (solar_anomalies[1] - solar_anomalies[0]) + mean_motion)
        end

        # 経朔 - 定朔 ( B 方式 - 微分)
        def _anomaly_b(mean_lunation, year, solar_unit, mean_motion)

          # 遅速差(月の中心差) / (日 / 10000_0000)
          lunar_anomalies = [0,1].map {|diff|
            equation_of_centre(((mean_lunation + @anomalistic_month_shift) % @anomalistic_month_length) / @lunar_unit, @m, diff)
          }

          # 盈縮差(太陽の中心差) / (日 / 10000_0000)
          solar_anomalies = (0..@solar_weight).to_a.map {|diff|
            solar_unit * equation_of_centre(((mean_lunation - _perihelion(year)) / solar_unit) % @year_length, @s, diff)
          }
          solar_anomalies[1] ||= 0

          # 経朔 - 定朔
          (lunar_anomalies[0] - solar_anomalies[0]) / (lunar_anomalies[1] / @lunar_unit -
                                                       solar_anomalies[1] /  solar_unit + mean_motion)
        end

        # 経朔 - 定朔 ( C 方式 - 幾何学的補正)
        def _anomaly_c(mean_lunation, year, solar_unit, mean_motion)
          diff = 0
          loop do

            # 遅速差(月の中心差) / (日 / 10000_0000)
            lunar_anomaly = equation_of_centre(((mean_lunation - diff + @anomalistic_month_shift) % @anomalistic_month_length) / @lunar_unit, @m)

            # 盈縮差(太陽の中心差) / (日 / 10000_0000)
            solar_anomaly = solar_unit * equation_of_centre(((mean_lunation - diff - _perihelion(year)) / solar_unit) % @year_length, @s)

            # 次の差分
            next_diff = (lunar_anomaly - solar_anomaly) / mean_motion
            return next_diff if (next_diff - diff).abs < @anomaly_precision
            diff = next_diff
          end 
        end

        # 経朔 - 定朔 ( U 方式 - Chinese-Uighur)
        def _anomaly_u(mean_lunation, year, solar_unit, mean_motion)

          # 遅速差(月の中心差) / (日 / 1_0000)
          @approx_anomalistic_month_length ||= (@anomalistic_month_length / @lunar_unit) / 9
          l_lunar = mean_lunation - @year_length / 6 # 暦元を雨水に変更
          l_lunar = (l_lunar + @anomalistic_month_shift - @anomalistic_month_length * 13 *
                    (l_lunar / @year_length).floor) % @approx_anomalistic_month_length
          sign, angle = (l_lunar * 9).divmod(124)
          angle = angle.floor
          lunar_anomaly = angle * (124 - angle)
          lunar_anomaly = -lunar_anomaly unless sign == 1

          # 盈縮差(太陽の中心差) / (日 / 1_0000)
          l_solar = mean_lunation % @year_length
          sign, angle = l_solar.floor.divmod(182)
          solar_anomaly = (angle * (182 - angle) * 2.0 / 9).floor
          solar_anomaly = -solar_anomaly unless sign == 1

          (solar_anomaly + lunar_anomaly) / 10000.0
        end

        # 中心差およびその時間微分
        def equation_of_centre(mean_anomaly, table, differential=0)
          table.each do |range, base, *coefficients|
            if range.include?(mean_anomaly)
              diff = mean_anomaly - base
              diff = diff.abs if coefficients[0].size[0] == 0
              return coefficients[differential].inject(0) {|sum, coefficient| sum * diff + coefficient}
            end
          end
          raise RangeError, 'Mean anomaly out of range: ' + mean_anomaly.to_s
        end

        # 立成の作成
        def _initialize_rissei
          @year_length              =  @year_length.to_f                  # 暦元の冬至年 / 日
          @year_span                = (@year_span || 1).to_i              # 冬至年の改訂周期 / 年
          @anomalistic_year_shift   =  @anomalistic_year_shift.to_f if @anomalistic_year_shift # 暦應(暦元での冬至から近日点通過までの日数)
          @precession               = (@precession || 0.015).to_f         # 歳差
          @lunation_length          =  @lunation_length.to_f              # 朔実(朔望月)
          @lunation_shift           =  @lunation_shift.to_f               # 閏應(暦元前経朔から暦元天正冬至までの日数)
          @lunar_mean_motion        =  @lunar_mean_motion.to_f            # 月平行(恒星天に対する月の平均運動 / 日)
          @anomalistic_month_length =  @anomalistic_month_length.to_f     # 転終(近点月)
          @anomalistic_month_shift  =  @anomalistic_month_shift.to_f      # 転應(暦元前近/遠地点通過から暦元天正冬至までの日数)
          @anomaly_method           =  @anomaly_method || 'a'             # (経朔-定朔)の計算方法
          @anomaly_precision        = (@anomaly_precision || 1.0E-5).to_f # c 方式 での収束判定誤差 / 日
          @solar_weight             = (@solar_weight      || 0     ).to_i # (経朔-定朔)の計算で用いる実行差での太陽盈縮の重み(0:非考慮,1:考慮)
          @lunar_unit               =  @lunar_unit.to_f                   # 太陰遅速計算用招差法定数の時間の単位(限)
          @m                        =  _rissei_j(@m) if @m                # 太陰遅速計算用招差法定数
          @s                        =  _rissei_j(@s) if @s                # 太陽盈縮計算用招差法定数
        end

        # 招差法用の表の生成
        def _rissei_j(table)
          table.map {|range, base, coefficients|
            sign = range.last == base ? -1 : +1
            [range, base, coefficients.reverse,
             (1...coefficients.size).to_a.reverse.map {|i| sign * i * coefficients[i]}]
          }
        end
      end

      # 近点月
      # @return [Numeric]
      #attr_reader :anomalistic_month_length

      # 元期の近点角
      # @return [Numeric]
      #attr_reader :anomalistic_month_shift

      # 日時 -> 周期番号(唐代の定朔の暦法用 cn_to_time(1L) を使用する)
      #
      # @param [Numeric] t ユリウス日(Terrestrial Time)
      # @param [When::TM::TemporalPosition] t
      #
      # @return [Numeric] 周期番号
      #
      def time_to_cn(t)
        return super unless @cycle_number_1m
        time = @is_dynamical ? +t : t.to_f
        cn0  = time * @cycle_number_1m + @cycle_number_0m
        root(cn0, time, 0, 5) {|cn| cn_to_time(cn)}
      end

      # 当該日付の月の位相の変化範囲(唐代の定朔の暦法用 cn_to_time(1L) を使用する)
      #
      # @param [When::TM::TemporalPosition] date 日付
      #
      # @return [Array<Numeric>] 当該日付の月の位相の変化範囲
      #
      def phase_range(date)
        date = date.floor
        [date, date.succ].map {|d|
          t  = d.to_f
          c  = (60.0 * ((t - CYCLE_0M) * @cycle_number_1m + @cycle_number_0m)).floor
          t0 = t1 = nil
          loop do
            t0 = cn_to_time( c   / 60.0)
            t1 = cn_to_time((c+1)/ 60.0)
            d  = ((t-t0) / (t1-t0)).round
            if d.abs > 1
              c += d
            elsif t0 > t
              c -= 1
            elsif t1 <= t
              c += 1
            else
              break
            end
          end
          (c + (t-t0) / (t1-t0)) / 60.0
        }
      end

      private

      # オブジェクトの正規化
      def _normalize(args=[], options={})
        super

        if @formula == '1L'

          # 月の位相の計算
          @method ||= @year_span ? 'J' : 'A'
          extend self.class.const_get("Method#{@method.upcase}")

          # 立成の初期化
          _initialize_rissei

        elsif @year_span
          # 太陽黄経の計算(消長あり)
          extend MethodS
          @year_span = @year_span.to_i
        end

        if self.kind_of?(JujiMethods)
          case @year_span
          when 0,1; extend JujiMethods::Y
          when 10 ; extend JujiMethods::D
          else    ; extend JujiMethods::C
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

      class << self
        #
        # 太陰太陽暦の定義から太陰太陽暦と太陽暦(節月)の組を作る
        #
        # @private
        def twin(area, definition)
          definition.inject([]) {|list, cal|
            if cal.kind_of?(Array) && cal[0] == ChineseLuniSolar
              solar_name  = cal[1].sub(/=?\]/, '(節月)=]')
              lunisolar   = cal.dup << "twin:#{area}::" + solar_name.gsub(/(name:\[|=?\])/,'')
              solar       = cal.dup << "twin:#{area}::" + cal[1].gsub(/(name:\[|=?\])/,'')
              solar[0..1] = [ChineseSolar, solar_name]
              list << lunisolar << solar
            else
              list << cal
            end
          }
        end

        #
        # 盈縮差の表の時間の単位を調整する
        #
        # @private
        def change_unit(unit, definition)
          definition.map {|line|
            line.map {|item|
              case item
              when Range   ; Range.new(item.first*unit, item.last*unit, item.exclude_end?)
              when Numeric ; item*unit
              else         ; item
              end
            }
          }
        end
      end

      #
      # @return [When::CalendarTypes::ChineseLuniSolar] 対で用いる太陰太陽暦の名前
      #
      attr_reader :twin

      # @private
      attr_reader :doyo

      private

      # オブジェクトの正規化
      #
      #   @formula      = 太陽黄経の計算に用いるEphemeris
      #
      def _normalize(args=[], options={})
        @label            ||= 'Chinese::ChineseSolar'
        @formula          ||= (When::CalendarNote::LuniSolarPositions.table_off ? ['Formula'] :
                                 [When.Resource('_ep:SolarFormulaWithTable'), When.Resource('_ep:LunarFormulaWithTable')])
        @formula            = Array(@formula)
        @formula           *= 2 if @formula.length == 1
        @formula[0]        += (@formula[0] =~ /\?/ ? '&' : '?') + 'formula=12S' if @formula[0].kind_of?(String)
        @formula[1]        += (@formula[1] =~ /\?/ ? '&' : '?') + 'formula=1L'  if @formula[1].kind_of?(String)
        @note             ||= When.CalendarNote('ChineseSolar')
        @indices          ||= [
            When.Index('Chinese::Month'),
            When::Coordinates::DefaultDayIndex
          ]
        super
      end
    end

    #
    # Chinese Luni-Solar Calendar
    #
    class ChineseLuniSolar < EphemerisBasedLuniSolar

      #
      # @return [When::CalendarTypes::ChineseSolar] 対で用いる太陽暦の名前
      #
      attr_reader :twin

      # 指定の年の天正冬至を含む月以降１年分の閏月のパターン
      #
      # @param [Numeric] y 年
      #
      # @return [Array<Numeric:月番号>, Hash<Numeric:含む中気の数=>Numeric:月番号>]
      #
      def intercalary_pattern(y)
        m  = _base_month(y)
        l  = _base_ids(y)
        c  = {0=>[], 1=>[], 2=>[]}
        d0 = Residue.mod(_new_month(m)-1) {|n| _new_epoch(n)}[0]
        l.size.times do |i|
          d1 = Residue.mod(_new_month(m+i+1)-1) {|n| _new_epoch(n)}[0]
          c[d1-d0] << l[i]
          d0 = d1
        end
        c.delete(1)
        [l, c]
      end

      private

      # オブジェクトの正規化
      #
      #   @cycle_offset = 雨水の場合 -1
      #   @formula      = 太陽黄経および月の位相の計算に用いるEphemeris
      #
      def _normalize(args=[], options={})
        @label            ||= 'Chinese::ChineseLuniSolar'
        @formula          ||= (When::CalendarNote::LuniSolarPositions.table_off ? ['Formula'] :
                                 [When.Resource('_ep:SolarFormulaWithTable'), When.Resource('_ep:LunarFormulaWithTable')])
        @formula            = Array(@formula)
        @formula           *= 2 if @formula.length == 1
        @formula[0]        += (@formula[0] =~ /\?/ ? '&' : '?') + 'formula=12S' if @formula[0].kind_of?(String)
        @formula[1]        += (@formula[1] =~ /\?/ ? '&' : '?') + 'formula=1L'  if @formula[1].kind_of?(String)
        @vernal_month     ||=  2
        @cycle_offset     ||=  @vernal_month - 3
        @base_month       ||= 11
        @base_month         = @base_month.to_i
        @intercalary_span ||= 12
        @intercalary_span   =  @intercalary_span.to_i
        @intercalary_month  = (@intercalary_month.to_i - @base_month) % 12 + 1 if @intercalary_month
        @note             ||= When.CalendarNote('ChineseLuniSolar')
        @indices          ||= [
            When.Index('Chinese::Month', {:branch=>{1=>'_m:Calendar::閏'}}),
            When::Coordinates::DefaultDayIndex
          ]
        instance_eval %Q{
          alias :_flags :_flags_reverse
        } if @reverse
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
        (Residue.mod(solar_sdn(@formula[0].cn_to_time(12*(y-1) + @base_month - @vernal_month))) {|m| _new_month(m)})[0]
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
        return _flags(m0, n)
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

      # 閏判定表(最初を選択)
      #
      # @param [Numeric] m 最初の通月
      # @param [Numeric] n 区間の長さ
      #
      # @return [Array<Boolean>] f 閏判定表
      #
      def _flags(m,n)
        flags = Array.new(n+1, false)
        n.times do |i|
          m += 1
          if _intercalary?(m)
            flags[i+1] = true
            return flags
          end
        end
        raise ArgumentError, "Intercalary month not found"
      end

      # 閏判定表(最後を選択)
      #
      # @param [Numeric] m 最初の通月
      # @param [Numeric] n 区間の長さ
      #
      # @return [Array<Boolean>] f 閏判定表
      #
      def _flags_reverse(m,n)
        flags = Array.new(n+1, false)
        m += n
        n.times do |i|
          if _intercalary?(m)
            flags[-i-1] = true
            return flags
          end
          m -= 1
        end
        raise ArgumentError, "Intercalary month not found"
      end
    end

    #
    # 太平天国 2.1.1-3.2.30
    #
    TenrekiA =  [CyclicTableBased, {
      'origin_of_LSC'  =>  2397523,
      'origin_of_MSC'  =>  1852,
      'indices' => [
         When.Index('Chinese::Month', {:unit =>12}),
         When::Coordinates::DefaultDayIndex
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
         When.Index('Chinese::Month', {:unit  =>12}),
         When.Index({:shift => 1})
       ],
      'rule_table'     => {
        'T' => {'Rule'  =>[366]},
        366 => {'Length'=>[31,30]*6}
      },
      'note' => 'Default'
    }]

    #
    # 彝
    #
    Yi =  [CyclicTableBased, {
      'label'   => 'Chinese::Yi',
      'origin_of_LSC'  =>  1721431,
      'origin_of_MSC'  =>  1,
      'indices' => [
         When.Index('Yi::Month', {:unit  =>11}),
         When::Coordinates::DefaultDayIndex
       ],
      'rule_table'     => {
        'T' => {'Rule'  =>[365, 365, 365, 366]},
        365 => {'Length'=>[36]*10 + [5]},
        366 => {'Length'=>[36]*10 + [6]}
      },
      'note' => 'Yis'
    }]
  end
end
