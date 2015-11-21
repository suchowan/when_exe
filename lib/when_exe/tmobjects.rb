# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2015 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::TM
#
# (5.2) Temporal Objects Package
#
#

  #
  # 長さと距離を計算するための操作を規定する
  #
  module Separation

    # When::TM::GeometricPrimitive 自身の持続時間
    #
    # @return [When::TM::Duration]
    #
    # @abstract
    #
    def length
      raise TypeError, "Absolute Class #{self.class}"
    end

    # 他のWhen::TM::GeometricPrimitiveとの時間位置の差の絶対値
    #
    # @param [When::TM::GeometricPrimitive] other
    #
    # @return [When::TM::Duration]
    #
    # @abstract
    #
    def distance(other)
      raise TypeError, "Absolute Class #{self.class}"
    end

  end

  #
  # 互いの相対位置を判定する操作を規定する
  #
  module Order

    # 他のWhen::TM::Primitiveとの相対的な時間位置
    #
    # @param [When::TM::Primitive] other
    #
    # @return [When::TM::RelativePosition]
    #
    # @abstract
    #
    def relative_position(other)
      raise TypeError, "Absolute Class #{self.class}"
    end
    alias :relativePosition :relative_position

  end

  # 相対的な時間位置
  #
  # Allen(1983) が分類した13種類の相対的な時間位置を定義している
  #
  # ISO19108では値は Code クラスだが、本実装では値は Symbol である
  #
  # see {http://schemas.opengis.net/gml/3.1.1/base/temporal.xsd#RelatedTimeType gml schema}
  #
  # see Allen,J.F., Maintaining Knowledge about Temporal Intervals, Communications of the ACM, 1983,vol.26 pp.832-843
  #
  module RelativePosition

    Before       = :Before
    After        = :After
    Begins       = :Begins
    Ends         = :Ends
    During       = :During
    Equals       = :Equals
    Contains     = :Contains
    Overlaps     = :Overlaps
    Meets        = :Meets
    OverlappedBy = :OverlappedBy
    MetBy        = :MetBy
    BegunBy      = :BegunBy
    EndedBy      = :EndedBy

  end

  # 時間のオブジェクト
  #
  # see {http://schemas.opengis.net/gml/3.1.1/base/temporal.xsd#AbstractTimeObjectType gml schema}
  #
  class Object < When::BasicTypes::Object

  end

  # 複数の時間プリミティブの集成
  #
  # see {http://schemas.opengis.net/gml/3.1.1/base/temporal.xsd#AbstractTimeComplexType gml schema}
  #
  class Complex < Object

  end

  # 位相複体 - 連結した位相プリミティブの集合
  #
  # A temporal topology complex.
  #
  # see {http://schemas.opengis.net/gml/3.1.1/base/temporalTopology.xsd#TimeTopologyComplexType gml schema}
  #
  class TopologicalComplex < Complex

    # 対応するプリミティブ (relation - Complex)
    #
    # @return [Array<When::TM::TopologicalPrimitive>]
    #
    attr_reader :primitive

    # オブジェクトの生成
    #
    # @param [When::TM::TopologicalPrimitive] primitive 対応するプリミティブの Array
    #
    def initialize(primitive)
      @primitive = primitive
      @primitive.each do |p|
        p.complex << self
      end
    end
  end

  # 時間プリミティブ
  #
  # see {http://schemas.opengis.net/gml/3.1.1/base/temporal.xsd#AbstractTimePrimitiveType gml schema}
  #
  class Primitive < Object

    include Order

  end

  # 時間幾何プリミティブ
  #
  # see {http://schemas.opengis.net/gml/3.1.1/base/temporal.xsd#AbstractTimeGeometricPrimitiveType gml schema}
  #
  class GeometricPrimitive < Primitive

    include Separation

  end

  # 瞬間 - 零次元幾何プリミティブ
  #
  # see {http://schemas.opengis.net/gml/3.1.1/base/temporal.xsd#TimeInstantType gml schema}
  #
  class Instant < GeometricPrimitive

    # この瞬間の時間位置
    #
    # @return [When::TM::Position]
    #
    attr_reader :position

    # この瞬間を始まりとする期間 (relation - Beginning)
    #
    # @return [Array<When::TM::Period>]
    #
    attr_reader :begun_by
    alias :begunBy :begun_by

    # この瞬間を終わりとする期間 (relation - Ending)
    #
    # @return [Array<When::TM::Period>]
    #
    attr_reader :ended_by
    alias :endedBy :ended_by

    # 対応するノード (relation - Realization)
    #
    # @return [When::TM::Node]
    #
    attr_reader :topology

    # When::TM::GeometricPrimitive 自身の持続時間
    #
    # @return [When::TM::Duration]
    #
    def length()
      return When.Duration(0)
    end

    # 他のWhen::TM::GeometricPrimitiveとの時間位置の差の絶対値
    #
    # @param [When::TM::GeometricPrimitive] other
    #
    # @return [When::TM::Duration]
    #
    def distance(other)
      case other
      when Instant
        return (self.position - other.position).abs
      when Period
        verify = other.begin.position - self.position
        return verify if verify.sign >= 0
        return [self.position - other.end.position, When::TM::PeriodDuration.new(0,When::DAY)].max
      else
        raise TypeError, "The right operand should be When::TM::Instant or When::TM::Period"
      end
    end

    # 他のWhen::TM::Primitiveとの相対的な時間位置
    #
    # @param [When::TM::Primitive] other
    #
    # @return [When::TM::RelativePosition]
    #
    def relative_position(other)
      case other
      when Instant
        verify = self.position <=> other.position
        return RelativePosition::Before if verify <  0
        return RelativePosition::Equals if verify == 0
        return RelativePosition::After
      when Period
        verify = self.position <=> other.begin.position
        return RelativePosition::Before if verify <  0
        return RelativePosition::Begins if verify == 0
        verify = self.position <=> other.end.position
        return RelativePosition::During if verify <  0
        return RelativePosition::Ends   if verify == 0
        return RelativePosition::After
      else
        raise TypeError, "The right operand should be When::TM::Instant or When::TM::Period"
      end
    end
    alias :relativePosition :relative_position

    # オブジェクトの生成
    #
    # @param [When::TM::Position] position 対応する時間位置
    #
    def initialize(position)
      @position = position
      @begun_by = []
      @ended_by = []
    end

    private

    # その他のメソッド
    #
    # @note
    #   When::TM::Instant で定義されていないメソッドは
    #   処理を @position (type: When::TM::Position) に委譲する
    #
    def method_missing(name, *args, &block)
      self.class.module_eval %Q{
        def #{name}(*args, &block)
          list = args.map {|arg| arg.kind_of?(self.class) ? arg.position : arg}
          @position.send("#{name}", *list, &block)
        end
      } unless When::Parts::MethodCash.escape(name)
      list = args.map {|arg| arg.kind_of?(self.class) ? arg.position : arg}
      @position.send(name, *list, &block)
    end
  end

  # 期間 - 一次元幾何プリミティブ
  #
  # see {http://schemas.opengis.net/gml/3.1.1/base/temporal.xsd#TimePeriodType gml schema}
  #
  class Period < GeometricPrimitive

    RELATIVE_POSITION = {
      RelativePosition::Contains => {
        RelativePosition::Before   => RelativePosition::Overlaps,
        RelativePosition::EndedBy  => RelativePosition::EndedBy,
        RelativePosition::Contains => RelativePosition::Contains
      },
      RelativePosition::BegunBy => {
        RelativePosition::Before   => RelativePosition::Begins,
        RelativePosition::EndedBy  => RelativePosition::Equals,
        RelativePosition::Contains => RelativePosition::BegunBy
      },
      RelativePosition::After => {
        RelativePosition::Before   => RelativePosition::During,
        RelativePosition::EndedBy  => RelativePosition::Ends,
        RelativePosition::Contains => RelativePosition::OverlappedBy
      }
    }

    # この期間が始まる瞬間 (relation - Beginning)
    #
    # @return [When::TM::Instant]
    #
    attr_reader :begin

    # この期間が終わる瞬間 (relation - Ending)
    #
    # @return [When::TM::Instant]
    #
    attr_reader :end

    # 対応するエッジ (relation - Realization)
    #
    # @return [When::TM::Edge]
    #
    attr_reader :topology

    # When::TM::GeometricPrimitive 自身の持続時間
    #
    # @return [When::TM::Duration]
    #
    def length()
      @length ||= @end - @begin
    end

    # 他のWhen::TM::GeometricPrimitiveとの時間位置の差の絶対値
    #
    # @param [When::TM::GeometricPrimitive] other
    #
    # @return [When::TM::Duration]
    #
    def distance(other)
      case other
      when Instant
        return other.distance(self)
      when Period
        verify = other.begin.position - self.end.position
        return verify if verify.sign >= 0
        return [self.begin.position - other.end.position, When::TM::PeriodDuration.new(0,When::DAY)].max
      else
        raise TypeError, "The right operand should be Instant or Period"
      end
    end

    # 他のPrimitiveとの相対的な時間位置
    #
    # @param [When::TM::Primitive] other
    #
    # @return [When::TM::RelativePosition]
    #
    def relative_position(other)
      case other
      when Instant
        verify = self.end.position <=> other.position
        return RelativePosition::Before   if verify <  0
        return RelativePosition::EndedBy  if verify == 0
        verify = self.begin.position <=> other.position
        return RelativePosition::Contains if verify <  0
        return RelativePosition::BegunBy  if verify == 0
        return RelativePosition::After
      when Period
        verify_b = relative_position(other.begin)
        case verify_b
        when RelativePosition::Before  ; return RelativePosition::Before
        when RelativePosition::EndedBy ; return RelativePosition::Meets
        end
        verify_e = relative_position(other.end)
        case verify_e
        when RelativePosition::BegunBy ; return RelativePosition::MetBy
        when RelativePosition::After   ; return RelativePosition::After
        else                           ; return RELATIVE_POSITION[verify_b][verify_e]
        end
      else
        raise TypeError, "The right operand should be Instant or Period"
      end
    end
    alias :relativePosition :relative_position

    # オブジェクトの生成
    #
    # @param [When::TM::Instant] begun 始点
    #
    # @param [When::TM::Instant] ended 終点
    #
    def initialize(begun, ended)
      raise ArgumentError, 'Order mismatch: begun > ended' if begun > ended
      @begin = begun
      @end   = ended
      @begin.begun_by << self
      @end.ended_by   << self
    end

    private

    # その他のメソッド
    #
    # @note
    #   When::TM::Period で定義されていないメソッドは
    #   処理を @begin (type: When::TM::Instant) に委譲する
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

  # 時間位相プリミティブ - 単独で不可分な位相要素
  #
  # see {http://schemas.opengis.net/gml/3.1.1/base/temporalTopology.xsd#AbstractTimeTopologyPrimitiveType gml schema}
  #
  class TopologicalPrimitive < Primitive

    # 対応するコンプレックス (relation - Complex)
    #
    # @return [Array<When::TM::TopologicalComplex>]
    #
    attr_accessor :complex

    #
    # オブジェクトの生成
    #
    def initialize
      @complex = []
    end

    private

    alias :_method_missing :method_missing

    # その他のメソッド
    #
    # @note
    #   When::TM::TopologicalPrimitive で定義されていないメソッドは
    #   処理を @geometry (type: When::TM::Instant) に委譲する
    #
    def method_missing(name, *args, &block)
      return _method_missing(name, *args, &block) if When::Parts::MethodCash::Escape.key?(name) ||
                                                     !respond_to?(:geometry)
      self.class.module_eval %Q{
        def #{name}(*args, &block)
          list = args.map {|arg| arg.respond_to?(:geometry) ? arg.geometry : arg}
          geometry.send("#{name}", *list, &block)
        end
      } unless When::Parts::MethodCash.escape(name)
      list = args.map {|arg| arg.respond_to?(:geometry) ? arg.geometry : arg}
      geometry.send(name, *list, &block)
    end
  end

  # 零次元位相プリミティブ - 幾何的実現は When::TM::Instant と対応する
  #
  # see {http://schemas.opengis.net/gml/3.1.1/base/temporalTopology.xsd#TimeNodeType gml schema}
  #
  class Node < TopologicalPrimitive

    # 対応するエッジ (relation - Termination)
    #
    # @return [Array<When::TM::Edge>]
    #
    attr_reader :previous_edge
    alias :previousEdge :previous_edge

    # 対応するエッジ (relation - Initiation)
    #
    # @return [Array<When::TM::Edge>]
    #
    attr_reader :next_edge
    alias :nextEdge :next_edge

    # 対応する瞬間 (relation - Realization)
    #
    # @return [When::TM::Instant]
    #
    attr_reader :geometry

    # オブジェクトの生成
    #
    # @param [When::TM::Instant] geometry 対応する瞬間
    #
    def initialize(geometry)
      super()
      @previous_edge     = []
      @next_edge         = []
      @geometry          = geometry
      @geometry.topology = self
    end
  end

  # 一次元位相プリミティブ - 幾何的実現は When::TM::Period と対応する
  #
  # see {http://schemas.opengis.net/gml/3.1.1/base/temporalTopology.xsd#TimeEdgeType gml schema}
  #
  class Edge < TopologicalPrimitive

    # 対応するノード (relation - Termination)
    #
    # @return [When::TM::Node]
    #
    attr_reader :end

    # 対応するノード (relation - Initiation)
    #
    # @return [When::TM::Node]
    #
    attr_reader :start

    # 対応する期間 (relation - Realization)
    #
    # @return [When::TM::Period]
    #
    attr_reader :geometry

    # オブジェクトの生成
    #
    # @param [When::TM::Node] start 始点
    #
    # @param [When::TM::Node] ended 終点
    #
    def initialize(start, ended)
      super()
      @start = start
      @end   = ended
      @geometry = Period.new(@start.geometry, @end.geometry)
      @geometry.topology  = self
      @start.next_edge   << self
      @end.previous_edge << self
    end
  end

  # 時間次元における長さ又は距離を記述するために使うデータ型
  #
  # see {http://schemas.opengis.net/gml/3.1.1/base/temporal.xsd#duration gml schema}
  #
  class Duration

    # 繰り返し有無
    #
    # @return [Boolean]
    #
    attr_accessor :repeat
    protected :repeat=

    #
    # When::TM::IntervalLength への変換
    #
    # @return [When::TM::IntervalLength]
    #
    def to_interval_length
      [['week', WEEK], ['day', DAY], ['hour', HOUR], ['minute', MINUTE], ['second', SECOND]].each do |unit|
        div, mod = duration.divmod(unit[1])
        return When::TM::IntervalLength.new(div, unit[0]) if mod == 0
      end
      When::TM::IntervalLength.new(duration / SECOND, 'second')
    end

    #
    # When::TM::PeriodDuration への変換
    #
    # @return [When::TM::PeriodDuration]
    #
    def to_period_duration
      [[When::WEEK, WEEK], [When::DAY, DAY], [When::HOUR, HOUR], [When::MINUTE, MINUTE], [When::SECOND, SECOND]].each do |unit|
        div, mod = duration.divmod(unit[1])
        return When::TM::PeriodDuration.new(div, unit[0]) if mod == 0
      end
      When::TM::PeriodDuration.new(duration / SECOND, When::SECOND)
    end

    # オブジェクト変換オプションの遅延適用(ダミー)
    #
    # @param [Hash] options 以下の通り
    # @option options [Hash<Integrt=>When::Coordinates::Residue>] :residue
    # @option options [When::TM::Clock]                           :clock
    # @option options [Array <When::TM::Calendar>]                :frame
    #
    # @return [When::TM::Duration]
    #
    def apply_delayed_options(options)
      self
    end

    # 繰り返し設定
    #
    # @param [Boolean] repeat 設定
    #
    # @return [When::TM::Duration]
    #
    def set_repeat(repeat)
      repeated = dup
      repeated.repeat = repeat
      repeated
    end

    #
    # Duration 用の Enumerator
    #
    class Enumerator < When::Parts::Enumerator

      # 次の時間位置を取得する
      #
      # @return [When::TM::TemporalPosition] 次の時間位置
      #
      def succ
        value    = @current
        @current = (@count_limit.kind_of?(Numeric) && @count >= @count_limit) ? nil :
                   (@current==:first) ? @first :
                   (@direction==:reverse) ? @first - @parent * @count : @first + @parent * @count
        if @last
          sign     = @parent.sign
          sign     = -sign if @direction==:reverse
          @current = nil if (sign * (@current <=> @last)) > 0
        end
        @count  += 1
        return value
      end
    end

    # Enumerator の生成
    #
    # @overload initialize(range, count_limit=nil))
    #   @param [Range, When::Parts::GeometricComplex] range
    #     [ 始点 - range.first ]
    #     [ 終点 - range.last  ]
    #   @param [Integer] count_limit 繰り返し回数(デフォルトは指定なし)
    #
    # @overload initialize(first, direction, count_limit=nil))
    #   @param [When::TM::TemporalPosition] first 始点
    #   @param [Symbol] direction
    #     [ :forward - 昇順 ]
    #     [ :reverse - 降順 ]
    #   @param [Integer] count_limit 繰り返し回数(デフォルトは指定なし)
    #
    def _enumerator(*args)
      return Enumerator.new(*args.unshift(self))
    end
    alias :to_enum  :_enumerator
    alias :enum_for :_enumerator
  end

  #
  # ISO 11404 の時間間隔に基づいて定義された When::TM::Duration の subclass
  #
  # see {http://schemas.opengis.net/gml/3.1.1/base/temporal.xsd#timeIntervalLengthType gml schema}
  #
  class IntervalLength < Duration

    Alias  = {'Y'=>'year', 'M'=>'month' , 'D'=>'day', 'W'=>'week', 'S'=>'system',
              'h'=>'hour', 'm'=>'minute', 's'=>'second'}

    # Interval Length 形式の表現を分解して配列化する
    #
    # @param [String] interval
    #
    # @return [Array<Numeric, String>] ( value, unit_name, factor, radix )
    #   [ value     [Numeric] - 時間間隔 / 単位 ]
    #   [ unit_name [String]  - 単位名 ]
    #   [ factor    [Numeric] - 冪乗 ]
    #   [ radix     [Numeric] - 冪乗の基数 ]
    #
    # @note value, factor, radix は Numeric
    #
    def self._to_array(interval)
      return nil unless interval =~ /\A([-+]?[\d.]+)(?:(E|X|\((\d+)\))([-+]?\d+))?([A-Za-z]+|\*([\d.]+)S)\z/
      value, radix, radix_quantity, factor, unit, unit_quantity = $~[1..6]
      value  = When::Coordinates::Pair._en_number(value)
      radix  = case radix
               when 'E', nil ; 10
               when 'X'      ; 60
               else          ; radix_quantity.to_i
               end
      factor = factor ? -factor.to_i : 0
      return [value, unit_quantity, factor, radix] if unit_quantity
      unit_quantity = Unit[unit.downcase] || Unit[Alias[unit[0..0]]]
      return [value,  UnitName[unit_quantity], factor, radix] if unit_quantity
      return nil
    end

    # 時間間隔の長さ (128秒単位)
    #
    # @return [Numeric]
    #
    protected :duration=

    # 時間間隔を表現するために使用した測定単位の名称
    #
    # @return [String] (year|month|week|day|hour|minute|second|system)
    #
    attr_reader :unit

    # 時間単位となる乗数の基底となる正の整数
    #
    # @return [Integer]
    #
    attr_reader :radix

    # 基底のべき乗を行う指数
    #
    # @return [Integer]
    #
    attr_reader :factor

    # 時間間隔の長さ / 測定単位
    #
    # @return [Numeric]
    #
    attr_accessor :value
    protected :value=

    #
    # 測定単位の大きさ
    #
    # @return [Numeric]
    #
    attr_reader :unit_quantity

    # 時刻配列
    #
    # @return [Numeric]
    #     When::TM::PeriodDuration との互換性のために提供
    #
    # @private
    #
    def time
      [0, 0, @duration / SECOND]
    end

    # 日付配列
    #
    # @return [nil]
    #     When::TM::PeriodDuration との互換性のために提供
    #
    # @private
    #
    def date
      nil
    end

    # 暦週配列
    #
    # @return [nil]
    #     When::TM::PeriodDuration との互換性のために提供
    #
    # @private
    #
    def weeks
      nil
    end

    # 符号反転
    #
    # @return [When::TM::IntervalLength]
    #
    def -@
      interval = self.dup
      interval.value    = -@value
      interval.duration = -@duration
      return interval
    end

    #
    # 加算
    #
    # @param [When::TM::Duration] other
    # @param [Numeric] other 秒数
    # @param [その他] other 日時とみなす
    #
    # @return [When::TM::IntervalLength] (other が Numeric, When::TM::Duration の場合)
    # @return [other と同じクラス] (other がその他の場合)
    #
    def +(other)
      case other
      when Duration ; diff = other.duration
      when Numeric  ; diff = other * SECOND
      else          ; return other + self
      end
      interval = self.dup
      interval.duration = @duration + diff
      interval.value    = interval.duration / (@radix ** (-@factor) * @unit_quantity)
      return interval
    end

    #
    # 減算
    #
    # @param [When::TM::IntervalLength] other
    # @param [Numeric] other 秒数
    #
    # @return [When::TM::IntervalLength]
    #
    def -(other)
      interval = self.dup
      interval.duration = @duration - (other.kind_of?(Duration) ? other.duration : other * SECOND)
      interval.value    = interval.duration / (@radix ** (-@factor) * @unit_quantity)
      return interval
    end

    # 乗算
    #
    # @param [Numeric] times
    #
    # @return [When::TM::IntervalLength]
    #
    def *(times)
      interval = self.dup
      interval.value    = times * @value
      interval.duration = times * @duration
      return interval
    end

    #
    # 除算
    #
    # @param [When::TM::IntervalLength] other
    # @param [Numeric] other 秒数
    #
    # @return [When::TM::IntervalLength] (other が Numeric  の場合)
    # @return [Numeric] (other が When::TM::Duration の場合)
    #
    def /(other)
      other.kind_of?(Duration) ? @duration / other.duration : self * (1.0 / other)
    end

    # 文字列化
    #
    # @return [String]
    #
    def to_s
      expression = @value.to_s
      unless @factor == 0
        case @radix
        when 10 ; expression += 'E'
        when 60 ; expression += 'X'
        else    ; expression += '(%d)' % @radix
        end
        expression += '%+d' % (-@factor)
      end
      expression += Alias.invert[@unit] || "*#{When::Coordinates::Pair._en_number(@unit)}S"
      return expression
    end

    #
    # When::TM::IntervalLength への変換
    #
    #   単なるオブジェクトのコピー
    #
    # @return [When::TM::IntervalLength]
    #
    def to_interval_length
      self.dup
    end

    # オブジェクトの生成
    #
    # @param [Numeric] value 時間間隔の長さ / 測定単位(省略不可)
    # @param [String]  unit 時間間隔を表現するために使用した測定単位の名称(デフォルト : system)
    #   ('year'|'month'|'week'|'day'|'hour'|'minute'|'second'|'system')
    # @param [Integer] factor  基底の冪乗を行う指数(デフォルト : 0)
    # @param [Integer] radix  時間単位となる乗数の基底となる正の整数(デフォルト : 10)
    #
    def initialize(value, unit='system', factor=0, radix=10)
      @value, @factor, @radix = value, factor, radix
      @unit_quantity   = Unit[unit.downcase] || Unit[Alias[unit[0..0]]] if unit.kind_of?(String)
      @unit_quantity ||= unit.to_f
      raise TypeError, "Wrong Unit Type: #{unit}" unless @unit_quantity.kind_of?(Numeric)
      @unit = UnitName[@unit_quantity] ||
              When::Coordinates::Pair._en_number(@unit_quantity).to_s
      @duration = @value * @radix ** (-@factor) * @unit_quantity
    end

    # オブジェクトの生成(終点と始点を指定)
    #
    # @param [When::TM::TemporalPosition] ended 終点
    # @param [When::TM::TemporalPosition] begun 始点
    #
    # @return [When::TM::IntervalLength]
    #   [ 日単位の精度 - 終点と始点の分解能のいずれかが“日”またはそれより粗い場合 ]
    #   [ システム精度 - 終点と始点の分解能がともに“日”より細かい場合 ]
    #
    def self.difference(ended, begun)
      precision = [ended.precision, begun.precision].min
      return new(ended-begun) if precision > When::DAY
      return new(ended.to_i - begun.to_i, unit='day')
    end

    private

    # その他のメソッド
    #
    # @note
    #   When::TM::IntervalLength で定義されていないメソッドは
    #   処理を @duration (type:Numeric) に委譲する
    #
    def method_missing(name, *args, &block)
      self.class.module_eval %Q{
        def #{name}(*args, &block)
          @duration.send("#{name}", *args, &block)
        end
      } unless When::Parts::MethodCash.escape(name)
      @duration.send(name, *args, &block)
    end
  end

  #
  # ISO 8601 (JIS X0301) の時間間隔に基づいて定義された When::TM::Duration の subclass
  #
  class PeriodDuration < Duration

    include When
    include Coordinates

    #
    # When::TM::PeriodDuration オブジェクトが月や年などの可変長の単位に依存する場合
    # に @duration 属性の参照を禁止するために用いる
    #
    module NoDuration
      #
      # 属性 @duration が定義できないとをエラーで示す
      #
      # @return [Numeric]
      #
      def duration
        raise TypeError, "This PeriodDuration object does't have duration value"
      end
    end

    # ISO 8601 形式の表現を分解して配列化する
    #
    # @param [String] period
    #
    # @return [Array<Numeric, Array<Numeric>>] ( sign, date, time, week )
    #   [ sign [Numeric]        - +1 , -1 ]
    #   [ date [Array<Numeric>] - 年月日  ]
    #   [ time [Array<Numeric>] - 時分秒  ]
    #   [ week [Array<Numeric>] - 週日    ]
    #
    def self._to_array(period)

      return nil unless period.gsub(/_+/, '') =~ /\A([-+])?P(.*?)?(?:T(.+))?\z/

      sign = ($1 == '-') ? -1 : +1
      pdate, ptime = $~[2..3]

      # 時分秒形式
      if (ptime =~ /\A(?:([.,\d]+)?([:*=])?H)?(?:([.,\d]+)?([:*=])?M)?(?:([.,\d]+)?([:*=])?S)?((?:[.,\d]*[:*=]?X)*)\z/)
        trunk = [1,3,5].map {|i|
            $~[i] ? Pair._en_pair($~[i], $~[i+1]) : 0
          }
        extra = $7 ? $7.scan(/([.,\d]+)?([:*=])?X/).map {|d|
            d[0] ? Pair._en_pair(d[0], d[1]) : 0
          } : []
        time = [0] + trunk + extra
        time = nil if time.uniq == [0]
      end

      case pdate
      # 年月日形式
      when /\A((?:[.,\d]*[-*=]?X)*)(?:([.,\d]+)?([-*=])?Y)?(?:([.,\d]+)?([-+*&%!>=<?])?M)?(?:([.,\d]+)?([-*=?%])?D)?\z/
        trunk = [2,4,6].map {|i|
            $~[i] ? Pair._en_pair($~[i], $~[i+1]) : 0
          }
        extra = $1 ? $1.scan(/([.,\d]+)?([:*=])?X/).map {|d|
            d[0] ? Pair._en_pair(d[0], d[1]) : 0
          } : []
        date = extra + trunk
        date = nil if date.uniq == [0]
        return sign, date, time

      # 週日形式
      when /\A(?:([.,\d]+)?([:*=])?W)(?:([.,\d]+)?([-*=?%])?D)?\z/
        week = [1,3].map {|i|
            $~[i] ? Pair._en_pair($~[i], $~[i+1]) : 0
          }
        return sign, nil, time if week.uniq == [0]
        date = [0,  0, week[1] + 7*week[0]]
        return sign, date, time, week

      # 代用形式
      else
        pdate += 'T' + ptime if ptime
        f, d, t, z, e = When::BasicTypes::DateTime._to_array(pdate, {:abbr=>[0]*20})
        return nil if e
        if d
          case f
          when :day          ; date       = [d[0], 0, d[1]]
          when :century, nil ; date       = (0..2).map {|i| d[i]||0}
          when :week         ; date, week = [0,0,d[0]*7+(d[1]||0)], [d[0], d[1]||0]
          end
        end
        time = t ? (t.map {|v| v||0}) : nil
        return sign, date, time, week
      end
    end

    # 期間の日数
    #
    # @return [Integer]
    #
    # @note 固定の整数で表現できない場合は nil
    #
    attr_reader :to_day

    # 期間の日付要素
    #
    # @return [Array<Numeric>]
    #
    attr_accessor :date
    private :date=

    # 期間の週日要素
    #
    # @return [Array<Numeric>]
    #
    attr_accessor :week
    private :week=

    # 期間の時刻要素
    #
    # @return [Array<Numeric>]
    #
    attr_accessor :time
    private :time=

    # 要素の参照
    #
    # @param [Numeric] index When::Coordinates で定義している分解能定数に対応する列挙型( YEAR, ... , SECOND)
    #
    # @return [Numeric]
    #
    def [](index)
      if index == WEEK
        return nil unless @week
        return @week[0]
      elsif index <= 0
        return nil unless @date
        return @date[index-1]
      else
        return nil unless @time
        return @time[index]
      end
    end

    # 持続期間であることを文字'P'で示す
    #
    # @return [String]
    #
    def designator
      return 'P'
    end

    # 期間に含まれる年数を示す
    #
    # @return [String]
    #
    def years
      return nil unless @date
      return @date[YEAR-1].to_s
    end

    # 期間に含まれる月数を示す
    #
    # @return [String
    #
    def months
      return nil unless @date
      return @date[MONTH-1].to_s
    end

    # 期間に含まれる週数を示す
    #
    # @return [String]
    #
    def weeks
      return nil unless @week
      return @week[0].to_s
    end

    # 期間に含まれる日数を示す
    #
    # @return [String]
    #
    def days
      return nil unless @date
      return @date[DAY-1].to_s
    end

    # 期間が1日より短い時間単位を含むとき文字'T'で示す
    #
    # @return [String]
    #
    def time_indicator
      return (@time) ? 'T' : nil
    end
    alias :timeIndicator :time_indicator

    # 期間に含まれる時間数を示す
    #
    # @return [String]
    #
    def hours
      return nil unless @time
      return @time[HOUR].to_s
    end

    # 期間に含まれる分数を示す
    #
    # @return [String]
    #
    def minutes
      return nil unless @time
      return @time[MINUTE].to_s
    end

    # 期間に含まれる秒数を示す
    #
    # @return [String]
    #
    def seconds
      return nil unless @time
      return @time[SECOND].to_s
    end

    # 符号反転
    #
    # @return [When::TM::PeriodDuration]
    #
    def -@
      period = self.dup
      period.send(:date=, @date.map {|v| -v}) if @date
      period.send(:week=, @week.map {|v| -v}) if @week
      period.send(:time=, @time.map {|v| -v}) if @time
      period.send(:_duration)
      return period
    end

    # 符号
    #
    # @return [Integer] 0 との比較により、負,0,正の値を返す
    #
    def sign
      @sign ||= _sign
    end

    def _sign
     ((@week || @date || []) + (@time || [])).each do |v|
       return -1 if +v < 0
     end
     return +1
    end
    private :_sign

    # 比較
    #
    # @param [When::TM::PeriodDuration] other
    #
    # @return [Integer] other との比較により、負,0,正の値を返す
    #
    def <=>(other)
      unless (@date && @date.size) == (other.date && other.date.size) &&
             (@week && @week.size) == (other.week && other.week.size) &&
             (@time && @time.size) == (other.time && other.time.size)
        raise ArgumentError, "PeriodDuration structure mismatch"
      end

      (0...@week.size).each do |i|
         sgn = +@week[i] <=> +other.week[i]
         return sgn unless sgn == 0
      end if @week

      (0...@date.size).each do |i|
         sgn = +@date[i] <=> +other.date[i]
         return sgn unless sgn == 0
      end if @date

      (0...@time.size).each do |i|
         sgn = +@time[i] <=> +other.time[i]
         return sgn unless sgn == 0
      end if @time

      return 0
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

    # 加算
    #
    # @param [When::TM::PeriodDuration] other
    # @param [その他] other 日時とみなす
    #
    # @return [WWhen::TM::PeriodDuration] (other が When::TM::PeriodDuration の場合)
    # @return [other と同じクラス] (other がその他の場合)
    #
    def +(other)
      other.kind_of?(When::TM::PeriodDuration) ? _plus(other, +1) : other + self
    end

    # 減算
    #
    # @param [When::TM::PeriodDuration] other
    #
    # @return [When::TM::PeriodDuration]
    #
    def -(other)
      _plus(other, -1)
    end

    # 乗算
    #
    # @param [Numeric] times
    #
    # @return [When::TM::PeriodDuration]
    #
    def *(times)
      period = self.dup
      period.send(:date=, @date.map {|v| v *= times; v.to_i==v.to_f ? v.to_i : v}) if @date
      period.send(:week=, @week.map {|v| v *= times; v.to_i==v.to_f ? v.to_i : v}) if @week
      period.send(:time=, @time.map {|v| v *= times; v.to_i==v.to_f ? v.to_i : v}) if @time
      period.send(:_duration)
      return period
    end

    # 除算
    #
    # @param [Numeric] divisor
    #
    # @return [When::TM::PeriodDuration]
    #
    def /(divisor)
      self * (1.0 / divisor)
    end

    # 文字列化
    #
    # @return [String]
    #
    def to_s
      period = 'P'
      if @week
        period += @week[0].abs.to_s + 'W'
        period += @week[1].abs.to_s + 'D' unless @week[1] == 0
      elsif @date
        (-@date.length..-1).each do |i|
          period += @date[i].abs.to_s + PRECISION_NAME[i+1][0..0] unless @date[i] == 0
        end
      end
      if @time
        period += 'T'
        (1..@time.length-1).each do |i|
          period += @time[i].abs.to_s + PRECISION_NAME[i][0..0] unless @time[i] == 0
        end
      end
      period = '-' + period if sign < 0
      period == 'P' ? 'P0D' : period
    end

    #
    # When::TM::PeriodDuration への変換
    #
    #   単なるオブジェクトのコピー
    #
    # @return [When::TM::PeriodDuration]
    #
    def to_period_duration
      self.dup
    end

    # オブジェクトの生成
    #
    # @overload initialize(date=nil, time=nil, week=nil)
    #   @param [Array<Numeric>] date 期間の日付要素
    #   @param [Array<Numeric>] time 期間の時刻要素
    #   @param [Array<Numeric>] week 期間の週日要素
    #
    # @overload initialize(value, index, range=YEAR..SECOND)
    #   @param [Numeric] value ndex に対応する桁での)時間間隔
    #   @param [Numeric] index When で定義している分解能定数(YEAR, ... ,SECOND)
    #   @param [Range] range 生成する桁の範囲
    #
    def initialize(*args)
      @options = (args[-1].kind_of?(Hash)) ? (args.pop.reject {|key,value| value == nil}) : {}
      if args[0].kind_of?(Numeric)
        _initialize_by_unit(*args)
      else
        @date, @time, @week = args
      end
      _duration
    end

    private

    #
    # 引数パターン2での初期化
    #
    def _initialize_by_unit(value, index, range=YEAR..SECOND)
      max   = range.first
      min   = range.last
      min  += 1 if (range.exclude_end?)
      if (index < max)
        if (index > MONTH)
          max    = index.floor
        else
          value *= 10**(max-index)
          index  = max
        end
      elsif (index > min)
        if (index <= DAY)
          min    = index.ceil
        else
          value *= 0.1**(index-min)
          index  = min
        end
      end
      value = value.to_i unless value.kind_of?(Pair) || value.to_i != value.to_f
      @date = Array.new(1-max, 0) if (max <= DAY) && (index <= DAY)
      @time = Array.new(1+min, 0) if (min >  DAY) && (index  > DAY)
      if (index == WEEK)
        @week    = [value, 0]
        @date[DAY-1] = 7 * value
      elsif (index <= DAY)
        @date[index-1] = value
      else
        @time[index]   = value
      end
    end

    #
    # 属性 @duration の計算
    #
    def _duration
      @duration = @sign = nil

      if @time
        @duration  = +@time[HOUR  ] * Duration::HOUR
        @duration += +@time[MINUTE] * Duration::MINUTE if @time[MINUTE]
        @duration += +@time[SECOND] * Duration::SECOND if @time[SECOND]
      end

      if @week
        @duration = +@week[0] * Duration::WEEK + +@week[1] * Duration::DAY + (@duration||0)

      elsif @date
        date = @date.dup
        date.shift while date.first == 0
        case date.size
        when 0 ; @duration ||= 0
        when 1 ; @duration   = +@date[DAY-1] * Duration::DAY + (@duration||0)
        else   ; @duration   = nil
        end
      end

      if @duration
        length  = @duration / Duration::DAY
        @to_day = length.to_i if length.to_i == length.to_f
      else
        extend NoDuration
      end
    end

    # 加減算共通処理
    #
    # @param [When::TM::PeriodDuration] other
    # @param [Numeric] sgn +1, -1
    #
    # @return [When::TM::PeriodDuration]
    #
    def _plus(other, sgn)
      unless (@week && @week.size) == (other.week && other.week.size) &&
             (@date && @date.size) == (other.date && other.date.size) &&
             (@time && @time.size) == (other.time && other.time.size)
        raise ArgumentError, "PeriodDuration structure mismatch"
      end
      period = self.dup
      period.send(:week=, (0...@week.size).to_a.map {|i| @week[i] + sgn * other.week[i]}) if @week
      period.send(:date=, (0...@date.size).to_a.map {|i| @date[i] + sgn * other.date[i]}) if @date
      period.send(:time=, (0...@time.size).to_a.map {|i| @time[i] + sgn * other.time[i]}) if @time
      period.send(:_duration)
      return period
    end
  end
end
