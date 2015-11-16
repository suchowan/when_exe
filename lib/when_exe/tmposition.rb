# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2015 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::TM
#
# (5.4) Temporal Position Package
#
#

  # 列挙データ型である When::TM::IndeterminateValue は,不確定な位置のために
  # 6つの値を規定する.このうち Min と Max は 本ライブラリでの拡張である.
  #
  # These values are interpreted as follows: 
  #- “Unknown” 時間位置を示す値が与えられていないことを示す(本ライブラリでは“Unknown”は使用しない)
  #- “Now”     常に現時点の時間位置を示す(オブジェクト生成時の時間位置でないことに注意)
  #- “Before”  実際の時間位置は未知だが、指定した値よりも前であることを示す(本ライブラリでは“Before”は無視される)
  #- “After”   実際の時間位置は未知だが、指定した値よりも後であることを示す(本ライブラリでは“After”は無視される)
  #- “Min”     無限の過去を示す
  #- “Max”     無限の未来を示す
  #
  # see {gml schema}[link:http://schemas.opengis.net/gml/3.1.1/base/temporal.xsd#TimeIndeterminateValueType]
  #
  module IndeterminateValue

    After   = :After
    Before  = :Before
    Now     = :Now
    Unknown = :Unknown
    # additional value for this library
    Min     = :Min
    # additional value for this library
    Max     = :Max

    S = {'After'=>After, 'Before'=>Before, 'Now'=>Now, 'Unknown'=>Unknown, '-Infinity'=>Min, '+Infinity'=>Max}
    I = S.invert
  end

  # 時間位置共用体
  # union of
  #   When::TM::TemporalPosition
  #   When::BasicTypes::Date
  #   When::BasicTypes::Time
  #   When::BasicTypes::DateTime
  #
  # see {http://schemas.opengis.net/gml/3.1.1/base/temporal.xsd#TimePositionType gml schema}
  #
  class Position

    include IndeterminateValue
    include When::Parts::Resource

    # @private
    HashProperty =
      [:indeterminated_position, :frame,
       [:precision, When::SYSTEM], :events, :options, :trans, :query,
       :location, [:time_standard, When::TimeStandard::UniversalTime], [:rate_of_clock, 1.0]]

    # 代表文字列
    #
    # @return [When::BasicTypes::DateTime]
    #
    attr_reader :date_time8601
    alias :dateTime8601 :date_time8601

    # 時間位置
    #
    # @return [When::TM::TemporalPosition]
    #
    attr_reader :any_other
    alias :anyOther :any_other

    # 諸々のオブジェクトから When::TM::TemporalPosition を取り出す
    #
    # @param [Object] position 変換元の時間位置
    # @param [Hash] options
    #   see {When::TM::TemporalPosition._instance}
    #
    # @return [When::TM::TemporalPosition] position の型により下記を返す
    #   - {When::BasicTypes::Date}, {When::BasicTypes::Time}, {When::BasicTypes::DateTime} - When::TM::Calendar#jul_trans による変換結果
    #   - {When::TM::TemporalPosition}    - そのまま position  ( optionは無視 )
    #   - {When::TM::Position}            - position.any_other ( optionは無視 )
    #   - {When::Parts::GeometricComplex} - position.first     ( optionは無視 )
    #
    def self.any_other(position, options={})
      case position
      when TemporalPosition              ; position
      when Position                      ; position.any_other
      when When::Parts::GeometricComplex ; position.first
      else ; When.Calendar(options[:frame] || 'Gregorian').jul_trans(position, options) || position
      end
    end

    # オブジェクトの生成
    #
    # @param [String] specification When.exe Standard Representation として解釈して生成する
    # @param [Hash] options 暦法や時法などの指定
    #   see {When::TM::TemporalPosition._instance}
    #
    # @note
    #    specification が String 以外の場合、そのオブジェクトの代表的な日時
    #    (When::TM::CalendarEra#reference_dateなど)により解釈する
    #
    def initialize(specification, options={})

      case specification
      when String
        @date_time8601 = specification
        @any_other     = TemporalPosition._instance(specification, options)
      when Position
        @date_time8601 = specification.date_time8601
        @any_other     = specification.any_other
        return
      else
        @any_other     = specification
      end

      klass   = specification.class
      message = "Irregal specification type: #{klass}"

      case specification
      when CalDate                ; @date_time8601 = When::BasicTypes::Date.new(specification.to_s)
      when ClockTime              ; @date_time8601 = When::BasicTypes::Time.new(specification.to_s)
      when TemporalPosition       ; @date_time8601 = When::BasicTypes::DateTime.new(specification.to_s)
      when CalendarEra            ; @date_time8601 = When::BasicTypes::Date.new(specification.reference_date.to_s)
      when OrdinalEra             ; @date_time8601 = When::BasicTypes::Date.new(specification.begin.to_s)
      when When::BasicTypes::Date ; raise TypeError, message unless klass == CalDate
      when When::BasicTypes::Time ; raise TypeError, message unless klass == ClockTime
      when String                 ;
      else                        ; raise TypeError, message
      end
    end

    private

    alias :_method_missing :method_missing

    # その他のメソッド
    #
    # @note
    #   When::TM::Position で定義されていないメソッドは
    #   処理を @date_time8601  (type: When::BasicTypes::DateTime) 
    #   または @any_other (type: When::TM::TemporalPosition) に委譲する
    #   (両方ともに有効なメソッドは@any_otherを優先する)
    #
    def method_missing(name, *args, &block)
      return _method_missing(name, *args, &block) if When::Parts::MethodCash::Escape.key?(name)
      self.class.module_eval %Q{
        def #{name}(*args, &block)
          union = @any_other.respond_to?("#{name}") ? @any_other : @date_time8601
          union.send("#{name}", *args, &block)
        end
      } unless When::Parts::MethodCash.escape(name)
      union = @any_other.respond_to?(name) ? @any_other : @date_time8601
      union.send(name, *args, &block)
    end
  end

  # 「時間位置」の基底クラス
  #
  # see {http://schemas.opengis.net/gml/3.1.1/base/temporalAppendix.xsd#TemporalPositionType gml schema}
  #
  class TemporalPosition < ::Object

    #
    # When::TM::JulianDate, When::TM::CalDate or DateAndTime への変換メソッドを提供
    #
    module Conversion
      #
      # 対応する When::TM::JulianDate を生成
      #
      # @param [Hash] options 以下の通り
      # @option options [When::TM::Clock] :clock
      # @option options [When::Parts::Timezone] :tz
      #
      # @return [When::TM::JulianDate]
      #
      def julian_date(options={})
        When::TM::JulianDate.new(self, options)
      end
      alias :to_julian_date :julian_date

      #
      # 対応する When::TM::CalDate or DateAndTime を生成
      #
      # @param [Hash] options 暦法や時法などの指定
      #   see {When::TM::TemporalPosition._instance}
      #
      # @return [When::TM::CalDate, When::TM::DateAndTime]
      #
      def tm_pos(options={})
        When.Calendar(options[:frame] || 'Gregorian').jul_trans(self, options)
      end
      alias :to_tm_pos :tm_pos
    end

    include When
    include Comparable
    include IndeterminateValue
    include Coordinates
    include Parts::Resource
    include Conversion

    # @private
    HashProperty = Position::HashProperty

    # @private
    DateTimeInstanceMethods = ::Object.const_defined?(:Date) && ::Date.method_defined?(:+) ? ::DateTime.instance_methods : []

    # この時間位置の意味づけ
    #
    # @return [When::TM::IndeterminateValue]
    #
    attr_reader :indeterminated_position
    alias :indeterminatedPosition :indeterminated_position

    # この時間位置と関連付けられた時間参照系 (relation - Reference)
    #
    # The time reference system associated with the temporal position being described
    #
    # @return [When::TM::ReferenceSystem]
    #
    attr_accessor :frame

    # この時間位置と関連付けられたイベント - additional attribute
    #
    # @return [Array<When::Parts::Enumerator>]
    #
    attr_accessor :events
    #protected :events=

    # この時間位置の分解能 - additional attribute
    #
    # @return [Numeric]
    #
    # @note precision より resolution の方が分解能の意味にふさわしいが ISO19108 で別の意味に用いられているため resolution とした。
    #
    attr_accessor :precision

    # その他の属性 - additional attribute
    #
    # @return [Hash] { String=>Object }
    #
    attr_reader :options

    # その他の属性 - additional attribute
    #
    # @return [Hash] { String=>Object }
    #
    attr_accessor :trans

    # その他の属性 - additional attribute
    #
    # @return [Hash] { String=>When::BasicTypes::M17n }
    #
    attr_accessor :query

    # その他の属性 - additional attribute
    #
    # @return [When::Coordinates::Spatial]
    #
    attr_accessor :location

    class << self

      include When
      include Coordinates

      # Temporal Objetct の生成
      #
      # @param [String] specification When.exe Standard Representation
      # @param [Hash] options 下記の通り
      # @option options [When::TM::ReferenceSystem] :frame 暦法の指定
      # @option options [When::Parts::Timezone::Base, String] :clock 時法の指定
      # @option options [String] :tz 時法の指定(時間帯を指定する場合 :clock の替わりに用いることができる)
      # @option options [Array<Numeric>] :abbr ISO8601上位省略形式のためのデフォルト日付(省略時 指定なし)
      # @option options [Integer] :extra_year_digits ISO8601拡大表記のための年の構成要素拡大桁数(省略時 1桁)
      # @option options [Integer] :ordinal_date_digits ISO8601拡大表記の年内通日の桁数(省略時 3桁)
      # @option options [String] :wkst ISO8601週日形式のための暦週開始曜日(省略時 'MO')
      # @option options [Integer] :precision 生成するオブジェクトの分解能
      # @option options [When::TimeStandard::TimeStandard] :time_standard 時刻系の指定(省略時 When::TimeStandard::UnversalTime)
      # @option options [When::Ephemeris::Spatial] :location 観測地の指定(省略時 指定なし)
      # @option options [String] :era_name 暦年代
      # @option options [Hash] :trans 暦年代の上下限
      #   - :count => 条件に合致する暦年代のうち何番目を採用するか
      #   - :lower => 暦年代適用の下限
      #      true            - epoch_of_use の始め(省略時)
      #      :reference_date - 参照事象の日付
      #   - :upper => 暦年代適用の上限
      #      true            - epoch_of_use の終わり(省略時)
      #      :reference_date - 参照事象の日付
      # @option options [Hash] :query 暦年代の絞込み条件
      #   - :area   => area による暦年代絞込み
      #   - :period => period による暦年代絞込み
      #   - :name   => name による暦年代絞込み(epoch の attribute使用可)
      #
      # @note options の中身は本メソッドによって更新されることがある。
      #
      # @note :tz は 'Asia/Tokyo'など時間帯を表す文字列をキーにして、登録済みのWhen::V::Timezone, When::Parts::Timezoneを検索して使用する。
      #       :clock はWhen::Parts::Timezone::Baseオブジェクトをそのまま使用するか '+09:00'などの文字列をWhen::TM::Clock化して使用する。
      #       :tz の方が :clock よりも優先される。
      #
      # @return [When::TM::TemporalPosition]    ISO8601 time point
      # @return [When::TM::Duration]            ISO8601 duration 
      # @return [When::Parts::GeometricComplex] ISO8601 repeating interval
      #
      def _instance(specification, options={})

        # prefix - RFC 5545 Options
        iso8601form = When::Parts::Resource::ContentLine.extract_rfc5545_Property(specification, options).
                      gsub(When::Parts::Resource::IRIDecode) {|c| When::Parts::Resource::IRIDecodeTable[c]}

        # suffix - Frame specification
        if iso8601form =~ /\A(.*[^\d]|.+=[^:]+)\((([-+*&%@!>=<?\d.A-Z:]|\{.+?\})+)\)\z/
          frame, iso8601form = $~[1..2]
          frame.sub!(/_+\z/, '')
        else
          iso8601form, frame, *rest = iso8601form.split(/(?:\^|%5E){1,2}/i)
          return rest.inject(_instance(iso8601form + '^' + frame, options)) {|p,c| When.Resource(c, '_c:').jul_trans(p)} unless rest.empty?
        end

        # add frame to options
        options = options.merge({:frame=>When.Resource(frame, '_c:')}) if frame

        # indeterminateValue
        if (iso8601form.sub!(/\/After\z|\ABefore\/|\ANow\z|\AUnknown\z|\A[-+]Infinity\z/i, ''))
          options[:indeterminated_position] = When::TimeValue::S[$&.sub(/\//,'')]
          case options[:indeterminated_position]
          when When::TimeValue::Now,
               When::TimeValue::Unknown,
               When::TimeValue::Max,
               When::TimeValue::Min
            return self.new(self._options(options))
          end
        end

        # each specification
        splitted = iso8601form.split(/\//)
        if (splitted[0] =~ /\AR(\d+)?\z/)
          repeat = $1 ? $1.to_i : true
          splitted.shift
        end
        case splitted.length
        when 1
        when 2
          if (splitted[0] !~ /\A[-+]?P/ && splitted[1] =~ /\A\d/ && splitted[1].length < splitted[0].length)
            splitted[1] = splitted[0][0..(splitted[0].length-splitted[1].length-1)] + splitted[1]
          end
        else
          raise ArgumentError, "Irregal ISO8601 Format: #{iso8601form}"
        end
        options = self._options(options)
        element = splitted.map { |v| _date_time_or_duration(v, options.dup) }

        # total result
        case repeat
        when nil
          case element[1]
          when nil
            return element[0]
          when Duration
            case element[0]
            when Duration ; raise TypeError, "Duplicate Duration: #{element[0]} and #{element[1]}"
            when self     ; return When::Parts::GeometricComplex.new(*element)
            else          ; return When::Parts::GeometricComplex.new(element[0].first, element[1])
            end
          when self
            case element[0]
            when Duration ; return When::Parts::GeometricComplex.new([[element[1]-element[0],false], [element[1],true ]])
            when self     ; return When::Parts::GeometricComplex.new(element[0]..element[1])
            else          ; return When::Parts::GeometricComplex.new(element[0].first..element[1])
            end
          else
            case element[0]
            when Duration ; return When::Parts::GeometricComplex.new([[element[1].first-element[0],false],
                                                                      [element[1].last-element[0]-1,true ]])
            when self     ; return When::Parts::GeometricComplex.new(element[0]...element[1].last)
            else          ; return When::Parts::GeometricComplex.new(element[0].first...element[1].last)
            end
          end
        when 0            ; return []
        when Integer      ; return [element[0]] * repeat unless element[1]
        end

        case element[1]
        when Duration
          case element[0]
          when Duration   ; raise TypeError, "Duplicate Duration: #{element[0]} and #{element[1]}"
          else            ; duration = element[1]
          end
        when self
          case element[0]
          when Duration   ; duration = -element[0]
          when self       ; duration =  element[1] - element[0]
          else            ; duration =  element[1] - element[0].first
          end
        else
          case element[0]
          when Duration   ; duration = -element[0]
          when self       ; duration =  element[1].first - element[0]
          else            ; duration =  element[1].first - element[0].first
          end
        end
        base = element[0].kind_of?(Duration) ? element[1] : element[0]

        if repeat.kind_of?(Integer)
          result = case base
                   when self  ; (1..repeat-1).inject([base]) {|a,i| a << (a[-1] + duration) }
                   else       ; (1..repeat-1).inject([base]) {|a,i| a << When::Parts::GeometricComplex.new(
                                                                          a[-1].first+duration...a[-1].last+duration)}
                   end
          result.reverse! if duration.sign < 0
          return result

        else
          duration = -duration if duration.sign < 0
          return case base
                 when self    ; When::V::Event.new({'rrule'=>{'FREQ'=>duration}, 'dtstart'=>base})
                 else         ; When::V::Event.new({'rrule'=>{'FREQ'=>duration}, 'dtstart'=>base.first,
                                                                                 'dtend'  =>base.last})
                 end
        end
      end

      # When::TM::TemporalPosition の生成
      #
      # @see When.TemporalPosition
      #
      def _temporal_position(*args)
        # 引数の解釈
        options  = args[-1].kind_of?(Hash) ? args.pop.dup : {}
        validate = options.delete(:invalid)
        options  = TemporalPosition._options(options)
        options[:frame]  ||= 'Gregorian'
        options[:frame]    = When.Resource(options[:frame], '_c:') if options[:frame].kind_of?(String)
        case args[0]
        when String
          options[:era_name]    = When::EncodingConversion.to_internal_encoding(args.shift)
        when Array
          options[:era_name]    = args.shift
          options[:era_name][0] = When::EncodingConversion.to_internal_encoding(options[:era_name][0])
        end

        # 時間位置の生成
        res   = []
        abbrs = Array(options[:abbr])
        date  = Array.new(options[:frame].indices.length-1) {
          element = args.shift
          abbr    = abbrs.shift
          res    << element.to('year') if element.kind_of?(When::Coordinates::Residue)
          element.kind_of?(Numeric) ? element : (abbr || 1)
        }
        date += Array.new(2) {
          element = args.shift
          abbr    = abbrs.shift
          res    << element.to('day') if element.kind_of?(When::Coordinates::Residue)
          case element
          when Numeric ; element
          when nil     ; abbr
          else         ; nil
          end
        }
        if args.length > 0
          options[:clock] ||= Clock.local_time
          options[:clock]   = When.Clock(options[:clock])
          time = Array.new(options[:clock].indices.length) {args.shift}
          position = DateAndTime.new(date, time.unshift(0), options)
        else
          position = CalDate.new(date, options)
        end
        res.each do |residue|
          position  = position.succ if residue.carry < 0
          position &= residue
        end

        return position unless [:raise, :check].include?(validate)

        # 時間位置の存在確認
        date[0] = -date[0] if position.calendar_era_props && position.calendar_era_reverse # 紀元前
        date.each_index do |i|
          break unless date[i]
          next if When::Coordinates::Pair._force_pair(date[i]) == When::Coordinates::Pair._force_pair(position.cal_date[i])
          return nil if validate == :check
          raise ArgumentError, "Specified date not found: #{date}"
        end
        return position unless time
        time.each_index do |i|
          break unless time[i]
          next if When::Coordinates::Pair._force_pair(time[i]) == When::Coordinates::Pair._force_pair(position.clk_time.clk_time[i])
          return nil if validate == :check
          raise ArgumentError, "Specified time not found: #{time}"
        end
        return position
      end

      # option の正規化
      # @private
      def _options(options)
        query = options.dup
        main  = {}
        clock = Clock.get_clock_option(query)
        main[:clock] = clock if clock
        [:indeterminated_position, :frame, :events, :precision,
         :era_name, :era, :abbr, :extra_year_digits, :ordinal_date_digits, :wkst, :time_standard, :location].each do |key|
          main[key] = query.delete(key) if query.key?(key)
        end
        long = query.delete(:long)
        lat  = query.delete(:lat)
        alt  = query.delete(:alt)
        main[:location] ||= "_l:long=#{long||0}&lat=#{lat||0}&alt=#{alt||0}" if long && lat
        trans = query.delete(:trans) || {}
        [:lower, :upper, :count].each do |key|
          trans[key] = query.delete(key) if (query.key?(key))
        end
        query = query.merge(query.delete(:query)) if (query.key?(:query))
        main[:query] = query if (query.size > 0)
        main[:trans] = trans if (trans.size > 0)
        return main
      end

      # 比較
      # @private
      def _verify(source, target)
        return source.universal_time <=> target.universal_time if source.time_standard.equal?(target.time_standard)
        return source.dynamical_time <=> target.dynamical_time
      end

      private

      # date_time_or_duration
      def _date_time_or_duration(specification, options)
        # IntervalLength
        args = IntervalLength._to_array(specification)
        return IntervalLength.new(*args) if args

        # PeriodDuration
        sign, *args = PeriodDuration._to_array(specification)
        if sign
          args << options
          duration = PeriodDuration.new(*args)
          return (sign >= 0) ? duration : -duration
        end

        # TemporalPosition
        specification =~ /(.+?)(?:\[([-+]?\d+)\])?\z/
        options[:sdn] = $2.to_i if $2
        f, d, t, z, e, r = When::BasicTypes::DateTime._to_array($1, options)
        options.delete(:abbr)
        z2  = When.Clock(options[:clock]) if z && options[:clock]
        z ||= options[:clock]
        z   = When.Clock(z) if z =~ /\A[A-Z]+\z/

        unless d
          # ClockTime
          raise ArgumentError, "Timezone conflict: #{z} - #{options[:clock]}" if z && options[:frame]
          options[:frame] ||= z
          options.delete(:clock)
          return ClockTime.new(t, options)
        end

        options[:era_name] = e if e
        options[:_format ] = f if f
        d, w = d[0..0], d[1..-1] if f == :week || f == :day
        position = z ? DateAndTime.new(d, t||[0], options.update({:clock => z})) :
                   t ? DateAndTime.new(d, t,      options)                       :
                       CalDate.new(d, options)
        case f
        when :day
          position += PeriodDuration.new(w[0]-1, DAY)
        when :week
          position = ((position  + PeriodDuration.new(4, DAY)) & (Residue.day_of_week(options[:wkst]) << 1)) +
                     PeriodDuration.new((w[0]-1)*7 + (w[1]||1)-1, DAY)
          position = When::Parts::GeometricComplex.new(position...(position+P1W)) unless w[1]
        end
        if r
          r.keys.sort.each do |count|
            residue = When.Residue(r[count])
            if count == 0
              residue = residue.to('year')
            else
              position = position.succ if residue.carry < 0
            end
            position &= residue
          end
        end
        z2 ? z2 ^ position : position
      end
    end

    # 時刻系
    #
    # @return [When::TimeStandard]
    #
    def time_standard
      return @time_standard if @time_standard.kind_of?(When::TimeStandard)
      @time_standard ||= clock.time_standard if respond_to?(:clock) && clock
      @time_standard ||= frame.time_standard if frame
      @time_standard ||= 'UniversalTime'
      @time_standard   = When.Resource(@time_standard, '_t:')
    end

    # 時間の歩度
    #
    # @return [Numeric]
    #
    def rate_of_clock
      time_standard.rate_of_clock
    end

    # 内部時間
    #
    # @return [Numeric]
    #
    #   1970-01-01T00:00:00Z からの Universal Time, Coordinated の経過時間 / 128秒
    #
    #   暦法によっては、異なる意味を持つことがある
    #
    def universal_time
      case @indeterminated_position
      when Now ; time_standard.from_time_object(Time.now)
      when Max ; +Float::MAX/4
      when Min ; -Float::MAX/4
      else     ; raise NameError, "Temporal Reference System is not defined"
      end
    end
    alias :local_time :universal_time

    # 外部時間
    #
    # @return [Numeric]
    #
    #   1970-01-01T00:00:00TT からの terrestrial time の経過時間 / 128秒
    #
    def dynamical_time
      return @dynamical_time if @dynamical_time && @indeterminated_position != Now
      @dynamical_time = 
        case @indeterminated_position
        when Max ; +Float::MAX/4
        when Min ; -Float::MAX/4
        else     ; time_standard.to_dynamical_time(local_time)
        end
    end

    # ユリウス日時(実数)
    #
    # @return [Float]
    #
    #   universal time での経過日数を, ユリウス日と1970-01-01T00:00:00Zで時計あわせしたもの
    #
    def to_f
      JulianDate._t_to_d(universal_time)
    end

    # ユリウス日(整数)
    #
    # @return [Integer]
    #
    #   -4712-01-01T12:00:00Z からの経過日数に対応する通番(当該時間帯での午前0時に1進める)
    #
    def to_i
      sd  = universal_time
      sd -= @frame.universal_time if @frame.kind_of?(Clock)
      div, mod = sd.divmod(Duration::DAY)
      div + JulianDate::JD19700101
    end

    # 剰余類化
    #
    # @param [Numeric] remainder 剰余
    # @param [Integer] divisor   法(>0)
    #
    # @return [When::Coordinates::Residue]
    #
    #   当日を基準とする剰余類
    #
    def to_residue(remainder, divisor)
      When::Coordinates::Residue.new(remainder, divisor, {'day'=>to_i})
    end

    # ユリウス日時(実数)
    #
    # @return [Float]
    #
    #   dynamical time での経過日数を, ユリウス日と1970-01-01T00:00:00TTで時計あわせしたもの
    #
    def +@
      JulianDate._t_to_d(dynamical_time)
    end

    # When::TM::ClockTime オブジェクトへの変換
    #
    # @return [When::TM::ClokTime]
    #
    def to_clock_time
      raise TypeError, "Clock not assigned" unless clock
      clk_time = clock.to_clk_time(universal_time - (to_i - JulianDate::JD19700101)*Duration::DAY)
      clk_time.clk_time[0] += to_i
      return clk_time
    end

    # 標準ライブラリの DateTime オブジェクトへの変換
    #
    # @param [Integer] start ::DateTime オブジェクトのグレゴリオ改暦日(ユリウス通日)
    # @param [Hash] option  時間の歩度が1.0でない場合のための option
    #   see {When::TM::TemporalPosition._instance}
    #
    # @return [::DateTime]
    #
    def to_datetime(start=_default_start, option={:frame=>When::UTC})
      return JulianDate.dynamical_time(dynamical_time, option).to_datetime unless time_standard.rate_of_clock == 1.0
      raise TypeError, "Clock not assigned" unless clock
      Rational
      offset   = Rational(-(clock.universal_time/Duration::SECOND).to_i, (Duration::DAY/Duration::SECOND).to_i)
      clk_time = clock.to_clk_time(universal_time - (to_i - JulianDate::JD19700101)*Duration::DAY).clk_time
      ::DateTime.jd(to_i, clk_time[1], clk_time[2], clk_time[3].to_i, offset, start)
    end

    # 標準ライブラリの Date オブジェクトへの変換
    #
    # @param [Integer] start ::DateTime オブジェクトのグレゴリオ改暦日(ユリウス通日)
    # @param [Hash] option  時間の歩度が1.0でない場合のための option
    #   see {When::TM::TemporalPosition._instance}
    #
    # @return [::Date]
    #
    def to_date(start=_default_start, option={})
      return JulianDate.dynamical_time(dynamical_time, option).to_date unless time_standard.rate_of_clock == 1.0
      ::Date.jd(to_i, start)
    end
    alias :to_date_or_datetime :to_date

    # 組み込みライブラリの Time オブジェクトへの変換
    #
    # @return [::Time]
    #
    def to_time
      time_standard.to_time_object(universal_time)
    end

    # 要素の参照
    #
    # @param [Integer, String] index 参照する要素の指定
    #
    # @return [Numeric]
    #
    def [](index)
      return value(index) if index.kind_of?(String) || !index.respond_to?(:inject)
      index.inject([]) {|list, i| list << value(i) }
    end

    # 加算
    #
    # @param [Numeric, When::TM::Duration] other
    #
    # @return [When::TM::TemporalPosition]
    #
    def +(other)
      case other
      when Integer        ; self + PeriodDuration.new(other, When::DAY)
      when Numeric        ; self + IntervalLength.new(other, 'day')
      when PeriodDuration ; _plus(other)
      when Duration       ; @frame.kind_of?(Calendar) ? @frame.jul_trans(JulianDate.dynamical_time(dynamical_time + other.duration), self._attr) :
                                                                         JulianDate.dynamical_time(dynamical_time + other.duration,  self._attr)
      else                ; raise TypeError, "The right operand should be Numeric or Duration"
      end
    rescue RangeError
      (@frame ^ self) + other
    end

    # 減算
    #
    # @param [Numeric, When::TM::Duration, When::TM::TemporalPosition] other
    #
    # @return [When::TM::TemporalPosition] if other is a Numeric or When::TM::Duration
    # @return [When::TM::Duration]         if other is a When::TM::TemporalPosition
    #
    def -(other)
      case other
      when TimeValue      ; self.time_standard.rate_of_clock == other.time_standard.rate_of_clock && [@precision, other.precision].min <= When::DAY ?
                              PeriodDuration.new(self.to_i - other.to_i, When::DAY) :
                              IntervalLength.new((self.dynamical_time - other.dynamical_time) / Duration::SECOND, 'second')
      when Integer        ; self - PeriodDuration.new(other, When::DAY)
      when Numeric        ; self - IntervalLength.new(other, 'day')
      when PeriodDuration ; _plus(-other)
      when Duration       ; @frame.kind_of?(Calendar) ? @frame.jul_trans(JulianDate.dynamical_time(dynamical_time - other.duration), self._attr) :
                                                                         JulianDate.dynamical_time(dynamical_time - other.duration,  self._attr)
      else                ; raise TypeError, "The right operand should be Numeric, Duration or TemporalPosition"
      end
    rescue RangeError
      (@frame ^ self) - other
    end

    # 分解能に対応する Duration
    #
    # @return [When::TM::PeriodDuration]
    #
    def period
      return @period if @period
      period_name = When::Coordinates::PERIOD_NAME[@precision]
      raise ArgumentError, "Presicion not defined" unless period_name
      @period = When.Duration(period_name)
    end

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

    #
    # 前後の日時を取得可能か?
    #
    # @return [Boolean]
    #   [ true  - 可能 ]
    #   [ false - 不可 ]
    #
    def has_next?
      When::Coordinates::PERIOD_NAME[@precision] != nil
    end

    # 下位桁の切り捨て
    #
    # @param [Integer] digit これより下の桁を切り捨てる(省略すると When::DAY)
    #
    # @param [Integer] precision 切り捨て結果の分解能
    #
    # @return [When::TM::TemporalPosition] (本 Class では、実際には切り捨てない)
    #
    def floor(digit=DAY, precision=digit)
      self
    end

    # 分解能が時刻を持つか
    #
    # @return [Boolean]
    #
    def has_time?
      (@precision > 0)
    end

    # 指定の日時を含むか?
    #
    # @param [When::TM::TemporalPosition] date チェックされる日時
    #
    # @return [Boolean]
    #   [ true  - 含む     ]
    #   [ false - 含まない ]
    #
    def include?(date)
      return false if self.precision > date.precision
      return self == date
    end

    # オブジェクトの同値
    #
    # @param [比較先] other
    #
    # @return [Boolean]
    #   [ true  - 同値   ]
    #   [ false - 非同値 ]
    #
    def ==(other)
      (self <=> other) == 0
    rescue
      false
    end

    # 大小比較
    #
    # @param [When::TM::TemporalPosition] other チェックされる日時
    # @param [Numeric] other チェックされる日時の universal time(self と同じtime_standardとみなす)
    #
    # @return [Integer] (-1, 0, 1)
    #
    #   分解能の低い方にあわせて比較を行う
    #
    #     Ex. when?('2011-03') <=> when?('2011-03-10') -> 0
    #
    def <=>(other)
      other = other.first if other.kind_of?(Range)
      return universal_time <=> other if other.kind_of?(Numeric)

      [self.indeterminated_position, other.indeterminated_position].each do |position|
        prec = SYSTEM if [TimeValue::Min, TimeValue::Max].include?(position)
      end
      prec   = [self.precision, other.precision].min unless prec

      case prec
      when DAY    ; return self.to_i <=> other.to_i
      when SYSTEM ; return TemporalPosition._verify(self, other)
      end

      if prec < DAY && respond_to?(:most_significant_coordinate) &&
                 other.respond_to?(:most_significant_coordinate) && @frame.equal?(other.frame)
        self_year  = most_significant_coordinate
        other_year = other.most_significant_coordinate
        if @cal_date.length + prec == 1
          self_year  *= 1
          other_year *= 1
        end
        result = self_year <=> other_year
        return result unless result == 0 && @cal_date.length + prec > 1
        (@cal_date.length + prec - 2).times do |i|
          result = @cal_date[i+1] <=> other.cal_date[i+1]
          return result unless result == 0
        end
        @cal_date[prec - 1] <=> other.cal_date[prec - 1]
      else
        source = (prec >= self.precision ) ? self  : self.floor(prec)
        target = (prec >= other.precision) ? other : other.floor(prec)
        return source.to_i <=> target.to_i if prec <= DAY
        TemporalPosition._verify(source, target)
      end
    end

    # 条件を満たすオブジェクトの抽出
    #
    # @param [Module, Array<Moduel>, When::Coordinates::Residue, When::TM::Duration, When::TM::Calendar, When::TM::CalendarEra] other
    # @param [Boolean] leaf extract only leaf Objects.
    # @param [Block] block If block is given, the specified block is yield.
    #
    # @return [Array of (element^self) for all When::Parts::Resource registered elements] (If other is Module)
    # @return [Array of (self^element) for elemnt of other  which belong to the specified module or class] (If other is [Array])
    # @return [Enumerator which generates temporal position sequence begins from self with the specified duration] (If other is [When::TM::Duration])
    # @return [Array of temporal position using the specified calendar as a frame] (If other is [When::TM::Calendar])
    # @return [Array of temporal position using the specified calendar era as a calendarEraName] (If other is [When::TM::CalendarEra])
    #
    def scan(other, leaf=false, &block)
      list = []
      case other
      when Numeric, TemporalPosition, Position
        raise TypeError, "Operand should not be Numeric or (Temporal)Position"

      when Module
        objects = []
        ObjectSpace.each_object(other) do |object|
          objects << object if object.registered?
        end
        objects.each do |object|
          element = (object ^ self)
          if element && !(leaf && element.respond_to?(:leaf?) && !element.leaf?)
            list << element
            yield(element) if block_given?
          end
        end
        return list

      when Array
        return other.map {|v| scan(v, leaf, &block)}

      else
        if other.respond_to?(:_enumerator)
          enumerator = other._enumerator(self)
          return enumerator unless block_given?
          return enumerator.each(&block)
        end

        element = (other ^ self)
        if element && !(leaf && element.respond_to?(:leaf?) && !element.leaf?)
          list << element
          yield(element) if block_given?
        end
        if (other.respond_to?(:child) && other.child)
          other.child.each do |object|
            list += scan(object, leaf, &block)
          end
        end
        return list
      end
    end

    # 条件を満たすオブジェクトの抽出
    #
    # @param (see #scan)
    # @return (see #scan)
    #
    def ^(other, leaf=true, &block)
      scan(other, leaf, &block)
    end

    # 属性を変更したコピーを作る
    #
    # @param [Hash] options { 属性=>属性値 }
    #
    # @return [When::TM::TemporalPosition]
    #
    def copy(options={})
      position = self.dup
      position._copy(options)
      position
    end

    # 属性の Hash
    # @private
    def _attr
      attributes = {}
      [:frame, :events, :precision, :options, :trans, :query].each do |key|
        attributes[key] = instance_variable_get("@#{key}")
      end
      attributes[:location]      = location
      attributes[:time_standard] = time_standard
      return attributes.delete_if {|k,v| !v}
    end

    protected

    # 属性のコピー
    # @private
    def _copy(options={})
      @frame         = options[:frame]         if options.key?(:frame)
      @events        = options[:events]        if options.key?(:events)
      @precision     = options[:precision]     if options.key?(:precision)
      @query         = options[:query]         if options.key?(:query)
      @location      = options[:location]      if options.key?(:location)
      @time_standard = options[:time_standard] if options.key?(:time_standard)
      @sdn = @universal_time = @local_time = @dynamical_time = @period = nil
      _normalize(options)
      return self
    end

    private

    # オブジェクトの生成
    #
    # @param [Hash] options see {When::TM::TemporalPosition._instance}
    #
    def initialize(options={})
      options.reject! {|key,value| !value}
      options.each_pair do |key,value|
        self.instance_variable_set("@#{key}", value)
      end
      @keys          = []
      @location      = When.Resource(@location, '_l:') if @location.kind_of?(String)
      # @sdn = @universal_time = @dynamical_time = nil
      _normalize(options)
    end

    # オブジェクトの正規化
    def _normalize(options={})
      @precision ||= SYSTEM
      @period      = nil
      @keys       |= @frame.keys if @frame
    end

    # 指定桁のチェック
    def _digit(index)
      digit = index.kind_of?(String) ? PRECISION[index.upcase] : index
      raise RangeError, " wrong digit: #{index}" unless digit.kind_of?(Integer) && (!block_given? || yield(digit))
      digit
    end

    # 指定の日を探す
    def _force_euqal_day(diff)
      return self if diff == 0
      date = self + When::P1D * diff
      return date if date.to_i - to_i == diff
      if @calendar_era
        options = _attr
        options.delete(:era_name)
        era = @calendar_era
        jdn = (clock ? to_f : to_i)+diff
        while era
          date = era.^(jdn, options)
          return date if date
          era = diff > 0 ? era.succ : era.prev
        end
        raise RangeError, "can't find target date: #{self} -> #{jdn}"
      else
        done = {}
        jdn  = to_i + diff
        loop do
          case
          when date.to_i == jdn
            return date
          when date.to_i > jdn
            next_date = date - When::P1D
            date = (date.to_i == next_date.to_i) ? date - When::P2D : next_date
          when date.to_i < jdn
            next_date = date + When::P1D
            date = (date.to_i == next_date.to_i) ? date + When::P2D : next_date
          end
          raise RangeError, "can't find target date: #{self} -> #{jdn}" if done.key?(date.to_i)
          done[date.to_i] = true
        end
      end
    end

    #
    # 対応する ::Date の start 属性
    def _default_start
      frame ? frame._default_start : ::Date::GREGORIAN
    end

    alias :_method_missing :method_missing

    # その他のメソッド
    #
    # @note
    #   When::TM::TemporalPosition で定義されていないメソッドは
    #   処理を @frame(class: When::TM::Calendar or When::TM::Clock)
    #   または to_date_or_datetime(class: ::Date or ::DateTime) に委譲する
    #
    def method_missing(name, *args, &block)
      
      return _method_missing(name, *args, &block) if When::Parts::MethodCash::Escape.key?(name)
      if DateTimeInstanceMethods.include?(name) && ! @frame.respond_to?(name)
        self.class.module_eval %Q{
          def #{name}(*args, &block)
            self.to_date_or_datetime.send("#{name}", *args, &block)
          end
        } unless When::Parts::MethodCash.escape(name)
        self.to_date_or_datetime.send(name, *args, &block)
      else
        self.class.module_eval %Q{
          def #{name}(*args, &block)
            @frame.send("#{name}", self, *args, &block)
          end
        } unless When::Parts::MethodCash.escape(name)
        @frame.send(name, self, *args, &block)
      end
    end
  end

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
        universal_time(When.Resource(options[:time_standard] || 'UniversalTime', '_t:').from_dynamical_time(dynamical_time), options)
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
        when/MJD/i ; jdn += JDN_of_MJD
        when/CEP/i ; jdn += JDN_of_CEP
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
