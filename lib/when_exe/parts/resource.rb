# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2021 Takashi SUGA

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

    include When::Namespace

    # @private
    LabelProperty = nil

    # @private
    ConstTypes = {
      'SolarTerms'  => ['CalendarNote',     '%sSolarTerms',  '_n:%sSolarTerms%s' ],
      'LunarPhases' => ['LunarPhases',      '%sLunarPhases', '_n:%sLunarPhases%s'],
      'Terms'       => ['BasicTypes::M17n', '%s',            '_m:%s%s'           ],
      'Era'         => ['TM::CalendarEra',  '%s',            '_e:%s%s'           ],
      'Residue'     => ['Coordinates',      '%s',            '_co:%s%s'          ],
      'Week'        => ['CalendarNote',     '%sWeek',        '_n:%sWeek%s'       ],
      'Note'        => ['CalendarNote',     '%s',            '_n:%s%s'           ],
      'Notes'       => ['CalendarNote',     '%s',            '_n:%s/Notes%s'     ],
      nil           => ['CalendarTypes',    '%s',            '_c:%s%s'           ]
    }

    # @private
    ConstList = []

    # @private
    IRIHeader = /\A[_a-z\d]+:[^:]/i

    # @private
    IRIEncodeTable = {'#'=>'%23', '<'=>'%3C', '>'=>'%3E', '{'=>'%7B', '}'=>'%7D'}

    # @private
    IRIDecodeTable = IRIEncodeTable.invert

    # @private
    IRIEncode = /[#{IRIEncodeTable.keys.join('')}]/

    # @private
    IRIDecode = /#{IRIDecodeTable.keys.join('|')}/i

    # @private
    class ContentLine

      RFC6350 = {
        "\\\\" => "\\",
        "\\n"  => "\n",
        "\\N"  => "\n",
        "\\;"  => ";",
        "\\:"  => ":"
      }

      RFC6868 = {
        "^n"  => "\n",
        "^^"  => "^",
        "^'"  => '"'
      }

      attr_reader   :predicate
      attr_accessor :object
      attr_reader   :attribute
      attr_accessor :namespace
      attr_accessor :same_altid
      attr_reader   :marked

      def initialize(key, object=nil, marked=nil)
        key = key.downcase.gsub(/-/,'_') if (key==key.upcase)
        @predicate, @namespace = key.split(/:/).reverse
        object     = object.gsub(/\^./) {|escape| RFC6868[escape] || escape} if object.instance_of?(String)
        @object    = object
        @marked    = marked
        @attribute = {}
      end

      #
      # 行から RFC5545 の Property を取り出す
      #
      # @private
      def self.extract_rfc5545_Property(specification, options)
        return specification unless specification =~ /\A[-A-Z_]+=.+?:/i
        caret = 0
        specification.length.times do |i|
          caret = specification[i..i] == '^' ? caret + 1 : 0
          if caret[0] == 0 && specification[i..i] == ':'
            specification[0...i].gsub(/\^./) {|escape| RFC6868[escape] || escape}.
              scan(/((?:[^\\;]|\\.)+)(?:;(?!\z))?|;/).flatten.each do |pr|
              pr ||= ''
              pr.gsub!(/\\./) {|escape| RFC6350[escape] || escape}
              key, value = pr.split(/=/, 2)
              case key
              when 'VALUE' ; options[:precision] = value
              when 'TZID'  ; options[:clock] = 
                case When::V::Timezone[value]
                when Array ; When::V::Timezone[value][-1]
                when nil   ; When::Parts::Timezone.new(value)
                else       ; When::V::Timezone[value]
                end
              else         ; options[key]    = value
              end
            end
            return specification[(i+1)..-1]
          end
        end
        return specification
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
      #
      # @note
      #   本メソッドでマルチスレッド対応の管理変数の初期化を行っている。
      #   このため、本メソッド自体はスレッドセーフでない。
      #
      def _setup_
        @_lock_ = Mutex.new if When.multi_thread
        @_pool  = {}
      end

      # オブジェクト参照
      #
      # @param [String] label
      #
      # @return [When::Parts::Resource] 指定した label で登録した子 Resource を返す
      #
      def [](label)

        # nil label の場合
        return _pool[label] unless label

        # 階層がある場合
        terms = Resource._encode(label).split(/::/)
        terms.shift if terms[0] == ''
        return terms.inject(self) {|obj,term| obj = obj[Resource._decode(term)]} if terms.length >= 2

        # 階層がない場合
        _pool[Resource._decode(Resource._extract_prefix(terms[0]))]
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

    module Navigation
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
    end

    class << self

      include Pool

      # Base URI for When_exe Resources
      #
      # @return [String]
      #
      def base_uri
        @base_uri ||= When::SourceURI
      end

      # Root Directory for When_exe Resources
      #
      # @return [String]
      #
      def root_dir
        @root_dir ||= When::RootDir
      end

      #
      # 略称を iri に変換する
      #
      # @param [String or Symbol] abbreviation 略称
      #
      # @return [String] iri or nil
      #
      # @private
      def _abbreviation_to_iri(abbreviation, abbreviation_types=ConstTypes)
        abbreviation_types[:pattern] ||= /\A(?=[A-Z])(.*?)(#{abbreviation_types.keys.compact.join('|')})?(\?.+|::.+)?\z/
        abbreviation.to_s =~ abbreviation_types[:pattern]
        return nil unless $1
        klass, name, iri = abbreviation_types[$2]
        key,   name, iri = $2, name % $1, iri % [$1,$3]
        if klass.kind_of?(String)
          klass = klass.split('::').inject(When) {|k,n| k.const_get(n)}
          abbreviation_types[key][0] = klass
        end
        klass.const_defined?(name) ? iri : nil
      end

      # @private
      attr_reader :_prefix, :_prefix_values, :_prefix_index
      private     :_prefix, :_prefix_values, :_prefix_index

      # 初期化
      #
      # @param [Hash] options 以下の通り
      # @option options [String]  :base_uri Base URI for When_exe Resources (Default When::SourceURI)
      # @option options [Hash<String(namespace)=>String(URI)>] :additional_namespaces User defined namespaces (Default {})
      # @option options [String]  :root_dir Root Directory for When_exe Resources Cash data (Default When::RootDir)
      # @option options [Boolean] :leave_const If true, leave Constants of When module defined
      #
      # @return [void]
      #
      # @note
      #   本メソッドでマルチスレッド対応の管理変数の初期化を行っている。
      #   このため、本メソッド自体はスレッドセーフでない。
      #
      def _setup_(options={})
        super()
        @_prefix = {
          '_wp'  => 'https://en.wikipedia.org/wiki/',
          '_w'   => base_uri + '/',
          '_p'   => base_uri + 'Parts/',
          '_b'   => base_uri + 'BasicTypes/',
          '_m'   => base_uri + 'BasicTypes/M17n/',
          '_co'  => base_uri + 'Coordinates/',
          '_l'   => base_uri + 'Coordinates/Spatial?',
          '_v'   => base_uri + 'V/',
          '_rs'  => base_uri + 'RS/',
          '_ex'  => base_uri + 'EX/',
          '_tm'  => base_uri + 'TM/',
          '_e'   => base_uri + 'TM/CalendarEra/',
          '_t'   => base_uri + 'TimeStandard/',
          '_ep'  => base_uri + 'Ephemeris/',
          '_c'   => base_uri + 'CalendarTypes/',
          '_n'   => base_uri + 'CalendarNote/',
          '_sc'  => base_uri + 'Ephemeris/V50/'
        }
        @base_uri       = options[:base_uri] || When::SourceURI
        @root_dir       = options[:root_dir] || When::RootDir
        @_prefix        = options[:additional_namespaces].merge(@_prefix) if options[:additional_namespaces].kind_of?(Hash)
        @_prefix_values = @_prefix.values.sort.reverse
        @_prefix_index  = @_prefix.invert
        unless options[:leave_const] || ConstList.empty?
          ConstList.delete_if do |constant|
            When.send(:remove_const, constant) if When.const_defined?(constant)
            true
          end
          When._define_common_calendar_types
        end
      end

      # 設定情報を取得する
      #
      # @return [Hash] 設定情報
      #
      def _setup_info
        {:base_uri => base_uri, :root_dir => root_dir}
      end

      # オブジェクト生成&参照
      #
      # 指定した iri の When::Parts::Resource オブジェクトを取得する。
      # 当該オブジェクトが未登録であれば生成する。
      #
      # @param [String] iri International Resource Identifier
      # @param [String] namespace (デフォルトの名前空間, 指定がないときは名前空間を省略しない)
      # @param [Block] block オブジェクトやパスが見つからない場合の代替処理
      #
      # @return [When::Parts::Resource]
      #
      def _instance(iri, namespace=nil, &block)
        _setup_ unless @_pool

        case iri
        when Array    ; return iri.map {|e| _instance(e, namespace)}                  # 配列は個別に処理
        when Resource ; return iri                                                    # 登録済みはそのまま
        when String   ;                                                               # 解析処理へ
        else          ; raise ArgumentError, "can't convert #{iri.class} to String"   # 例外
        end

        # 内部文字列化
        iri = When::EncodingConversion.to_internal_encoding(iri)

        # 階層がある場合は、階層をたどる
        iri = Resource._decode(iri)
        iri = $1 while iri =~ /\A\((.*)\)\z/
        iri = namespace + iri if namespace && iri !~ IRIHeader
        root, *leaves= Resource._encode(iri).split(/::/)
        if leaves.size > 0
          return leaves.inject(_instance(Resource._decode(root))) {|obj,leaf| obj[Resource._decode(leaf)]}
        end

        # 登録ずみなら、参照
        iri = _extract_prefix(iri)
        path, query = iri.split(/\?/, 2)
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
          when my_mutex
            my_mutex.synchronize do
              begin
                @_pool[iri] = _create_object(iri, path, query, &block)
              rescue => exception
                @_pool[iri] = nil
                raise exception
              end
            end
          when Mutex
            @_pool[iri].synchronize do
              @_pool[iri]
            end
          else
            @_pool[iri]
          end
        else
          @_pool      ||= {}
          @_pool[iri] ||= _create_object(iri, path, query, &block)
        end
      end

      # @private
      def _path_with_prefix(obj, simple=true)
        _setup_ unless @_pool
        path = obj.kind_of?(Class) ? obj.to_s.sub(/\AWhen::/, base_uri).gsub(/::/, '/') :
                                     obj.iri
        simple ? _simplify_path(path) : path
      end

      # @private
      def _simplify_path(path)
        _prefix_values.each do |value|
          index = path.index(value)
          return _prefix_index[value] + ':' + path[value.length..-1] if index
        end
        return path
      end

      # @private
      def _parse(line, type=nil)
        return line unless line.kind_of?(String)
        line.sub!(/\s#.*\z/, '')
        return When::Locale._split($1) if type && /\A#{type}:(.+)\z/i =~ line
        tokens = line.scan(/((?:[^\\:]|\\.)+)(?::(?!\z))?|:/).flatten
        return When::Locale._split(line) unless tokens.size > 1 && /\A(\*)?([A-Z][-A-Z_]{0,255})(?:;(.+))?\z/i =~ tokens[0]
        marked, key, property = $~[1..3]
        values = tokens[1..-1]
        value  = values.join(':') unless values == [nil]
        content = ContentLine.new(key, value, marked)
        value ||= ''
        if property
          content.attribute['.'] = property + ':' + value
          property.scan(/((?:[^\\;]|\\.)+)(?:;(?!\z))?|;/).flatten.each do |pr|
            pr ||= ''
            pr.gsub!(/\\./) {|escape| ContentLine::RFC6350[escape] || escape}
            prop = ContentLine.new(*pr.split(/=/, 2))
            content.attribute[prop.predicate] = prop
          end
        else
          content.attribute['.'] = value
        end
        return content
      end

      # @private
      def _extract_prefix(path, capitalize=false)
        if (path =~ /\A(.+?):+(.+)\z/)
          prefix, klass = $~[1..2]
          if capitalize
            prefix = '_' + prefix.downcase
            klass  = klass.capitalize if klass == klass.upcase
          end
          path = _prefix[prefix] + klass if _prefix[prefix]
        elsif capitalize && path =~ /\A(v[^\/]+|daylight$|standard$)/i
          klass = path.sub(/\Av/i, '').capitalize
          path  = _prefix['_v'] + klass if When::V.const_defined?(klass) &&
                                           When::V.const_get(klass).kind_of?(Class)
        end
        return path
      end

      # @private
      def _replace_tags(source, tags)
        case source
        when When::BasicTypes::M17n
          source
        when String
          target = source.dup
          tags.each_pair do |key, value|
            target.gsub!(/#\{([?&][^=#}]+?=)?#{key}(:.*?)?\}/, '\1' + value) if value.kind_of?(String)
          end
          target.gsub(/#\{.+?(:(.*?))?\}/, '\2')
        when Array
          source.map {|target| _replace_tags(target, tags)}
        when Hash
          target = {}
          source.each_pair do |key, value|
            target[key] = _replace_tags(tags[key] || value, tags)
          end
          target
        else
          source
        end
      end

      # @private
      def _encode(iri)
        return iri unless iri =~ /\(/

        iri = iri.dup
        begin
          unless iri.gsub!(/\([^()]*\)/) {|token|
            token.gsub(/[():?&%]/) {|char|'%' + char.ord.to_s(16)}
          }
            raise ArgumentError, 'Brackets do not correspond: ' + iri 
          end
        end while iri =~ /\(/
        iri
      end

      # @private
      def _decode(iri)
        iri = iri.gsub(When::Parts::Resource::IRIDecode) {|c| When::Parts::Resource::IRIDecodeTable[c.upcase]}
        return iri unless iri =~ /%28/

        begin
          unless iri.gsub!(/%28.*?%29/) {|token|
            token.gsub(/%([\dA-F]{2})/i) {$1.to_i(16).chr}
          }
            raise ArgumentError, 'Brackets do not correspond: ' + iri 
          end
        end while iri =~ /%28/
        iri = $1 if iri =~ /\A\((.*)\)\z/
        iri
      end

      # @private
      def _instantiate(resource)
        return resource unless resource.kind_of?(Array)
        return resource[0].new(*resource[1..-1]) if resource[0].kind_of?(Class)
        return resource.map {|rsc| _instantiate(rsc)}
      end

      private

      # オブジェクト生成
      def _create_object(iri, path, query, &block)
        # query analyzation
        options = {}
        replace = {}
        if query
          options = Hash[*Resource._encode(query).split(/&/).map{|pair|
            key, value = pair.split(/=/, 2)
            [key, Resource._decode(value)]
          }.flatten]
          keys    = options.keys
          keys.each do |key|
            replace[$1] = options.delete(key) if key =~ /\A([A-Z].*)/
          end
        end
        options['..'] = iri

        # internal Resource
        if path.index(Resource.base_uri) == 0
          list = _class(path)
          if list
            return _internal(list, replace, options)
          else
            object = yield(iri) if block_given?
            return object if object
            raise IOError, 'IRI not found - ' + path
          end
        end

        # external Resource
        begin
          object = When::Locale.send(:wikipedia_object, path, {:query=>query})
          return object if object
          OpenURI
          args  = [path, "1".respond_to?(:force_encoding) ? 'r:utf-8' : 'r']
          real_path = block_given? ? yield(path) : path
          raise IOError, path + ': not ready' unless real_path
          args  = [real_path, "1".respond_to?(:force_encoding) ? 'r:utf-8' : 'r']
          args << {:ssl_verify_mode=>OpenSSL::SSL::VERIFY_NONE} if real_path =~ /\Ahttps:/
          URI.send(:open,*args) do |file|
            resource = file.read
            case resource[0..5].upcase
            when 'BEGIN:'
              options['.'] = _ics(_replace_tags(resource, replace).split(/[\n\r]+/))
              options['.'][0].new(options)
            when '<?XML '
              options['.'] = _xml(REXML::Document.new(_replace_tags(resource, replace)).root)
              options['.'][0].new(options)
            when '# WHEN'
              klass, rows = _csv(resource)
              klass.new(path, rows, &block)
            else
              raise NoMethodError, 'JSON not supported' unless Object.const_defined?(:JSON)
              _internal(_json([JSON.parse(resource)]), replace, options)
            end
          end
        rescue OpenURI::HTTPError => error
          message = error.message + " - #{path}"
          error   = error.respond_to?(:uri) ?
                      error.class.new(message, error.io, error.uri) :
                      error.class.new(message, error.io)
          raise error
        end
      end

      # 指定のモジュール/クラスで直接定数が定義されているか
      if method(:const_defined?).arity == 1
        def _directry_defined?(klass, const)
          klass.const_defined?(const)
        end
      else
        def _directry_defined?(klass, const)
          klass.const_defined?(const, false)
        end
      end

      # 内部形式定義の取得
      def _class(path)
        list = [When]
        path[Resource.base_uri.length..-1].split(/\//).each do |mod|
          if list[0].kind_of?(Module) && _directry_defined?(list[0], mod)
            list.unshift(list[0].const_get(mod))
          else
            return nil unless list[0] == When::V
            list.unshift(When::V::Root)
            return list
          end
        end
        return list
      end

      # 内部形式定義のオブジェクト化
      def _internal(list, replace, options)
        case list[0]
        when Class
          list[0].new(options)
        when Array
          top = list[0][0]
          if top.kind_of?(Hash)
            top.each_pair do |key, value|
              replace.update(value[replace[key]]) if value.kind_of?(Hash) && value[replace[key]]
            end
            list[0] = list[0][1..-1]
            list[0] = _replace_tags(list[0], top.merge(replace))
          end
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
          klass.new(*list)
        else
          list[0]
        end
      end

      # .xml フォーマットの読み込み
      def _xml(xml, namespace={})
        obj = [_class(_extract_prefix(xml.attributes['type'].to_s))[0]]
        xml.attributes.each_pair do |key,value|
          expanded_name = value.expanded_name
          next unless (expanded_name =~ /\Axmlns/)
          key = '' if expanded_name == 'xmlns'
          namespace[key] = value.to_s
        end
        obj << ContentLine.new('xmlns:namespace', namespace) if (namespace.size>0)
        xml.each do |e|
          next unless defined? e.name
          if (e.attributes['type'])
            obj << _xml(e, namespace)
          else
            content = ContentLine.new(e.expanded_name, e.attributes['ref']||e.text)
            e.attributes.each_pair do |key,value|
              attr = ContentLine.new(value.name, value)
              attr.namespace = value.prefix
              content.attribute[key] = attr
            end
            obj << content
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
          when /\A\s*BEGIN:(.*)\z/
            if type
              subtype = $1
              obj[-1] = _parse(obj[-1], type) if obj.length > 1
              obj << _ics(ics, subtype)
            else
              type = $1
              obj  = [type]
            end
          when /\A\s*END:(.*)\z/
            raise TypeError, "Irregal Type : #{$1}" unless type == $1
            obj[0]  = _class(_extract_prefix(type, true))[0]
            obj[-1] = _parse(obj[-1], type)
            return obj
          when /\A\s*#/
          when /\A(\s*)(.*)\z/
            indent  = $1 unless indent
            if indent.length < $1.length
              obj[-1] += line[(indent.length+1)..-1] # See RFC5545 3.1 Content Lines
            else
              obj << $2
              obj[-2]  = _parse(obj[-2], type)
            end
          end
        end
        raise ArgumentError, "BEGIN-END mismatch"
      end

      # .json フォーマットの読み込み
      def _json(json)
        case json
        when Array
          json.map {|value| _json(value)}
        when Hash
          hash = {}
          json.each_pair {|key, value| hash[key] = _json(value)}
          hash
        when String
          return json unless json =~ /\AWhen::/
          begin
            return json.split('::').inject(Object) {|ns, sym| ns.const_get(sym)}
          rescue
            json
          end
        else
          json
        end
      end

      # .csv フォーマットの読み込み
      def _csv(csv)
        rows  = CSV.parse(csv)
        klass = rows.shift.first[2..-1].strip.split('::').inject(Object) {|ns, sym| ns.const_get(sym)}
        [klass, rows]
      end
    end

    include Synchronize

    # @private
    attr_reader :_pool

    # self が has-a 関係で包含するオブジェクト
    #
    # @return [Array<When::Parts::Resource>]
    #
    attr_accessor :child
    private :child=

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
    # @param [Boolean] prefix true ならIRI の先頭部分を簡約表現にする
    #
    # @return [Sring]
    #
    def iri(prefix=false)
      return nil unless @_pool
      unless @iri
        root = @_pool['..']
        path = root.instance_of?(String) ? root : label.to_s
        if root.respond_to?(:iri)
          root_iri = root.iri
          path = root_iri + '::' + path.gsub(/[<>]/) {|char|'%' + char.ord.to_s(16)} if root_iri
        end
        @iri = path
      end
      prefix ? Resource._simplify_path(@iri) : @iri
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
        Resource._encode(iri).split(/::/).each do |label|
          return obj.child if label == '*'
          if obj == Resource
            obj = Resource._instance(Resource._decode(label))
          else
            case label
            when ''  ; obj = Resource
            when '.' # obj = obj
            else     ; obj = obj._pool[Resource._decode(label)]
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
      while leaf._pool && leaf._pool['..'].respond_to?(:_pool)
        root = leaf._pool['..']
        return false unless leaf.equal?(root._pool[leaf.label])
        leaf = root
      end
      Resource._pool.values.map {|resource| resource.object_id}.include?(leaf.object_id)
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
        return self[$1] if source =~ /\A\s*\[((\.{1,2}|::)+[^\]]+)\]/
        When::BasicTypes::M17n.new(source, namespace, locale, options)
      else ; raise TypeError, "Invalid Type: #{source.class}"
      end
    end

    # 子オブジェクトを順に取り出す enumerator
    #
    def enum_for
      @child.enum_for
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
        unless (key =~ /\Aoptions$|^\.|^[A-Z]/)
          case "#{key}"
          when 'namespace' ; value = When::Locale._namespace(value)
          when 'locale'    ; value = When::Locale._locale(value)
          end
          instance_variable_set("@#{key}", value)
        end
      end
    end

    # 配下のオブジェクトの生成
    def _child(options)
      @child           = []
      query            = options.dup
      options['..']    = self
      leaves           = options.delete('.').map {|leaf| Resource._parse(leaf)}
      key_list         = []
      properties       = {}
      label_candidates = nil

      # ContentLine の処理(namespace, locale, altidの前処理)
      leaves.each do |content|
        next unless content.kind_of?(ContentLine)
        key   = content.predicate
        value = content.object
        next options.delete(key) unless value
        case key
        when 'namespace'
          options[key] ||= {}
          if content.attribute['altid']
            options[key][content.attribute['prefix'].object] = content.object
          else
            options[key] = options[key].update(When::Locale._namespace(value))
          end
        when 'locale'
          options[key] = When::Locale._locale(value)
        else
          _parse_altid(properties, content)
          key_list << key unless key_list.include?(key)
        end
      end

      # ContentLine の処理(一般)
      key_list.each do |key|
        content = properties[key][0]
        value   = content.same_altid ? When::BasicTypes::M17n.new(content, options['namespace'], []) : content.object
        value   = When::BasicTypes::M17n.new(value, nil, nil, options) if value.instance_of?(String) && value =~ /\A\s*\[/
        @_pool[value.to_s] = value if value.kind_of?(When::BasicTypes::M17n)
        if content.marked || key == self.class::LabelProperty
          @label = value
        else
          options[key] = value
          label_candidates ||= value
        end
      end

      # 代表ラベルの設定
      unless @label
        raise ArgumentError, "label attribute not found: #{options['.']}" unless label_candidates
        @label = label_candidates
      end

      # Array の処理(子オブジェクトの生成)
      leaves.each do |content|
        next unless content.kind_of?(Array)
        if content[0].kind_of?(Class)
          list = []
          content.each do |e|
            if e.kind_of?(Hash)
              list += e.keys.map {|key| Resource::ContentLine.new(key, e[key])}
            else
              list << e
            end
          end
          options['.'] = list
          @child << content[0].new(options.dup)
        else
          options.delete('.')
          @child << self.class.new(*(content + [options]))
        end
      end

      # options の更新
      options.update(query)
    end

    # ALTIDを持つ ContentLine の解析
    def _parse_altid(properties, content)
      key = content.predicate
      properties[key] ||= []
      if content.attribute['altid']
        found = false
        (0...properties[key].length).to_a.each do |i|
          prev = properties[key][i]
          if prev.attribute['altid'] && prev.attribute['altid'].object == content.attribute['altid'].object
            content.same_altid      = prev
            properties[key][i] = content
            found = true
            break
          end
        end
      end
      properties[key] << content unless found
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

    alias :__method_missing :method_missing

    # その他のメソッド
    #   When::Parts::Resource で定義されていないメソッドは
    #   処理を @child (type: Array) に委譲する
    #
    def method_missing(name, *args, &block)
      return __method_missing(name, *args, &block) if When::Parts::MethodCash::Escape.key?(name)
      self.class.module_eval %Q{
        def #{name}(*args, &block)
          @child.send("#{name}", *args, &block)
        end
      } unless When::Parts::MethodCash.escape(name)
      @child.send(name, *args, &block)
    end
  end
end
