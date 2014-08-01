# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

#
# 本ライブラリのための諸々の部品
#
module When::Parts

  #
  # v1.8.x のための互換性確保用
  #
  # @private
  class Enumerator < ::Enumerator  ; end if Object.const_defined?(:Enumerator)

  #
  # 本ライブラリ用の Enumerator の雛形
  #
  class Enumerator

    # @private
    def self._options(args)
      options  = args[-1].kind_of?(Hash) ? args.pop.dup : {}
      options[:exdate] =
        case options[:exdate]
        when GeometricComplex ; options[:exdate].dup
        when nil ; GeometricComplex.new()
        else ; GeometricComplex.new(options[:exdate])
        end
      return options
    end

    # 生成元オブジェクト
    # @return [Comparable]
    attr_reader :parent

    # オプション
    # @return [Hash]
    # @private
    attr_accessor :options
    protected :options=

    # 除外要素
    # @return [When::Parts::GeometricComplex]
    attr_accessor :exdate
    protected :exdate=

    # 処理済み要素
    # @return [When::Parts::GeometricComplex]
    attr_accessor :processed
    protected :processed=

    # 最初の要素
    # @return [Comparable]
    attr_accessor :first
    protected :first=

    # 最後の要素
    # @return [Comparable]
    attr_accessor :last
    protected :last=

    # 繰り返し方向
    # @return [Symbol]
    #   [ :forward - 昇順 ]
    #   [ :reverse - 降順 ]
    attr_reader :direction

    # 最大繰り返し回数
    # @return [Integer]
    attr_reader :count_limit

    # 現在の繰り返し回数
    # @return [Integer]
    attr_reader :count

    # 現在の要素
    # @return [Comparable]
    attr_accessor :current
    protected :current=

    # 現在のインデックス
    # @return [Integer]
    # @private
    attr_reader :index

    # with_object メソッドで渡すインスタンス
    # @return [Comparable]
    # @private
    attr_accessor :object
    protected :object=

    #
    # ブロックを評価する
    #
    # @return [rewind された self]
    #
    def each
      return self unless block_given?
      while (has_next?) do
        if @index
          yield(succ, @index)
          @index += 1
        elsif @object
          yield(succ, @object)
        else
          yield(succ)
        end
      end
      @index = @object = nil
      rewind
    end

    #
    # index をブロックに渡して評価する
    #
    # @param [Integer] offset index の初期値
    #
    # @return [When::Parts:Enumerator]
    #   [ ブロックあり - rewind された self ]
    #   [ ブロックなし - copy ]
    #
    def with_index(offset=0, &block)
      if block_given?
        @index = offset||@count
        return each(block)
      else
        copy = _copy
        copy.object = nil
        copy.index  = offset||@count
        return copy
      end
    end

    #
    # index をブロックに渡して評価する
    #
    # @param [Comparable] object ブロックに渡す Object
    #
    # @return [When::Parts:Enumerator]
    #   [ ブロックあり - rewind された self ]
    #   [ ブロックなし - copy ]
    #
    def with_object(object, &block)
      if block_given?
        @object = object
        each(block)
        return object
      else
        copy = _copy
        copy.object = object
        copy.index  = nil
        return copy
      end
    end

    #
    # 巻き戻す
    #
    # @return [rewind された self]
    #
    def _rewind
      @processed = @exdate.dup
      @count     = 0
      @current   = :first
      succ
      self
    end
    alias :rewind :_rewind

    #
    # 次の要素があるか?
    #
    # @return [Boolean]
    #   [ true  - ある ]
    #   [ false - ない ]
    #
    def has_next?
      return (@current != nil)
    end

    #
    # 次の要素を取り出す
    #
    # @return [Comparable] 次の要素
    # @raise [StopIteration] 次の要素がない場合 rewind して例外を発生
    #
    def next
      return succ if has_next?
      rewind
      raise StopIteration, "Iteration Stopped"
    end

    #
    # 次の要素を取り出す
    #
    # @return [Comparable]
    #   [ 次の要素あり - 次の要素 ]
    #   [ 次の要素なし - nil ]
    #
    # @note
    #   次の要素がない場合 rewind や、StopIteration例外発生は行わない
    #
    def succ
      value = @current
      if (@count_limit.kind_of?(Numeric) && @count >= @count_limit)
        @current = nil
      else
        loop do
          @current = _succ
          break unless (@current)
          next if (@current == :next)
          @current = GeometricComplex.new(@current, @duration) if @duration
          next if _exclude(@current)
          case @direction
          when :reverse
            next if (@current > @first)
            @current = nil if (@last && @current < @last)
            break
          else
            next if (@current < @first)
            @current = nil if (@last && @current > @last)
            break
          end
        end
        @count += 1
        _exclude(@current) if (@current)
      end
      return value
    end

    # オブジェクトの生成
    #
    # @overload initialize(parent, range, count_limit=nil)
    #   @param [Comparable] parent 生成元
    #   @param [Range, When::Parts::GeometricComplex] range
    #     [ 始点 - range.first ]
    #     [ 終点 - range.last  ]
    #   @param [Integer] count_limit 繰り返し回数(デフォルトは指定なし)
    #
    # @overload initialize(parent, first, direction, count_limit=nil)
    #   @param [Comparable] parent 生成元
    #   @param [When::TM::TemporalPosition] first 始点
    #   @param [Symbol] direction (options[:direction]で渡してもよい)
    #     [ :forward - 昇順 ]
    #     [ :reverse - 降順 ]
    #   @param [Integer] count_limit 繰り返し回数(デフォルトは指定なし, options[:count_limit]で渡してもよい)
    #
    def initialize(*args)
      @options = self.class._options(args)
      @exdate  = @options.delete(:exdate)
      @exevent = @options.delete(:exevent)
      @parent, *rest = args
      _range(rest)
      _rewind
    end

    private

    def _range(rest)
      if (rest[0].instance_of?(Range))
        range, @count_limit, others = rest
        raise ArgumentError, "Too many arguments" if others
        @first   = When.when?(range.first)
        @last    = When.when?(range.last)
        @exdate |= @last if (range.exclude_end?)
        if (@first > @last)
          @first, @last = @last, @first
          @direction = :reverse
        else
          @direction = :forward
        end
      else
        @first, @direction, @count_limit, others = rest
        raise ArgumentError, "Too many arguments" if others
        raise ArgumentError, "Too few arguments"  unless @first
        @direction ||= :forward
        @last        = nil
      end
      @count_limit = @options[:count_limit] if @options[:count_limit] && (!@count_limit || @count_limit > @options[:count_limit])
      @options.delete(:count_limit)
      @direction   = @options[:direction] if @options[:direction]
      @options.delete(:direction)
    end

    def _exclude(value)
      if @exevent
        @exevent.each do |ev|
          return true if ev.include?(value)
        end
      end
      previous    = @processed._include?(value)
      @processed |= value if previous == false
      registered  = (previous==value) ? previous : value
      registered  = registered.first if registered.kind_of?(GeometricComplex)
      registered.events ||=[]
      registered.events << self.parent
      registered.events.uniq!
      return previous != false
    end

    def _copy
      copy = dup
      copy.options   = @options.dup   if @options
      copy.exdate    = @exdate.dup    if @exdate
      copy.exevent   = @exevent.dup   if @exevent
      copy.processed = @processed.dup if @processed
      copy.first     = @first.dup     if @first
      copy.last      = @last.dup      if @last
      copy.current   = @current.dup   if @current.respond_to?(:dup)
      copy.object    = @object.dup    if @object.respond_to?(:dup)
      return copy
    end

    #
    # 時間位置の Array を順に取り出す Enumerator
    #
    class Array < Enumerator

      # 整列して、重複した候補を削除
      #
      # @param [Array] list 
      # @param [Symbol] direction
      #   [ :forward - 昇順 ]
      #   [ :reverse - 降順 ]
      #
      # @return [Array]
      # @note
      #   eql? はオーバーライドしない
      #
      def self._sort(list, direction)
        list = list.sort
        prev = nil
        list.delete_if do |x|
          if (x == prev)
            true
          else
            prev = x
            false
          end
        end
        list.reverse! if (direction == :reverse)
        return list
      end

      # 初期リスト
      # @return [Array]
      # @private
      attr_accessor :initial_list
      protected :initial_list=

      # 現在リスト
      # @return [Array]
      # @private
      attr_accessor :current_list
      protected :current_list=

      #
      # 巻き戻す
      #
      # @return [rewind された self]
      # @private
      def _rewind
        @current_list = @initial_list.dup
        super
      end

      # オブジェクトの生成
      #
      # @overload initialize(parent, list, count_limit=nil))
      #   @param [Comparable] parent 生成元
      #   @param [Array<When::TM::TemporalPosition>] list 順に取り出す時間位置の Array
      #   @param [Symbol] direction
      #     [ :forward - 昇順 ]
      #     [ :reverse - 降順 ]
      #   @param [Integer] count_limit 繰り返し回数(デフォルトは指定なし)
      #
      def initialize(*args)
        parent, list, direction, *args = args
        raise ArgumentError, "Too few arguments" unless list
        @initial_list = self.class._sort(list, direction||:forward)
        super(parent, @initial_list[0], direction, *args)
      end

      private

      def _succ
        return @current_list.shift
      end

      def _copy
        copy = super
        copy.initial_list = @initial_list.dup
        copy.current_list = @current_list.dup
        return copy
      end
    end

    #
    # 複数の下位 Enumerator の結果を順に取り出す Enumerator
    #
    class Integrated < Enumerator

      #
      # 下位 Enumerator
      #
      # @return [Array<When::Parts::Enumerator>]
      #
      attr_accessor :enumerators
      protected :enumerators=

      #
      # 巻き戻す
      #
      # @return [rewind された self]
      #
      def rewind
        @enumerators.each do |enum|
          enum._rewind
        end
        super
      end

      # オブジェクトの生成
      #
      # @overload initialize(parent, enumerators, first, count_limit=nil))
      #   @param [Comparable] parent 生成元
      #   @param [Array<When::Parts::Enumerator>] list 順に取り出す下位 Enumeratorの Array
      #   @param [When::TM::TemporalPosition] first 始点
      #   @param [Symbol] direction
      #     [ :forward - 昇順 ]
      #     [ :reverse - 降順 ]
      #   @param [Integer] count_limit 繰り返し回数(デフォルトは指定なし)
      #
      def initialize(*args)
        parent, @enumerators, *rest = args
        raise ArgumentError, "Too few arguments" unless @enumerators.kind_of?(::Array)
        super(parent, *rest)
      end

      private

      def _copy
        copy = super
        copy.enumerators = @enumerators.map {|e| e._copy}
        return copy
      end

      def _succ
        current  = nil
        selected = nil
        @enumerators.each_index do |i|
          value = @enumerators[i].current
          next unless (value)
          if (current)
            verify = current <=> value
            case @direction
            when :reverse ; next if (verify > 0)
            else          ; next if (verify < 0)
            end
            if (verify == 0)
              next if current.kind_of?(GeometricComplex) && current.include?(value)
              #next if current.precision <= value.precision # TODO
            end
          end
          current  = value
          selected = i
        end
        @enumerators[selected].succ if (selected)
        return current
      end
    end
  end
end
