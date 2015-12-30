# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2015 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

#
# 座標の記述に用いる諸オブジェクト
#
module When::Coordinates

  #
  # 空間位置
  #
  class Spatial < When::BasicTypes::Object

    LabelProperty = 'label'

    include When::Ephemeris

    require 'when_exe/ephemeris/eclipse'

    class << self
      # When::Coordinates::Spatial のグローバルな設定を行う
      #
      # @param [When::Coordinates::Spatial, String] location デフォルトの空間位置を使用する場合、指定する
      #
      # @return [void]
      #
      # @note
      #   本メソッドでマルチスレッド対応の管理変数の初期化を行っている。
      #   このため、本メソッド自体はスレッドセーフでない。
      #
      def _setup_(location=nil)
        @_lock_ = Mutex.new if When.multi_thread
        @_pool  = {}
        @default_location = location
      end

      # デフォルトの空間位置
      #
      # @param [When::Coordinates::Spatial, String] local デフォルトの空間位置
      #
      # @return [When::Coordinates::Spatial, String]
      #
      # @note
      #   @default_locationは、原則、ライブラリ立ち上げ時に _setup_ で初期化する。
      #   以降、@default_locationに代入を行っても、すでに生成した When::TM::TemporalPosition 等には反映されない。
      #
      def default_location=(local)
        if @_pool
          @default_location = local
        else
          _setup_(local)
        end
      end

      # 設定情報を取得する
      #
      # @return [Hash] 設定情報
      #
      def _setup_info
        {:location => @default_location}
      end

      # デフォルトの空間位置を読みだす
      #
      # @return [When::Coordinates::Spatial]
      #
      def default_location
        _default_location[1]
      end

      # デフォルトの空間位置が When::TM::Clock のローカルタイムから生成されたか?
      #
      # @return [true, false]
      #
      def is_default_location_derived?
        location = _default_location
        location[0] && location[1]
      end

      private

      # 共通処理
      def _default_location
        case @default_location
        when nil    ;
        when Array  ; return  @default_location unless @default_location[0]
        when String ; return (@default_location = [false, When.Resource(@default_location)])
        else        ; return (@default_location = [false, @default_location])
        end
        timezone = When::TM::Clock.local_time
        location = timezone.location if timezone.kind_of?(When::Parts::Timezone)
        return [true, location]
      end
    end

    # @private
    HashProperty = [:label, :longitude, :latitude, [:altitude, 0.0], [:datum, When::Ephemeris::Earth], :ref]

    # Degree / Internal Location Unit(16")
    #
    #   (3600 を 2 の因数で割りつくした値を単位とする)
    DEGREE     = 225

    # 黄道座標 (ecliptic coordinate  system)
    ECLIPTIC   = 0

    # 赤道座標 (equatorial coordinate system)
    EQUATORIAL = 1

    # 赤道座標[時角] (equatorial coordinate system with hour angle)
    EQUATORIAL_HA = 2

    # 地平座標 (horizontal coordinate system)
    HORIZONTAL = 3

    # 惑星中心の高度
    CENTER = :center

    # 角度の単位 (1 => 1度, 225=> 1/225 度)
    #
    # @return [Numeric]
    #
    attr_reader :degree

    # 北緯を正とする緯度 / 16秒
    #
    # @return [Numeric]
    #
    attr_reader :lat

    # 東経を正とする経度 / 16秒
    #
    # @return [Numeric]
    #
    attr_reader :long

    # 高度 / m
    #
    # @return [Numeric]
    # @return [:Center] 天体の中心の場合
    #
    attr_reader :alt
    alias :altitude :alt

    # 座標系
    #
    # @return [When::Ephemeris::Datum]
    #
    attr_reader :datum

    # 参照
    #
    # @return [String] URI
    #
    attr_reader :ref

    # 時間帯(オプショナル)
    #
    # @return [TZInfo::CountryTimezone]
    #
    #    TZInfoライブラリから経緯度を取得して使用する
    #
    attr_reader :tz

    # 緯度文字列
    #
    # @param [Integer] round 秒の小数点以下最大桁数
    #
    # @return [String] 緯度文字列(DD.MMSSsss[NS])
    #
    def lat_s
      When::Coordinates.to_dms(lat / @degree, 'NS', round=6)
    end
    alias :latitude :lat_s

    # 経度文字列
    #
    # @param [Integer] round 秒の小数点以下最大桁数
    #
    # @return [String] 経度文字列(DDD.MMSSsss[EW])
    #
    def long_s
      When::Coordinates.to_dms(long / @degree, 'EW', round=6)
    end
    alias :longitude :long_s

    # 高度 / m
    #
    # @return [Numeric]
    # @return [:Center] 天体の中心の場合
    #
    attr_reader :alt

    # 観測地の地心距離 / kmを返します。
    #
    # @return [Numeric]
    #
    def obserber_distance
      l = PI / (90 * @degree) * @lat
      @datum.surface_radius * (@datum.shape[0]+@datum.shape[1]*cos(l)+@datum.shape[2]*cos(2*l))
    end

    # 観測地での‘大地’の視半径
    #
    # @return [Numeric]
    #
    def horizon
      # 地面以下なら 90度とみなす
      return 0.25 if @alt == :Center || @alt <= 0

      # 観測地の地心距離 / m
      r = obserber_distance * 1000.0

      # 大気効果
      air_effect = @datum.air[1] * @alt / (@datum.air[2] * @alt + r)

      # ‘大地’の視半径
      asin((1.0+air_effect) * r / (r+@alt)) / CIRCLE
    end

    #  観測地の地方恒星時 / 時を返します。
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    # @param [When::TM::TemporalPosition] t
    #
    # @return [Numeric]
    #
    def local_sidereal_time(t)
      t = +t
      c = julian_century_from_2000(t)
      result  = @datum.sid[0] + c * (@datum.sid[1] + c * @datum.sid[2]) + @long / (15.0 * @degree)
      result += (cosc(obl(c)) * delta_p(c) +
                 (t-When::TimeStandard.delta_t_observed(t)/86400+0.5) % 1) * 24 if @datum.kind_of?(Earth)
      result
    end

    # 観測地の日心三次元座標(黄道座標)
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    # @param [When::TM::TemporalPosition] t
    #
    # @return [Numeric]
    #
    def _coords(t)
      t   = +t
      @datum._coords(t) + _coords_diff(t)
    end

    private

    # 要素の正規化
    def _normalize(args=[], options={})

      # 角度の単位は 1/225 度
      @degree ||= DEGREE

      # 同一視
      @long ||= @longitude
      @lat  ||= @latitude
      @alt  ||= @altitude

      # 時間帯による指定
      @tz = When::Parts::Timezone.tz_info[@tz] if @tz.kind_of?(String)
      if @tz
        @label ||= When.m17n(@tz.identifier)
        @long  ||= @tz.longitude
        @lat   ||= @tz.latitude
      end

      # データの整形
      @label = When::BasicTypes::M17n.new(@label) if @label.kind_of?(Hash)
      @long  = When::Coordinates.to_deg_225(@long, 'EW', @degree) if @long
      @lat   = When::Coordinates.to_deg_225(@lat,  'NS', @degree) if @lat
      @datum = When.Resource(@datum || 'Earth', '_ep:')
      @long ||= 0.0
      @lat  ||= 0.0
      @alt    =
        case @alt
        when String  ; @alt.gsub(/@/, '.').to_f
        when Numeric ; @alt.to_f
        when Symbol  ; @alt
        else         ; 0.0
        end

      # 日月食用作業変数
      @mean = When.Resource(@mean || '_ep:Formula?formula=1L')
      @ecls = {}

    end

    # 観測地の惑星中心を原点とする三次元座標
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    # @param [When::TM::TemporalPosition] t
    # @param [Integer] system : 座標系
    #   [ ECLIPTIC      = 黄道座標 ]
    #   [ EQUATORIAL    = 赤道座標 ]
    #   [ EQUATORIAL_HA = 赤道座標[時角] ]
    #   [ HORIZONTAL    = 地平座標 ]
    #
    def _coords_diff(t, system=ECLIPTIC)
      return Coords.polar(0,0,0) if alt == :Center
      t   = +t
      lat = @lat.to_f / @degree
      coords = Coords.polar(
                        local_sidereal_time(t) /  24.0,
         (lat + @datum.shape[3] * sind(2*lat)) / 360.0,
             (obserber_distance + @alt/1000.0) /   AU)
      case system
      when ECLIPTIC      ; coords.r_to_y(t, @datum)
      when EQUATORIAL    ; coords
      when EQUATORIAL_HA ; coords.r_to_rh(t, self)
      when HORIZONTAL    ; coords.r_to_h(t, self)
      end
    end

    # その他のメソッド
    #   When::Coordinates::Spatial で定義されていないメソッドは
    #   処理を @datum (type: When::Ephemeris::Datum) に委譲する
    #
    def method_missing(name, *args, &block)
      self.class.module_eval %Q{
        def #{name}(*args, &block)
          @datum.send("#{name}", *args, &block)
        end
      } unless When::Parts::MethodCash.escape(name)
      @datum.send(name, *args, &block)
    end

    # @private
    module Normalize

      private

      # 位置情報
      #
      # @return [When::Coordinates::Spatial]
      #
      #attr_reader :location

      # 日時要素の境界オブジェクト
      #
      # @return [When::Coordinates::Border]
      #
      #attr_reader :border

      # 境界計算用の計算オブジェクト
      #
      # @return [When::Ephemeris::Formula]
      #
      #attr_reader :formula

      #
      # Temporal Module の Spatial Parts の初期化
      #
      def _normalize_spatial

        # Location
        if (@location||@long||@lat||@alt).kind_of?(String)
          @location ||= "_l:long=#{@long||0}&lat=#{@lat||0}&alt=#{@alt||0}"
          @location   = When.Resource(@location)
        end
        @location   ||= @tz_prop.location if @tz_prop

        # Border
        @border = When.Border(@border) if @border.kind_of?(String)

        # Formula
        instance_eval('class << self; attr_reader :formula; end') if @location && @border
        if respond_to?(:formula)
          extend When::Ephemeris::Formula::ForwardedFormula
          unless @formula
            options  = {:formula => kind_of?(When::CalendarTypes::SolarYearTableBased) ? '1S' : '1L'}
            options[:location] = @location if @location
            @formula = When::Ephemeris::Formula.new(options)
          end
          @formula   = When.Resource(Array(@formula), '_ep:')
        end
      end
    end

    #
    # イベント管理用範囲オブジェクト
    #
    class Range

      class << self

        # 地名を空間座標化する
        #
        # @param [String] name 地名または座標
        #
        # @return [When::Coordinates::Spatial] or [When::Coordinates::Spatial::Range]
        #
        def [](name)
          source = name.strip
          case source
          when /\A(.+)\.\.(.+)\z/                       ; return self.new(_instance($1), _instance($2))
          when /\A([\d.]+)([SN])([\d.]+)([WE])([-+\d.]+)?\z/i ; lat,  sn, long, we, alt = $~[1..5]
          when /\A([\d.]+)([WE])([\d.]+)([SN])([-+\d.]+)?\z/i,
               /\A([-+\d.]+)(_)([-+\d.]+)(_)?([-+\d.]+)?\z/   ; long, we, lat,  sn, alt = $~[1..5]
          end
          locations =
            if long
              [[
                When::Coordinates.to_deg_225("#{long}#{we}", 'EW', 1),
                When::Coordinates.to_deg_225("#{lat }#{sn}", 'NS', 1),
                (alt || 0).to_f
              ]]
            else
              t = When::Coordinates::LocationTable
              keys = [source]
              keys.concat(name.names.values) if name.kind_of?(When::BasicTypes::M17n)
              keys_to_location(keys, t)
            end
          return locations unless locations.kind_of?(Array)
          locations = locations.map {|location|
            When::Coordinates::Spatial.new({'long'=>location[0], 'lat'=>location[1], 'alt'=>location[2], 'degree'=>1})
          }
          locations = locations.size > 1 ? self.new(*locations) : locations.first
          if t
            keys.each do |key|
              t[0][key] = locations
            end
          end
          locations
        end
        alias :_instance :[]

        # 地名に空間座標を設定する
        #
        # @param [String] name 地名または座標
        # @param [When::Coordinates::Spatial or When::Coordinates::Spatial::Range] 空間座標
        #
        def []=(name, locations)
          keys = [source]
          keys.concat(name.names.values) if name.kind_of?(When::BasicTypes::M17n)
          keys.each do |key|
            When::Coordinates::LocationTable[0][key] = locations
          end
        end

        private

        def keys_to_location(keys, t)
          keys.each do |key|
            if t[0].key?(key)
               return t[0][key] 
            elsif t[1].key?(key)
              return [t[1][key]]
            elsif t[2].key?(key)
              return [t[2][key][:SWB], t[2][key][:NET]]
            elsif t[3].key?(key)
              return [t[3][key][:SWB], t[3][key][:NET]]
            end
          end
          raise ArgumentError, keys.first + ' not found'
        end
      end

      # 西南下の境界
      #
      # @return [When::Coordinates::Spatial]
      #
      attr_reader :first

      # 西の境界
      #
      # @return [Numeric]
      #
      attr_reader :west

      # 南の境界
      #
      # @return [Numeric]
      #
      attr_reader :south

      # 下の境界
      #
      # @return [Numeric]
      #
      attr_reader :bottom

      # 東北上の境界
      #
      # @return [When::Coordinates::Spatial]
      #
      attr_reader :last

      # 東の境界
      #
      # @return [Numeric]
      #
      attr_reader :east

      # 北の境界
      #
      # @return [Numeric]
      #
      attr_reader :north

      # 上の境界
      #
      # @return [Numeric]
      #
      attr_reader :top

      # 東西の範囲
      #
      # @return [::Range]
      #
      attr_reader :long

      # 南北の範囲
      #
      # @return [::Range]
      #
      attr_reader :lat

      # 上下の範囲
      #
      # @return [::Range]
      #
      attr_reader :alt

      # 範囲の重なりの判断が複雑になるか？(ダミー)
      #
      # @return [Boolean] false - 単純
      #
      def is_complex?
        false
      end

      # 終端を除外するか？(ダミー)
      #
      # @return [Boolean] false - 除外しない
      #
      def exclude_end?
        false
      end

      # 指定オブジェクトが範囲内か？
      #
      # @param [Object] target 判定するオブジェクト
      #
      # @return [Boolean] true - 範囲内のオブジェクトあり, false - 範囲内のオブジェクトなし
      #
      def include?(target)
        case target
        when When::Coordinates::Spatial
          @long.include?(target.long) && @lat.include?(target.lat) && @alt.include?(target.alt)
        when Range
          @long.include?(target.west) && @lat.include?(target.south) && @alt.include?(target.bottom) &&
          @long.include?(target.east) && @lat.include?(target.north) && @alt.include?(target.top)
        else
          false
        end
      end

      #
      # 範囲の重なりの判断
      #
      # @param [Range] range 確認対象の単純範囲オブジェクト
      #
      # @return [Boolean] true - 重なる, false - 重ならない
      #
      def is_overlaped?(range)
        case target
        when When::Coordinates::Spatial
          @long.include?(target.long) && @lat.include?(target.lat) && @alt.include?(target.alt)
        when Range
          @west >= target.east && @north >= target.south && @top >= target.bottom &&
          @east <= target.west && @south <= target.north && @bottom <= target.top
        else
          false
        end
      end

      #
      # イベント管理用範囲オブジェクトの生成
      #
      # @param [When::Coordinates::Spatial] first 南西下の境界
      # @param [When::Coordinates::Spatial] last  東北上の境界
      #
      def initialize(first, last)
        @first  = first.kind_of?(Range) ? first.first : first
        @last   = last.kind_of?(Range)  ? last.last   : last
        @west   = @first.long
        @south  = @first.lat
        @bottom = @first.alt
        @east   = @last.long
        @north  = @last.lat
        @top    = @last.alt
        @long   = ::Range.new(@west,   @east,  false)
        @lat    = ::Range.new(@south,  @north, false)
        @alt    = ::Range.new(@bottom, @top,   false)
      end
    end
  end
end
