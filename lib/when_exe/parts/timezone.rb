# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2013 Takashi SUGA

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
        self[label] = self.new(label)
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
          if hash.keys.size == 1
            @tz_info[id] = hash[hash.keys[0]]
          else
            hash.each_pair do |c, z|
              @tz_info["#{id}(#{c})"] = z
            end
          end
        end
        @tz_info
      end
    end

    # ラップしている TZInfo::Timezone インスタンス
    # @return [TZInfo::Timezone]
    attr_reader :timezone

    # 標準時間帯の時計
    # @return [When::TM::Clock]
    attr_reader :standard

    # 夏時間帯の時計
    # @return [When::TM::Clock]
    attr_reader :daylight

    # 夏時間帯と標準時間帯の時間差
    # @return [When::TM:IntervalLength]
    attr_reader :difference

    # ユニーク識別名
    # @return [String]
    def label
      @timezone.identifier
    end

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

    # 時分秒のインデクス
    # @return [Array<When::Coordinates::Index>]
    attr_reader :indices

    # オブジェクト生成
    #
    # @param [String] identifier 識別名 ( "America/New_York" など)
    #
    def initialize(identifier)
      @timezone   = TZInfo::Timezone.get(identifier)
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
      std, dst    = _offsets(Time.now.to_i)
      @standard   = When::TM::Clock.new({:zone=>std, :tz_prop=>self})
      if std == dst
        @daylight   = @standard
        @difference = 0
      else
        @daylight   = When::TM::Clock.new({:zone=>dst, :tz_prop=>self})
        @difference = @standard.universal_time - @daylight.universal_time
      end
      @indices = When::Coordinates::DefaultTimeIndices
    end

    # @private
    def _daylight(zdate=nil)
      if block_given?
        zdate  = yield(@standard.dup.tap{|clock| clock.tz_prop = nil})
        now    = zdate.to_time.to_i
        clocks = _offsets(now).map {|clock| When::TM::Clock.new({:zone=>clock, :tz_prop=>self})}
        flags  = clocks.map {|z| @timezone.period_for_utc(yield(z.dup.tap{|clock| clock.tz_prop = nil}).to_time.to_i).dst? }
        (flags[0] || flags[1]) ? clocks[1] : clocks[0]
      else
        When::TM::Clock.new({:zone=>@timezone.period_for_utc(zdate.to_time.to_i).utc_total_offset, :tz_prop=>self})
      end
    end

    # @private
    def _need_validate
      true
    end

    private

    def _offsets(time)
      now         = @timezone.period_for_utc(time)
      past        = @timezone.period_for_utc(now.utc_start-1) if now.utc_start
      future      = @timezone.period_for_utc(now.utc_end)     if now.utc_end
      std         = now.utc_offset
      dst         = now.utc_total_offset
      [past, future].each do |period|
        next unless period
        std = period.utc_offset       if std > period.utc_offset
        dst = period.utc_total_offset if dst < period.utc_total_offset
      end
      [std, dst]
    end

    # その他のメソッド
    #   When::Parts::GeometricComplex で定義されていないメソッドは
    #   処理を first (type: When::TM::(Temporal)Position) に委譲する
    #
    def method_missing(name, *args, &block)
      timezone.send(name.to_sym, *args, &block)
    end
  end
end
