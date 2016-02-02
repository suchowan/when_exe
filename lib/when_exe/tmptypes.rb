# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2016 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::TM

  #
  # 時間座標 - 単一の時間間隔によって定義する連続な間隔尺度を基礎とする
  #
  # see {http://schemas.opengis.net/gml/3.1.1/base/temporalAppendix.xsd#TimeCoordinateType gml schema}
  #
  class Coordinate < TemporalPosition

    class << self
      # 内部時間によるオブジェクトの生成
      alias :universal_time :new

      # 外部時間によるオブジェクトの生成
      #
      # @param [Numeric] dynamical_time 外部時間による時間座標値
      #
      # @param [Hash] options 下記の通り
      # @option options [When::TimeStandard] :time_standard
      #
      # @return [When::TM::Coordinate]
      #
      def dynamical_time(dynamical_time, options={})
        universal_time(When.Resource(options[:time_standard] || 'UniversalTime', '_t:').dynamical_time_to_universal(dynamical_time), options)
      end

      # 他種の時間位置によるオブジェクトの生成
      #
      # @param [Numeric, When::TM::ClockTime, ::Time, ::Date, ::DateTime] time 他種の時間位置によるオブジェクト
      #
      # @param [Hash] options 下記の通り
      # @option options [When::TM::Clock] :clock
      # @option options [When::Parts::Timezone] :tz
      #
      # @return [When::TM::Coordinate]
      #
      def new(time, options={})
        options         = options.dup
        options[:frame] = Clock.get_clock_option(options)
        case time
        when Numeric
          options[:frame] ||= When::UTC unless time.kind_of?(Integer)
          universal_time    = (2*time - (2*JulianDate::JD19700101-1)) * Duration::DAY.to_i / 2.0
        when ClockTime
          options[:frame] ||= time.clock
          universal_time    = time.clk_time[0] + time.universal_time
        when ::Time
          options[:frame] ||= When.Clock(time.gmtoff)
          universal_time    = options[:frame].time_standard.from_time_object(time)
        when TimeValue
          options[:frame] ||= time.clock
          universal_time    = time.universal_time
        else
          if ::Object.const_defined?(:Date) && ::Date.method_defined?(:+) && time.respond_to?(:ajd)
            case time
            when ::DateTime
              options[:frame] ||= When.Clock((time.offset * 86400).to_i)
              universal_time    = (2*time.ajd - (2*JulianDate::JD19700101-1)) * Duration::DAY.to_i / 2.0
            when ::Date
              universal_time    = JulianDate._d_to_t(time.jd)
              if options[:frame] && options[:frame].rate_of_clock != 1.0
                universal_time  = options[:frame].time_standard.from_dynamical_time(
                                               When::TimeStandard.to_dynamical_time(universal_time))
              end
            end
          end
        end
        raise TypeError, "Can't create #{self} from #{time.class}" unless universal_time
        universal_time(universal_time, options)
      end
    end

    # この時間位置と関連付けられた時間参照系 (relation - Reference)
    #
    # The time reference system associated with the temporal position being described
    #
    # @return [When::TM::ReferenceSystem]
    #
    alias :clock :frame

    # 内部時間による時間座標値
    #
    # @return [Numeric]
    #
    attr_accessor :universal_time
    alias :coordinateValue :universal_time
    protected :universal_time=

    # 内部時間(ローカル)
    #
    # @return [Numeric]
    #
    #   1970-01-01T00:00:00(ローカル) からの Universal Coordinated Time の経過時間 / 128秒
    #
    def local_time
      @universal_time
    end

    # CoordinateSystem による時間座標値
    #
    # @return [Numeric]
    #
    def coordinateValue
      (universal_time - frame.origin.universal_time) / frame.interval.to_f
    end

    # 加算
    #
    # @param [Numeric, When::TM::IntervalLength] other
    #
    # @return [When::TM::TemporalPosition]
    #
    def +(other)
      other = other.to_interval_length if other.kind_of?(PeriodDuration)
      super(other)
    end

    # 減算
    #
    # @param [When::TM::TemporalPosition, Numeric, When::TM::IntervalLength] other
    #
    # @return [When::TM::TemporalPosition] if other is a Numeric or When::TM::IntervalLength
    # @return [When::TM::IntervalLength]   if other is a When::TM::TemporalPosition
    #
    def -(other)
      other = other.to_interval_length if other.kind_of?(PeriodDuration)
      super(other)
    end

    # 前の時刻
    #
    # @return [When::TM::TemporalPosition]
    #
    #   分解能に対応する Duration だけ,日時を戻す
    #
    def prev
      self - period
    end

    # 次の時刻
    #
    # @return [When::TM::TemporalPosition]
    #
    #   分解能に対応する Duration だけ,日時を進める
    #
    def succ
      self + period
    end
    alias :next :succ

    # オブジェクトの生成
    #
    # @param [Numeric] universal_time 内部時間による時間座標値
    #
    # @param [Hash] options 下記の通り
    # @option options [When::TM::CoordinateSystem] :frame
    #
    def initialize(universal_time, options={})
      super(options)
      @universal_time = universal_time
    end
  end

  #
  # ユリウス日
  #
  # see {http://schemas.opengis.net/gml/3.1.1/base/temporalAppendix.xsd#JulianDateType CALENdeRsign}
  #
  class JulianDate < Coordinate

    # Julian Day Number
    #   19700101T120000Z
    JD19700101 = 2440588

    # Modified Julian Date
    # 
    # see {https://en.wikipedia.org/wiki/Julian_day#Variants MJD}
    JDN_of_MJD = 2400000.5

    # Countdown to Equinoctial Planetconjunction 
    # 
    # see {http://www.calendersign.com/en/cs_cep-pec.php CEP}
    JDN_of_CEP = 2698162

    class << self

      JD19700100_5 = JD19700101 - 0.5

      #
      # 日時の内部表現をユリウス日に変換
      #
      # @param [Numeric] t
      #
      # @return [Numeric]
      #
      def _t_to_d(t)
        t / Duration::DAY + JD19700100_5
      end

      #
      # ユリウス日をに日時の内部表現変換
      #
      # @param [Numeric] d
      #
      # @return [Numeric]
      #
      def _d_to_t(d)
        (d - JD19700100_5) * Duration::DAY
      end

      # Generation of Temporal Objetct
      #
      # @param [String] specification ユリウス通日を表す文字列
      # @param [Hash] options 暦法や時法などの指定 (see {When::TM::TemporalPosition._instance})
      #
      # @return [When::TM::TemporalPosition, When::TM::Duration, When::Parts::GeometricComplex or Array<them>]
      #
      def parse(specification, options={})
        num, *calendars = specification.split(/\^{1,2}/)
        jdn   = num.sub!(/[.@]/, '.') ? num.to_f : num.to_i
        case num
        when /MJD/i ; jdn += JDN_of_MJD
        when /CEP/i ; jdn += JDN_of_CEP
        when /DTB/i ; jdn  = When.Resource('_t:UniversalTime').from_dynamical_date(jdn)
        end
        frame = calendars.shift || options[:frame]
        return self.new(jdn, options) unless frame
        calendars.unshift(frame).inject(jdn) {|date, calendar| When.Calendar(calendar).jul_trans(date, options)}
      end
    end

    # 加算
    #
    # @param [Numeric, When::TM::IntervalLength] other
    #
    # @return [When::TM::TemporalPosition]
    #
    def +(other)
      new_date = super
      new_date.frame = new_date.frame._daylight(new_date.universal_time) if new_date.frame && new_date.frame._need_validate
      return new_date
    end

    # 減算
    #
    # @param [When::TM::TemporalPosition, Numeric, When::TM::IntervalLength] other
    #
    # @return [When::TM::TemporalPosition]
    #
    def -(other)
      new_date = super
      new_date.frame = new_date.frame._daylight(new_date.universal_time) if new_date.kind_of?(TimeValue) && new_date.frame && new_date.frame._need_validate
      return new_date
    end

    # ユリウス日が指定の剰余となる日
    #
    # @param [When::Coordinates::Residue] other
    #
    # @return [When::TM::TemporalPosition]
    #
    def &(other)
      raise TypeError,"The right operand should be When::Coordinates::Residue" unless other.kind_of?(Residue)
      raise ArgumentError,"The right operand should have a unit 'day'" unless other.event == 'day'
      jdn      = to_i
      new_date = self.dup
      new_date.universal_time += ((other & jdn) - jdn) * Duration::DAY
      return new_date
    end

    # ユリウス日の剰余
    #
    # @param [When::Coordinates::Residue] other
    #
    # @return [Numeric]
    #
    def %(other)
      raise TypeError,"The right operand should be When::Coordinates::Residue" unless other.kind_of?(Residue)
      raise ArgumentError,"The right operand should have a unit 'day'" unless other.event == 'day'
      other % to_i
    end

    private

    # オブジェクトの生成
    #
    # @param [Numeric] universal_time 内部時間による時間座標値
    #
    # @param [Hash] options 以下の通り
    # @option options [When::TM::Clock] :frame
    # @option options [Integer] :precision
    #
    def initialize(universal_time, options={})
      @frame = options.delete(:frame)
      @frame = When.Clock(@frame) if @frame.kind_of?(String)
      @frame = @frame._daylight(universal_time) if @frame && @frame._need_validate
      precision    = options.delete(:precision)
      precision  ||= DAY unless @frame.kind_of?(Clock)
      @precision   = Index.precision(precision)
      super
    end
  end

  #
  # 順序時間参照系で参照する位置
  #
  # see {http://schemas.opengis.net/gml/3.1.1/base/temporalAppendix.xsd#TimeOrdinalPositionType gml schema}
  #
  class OrdinalPosition < TemporalPosition

    # この順序位置と関連付けられた順序年代 (relation - Reference)
    #
    # The ordinal era associated with the ordinal position being described
    #
    # @return [When::TM::OrdinalEra]
    #
    attr_reader :ordinal_position
    alias :ordinalPosition :ordinal_position

    # オブジェクトの生成
    #
    # @param [When::TM::OrdinalEra] ordinal_position この順序位置と関連付けられた順序年代
    # @param [Hash] options see {When::TM::TemporalPosition._instance}
    #
    def initialize(ordinal_position, options={})
      super(options)
      @ordinal_position = ordinal_position
    end
  end

  #
  # 時刻
  #
  # see {http://schemas.opengis.net/gml/3.1.1/base/temporalAppendix.xsd#ClockTimeType gml schema}
  #
  class ClockTime < TemporalPosition

    # 時刻要素
    #
    # @return [Array<Numeric>]
    #
    # @note ISO19108 では sequence<Integer> だが、閏時・閏秒などが表現可能なよう Numeric としている。
    #
    attr_reader :clk_time
    alias :clkTime :clk_time

    # この時間位置と関連付けられた時間参照系 (relation - Reference)
    #
    # The time reference system associated with the temporal position being described
    #
    # @return [When::TM::ReferenceSystem]
    #
    alias :clock :frame

    # 内部時間
    #
    # @param [Integer] sdn 参照事象の通し番号
    #
    # @return [Numeric]
    #
    #   T00:00:00Z からの Universal Coordinated Time の経過時間 / 128秒
    #
    #   時法によっては、異なる意味を持つことがある
    #
    def universal_time(sdn=nil)
      raise NameError, "Temporal Reference System is not defined" unless @frame
      @universal_time ||= @frame.to_universal_time(@clk_time, sdn)
    end

    # 内部時間(ローカル)
    #
    # @param [Integer] sdn 参照事象の通し番号
    #
    # @return [Numeric]
    #
    #   T00:00:00(ローカル) からの Universal Coordinated Time の経過時間 / 128秒
    #
    #   時法によっては、異なる意味を持つことがある
    #
    def local_time(sdn=nil)
      raise NameError, "Temporal Reference System is not defined" unless @frame
      @local_time ||= @frame.to_local_time(@clk_time, sdn)
    end

    # 繰り上がり
    #
    # @return [Numeric]
    #
    #   日付の境界が午前0時でない場合、clk_time の最上位桁に 0 以外が入ることがある
    #
    def carry
      return @clk_time[0]
    end

    # 要素の参照
    #
    # @param [Integer, String] index 参照する要素の指定
    #
    # @return [Numeric]
    #
    def value(index)
      @clk_time[_digit(index) {|digit| digit >= DAY}]
    end

    #protected
    # 属性のコピー
    # @private
    def _copy(options={})
      @clk_time = options[:time] if options.key?(:time)
      if options.key?(:clock)
        options.delete(:frame)
        @frame  = options[:clock]
      end
      if options.key?(:tz_prop)
        @frame  = @frame.dup
        @frame.tz_prop = options[:tz_prop]
      end
      return super
    end

    # オブジェクトの生成
    #
    # @param [String] time ISO8601形式の時刻表現
    # @param [Array<Numeric>] time (日, 時, 分, 秒)
    #     
    #
    # @param [Hash] options 以下の通り
    # @option options [When::TM::Clock] :frame
    # @option options [Integer] :precision
    #
    def initialize(time, options={})
      # 参照系の取得
      @frame = options[:frame] || Clock.local_time
      @frame = When.Clock(@frame) if (@frame.kind_of?(String))
      options.delete(:frame)

      # 時刻表現の解読 ( Time Zone の解釈 )
      if (time.kind_of?(String))
        case time
        when /\A([-+])?(\d{2,}?):?(\d{2})?:?(\d{2}(\.\d+)?)?\z/
          sign, hh, mm, ss = $~[1..4]
          time = @frame._validate([0,0,0,0],
                 [0,
                  -(sign.to_s + "0" + hh.to_s).to_i,
                  -(sign.to_s + "0" + mm.to_s).to_i,
                  Pair._en_number(-(sign.to_s + "0" + ss.to_s).to_f)])
          time[0] = Pair.new(0, time[0].to_i) if (time[0] != 0)
        when /\AZ\z/
          time = [0,0,0,0]
        else
          raise ArgumentError, "Invalid Time Format"
        end
      end
      @clk_time = time

      # 分解能
      @precision = @frame._precision(time, options.delete(:precision))

      super(options)
    end

    private

    # オブジェクトの正規化
    def _normalize(options={})
      # strftime で使用する locale
      @keys    |= @frame.keys

      # 時刻の正規化
      @clk_time = @frame._validate(@clk_time) unless options[:validate]
    end

    # 加減算共通処理
    def _plus(period)
      self.dup._copy({:time=>@frame._validate(@clk_time, @frame._arrange_length(period.time)),
                      :events=>nil, :query=>nil, :validate=>:done})
    end
  end

  #
  # 暦日
  #
  # see {gml schema}[link:http://schemas.opengis.net/gml/3.1.1/base/temporalAppendix.xsd#CalDateType]
  #
  class CalDate < TemporalPosition

    # 検索オプション
    # @private
    SearchOption = {After=>[0, -2, Before], Before=>[-2, 0, After]}

    # 日付要素
    #
    # @return [Array<Numeric>]
    #
    # @note ISO19108 では sequence<Integer> だが、閏月などが表現可能なよう Numeric としている。
    #
    attr_reader :cal_date
    alias :calDate :cal_date

    # この時間位置と関連付けられた時間参照系 (relation - Reference)
    #
    # The time reference system associated with the temporal position being described
    #
    # @return [When::TM::ReferenceSystem]
    #
    alias :calendar :frame

    # 暦年代
    #
    # @return [When::TM::CalendarEra]
    #
    attr_accessor :calendar_era
    private :calendar_era=
    alias :calendarEra :calendar_era

    # 暦年代属性
    #
    # @return [Array] ( name, epoch, reverse, go back )
    #   - name    [String]  暦年代名
    #   - epoch   [Integer] 使用する When::TM::Calendar で暦元に対応する年
    #   - reverse [Boolean] 年数が昇順(false,nil)か降順(true)か
    #   - go back [Boolean] 参照イベントより前の暦日か(true)、否か(false,nil)
    #
    attr_accessor :calendar_era_props
    private :calendar_era_props=

    # 暦年代名
    #
    # @return [String] 暦年代名
    #
    def calendar_era_name
      @calendar_era_props ? @calendar_era_props[0] : nil
    end
    alias :calendarEraName :calendar_era_name

    # 暦年代元期
    #
    # @return [Integer] 使用する When::TM::Calendar で暦元に対応する年
    #
    def calendar_era_epoch
      @calendar_era_props ?  @calendar_era_props[1] : 0
    end

    # 暦年代正逆
    #
    # @return [Boolean] 年数が昇順(false,nil)か降順(true)か
    #
    def calendar_era_reverse
      @calendar_era_props ? @calendar_era_props[2] : false
    end

    # 暦年代遡及
    #
    # @return [Boolean] 参照イベントより前の暦日か(true)、否か(false,nil)
    #
    def calendar_era_go_back
      @calendar_era_props ? @calendar_era_props[3] : false
    end

    # 時法の取得 - ダミー
    def clock
      nil
    end

    # 内部時間
    #
    # @return [Numeric]
    #
    #   当日正午の 1970-01-01T00:00:00Z からの Universal Coordinated Time の経過時間 / 128秒
    #
    def universal_time
      return super if [Now, Max, Min].include?(@indeterminated_position)
      @universal_time ||= JulianDate._d_to_t(to_i)
    end
    alias :local_time :universal_time

    # ユリウス日
    #
    # @return [Integer]
    #
    #   -4712-01-01からの経過日数に対応する通番
    #
    def to_i
      @sdn ||= _to_i
    end

    #
    # 暦法上の通日
    #
    def _to_i
      void, epoch = @calendar_era_props
      if epoch
        date     = @cal_date.dup
        date[0] += epoch
      else
        date     = @cal_date
      end
      @frame.to_julian_date(date)
    end
    private :_to_i

    # 前の日時
    #
    # @return [When::TM::TemporalPosition]
    #
    #   分解能に対応する Duration だけ,日時を戻す
    #
    def prev
      @precision==When::DAY ? _force_euqal_day(-1) : self-period
    rescue RangeError
      (When::Gregorian ^ self) - period
    end

    # 次の日時
    #
    # @return [When::TM::TemporalPosition]
    #
    #   分解能に対応する Duration だけ,日時を進める
    #
    def succ
      @precision==When::DAY ? _force_euqal_day(+1) : self+period
    rescue RangeError
      (When::Gregorian ^ self) + period
    end
    alias :next :succ

    # 剰余類化
    #
    # @param [Numeric] remainder 剰余
    # @param [Integer] divisor   法(>0)
    #
    # @return [When::Coordinates::Residue] 当日、当年を基準とする剰余類
    #
    def to_residue(remainder, divisor)
      When::Coordinates::Residue.new(remainder, divisor, {'day'  => least_significant_coordinate,
                                                          'year' => most_significant_coordinate})
    end

    # 暦年代の削除
    #
    # @return [When::TM::CalDate] 暦年代を削除した When::TM::CalDate
    #
    def without_era
      target  = dup
      return target unless calendar_era
      options = _attr
      options[:era]      = nil
      options[:era_name] = nil
      options[:date]     = cal_date.dup
      options[:date][0] += calendar_era_epoch
      target._copy(options)
    end

    # 要素の参照
    #
    # @param [Integer, String] index 参照する要素の指定
    #
    # @return [Numeric]
    #
    def value(index)
      @cal_date[(_digit(index) {|digit| digit <= DAY})-1]
    end

    #
    # 最上位の要素
    #
    # @return [Numeric] 暦年代の epoch に関わらず暦法に従った年の通し番号を返す
    #
    def most_significant_coordinate
      coordinate  = @cal_date[0]
      coordinate += calendar_era_epoch if @calendar_era_props
      @frame.index_of_MSC.times do |i|
        coordinate = +coordinate * @frame.indices[i].unit + @cal_date[i+1] - @frame.indices[i].base
      end
      coordinate
    end

    #
    # 最下位の要素
    #
    # @return [Numeric] 剰余類の演算に用いる日の通し番号を返す
    #
    def least_significant_coordinate
      return to_i + @frame.indices[-1].shift
    end

    # ユリウス日または通年が指定の剰余となる日
    #
    # @param [When::Coordinates::Residue] other
    #
    # @return [When::TM::CalDate]
    #
    def &(other)
      raise TypeError,"The right operand should be When::Coordinates::Residue" unless other.kind_of?(Residue)
      case other.event
      when 'day'
      # 指定の剰余となる日
        sdn      = other & to_i
        options  = {:date=>_date_with_era(@frame.to_cal_date(sdn)), :events=>nil, :query=>@query, :validate=>:done}
        options[:precision] = When::DAY if precision < When::DAY
        result   = self.dup._copy(options)
        result.send(:_force_euqal_day, sdn-result.to_i)

      when 'year'
      # 指定の剰余となる年
        date     = @frame.send(:_decode, _date_without_era)
        date[0]  = (other & (date[0] + @frame.diff_to_CE)) - @frame.diff_to_CE
        options  = {:date=>_date_with_era(@frame.send(:_encode, date)), :events=>nil, :query=>@query}
        options[:precision] = When::YEAR if precision < When::YEAR
        return self.dup._copy(options)

      else
        raise ArgumentError,"The right operand should have a unit 'day' or 'year'"
      end
    end

    # ユリウス日または通年の剰余
    #
    # @param [When::Coordinates::Residue] other
    #
    # @return [Numeric]
    #
    def %(other)
      raise TypeError,"The right operand should be When::Coordinates::Residue" unless other.kind_of?(Residue)
      if precision <= When::YEAR && other.units['year'] && other.event != 'year'
        other.to('year') % (most_significant_coordinate + @frame.epoch_in_CE)
      else
        case other.event
        when 'day'  ; other % least_significant_coordinate
        when 'year' ; other % (most_significant_coordinate + @frame.epoch_in_CE)
        else        ; raise ArgumentError,"The right operand should have a unit 'day' or 'year'"
        end
      end
    end

    # 下位桁の切り捨て
    #
    # @param [Integer] digit 切り捨てずに残す、最下位の桁
    #
    # @param [Integer] precision 切り捨て結果の分解能
    #
    # @return [When::TM::CalDate]
    #
    def floor(digit=DAY, precision=digit)
      options = {:date=>@cal_date[0..(digit-1)], :events=>nil, :query=>nil}
      options[:precision] = precision if precision
      self.dup._copy(options)
    end

    # 下位桁の切り上げ
    #
    # @param [Integer] digit 切り上げずに残す、最下位の桁
    #
    # @param [Integer] precision 切り上げ結果の分解能
    #
    # @return [When::TM::CalDate]
    #
    def ceil(digit=DAY, precision=digit)
      (self + PeriodDuration.new(1, digit, (-@frame.indices.length)..0)).floor(digit, precision)
    end

    # 要素数 ― 上位要素に含まれる下位要素の数
    #
    # @param [Integer] upper 上位要素のインデックス
    # @param [Integer] lower 下位要素のインデックス(DAY または MONTH)
    #
    # @return [Integer]
    #
    def length(upper, lower=DAY)
      range = [floor(upper).to_i, ceil(upper).to_i]
      range = range.map {|d| (Residue.mod(d) {|m| frame._new_month(m)})[0]} if lower == MONTH
      range[1] - range[0]
    end

    # 時刻情報のない When::TM::CalDate を返す
    #
    # @return [When::TM::CalDate]
    #
    alias :to_cal_date :dup
    alias :to_CalDate  :to_cal_date

    # 暦年代が末端の参照であるか?
    #
    # @return [Boolean]
    #
    def leaf?
      ! @calendar_era.respond_to?(:_pool) || @calendar_era.leaf?
    end

    # 属性の Hash
    # @private
    def _attr
      super.merge({:era_name=>@calendar_era_props, :era=>@calendar_era})
    end
    protected

    # 属性のコピー
    # @private
    def _copy(options={})
      @cal_date           = options[:date]     if options.key?(:date)
      @calendar_era       = options[:era]      if options.key?(:era)
      @calendar_era_props = options[:era_name] if options.key?(:era_name)
      return super
    end

    # オブジェクトの生成
    #
    # @param [Array<Numeric>] date 日付表現
    #
    # @param [Hash] options 下記の通り (see also {When::TM::TemporalPosition._instance})
    # @option options [When::TM::Calendar] :frame
    # @option options [When::TM::CalendarEra, When::BasicTypes::M17n, Array<When::BasicTypes::M17n, Integer>] :era_name
    #   (Integer は 当該年号の 0 年に相当する通年)
    # @option options [Integer] :precision
    #
    def initialize(date, options={})
      # 年号 & 日付
      @calendar_era_props = options[:era_name]
      @calendar_era       = options[:era]
      @cal_date           = date

      super(options)
    end

    private

    # オブジェクトの正規化
    def _normalize(options={})

      # 日付配列の長さ
      cal_date_index = @cal_date.compact.length

      # 日付の正規化
      if @calendar_era_props
        # Calendar Era がある場合
        trans_options = @trans || {} # TODO? 消す
        count = trans_options[:count] || 1
        query_options = (@query || {}).dup
        query_options[:label] = @calendar_era_props
        query_options[:count] = count
        era = date  = nil
        if @calendar_era
          era, date = _search_era(@calendar_era, trans_options)
        else
          eras = CalendarEra._instance(query_options)
          raise ArgumentError, "CalendarEraName doesn't exist: #{query_options[:label]}" if eras.empty?
          eras.each do |e|
            era, date = _search_era(e, trans_options)
            next unless era
            count -= 1
            break unless count > 0
          end
        end
        raise RangeError, "Out of CalendarEra Range" unless era
        @calendar_era_props = date.calendar_era_props
        @calendar_era       = era
        @cal_date = date.cal_date
        @frame    = date.frame
        @query    = (@query||{}).merge(date.query)
        @trans    = (@trans||{}).merge(date.trans)
        @keys    |= calendar_era_name.keys | @frame.keys
      else
        # Calendar Era がない場合
        @frame = When.Resource(options[:frame] || @frame || 'Gregorian', '_c:')
        @cal_date = @frame._validate(@cal_date) unless options[:validate] == :done
        @keys    |= @frame.keys
      end

      # 分解能
      precision   = options.delete(:precision) || @precision
      cal_date_index =
        case options.delete(:_format)
        when :century    ; CENTURY
        when :week, :day ; DAY
        else             ; cal_date_index - (@frame.indices.length + 1)
        end
      precision ||= cal_date_index      if cal_date_index < DAY
      precision ||= @clk_time.precision if @clk_time
      @precision  = Index.precision(precision || DAY)
    end

    # 暦年代を探す
    def _search_era(era, trans_options)
      cal_date     = @cal_date.dup
      cal_date[0]  = -cal_date[0] if era.reverse?
      cal_date[0] += era.epoch_year
      date = era.trans(cal_date, trans_options)
      loop do
        case date
        when Before, After
          i0, i1, reverse = SearchOption[date]
          new_era = (date == Before) ? era.prev : era.succ
          break unless new_era
          date = new_era.trans(cal_date, trans_options)
          if date == reverse
            cal_date = new_era.epoch[i0].frame.to_cal_date(era.epoch[i1].frame.to_julian_date(cal_date))
            date = new_era.trans(cal_date, trans_options)
            break if date == reverse
          end
          era  = new_era
        when TimeValue
         return era, date
        else
          break
        end
      end
      return nil
    end

    # 加減算共通処理
    def _plus(period)
      _frame_adjust(period, self.dup._copy({:date=>_date_with_era(@frame._validate(_date_without_era,
                                                     @frame._arrange_length(period.date))),
                               :events=>nil, :query=>nil, :validate=>:done}))
    end

    # 年号を除外した @frame の暦法に対応する日付
    def _date_without_era
      date = @cal_date.dup
      date[0] += calendar_era_epoch if @calendar_era_props
      date
    end

    # 年号に続く日付
    def _date_with_era(date)
      date[0] -= calendar_era_epoch if @calendar_era_props
      date
    end

    # 暦法が変わった場合の補正
    def _frame_adjust(period, date)
      return date if @frame.equal?(date.frame) || (period.to_day||0) == 0
      diff = period.to_day - (date.to_i - to_i)
      return date if diff == 0
      date.send(:_force_euqal_day, diff)
    end
  end

  #
  # 時刻を伴った日付
  #
  # see {http://schemas.opengis.net/gml/3.1.1/base/temporalAppendix.xsd#DateAndTimeType gml schema}
  #
  class DateAndTime < CalDate

    # 時刻要素
    #
    # @return [When::TM::ClockTime]
    #
    attr_reader :clk_time
    alias :clkTime :clk_time

    # 時法の取得
    #
    # @return [When::TM::Clock]
    #
    def clock
      @clk_time.frame
    end

    # 内部時間
    #
    # @return [Numeric]
    #
    #   1970-01-01T00:00:00Z からの Universal Coordinated Time の経過時間 / 128秒
    #
    #   暦法によっては、異なる意味を持つことがある
    #
    def universal_time
      return super if [Now, Max, Min].include?(@indeterminated_position)
      raise NameError, "Temporal Reference System is not defined" unless (@frame && clock)
      @universal_time ||= (to_i - JulianDate::JD19700101) * Duration::DAY + @clk_time.universal_time(to_i)
    end

    # 内部時間(ローカル)
    #
    # @return [Numeric]
    #
    #   1970-01-01T00:00:00(ローカル) からの Universal Coordinated Time の経過時間 / 128秒
    #
    #   暦法によっては、異なる意味を持つことがある
    #
    def local_time
      return super if [Now, Max, Min].include?(@indeterminated_position)
      raise NameError, "Temporal Reference System is not defined" unless (@frame && clock)
      @local_time ||= (to_i - JulianDate::JD19700101) * Duration::DAY + @clk_time.local_time(to_i)
    end

    # 要素の参照
    #
    # @param [Integer] index 参照する要素の指定
    #
    # @return [Numeric]
    #
    def value(index)
      digit = _digit(index)
      return (digit <= DAY) ? @cal_date[digit-1] : @clk_time.clk_time[digit]
    end

    # ユリウス日または通年が指定の剰余となる日
    #
    # @param [When::Coordinates::Residue] other
    #
    # @return [When::TM::DateAndTime]
    #
    def &(other)
      raise TypeError,"The right operand should be When::Coordinates::Residue" unless other.kind_of?(Residue)
      case other.event
      when 'day'
        # 指定の剰余となる日
        sdn     = other & to_i
        options = {:date=>_date_with_era(@frame.to_cal_date(sdn)), :time=>@clk_time.clk_time.dup,
                   :events=>nil, :query=>@query, :validate=>:done}
        options[:precision] = When::DAY if precision < When::DAY
        result  = self.dup._copy(options)
        result.send(:_force_euqal_day, sdn-result.to_i)

      when 'year'
        # 指定の剰余となる年
        date     = @frame.send(:_decode, _date_without_era)
        date[0]  = (other & (date[0] + @frame.diff_to_CE)) - @frame.diff_to_CE
        options  = {:date=>_date_with_era(@frame.send(:_encode, date)), :time=>@clk_time.clk_time.dup,
                    :events=>nil, :query=>@query}
        options[:precision] = When::YEAR if precision < When::YEAR
        return self.dup._copy(options)

      else
        raise ArgumentError,"The right operand should have a unit 'day' or 'year'"
      end
    end

    # 下位桁の切り捨て
    #
    # @param [Integer] digit 切り捨てずに残す、最下位の桁
    #
    # @param [Integer] precision 切り捨て結果の分解能
    #
    # @return [When::TM::DateAndTime]
    #
    def floor(digit=DAY, precision=digit)
      count    = digit - clock.indices.length

      if digit>=DAY
        date     = @cal_date.dup
      elsif @calendar_era_props
        date     = @cal_date.dup
        date[0] += calendar_era_epoch
        date     = @frame._validate(date[0..(digit-1)])
        date[0] -= calendar_era_epoch
      else
        date     = @frame._validate(@cal_date[0..(digit-1)])
      end

      time     = @clk_time.clk_time[0..((digit<=DAY) ? 0 : ((count>=0) ? -1 : digit))]
      time[0] += to_i
      time     = clock._validate(time)
      time[0] -= to_i

      if (count >= 0)
        factor = 10**count
        time[-1] = (time[-1] * factor).floor.to_f / factor
      end

      # オブジェクトの生成
      options = {:date=>date, :validate=>:done, :events=>nil, :query=>nil,
                 :time=>(digit<=DAY) ? time : @clk_time.dup._copy({:time=>time})}
      options[:precision] = precision if precision
      return self.dup._copy(options)
    end

    # 下位桁の切り上げ
    #
    # @param [Integer] digit 切り上げずに残す、最下位の桁
    #
    # @param [Integer] precision 切り上げ結果の分解能
    #
    # @return [When::TM::DateAndTime]
    #
    def ceil(digit=DAY, precision=digit)
      length  = clock.indices.length
      count   = digit - length
      period  = PeriodDuration.new((count<=0) ? 1 : 0.1**count, digit, (-@frame.indices.length)..length)
      result  = floor(digit, precision) + period
      result += clock.tz_difference if (result.universal_time <= self.universal_time)
      return result
    end

    # 位置情報
    #
    # @return [When::Coordinates::Spatial]
    #
    def location
      @location ||= @clk_time.frame.location
    end

    # 時刻情報のない When::TM::CalDate を返す
    #
    # @return [When::TM::CalDate]
    #
    def to_cal_date
      options = _attr
      options.delete(:clock)
      options[:precision] = [When::DAY, options[:precision]].min
      CalDate.new(@cal_date, options)
    end
    alias :to_CalDate :to_cal_date

    # 標準ライブラリの DateTime オブジェクトへの変換
    #
    alias :to_date_or_datetime :to_datetime

    #protected

    # 属性の Hash
    # @private
    def _attr
      super.merge({:clock=>clock})
    end

    # 属性のコピー
    # @private
    def _copy(options={})
      # 夏時間の調整
      case options[:time]
      when Array
        if clock._need_validate
          if @calendar_era_props
            date     = options[:date].dup
            date[0] += calendar_era_epoch
          else
            date     = options[:date]
          end
          new_clock = clock._daylight([@frame, date, options[:time]])
          options[:time] = options[:time].map {|t| t * 1}
        else
          new_clock = clock
        end
        options[:time] = @clk_time.dup._copy(options.merge({:clock=>new_clock}))
      when nil
        options[:time] = @clk_time.dup._copy(options)
      end

      return super(options)
    end

    # オブジェクトの生成
    #
    # @param [Array<Numeric>] date 日付表現
    # @param [Array<Numeric>] time 時刻表現
    # @param [Hash] options 下記の通り (see also {When::TM::TemporalPosition._instance})
    # @option options [When::TM::Calendar] :frame
    # @option options [When::TM::Clock] :clock 
    # @option options [When::TM::CalendarEra, When::BasicTypes::M17n, Array<When::BasicTypes::M17n, Integer>] :era_name
    #   (Integer は 当該年号の 0 年に相当する通年)
    # @option options [Integer] :precision
    #
    def initialize(date, time, options={})
      options[:time] = time
      super(date, options)
    end

    private

    # オブジェクトの正規化
    def _normalize(options={})

      # Clock
      unless options[:validate]
        clock   = Clock.get_clock_option(options)
        clock ||= options[:time].frame if options[:time].kind_of?(ClockTime)
        clock ||= Clock.local_time
      end
      clock = When.Clock(clock) if clock.kind_of?(String)
      clock_is_timezone = clock && !clock.kind_of?(When::TM::Clock)
      clock = clock.daylight if clock_is_timezone

      # ClockTime
      @clk_time = 
        case options[:time]
        when ClockTime ; options[:time]
        when Array     ; ClockTime.new(options[:time], {:frame=>clock, :precision=>options[:precision], :validate=>:done})
        else           ; clock.to_clk_time(options[:time], {:precision=>options[:precision]})
        end

      super

      # 日付と時刻の正規化
      unless options[:validate]
        time      = @clk_time.clk_time
        precision = @clk_time.precision
        second    = time[clock.base.length-1]
        second   -= clock.base[-1] if second
        if second && second != 0 && time_standard.has_leap?
          zero    = DateAndTime.new(@cal_date, time[0..-2],
                                   {:frame=>@frame, :clock=>clock,  :precision=>precision,
                                    :era_name=>@calendar_era_props,  :era=>options[:era],
                                    :time_standard=>time_standard, :location=>@location})
        end

        # 日付と時刻の関係の調整
        @cal_date = _date_with_era(@frame._validate(_date_without_era) {|jdn|
          time[0]    += jdn
          time[0..-1] = clock._validate(time)
          jdn         = time[0] * 1
          time[0]    -= jdn
          jdn
        })

        # 夏時間の調整
        if clock._need_validate
          if @calendar_era_props
            cal_date     = @cal_date.dup
            cal_date[0] += calendar_era_epoch
          else
            cal_date     = @cal_date
          end
          clock = clock._daylight([@frame, cal_date, time])
        end
        time = [time[0]] +  time[1..-1].map {|t| t * 1}
        @clk_time = ClockTime.new(time, {:frame=>clock, :precision=>precision, :validate=>:done}) if clock_is_timezone

        # 閏秒
        if zero
          leap = ((dynamical_time - zero.dynamical_time) * clock.second - second).to_i
          if leap != 0 && leap.abs < clock.second
            @cal_date = zero.cal_date
            @clk_time = zero.clk_time
            @clk_time.clk_time[-1] += second
            leap                   /= clock.second
            @universal_time = @local_time = When::Coordinates::LeapSeconds.new(@local_time-leap, leap, 1/clock.second)
            @dynamical_time -= leap
          end
        end
      end

      # 後処理
      @keys |= @clk_time.keys
    end

    # 加減算共通処理
    def _plus(period)
      # 日時の加算
      time  = @clk_time.clk_time.dup
      pdate = @frame._arrange_length(period.date)
      ptime = clock._arrange_length(period.time)
      date  = _date_with_era(@frame._validate(_date_without_era, pdate) {|jdn|
        time[0] += jdn
        time     = clock._validate(time, ptime)
        jdn      = time[0] * 1
        time[0] -= jdn
        jdn
      })

      # オブジェクトの生成
      _frame_adjust(period, self.dup._copy({:date=>date, :time=>time, :validate=>:done, :events=>nil, :query=>nil}))
    end
  end
end
