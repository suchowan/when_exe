# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2016 Takashi SUGA

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

        # delayed_options
        delayed_options = {}

        # Frame specifications - 暦法指定の取り出し
        if iso8601form =~ /\A(.*[^\d]|.+=[^:]+)\((([-+*&%@!>=<?\d.A-Z:]|\{.+?\})+)\)\z/
          frame, iso8601form = $~[1..2]
          frame.sub!(/_+\z/, '')
        else
          iso8601form, frame, *rest = iso8601form.split(/(?:\^|%5E){1,2}/i)
          delayed_options[:frame] = rest.map{|calendar| When.Resource(calendar, '_c:')} unless rest.empty?
        end

        # add frame to options
        options = options.merge({:frame=>When.Resource(frame, '_c:')}) if frame

        return _instance_element(iso8601form, options, delayed_options) unless iso8601form =~ /\A(.+?)(\.{2,3})(.+)\z/
        first, separater, last = $1, $2, $3
        When::Events::Range.new(_instance_element(first, options.dup, delayed_options.dup),
                                _instance_element(last,  options.dup, delayed_options.dup), separater == '...')
      end

      def _instance_element(iso8601form, options, delayed_options)

        # indeterminateValue
        if (iso8601form.sub!(/\/After\z|\ABefore\/|\ANow\z|\AUnknown\z|\A[-+]Infinity\z/i, ''))
          options[:indeterminated_position] = When::TimeValue::S[$&.sub('/','')]
          case options[:indeterminated_position]
          when When::TimeValue::Now,
               When::TimeValue::Unknown,
               When::TimeValue::Max,
               When::TimeValue::Min
            return self.new(self._options(options))
          end
        end

        # each specification - '/' で区切られた個々の要素の取り出し
        splitted = iso8601form.gsub(/\{.+?\}/) {|m| m.gsub('/', When::Locale::NUL)}.split('/').map {|m| m.gsub(When::Locale::NUL, '/')}
        if (splitted[0] =~ /\AR(\d+)?(P.+)?\z/)
          repeat = $1 ? $1.to_i : true
          delayed_options[:duration] = When.Duration($2) if $2
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
        element = splitted.map { |v|
          d, r, z2 = _date_time_or_duration(v, options.dup)
          delayed_options[:residue] = r  if r
          delayed_options[:clock  ] = z2 if z2
          d
        }

        # 意味のある繰り返しのない場合
        has_residue_options = delayed_options[:residue] && (delayed_options[:residue][0].kind_of?(String) ||
                                                            delayed_options[:residue][2].kind_of?(String))
        case repeat
        when nil ; return _instance_without_repeat(element).apply_delayed_options(delayed_options) unless has_residue_options
        when 0   ; return []
        when Integer
          return [element[0]] * repeat if element.length == 1 && element[0].kind_of?(When::TM::Duration) # JIS X0301 5.6.3
          raise ArgumentError, "Duration or TemporalPosition missing" unless element[1] || has_residue_options
        end

        # 繰り返しの起点と間隔
        base     = element[0].kind_of?(Duration) ? element[1] : element[0]
        duration = _duration_for_repeat(element)

        # 繰り返しのある場合
        if repeat.kind_of?(Integer) && !has_residue_options

          # iCalendar の機能を使用しない
          result = []
          seed   = base
          guard  = (base - When::V::Event.default_until)...(base + When::V::Event.default_until)
          while result.length < repeat && seed >= guard.first && seed < guard.last
            applied = seed.apply_delayed_options(delayed_options)
            applied = When::Parts::GeometricComplex.new(applied, delayed_options[:duration]) if delayed_options[:duration]
            result << applied if applied
            seed += duration
          end
          result.reverse! if duration.sign < 0
          return result

        else

          return duration.set_repeat(true) unless base

          # iCalendar の機能を使用する
          should_limit = base.precision == When::MONTH && !(delayed_options[:residue] && delayed_options[:residue][0])
          iterator = When::V::Event.iterator_for_ISO8601(base, duration, delayed_options)
          case repeat
          when nil     ; (result=iterator.succ).precision > base.precision && should_limit && base != result ? nil : result
          when Integer ; (0...repeat).to_a.map {iterator.succ}
          else         ; iterator
          end
        end
      end
      private :_instance_element

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
        parse = options.delete(:parse)
        if parse && parse[:residue] && parse[:residue][2]
          res << parse[:residue][2]
        end
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
        [:indeterminated_position, :frame, :events, :precision, :parse,
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
          position = When::Parts::GeometricComplex.new(position, P1W) unless w[1]
        end
        [position, r, z2]
      end

      # オブジェクト変換オプションの遅延適用対象オブジェクト
      #
      # @param [Array<When::TM::TemporalPosition or When::TM::Duration>] element
      #
      # @return [When::TM::TemporalPosition]    ISO8601 time point
      # @return [When::Parts::GeometricComplex] ISO8601 遅延適用対象オブジェクト
      #
      def _instance_without_repeat(element)
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
      end

      # 繰り返し用の Duration 取得
      #
      # @param [Array<When::TM::TemporalPosition or When::TM::Duration>] element
      #
      # @return [When::TM::Duration] repeating interval
      #
      def _duration_for_repeat(element)
        case element[1]
        when Duration
          case element[0]
          when Duration   ; raise TypeError, "Duplicate Duration: #{element[0]} and #{element[1]}"
          else            ; return element[1]
          end
        when self
          case element[0]
          when Duration   ; return -element[0]
          when self       ; return  element[1] - element[0]
          else            ; return  element[1] - element[0].first
          end
        when nil
          case element[0]
          when Duration   ; return element[0]
          else            ; nil
          end
        else
          case element[0]
          when Duration   ; return -element[0]
          when self       ; return  element[1].first - element[0]
          else            ; return  element[1].first - element[0].first
          end
        end
      end

      # オブジェクト変換オプションの遅延適用
      #
      # @param [Object] object 遅延適用するオブジェクト
      # 
      # @param [Hash] options 以下の通り
      # @option options [Hash<Integrt=>When::Coordinates::Residue>] :residue
      # @option options [When::TM::Clock]                           :clock
      # @option options [Array <When::TM::Calendar>]                :frame
      #
      # @return [Object] 遅延適用されたオブジェクト
      #
      def _apply_delayed_options(object, options)
        case object
        when Array                               ; object.map {|obj| _apply_delayed_options(obj, options)}
        when self, When::Parts::GeometricComplex ; object.apply_delayed_options(options)
        else                                     ; object
        end
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
      when Integer  ; return self + PeriodDuration.new(other, When::DAY)
      when Numeric  ; return self + IntervalLength.new(other, 'day')
      when Duration ; begin other = other.set_repeat(false); return other.enum_for(self+other, :forward) end if other.repeat
      when Array    ; return other.map {|o| self + o}
      else          ; raise TypeError, "The right operand should be Numeric or Duration"
      end
      return _plus(other) if other.kind_of?(PeriodDuration)
      @frame.kind_of?(Calendar) ? @frame.jul_trans(JulianDate.dynamical_time(dynamical_time + other.duration), self._attr) :
                                                   JulianDate.dynamical_time(dynamical_time + other.duration,  self._attr)
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
      when TimeValue; return self.time_standard.rate_of_clock == other.time_standard.rate_of_clock && [@precision, other.precision].min <= When::DAY ?
                        PeriodDuration.new(self.to_i - other.to_i, When::DAY) :
                        IntervalLength.new((self.dynamical_time - other.dynamical_time) / Duration::SECOND, 'second')
      when Integer  ; return self - PeriodDuration.new(other, When::DAY)
      when Numeric  ; return self - IntervalLength.new(other, 'day')
      when Duration ; begin other = other.set_repeat(false); return other.enum_for(self-other, :reverse) end if other.repeat
      when Array    ; return other.map {|o| self - o}
      else          ; raise TypeError, "The right operand should be Numeric, Duration or TemporalPosition"
      end
      return _plus(-other) if other.kind_of?(PeriodDuration)
      @frame.kind_of?(Calendar) ? @frame.jul_trans(JulianDate.dynamical_time(dynamical_time - other.duration), self._attr) :
                                                   JulianDate.dynamical_time(dynamical_time - other.duration,  self._attr)
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
      (@precision > DAY)
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
      elsif prec < DAY && precision < other.precision
        return +1 if other.to_i <  self.to_i
        return -1 if other.to_i >= succ.to_i
        return  0
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

    # オブジェクト変換オプションの遅延適用
    #
    # @param [Hash] options 以下の通り
    # @option options [Hash<Integrt=>When::Coordinates::Residue>] :residue
    # @option options [When::TM::Clock]                           :clock
    # @option options [Array <When::TM::Calendar>]                :frame
    #
    # @return [When::TM::TemporalPosition]
    #
    def apply_delayed_options(options)
      position = self
      if options[:residue]
        options[:residue].keys.sort.each do |count|
          options[:residue][count] = When.Residue(options[:residue][count]) unless options[:residue][count].kind_of?(When::Coordinates::Residue)
          residue = options[:residue][count]
          if count == 0
            residue   = residue.to('year')
            position &= residue
          else
            upper     = position
            position  = position.succ if residue.carry < 0
            position &= residue
            return nil if self.precision == When::MONTH && !(upper == position)
          end
        end
      end
      if options[:clock]
        position = options[:clock] ^ position
      end
      if options[:frame]
        position = options[:frame].inject(position) {|p,c| c.jul_trans(p)}
      end
      position
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
end
