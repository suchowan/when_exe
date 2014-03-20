# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When

  class BasicTypes::M17n

    ChineseTerms = [self, [
      "namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/]",
      "locale:[=ja:, en=en:, alias]",
      "names:[ChineseTerms=]",
      "[中国太陽暦(節月)=ja:%%<二十四節気>#%.<暦月と節月>, *ChineseSolar=en:Solar_term]",
      "[中国太陰太陽暦=ja:%%<中国暦>, *ChineseLuniSolar=en:Chinese_calendar]",
      "[彝暦=ja:%%<イ族>, *Yi=en:Yi_people]",

      [self,
        "names:[月=ja:%%<月_(暦)>, *Month]",
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
        "names:[月=ja:%%<月_(暦)>, *MonthA]",
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
        "names:[月=ja:%%<月_(暦)>, *MonthB]",
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
      "names:[YiTerms=]",

      [self,
        "names:[月=ja:%%<月_(暦)>, *Month]",
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

          # 通法
          @denominator = @year_length.denominator if @year_length.kind_of?(Rational)
          @denominator = [@denominator||0, @lunation_length.denominator].max if @lunation_length.kind_of?(Rational)

          # 太陽の盈縮表の生成
          #   [先後數, 朓朒数, (立成b, 立成c)]
          #      ↓
          #   [区間の始めの冬至からの経過日数, 朓朒数, 立成b, 立成c]
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
          #   [変日差, 損益率]
          #      ↓
          #   [変日(区間の終わりの遠/近地点からの経過日数), 区間の終わりの朓朒積, 区間の変日差/日, 区間の損益率]
          @m = @m.map {|item| item.dup}
          sum_t = sum_v = 0
          (0...@m.size).each do |i|
            sum_t += @m[i][0]
            sum_v += @m[i][1]
            @m[i]  = [sum_t / @denominator, sum_v, @m[i][0] / @denominator, @m[i][1]]
          end
        end

        # 戊寅暦 立成 １次補間
        def _rissei_a(k)
          tv = [0,1].map {|i| _tv_s(k+i)}
          [(tv[1][1]-tv[0][1]) / (tv[1][0]-tv[0][0]), 0.0]
        end

        # 儀鳳暦 立成
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
          [v * r, (t12-t01) * r * r]
        end

        # 宣明暦 立成 ２次補間
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
          2.times do
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
      # 元明代のアルゴリズム
      #
      # @private
      module JujiMethods

        # 暦元天正冬至から当該年の天正冬至までの日数
        def _winter_solstice_(year)
          shift = @year_span > 1 ? @year_span * (year / @year_span) :  year-1
          @year_length * year - @year_delta * year * shift
        end

        # 暦元天正冬至から当該年の近日点通過までの日数
        def _perihelion_(year)
          _winter_solstice(year) + @anomalistic_year_shift
        end

        # 歳周(当該年の日数)
        def _year_length_(year)
          shift = @year_span > 1 ? @year_span * (year / @year_span) :  year
          @year_length - 2 * @year_delta * shift
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
          solar_unit  = _year_length(year) / @year_length
          mean_motion = (@lunar_mean_motion - @solar_weight / solar_unit) * 10000_0000
          @day_epoch + mean_lunation - send('_anomaly_' + @anomaly_method.downcase, mean_lunation, year, solar_unit, mean_motion)
        end

        # 経朔 - 定朔 ( A 方式 - 差分)
        def _anomaly_a(mean_lunation, year, solar_unit, mean_motion)

          # 盈縮差(太陽の中心差) / (日 / 10000_0000)
          solar_anomalies = (0..@solar_weight).to_a.map {|day|
            solar_unit * equation_of_centre(((mean_lunation + day - _perihelion(year)) / solar_unit) % @year_length, @s)
          }
          solar_anomalies[1] ||= solar_anomalies[0]

          # 遅速差(月の中心差) / (日 / 10000_0000)
          lunar_anomalies = [0,1].map {|day|
            equation_of_centre(((mean_lunation + day + @anomalistic_month_shift) % @anomalistic_month_length) / @lunar_unit, @m)
          }

          # 経朔 - 定朔
          (lunar_anomalies[0] - solar_anomalies[0]) / ((lunar_anomalies[1] - lunar_anomalies[0]) -
                                                       (solar_anomalies[1] - solar_anomalies[0]) + mean_motion)
        end

        # 経朔 - 定朔 ( B 方式 - 微分)
        def _anomaly_b(mean_lunation, year, solar_unit, mean_motion)

          # 盈縮差(太陽の中心差) / (日 / 10000_0000)
          solar_anomalies = (0..@solar_weight).to_a.map {|diff|
            solar_unit * equation_of_centre(((mean_lunation - _perihelion(year)) / solar_unit) % @year_length, @s, diff)
          }
          solar_anomalies[1] ||= 0

          # 遅速差(月の中心差) / (日 / 10000_0000)
          lunar_anomalies = [0,1].map {|diff|
            equation_of_centre(((mean_lunation + @anomalistic_month_shift) % @anomalistic_month_length) / @lunar_unit, @m, diff)
          }

          # 経朔 - 定朔
          (lunar_anomalies[0] - solar_anomalies[0]) / (lunar_anomalies[1] / @lunar_unit -
                                                       solar_anomalies[1] /  solar_unit + mean_motion)
        end

        # 経朔 - 定朔 ( C 方式 - 幾何学的補正)
        def _anomaly_c(mean_lunation, year, solar_unit, mean_motion)
          diff = 0
          loop do

            # 盈縮差(太陽の中心差) / (日 / 10000_0000)
            solar_anomaly = solar_unit * equation_of_centre(((mean_lunation - diff - _perihelion(year)) / solar_unit) % @year_length, @s)

            # 遅速差(月の中心差) / (日 / 10000_0000)
            lunar_anomaly = equation_of_centre(((mean_lunation - diff + @anomalistic_month_shift) % @anomalistic_month_length) / @lunar_unit, @m)

            # 次の差分
            next_diff = (lunar_anomaly - solar_anomaly) / mean_motion
            return next_diff if (next_diff - diff).abs < 1e-5
            diff = next_diff
          end 
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
          @anomalistic_year_shift   = (@anomalistic_year_shift || 0).to_f # 暦應(冬至から近日点通過までの日数)
          @lunation_length          =  @lunation_length.to_f              # 朔実(朔望月)
          @lunation_shift           =  @lunation_shift.to_f               # 閏應(暦元前経朔から暦元天正冬至までの日数)
          @lunar_mean_motion        =  @lunar_mean_motion.to_f            # 月平行(恒星天に対する月の平均運動 / 日)
          @anomalistic_month_length =  @anomalistic_month_length.to_f     # 転終(近点月)
          @anomalistic_month_shift  =  @anomalistic_month_shift.to_f      # 転應(暦元前近/遠地点通過から暦元天正冬至までの日数)
          @anomaly_method           =  @anomaly_method || 'a'             # (経朔-定朔)の計算方法
          @solar_weight             =  @solar_weight   || 0               # (経朔-定朔)の計算で用いる実行差での太陽盈縮の重み(0:非考慮,1:考慮)
          @lunar_unit               =  @lunar_unit.to_f                   # 太陰遅速計算用招差法定数の時間の単位(限)
          @m                        =  _rissei_j(@m)                      # 太陰遅速計算用招差法定数
          @s                        =  _rissei_j(@s)                      # 太陽盈縮計算用招差法定数
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
            if t0 > t
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
          instance_eval("class << self; include const_get('Method#{@method.upcase}'); end")

          # 立成の初期化
          _initialize_rissei

        elsif @year_span
          # 太陽黄経の計算(消長あり)
          class << self; include MethodS; end
          @year_span = @year_span.to_i
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
        @label            ||= When.Resource('_m:ChineseTerms::ChineseSolar')
        @formula          ||= ['Formula']
        @formula            = Array(@formula)
        @formula           *= 2 if @formula.length == 1
        @formula[0]        += (@formula[0] =~ /\?/ ? '&' : '?') + 'formula=12S' if @formula[0].kind_of?(String)
        @formula[1]        += (@formula[1] =~ /\?/ ? '&' : '?') + 'formula=1L'  if @formula[1].kind_of?(String)
        @note             ||= When.CalendarNote('ChineseNotes')
        @indices          ||= [
            When::Coordinates::Index.new({:trunk=>When.Resource('_m:ChineseTerms::Month::*')}),
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
        @note             ||= When.CalendarNote('ChineseNotes')
        @indices          ||= [
            When::Coordinates::Index.new({:branch=>{1=>When.Resource('_m:CalendarTerms::閏')},
                                          :trunk=>When.Resource('_m:ChineseTerms::Month::*')}),
            When::Coordinates::DefaultDayIndex
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

    _chinese_common ={
      'day_epoch'                => 2188871 + 55.06,   # 暦元天正冬至のユリウス日
      'year_epoch'               => 1281,              # 暦元の西暦年
      'year_length'              => 365.2425,          # 暦元の冬至年 / 日
      'lunation_length'          => 29.530593,         # 朔実(朔望月)
      'lunation_shift'           => 20.185,            # 閏應(暦元前経朔から暦元天正冬至までの日数)
      'lunar_mean_motion'        => 13.36875,          # 月平行(恒星天に対する月の平均運動 / 日)
      'anomalistic_month_length' => 27.5546,           # 転終(近点月)
      'anomalistic_month_shift'  => 13.1904,           # 転應(暦元前近/遠地点通過から暦元天正冬至までの日数)
      'anomaly_method'           => 'a',               # (経朔-定朔)の計算方法(a:差分, b:微分, c:幾何学的補正)
      'lunar_unit'               =>  27.5546 / (84*4), # 太陰遅速計算用招差法定数の時間の単位(限)
      'solar_weight'             => 0,                 # (経朔-定朔)の計算で用いる実行差での太陽盈縮の重み(0:非考慮,1:考慮)
      's'                        => [                  # 太陽盈縮計算用招差法定数
        [  0       ... 88.909225,   0,       [0, +513_3200, -2_4600, -31]],
        [ 88.909225...182.62125,  182.62125, [0, +487_0600, -2_2100, -27]],
        [182.62125 ...276.333275, 182.62125, [0, -487_0600, +2_2100, +27]],
        [276.333275.. 365.2425,   365.2425,  [0, -513_3200, +2_4600, +31]]
      ],
      'm'                       => [                   # 太陰遅速計算用招差法定数
        [  0... 82,   0, [          +0, +1111_0000, -2_8100, -325       ]],
        [ 82... 86,  84, [+5_4293_4424,         +0, -1_9292,   -0, +1484]],
        [ 86...168, 168, [          +0, +1111_0000, -2_8100, -325       ]],
        [168...250, 168, [          -0, -1111_0000, +2_8100, +325       ]],
        [250...254, 252, [-5_4293_4424,         -0, +1_9292,   +0, -1484]],
        [254.. 336, 336, [          -0, -1111_0000, +2_8100, +325       ]]
      ]
    }

    Chinese = [{}, When::BasicTypes::M17n, ChineseSolar.twin('Chinese', [
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
        'time_basis:+00,+#{P:12}',
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
        'name:[戊寅暦]',
        'time_basis:+00,+#{P:00}',
        {'formula'=>['12S', '1L'].map {|f|
          Ephemeris::ChineseTrueLunation.new({
            'formula'                  => f,
            'day_epoch'                => -58077529,
            'year_length'              =>  '3456675/9464', # 365.0 + 2315/9464(度法)
            'lunation_length'          =>  '384075/13006', #  29.0 + 6901/13006(日法)
            'anomalistic_month_length' =>  '99775/3621',   #  27.0 + 16064/28968 (798200(暦周)/28968(暦法))
            'rissei'                   =>  'a',
            'method'                   =>  'C',
            's'                        => [
              #(先後數) 盈縮數
              [    0.0,     0], # 冬至
              [    0.0,  +896], # 大寒
              [    0.0, +1294], # 小寒
              [    0.0, +1694], # 立春
              [    0.0, +1922], # 啓蟄
              [    0.0, +2263], # 雨水
              [    0.0, +2713], # 春分
              [    0.0, +2213], # 清明
              [    0.0, +1758], # 穀雨
              [    0.0, +1403], # 立夏
              [    0.0,  +848], # 小満
              [    0.0,     0], # 芒種
              [    0.0,  -739], # 夏至
              [    0.0, -1365], # 小暑
              [    0.0, -1821], # 大暑
              [    0.0, -2109], # 立秋
              [    0.0, -2149], # 処暑
              [    0.0, -2491], # 白露
              [    0.0, -2946], # 秋分
              [    0.0, -2264], # 寒露
              [    0.0, -1639], # 霜降
              [    0.0, -1069], # 立冬
              [    0.0,  -556], # 小雪
              [    0.0,  -100]  # 大雪
            ],          
            'm'                       => [
              #(変日差)   盈縮積分の差分(9037=章歳(676)+章月(8361))
              [13006.0, -11341226.0/9037], #   １日
              [13006.0, -10053632.0/9037], #   ２日
              [13006.0,  -8557946.0/9037], #   ３日
              [13006.0,  -6841146.0/9037], #   ４日
              [13006.0,  -4903257.0/9037], #   ５日
              [13006.0,  -2978403.0/9037], #   ６日
              [13006.0,  -1053445.0/9037], #   ７日
              [13006.0,  +1092498.0/9037], #   ８日
              [13006.0,  +3238489.0/9037], #   ９日
              [13006.0,  +5163376.0/9037], #   10日
              [13006.0,  +6880164.0/9037], #   11日
              [13006.0,  +8388868.0/9037], #   12日
              [13006.0,  +9884554.0/9037], #   13日
              [13006.0, +11172149.0/9037], #   14日
              [13006.0, +10742961.0/9037], #   15日
              [13006.0,  +9455368.0/9037], #   16日
              [13006.0,  +7959678.0/9037], #   17日
              [13006.0,  +6242886.0/9037], #   18日
              [13006.0,  +4526094.0/9037], #   19日
              [13006.0,  +2601205.0/9037], #   20日
              [13006.0,   +663312.0/9037], #   21日
              [13006.0,  -1482690.0/9037], #   22日
              [13006.0,  -3407578.0/9037], #   23日
              [13006.0,  -5332465.0/9037], #   24日
              [13006.0,  -7036252.0/9037], #   25日
              [13006.0,  -8753044.0/9037], #   26日
              [13006.0, -10040638.0/9037], #   27日
              [ 7212.4,  -6229880.0/9037]  #   28日
            ]
         })
        }
       }
      ],

      [ChineseLuniSolar,
        'name:[平朔戊寅暦]',
        'formula:MeanLunation?year_length=3456675/9464&lunation_length=384075/13006&day_epoch=-58077529'
      ],

      [ChineseLuniSolar,
        'name:[麟徳暦]',
        'time_basis:+00,+#{P:00}',
        {'formula'=>['12S', '1L'].map {|f|
          Ephemeris::ChineseTrueLunation.new({
            'formula'                  => f,
            'day_epoch'                => -96608689,
            'year_length'              => '122357/335',
            'lunation_length'          =>  '39571/1340',
            'anomalistic_month_length' =>  '443077/16080', # 27.0 + (743.0+1.0/12)/1340,
          # 'rissei'                   =>  'B',
            's'                        => [
              # 消息總  盈朒積    立成b    立成c
              [    0.0,     0,  +3.9546, -0.0372], # 冬至
              [ -722.0,   +54,  +3.4091, -0.0372], # 大寒
              [-1340.0,  +100,  +2.8636, -0.0372], # 小寒
              [-1854.0,  +138,  +2.3181, +0.0372], # 立春
              [-2368.0,  +176,  +2.8636, +0.0372], # 啓蟄
              [-2986.0,  +222,  +3.4091, +0.0372], # 雨水
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
              #(変日差) 増減率
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
        },
        'doyo'   => (Rational( 4,15) +  244) / 1340
       }
      ],

      [ChineseLuniSolar,
        'name:[大衍暦]',
        'time_basis:+00,+#{P:03}',
        {'formula'=>['12S', '1L'].map {|f|
          Ephemeris::ChineseTrueLunation.new({
            'formula'                  => f,
            'day_epoch'                => -35412747829,
            'year_length'              => '1110343/3040',
            'lunation_length'          =>   '89773/3040',
            'anomalistic_month_length' =>  '6701279/243200', # 27.0 +(1685.0+79.0/80)/3040,
          # 'rissei'                   =>  'C',
            's'                        => [
              # 先後數  朓朒積    立成b    立成c
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
              #(変日差) 損益率
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
        },
        'doyo'   => (Rational(13,30) +  531) / 3040
       }
      ],

      [ChineseLuniSolar,
        'name:[五紀暦]',
        'time_basis:+00,+#{P:06}',
        {'formula'=>['12S', '1L'].map {|f|
          Ephemeris::ChineseTrueLunation.new({
            'formula'                  => f,
            'day_epoch'                => -96608689,
            'year_length'              => '122357/335',
            'lunation_length'          =>  '39571/1340',
            'anomalistic_month_length' =>  '1366156/49580', # 27.0 + (743.0+5.0/37)/1340,
          # 'rissei'                   =>  'C',
            's'                        => [
              # 先後數  朓朒積    立成b    立成c
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
              #(変日差) 損益率
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
        },
        'doyo'   => (Rational( 4,15) +  244) / 1340
       }
      ],

      [ChineseLuniSolar,
        'name:[正元暦]',
        'time_basis:+00,+#{P:06}',
        {'formula'=>['12S', '1L'].map {|f|
          Ephemeris::ChineseTrueLunation.new({
            'formula'                  => f,
            'day_epoch'                => -145149709,
            'year_length'              => '399943/1095',       # 365.0 + 268/1095(通法)
            'lunation_length'          =>  '32336/1095',       #  29.0 + 581/1095
            'anomalistic_month_length' =>  '301720132/10950000', #  27.0 + 607.0132(轉終日)/1095 (301720132(轉終分)/10950000)
            'rissei'                   =>  'c',
            'method'                   =>  'C',
            's'                        => [
              # 先後數  朓朒積
              [    0.0,     0], # 冬至
              [ -848.0,   +63], # 大寒
              [-1512.0,  +113], # 小寒
              [-2013.0,  +150], # 立春
              [-2364.0,  +176], # 雨水
              [-2576.0,  +192], # 啓蟄
              [-2653.0,  +198], # 春分
              [-2576.0,  +192], # 清明
              [-2364.0,  +176], # 穀雨
              [-2013.0,  +150], # 立夏
              [-1512.0,  +113], # 小満
              [ -848.0,   +63], # 芒種
              [    0.0,     0], # 夏至
              [ +848.0,   -63], # 小暑
              [+1512.0,  -113], # 大暑
              [+2013.0,  -150], # 立秋
              [+2364.0,  -176], # 処暑
              [+2576.0,  -192], # 白露
              [+2653.0,  -198], # 秋分
              [+2576.0,  -192], # 寒露
              [+2364.0,  -176], # 霜降
              [+2013.0,  -150], # 立冬
              [+1512.0,  -113], # 小雪
              [ +848.0,   -63], # 大雪
            ],
            'm'                       => [
              #(変日差) 損益率
              [1095.0,  -110], #   １日
              [1095.0,   -96], #   ２日
              [1095.0,   -81], #   ３日
              [1095.0,   -64], #   ４日
              [1095.0,   -46], #   ５日
              [1095.0,   -27], #   ６日
              [ 973.0,    -7], #   ７日
              [ 122.0,    +1], #   ７日
              [1095.0,   +12], #   ８日
              [1095.0,   +31], #   ９日
              [1095.0,   +51], #   10日
              [1095.0,   +68], #   11日
              [1095.0,   +85], #   12日
              [1095.0,   +96], #   13日
              [ 851.0,   +87], #   14日
              [ 244.0,   +25], #   14日
              [1095.0,  +107], #   15日
              [1095.0,   +94], #   16日
              [1095.0,   +78], #   17日
              [1095.0,   +61], #   18日
              [1095.0,   +42], #   19日
              [1095.0,   +23], #   20日
              [ 729.0,    +5], #   21日
              [ 366.0,    -2], #   21日
              [1095.0,   -16], #   22日
              [1095.0,   -35], #   23日
              [1095.0,   -53], #   24日
              [1095.0,   -71], #   25日
              [1095.0,   -88], #   26日
              [1095.0,  -102], #   27日
              [ 607.0,   -68], #   28日
              [ 366.0,   -42]  #   28日
            ]
         })
        }
       }
      ],

      [ChineseLuniSolar,
        'name:[宣明暦]',
        'time_basis:+00,+#{P:06}',
        {'formula'=>['12S', '1L'].map {|f|
          Ephemeris::ChineseTrueLunation.new({
            'formula'                  => f,
            'day_epoch'                => -2580308749,
            'year_length'              => '3068055/8400',
            'lunation_length'          =>  '248057/8400',
            'anomalistic_month_length' =>  '23145819/840000', # 27.0 + 4658.19 / 8400,
          # 'rissei'                   =>  'C',
            's'                        => [
              # 先後數  朓朒数    立成b    立成c
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
              #(変日差) 損益率
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
        },
        'doyo'   => (Rational( 1, 2) + 1468) / 8400
       }
      ],

      [ChineseLuniSolar,
        'name:[崇玄暦]',
        'time_basis:+00,+#{P:06}',
        {'formula'=>['12S', '1L'].map {|f|
          Ephemeris::ChineseTrueLunation.new({
            'formula'                  => f,
            'day_epoch'                => -19701911689,
            'year_length'              => '4930801/13500',     # 365.0+3301/13500(通法)
            'lunation_length'          =>  '398663/13500',     #  29.0+7163/13500
            'anomalistic_month_length' =>  '37198697/1350000', #  27.0+7486.97(轉終日)/13500
            'rissei'                   =>  'c',
            's'                        => [
              # 盈縮分     朓朒積
              [     0*1.35,     0], # 冬至
              [ -7740*1.35,  +782], # 大寒
              [-13809*1.35, +1395], # 小寒
              [-18381*1.35, +1857], # 立春
              [-21631*1.35, +2185], # 雨水
              [-23608*1.35, +2385], # 啓蟄
              [-24268*1.35, +2452], # 春分
              [-23608*1.35, +2385], # 清明
              [-21631*1.35, +2185], # 穀雨
              [-18381*1.35, +1857], # 立夏
              [-13809*1.35, +1395], # 小満
              [ -7740*1.35,  +782], # 芒種
              [     0*1.35,     0], # 夏至
              [ +7740*1.35,  -782], # 小暑
              [+13809*1.35, -1395], # 大暑
              [+18381*1.35, -1857], # 立秋
              [+21631*1.35, -2185], # 処暑
              [+23608*1.35, -2385], # 白露
              [+24268*1.35, -2452], # 秋分
              [+23608*1.35, -2385], # 寒露
              [+21631*1.35, -2185], # 霜降
              [+18381*1.35, -1857], # 立冬
              [+13809*1.35, -1395], # 小雪
              [ +7740*1.35,  -782], # 大雪
            ],
            'm'                       => [
              #(変日差) 損益率
              [13500.0,  +1319], #   １日
              [13500.0,  +1150], #   ２日
              [13500.0,   +978], #   ３日
              [13500.0,   +799], #   ４日
              [13500.0,   +617], #   ５日
              [13500.0,   +431], #   ６日
              [11996.75,  +213], #   ７日
              [ 1503.25,   -27], #   ７日
              [13500.0,   -285], #   ８日
              [13500.0,   -471], #   ９日
              [13500.0,   -650], #   10日
              [13500.0,   -840], #   11日
              [13500.0,  -1017], #   12日
              [13500.0,  -1185], #   13日
              [10493.5,  -1032], #   14日
              [ 3006.5,   -293], #   14日
              [13500.0,  -1284], #   15日
              [13500.0,  -1110], #   16日
              [13500.0,   -941], #   17日
              [13500.0,   -757], #   18日
              [13500.0,   -578], #   19日
              [13500.0,   -386], #   20日
              [ 8990.25,  -160], #   21日
              [ 4509.75,   +80], #   21日
              [13500.0,   +324], #   22日
              [13500.0,   +516], #   23日
              [13500.0,   +697], #   24日
              [13500.0,   +879], #   25日
              [13500.0,  +1053], #   26日
              [13500.0,  +1223], #   27日
              [ 7487.0,   +737]  #   28日
            ]
         })
        }
       }
      ],

      [ChineseLuniSolar,
        'name:[授時暦]',
        {'formula'=>['12S', '1L'].map {|f|
          Ephemeris::ChineseTrueLunation.new(_chinese_common.merge({
            'formula'                  => f,
            'year_delta'               => 1,   # 冬至年の変化率 / (10^(-6)日/年)
            'year_span'                => 100  # 冬至年の改訂周期 / 年
         }))
        }
       }
      ],

      [ChineseLuniSolar,
        'name:[大統暦]',
        {'formula'=>['12S', '1L'].map {|f|
          Ephemeris::ChineseTrueLunation.new(_chinese_common.merge({
            'formula'                  => f,
            'year_delta'               => 0,   # 冬至年の変化率 / (10^(-6)日/年)
            'year_span'                => 1    # 冬至年の改訂周期 / 年
         }))
        }
       }
      ]
    ])]

    #
    # 太平天国 2.1.1-3.2.30
    #
    TenrekiA =  [CyclicTableBased, {
      'origin_of_LSC'  =>  2397523,
      'origin_of_MSC'  =>  1852,
      'indices' => [
         When::Coordinates::Index.new({:unit =>12, :trunk=>When.Resource('_m:ChineseTerms::Month::*')}),
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
         When::Coordinates::DefaultDayIndex
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
