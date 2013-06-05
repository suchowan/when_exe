# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2013 Takashi SUGA

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

  DeltaT  = [                                                      142.00, # 1599

    141.00,140.00,139.00,139.00,139.00,139.00,139.00,140.00,140.00,141.00, # 1600-
    141.00,141.00,141.00,140.00,139.00,138.00,137.00,134.00,132.00,128.00, # 1610-
    124.00,119.00,115.00,110.00,106.00,102.00, 98.00, 95.00, 91.00, 88.00, # 1620-
     85.00, 82.00, 79.00, 77.00, 74.00, 72.00, 70.00, 67.00, 65.00, 63.00, # 1630-
     62.00, 60.00, 58.00, 57.00, 55.00, 54.00, 53.00, 51.00, 50.00, 49.00, # 1640-
     48.00, 47.00, 46.00, 45.00, 44.00, 43.00, 42.00, 41.00, 40.00, 38.00, # 1650-
     37.00, 36.00, 35.00, 34.00, 33.00, 32.00, 31.00, 30.00, 28.00, 27.00, # 1660-
     26.00, 25.00, 24.00, 23.00, 22.00, 21.00, 20.00, 19.00, 18.00, 17.00, # 1670-
     16.00, 15.00, 14.00, 14.00, 13.00, 12.00, 12.00, 11.00, 11.00, 10.00, # 1680-
     10.00, 10.00,  9.00,  9.00,  9.00,  9.00,  9.00,  9.00,  9.00,  9.00, # 1690-

      9.00,  9.00,  9.00,  9.00,  9.00,  9.00,  9.00,  9.00, 10.00, 10.00, # 1700-
     10.00, 10.00, 10.00, 10.00, 10.00, 10.00, 10.00, 11.00, 11.00, 11.00, # 1710-
     11.00, 11.00, 11.00, 11.00, 11.00, 11.00, 11.00, 11.00, 11.00, 11.00, # 1720-
     11.00, 11.00, 11.00, 11.00, 12.00, 12.00, 12.00, 12.00, 12.00, 12.00, # 1730-
     12.00, 12.00, 12.00, 12.00, 13.00, 13.00, 13.00, 13.00, 13.00, 13.00, # 1740-
     13.00, 14.00, 14.00, 14.00, 14.00, 14.00, 14.00, 14.00, 15.00, 15.00, # 1750-
     15.00, 15.00, 15.00, 15.00, 15.00, 16.00, 16.00, 16.00, 16.00, 16.00, # 1760-
     16.00, 16.00, 16.00, 16.00, 16.00, 17.00, 17.00, 17.00, 17.00, 17.00, # 1770-
     17.00, 17.00, 17.00, 17.00, 17.00, 17.00, 17.00, 17.00, 17.00, 17.00, # 1780-
     17.00, 17.00, 16.00, 16.00, 16.00, 16.00, 15.00, 15.00, 14.00, 14.00, # 1790-

     13.70, 13.40, 13.10, 12.90, 12.70, 12.60, 12.50, 12.50, 12.50, 12.50, # 1800-
     12.50, 12.50, 12.50, 12.50, 12.50, 12.50, 12.50, 12.40, 12.30, 12.20, # 1810-
     12.00, 11.70, 11.40, 11.10, 10.60, 10.20,  9.60,  9.10,  8.60,  8.00, # 1820-
      7.50,  7.00,  6.60,  6.30,  6.00,  5.80,  5.70,  5.60,  5.60,  5.60, # 1830-
      5.70,  5.80,  5.90,  6.10,  6.20,  6.30,  6.50,  6.60,  6.80,  6.90, # 1840-
      7.10,  7.20,  7.30,  7.40,  7.50,  7.60,  7.70,  7.70,  7.80,  7.80, # 1850-
      7.88,  7.82,  7.54,  6.97,  6.40,  6.02,  5.41,  4.10,  2.92,  1.82, # 1860-
      1.61,  0.10, -1.02, -1.28, -2.69, -3.24, -3.64, -4.54, -4.71, -5.11, # 1870-
     -5.40, -5.42, -5.20, -5.46, -5.46, -5.79, -5.63, -5.64, -5.80, -5.66, # 1880-
     -5.87, -6.01, -6.19, -6.64, -6.44, -6.47, -6.09, -5.76, -4.66, -3.74, # 1890-

     -2.72, -1.54, -0.02,  1.24,  2.64,  3.86,  5.37,  6.14,  7.75,  9.13, # 1900-
     10.46, 11.53, 13.36, 14.65, 16.01, 17.20, 18.24, 19.06, 20.25, 20.95, # 1910-
     21.16, 22.25, 22.41, 23.03, 23.49, 23.62, 23.86, 24.49, 24.34, 24.08, # 1920-
     24.02, 24.00, 23.87, 23.95, 23.86, 23.93, 23.73, 23.92, 23.96, 24.02, # 1930-
     24.33, 24.83, 25.30, 25.70, 26.24, 26.77, 27.28, 27.78, 28.25, 28.71, # 1940-
     29.15, 29.57, 29.97, 30.36, 30.72, 31.07, 31.35, 31.68, 32.18, 32.68, # 1950-
     33.15, 33.59, 34.00, 34.47, 35.03, 35.73, 36.54, 37.43, 38.29, 39.20, # 1960-
     40.18, 41.17, 42.23, 43.37, 44.49, 45.48, 46.46, 47.52, 48.53, 49.59, # 1970-
     50.54, 51.38, 52.17, 52.96, 53.79, 54.34, 54.87, 55.32, 55.82, 56.30, # 1980-
     56.86, 57.57, 58.31, 59.12, 59.99, 60.79, 61.63, 62.30, 62.97, 63.47, # 1990-

     63.83, 64.09, 64.30, 64.47, 64.57, 64.69, 64.85, 65.15, 65.46, 65.78, # 2000-
     66.07, 66.32, 66.60                                                   # 2010-
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
    def _setup_(leap_seconds=nil)
      @_lock_ = Mutex.new if When.multi_thread
      @_lock_.lock if @_lock_
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
      @_lock_.unlock if @_lock_
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

    # ΔT - 観測による(TT-UT1)
    #
    # @param [Numeric] jd_utc ユリウス日(Universal Time, Coordinated)
    #
    # @return [Numeric] (Terrestrial Time - Universal Time 1) / second
    #
    def delta_t_observed(jd_utc)
      c2000 = (jd_utc - When::Ephemeris::EPOCH2000)/When::Ephemeris::JCENT # 2000年からの経過世紀
      year  =  c2000 * 100.0 + 2000.0    #    0年からの経過年
      i = (year-1599.0).floor            # 1599年からの経過年(整数)
      if year >= 2009.0
        dt = 65.46 + 0.224 * (year-2009.0)
      elsif i>0
        n    = year % 1
        d0   = DeltaT[i+0] - DeltaT[i-1]
        d1   = DeltaT[i+1] - DeltaT[i+0]
        d2   = DeltaT[i+2] - DeltaT[i+1]
        d10  = d1  - d0
        d21  = d2  - d1
        d210 = d21 - d10
        dt   = DeltaT[i] + n*d1 + n*(n-1.0)/4.0*(d10+d21) + n*(n-1.0)*(n-0.5)/6.0*d210
      elsif year <948.0
        dt   = 2715.6 + 573.36 * c2000 + 46.5*c2000*c2000
      else
        dt   =   50.6 +  67.5  * c2000 + 22.5*c2000*c2000
      end
      return dt
    end

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
      super(time) + When::TM::Duration::DAY * @datum.equation_of_time(When::TM::JulianDate._t_to_d(time))
    end

    private

    # オブジェクトの正規化
    def _normalize(args=[], options={})
      @location ||= '_l:long=0&lat=0'
      @location   = When.Resource(@location.gsub(/%26/, '&')) if @location.kind_of?(String)
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
        t = @formula.sun_set(date-1, @height)
        f = (date - t) / (d - t) / 2 - 0.25

      elsif date > t # before midnight
        d = @formula.sun_rise(date+1, @height)
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
