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
  # Resource which has 'International Resource Identifier'
  #
  module Resource

    # 登録済み Prefix
    Prefix = {'_w'   => When::SourceURI + '/',
              '_p'   => When::SourceURI + 'Parts/',
              '_b'   => When::SourceURI + 'BasicTypes/',
              '_m'   => When::SourceURI + 'BasicTypes/M17n/',
              '_co'  => When::SourceURI + 'Coordinates/',
              '_l'   => When::SourceURI + 'Coordinates/Spatial?',
              '_v'   => When::SourceURI + 'V/',
              '_rs'  => When::SourceURI + 'RS/',
              '_ex'  => When::SourceURI + 'EX/',
              '_tm'  => When::SourceURI + 'TM/',
              '_e'   => When::SourceURI + 'TM/CalendarEra/',
              '_t'   => When::SourceURI + 'TimeStandard/',
              '_ep'  => When::SourceURI + 'Ephemeris/',
              '_c'   => When::SourceURI + 'CalendarTypes/',
              '_n'   => When::SourceURI + 'CalendarTypes/CalendarNote/',
              '_sc'  => When::SourceURI + 'Ephemeris/V50/'
    }

    # @private
    PrefixKeys    = Prefix.keys.sort.reverse.map {|k| k.downcase}

    # @private
    PrefixValues  = Prefix.values.sort.reverse

    # @private
    PrefixIndex   = Prefix.invert

    # @private
    LabelProperty = nil

    # @private
    class Element
      attr_reader :predicate
      attr_reader :object
      attr_reader :attribute
      attr_accessor :namespace
      attr_reader :marked

      def initialize(key, object=nil, marked=nil)
        key = key.downcase.gsub(/-/,'_') if (key==key.upcase)
        @predicate, @namespace = key.split(/:/).reverse
        @object    = object
        @marked    = marked
        @attribute = {}
      end
    end

    # @private
    module Synchronize

      # 排他実行
      #
      #   与えられたブロックを必要なら排他制御をして実行する
      #
      def synchronize
        if @_lock_
          @_lock_.synchronize do
            yield
          end
        else
          yield
        end
      end
    end

    #
    # Resource の has-a 親子関係を管理する
    #
    module Pool

      include Synchronize

      # 初期化
      # @return [void]
      def _setup_
        @_lock_ = Mutex.new if When.multi_thread
        @_lock_.lock if @_lock_
        @_pool  = {}
        @_lock_.unlock if @_lock_
      end

      # オブジェクト参照
      #
      # @param [String] label
      #
      # @return [When::Parts::Resource] 指定した label で登録した子 Resource を返す
      #
      def [](label)

        # nil label
        return _pool[label] unless label

        # 階層構造の確認
        unless label =~ /\?/
          terms = label.split(/::/)
          terms.shift if terms[0] == ''
          return terms.inject(self) {|obj,term| obj = obj[term]} if terms.length >= 2
        end

        # 階層がない場合
        path, options = label.split(/\?/, 2)
        label  = Resource._extract_prefix(path)
        label += '?' + options if options
        _pool[label.gsub(/%3A%3A/, '::')]
      end

      # オブジェクト登録
      #
      # 指定した label で子 Resource を登録する
      #
      # @param [String] label
      # @param [When::Parts::Resource] obj
      #
      # @return [void]
      #
      def []=(label, obj)
        # raise NameError, "Name duplication" if (@_pool[label])
        _pool[label] = obj
      end

      # @private
      def pool_keys
        _pool.keys
      end

      # @private
      def _pool
        _setup_ unless @_pool
        @_pool
      end
    end

    class << self

      include Pool

      # オブジェクト生成&参照
      #
      # 指定した iri の When::Parts::Resource オブジェクトを取得する。
      # 当該オブジェクトが未登録であれば生成する。
      #
      # @param [String] iri International Resource Identifier
      # @param [String] namespace (デフォルトの名前空間, 指定がないときは名前空間を省略しない)
      #
      # @return [When::Parts::Resource]
      #
      def _instance(iri, namespace=nil)
        # 配列は個別に処理
        return iri.map {|e| _instance(e, namespace)} if iri.kind_of?(Array)

        # 文字列以外はそのまま返す
        return iri unless iri.instance_of?(String)

        # 階層がある場合は、階層をたどる
        iri = namespace + iri if namespace && iri !~ /^[_a-z\d]+:[^:]/i
        root, *leaves= iri.split(/::/)
        return leaves.inject(_instance(root)) {|obj,leaf| obj[leaf]} unless leaves==[] || iri =~ /\?/

        # 登録ずみなら、参照
        path, query = _extract_prefix(iri).split(/\?/, 2)
        iri      = query ? (path + '?' + query) : path
        if When.multi_thread
          my_mutex = nil
          @_lock_.synchronize do
            @_pool ||= {}
            unless @_pool[iri]
              my_mutex    = Mutex.new
              @_pool[iri] = my_mutex
            end
          end
          case @_pool[iri]
          when my_mutex; my_mutex.synchronize    {_create_object(iri, path, query) }
          when Mutex   ; @_pool[iri].synchronize { @_pool[iri] }
          else         ; @_pool[iri]
          end
        else
          @_pool ||= {}
          @_pool[iri] ? @_pool[iri] : _create_object(iri, path, query)
        end
      end

      # @private
      def _path_with_prefix(obj, simple=true)
        path = obj.kind_of?(Class) ? obj.to_s.sub(/^When::/, When::SourceURI).gsub(/::/, '/') :
                                     obj.iri
        return path unless simple
        PrefixValues.each do |value|
          index = path.index(value)
          return PrefixIndex[value] + ':' + path[value.length..-1] if index
        end
        return path
      end

      # @private
      def _parse(line, type=nil)
        return line unless line.kind_of?(String)
        line.sub!(/\s#.*$/, '')
        return Locale._split($1) if type && line =~ /^#{type}:(.+)$/i
        return Locale._split(line) unless line =~ /^(\*)?([A-Z][-A-Z_]{0,255})(?:;(.*?))?:(.*)$/i

        marked, key, property, value = $~[1..4]
        element = Element.new(key, value, marked)
        if (property)
          element.attribute['.'] = property+':'+value
          property.split(/;/) do |pr|
            prop = Element.new(*pr.split(/=/, 2))
            element.attribute[prop.predicate] = prop
          end
        else
          element.attribute['.'] = value
        end
        return element
      end

      # @private
      def _extract_prefix(path, capitalize=false)
        if (path =~ /^(.+?):+(.+)$/)
          prefix, klass = $~[1..2]
          if capitalize
            prefix = '_' + prefix.downcase
            klass  = klass.capitalize if klass == klass.upcase
          end
          path = Prefix[prefix] + klass if (Prefix[prefix])
        elsif capitalize && path =~ /^(v[^\/]+|daylight$|standard$)/i
          klass = path.sub(/^v/i, '').capitalize
          path  = Prefix['_v'] + klass if When::V.const_defined?(klass) &&
                                          When::V.const_get(klass).kind_of?(Class)
        end
        return path
      end

      private

      def _create_object(iri, path, query)
        options = {}
        replace = {}
        if query
          options = Hash[*query.split(/&/).map{ |pair| pair.split(/=/, 2) }.flatten]
          keys    = options.keys
          keys.each do |key|
            replace[$1] = options.delete(key) if key =~ /^!(.+)/
          end
        end
        options['..'] = iri

        obj  = nil
        list = _class(path)
        if list
          # direct URI
          case list[0]
          when Class
            obj = list[0].new(options)
          when Array
            if list[0][0].kind_of?(Class)
              # 配列の先頭がクラスである場合
              klass, *list = list[0]
              unless list[-1].kind_of?(Hash)
                if list.length == 1
                  list[0] = {'.'=>Array(list[0])}
                else
                  list << {}
                end
              end
            else
              # 配列の先頭がクラスではない場合
              klass, *list = [list[1], *list[0]]
              list << {} unless list[-1].kind_of?(Hash)
            end
            list[-1] = list[-1].merge(options)
            obj = klass.new(*list)
          else
            obj = list[0]
          end
        else
          # external Resource
          parsed = nil
          OpenURI
          begin
            open(path, "1".respond_to?(:force_encoding) ? 'r:utf-8' : 'r') do |file|
              resource = file.read
              replace.keys.each do |key|
                resource.gsub!(/#\{#{key}\}/, replace[key])
              end
              parsed = (resource[0..5]=='BEGIN:') ? _ics(resource.split(/[\n\r]+/)) :
                                                    _xml(REXML::Document.new(resource).root)
            end
          rescue OpenURI::HTTPError => error
            message = error.message + " - #{path}"
            error   = error.respond_to?(:uri) ?
                        error.class.new(message, error.io, error.uri) :
                        error.class.new(message, error.io)
            raise error
          end
          options['.'] = parsed
          obj = parsed[0].new(options)
        end
        @_pool[iri] = obj
      end

      def _class(path)
        return nil unless (path =~ /^http:\/\/hosi\.org\/When\/(.*)/)
        list  = [When]
        $1.split(/\//).each do |mod|
          if list[0].const_defined?(mod)
            list.unshift(list[0].const_get(mod))
          else
            return nil unless (list[0] == When::V)
            list.unshift(When::V::Root)
            return list
          end
        end
        return list
      end

      # .xml フォーマットの読み込み
      def _xml(xml, namespace={})
        obj = [_class(_extract_prefix(xml.attributes['type'].to_s))[0]]
        xml.attributes.each_pair do |key,value|
          expanded_name = value.expanded_name
          next unless (expanded_name =~ /^xmlns/)
          key = '' if expanded_name == 'xmlns'
          namespace[key] = value.to_s
        end
        obj << Element.new('xmlns:namespace', namespace) if (namespace.size>0)
        xml.each do |e|
          next unless defined? e.name
          if (e.attributes['type'])
            obj << _xml(e, namespace)
          else
            element = Element.new(e.expanded_name, e.attributes['ref']||e.text)
            e.attributes.each_pair do |key,value|
              attr = Element.new(value.name, value)
              attr.namespace = value.prefix
              element.attribute[key] = attr
            end
            obj << element
          end
        end
        return obj
      end

      # .ics フォーマットの読み込み
      def _ics(ics, type=nil)
        obj = [type] if type
        indent = nil
        while (line = ics.shift) do
          line.chomp!
          case line
          when /^\s*BEGIN:(.*)$/
            if (type)
              obj[-1] = _parse(obj[-1], type) if obj.length > 1
              obj << _ics(ics, $1)
            else
              type = $1
              obj  = [type]
            end
          when /^\s*END:(.*)$/
            raise TypeError, "Irregal Type : #{$1}" unless (type == $1)
            obj[0]  = _class(_extract_prefix(type, true))[0]
            obj[-1] = _parse(obj[-1], type)
            return obj
          when /^\s*#/
          when /^(\s*)(.*)$/
            indent  = $1 unless indent
            if (indent.length < $1.length)
              obj[-1] += line[(indent.length+1)..-1] # See RFC5545 3.1 Content Lines
            else
              obj << $2
              obj[-2]  = _parse(obj[-2], type)
            end
          end
        end
        raise ArgumentError, "BEGIN-END mismatch"
      end
    end

    include Synchronize

    # @private
    attr_reader :_pool

    # self が has-a 関係で包含するオブジェクト
    #
    # @return [Array<When::Parts::Resource>]
    #
    attr_reader :child

    #
    # Resource包含階層で使用する namespace
    #
    #   When::BasicTypes::M17n の生成に使用する namespace を定義する。
    #   RFC 5545 に対する拡張である。
    #   xml で記述する場合には、本ライブラリ以外でも namespace を定義している。
    #
    # @return [Hash] { prefix => prefix文字列 }
    #
    attr_reader :namespace

    #
    # Resource包含階層で使用する locale
    #
    #   When::BasicTypes::M17n の生成に使用する locale を定義する。
    #   RFC 5545 に対する拡張である。
    #
    # @return [Array<String>]
    #
    attr_reader :locale

    # strftime で有効な locale
    #
    # @return [Array<String>]
    #
    attr_reader :keys

    # オブジェクトの IRI
    #
    #  @return [Sring]
    #
    def iri
      return @iri if @iri
      root = @_pool['..']
      path = root.instance_of?(String) ? root : label.to_s
      path = path.gsub(/::/, '%3A%3A')
      if root.respond_to?(:iri)
        prefix = root.iri
        path = prefix + '::' + path if prefix
      end
      @iri = path
    end

    # IRI または child の番号によるオブジェクト参照
    #
    # @param [String]  iri オブジェクトの IRI
    # @param [Numeric] iri child の index
    #
    # @return [When::parts::Resource]
    #
    def [](iri)
      case iri
      when Numeric
        return child[iri * 1]
      when String
        obj = self
        iri.split(/::/).each do |label|
          return obj.child if label == '*'
          if obj == Resource
            obj = Resource._instance(label)
          else
            case label
            when ''  ; obj = Resource
            when '.' # obj = obj
            else     ; obj = obj._pool[label.gsub(/%3A%3A/, '::')]
            end
          end
          raise ArgumentError, "IRI not found: #{iri}" unless obj
        end
        return obj
      else
        super(iri)
        #raise ArgumentError, "IRI not found: #{iri}"
      end
    end

    # self を直接に包含するオブジェクト
    #
    # @return [When::Parts::Resource]
    #
    def parent
      @_pool['..'].kind_of?(Resource) ? @_pool['..'] : nil
    end

    # self を包含するオブジェクト階層
    #
    # @param [Class] klass 階層を遡るクラス
    #
    # @return [When::Parts::Resource]
    #
    def hierarchy(klass=self.class)
      hierarchy = []
      parent    = self
      while parent.kind_of?(klass)
        hierarchy << parent
        parent = parent.parent
      end
      hierarchy.reverse
    end

    # self が other を包含するか
    #
    # @return [Boolean]
    #   [ true  - 包含する   ]
    #   [ false - 包含しない ]
    #
    def include?(other)
      c = other
      while c.kind_of?(Resource)
        return true if c.equal?(self)
        c = c.parent
      end
      return false
    end

    # other が self を包含するか
    #
    # @return [Boolean]
    #   [ true  - 包含される   ]
    #   [ false - 包含されない ]
    #
    def included?(other)
      other.include?(self)
    end

    # 前のオブジェクト
    #
    # @return [When::Parts::Resource]
    #
    def prev
      c = self
      c = c.child[0] while c.child && c.child.size > 0
      c = c._pool['.<-']
      c = c.child[-1] while c && c.child && c.child.size > 0
      c
    end

    # 次のオブジェクト
    #
    # @return [When::Parts::Resource]
    #
    def next
      c = self
      c = c.child[0] while c.child && c.child.size > 0
      c._pool['.->']
    end
    alias :succ :next

    # オブジェクト包含階層の末端か?
    #
    # @return [Boolean]
    #   [ true  - IRIが付与された他のオブジェクトを包含していない ]
    #   [ false - IRIが付与された他のオブジェクトを包含している   ]
    #
    def leaf?
      !@child || (@child.length==0)
    end

    # IRIが付与されているか?
    #
    # @return [Boolean]
    #   [ true  - IRIが付与されている   ]
    #   [ false - IRIが付与されていない ]
    #
    def registered?
      leaf = self
      while leaf._pool['..'].respond_to?(:_pool)
        root = leaf._pool['..']
        return false unless leaf.equal?(root._pool[leaf.label])
        leaf = root
      end
      Resource._pool.value?(leaf)
    end

    # When::BasicTypes::M17n の生成/参照
    #
    # @param [When::BasicTypes::M17n] source 処理を行わず、そのままsourceを返す
    # @param [String] source locale と 文字列の対応
    # @param [Array]  source 要素を個別に解釈して生成したオブジェクトのArrayを返す
    # @param [Hash]   namespace prefix の指定
    # @param [Array]  locale    locale の定義順序の指定
    # @param [Hash]   options (see {When::BasicTypes::M17n.new}[link:When/BasicTypes/M17n.html#method-c-new])
    #
    # @return [When::BasicTypes::M17n or Array<them>]
    #
    def m17n(source, namespace=nil, locale=nil, options={})
      case source
      when Array                  ; When::BasicTypes::M17n.new(source, namespace, locale, options)
      when When::BasicTypes::M17n ; source
      when String
        return self[$1] if source =~ /^\s*\[((\.{1,2}|::)+[^\]]+)\]/
        When::BasicTypes::M17n.new(source, namespace, locale, options)
      else ; raise TypeError, "Invalid Type: #{source.class}"
      end
    end

    # オブジェクトを順に取り出す enumerator
    #
    #   @param [Symbol] direction 取り出す方向
    #     [ :forward - 昇順 ]
    #     [ :reverse - 降順 ]
    #
    def enum_for(direction=:forward)
      Enumerator.new(self, direction)
    end
    alias :to_enum :enum_for

    # Enumerator 生成のダミー
    #
    # @param [Object] other
    #
    # @return [Enumerator]
    #
    def ^(other)
      return nil
    end

    # 順次実行
    #
    # @param [Array] args  各サブクラスの enum_for にそのまま渡す
    # @param [Block] block 実行するブロック
    #
    # @return [Enumerator]
    #
    def each(*args, &block)
      enum = enum_for(*args)
      return enum unless block
      enum.each(&block)
    end

    # map, collect の再定義
    #
    # has-a 関係の子 Resource に対して map/collect を行う
    #
    # @param [Block] block 実行するブロック
    #
    # @return [Array]
    #
    def map(&block)
      @child.map(&block)
    end
    alias :collect :map

    protected

    # @private
    def pool_keys
      _pool.keys
    end

    private

    # 属性の設定
    def _attributes(args)
      options =_get_options(args)
      _set_variables(options)
      return args, options
    end

    # option の読み出し
    def _get_options(args)
      options = args[-1].kind_of?(Hash) ? args.pop : {}
      @_pool  = {}
      @_pool['..'] = options['..'] if (options['..'])

      # 配下のオブジェクトの生成と関連付け
      if (options.key?('.'))
        _child(options)
      end

      options
    end

    # 変数の設定
    def _set_variables(options)
      @options = options[:options] || {} if options.key?(:options)
      options.each_pair do |key,value|
        unless (key =~ /^options$|^[_.]/)
          # スキームの":"がエンコーディングされていたら、valueをデコード
          if (value =~ /^\w+%3A/i)
            value.gsub!(/%[0-9A-F]{2}/i) do |c|
              c.sub(/%/,'0x').hex.chr
            end
          end
          case "#{key}"
          when 'namespace' ; value = Locale._namespace(value)
          when 'locale'    ; value = Locale._locale(value)
          end
          instance_variable_set("@#{key}", value)
        end
      end
    end

    # 配下のオブジェクトの生成
    def _child(options)
      @child = []
      query = options.dup
      options['..'] = self
      leaf = options['.']
      label_candidates = nil

      leaf.each_index do |i|
        element = Resource._parse(leaf[i])
        case element
        when Array
          if element[0].kind_of?(Class)
            list = []
            element.each do |e|
              if e.kind_of?(Hash)
                list += e.keys.map {|key| Resource::Element.new(key, e[key])}
              else
                list << e
              end
            end
            options['.'] = list
            @child << element[0].new(options.dup)
          else
            options.delete('.')
            @child << self.class.new(*(element + [options]))
          end

        when Resource::Element
          key   = element.predicate
          value = element.object
          if (value)
            case key
            when 'namespace'
              options[key] ||= {}
              options[key] = options[key].merge(Locale._namespace(value))
            when 'locale'
              options[key] = Locale._locale(value)
            else
              if (value.instance_of?(String) && value =~ /^\[/)
                options.delete('.')
                value  = m17n(value, nil, nil, options.dup)
                @_pool[value.to_s] = value
              end
              if element.marked || key == self.class::LabelProperty
                @label = value
              else
                options[key] = value
                label_candidates ||= value
              end
            end
          else
            options.delete(key)
          end
        end
      end
      options.update(query)
      unless @label
        raise ArgumentError, "label attribute not found: #{leaf}" unless label_candidates
        @label = label_candidates
      end
    end

    # 配下のオブジェクトの前後関係の設定
    def _sequence
      return unless @child
      prev = @_pool['..'].child[-1] if @_pool['..'].respond_to?(:child)
      @child.each do |v|
        if prev
          v._pool['.<-'] = prev
          prev._pool['.->'] = v
          while (prev.child && prev.child[-1]) do
            prev = prev.child[-1]
            prev._pool['.->'] = v
          end
        end
        @_pool[v.label.to_s] = v
        prev = v
      end
    end

    # その他のメソッド
    #   When::Parts::GeometricComplex で定義されていないメソッドは
    #   処理を @child (type: Array) に委譲する
    #
    def method_missing(name, *args, &block)
      @child.send(name.to_sym, *args, &block)
    end

    #
    # オブジェクトを順に取り出す enumerator
    #
    class Enumerator < When::Parts::Enumerator

      #
      # 次のオブジェクトを取り出す
      #
      # @return [When::Parts::Resource]
      #
      def succ
        value = @current
        @current = (@current==:first) ? @first : ((@direction == :reverse) ? @current.prev : @current.next)
        @current = nil unless @first.leaf? || @first.include?(@current)
        return value
      end
    end
  end
end
