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
  # 任意個の端点から構成する [Range] の subclass
  #
  class GeometricComplex < Range

    include Comparable

    # 範囲の反転
    # @return [Boolean]
    #   [ true  - 反転する   ]
    #   [ false - 反転しない ]
    #
    # @note
    #   無限の過去(-Infinity)を範囲に含むか否かと同値である
    #
    attr_reader :reverse

    #
    # When::Parts::GeometricComplex を構成する端点の Array
    #
    # @return [Array<Array<Comparable, Boolean>>]
    #   -  Comparable - 端点
    #   -  Boolean
    #        @reverse == true の場合
    #          true  - 範囲に含まない
    #          false - 範囲に含む
    #        @reverse == false の場合
    #          true  - 範囲に含む
    #          false - 範囲に含まない
    #
    # @example +[[3,true],[4,false]] は Range(3+...4)に対応する
    #
    attr_reader :node

    # 最小の端点
    #
    # @param [Comparable] default 端点が-∞の場合に返すべき値(指定がなければ nil)
    #
    # @return [Comparable] 最小の端点
    #
    # @note
    #   含むか否かに関わらず、最小の端点を返す。
    #   default が指定されているが有効な区間がない場合、nil を返す。
    #
    def first(default=nil)
      return (@node.length==0) ? nil : @node[0][0] unless default # 互換性
      if reverse
        return default
      else
        (@node.length==0) ? nil : @node[0][0]
      end
    end
    alias :begin :first

    # 最大の端点
    #
    # @param [Comparable] default 端点が+∞場合に返すべき値(指定がなければ nil)
    #
    # @return [Comparable] 最大の端点
    #
    # @note
    #   含むか否かに関わらず、最大の端点を返す
    #   default が指定されているが有効な区間がない場合、nil を返す
    #
    def last(default=nil)
      return (@node.length==0) ? nil : @node[-1][0] unless default # 互換性
      if reverse
        return (@node.length[0]==0) ? default : @node[-1][0]
      else
        return nil if (@node.length==0)
        return (@node.length[0]==1) ? default : @node[-1][0]
      end
    end
    alias :end :last

    # 端点が範囲に含まれるか?
    #
    # @param [Integer] index 端点の番号(デフォルト : -1 - 最大の端点)
    #
    # @return [Boolean]
    #   [ true  - 含まれる   ]
    #   [ false - 含まれない ]
    #
    def exclude_end?(index=-1)
      (@node.length==0) ? nil : !@node[index][1] ^ @reverse
    end

    # 分解能
    #
    # @return [Integer] 最小の端点の分解能を返す
    #
    # @note
    #   分解能がない場合は、When::SYSTEM を返す
    #
    def precision
      @node[0] && @node[0][0].respond_to?(:precision) ? @node[0][0].precision : Coordinates::SYSTEM
    end

    # 範囲を反転する
    #
    # @return [When::Parts::GeometricComplex]
    #
    def -@
      GeometricComplex.new(self, true)
    end

    # 最小の端点と other を比較する
    #
    # @param [Comparable] other 比較対象
    #
    # @return [Integer] 比較結果を 負, 0, 正の値で返す
    #
    def <=>(other)
      first <=> other
    end

    # 和集合
    #
    # @param [Range, When::Parts::GeometricComplex] other
    #
    # @return [When::Parts::GeometricComplex] self と other の和集合を返す
    #
    def |(other)
      other = GeometricComplex.new(other) unless other.kind_of?(GeometricComplex)
      return self if self.reverse && self.node.length==0
      return other | self if !self.reverse && other.reverse
      copy = self.node.dup
      ref  = other.node.dup
      max  = _max(copy.shift.dup, ref.shift.dup) if (other.reverse)
      rev  = max ? false : @reverse
      while (ref.length > 0) do
        first, last, *ref = ref
        updated  = _upper(copy, first, rev)
        updated += _lower(copy, last, rev) if last
        copy = updated
      end
      copy = _lower(copy, max, true) if max
      return GeometricComplex.new(copy, self.reverse)
    end

    # ISO19108 の TM オブジェクトに変換する
    #
    # @param [Hash] options When::TM::TemporalPosition の生成を行う場合に使用する
    #   (see {When::TM::TemporalPosition._instance})
    #
    # @return [When::TM::Node, When::TM::Edge, When::TM::TopologicalComplex]
    #
    def to_tm_object(options={})
      return nil unless !@reverse && @node.length>0 && @node.length[0]==0
      objects    = []
      primitives = @node.dup
      while (primitives) do
        first, last, primitives = primitives
        if (first[0].eql?(last[0]))
          objects = When::TM::Node.new(When::TM::Instant.new(When.when?(first[0],options)))
        else
          objects = When::TM::Edge.new(When::TM::Node.new(When::TM::Instant.new(When.when?(first[0],options))),
                                       When::TM::Node.new(When::TM::Instant.new(When.when?(last[0],options))))
        end
      end
      return objects[0] if objects.length==1
      return When::TM::TopologicalComplex.new(objects)
    end

    # 範囲に含まれるか?
    #
    # @param [Comparable] other 判断する Comparable
    #
    # @return [Boolean]
    #   [ true  - 範囲に含まれる   ]
    #   [ false - 範囲に含まれない ]
    #
    # @note 制限事項
    #   When::TM::TopologicalComplex どうしの包含判定は、和集合がもとの範囲と等しいか
    #   で判断している。分解能が When::SYSTEM でない場合、論理的には等しいものが、
    #   内部表現が異なるために等しくないとみなされる事があり、その場合 true であるべき
    #   ものを false と誤判断する。実行速度上の制約もあり、現時点では対策しない。
    #
    def include?(other)
      if (other.kind_of?(Comparable) && !other.kind_of?(GeometricComplex))
        return (_include_point?(other) != false)
      else
        other = GeometricComplex.new(other) unless other.kind_of?(GeometricComplex)
        return _include_range?(other)
      end
    end
    alias :=== :include?

    # Enumerator._exclude 専用
    # @private
    def _include?(other)
      if (other.kind_of?(Comparable) && !other.kind_of?(GeometricComplex))
        return _include_point?(other)
      else
        other = GeometricComplex.new(other) unless other.kind_of?(GeometricComplex)
        return _include_range?(other) && _include_point?(other.first)
      end
    end

    # オブジェクトの生成
    #
    # @overload initialize(range, reverse=false)
    #   @param [Range] range
    #
    # @overload initialize(point, reverse=false)
    #   range = Range(point..point) と同じ
    #   @param [Comparable] point 
    #
    # @overload initialize(first, last, reverse=false)
    #   range = Range(first...last) と同じ
    #   @param [Comparable] first
    #   @param [Comparable] last
    #
    # @overload initialize(first, duration, reverse=false)
    #   range = Range(first...(first+duration)) と同じ
    #   @param [Comparable] first
    #   @param [When::TM::Duration] duration
    #
    # @overload initialize(other, reverse=false)
    #   もとの When::Parts::GeometricComplex のコピー
    #   @param [When::Parts::GeometricComplex] other  
    #
    # @overload initialize(node, reverse=false)
    #   指定した node 構造の When::Parts::GeometricComplex を生成
    #   @param [Array<Array<Comparable, Boolean>>] note
    #     - Comparable - 端点
    #     - Boolean
    #         @reverse == true の場合
    #           true  - 範囲に含まない
    #           false - 範囲に含む
    #         @reverse == false の場合
    #           true  - 範囲に含む
    #           false - 範囲に含まない
    # @note
    #   すべての呼び出しパターンに共通の最終引数 reverse を付けることができる
    #     reverse [Boolean]
    #       true  - 反転する
    #       false - 反転しない
    #
    def initialize(*args)

      @reverse = (args[-1]==true || args[-1]==false) ? args.pop : false

      case args[0]
      when GeometricComplex
        @node     = args[0].node
        @reverse ^= args[0].reverse
        super(self.first, self.last, exclude_end?) if self.first && self.last
        return

      when Array
        @node = args[0]
        super(self.first, self.last, exclude_end?) if self.first && self.last
        return

      when Range
        first = [args[0].first, true]
        last  = [args[0].last, !args[0].exclude_end?]

      when Comparable
        first, last, rest = args
        raise ArgumentError, "Too many argument: #{rest}" if rest
        first = [first, true]
        case last
        when Comparable         ; last = [last, false]
        when When::TM::Duration ; last = [first[0] + last, false]
        when nil                ; last = first
        else ; raise TypeError, "Irregal GeometricComplex Type for last element: #{last.class}"
        end

      when nil ;
      else ; raise TypeError, "Irregal GeometricComplex Type: #{first.class}"
      end

      first, last = last, first if (first && last && first[0] > last[0])
      @node = []
      @node << first if first
      @node << last  if last
      super(self.first, self.last, exclude_end?) if first && last
    end

    private

    def _include_range?(other)
      union = self | other
      return false unless self.node == union.node
      return self.reverse == union.reverse
    end

    def _include_point?(other)
      @node.each_index do |i|
        current = @node[i]
        verify  = other <=> current[0]
        if (verify < 0)
          return false if ((i[0]==0) ^ @reverse)
          return @node[[0,i-1].max][0]
        elsif (verify == 0)
          return false unless (@reverse ^ current[1])
          return current[0]
        end
      end
      return  (@reverse ? nil : false) if @node.length==0
      return false if ((@node.length[0]==0) ^ @reverse)
      return @node[-1][0]
    end

    def _upper(node, point, reverse)
      node  = node.dup
      point = point.dup
      point[1] = !point[1] if reverse
      node.each_index do |i|
        if (_verify(point, node[i], reverse) <= 0)
          node[i..-1] = ((i[0]==0) ^ reverse) ? [point] : []
          return node
        end
      end
      node.push(point) if (node.length[0]==0) ^ @everse
      return node
    end

    def _lower(node, point, reverse)
      node  = node.dup
      point = point.dup
      point[1] = !point[1] if reverse
      (node.length-1).downto(0) do |i|
        if (_verify(point, node[i], reverse) >= 0)
          node[0..i] = ((i[0]==1) ^ reverse) ? [point] : []
          return node
        end
      end
      node.unshift(point) if (node.length[0]==0) ^ reverse
      return node
    end

    def _verify(point, node, reverse)
      verify = point[0] <=> node[0]
      return verify unless verify == 0
      if point[0].respond_to?(:precision) && node[0].respond_to?(:precision)
        point[0] = node[0] if point[0].precision >= node[0].precision
      end
      if reverse
        point[1] &= node[1]
      else
        point[1] |= node[1]
      end
      return verify
    end

    def _max(p1, p2)
      p1[1] = !p1[1]
      p2[1] = !p2[1]
      verify = p1[0] <=> p2[0]
      return p1 if (verify>0)
      return p2 if (verify<0)
      p1[1] |= p2[1]
      return p1
    end

    # その他のメソッド
    #   When::Parts::GeometricComplex で定義されていないメソッドは
    #   処理を first (type: When::TM::(Temporal)Position) に委譲する
    #
    def method_missing(name, *args, &block)
      self.class.module_eval %Q{
        def #{name}(*args, &block)
          first.send("#{name}", *args, &block)
        end
      } unless When::Parts::MethodCash.escape(name)
      first.send(name, *args, &block)
    end
  end
end
