# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

#
# ISO 19108 Geographic information - Temporal schema
#
module When::TM
#
# (5.3) Temporal Reference System Package
#

  # 時間参照系
  #
  # see {http://schemas.opengis.net/gml/3.1.1/base/temporalReferenceSystems.xsd#AbstractTimeReferenceSystemType gml schema}
  #
  class ReferenceSystem < When::TM::Object

    # この時間参照系が使用する空間と時間の制限(実装は時間のみ)
    #
    # Limits of space and time within which the temporal reference system is use
    #
    # @return [When::EX::Extent]
    #
    # @note
    #   domain の最小・最大から範囲を決定して domain_of_validity としている
    #   domain_of_validity は ISO19108との互換性を確保するため提供しているが、
    #   有効期間が複数に断片化していることがあるので、より正確な情報を含む
    #   domain の使用を推奨する
    #
    #   マルチスレッド動作時 CalendarEra の生成で Calendar の本属性が更新される
    #   参照・更新処理は synchronize { ... } の ... の部分に書く必要がある
    #
    attr_accessor :domain_of_validity
    alias :domainOfValidity :domain_of_validity

    # この時間参照系と関連付けられた時間位置 (relation - Reference)
    #
    # The temporal position associated with the time reference system being described
    #
    # @return [Array<When::TM::(Temporal)Position>]
    #
    attr_reader :position

    # この時間参照系が使用する時間の範囲
    #
    # Range of time within which the temporal reference system is use
    #
    # @return [Hash<String=>When::Parts::GeomerticComplex>]
    #
    # @note
    #   マルチスレッド動作時 CalendarEra の生成で Calendar の本属性が更新される
    #   参照・更新処理は synchronize { ... } の ... の部分に書く必要がある
    #
    def domain
      @domain ||= Hash.new {|hash, key| hash[key] = When::Parts::GeometricComplex.new([])}
    end

    # 時間参照系を識別する名称
    #
    # Name by which the temporal reference system is known
    #
    # @return [When::RS::Identifier]
    #
    def name
      @name ||= When::RS::Identifier.new(label, @version, @remarks)
    end
  end

  # 順序時間参照系
  #
  # see {http://schemas.opengis.net/gml/3.1.1/base/temporalReferenceSystems.xsd#TimeOrdinalReferenceSystemType gml schema}
  #
  class OrdinalReferenceSystem < ReferenceSystem

    # この順序時間参照系の最上位レベルを構成する順序年代 (relation - Structure)
    #
    # Ordinal eras that make up the highest level of this ordinal reference system
    #
    # @return [Array<When::TM::OrdinalEra>]
    #
    alias :component :child

    private

    # オブジェクトの正規化
    def _normalize(args=[], options={})
    end
  end

  # 暦
  #
  # see {http://schemas.opengis.net/gml/3.1.1/base/temporalReferenceSystems.xsd#TimeCalendarType gml schema}
  #
  class Calendar < ReferenceSystem

    include When::Coordinates
    include Spatial::Normalize
    include Temporal
    include When::TimeStandard::TimeBasis

    # 初期化
    #
    # @return [void]
    #
    # @note
    #   本メソッドでマルチスレッド対応の管理変数の初期化を行っている。
    #   このため、本メソッド自体はスレッドセーフでない。
    #
    def self._setup_
      @_lock_ = Mutex.new if When.multi_thread
      @_pool  = {}
    end

    # この暦と関連付けられた暦年代 (relation - Basis)
    #
    # The calendar eras associated with the calendar being described
    #
    # @return [Array<When::TM::CalendarEra>]
    #
    # @note
    #   マルチスレッド動作時 CalendarEra の生成で 本属性が更新される
    #   参照・更新処理は synchronize { ... } の ... の部分に書く必要がある
    #
    attr_reader :reference_frame
    alias :referenceFrame :reference_frame

    # 一暦日の中の時間位置を定めるために、この暦とともに使用する時計 (relation - Resolution)
    #
    # The clock that is used with this calendar to define
    # temporal position within a calendar day
    #
    # @return [Array<When::TM::Clock>]
    #
    attr_reader :time_basis
    alias :timeBasis :time_basis

    # 時刻制 - additional attribute
    #
    # @return [When::TimeStandard, nil]
    #
    def time_standard
      @time_basis ? @time_basis.time_standard : nil
    end

    # 時間の歩度
    #
    # @return [Numeric]
    #
    def rate_of_clock
      @time_basis ? @time_basis.time_standard.rate_of_clock : 1.0
    end

    # 日付と時刻をユリウス日(When::TM::JulianDate)に変換する
    #
    # @param [When::TM::CalDate] cal_date
    # @param [When::TM::ClockTime] time
    #
    # @return [When::TM::JulianDate]
    #
    def date_trans(cal_date, time=nil, options={})
      time = cal_date.clk_time if ((time == nil) && cal_date.kind_of?(DateAndTime))
      frac = (time) ? time.universal_time : 0.0
      jdn  = to_julian_date(cal_date.cal_date)
      return JulianDate.universal_time((jdn - JulianDate::JD19700101) * Duration::DAY + frac, options)
    end
    alias :dateTrans :date_trans

    # ユリウス日(When::TM::JulianDate)を日付に変換する
    #
    # @param [When::TM::JulianDate] jdt
    # @param [Hash] options see {When::TM::TemporalPosition._instance}
    #
    # @return [When::TM::CalDate]        if (options[:clock or :tz] == nil)
    # @return [When::TM::CalDateAndTime] if (options[:clock or :tz] != nil)
    #
    def jul_trans(jdt, options={})
      options = TemporalPosition._options(options)
      unless jdt.kind_of?(When::TimeValue)
        options[:clock] ||= @time_basis unless rate_of_clock == 1.0
        jdt = JulianDate.new(jdt, options)
      end
      cal_options = jdt._attr
      cal_options.delete(:era_name)
      cal_options.delete(:era)
      unless rate_of_clock == jdt.time_standard.rate_of_clock
        cal_options.delete(:time_standard)
        cal_options[:clock] = @time_basis || When::UTC
        jdt = JulianDate.dynamical_time(jdt.dynamical_time, {:time_standard=>time_standard})
      end

      cal_options.update(options)
      cal_options[:frame] = self
      clock = Clock.get_clock_option(cal_options) || jdt.clock

      if clock
        clock = When.Clock(clock) if clock.kind_of?(String)
        clock = clock._daylight(jdt.universal_time) if clock._need_validate
        frac  = clock.universal_time
        sdn, time = (jdt.universal_time - frac).divmod(Duration::DAY)
        cal_options[:clock] = clock
        cal_date = to_cal_date(sdn.to_i + JulianDate::JD19700101)
        cal_date[0] -= cal_options[:era_name][1] if cal_options[:era_name]
        DateAndTime.new(cal_date, time+frac, cal_options)
      else
        cal_date     = to_cal_date(jdt.to_i)
        cal_date[0] -= cal_options[:era_name][1] if cal_options[:era_name]
        CalDate.new(cal_date, cal_options)
      end
    end
    alias :julTrans :jul_trans
    alias :^ :jul_trans

    # ユリウス日(Numeric)を日付に変換する
    #
    # @param [Integer] jdn
    #
    # @return [Array<Numeric>]
    #
    def to_cal_date(jdn)
      _encode(_number_to_coordinates(jdn))
    end

    # 日付をユリウス日(Numeric)に変換する
    #
    # @param [Array<Numeric>] cal_date
    #
    # @return [Integer] JulianDate
    #
    def to_julian_date(cal_date)
      date    = _decode(cal_date)
      date[0] = +date[0]
      _coordinates_to_number(*date)
    end

    # 日付・時刻をUniversal Time(Numeric)に変換する
    #
    # @param [Array<Numeric>] cal_date 日付
    # @param [Array<Numeric>] clk_time 時刻
    # @param [When::TM::Clock] clock 時法
    #
    # @return [Numeric] Universal Time
    #
    def to_universal_time(cal_date, clk_time, clock=When::UTC)
      time     = clk_time.dup
      time[0] += _coordinates_to_number(*_decode(cal_date))
      clock.to_universal_time(time) - When::TM::JulianDate::JD19700101 * When::TM::Duration::DAY
    end

    # 月初の通日
    #
    # @param  [Integer] m 通月
    #
    # @return [Numeric] 月初の通日
    #
    def _new_month_(m)
      date = @base.map {|d| d||0}
      if @indices[-2].unit
        date[-2] += m
        _coordinates_to_number(*_decode(date))
      else
        d0        = _coordinates_to_number(*_decode(date))
        date[-3] += (m * @mean_month / @mean_year).floor - 1
        d1        = _coordinates_to_number(*_decode(date))
        date[-2] += m - ((d1 - d0) / @mean_month + 0.5).floor
        _coordinates_to_number(*_decode(date))
      end
    end

    # 通日 - > [通月,月内日数,月の日数]
    #
    # @param [Integer] sdn 通日
    #
    # @return [Array<Numeric>] ( m, d, n )
    #   [ m - 通月]
    #   [ d - 月内の日数 (0 始まり)]
    #   [ n - 月の日数]
    #
    def _to_month_number_(sdn)
      Residue.mod(sdn) {|m| _new_month(m)}
    end

    private

    # オブジェクトの正規化
    def _normalize(args=[], options={})
      @indices  ||= DefaultDateIndices
      _normalize_spatial
      _normalize_time_basis
      _default_index_of_MSC
      _normalize_temporal
      @reference_frame ||= []
    end
  end

  # 時計
  #
  # see {http://schemas.opengis.net/gml/3.1.1/base/temporalReferenceSystems.xsd#TimeClockType gml schema}
  #
  class Clock < ReferenceSystem

    include When::Coordinates
    include When::Parts::Timezone::Base
    include Spatial::Normalize
    include Temporal

    class << self
      include When::Parts::Resource::Pool

      # When::TM::Clock Class のグローバルな設定を行う
      #
      # @param [When::Parts::Timezone::Base, String] local 地方時を使用する場合、指定する
      #
      # @return [void]
      #
      # @note
      #   本メソッドでマルチスレッド対応の管理変数の初期化を行っている。
      #   このため、本メソッド自体はスレッドセーフでない。
      #
      def _setup_(local=nil)
        @_lock_ = Mutex.new if When.multi_thread
        @_pool  = {}
        @local_time = local
      end

      # 設定情報を取得する
      #
      # @return [Hash] 設定情報
      #
      def _setup_info
        {:local => _local_time}
      end

      # 地方時
      #
      # @param [When::Parts::Timezone::Base, String] local 地方時
      #
      # @return [When::Parts::Timezone::Base, String]
      #
      # @note
      #   @local_timeは、原則、ライブラリ立ち上げ時に _setup_ で初期化する。
      #   以降、@local_timeに代入を行っても、すでに生成した When::TM::TemporalPosition 等には反映されない。
      #
      def local_time=(local)
        if @_pool
          @local_time = local
        else
          _setup_(local)
        end
      end

      # When::TM::Clock のローカルタイムを読みだす
      #
      # @return [When::Parts::Timezone::Base]
      #
      def local_time
        _local_time[1]
      end

      # When::TM::Clock のローカルタイムが設定されているか?
      #
      # @return [true, false]
      #
      def is_local_time_set?
        _local_time[0]
      end

      # 共通処理
      def _local_time
        case @local_time
        when Array  ; @local_time
        when nil    ; @local_time = [false, When::UTC]
        when String ; @local_time = [true,  When::Parts::Timezone[@local_time] ||
                                            When::V::Timezone[@local_time]     ||
                                            When.Clock(@local_time)]
        else        ; @local_time = [true,  @local_time]
        end
      end
      private :_local_time

      # @private
      def get_clock(options)
        get_clock_option(options) || local_time
      end

      # @private
      def get_clock_option(options)
        clock = options.delete(:clock)
        tz    = options.delete(:tz)
        tz ? (When::V::Timezone[tz] || When::Parts::Timezone[tz]) : clock
      end

      # @private
      def to_hms(hms, extended=true)
        case hms
        when Numeric
          sgn    = (hms >= 0) ? '+' : '-'
          hh, mm = hms.abs.divmod(3600)
          mm, ss = mm.divmod(60)
          ss, ff = ss.divmod(1)
          ff     = (ff == 0 ||  When::STRING <= When::SECOND) ? '' :
                   ("%.#{When::STRING - When::SECOND}f" % ff)[1..-1]
          ss     = (ss == 0 && ff == '') ? '' : ("%02d" % ss)
          mm     = "%02d"  % mm
          hh     = "%02d" % hh
        when /\A([-+])(\d{2})([:=*])?(\d{2})?([:=*])?(\d{2})?(\.\d+)?\z/
          sgn, hh, d1, mm, d2, ss, ff = $~[1..7]
          ff   ||= ''
          ss   ||= ''
          mm   ||= ''
        else
          return nil
        end

        if (extended)
          d1 ||= (mm=='') ? '' : ':'
          d2 ||= (ss=='') ? '' : ':'
        else
          d1   = ''
          d2   = ''
        end
        sgn + hh + d1 + mm + d2 + ss + ff
      end
    end

    # この時法の基点となる事象
    #
    # Event used as the datum for this clock
    #
    # @return [String]
    #
    # @note
    #   new の options 引数に :reference_event があれば設定される。
    #   ライブラリとしては本変数を参照していない。下記の振る舞いを String で説明するため用いてもよい。
    #
    # @note
    #   日付の境界が午前0時でない場合、When::Coordinates::Temporal.border により、境界が指定される。
    #   border, behavior メソッドをオーバーライドすることで、日の出、日の入りなど event 時刻が一定
    #   しない場合にも対応する。
    #
    attr_reader :reference_event
    alias :referenceEvent :reference_event

    # この時法による参照事象の時刻
    #
    # Time of the reference event for this clock
    #
    # @return [When::TM::ClockTime]
    #
    attr_reader :reference_time
    alias :referenceTime :reference_time

    # UTCによる参照事象の時刻
    #
    # UTC time of the reference event
    #
    # @return [When::TM::ClockTime]
    #
    attr_reader :utc_reference
    alias :utcReference :utc_reference

    # 一暦日の中の時間位置を定めるために、この時計とともに使用する暦 (relation - Resolution)
    #
    # The calendar that is used with this clock to define
    # temporal position within a calendar day
    #
    # @return [Array<When::TM::Calendar>]
    #
    attr_reader :date_basis
    alias :dateBasis :date_basis

    # 時刻制 - additional attribute
    #
    # @return [When::TimeStandard]
    #
    attr_reader :time_standard

    # この時法を生成した時間帯プロパティ - additional attribute
    #
    # @return [When::V::TimezoneProperty]
    #
    # @note
    #   When::TM::TemporalPosition に対して加減算を行うと、時間帯が変わる可能性がある。
    #   本変数により、時間帯決定ルール(When::V::TimezoneProperty#rrule)を参照する。
    #
    attr_accessor :tz_prop
    alias :tzProp :tz_prop

    # universal_timeとこの時法の最小単位との比 - additional attribute
    #
    # @return [Numeric]
    #
    attr_reader :second

    # この時法のUTCとの差(ISO 8601 extended format) - additional attribute
    #
    # @return [String] (±hh:mm)
    #
    attr_reader :zone
    alias :to_extended :zone

    # 時間の歩度
    #
    # @return [Numeric]
    #
    def rate_of_clock
      @time_standard.rate_of_clock
    end

    # 128秒単位の実数による参照事象の時刻
    #
    # Fraction time of the reference event
    #
    # @param [Integer] sdn 参照事象の通し番号(ダミー)
    #
    # @return [Numeric]
    #
    #   T00:00:00Z からの参照事象の経過時間 / 128秒
    #
    def universal_time(sdn=nil)
      return @utc_reference.universal_time
    end

    # この時法の時刻をUTC時刻に変換する
    #
    # @param [When::TM::ClockTime] u_time
    #
    # @return [When::TM::ClockTime]
    #
    def utc_trans(u_time)
      return When::UTC.to_clk_time(self.to_universal_time(u_time.clk_time))
    end
    alias :utcTrans :utc_trans

    # UTC時刻をこの時法の時刻に変換する
    #
    # @param [When::TM::ClockTime] clk_time
    #
    # @return [When::TM::ClockTime]
    #
    def clk_trans(clk_time)
      return self.to_clk_time(When::UTC.to_universal_time(u_time.clk_time))
    end
    alias :clkTrans :clk_trans

    # この時法の時刻を128秒単位の実数に変換する
    #
    # @param [Array<Numeric>] clk_time
    #
    # @return [Numeric]
    #
    def to_universal_time(clk_time)
      return _coordinates_to_number(_decode(clk_time)) / @second
    end

    # 128秒単位の実数をこの時法の時刻に変換する
    #
    # @param [Numeric] fod
    #
    # @return [When::TM::ClockTime]
    #
    def to_clk_time(fod, options={})
      options[:frame] = self
      fod, second = fod.trunk, fod.branch / fod.second if fod.kind_of?(When::Coordinates::LeapSeconds)
      clk_time = ClockTime.new(_encode(_number_to_coordinates(fod * @second)), options)
      return clk_time if (second||0) == 0
      clk_time.clk_time[-1] += second
      return clk_time
    end

    # 時刻をNumeric(serial time)に変換する
    #
    # @param [Numeric] clk_time
    #
    # @return [Numeric] serial time
    #
    def _coordinates_to_number(clk_time)
      u = 1
      s = 0
      (@base.length-1).downto(1) do |i|
        s += u * (+clk_time[i] - @base[i]) if (clk_time[i])
        u *= @unit[i]
      end
      return  s + u * (+clk_time[0]) + @origin_of_LSC
    end

    # Numeric(serial time)を時刻に変換する
    #
    # @param [Numeric] serial_time
    #
    # @return [Numeric]
    #
    def _number_to_coordinates(serial_time)
      time = [serial_time-@origin_of_LSC]
      (@base.length-1).downto(1) do |i|
        carry, time[0] = (+time[0]).divmod(@unit[i])
        time[0] += @base[i]
        time.unshift(carry)
      end
      return time
    end

    #
    # _m17n_form のための要素生成
    #
    # @param [Hash] options 下記のとおり
    # @option options [Symbol] :method :to_m17n なら時間帯名を返す、その他は When::Parts::Resource#to_h 参照
    #
    # @private
    def _to_hash_value(options={})
      options[:method] == :to_m17n ? tzname(:hash)[0] : super
    end

    # この時法のUTCとの差(ISO 8601 basic format)
    #
    # @return [String] (±hhmm)
    #
    def to_basic
      return '' unless @zone
      @zone.gsub(/:/, '')
    end

    # 期間オブジェクトの桁数合わせ
    # @private
    def _arrange_length(period)
      return period unless period.kind_of?(Array)
      diff = @indices.length - period.length + 1
      return period if (diff == 0)
      return (diff > 0) ? period + Array.new(diff, 0) : period[0...diff]
    end

    # 時刻配列の分解能
    # @private
    def _precision(time, default=nil)
      nil_index = time.index(nil) || time.length
      precision = nil_index - 1 if (nil_index < @base.length || time[-1].kind_of?(Integer))
      When::Coordinates::Index.precision(default || precision)
    end

    # 丸め量 / When::TM::Duration::SYSTEM
    # @private
    def _round_value(precision)
      offset = When::TM::Duration::DAY / 2
      precision.times do |i|
        offset /= @unit[i+1] ? @unit[i+1] : 10
      end
      offset
    end

    # この時法の時間帯名
    #
    # @param [Symbol] format
    #   - :extended ISO 8601 extended format (default)
    #   - :basic    ISO 8601 basic format
    #   - :hash     時間帯名の後ろにISO 8601 extended format を付加する
    #
    # @return [Array<String>]
    #
    # @note
    #   :extended または :basicが指定され、上記は時間帯名が定義されていない場合は、ISO 8601形式で返す
    #
    def tzname(format=:extended)
      name   = @tz_prop.tzname if @tz_prop.kind_of?(When::V::TimezoneProperty) && format != :hash
      name ||= format == :basic ? to_basic : @zone
      name   = Array(name)
      return name unless format == :hash
      tzid = case @tz_prop
        when When::V::TimezoneProperty ; @tz_prop['..'].property['tzid'].object
        when When::Parts::Timezone     ; @tz_prop.timezone.name
        else                           ; ''
        end
      name[0] = tzid + name[0]
      name
    end

    # 標準時間帯の時計
    # @return [When::TM::Clock]
    def standard
      _tz_prop ? _tz_prop.standard : self
    end

    # 夏時間帯の時計
    # @return [When::TM::Clock]
    def daylight
      _tz_prop ? _tz_prop.daylight : self
    end

    # 夏時間帯と標準時間帯の時間差
    # @return [When::TM:IntervalLength]
    def tz_difference
      _tz_prop ? _tz_prop.tz_difference : 0
    end

    # 夏時間の有無
    # @private
    def _need_validate
      _tz_prop ? _tz_prop._need_validate : false
    end

    # 夏時間
    # @private
    def _daylight(time)
      _tz_prop ? _tz_prop._daylight(time) : self
    end

    private

    # Timezone オブジェクト
    def _tz_prop
      @tz_prop.kind_of?(When::V::TimezoneProperty) ? @tz_prop._pool['..'] : @tz_prop
    end

    # オブジェクトの正規化
    def _normalize(args=[], options={})
      @indices ||= DefaultTimeIndices

      # note
      @note    ||= 'JulianDay'

      # normalize spatial module
      _normalize_spatial

      # normalize temporal module
      _normalize_temporal

      # second
      @second = (@second||1/When::TM::Duration::SECOND).to_f

      # zone
      @zone   = Clock.to_hms(@zone || @label || @reference_event)

      # time_standard
      @time_standard   = When.Resource(@time_standard||'UniversalTime', '_t:') unless @time_standard.kind_of?(When::TimeStandard)

      # utc_reference
      @utc_reference ||= @zone ? ClockTime.new(@zone.to_s, {:frame=>When::UTC}) : Clock.local_time

      # reference_time & origin_of_LSC
      case @reference_time
      when Array     ; clk_time = @reference_time
      when String    ; clk_time = Pair._en_pair_date_time(@reference_time)
      when ClockTime ; clk_time = @reference_time.clk_time
      when nil       ; clk_time = [0, 0]
      else           ; raise TypeError, "reference_time type mismatch"
      end
      @origin_of_LSC   -= (to_universal_time(clk_time) - @utc_reference.universal_time) * @second
      @reference_time   = ClockTime.new(clk_time, {:frame=>self})
    end
  end

  # 時間座標系
  #
  # see {http://schemas.opengis.net/gml/3.1.1/base/temporalReferenceSystems.xsd#TimeCoordinateSystemType gml schema}
  #
  class CoordinateSystem < ReferenceSystem

    # グレゴリオ暦の日付及びその日のUTCの時刻で表現する、座標参照系の尺度の原点位置
    #
    # Position of the origin of the scale on which the temporal coordinate
    # system is based expressed as a date in the Gregorian calendar and
    # time of day in UTC
    #
    # @return [When::BasicTypes::DateTime]
    #
    attr_reader :origin

    # この参照系の軸で時間の参照単位とする間隔
    #
    # Standard unit of time used to measure duration
    # on the axis of the coordinate system
    #
    # @return [When::TM::Duration] (changed from String)
    #
    attr_reader :interval

    # この時間参照系の座標値をグレゴリオ暦及びUTC時刻に変換する
    #
    # @param [When::TM::Coordinate] c_value
    #
    # @return [When::TM::DateAndTime] (When::TM::BasicTypes::DateTimeはまちがい)
    #
    def transform_coord(c_value)
      When::Gregorian.jul_trans(JulianDate.universal_time(c_value.universal_time, {:frame=>When::UTC}))
    end
    alias :transformCoord :transform_coord

    # グレゴリオ暦及びUTC時刻をこの時間参照系の座標値に変換する
    #
    # @param [When::TM::DateAndTime (BasicTypes::DateTimeはまちがい)] date_time
    #
    # @return [When::TM::Coordinate]
    #
    def transform_date_time(date_time)
      Coordinate.universal_time(date_time.universal_time, {:frame=>self})
    end
    alias :transformDateTime :transform_date_time

    private

    # オブジェクトの正規化
    def _normalize(args=[], options={})
      @origin   = When.when?(@origin, options)
      @interval = When.Duration(@interval)
      raise TypeError, "Interval should be IntervalLength" unless @interval.kind_of?(IntervalLength)
    end
  end

  # 順序時間参照系
  #
  # see {http://schemas.opengis.net/gml/3.1.1/base/temporalReferenceSystems.xsd#TimeOrdinalEraType gml schema}
  #
  class OrdinalEra < When::TM::Object

    include Separation

    # この順序年代を識別する名称
    #
    # Name that identifies a specific ordinal era
    #
    # @return [String]
    #
    alias :name :label

    # この順序年代をさらに分割する順序年代
    #
    # Ordinal eras that subdivide this ordinal era
    #
    # @return [Array<When::TM::OrdinalEra>]
    #
    alias :member :child

    # この順序年代が属する順序時間参照系 (relation - Structure)
    #
    # Ordinal reference system that contains this ordinal era
    #
    # @return [When::TM::OrdinalReferenceSystem, nil]
    #
    def system
      _pool['..'].kind_of?(String) ? _pool['..'] : nil
    end

    # この順序年代が属する上位順序年代 (relation - Composition)
    #
    # Ordinal era that contains this ordinal era
    #
    # @return [When::TM::OrdinalEra, nil]
    #
    def group
      _pool['..'].kind_of?(String)? nil : _pool['..']
    end

    # この順序年代が始まる時点
    #
    # Date at which the ordinal era began
    #
    # @return [When::BasicTypes::DateTime]
    #
    attr_reader :begin

    # この順序年代が終わる時点
    #
    # Date at which the ordinal era ended
    #
    # @return [When::BasicTypes::DateTime]
    #
    def end
      @end || (@_pool['.->'] ? @_pool['.->'].begin : nil)
    end

    # 日時が属するか?
    #
    # @param [When::TM::TemporalPosition] other
    #
    # @return [Boolean]
    #   [ true  - 属する   ]
    #   [ false - 属さない ]
    #
    def include?(other)
      self.begin <= other && other < self.end
    end

    # When::TM::TemporalPosition ^ When::TM::OrdinalEra で呼ばれる
    # @private
    def ^(other)
      include?(other) ? self : nil
    end

    private

    # オブジェクトの正規化
    def _normalize(args=[], options={})
      # options
      @options ||= {}
      term_options    = @options.merge({'namespace'=>@namespace, 'locale'=>@locale})

      label, begun, ended = args

      # label
      @label = label if label
      @label = m17n(@label, nil, nil, term_options) if (@label.instance_of?(String))
      @label._pool['..'] ||= self
      @_pool[@label.to_s]  = @label

      # begin
      @begin = begun if begun
      @begin = When.when?(@begin, @options) if @begin
      @begin = @child[0].begin if !@begin && @child[0]

      # end
      @end   = ended if ended
      @end   = When.when?(@end,   @options) if @end
      @end   = @child[-1].end if !@end && @child[-1]
    end

    # その他のメソッド
    #
    # @note
    #   When::TM::OrdinalEra で定義されていないメソッドは
    #   処理を @begin (type: When::TM::TemporalPosition) に委譲する
    #
    def method_missing(name, *args, &block)
      self.class.module_eval %Q{
        def #{name}(*args, &block)
          @begin.send("#{name}", *args, &block)
        end
      } unless When::Parts::MethodCash.escape(name)
      @begin.send(name, *args, &block)
    end
  end

  # 暦年代
  #
  # see {http://schemas.opengis.net/gml/3.1.1/base/temporalReferenceSystems.xsd#TimeCalendarEraType gml schema}
  #
  class CalendarEra < When::TM::Object

    class << self

      include When::Parts::Resource::Pool

      # When::TM::CalendarEra Class のグローバルな設定を行う
      #
      # @param [Array<String>] order When::TM::CalendarEra の検索順序を指定するIRI文字列のArray
      #
      # @return [void]
      #
      # @note
      #   本メソッドでマルチスレッド対応の管理変数の初期化を行っている。
      #   このため、本メソッド自体はスレッドセーフでない。
      #
      def _setup_(order=nil)
        @_lock_ = Mutex.new if When.multi_thread
        @_pool  = {}
        @order  = order || DefaultEpochs
      end

      # 設定情報を取得する
      #
      # @return [Hash] 設定情報
      #
      def _setup_info
        {:order => @order || _setup_}
      end

      # When::TM::CalendarEra オブジェクトを検索し取得する
      #
      # @overload _instance(key, epoch=nil, reverse=nil, options={})
      #   @param [String, Regexp] key     検索する暦年代または、暦年代にマッチする正規表現
      #   @param [Integer]        epoch   年数を昇順にカウントする方式での暦元(0年)の通年(デフォルトは nil - 指定なし)
      #   @param [Integer]        reverse 年数を降順にカウントする方式での暦元(0年)の通年(デフォルトは nil - 指定なし)
      #   @param [Hash] options 以下の通り
      #   @option options [String]  :area   暦年代の使用地域の指定(デフォルトは nil - 指定なし)
      #   @option options [String]  :period 暦年代の使用時代の指定(デフォルトは nil - 指定なし)
      #   @option options [Integer] :count  何件ヒットするまで検索するかを指定(デフォルトは 1件)
      #   @option options [String]  the_others 例えば When::TM::CalendarEra オブジェクトの epoch_of_use に 'name' などの
      #                                        指定がある場合、:name に指定しておけば、検索での絞り込みに使用できる。
      #
      # @note 検索用のインデクスはインスタンスの生成時に作成する。
      #       作成後にキーワードとなる年号(M17nクラス)にローケールが追加されても反映されない。
      #
      def _instance(*args)
        # パラメータ
        args    = args.dup
        options = (args[-1].kind_of?(Hash)) ? args.pop.dup : {}
        key, epoch, reverse = options.delete(:label) || args
        key = When::Locale.ideographic_unification(key)
        if key.kind_of?(String)
          key, *parents = key.split(/::/).reverse
        else
          parents = []
        end
        area    = options.delete(:area)
        period  = options.delete(:period)
        count   = options.delete(:count) || 1

        # 候補
        _setup_ unless @_pool
        pool = _candidates(options, area, period, key, epoch,  false) +
               _candidates(options, area, period, key, reverse, true)
        _compact(pool, parents)
        return pool unless pool.size < count

        order = @order
        if /\?.+?=/ =~ parents[-1]
          begin
            head  = When.CalendarEra(parents[-1])
            order = order.dup.unshift(head)
          rescue
          end
        end
        order.each do |iri|
          When.CalendarEra(iri)
          pool = _candidates(options, area, period, key, epoch,  false) +
                 _candidates(options, area, period, key, reverse, true)
          _compact(pool, parents)
          return pool unless pool.size < count
        end

        return []
      end

      private

      # 候補の抽出
      def _candidates(options, area, period, key, epoch, reverse)
        regexp, key = key if key.kind_of?(Regexp)
        return [] unless @_pool[area] &&
                         @_pool[area][period] &&
                         @_pool[area][period][key] &&
                         @_pool[area][period][key][epoch]
        pool = @_pool[area][period][key][epoch].dup
        pool.delete_if {|e| regexp !~ e.name} if regexp
        return pool if options.empty?
        pool.delete_if {|e| !_match(e, reverse, options) }
      end

      def _match(epoch, reverse, options)
        return false unless epoch.reverse? == reverse
        target = {:reference_event  => epoch.reference_event,
                  :reference_date   => epoch.reference_date,
                  :julian_reference => epoch.julian_reference
                 }
        options.each_pair do |k,v|
          return false unless (v === (target.key?(k) ? target[k] : epoch.options[k]))
        end
        return true
      end

      def _compact(pool, parents)
        pool.uniq!
        return if parents.empty?
        pool.delete_if {|e|
          !parents.each do |parent|
            e = e.parent
            break false unless parent == e.name
          end
        }
      end

      def _behalf_of(iri)
        base = iri.dup.sub!('/TM/CalendarEra/','/CalendarTypes/')
        return nil unless base
        calendar = When::Parts::Resource._instance(base)
        date     = When.tm_pos(1, {:frame=>calendar}).floor
        options  = {:label=>calendar.label, '..'=>iri}
        %w(period area).each do |name|
          value  = calendar.instance_variable_get('@' + name)
          options[name.to_sym] = value if value
        end
        era = self.new(date, '@CE', date, options)
        era.send(:_register_calendar_era)
        era
      end
    end

    # @private
    HashProperty =
      [:reference_event, :reference_date, :julian_reference, :dating_system, # :epoch_of_use
       :epoch, :epoch_year, :options]

    # この暦年代を識別する名称
    #
    # Name by which this calendar era is known
    #
    # @return [String]
    #   通常 String のサブクラスである When::BasicTypes::M17n を使用する。
    #
    alias :name :label

    # この暦年代の基点となる事象
    #
    # Event used as the datum for this calendar era
    #
    # @return [String]
    #   通常 String のサブクラスである When::BasicTypes::M17n を使用する。
    #
    # @note
    #   [Accession,代始]::       天皇・皇帝などの代始めの改元,必ずしも践祚と連動しない。
    #   ::                       JIS X7108 附属書D表3に参照事象の例として「新しい天皇の即位」とある。
    #   ::                       これは践祚を意味するので、岡田芳朗氏によれば適切ではないとのこと。
    #   ::                       英語には適切な訳語がないと思われる。
    #   [FelicitousEvent,祥瑞]:: 祥瑞の発生に伴う改元
    #   [NaturalDisaster,災異]:: 災異の発生に伴う改元
    #   [InauspiciousYear,革年]:: 甲子革令・辛酉革命説による改元
    #   [Foundation,創業]:: 建国による元号の制定
    #   [CalendarReform,改暦]:: 改暦に伴う epoch_of_use の境界
    #
    attr_reader :reference_event
    alias :referenceEvent :reference_event

    # この暦による参照事象の日付
    #
    # Date of the reference event in the calendar being described
    #
    # @return [When::TM::CalDate]
    #
    # @note
    #   明治以前の改元は当該年の初めにに遡って適用された。しかし、日記などの資料は当然旧年号で
    #   記載されている。このような場合、reference_date の分解能を「年」とする。
    #   本ライブラリでは、reference_date の分解能が「年」の場合、When::TM::TemporalPosition._instance
    #   の options[:lower] で年号使用の下限を年初とするか、epoch_of_use の下限とするかを
    #   指定することができる。
    #
    attr_reader :reference_date
    alias :referenceDate :reference_date

    # 参照事象のユリウス日
    #
    # Julian date of the reference event
    #
    # @return [When::TM::JulianDate]
    #
    attr_reader :julian_reference
    alias :julianReference :julian_reference

    # この暦年代が日付の基礎として使用する期間
    #
    # Period for which the era was used as a basis for dating
    #
    # @return [Array<When::TM::TemporalPosition>]
    #
    # @note
    #   途中の改暦を指定するために要素が必要になることがあり、要素数が2を超えることがある。
    #   最初の要素が When::TimeValue::MIN(-Infinity)の場合、年数を降順にカウントする。
    #   暦年代の分解能を“日”より細かくすることはできない。
    #
    attr_reader :epoch

    # この暦年代と関連付けられた暦 (relation - Basis)
    #
    # The calendar associated with the calendar eras being described
    #
    # @return [Array<When::TM::Calendar>]
    #
    attr_reader :dating_system
    alias :datingSystem :dating_system

    # この暦年代の元年の年番号(additional attribute)
    #
    # The year number of the calendar associated with the first year of this calendar era
    #
    # @return [Integer]
    #
    attr_reader :epoch_year
    alias :epochYear :epoch_year

    # その他の属性 - additional attribute
    #
    # @return [Hash]
    #   [ 'area'   => 暦年代の使用地域 [When::BasicTypes::M17n] ]
    #   [ 'period' => 暦年代の使用時代 [When::BasicTypes::M17n] ]
    #   [ the others => epoch_of_use の 'name' などの指定を反映 [String] ]
    #
    attr_reader :options

    # この暦年代が日付の基礎として使用する期間
    #
    # Period for which the era was used as a basis for dating
    #
    # @return [When::TM::Period]
    #
    # @note
    #   epoch_of_use メソッドの戻り値は ISO19108 で When::TM::Period と規定されている。
    #   このため変数 @epoch とは別に、本メソッドを提供する。
    #
    def epoch_of_use
      @epoch_of_use ||=
        Period.new(*([0, -1].map {|i|
          date = @epoch[i]
          if date.kind_of?(CalDate)
            options = date._attr
            options[:frame] = options.delete(:clock)
            date = JulianDate.universal_time(date.universal_time, options)
          end
          Instant.new(date) # See JIS X7108 5.3.2.2 e) When::TM::Period は直接 JulianDate を保持できない
        }))
    end
    alias :epochOfUse :epoch_of_use

    # 年数の数え方
    #
    # @return [Boolean]
    #   [ true  - 降順 (Before Common Era 方式)]
    #   [ false - 昇順 (Common Era 方式) ]
    #
    def reverse?
      @epoch[0].indeterminated_position == When::TimeValue::Min
    end

    # 未来永劫使用するか?
    #
    # @return [Boolean]
    #   [ true  - する   ]
    #   [ false - しない ]
    #
    def unlimited?
      @epoch[-1].indeterminated_position == When::TimeValue::Max
    end

    # 時間の歩度
    #
    # @return [Numeric]
    #
    def rate_of_clock
      _typical_epoch.time_standard.rate_of_clock
    end

    # 当該の暦年代の日付に変換する
    #
    # @param [When::TM::TemporalPosition] date
    # @param [Hash] trans_options 以下の通り
    # @option trans_options [Hash] :lower 暦年代適用の下限
    #   [ true            - epoch_of_use の始め(省略時) ]
    #   [ :reference_date - 参照事象の日付 ]
    # @option trans_options [Hash] :upper 暦年代適用の上限
    #   [ true            - epoch_of_use の終わり(省略時) ]
    #   [ :reference_date - 参照事象の日付 ]
    #
    # @return [When::TM::TemporalPosition]
    #   [ When::TimeValue::Before - 当該の暦年代より前の日付である ]
    #   [ When::TimeValue::After  - 当該の暦年代より後の日付である ]
    #   [ その他 - 当該の暦年代の日付に変換された When::TM::TemporalPosition ]
    #
    def trans(date, trans_options={})
      # 当該日付の決定
      date = Position.any_other(date, trans_options) unless date.kind_of?(Array)
      epoch, cal_date = 
        case date
        when Array                   ; _trans_array(date)
        when JulianDate, DateAndTime ; _trans_date(date, date.clock)
        when When::TimeValue         ; _trans_date(date)
        when Numeric                 ; _trans_date(JulianDate.universal_time((date-JulianDate::JD19700101)*Duration::DAY))
        else ; raise TypeError, "Irregal Seed Date Type"
        end
      return epoch unless cal_date

      # 上下限の確認
      trans_options ||= {}
      return When::TimeValue::Before if cal_date.to_i < lower_bound(trans_options[:lower] || :reference_date)
      return When::TimeValue::After  if cal_date.to_i > upper_bound(trans_options[:upper] || true)

      # 発見した日時の属性設定
      cal_date.send(:calendar_era=, self)
      cal_date.send(:calendar_era_name=, [@label, @epoch_year, reverse?, cal_date.to_i < @epoch[0].to_i])
      cal_date.cal_date[0]      -= @epoch_year
      cal_date.trans             = trans_options.dup
      cal_date.query             = (epoch.query || {}).dup
      return cal_date
    end

    # When::TM::TemporalPosition ^ When::TM::CalendarEra で呼ばれる
    # @private
    def ^(date, options={})
      date = Position.any_other(date, options)
      cal_date = trans(date, (date.trans||{}).merge(options))
      return nil unless cal_date.kind_of?(CalDate)
      return cal_date
    end

    # other と @julian_reference とを比較する
    #
    # @param [Comparable] other 比較対象
    #
    # @return [Integer] 比較結果を 負, 0, 正の値で返す
    #
    def <=>(other) #TODO @precision は?
      @julian_reference.universal_time <=> other.julian_reference.universal_time
    end

    # 暦年代の下限
    # @private
    def lower_bound(type=nil)
      @lower_bound[type] ||= @epoch[0].indeterminated_position == When::TimeValue::Min  ? -Float::MAX :
        @reference_date.precision == When::YEAR &&
        @reference_date.cal_date[When::YEAR-1] == 0 ? @epoch[0].ceil(When::YEAR).to_i :
        case type
        when true            ;  @epoch[0].to_i
        when :reference_date ;  @reference_date.to_i
        else                 ; [@reference_date.to_i, @epoch[0].to_i].min
        end
    end

    # 暦年代の上限
    # @private
    def upper_bound(type=nil)
      @upper_bound[type] ||= @epoch[-1].indeterminated_position == When::TimeValue::Max ? +Float::MAX :
        begin
          next_era = succ
          next_ref = next_era.reference_date if next_era.respond_to?(:reference_date)
          next_ref &&
          next_ref.precision == When::YEAR &&
          next_ref.cal_date[When::YEAR-1] == 0 ? @epoch[-1].ceil(When::YEAR).to_i - 1 :
          case type
          when true            ;  @epoch[-1].to_i - 1
          when :reference_date ;  @reference_date.to_i
          else                 ; [@reference_date.to_i, @epoch[-1].to_i - 1].max
          end
        end
    end

    protected

    # @private
    def _normalize_leaf_era
      # r_date and others
      case @reference_date
      when String  ; format, r_date, r_era = When::BasicTypes::DateTime._to_array(@reference_date)
      when Array   ; r_era, *r_date        = @reference_date
      when CalDate ; r_era,  r_date        = @reference_date.calendar_era_name, @reference_date.cal_date
      when nil     ;
      else         ; raise TypeError, "ReferenceDate is invalid type"
      end
      r_era, r_year = r_era

      epochs = @epoch.dup
      epochs.shift if (epochs[0].indeterminated_position == When::TimeValue::Min)
      # j_date and calculated reference_date !((julian_reference == nil) && (reference_date != nil))
      if @julian_reference
        jdn = @julian_reference.to_i
        epoch = epochs[0]
        epochs.each do |e|
          if (e.indeterminated_position == When::TimeValue::Max)
            epoch = e
            break
          elsif (jdn < e.to_i)
            break
          else
            epoch = e
          end
        end
        @reference_date = epoch.frame.jul_trans(When.when?(jdn), {:frame=>epoch.frame})
        j_date = @reference_date.cal_date
      elsif (@reference_date == nil)
        @reference_date = epochs[0].dup
        j_date = @reference_date.cal_date
      end

      # epoch_year
      @epoch_year ||= r_year
      @epoch_year = @epoch_year.to_i if (@epoch_year)
      raise ArgumentError, "EpochYear mismatch" unless (@epoch_year == r_year)
      unless @epoch_year
        raise ArgumentError, "ReferenceDate is absent" unless r_date
        @epoch_year = epochs[0].cal_date[0] * 1 - r_date[0] * 1
      end

      # j_date and calculated reference_date ((julian_reference == nil) && (reference_date != nil))
      unless j_date
        j_date = [+r_date[0]+@epoch_year, *r_date[1..-1]]
        epochs.each_index do |i|
          e = epochs[i]
          d = CalDate.new(j_date,{:frame=>e.frame})
          if (e.indeterminated_position == When::TimeValue::Max)
            @reference_date = d
            break
          elsif (d.to_i < e.to_i)
            @reference_date = d if (i==0)
            break
          else
            @reference_date = d
          end
        end
      end

      # julian_reference and reference_date
      @julian_reference = JulianDate.universal_time(@reference_date.universal_time)
      @reference_date.cal_date[0] -= @epoch_year
      @reference_date.send(:calendar_era_name=, [(r_era ? r_era : @label), @epoch_year])
      if (r_date)
        raise ArgumentError, "JulianReference and ReferenceDate are mismatch" unless (@epoch_year == +j_date[0]-(+r_date[0]))
        raise ArgumentError, "JulianReference and ReferenceDate are mismatch" unless (j_date[1..-1] == r_date[1..-1])
        #raise ArgumentError, "JulianReference and ReferenceDate are mismatch" unless (j_date == r_date)
        if    (r_date[1] == nil)
          @reference_date.precision = When::YEAR
        elsif (r_date[2] == nil)
          @reference_date.precision = When::MONTH
        end
      end
    end

    # @private
    def _register_calendar_era
      return unless @label.kind_of?(When::BasicTypes::M17n)

      # dating_system
      @dating_system = (@epoch.map {|e| e.frame}).compact.uniq
      ancestors     = hierarchy.inject(['']) {|list,era|
        list << list[-1] + '::' + era.label.to_s
        list
      }

      if @epoch.length == 1
        epoch[0].frame.synchronize {
          range = When::Parts::GeometricComplex.new([[epoch[0],true]])
          ancestors.each do |ancestor|
            epoch[0].frame.domain[ancestor]   |= range
          end
        } if epoch[0].frame
      elsif reverse?
        epoch[1].frame.synchronize {
          range = When::Parts::GeometricComplex.new([[epoch[1],true]], true)
          ancestors.each do |ancestor|
            epoch[1].frame.domain[ancestor]   |= range
          end
        } if epoch[1].frame
      else
        (epoch.length-1).times do |i|
          epoch[i].frame.synchronize {
            range = When::Parts::GeometricComplex.new([[epoch[i],true], [epoch[i+1],false]])
            ancestors.each do |ancestor|
              epoch[i].frame.domain[ancestor] |= range
            end
          } if epoch[i].frame
        end
      end

      @dating_system.each do |f|
        f.synchronize do
          f.reference_frame << self
          f.reference_frame.uniq!
          f.reference_frame.sort!
          first = f.domain[''].first(When::MinusInfinity)
          last  = f.domain[''].last(When::PlusInfinity)
          f.domain_of_validity = When::EX::Extent.new(
                                   When::TM::Period.new(
                                     When::TM::Instant.new(first),
                                     When::TM::Instant.new(last))) if first && first <= last
        end
      end

      # インデクス登録
      ((@area||{}).values + [nil]).each do |a|
        self.class[a] ||= {}
        ((@period||{}).values + [nil]).each do |p|
          self.class[a][p] ||= {}
          (@label.values + [nil]).each do |k|
            self.class[a][p][k] ||= {}
            [@epoch_year, nil].each do |e|
              self.class[a][p][k][e] ||= []
              self.class[a][p][k][e] << self
            end
          end
        end
      end
    end

    private

    # オブジェクトの正規化
    def _normalize(args=[], options={})
      # area, period
      term_options = {:namespace=>@namespace, :locale=>@locale, :options=>options}
      @area        = m17n(@area,   nil, nil, term_options) if @area.instance_of?(String)
      @period      = m17n(@period, nil, nil, term_options) if @period.instance_of?(String)

      # 暦年代の上下限
      @lower_bound = {}
      @upper_bound = {}

      # other attributes
      if @child && @child.length>0
        _non_leaf_era(args, term_options)
        _register_calendar_era unless _pool['..'].kind_of?(CalendarEra)
        @child.each do |era|
          era._register_calendar_era
        end
      else
        _set_leaf_era(args, term_options)
        _normalize_leaf_era unless @epoch[0].indeterminated_position == When::TimeValue::Min
      end
    end

    def _non_leaf_era(args, term_options)
      @label = m17n(@label, nil, nil, term_options) if @label.instance_of?(String)
      if @label
        @label._pool['..']  = self # TODO ここを ||= にすると leaf? の判定がおかしくなる
        @_pool[@label.to_s] = @label
      end

      # reference_date, reference_event & label
      @reference_date    = @child[0].reference_date
      @reference_event   = @child[0].reference_event
      @epoch_year        = 0 # @child[0].epoch_year
      @julian_reference  = @child[0].julian_reference

      # options
      @options ||= {}
      @options.update({'area'=>@area, 'period'=>@period})

      # epoch
      @epoch = []
      @child.each do |c|
        c.epoch.each do |e|
          @epoch << e unless e == @epoch[-1]
        end
      end
    end

    def _set_leaf_era(args, term_options)
      # 変数の読み込み
      reference_date, reference_event, *epochs = args

      # reference_date & label
      if reference_date
        @reference_date = reference_date
        @label        ||= m17n(@reference_date[/\A\[[^\]]+\]|^[^-+0-9]+/], nil, nil, term_options)
      end
      @label._pool['..'] ||= self
      @_pool[@label.to_s]  = @label

      # reference_event
      @reference_event   = reference_event if reference_event
      @reference_event ||= ""
      @reference_event   = DefaultEvents[@reference_event] if DefaultEvents[@reference_event]
      @reference_event   = m17n(@reference_event, nil, nil, term_options) if @reference_event.instance_of?(String)
      @reference_event._pool['..'] ||= self
      @_pool[@reference_event.to_s]  = @reference_event

      # options
      term_options[:options][:query] ||= {}
      @options ||= {}
      @options.update(term_options[:options][:query])
      @options.update({'area'=>@area, 'period'=>@period})

      # epoch
      @epoch    ||= epochs
      @epoch[0] ||= '-Infinity'
      @epoch[1] ||= '+Infinity'
      term_options[:options][:frame] ||= When::Gregorian
      epoch = ''
      @epoch = @epoch.map {|e|
        case e
        when ''
          When.when?('+Infinity')
        when String
          d, f = e.split(/\^{1,2}/)
          term_options[:options][:frame] = When.Resource(f, '_c:') if (f)
          d.split(/;/).each do |v|
            v.strip!
            if (v =~ /\A[-+\d]|^Now$|^Unknown$|^[-+]Infinity\z/i)
              epoch = v
              break
            end
            k, c = v.split(/\s*[:=]\s*/, 2)
            if (c.kind_of?(String))
              code = m17n(c.gsub(/%2C/,','), nil, nil, term_options)
              @_pool[code.to_s] ||= code
              @options[k] = term_options[:options][:query][k] = @_pool[code.to_s]
            else
              @options.delete(k)
              term_options[:options][:query].delete(k)
            end
          end
          When.when?(epoch, @options.merge({:frame=>term_options[:options][:frame], :validate=>:epoch}))
        else
          e
        end
      }

      # normalize for last era
      last_era = _pool['..'].child[-1] if _pool['..'].kind_of?(CalendarEra)
      if last_era
        if last_era.epoch[0].indeterminated_position == When::TimeValue::Min
          last_era.epoch[0].frame = @epoch[0].frame
          last_era.epoch[1]       = @epoch[0]
          last_era._normalize_leaf_era
        elsif last_era.epoch[-1].indeterminated_position == When::TimeValue::Max
          last_era.epoch[-1] = @epoch[0]
        end
      end
    end

    # 配下のオブジェクトの前後関係の設定
    def _sequence
      return unless @child
      prev = nil
      if @_pool['..'].respond_to?(:child) && @_pool['..'].child
        (@_pool['..'].child.length-1).downto(0) do |i|
          v = @_pool['..'].child[i]
          next if (v.epoch[0]>=self.epoch[0])
          prev = v
          break
        end
      end
      @child.each do |v|
        if prev
          v._pool['.<-'] = prev
          prev._pool['.->'] ||= v
          while (prev.child && prev.child[-1]) do
            prev = prev.child[-1]
            prev._pool['.->'] ||= v
          end
        end
        @_pool[v.label.to_s] = v
        prev = v
      end
    end

    def _trans_array(date)
      date   = date.dup
      epoch0 = @epoch.first
      date0  = date1 = CalDate.new(date, {:frame=>epoch0.frame}) if epoch0.frame
      @epoch.each do |epoch1|
        date1 = CalDate.new(date, {:frame=>epoch1.frame}) unless epoch0.frame.equal?(epoch1.frame)
        return [epoch0, date0] if epoch1.indeterminated_position == When::TimeValue::Max
        if date1.to_i < epoch1.to_i
          return [epoch0, date0] if date0.to_i < epoch1.to_i
          return [epoch1, epoch1.frame ^ date0.to_i]
        end
        date0, epoch0 = date1, epoch1
      end
      return [@epoch.last, date1]
    end

    def _trans_date(date, clock=nil)
      unless rate_of_clock == date.time_standard.rate_of_clock
        date  = JulianDate.dynamical_time(date.dynamical_time, {:time_standard=>_typical_epoch.time_standard})
        clock = _typical_epoch.clock
      end
      frac      = clock ? clock.universal_time : 0
      sdn, time = (date.universal_time - frac).divmod(Duration::DAY)
      sdn      += JulianDate::JD19700101
      epoch     = @epoch[0]
      return When::TimeValue::Before if sdn < lower_bound
      return When::TimeValue::After  if sdn > upper_bound
      @epoch.each do |e|
        break if e.indeterminated_position == When::TimeValue::Max
        break if sdn < e.to_i
        epoch   = e
      end
      frame     = epoch.frame
      cal_date  = frame.to_cal_date(sdn)
      return epoch, CalDate.new(cal_date, {:frame=>frame}) unless clock
      return epoch, DateAndTime.new(cal_date, time+frac, {:frame=>frame, :clock=>clock})
    end

    # 代表的な元期
    #
    # @return [When::TM::TemporalPosition]
    #
    def _typical_epoch
      @_typical_epoch ||= reverse? ? @epoch[-1] : @epoch[0]
    end

    # その他のメソッド
    #
    # @note
    #   When::TM::CalendarEra で定義されていないメソッドは
    #   処理を @reference_date (type: When::TM::TemporalPosition) に委譲する
    #
    def method_missing(name, *args, &block)
      self.class.module_eval %Q{
        def #{name}(*args, &block)
          @reference_date.send("#{name}", *args, &block)
        end
      } unless When::Parts::MethodCash.escape(name)
      @reference_date.send(name, *args, &block)
    end
  end
end
