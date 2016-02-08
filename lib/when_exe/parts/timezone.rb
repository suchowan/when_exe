# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2016 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

#
# 本ライブラリのための諸々の部品
#
module When::Parts

  #
  # TZInfo::Timezone クラスを本ライブラリから使用するためのラッパークラス
  #
  class Timezone

    #
    # When::TM::Clock, When::V::Timezone と Qhwn::Parts::Timezone の抽象基底
    # 
    module Base
      # 標準時間帯の時計
      # @return [When::TM::Clock]
      attr_reader :standard

      # 夏時間帯の時計
      # @return [When::TM::Clock]
      attr_reader :daylight

      # 夏時間帯と標準時間帯の時間差
      # @return [When::TM:IntervalLength]
      attr_reader :tz_difference

      # When::TM::TemporalPosition の時間帯を変更して複製する
      #
      # @param [When::TM::CalDate, When::TM::DateAndTime, When::TM::JulianDate] date
      # @param [Hash] options see {When::TM::TemporalPosition._instance}
      #
      # @return [When::TM::DateAndTime, When::TM::JulianDate]
      #
      def ^(date, options={})
        date   = When::TM::Position.any_other(date, options)
        my_opt = date._attr
        my_opt[:clock]         = self
        my_opt[:time_standard] = time_standard if respond_to?(:time_standard)
        my_opt.merge(options)
        return When::TM::JulianDate.dynamical_time(date.dynamical_time, my_opt) unless date.frame.kind_of?(When::TM::Calendar)
        date.frame.jul_trans(When::TM::JulianDate.dynamical_time(date.dynamical_time, {:time_standard=>my_opt[:time_standard]}), my_opt)
      end
    end

    class << self
      include Resource::Pool

      # @private
      alias :_get :[]

      # オブジェクト参照
      #
      # @param [String] label 識別名 ( "America/New_York" など)
      #
      # @return [When::Parts::Timezone] 時間帯オブジェクト
      #
      def [](label)
        ref = _get(label)
        return ref if ref
        return nil unless label =~ /\A[A-Z]/i
        self[label] = self.new(label)
      rescue NameError
        raise NameError, 'Prease install TZInfo - gem install tzinfo'
      end
      alias :get :[]

      # TZInfo でサポートしている Timezone の連想配列
      #
      # @return [Hash] { String => TZInfo::CountryTimezone }
      #   [ String                  - 時間帯ID ]
      #   [ TZInfo::CountryTimezone - 時間帯オブジェクト(proxy for autoload) ]
      #
      def tz_info
        return @tz_info if @tz_info
        zones = {}
        TZInfo::Country.all.each do |c|
          c.zone_info.each do |z|
            zones[z.identifier]       ||= {}
            zones[z.identifier][c.code] = z
          end
        end

        @tz_info = {}
        zones.each_pair do |id, hash|
          @tz_info[id] = hash[hash.keys[0]]
          unless hash.keys.size == 1
            hash.each_pair do |c, z|
              @tz_info["#{id}(#{c})"] = z
            end
          end
        end
        @tz_info
      end
    end

    include Base

    # ラップしている TZInfo::Timezone インスタンス
    # @return [TZInfo::Timezone]
    attr_reader :timezone

    # ユニーク識別名
    # @return [String]
    attr_reader    :identifier
    alias :label   :identifier
    alias :inspect :identifier

    # 時間帯を代表する都市の経度 / 度
    # @return [Rational]
    def longitude
      self.class.tz_info[label].longitude
    end

    # 時間帯を代表する都市の緯度 / 度
    # @return [Rational]
    def latitude
      self.class.tz_info[label].latitude
    end

    # 時間帯を代表する都市の空間位置
    # @return [When::Coordinates::Spatial]
    def location
      return @location if @location
      city_tz = @timezone
      unless self.class.tz_info[label]
        while city_tz.kind_of?(TZInfo::LinkedTimezone)
          city_tz = TZInfo::Timezone.get(city_tz.send(:info).link_to_identifier)
        end
      end
      tzinfo = self.class.tz_info[city_tz.identifier]
      longitude = When::Coordinates.to_dms(tzinfo.longitude, 'EW')
      latitude  = When::Coordinates.to_dms(tzinfo.latitude,  'NS')
      @location = When.Resource("_l:long=#{longitude}&lat=#{latitude}&label=#{label}")
    end

    # 時分秒のインデクス
    # @return [Array<When::Coordinates::Index>]
    attr_reader :indices

    # オブジェクト生成
    #
    # @param [String] identifier 識別名 ( "America/New_York" など)
    #
    def initialize(identifier)
      @identifier = identifier
      id, query   = identifier.split('?', 2)
      @timezone   = TZInfo::Timezone.get(id.sub(/\(.+?\)\z/,''))
      unless TZInfo::TimeOrDateTime.method_defined?(:_to_datetime)
        if TZInfo::RubyCoreSupport.respond_to?(:datetime_new)
          TZInfo::TimeOrDateTime.class_eval %Q{
            alias :_to_datetime :to_datetime
            ::Rational
            def to_datetime
              unless @datetime
                u = usec
                s = u == 0 ? sec : Rational(sec * 1000000 + u, 1000000)
                @datetime = TZInfo::RubyCoreSupport.datetime_new(year, mon, mday, hour, min, s, 0, Date::GREGORIAN)
              end
              @datetime
            end
          }
        else
          TZInfo::TimeOrDateTime.class_eval %Q{
            alias :_to_datetime :to_datetime
            def to_datetime
              @datetime ||= DateTime.new(year, mon, mday, hour, min, sec, 0, Date::GREGORIAN)
            end
          }
        end
      end
      dst, std  = _offsets(Time.now.to_i)
      options   = query ? Hash[*(query.split('&').map {|item| item.split('=',2)}.flatten)] : {}
      @standard = When::TM::Clock.new(options.merge({:zone=>std, :tz_prop=>self}))
      if std == dst
        @daylight      = @standard
        @tz_difference = 0
      else
        @daylight      = When::TM::Clock.new(options.merge({:zone=>dst, :tz_prop=>self}))
        @tz_difference = @standard.universal_time - @daylight.universal_time
      end
      @indices = When::Coordinates::DefaultTimeIndices
    end

    # @private
    def _daylight(time)
      frame, cal_date, clk_time = time
      clocks  = {}
      options = {}
      %w(border location).each do |attr|
        value = @standard.instance_variable_get("@#{attr}")
        next unless value
        value = value.dup unless value.kind_of?(When::Parts::Resource) && value.registered?
        options[attr] = value
      end
      if clk_time
        time    = frame.to_universal_time(cal_date, clk_time, @standard)
        offsets = _offsets((time/When::TM::Duration::SECOND).floor)
        offsets.each do |offset|
          clocks[offset] ||= When::TM::Clock.new(options.merge({:zone=>offset, :tz_prop=>self}))
          return clocks[offsets[0]] if @timezone.period_for_utc(
            (frame.to_universal_time(cal_date, clk_time, clocks[offset])/When::TM::Duration::SECOND).floor).dst?
        end
      end
      offset = @timezone.period_for_utc((time/When::TM::Duration::SECOND).floor).utc_total_offset
      clocks[offset] || When::TM::Clock.new(options.merge({:zone=>offset, :tz_prop=>self}))
    end

    # @private
    def _need_validate
      true
    end

    private

    def _offsets(time)
      now    = @timezone.period_for_utc(time)
      past   = @timezone.period_for_utc(now.utc_start-1) if now.utc_start
      future = @timezone.period_for_utc(now.utc_end)     if now.utc_end
      std    = now.utc_offset
      dst    = now.utc_total_offset
      [past, future].each do |period|
        next unless period
        std  = period.utc_offset       if std > period.utc_offset
        dst  = period.utc_total_offset if dst < period.utc_total_offset
      end
      [dst, std]
    end

    # その他のメソッド
    #   When::Parts::GeometricComplex で定義されていないメソッドは
    #   処理を first (type: When::TM::(Temporal)Position) に委譲する
    #
    def method_missing(name, *args, &block)
      self.class.module_eval %Q{
        def #{name}(*args, &block)
          timezone.send("#{name}", *args, &block)
        end
      } unless When::Parts::MethodCash.escape(name)
      timezone.send(name, *args, &block)
    end
  end
end
