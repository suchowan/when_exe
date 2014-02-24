# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

#
# 標準的な時刻系の定義
#
module When::TimeStandard

  # TT(Terrestrial Time) - UTC(Universal Time, Coordinated) at 1970-01-01T00:00:00Z
  DeltaT0 = (40 + 377.0/2048) * When::TM::Duration::SECOND

  TAI_UTC = # http://maia.usno.navy.mil/ser7/tai-utc.dat
    [[2437300.5,  1.422818, 37300.0, 0.001296 ],
     [2437512.5,  1.372818, 37300.0, 0.001296 ],
     [2437665.5,  1.845858, 37665.0, 0.0011232],
     [2438334.5,  1.945858, 37665.0, 0.0011232],
     [2438395.5,  3.24013,  38761.0, 0.001296 ],
     [2438486.5,  3.34013,  38761.0, 0.001296 ],
     [2438639.5,  3.44013,  38761.0, 0.001296 ],
     [2438761.5,  3.54013,  38761.0, 0.001296 ],
     [2438820.5,  3.64013,  38761.0, 0.001296 ],
     [2438942.5,  3.74013,  38761.0, 0.001296 ],
     [2439004.5,  3.84013,  38761.0, 0.001296 ],
     [2439126.5,  4.31317,  39126.0, 0.002592 ],
     [2439887.5,  4.21317,  39126.0, 0.002592 ],
     [2441317.5, 10.0],
     [2441499.5, 11.0],
     [2441683.5, 12.0],
     [2442048.5, 13.0],
     [2442413.5, 14.0],
     [2442778.5, 15.0],
     [2443144.5, 16.0],
     [2443509.5, 17.0],
     [2443874.5, 18.0],
     [2444239.5, 19.0],
     [2444786.5, 20.0],
     [2445151.5, 21.0],
     [2445516.5, 22.0],
     [2446247.5, 23.0],
     [2447161.5, 24.0],
     [2447892.5, 25.0],
     [2448257.5, 26.0],
     [2448804.5, 27.0],
     [2449169.5, 28.0],
     [2449534.5, 29.0],
     [2450083.5, 30.0],
     [2450630.5, 31.0],
     [2451179.5, 32.0],
     [2453736.5, 33.0],
     [2454832.5, 34.0],
     [2456109.5, 35.0]]

  DeltaT  = [                                                                63.467, # 1999
     63.827, 64.092, 64.300, 64.473, 64.573, 64.689, 64.846, 65.145, 65.456, 65.779, # 2000-
     66.070, 66.324, 66.603, 66.909                                                  # 2010-
  ]

  class << self
    # When::TimeStandard Module のグローバルな設定を行う
    #
    # @param [String] leap_seconds http://maia.usno.navy.mil/ser7/tai-utc.dat 形式のファイルのファイルパス
    # @param [Array<Array<Numeric>>] leap_seconds 閏秒の挿入記録 [ [ JD, TAI-UTC, (MJD, OFFSET) ] ]
    #   [ JD      - 閏秒を挿入した日時のユリウス日 ]
    #   [ TAI-UTC - 閏秒を挿入後の TAI と UTC の差 ]
    #   [ MJD     - 周波数オフセットの基準となる日時の修正ユリウス日 ]
    #   [ OFFSET  - 周波数オフセット値 ]
    #
    # @return [void]
    #
    # @note
    #   本メソッドでマルチスレッド対応の管理変数の初期化を行っている。
    #   このため、本メソッド自体はスレッドセーフでない。
    #
    def _setup_(leap_seconds=nil)
      @_lock_ = Mutex.new if When.multi_thread
      leap_seconds ||= TAI_UTC
      @leap_seconds  =
        if leap_seconds.kind_of?(String)
          OpenURI
          open(leap_seconds) do |file|
            file.read.split(/[\n\r]+/).map { |line|
              line.split(/[^\d.]+/)[3..6].map {|d| d.to_f}
            }.reverse
          end
        else
          leap_seconds.reverse
        end
    end

    # @private
    # 閏秒の挿入記録を取得する
    def _leap_seconds
      @leap_seconds ||= TAI_UTC.reverse
    end

    # 処理系が閏秒を無視しているか否か
    # @private
    def _is_systemtime_universal?
      @is_systemtime_universal = ((Time.utc(1976).to_i - Time.utc(1975).to_i) % 86400 == 0) if @is_systemtime_universal == nil
      @is_systemtime_universal
    end

    # ΔT
    #
    # @param [Numeric] jd_utc ユリウス日(Universal Time, Coordinated)
    #
    # @return [Numeric] (dynamical_time - universal_time) / second
    #     1/2048 second(≒0.5ms)未満を四捨五入
    #
    def delta_t(jd_utc)
      (delta_t_coordinated(jd_utc) * 4096 + 1).floor / 4096.0
    end
    alias :deltaT :delta_t

    # ΔT - 閏秒による(TT-UTC)
    #
    # @param [Numeric] jd_utc ユリウス日(Universal Time, Coordinated)
    #
    # @return [Numeric] (Terrestrial Time - Universal Time, Coordinated) / second
    #
    def delta_t_coordinated(jd_utc)
      list = _leap_seconds
      list.each do |v|
        if jd_utc >= v[0]
          result  = 32.184 + v[1]
          result += (jd_utc - (2400000.5 + v[2])) * v[3] unless (v[3]||0) == 0
          return result
        end
      end
      delta_t_observed(jd_utc)
    end

    # ΔT - 観測による(TT-UT1) mix of Table and NASA
    #
    # @param [Numeric] jd_utc ユリウス日(Universal Time, Coordinated)
    #
    # @return [Numeric] (Terrestrial Time - Universal Time 1) / second
    #
    def delta_t_observed(jd_utc)
      year = (jd_utc - When::Ephemeris::EPOCH2000)/When::Ephemeris::JYEAR + 2000 # 0年からの経過世紀
      return delta_t_observed_poly(year) unless 2000 <= year && year < 2050
      return delta_t_observed_poly(year) + DeltaThreshold * (year - 2050.0) / (YearThreshold - 2050.0) if year >= YearThreshold

      i = (year-1999.0).floor             # 1999年からの経過年(整数)
      n    = year % 1
      d0   = DeltaT[i+0] - DeltaT[i-1]
      d1   = DeltaT[i+1] - DeltaT[i+0]
      d2   = DeltaT[i+2] - DeltaT[i+1]
      d10  = d1  - d0
      d21  = d2  - d1
      d210 = d21 - d10
      DeltaT[i] + n*d1 + n*(n-1.0)/4.0*(d10+d21) + n*(n-1.0)*(n-0.5)/6.0*d210
    end

    # ΔT - 観測による(TT-UT1) from http://eclipse.gsfc.nasa.gov/SEhelp/deltatpoly2004.html
    #
    # @param [Numeric] jd_utc ユリウス日(Universal Time, Coordinated)
    #
    # @return [Numeric] (Terrestrial Time - Universal Time 1) / second
    #
    def delta_t_observed_nasa(jd_utc)
      delta_t_observed_poly((jd_utc - When::Ephemeris::EPOCH2000)/When::Ephemeris::JYEAR + 2000.0) # 0年からの経過年
    end

    # 多項式による近似
    def delta_t_observed_poly(year)
      u    = (year-1820)/100

      # 2150 ... 3000
      if    year >= 2150
        -20 + 32 * u**2

      # 2050 ... 2150
      elsif year >= 2050
        -20 + 32 * u**2 - 0.5628 * (2150 - year)

      # 2005 ... 2050
      elsif year >= 2005
        t = year - 2000
        62.92 + 0.32217 * t + 0.005589 * t**2

      # 1986 ... 2005
      elsif year >= 1986
        t = year - 2000
        63.86 + 0.3345 * t - 0.060374 * t**2 + 0.0017275 * t**3 + 0.000651814 * t**4 + 0.00002373599 * t**5

      # 1961 ... 1986
      elsif year >= 1961
        t = year - 1975
       45.45 + 1.067*t - t**2/260 - t**3 / 718

      # 1941 ... 1961
      elsif year >= 1941
        t = year - 1950
        29.07 + 0.407*t - t**2/233 + t**3 / 2547

      # 1920 ... 1941
      elsif year >= 1920
        t = year - 1920
        21.20 + 0.84493*t - 0.076100 * t**2 + 0.0020936 * t**3

      # 1900 ... 1920
      elsif year >= 1900
        t = year - 1900
         -2.79 + 1.494119 * t - 0.0598939 * t**2 + 0.0061966 * t**3 - 0.000197 * t**4

      # 1860 ... 1900
      elsif year >= 1860
        t = year - 1860
         7.62 + 0.5737 * t - 0.251754 * t**2 + 0.01680668 * t**3 - 0.0004473624 * t**4 + t**5 / 233174

      # 1800 ... 1860
      elsif year >= 1800
        t = year - 1800
        13.72 - 0.332447 * t + 0.0068612 * t**2 + 0.0041116 * t**3 - 0.00037436 * t**4 + 0.0000121272 * t**5 - 0.0000001699 * t**6 + 0.000000000875 * t**7

      # 1700 ... 1800
      elsif year >= 1700
        t = year - 1700
        8.83 + 0.1603 * t - 0.0059285 * t**2 + 0.00013336 * t**3 - t**4 / 1174000

      # 1600 ... 1700
      elsif year >= 1600
        t = year - 1600
        120 - 0.9808 * t - 0.01532 * t**2 + t**3 / 7129

      # 500 ... 1600
      elsif year >=  500
        u = (year - 1000) / 100
        1574.2 - 556.01 * u + 71.23472 * u**2 + 0.319781 * u**3 - 0.8503463 * u**4 - 0.005050998 * u**5 + 0.0083572073 * u**6

      # -500 ... 500
      elsif year >= -500
        u = year / 100
        10583.6 - 1014.41 * u + 33.78311 * u**2 - 5.952053 * u**3 - 0.1798452 * u**4 + 0.022174192 * u**5 + 0.0090316521 * u**6

      # ... -500
      else
        -20 + 32 * u**2
      end
    end
    private :delta_t_observed_poly

    # universal time を dynamical time に変換する
    #
    # @param [Numeric] time universal time
    #
    # @return [Numeric] dynamical time
    #
    def to_dynamical_time(time)
      return time unless -Float::MAX/4 < time && time < Float::MAX/4
      jd_utc = When::TM::JulianDate._t_to_d(time * 1)
      +time + delta_t(jd_utc) * When::TM::Duration::SECOND
    end

    # dynamical time を universal time に変換する
    #
    # @param [Numeric] time dynamical time
    #
    # @return [Numeric] universal time
    #
    def from_dynamical_time(time)
      return time unless -Float::MAX/4 < time && time < Float::MAX/4
      jd_tt = When::TM::JulianDate._t_to_d(time)
      utc   = time - delta_t(jd_tt) * When::TM::Duration::SECOND
      diff  = time - to_dynamical_time(utc)
      return utc if diff == 0 # 間に閏秒なし
      utc  += diff
      diff  = time - to_dynamical_time(utc)
      return utc if diff == 0 # 間に閏秒なし
      return When::Coordinates::LeapSeconds.new(utc+diff, -diff, When::TM::Duration::SECOND)
    end

    # Time オブジェクトを dynamical time に変換する
    #
    # @param [::Time] time
    #
    # @return [Numeric] [dynamical time
    #
    def from_time_object(time)
      time = time.to_f * When::TM::Duration::SECOND
      _is_systemtime_universal? ? to_dynamical_time(time) : time + DeltaT0
    end

    # dynamical time を Time オブジェクトに変換する
    #
    # @param [Numeric] time dynamical time
    #
    # @return [::Time]
    #
    def to_time_object(time)
      time = _is_systemtime_universal? ? from_dynamical_time(time) : time - DeltaT0
      ::Time.at(+time / When::TM::Duration::SECOND)
    end
  end

  # @private
  YearThreshold  = 1997.0 + DeltaT.size

  # @private
  DeltaThreshold = DeltaT[-2] - delta_t_observed_poly(YearThreshold)

  #
  # When::TM::Calendar のための TimeBasis の初期化
  #
  # @private
  module TimeBasis

    # @private
    attr_reader :_time_basis

    module FixedTimeBasis

      private

      # 太陽黄経のための日付境界のオフセットを反映した通日
      #
      # @param [Numeric] t ユリウス日(Terrestrial Time)
      #
      # @return [Integer]
      #
      def solar_sdn(t)
        (t + 0.5 + @_time_basis_offset[0]).floor
      end

      # 月の位相のための日付境界のオフセットを反映した通日
      #
      # @param [Numeric] t ユリウス日(Terrestrial Time)
      #
      # @return [Integer]
      #
      def lunar_sdn(t)
        (t + 0.5 + @_time_basis_offset[-1]).floor
      end
    end

    module ApparentTimeBasis

      private

      # 太陽黄経のための日付境界のオフセットを反映した通日
      #
      # @param [Numeric] t ユリウス日(Terrestrial Time)
      #
      # @return [Integer]
      #
      def solar_sdn(t)
        time_basis.time_standard.from_dynamical_date(t + 0.5 + @_time_basis_offset[0]).floor
      end

      # 月の位相のための日付境界のオフセットを反映した通日
      #
      # @param [Numeric] t ユリウス日(Terrestrial Time)
      #
      # @return [Integer]
      #
      def lunar_sdn(t)
        time_basis.time_standard.from_dynamical_date(t + 0.5 + @_time_basis_offset[-1]).floor
      end
    end

    #
    # When::TM::Calendar のための TimeBasis の初期化
    #
    def _normalize_time_basis

      @_time_basis ||= @time_basis || (@location ? @location.long / When::Coordinates::Spatial::DEGREE * 240 : When.utc)
      @_time_basis   = When::Parts::Locale._split(@_time_basis) if @_time_basis.kind_of?(String)
      @_time_basis   = [@_time_basis] unless @_time_basis.kind_of?(Array)
      @_time_basis   = @_time_basis.map {|clock| When.Clock(clock)}
      @_time_basis_offset = @_time_basis.map {|clock| -clock.universal_time / When::TM::Duration::DAY}

      @time_basis = @_time_basis[0] if @time_basis

      if @_time_basis[0].time_standard.kind_of?(LocalApparentTime)
        class << self; include ApparentTimeBasis ; end
      else
        class << self; include FixedTimeBasis    ; end
      end
    end
  end

  #
  # 時刻系のひながた
  #
  class TimeStandard < When::BasicTypes::Object

    include When::TimeStandard

    Ratio = 1.0

    # universal time を dynamical time に変換する
    #
    # @param [Numeric] time universal time
    #
    # @return [Numeric] dynamical time
    #
    def to_dynamical_time(time)
      When::TimeStandard.to_dynamical_time(time)
    end

    # dynamical time を universal time に変換する
    #
    # @param [Numeric] time dynamical time
    #
    # @return [Numeric] universal time
    #
    def from_dynamical_time(time)
      When::TimeStandard.from_dynamical_time(time)
    end

    # 当該時刻系の日付を dynamical date に変換する
    #
    # @param [Numeric]  date 当該時刻系の日付
    #
    # @return [Numeric] dynamical date
    #
    def to_dynamical_date(date)
      When::TM::JulianDate._t_to_d(
        to_dynamical_time(
          When::TM::JulianDate._d_to_t(date)))
    end

    # dynamical date を当該時刻系の日付に変換する
    #
    # @param [Numeric] date dynamical date
    #
    # @return [Numeric] 当該時刻系の日付
    #
    def from_dynamical_date(date)
      When::TM::JulianDate._t_to_d(
        from_dynamical_time(
          When::TM::JulianDate._d_to_t(date)))
    end

    # Time オブジェクトを universal time に変換する
    #
    # @param [::Time] time
    #
    # @return [Numeric] universal time
    #
    def from_time_object(time)
      from_dynamical_time(When::TimeStandard.from_time_object(time))
    end

    # universal time を Time オブジェクトに変換する
    #
    # @param [Numeric] time universal time
    #
    # @return [::Time]
    #
    def to_time_object(time)
      When::TimeStandard.to_time_object(to_dynamical_time(time))
    end

    # 当該時刻系に閏秒があるか?
    #
    # @return [Boolean] - false 閏秒なし
    #
    def has_leap?
      false
    end

    # 時間の歩度
    #
    # @return [Numeric]
    #
    def rate_of_clock
      self.class::Ratio
    end

    private

    def _normalize(args=[], options={})
    end
  end

  #
  # 協定世界時
  #
  class UniversalTime < TimeStandard

    # Time オブジェクトを universal time に変換する
    #
    # @param [::Time] time
    #
    # @return [Numeric] universal time
    #
    def from_time_object(time)
      result = time.to_f * When::TM::Duration::SECOND
      return result if When::TimeStandard._is_systemtime_universal?
      from_dynamical_time(result + DeltaT0)
    end

    # universal time を Time オブジェクトに変換する
    #
    # @param [Numeric] time universal time
    #
    # @return [::Time]
    #
    def to_time_object(time)
      time = to_dynamical_time(time) - DeltaT0 unless When::TimeStandard._is_systemtime_universal?
      ::Time.at(+time / When::TM::Duration::SECOND)
    end

    # 当該時刻系に閏秒があるか?
    #
    # @return [Boolean] - true 閏秒あり
    #
    def has_leap?
      true
    end
  end

  #
  # 地方平均太陽時
  #
  class LocalMeanTime < TimeStandard

    # local mean time  を dynamical time に変換する
    #
    # @param [Numeric] time local mean time
    #
    # @return [Numeric] dynamical time
    #
    def to_dynamical_time(time)
      super(time - When::TM::Duration::DAY * @location.long / (360.0 * When::Coordinates::Spatial::DEGREE))
    end

    # dynamical time を local mean time  に変換する
    #
    # @param [Numeric] time dynamical time
    #
    # @return [Numeric] local mean time
    #
    def from_dynamical_time(time)
      super(time) + When::TM::Duration::DAY * @location.long  / (360.0 * When::Coordinates::Spatial::DEGREE)
    end

    private

    # オブジェクトの正規化
    def _normalize(args=[], options={})
      @location = When.Resource(@location || '_l:long=0&lat=0')
      super
    end
  end

  #
  # 地方真太陽時
  #
  class LocalApparentTime < TimeStandard

    # local apparent time  を dynamical time に変換する
    #
    # @param [Numeric] time local apparent time
    #
    # @return [Numeric] dynamical time
    #
    def to_dynamical_time(time)
      date   = When::TM::JulianDate._t_to_d(time) - @location.long / (360.0 * When::Coordinates::Spatial::DEGREE)
      diff   = 0
      2.times do
        diff = @datum.equation_of_time(date-diff)
      end
      super(When::TM::JulianDate._d_to_t(date-diff))
    end

    # dynamical time を local apparent time  に変換する
    #
    # @param [Numeric] time dynamical time
    #
    # @return [Numeric] local apparent time
    #
    def from_dynamical_time(time)
      super(time) + When::TM::Duration::DAY * (@location.long  / (360.0 * When::Coordinates::Spatial::DEGREE) +
                                               @datum.equation_of_time(When::TM::JulianDate._t_to_d(time)))
    end

    private

    # オブジェクトの正規化
    def _normalize(args=[], options={})
      @location ||= '_l:long=0&lat=0'
      @location   = When.Resource(@location) if @location.kind_of?(String)
      @datum      = When.Resource(@datum    || '_ep:Earth'       )
      super
    end
  end

  #
  # 不定時法
  #
  class TemporalHourSystem < LocalApparentTime

    # @private
    alias :_to_dynamical_time   :to_dynamical_time
    # @private
    alias :_from_dynamical_time :from_dynamical_time

    # temporal hour system を dynamical time に変換する
    #
    # @param [Numeric] time temporal hour system
    #
    # @return [Numeric] dynamical time
    #
    def to_dynamical_time(time)
      noon, frac = When::TM::JulianDate._t_to_d(time).divmod(1)

      r, *p =
        case (frac * 4).floor
        when 3 ; [-1.5, [noon+1, -1],[noon+1, +1]] # morning
        when 0 ; [+0.5, [noon,   -1],[noon,   +1]] # afternoon
        else   ; [-0.5, [noon,   +1],[noon+1, -1]] # night
        end

      s, e = p.map {|v| 
        When::TM::JulianDate._d_to_t(@formula.day_event(_to_dynamical_date(v[0]), v[1], When.Resource('_ep:Sun'), @height))
      }

      s + (e - s) * (frac * 2 + r)
    end

    # dynamical time を temporal hour system に変換する
    #
    # @param [Numeric] time dynamical time
    #
    # @return [Numeric] temporal hour system
    #
    def from_dynamical_time(time)
      date = When::TM::JulianDate._t_to_d(time)

      d, t = [-1, +1].map {|v| @formula.day_event(date, v, When.Resource('_ep:Sun'), @height)}

      if    date < d # after midnight
        t = @formula.sunset(date-1, @height)
        f = (date - t) / (d - t) / 2 - 0.25

      elsif date > t # before midnight
        d = @formula.sunrise(date+1, @height)
        f = (date - t) / (d - t) / 2 - 0.25

      else           # day time
        f  = (date - d) / (t - d) / 2 + 0.25
      end

      When::TM::JulianDate._d_to_t(_from_dynamical_date(d).floor + 0.5 + f)
    end

    private

    # オブジェクトの正規化
    def _normalize(args=[], options={})
      @formula  = When::Ephemeris::Formula.new({:location=>@location})
      @height ||= 'T'
      super
    end

    # 単位を「日」にした to_dynamical_time
    def _to_dynamical_date(date)
      When::TM::JulianDate._t_to_d(_to_dynamical_time(When::TM::JulianDate._d_to_t(date)))
    end

    # 単位を「日」にした from_dynamical_time
    def _from_dynamical_date(date)
      When::TM::JulianDate._t_to_d(_from_dynamical_time(When::TM::JulianDate._d_to_t(date)))
    end
  end
end
