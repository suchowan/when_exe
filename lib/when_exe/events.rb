# -*- coding: utf-8 -*-
=begin
    Copyright (C) 2015-2016 Takashi SUGA

    You may use and/or modify this file according to the license
    described in the LICENSE.txt file included in this archive.
=end

require 'when_exe/namespace'
require 'when_exe/tmduration'

module When

  #
  # 時間座標を持つイベント記録の管理
  #
  module Events

    #
    # イベント管理用範囲オブジェクト
    #
    class Range < ::Range

      # 実数のための exclude_end? 判定用マージン
      #
      Delta = When::TM::Duration::SECOND / 4096.0 / When::TM::Duration::DAY

      # 小さい方の境界
      #
      # @return [Object]
      #
      attr_reader :start

      # 大きい方の境界
      #
      # @return [Object]
      #
      attr_reader :until

      # オリジナル文字列
      #
      # @return [String]
      #
      attr_accessor :original
      private :original=

      # オブジェクトを When::Events::Range 型に変換する
      #
      # @param [Object] source 変換元のオブジェクト
      #
      # @return [When::Events::Range] 変換結果
      #
      def self.convert_from(source)
        case
        when source.kind_of?(self)             ; source
        when source.respond_to?(:exclude_end?) ; new(source, source.last, source.exclude_end?)
        when source.respond_to?(:succ)         ; new(source, source.succ, true)
        else raise ArgumentError, "Can't convert #{source} to #{self}"
        end
      end

      # 範囲の重なりの判断が複雑になるか？
      #
      # @return [Boolean] true - 複雑, false - 単純
      #
      def is_complex?
        case @start
        when Array, Enumerator ; true
        else                   ; false
        end
      end

      # 指定オブジェクトが範囲内か？
      #
      # @param [Object] target 判定するオブジェクト
      #
      # @return [Boolean] true - 範囲内のオブジェクトあり, false - 範囲内のオブジェクトなし
      #
      def include?(target)
        !include(target).empty?
      end

      # 含む対象の抽出
      #
      # @param [Object] target 判定するオブジェクト
      #
      # @return [Array<Object>] 実際に包含した範囲オブジェクトの Array
      #
      def include(target)
        return [] if (exclude_end? && @until <= target) || (!exclude_end? && @until < target)

        case @start
        when ::Range
          return @start.include?(target) ? [@start] : []

        when Array
          list = []
          @start.each do |range|
            break if _range_exceeded?(range, target)
            list << range if _target_included?(range, target)
          end
          return list

        when Enumerator
          begin
            list = []
            while (range = @start.succ)
              break if _range_exceeded?(range, target)
              list << range if _target_included?(range, target)
            end
            return list
          ensure
            @start._rewind
          end
 
        else
          return @start <= target ? [@start] : []
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
        !overlaped(range).empty?
      end

      #
      # 範囲が重なる対象の抽出
      #
      # @param [Range] target 確認対象の単純範囲オブジェクト
      #
      # @return [Array<Object>] 実際に重なった範囲オブジェクトの Array
      #
      def overlaped(target)
        first = target.first
        last  = target.last
        last  = last.respond_to?(:prev) ? last.prev : last - Delta if target.exclude_end?
        return [] if (exclude_end? && @until <= first) || (!exclude_end? && @until < first)

        case @start
        when ::Range
          return _target_exceeded?(@start, first) || _range_exceeded?(@start, last) ? [] : [@start]

        when Array
          list = []
          @start.each do |range|
            break if _range_exceeded?(range, last)
            list << range unless _target_exceeded?(range, first)
          end
          return list

        when Enumerator
          begin
            list = []
            while (range = @start.succ)
              break if _range_exceeded?(range, last)
              list << range unless _target_exceeded?(range, first)
            end
            return list
          ensure
            @start._rewind
          end
 
        else
          return @start <= last ? [@start] : []
        end
      end

      #
      # イベント管理用範囲オブジェクトの生成
      #
      # @param [Object] first 小さい方の境界
      # @param [Object] last 大きい方の境界
      # @param [Boolean] exclude_end 大きい方の境界を含まないか？
      #
      def initialize(first, last, exclude_end=false)
        @start = first
        @until = last
        range  = [first, last].map {|edge| edge.respond_to?(:first) ? edge.first : edge}
        rase ArgumentError, "#{range.last} is less than #{range.first}" if range.last < range.first
        super(range.first, range.last, exclude_end)
      end

      private

      # target が小さすぎるか？
      def _range_exceeded?(range, target)
        focused = range.respond_to?(:first) ? range.first : range
        return true if  exclude_end? && @until <= focused
        return true if !exclude_end? && @until <  focused
        target < focused
      end

      # target が大きすぎるか？
      def _target_exceeded?(range, target)
        return false if target == (range.respond_to?(:first) ? range.first : range)
        return target >= range.succ unless range.respond_to?(:last)
        return target >= range.last if range.exclude_end?
        return target >  range.last
      end

      # target が含まれるか？
      def _target_included?(range, target)
        range.respond_to?(:include?) ? range.include?(target) : (range == target)
      end
    end

    if When.const_defined?(:Parts)

      #
      # 多言語対応データセット群
      #
      #   言語ごとに異なるデータセットを保持する
      #
      class DataSets

        include When::Parts::Resource

        # 名前
        #
        # @return [When::BasicTypes::M17n]
        #
        attr_reader :label

        # 各言語用のデータセットの Hash
        #
        # @return [Hash<String=>When::Events::DataSet>]
        #
        attr_reader :datasets

        # 単言語データセットオブジェクトの取得
        #
        # @param [String] language 言語コード
        # @param [Numeric] limit オブジェクト生成待ち時間 / 秒
        # @param [Boolean] limit false - 待たない, true - 無限に待つ
        #
        # @return [When::Events::DataSet]
        #
        def dataset(language='', limit=true)
          if When.multi_thread
            joined =
              case limit
              when Numeric   ; @thread.join(limit)
              when nil,false ; true
              else           ; @thread.join
              end
            return nil unless joined
          end
          return nil unless @datasets
          When::Locale._hash_value(@datasets, language)
        end

        # 多言語対応 namespace の取得
        #
        # @param [String] prefix プレフィクス
        # @param [String] language 言語コード
        #
        # @return [Array<String(namespace), String(説明)>]
        #
        def namespace(prefix, language)
          When::Locale._hash_value(@prefixes[prefix], language)
        end

        #
        # 指定の Event を主語とする Statement からなる RDF:Repository を生成する
        #
        # @param [Array<When::Events::Event>] events 登録する Event の Array
        #
        # @return [Hash<String(GraphURI)=>RDF:Repository>] 生成した Repository の Hash
        #
        def repository(events=nil)
          repositories = {}
          @datasets.each_pair do |language, dataset|
            repositories[language] = dataset.repository(events)
          end
          _merge_each_graph(repositories)
        end

        #
        # 指定の URI を主語とする Statement からなる RDF:Repository を生成する
        #
        # @param [String] uri 主語の URI
        # @param [Integer] uri 主語のイベントの通し番号
        # @param [String] graph 検索対象のグラフ(ダミー)
        #
        # @return [Hash<String(GraphURI)=>RDF:Repository>] 生成した Repository の Hash
        #
        def event(uri, graph=nil)
          repositories = {}
          @datasets.each_pair do |language, dataset|
            repositories[language] = dataset.event(uri, graph)
          end
          _merge_each_graph(repositories)
        end

        #
        # RDF::URI リソースで使用された prefix - namespace 対
        #
        # @return [Hash<String(prefix)=>String(namespace)>]
        #
        def used_ns
          pair = {}
          @datasets.each_value do |dataset|
            pair.update(dataset.used_ns)
          end
          pair
        end

        #
        # graph ごとに repository を merge する
        #
        def _merge_each_graph(repositories)
          merged = {}
          repositories.keys.inject([]) {|graphs,language| (graphs | repositories[language].keys) }.each do |graph|
            repository_for_graph = ::RDF::Repository.new
            repositories.each_value do |repository|
              repository_for_graph << repository[graph] if repository.key?(graph)
            end
            merged[graph] = repository_for_graph
          end
          merged
        end
        private :_merge_each_graph

        # 多言語対応データセットオブジェクトの生成
        #
        # @param [String] uri データセット定義の所在
        # @param [Array<Array<String>>] rows 多言語対応データセット定義
        # @param [Block] block キャッシュされたファイルパスの読み替え処理
        #
        def initialize(uri, rows, &block)

          # 定義行を言語ごとに仕分けする
          definitions = {}
          @prefixes   = {}
          labels   = nil
          datasets = nil
          (0...rows.size).to_a.reverse.each do |index|
            items = rows[index].map {|item| item.strip}
            prefix, namespace, word = items
            if /\A(.+?):@\*\z/ =~ prefix
              rows[index..index] = prefix_wildcard($1, namespace, word)
            else
              rows[index] = items
            end
          end
          rows.each do |row|
            next if row.first =~ /\A\s*#/
            name, language= row.shift.split('@', 2)
            language    ||= ''
            language.sub!('_', '-')
            if definitions.key?(name)
              if language == ''
                definitions[name].values.each do |definition|
                  definition << row
                end
              else
                definitions[name][language] << row
              end
            else
              definitions[name] = Hash.new {|hash,key| hash[key]=[]}.merge({''=>[row]})
              definitions[name][language] << row unless language == ''
            end
            case extract(name)
            when LABEL       ; labels        = filter_for_dataset(definitions[name])
            when REFERENCE   ; datasets      = filter_for_dataset(definitions[name])
            when /\A(.+?):\z/; @prefixes[$1] = filter_for_dataset(definitions[name], true)
            end
          end

          # 名前オブジェクトを生成する
          @label = When::BasicTypes::M17n.new({
            'label'=>labels[''].first,
            'names'=>Hash[*(labels.keys.map   {|label|   [label,   labels[label].first    ]}).flatten],
            'link' =>Hash[*(datasets.keys.map {|dataset| [dataset, datasets[dataset].first]}).flatten]
          })
          @_pool = {'..'=>uri, '.'=>rows, @label.to_s=>@label}
          @child             = [@label]
          @label._pool['..'] = self

          # 各言語用のデータセットオブジェクトを生成する
          if When.multi_thread
            @thread = Thread.new do
              begin
                @datasets = create_datasets(datasets, uri, definitions, &block)
              rescue => exception
                puts exception
              # puts exception.backtrace
                raise exception
              end
            end
          else
            @datasets = create_datasets(datasets, uri, definitions, &block)
          end
        end

        private

        # 言語ごとのデータセットを登録する
        def create_datasets(datasets, uri, definitions, &block)
          Hash[*(datasets.keys.map {|language|
            lines = []
            definitions.each_pair do |name, definition|
              lang = When::Locale._hash_key(definition, language)
              definition[lang].each do |defs|
                lines << [[name] + defs, lang]
              end
            end
            [language, DataSet.new(lines, language, uri, self, &block)]
          }).flatten]
        end

        # 名前空間のワイルドカードを展開する
        def prefix_wildcard(prefix, namespace, word)
          hash = When.Wikipedia(word).to_h
          hash[:names].keys.map {|loc|
            next nil unless /./ =~ loc
            ["#{prefix}_#{loc}:@#{loc}", namespace.sub('*',loc), hash[:names][loc]]
          }.compact
        end

        # データセット用の設定を選択する
        def filter_for_dataset(target, filter=false)
          hash = {}
          target.each_pair do |language, definitions|
            definitions.each do |definition|
              if filter || DataSet.for_dataset?(definition.first)
                hash[language] = definition
                break
              end
            end
          end
          hash
        end

        # プレフィクスを名前空間に展開する
        def extract(predicate)
          return predicate unless /\A\{(.+?):(.+)\}\z/ =~ predicate && @prefixes.key?($1)
          prefix, body = $~[1..2]
          namespace = @prefixes[prefix].values.first.first
          namespace = namespace.sub(/([a-z0-9])\z/i, '\1#')
          namespace + body
        end
      end

      # When.exe Time Schema
      TS = When::Parts::Resource.base_uri.sub(/When\/$/, 'ts#')

    else

      # When.exe Time Schema - TS may not equal When::Resource.base_uri.sub(/When\/$/, 'ts#')
      TS = 'http://hosi.org/ts#'

    end

    # Time Schema
    TT          = TS.sub(/#\z/,'/')
    RANGE       = TT + Range.class.to_s.gsub('::','/')
    ID          = TS + 'id'
    IRI         = TS + 'IRI'
    REFERENCE   = TS + 'reference'
    GROUP       = TS + 'group'
    WHAT_DAY    = TS + 'whatDay'
    START       = TS + 'start'
    UNTIL       = TS + 'until'
    WEST        = TS + 'west'
    EAST        = TS + 'east'
    SOUTH       = TS + 'south'
    NORTH       = TS + 'north'
    BOTTOM      = TS + 'bottom'
    TOP         = TS + 'top'

    # XML Schema Definition
    INTEGER     = Namespace::XSD  + '#integer'
    FLOAT       = Namespace::XSD  + '#float'
    DOUBLE      = Namespace::XSD  + '#double'
    STRING      = Namespace::XSD  + '#string'
    DATE        = Namespace::XSD  + '#date'
    TIME        = Namespace::XSD  + '#time'
    DATETIME    = Namespace::XSD  + '#dateTime'

    # Resource Description Framework
    TYPE        = Namespace::RDF  + 'type'
    SUBJECT     = Namespace::RDF  + 'subject'
    LABEL       = Namespace::RDFS + 'label'
    GRAPH       = Namespace::RDFC + 'section-rdf-graph'

    # Dublin Core
    SOURCE      = Namespace::DC   + 'source'
    CONTRIBUTOR = Namespace::DC   + 'contributor'
    LICENSE     = Namespace::DCQ  + 'license'
    VALID       = Namespace::DCQ  + 'valid'
    ABSTRACT    = Namespace::DCQ  + 'abstract'
    HAS_PART    = Namespace::DCQ  + 'hasPart'
    SPATIAL     = Namespace::DCQ  + 'spatial'
    URI         = Namespace::DCQ  + 'URI'

    # For Dataset
    ForDataset  = [LABEL, REFERENCE, CONTRIBUTOR, LICENSE]

    # Index
    EqualIndex  = [SUBJECT, GRAPH, GROUP, CONTRIBUTOR, SPATIAL]
    FirstEdge   = {'valid'=>START, 'longitude'=>WEST, 'latitude'=>SOUTH, 'altitude'=>BOTTOM}
    LastEdge    = {'valid'=>UNTIL, 'longitude'=>EAST, 'latitude'=>NORTH, 'altitude'=>TOP   }

    # 同値インデクスの判断
    #
    # @param [String] predicate 述語
    #
    # @return [Symbol] :equal 作成する, nil 作成しない
    #
    def self.equal(predicate)
      EqualIndex.include?(predicate) ?
        :equal :
        nil
    end

    # 境界インデクスの判断
    #
    # @param [String] predicate 述語
    #
    # @return [Symbol] :first 下限境界, :last 上限境界, nil どちらでもなし
    #
    def self.edge(predicate)
      FirstEdge.values.include?(predicate) ?
        :first :
      LastEdge.values.include?(predicate) ?
        :last  :
        nil
    end

    # 出現回数の限定
    #
    # @param [String] predicate 述語
    #
    # @return [Boolean] true 1回限定, false 限定なし
    #
    def self.cardinality1(predicate)
      predicate != HAS_PART
    end

    #
    # 一言語対応データセット
    #
    #   特定の言語用データセットを保持する
    #
    class DataSet

      #
      # オブジェクト操作定義
      #

      # 何もしない
      nooperation  = proc {|event, obj|
        obj
      }

      # 名前空間の展開
      to_uri       = proc {|event, obj|
        event.dataset.extract(obj)
      }

      # 整数化
      to_i         = proc {|event, obj|
        obj.to_i
      }

      # 実数化
      to_f         = proc {|event, obj|
        obj.to_f
      }

      # 下限整数化
      first_to_i   = proc {|event, obj|
        obj.respond_to?(:first) ?
          obj.first.to_i :
          obj.to_i
      }

      # 下限実数化
      first_to_f   = proc {|event, obj|
        obj.respond_to?(:first) ?
          obj.first.to_f :
          obj.to_f
      }

      # 上限整数化
      last_to_i    = proc {|event, obj|
        !obj.respond_to?(:last) ?
          obj.succ.to_i - 1 :
        obj.exclude_end? ?
          obj.last.to_i - 1 :
          obj.last.succ.to_i - 1
      }

      # 上限実数化
      last_to_f    =  proc {|event, obj|
        !obj.respond_to?(:last) ?
          obj.to_f :
        obj.exclude_end? ?
          obj.last.to_f - Range::Delta :
        obj.last.respond_to?(:succ) ?
          obj.last.succ.to_f - Range::Delta :
          obj.last.to_f
      }

      # 日時範囲化
      to_range     = proc {|event, date|
        target = When.when?(date, :parse=>When::Locale::EasternParser)
        target = Range.convert_from(target) if target.kind_of?(Array) || target.kind_of?(Enumerator)
        target.send(:original=, date) if target.kind_of?(Range)
        target
      }

      # 日付化
      to_date      = proc {|event, date|
        Date.parse(date)
      }

      # 時刻化
      to_time      = proc {|event, time|
        Time.parse(time)
      }

      # 日時化
      to_date_time = proc {|event, date_time|
        DateTime.parse(date_time)
      }

      # 経度
      to_long      = proc {|event, location|
        location.kind_of?(Numeric) ? location :
        When.where?(location).long
      }

      # 緯度
      to_lat       = proc {|event, location|
        location.kind_of?(Numeric) ? location :
        When.where?(location).lat
      }

      # 高度
      to_alt       = proc {|event, location|
        location.kind_of?(Numeric) ? location :
        When.where?(location).alt
      }

      #
      # オブジェクト操作対応付け
      #
      Operations = Hash.new(nooperation).merge({
        URI               => to_uri,
        IRI               => to_uri,
        INTEGER           => to_i,
        FLOAT             => to_f,
        DOUBLE            => to_f,
        [:first, INTEGER] => first_to_i,
        [:first, FLOAT  ] => first_to_f,
        [:first, DOUBLE ] => first_to_f,
        [:last,  INTEGER] => last_to_i,
        [:last,  FLOAT  ] => last_to_f,
        [:last,  DOUBLE ] => last_to_f,
        RANGE             => to_range,
        DATE              => to_date,
        TIME              => to_time,
        DATETIME          => to_date_time,

        WEST              => to_long,
        EAST              => to_long,
        SOUTH             => to_lat,
        NORTH             => to_lat,
        BOTTOM            => to_alt,
        TOP               => to_alt
      })

      #
      # 自身の言語
      #
      # @return [String]
      #
      attr_reader :language

      #
      # 所属する多言語対応データセット
      #
      # @return [When::Events::DataSets]
      #
      attr_reader :parent

      #
      # 定義行の元情報
      #
      # @return [Array<String>]
      #
      attr_reader :definitions

      #
      # 時間座標を持つイベント
      #
      # @return [When::Events::Event]
      #
      attr_reader :events

      #
      # デフォルト Graph の URI
      #
      # @return [String(URI)]
      #
      attr_reader :default_graph

      #
      # 名前空間
      #
      # @return [Hash<String(prefix)=>String(namespace)>]
      #
      attr_reader :prefix

      #
      # 名前空間の説明
      #
      # @return [Array<Array<String(namespace), String(description)>>]
      #
      attr_reader :prefix_description

      #
      # ロール変数の定義
      #
      # @return [Hash<String(prefix:name)=>Hash>]
      #
      attr_reader :role

      #
      # RDF変数の定義
      #
      # @return [Hash<String(prefix:name)=>Hash>]
      #
      attr_reader :rdf

      #
      # CSV変数の定義
      #
      # @return [Hash<String(prefix:name)=>Hash>]
      #
      attr_reader :csv

      #
      # 一致キーのためのインデクス
      #
      # @return [Hash<String(prefix:name)=>Hash<String(key)=>Array>>]
      #
      attr_reader :index

      #
      # 順序キーのためのインデクス
      #
      # @return [Hash<String(prefix:name)=>Array>]
      #
      attr_reader :order

      #
      # データセットで使用しているRDF::URI リソース
      #
      # @return [Hash<String(iri)=>::RDF::URI>]
      #
      attr_reader :resource

      #
      # RDF::URI リソースで使用された prefix - namespace 対
      #
      # @return [Hash<String(prefix)=>String(namespace)>]
      #
      attr_reader :used_ns

      #
      # 指定の Event を主語とする Statement からなる RDF:Repository を生成する
      #
      # @param [Array<When::Events::Event>] events 登録する Event の Array
      #
      # @return [Hash<String(GraphURI)=>RDF:Repository>] 生成した Repository の Hash
      #
      def repository(events=nil)
        if events
          rep = Hash.new {|hash,key| hash[key] = ::RDF::Repository.new}
          events.each do |event|
            rep[''].insert(*event.statements)
            rep[event.role[GRAPH]].insert(*event.statements) if @role.key?(GRAPH)
          end
          rep
        else
          @repository ||= repository(@events)
        end
      end

      #
      # 指定の URIまたはイベントの通し番号を主語とする Statement からなる RDF:Repository を生成する
      #
      # @param [String] uri 主語の URI
      # @param [Integer] uri 主語のイベントの通し番号
      # @param [String] graph 検索対象のグラフ(ダミー)
      #
      # @return [Hash<String(GraphURI)=>RDF:Repository>] 生成した Repository の Hash
      #
      def event(uri, graph=nil)
        rep   = Hash.new {|hash,key| hash[key] = ::RDF::Repository.new}
        list  = uri.kind_of?(String) ? @index[SUBJECT][uri] : [uri]
        unless list.empty?
          event = @events[list.first-1]
          rep[''].insert(*event.statements)
          rep[event.role[GRAPH]].insert(*event.statements) if @role.key?(GRAPH)
        end
        rep
      end

      #
      # 外部 RDF を読み込んだ場合に動作を置き換える
      #
      module ExternalRepository
        #
        # 指定の Event を主語とする Statement からなる RDF:Repository を生成する
        #
        # @param [Array<When::Events::Event>] events 登録する Event の Array
        #
        # @return [Hash<String(GraphURI)=>RDF:Repository>] 生成した Repository の Hash
        #
        def repository(events=nil)
          if events
            rep = Hash.new {|hash,key| hash[key] = ::RDF::Repository.new}
            events.each do |event|
              @repository[''].query({:subject=>@resource[event.role[SUBJECT]]}) do |statement|
                rep[''].insert(statement)
                rep[event.role[GRAPH]].insert(statement) if @role.key?(GRAPH)
              end
            end
            rep
          else
            @repository
          end
        end

        #
        # 指定の URI を主語とする Statement からなる RDF:Repository を生成する
        #
        # @param [String] uri 主語の URI
        # @param [String] graph 検索対象のグラフ(ダミー)
        #
        # @return [Hash<String(GraphURI)=>RDF:Repository>] 生成した Repository の Hash
        #
        def event(uri, graph=nil)
          rep = Hash.new {|hash,key| hash[key] = ::RDF::Repository.new}
          @repository[''].query({:subject=>@resource[uri]}) do |statement|
            rep[''].insert(statement)
            rep[event.role[GRAPH]].insert(statement) if @role.key?(GRAPH)
          end
          rep
        end

        private

        # リポジトリを準備する
        def initialize_repository(source)
          @used_predicate = {}
          @repository = Hash.new {|hash,key| hash[key] = ::RDF::Repository.new}
          @repository.update({''=>::RDF::Repository.load(source)})
          valid = @resource[@role[VALID] && /<(.+?)>/ =~ @role[VALID][:target] ?
                    $1 : VALID]
          @repository[''].query({:predicate=>valid}) do |statement|
            yield(rdf_to_hash(statement.subject))
          end
          @events.each do |event|
            statements = event.statements.reject {|statement|
              predicate = statement.predicate.to_s
              @used_predicate.key?(predicate) || @role[predicate][:copied]
            }
            @repository[''].insert(*statements)
            @repository[event.role[GRAPH]].insert(*statements) if @role.key?(GRAPH)
          end
        end

        # 主語 subject を指定してトリプルをハッシュ化する
        def rdf_to_hash(subject)
          hash = {SUBJECT=>subject.to_s}
          @repository[''].query({:subject=>subject}) do |statement|
            key   = statement.predicate.to_s
            value = statement.object
            value = value.to_s unless value.kind_of?(Numeric)
            case hash[key]
            when Array ; hash[key] << value
            when nil   ; hash[key] = When::Events.cardinality1(key) ? value : [value]
            else       ; hash[key] = [hash[key], value]
            end
            @used_predicate[key] ||= statement.predicate
          end
          hash
        end
      end

      #
      # 外部 SPARQL サーバーを利用する場合に動作を置き換える
      #
      module SparqlRepository

        #
        # 指定の URI を主語とする Statement からなる RDF:Repository を生成する
        #
        # @param [String] uri 主語の URI
        # @param [String] graph 検索対象のグラフ
        #
        # @return [Hash<String(GraphURI)=>RDF:Repository>] 生成した Repository の Hash
        #
        def event(uri, graph=nil)
          rep     = Hash.new {|hash,key| hash[key] = ::RDF::Repository.new}
          subject = @resource[uri]

          # 問い合わせ文字列を準備する
          query_string  = "SELECT DISTINCT ?predicate ?object \n"
          query_string << "FROM <#{graph}> \n" if /./ =~ graph
          query_string << "WHERE { \n <#{uri}> ?predicate ?object . \n} \n"
        # return query_string

          # 問い合わせを実行する
          client = ::SPARQL::Client.new(@endpoint)
          client.query(query_string).each do |solution|
            statement = ::RDF::Statement.new(subject, solution[:predicate], solution[:object])
            rep[''].insert(statement)
            rep[graph].insert(statement) if graph
          end
          rep
        end

        #
        # 指定の条件を満たす Event の Array を返す
        #
        # @param [Hash] options 以下の通り
        # @option options [String]             'date'        日付範囲
        # @option options [String]             'contributor' 情報提供者
        # @option options [String]             'graph'       グラフ
        # @option options [String]             'group'       グループ
        # @option options [String]             'location'    空間位置
        # @option options [String]             'keyword'     キーワード
        # @option options [String or Integer]  'limit'       最大取得数
        # @option options [String or Integer]  'offset'      取得開始レコード
        # @option options [Boolean]            'count'       イベント数のみの確認か?
        #
        # @return [Array<When::Events::Event>] Event の Array
        #
        def intersection_events(options)

          # 問い合わせ文字列を準備する
          rdf_keys   = Hash.new {|hash,key| hash[key]=[]}
          role_keys  = @role.keys - [LABEL, REFERENCE, WHAT_DAY]
          role_keys.each do |role_key|
            @role[role_key][:target].scan(/<(.+?)>/) {rdf_keys[$1] << role_key}
          end
          keywords   = (/./ =~ options['keyword']) ? options['keyword'].split('*') : []
          loc_edges  = @order.key?(WEST) || @order.key?(SOUTH) || @order.key?(BOTTOM)
          triples    = []
          predicates = {}
          rdf_keys.each_pair do |rdf_key, role_key|
            if role_key.include?(SUBJECT)
              predicates['?s'] = rdf_key
            elsif role_key.include?(HAS_PART)
              keywords.each do |keyword|
                triples << "?s <#{rdf_key}> \"#{keyword}\" . "
              end
            elsif role_key.include?(CONTRIBUTOR) && /\A[^!]/ =~ options['contributor']
              triples << "?s <#{rdf_key}> \"#{options['contributor']}\" . "
            elsif role_key.include?(GROUP) && /./ =~ options['group']
              triples << "?s <#{rdf_key}> \"#{options['group']}\" . "
            elsif role_key.include?(SPATIAL) && /./ =~ options['location'] && !loc_edges
              triples << "?s <#{rdf_key}> \"#{options['location']}\" . "
            else
              object = "?o#{predicates.size}"
              predicates[object] = rdf_key
              triples << "?s <#{rdf_key}> #{object} . "
            end
          end
          select  = options['count'] ?
                      "SELECT DISTINCT (COUNT(*) AS ?count) " :
                      "SELECT DISTINCT #{predicates.keys.join(' ')} "
          filters = []
          filters.concat(range_filter(When.date_or_era(options['date']), predicates, rdf_keys, 'valid', options['date'])) if /./ =~ options['date']
          filters.concat(regex_filter(options['contributor'], predicates, rdf_keys, 'contributor'))
          if /./ =~ options['location'] && loc_edges
            location = When.where?(options['location'])
            filters.concat(range_filter(location.long, predicates, rdf_keys, 'longitude')) if @order.key?(WEST)
            filters.concat(range_filter(location.lat,  predicates, rdf_keys, 'latitude' )) if @order.key?(SOUTH)
            filters.concat(range_filter(location.alt,  predicates, rdf_keys, 'altitude' )) if @order.key?(BOTTOM)
          end
          query_string  = "#{select}\n"
          query_string << "FROM <#{options['graph']}> \n" if @role.key?(GRAPH) && /./ =~ options['graph']
          query_string << "WHERE { \n #{triples.map {|t| t+"\n "}.join('')}"
          query_string << " FILTER ( \n  #{filters.map {|f| ' '+f}.join(" && \n  ")}\n  ) \n" unless filters.empty?
          query_string << "} \n"
          query_string << "ORDER BY #{attr2var(@order.key?(START) ? 'start' : 'valid', predicates, rdf_keys)} \n" unless options['count']
          query_string << "LIMIT  #{options['limit']} \n"  if options['limit' ].to_i > 1
          query_string << "OFFSET #{options['offset']} \n" if options['offset'].to_i > 1
          return query_string if options['debug']

          # 問い合わせを実行する
          client = ::SPARQL::Client.new(@endpoint)
          if options['count']
            # イベント数のみ確認する
            client.query(query_string).each do |solution|
              return solution[:count].to_i
            end
            return 0

          else
            # イベントの内容を取り出す
            client.query(query_string).map {|solution|
              event = Hash[*predicates.keys.map {|predicate|
                        object = solution[predicate[1..-1].to_sym]
                        [predicates[predicate],
                         case object
                         when ::RDF::Literal::Integer ; object.to_i
                         when ::RDF::Literal::Numeric ; object.to_f
                         else object.to_s
                         end]
                      }.flatten]
              rdf_keys.each_pair do |rdf_key, role_key|
                next if event.key?(rdf_key)
                if role_key.include?(HAS_PART)
                  event[rdf_key] = keywords
                elsif role_key.include?(CONTRIBUTOR)
                  event[rdf_key] = options['contributor']
                elsif role_key.include?(GRAPH)
                  event[rdf_key] = (/./ =~ options['graph'] ? options['graph'] : @default_graph)
                elsif role_key.include?(SPATIAL)
                  event[rdf_key] = options['location']
                end
              end
              uri = event[predicates['?s']]
              id  = uri[@default_graph.length..-1] if @default_graph && uri.index(@default_graph)
              Event.new(self, id || uri, event)
            }
          end
        end

        private

        # リポジトリを準備する
        def initialize_repository(source)
          @endpoint = source
        end

        def range_filter(target, predicates, rdf_keys, attr, altanative=nil)
          first, last, exclude =
            case @role[FirstEdge[attr]] && @role[FirstEdge[attr]][:type]
            when INTEGER
              range_to_args(target, :to_i)
            when DOUBLE, FLOAT
              range_to_args(target, :to_f)
            else
              case altanative
              when /\A(.+?)(\.{2,3})(.+?)(\^{1,2}.+)?\z/
                ["\"#{$1}#{$4}\"", "\"#{$3}#{$4}\"", $2=='...']
              else
                [altanative]
              end
            end
          lower  = @order.key?(LastEdge[ attr]) ? LastEdge[ attr][/[a-z]+\z/i] :
                   @order.key?(FirstEdge[attr]) ? FirstEdge[attr][/[a-z]+\z/i] : attr
          upper  = @order.key?(FirstEdge[attr]) ? FirstEdge[attr][/[a-z]+\z/i] : attr
          last ||= first
          lower_var = attr2var(lower, predicates, rdf_keys)
          upper_var = attr2var(upper, predicates, rdf_keys)
          [lower,first] == [upper,last] ?
            ["#{lower_var} = #{first}"] : ["#{lower_var} >= #{first}", "#{upper_var} #{exclude ? '<' : '<='} #{last}"]
        end

        def regex_filter(target, predicates, rdf_keys, attr='contributor')
          return [] unless target && /\A!(.+)\z/ =~ target.strip
          ["!regex(#{attr2var(attr, predicates, rdf_keys)}, \"^#{$1}$\") "]
        end

        def range_to_args(target, method)
          if target.respond_to?(:first)
            return [target.first.send(method), target.last.succ.send(method), true] if !target.exclude_end? && target.last.respond_to?(:succ)
            return [target.first.send(method), target.last.send(method), target.exclude_end?]
          elsif target.respond_to?(:succ)
            return [target.send(method), target.succ.send(method), true]
          else
            return [target.send(method)]
          end
        end

        def attr2var(attr, predicates, rdf_keys)
          predicates.each_pair do |var, rdf_key|
            rdf_keys[rdf_key].each do |role|
              return var if role.index(attr)
            end
          end
          nil
        end
      end

      #
      # 指定の条件を満たす Event の Array を返す
      #
      # @param [Hash] options 以下の通り
      # @option options [String] 'date'        日付範囲
      # @option options [String] 'contributor' 情報提供者
      # @option options [String] 'graph'       グラフ
      # @option options [String] 'group'       グループ
      # @option options [String] 'location'    空間位置
      # @option options [String] 'day'         今日は何の日用の日付(共通)
      # @option options [String] 'lsday'       今日は何の日用の日付(エスニック)
      # @option options [String] 'keyword'     キーワード
      #
      # @return [Array<When::Events::Event>] Event の Array
      #
      def intersection_events(options)
        list = []

        # 日付範囲
        if @order.key?(START) && /./ =~ options['date']
          range = Range.convert_from(When.date_or_era(options['date']))
          list << (@order.key?(UNTIL) ?
                     range_overlaped(START, UNTIL, range) :
                     edge_included(START, range))
        end

        # キーワード
        if @index.key?(HAS_PART) && /./ =~ options['keyword']
          options['keyword'].split('*').each {|key| list << @index[HAS_PART][key]}
        end

        # 情報提供者
        if @index.key?(CONTRIBUTOR) && /\A(!)?(.+)/ =~ options['contributor']
          reverse, contributor = $1, $2
          sublist = @index[CONTRIBUTOR][contributor]
          if sublist
            sublist = (@order[START] || (1..@events.size).to_a) - sublist if reverse
            list << sublist
          end
        end

        # グループ
        if @index.key?(GROUP) && /./ =~ options['group']
          list << @index[GROUP][options['group']]
        end

        # 空間位置
        if /./ =~ options['location']
          if @order.key?(WEST) || @order.key?(SOUTH) || @order.key?(BOTTOM)
            range = When.where?(options['location'])
            range = When::Coordinates::Spatial::Range.new(range,range) unless range.kind_of?(When::Coordinates::Spatial::Range)
            [[WEST,   EAST,  :long],
             [SOUTH,  NORTH, :lat ],
             [BOTTOM, TOP,   :alt ]].each do |pattern|
               first, last, method = pattern
               if @order.key?(first)
                 list << (@order.key?(last) ?
                            range_overlaped(first, last, range.send(method), :to_f) :
                            edge_included(first, range.send(method), :to_f))
               end
             end
           elsif @index.key?(SPATIAL)
             list << @index[SPATIAL][options['location']]
           end
        end

        # グラフ
        if @index.key?(GRAPH) && /./ =~ options['graph']
          list << @index[GRAPH][options['graph']]
        end

        # 今日は何の日
        if @index.key?(WHAT_DAY)
          list << @index[WHAT_DAY][[true,  $1.to_i,$2.to_i]] if /\A(\d{1,2})[-\/]?(\d{1,2})\z/ =~ options['day']
          list << @index[WHAT_DAY][[false, $1.to_i,$2.to_i]] if /\A(\d{1,2})[-\/]?(\d{1,2})\z/ =~ options['lsday']
        end

        # 共通集合
        list.compact!
        return list if list.empty?
        intersection = list.shift
        list.each {|s| intersection &= s}
        events = intersection.map {|id| @events[id-1]}
        return events unless range

        # 個別の絞込み
        narrowed_events = []
        sort_required = false
        events.each do |event|
          event_range = event.role[VALID]
          if event_range.kind_of?(Range) && event_range.is_complex?
            event_range.overlaped(range).each do |focused_date|
              sort_required = true
              focused_event = event.deep_copy
              focused_event.send(:date=, focused_date)
              narrowed_events << focused_event
            end
          else
            narrowed_events << event
          end
        end
        narrowed_events.sort_by! {|event| event.date} if sort_required
        narrowed_events
      end

      #
      # 順序キーによる検索
      #
      # @param [String] edge 順序キー(ts:start, ts:until, ts:west, ts:east, ts:south, ts:north, ts:bottom, ts:top)
      # @param [Range] range 絞り込む範囲
      # @param [Symbol] method スカラー化メソッドの指定 :to_i - 整数変数, :to_f - 実数変数
      #
      # @return [Array<Integer>] イベントのIDの配列
      #
      def edge_included(edge, range, method=:to_i)
        _edge_included(edge, Range.new(*range_args(range, method)))
      end

      #
      # 範囲の重なり
      #
      # @param [String] first_edge 順序キー(ts:start, ts:west, ts:south, ts:bottom)
      # @param [String] last_edge  順序キー(ts:until, ts:east, ts:north, ts:top)
      # @param [Range] range 絞り込む範囲
      # @param [Symbol] method スカラー化メソッドの指定 :to_i - 整数変数, :to_f - 実数変数
      #
      # @return [Array<Integer>] イベントのIDの配列
      #
      def range_overlaped(first_edge, last_edge, range, method=:to_i)
        args  = range_args(range, method)
        upper = ::Range.new(args[0], +Float::MAX/4, false)
        lower = ::Range.new(-Float::MAX/4, args[1], args[2])
        ([first_edge, last_edge].map {|edge| [@order[edge].first, @order[edge].last]}.flatten.uniq.select {|id|
          lower.include?(@events[id-1].role[first_edge]) && upper.include?(@events[id-1].role[last_edge])
        } | (
          @order[last_edge][_start_edge(last_edge, upper, 0, @events.size-1)..-1] &
          @order[first_edge][0..._ended_edge(first_edge, lower, 0, @events.size-1)]
        )).sort_by {|id|
          @events[id-1].role[first_edge]
        }
      end

      #
      # 範囲生成用引数の準備
      #
      def range_args(range, method)
        range.exclude_end? ?
          [range.first.send(method), range.last.send(method), true] :
        range.last.respond_to?(:succ) ?
          [range.first.send(method), range.last.succ.send(method), true] :
          [range.first.send(method), range.last.send(method), false]
      end
      private :range_args

      # プレフィクスを名前空間に展開する
      #
      # @param [String] predicate プレフィクス付きの URI
      #
      # @return [String] プレフィクスを名前空間に展開した URI
      #
      def extract(predicate)
        return predicate unless /\A(.+?):(.+)\z/ =~ predicate && @prefix.key?($1)
        prefix, body = $~[1..2]
        namespace = @prefix[prefix].first
        namespace = namespace.sub(/([a-z0-9])\z/i, '\1#')
        namespace + body
      end

      #
      # 一言語対応データセットを生成する
      #
      # @param [Array<Array<Array<String>, String>>] definitions 定義行の情報
      # @param [String] language 言語コード
      # @param [String] uri 定義の所在のルート(ts:referenceが相対位置の場合に使用)
      # @param [When::Events::DataSets] parent 所属する多言語対応データセット
      # @param [Block] block キャッシュされたファイルパスの読み替え処理
      #
      def initialize(definitions, language='', uri='', parent=nil, &block)
        @language = language
        @parent   = parent
        @prefix   = {}
        @role     = {}
        @rdf      = {}
        @csv      = {}
        @l_to_i   = {}
        @i_to_l   = {}
        @role_for_dataset = {}
        @definitions = definitions
        @definitions.each do |definition, lang|
          parameters = definition[1..2].map {|item| item.strip}
          case definition.first
          when /\A(.+):\z/
            @prefix[$1] = parameters
          when /\A\[(.+)\]\z/
            key=extract($1)
            @csv[key ] = operation(key, parameters, lang)
          when /\A<(.+)>\z/
            key=extract($1)
            @rdf[key ] = operation(key, parameters, lang)
          when /\A\{(.+)\}\z/
            key=extract($1)
            (DataSet.for_dataset?(parameters.first, key) ? @role_for_dataset : @role)[key] = operation(key, parameters, lang)
          end
        end
        @prefix_description  = @prefix.values.reject {|value| value.size < 2}.sort_by {|value| -value.first.length}
        @namespace_to_prefix = @prefix.invert.sort.reverse
        @used_ns  = {}
        @resource = Hash.new {|hash,key|
          @namespace_to_prefix.each do |prefix|
            index = key.index(prefix.first.first)
            if index && index == 0
              @used_ns[prefix.last] = prefix.first.first
              break
            end
          end
          hash[key] = ::RDF::URI.new(key)
        }

        @events = []
        @index  = {}
        (@role.keys + @rdf.keys + @csv.keys).each {|item| @index[item] = Hash.new {|hash,key| hash[key]=[]}}
        target = @role_for_dataset[REFERENCE][:target]
        unless target =~ /:/ # Relative path
          path     = uri.split('/')
          path[-1] = target
          target   = path.join('/')
        end
        operation = @role_for_dataset[REFERENCE][:original]
        source    = extract(target)
        source    = yield(source) if block_given? && operation !~ /SPARQL|CalendarEra/i
        raise IOError, target + ': not ready' unless source
        for_each_record(source, operation) do |row|
          event = Event.new(self, @events.size+1, row)
          @events << event

          @role.keys.each do |item|
            case item
            when LABEL, REFERENCE
            when HAS_PART
              if event.role[HAS_PART].kind_of?(Array)
                event.role[HAS_PART].each do |word|
                  @index[HAS_PART][word] << @events.size
                end
              else
                event.each_word do |word|
                  @index[HAS_PART][word] << @events.size
                end
              end
            when WHAT_DAY
              date = event.role[WHAT_DAY]
              key = [date.class.to_s !~ /\AWhen/ ||
                     date.frame.kind_of?(When::CalendarTypes::Christian),
                     date.month * 1, date.day]
              @index[WHAT_DAY][key] << @events.size
            else
              add_index(:role, item)
            end
          end

          [:rdf, :csv].each do |method|
            send(method).keys.each do |item|
              add_index(method, item)
            end
          end
        end

        @order = {}
        [:role, :rdf, :csv].each do |method|
          send(method).each_pair do |item, definition|
            next unless definition[:index] == :order
            @order[item] = (1..@events.size).to_a.sort_by {|id| @events[id-1].send(method)[item]}
            @order[item].each_with_index do |id, index|
              @events[id-1].order[item] = index + 1
            end
          end
        end
        @index.each_value do |hash|
          hash.each_value do |value|
            value.uniq!
            value.sort_by! {|id| @events[id-1].order[START]} if @order.key?(START)
          end
        end

        @default_graph   = $1 if @role.key?(SUBJECT) && /\A(.+)<(.+)>\z/ =~ extract(@role[SUBJECT][:target])
        @default_graph ||= parent.iri if parent
      end

      private

      # 定義行一行を解釈する
      def operation(key, definition, lang='')
        edge  = When::Events.edge(key)
        if definition[1]
          type = nil
          definition[1].split(/\s+/).each do |predicate|
            if /\A(.+?):(.*)\z/ =~ predicate && @prefix.key?($1)
              body      = $2
              namespace = @prefix[$1].first
              namespace = namespace.sub(/([a-z0-9])\z/i, '\1#')
              type      = namespace + body
            end
            break
          end
        end
        type      ||= (When.const_defined?(:Parts) ? RANGE : ::Date) if key == VALID
        operation   = if /\A\s*strptime\((.+)\)\s*\z/ =~ definition[1]
                        fmt = $1
                        proc {|date| When.strptime(date, fmt)}
                      else
                        Operations[edge ? [edge, type] : type]
                      end
        {:target    => definition[0].gsub(/<(.+?)>|\{(.+?)\}/) {|match|
             match[1..-2] = extract($1 || $2)
             match
           },
         :original  => definition[1],
         :index     => When::Events.equal(key) || (edge ? :order : ''),
         :type      => type,
         :operation => operation,
         :copied    => /\A<[^>]+>\z/ =~ definition[0] && operation.equal?(Operations.default),
         :lang      => lang
        }
      end

      # データセット用の定義かイベント用の定義かの判断
      def self.for_dataset?(target, key=nil)
        return false if key && !ForDataset.include?(key)
        /\[.+?\]|<.+?>|\{.+?\}/ !~ target
      end

      # イベントを生成・登録
      def for_each_record(source, operation='csv with header', &block)
        case operation
        when /(out|no)\s*header\s*(\((\d+)\))?/i
          @limit = $3.to_i if $3
          csv_row_vs_label([])
          open(source,'r') do |io|
            CSV.parse(io.read) do |row|
              yield(row)
              break if @limit && @events.size >= @limit
            end
          end
        when /header\s*(\((\d+)\))?/i
          @limit = $2.to_i if $2
          open(source,'r') do |io|
            CSV.parse(io.read) do |row|
              if @row_vs_label
                yield(row)
              else
                csv_row_vs_label(row)
              end
              break if @limit && @events.size >= @limit
            end
          end
        when /SPARQL/i
          extend SparqlRepository
          initialize_repository(source, &block)
        when /RDF/i
          extend ExternalRepository
          initialize_repository(source, &block)
        when /CalendarEra/i
          era = When.Resource(source)
          era = era.child.first unless era.child.empty?
          while (era)
            yield({VALID     => When::Parts::GeometricComplex.new(era.first, era.last.indeterminated_position ?
                                                                   When.today+When::P6W : era.last),
                   LABEL     => era.label.translate(@language),
                   REFERENCE => era.label.reference(@language)})
            era = era.succ
          end
        when /\A\/(.+)\/(\((\d+)\))?\z/
          @limit = $3.to_i if $3
          rexp = Regexp.compile($1)
          csv_row_vs_label([])
          open(source, 'r') do |file|
            file.read.gsub(/[\r\n]/,'').scan(rexp) do
              yield((1...$~.size).to_a.map {|i| $~[i]})
            end
            break if @limit && @events.size >= @limit
          end
        else
          raise ArgumentError, "Undefined operation: #{operation}"
        end
      end

      # CSVのフィールド番号とフィールド名の対応を管理する
      def csv_row_vs_label(row)
        row.each_with_index do |label, index|
          @l_to_i[label]     = index + 1
          @i_to_l[index + 1] = label
        end

        [@rdf, @role, @csv].each do |element|
          element.each_value do |values|
            values[:target].scan(/\[(.+?)\]/) {verify_index_and_label($1)} if values[:target]
          end
        end
        @csv.keys.each do |key|
          verify_index_and_label(key)
        end

        [@rdf, @role, @csv].each do |element|
          element.each_value do |values|
            values[:target].gsub!(/\[(.+?)\]/) {label_to_index($1)} if values[:target]
          end
        end
        csv_verified = {}
        @csv.each_pair do |item, value|
          next if value.empty?
          key = label_to_index(item)
          if @csv_varified.key?(key)
            raise ArgumentError, "Duplicated index and label: #{item}" unless value == csv_verified[key]
          else
            csv_verified[key] = value
          end
        end
        @csv = csv_verified

        @i_to_l.each_pair do |index, label|
          next unless /:/ =~ label
          @rdf[label] ||= {:target    => "[#{index}]",
                           :original  => '',
                           :index     => '',
                           :operation => Operations.default}
        end

        @row_vs_label = true
      end

      # CSVのフィールド名→フィールド番号
      def label_to_index(item)
        case item
        when /\A\d+\z/
          "[#{item.to_i}]"
        when /\A[^:]+\z/, /\A[^\d:].*?:/
          raise ArgumentError, "Label undefined: #{item}" unless @l_to_i.key?(item)
          "[#{@l_to_i[item]}]"
        else
          index = verify_index_and_label(item)
          raise ArgumentError, "Irregal index format: #{item}" unless index
          "[#{index}]"
        end
      end

      # CSVのフィールド番号とフィールド名を照合する
      def verify_index_and_label(item)
        return nil unless /\A(\d+?):(.+)\z/ =~ item
        index ,label = $~[1..2]
        index = index.to_i
        label = extact(label)
        if @i_to_l.key?(index) && @i_to_l[index] != label ||
           @l_to_i.key?(label) && @l_to_i[label] != index
          raise ArgumentError, "Duplicated index and label: #{item}"
        else
           @i_to_l[index] = label
           @l_to_i[label] = index
        end
        index
      end

      # ロールを一致インデクス管理対象として登録する
      def add_index(method, item)
        return unless send(method)[item][:index] == :equal
        key = @events.last.send(method)[item]
        return unless key
        @index[item][key] << @events.size
      end

      # 二分検索 - メイン
      def _edge_included(edge, range, from=0, to=@events.size-1)
        middle = (from + to) / 2
        if range.include?(@events[@order[edge][middle]-1].role[edge])
          if range.first <= @events[@order[edge].first-1].role[edge]
            start = 0
          else
            start = _start_edge(edge, range, 0, middle)
          end
          if range.exclude_end? && range.last >= @events[@order[edge].last-1].role[edge] ||
            !range.exclude_end? && range.last >  @events[@order[edge].last-1].role[edge]
            ended = @events.size
          else
            ended = _ended_edge(edge, range, middle, @events.size-1)
          end
          return (start...ended).to_a.map {|i| @order[edge][i]}
        end
        return [] if from == to
        @events[@order[edge][middle]-1].role[edge] < range.first ?
          _edge_included(edge, range, middle+1, to) :
          _edge_included(edge, range, from,  middle)
      end

      # 二分検索 - 小さい方の境界
      def _start_edge(edge, range, from, to)
        return to if to - from <= 1
        middle = (from + to) / 2
        range.include?(@events[@order[edge][middle]-1].role[edge]) ?
          _start_edge(edge, range, from,   middle) :
          _start_edge(edge, range, middle, to)
      end

      # 二分検索 - 大きい方の境界
      def _ended_edge(edge, range, from, to)
        return to if to - from <= 1
        middle = (from + to) / 2
        range.include?(@events[@order[edge][middle]-1].role[edge]) ?
          _ended_edge(edge, range, middle, to) :
          _ended_edge(edge, range, from,   middle)
      end
    end

    #
    # 時間座標を持つイベント
    #
    class Event

      #
      # 所属する一言語対応データセット
      #
      # @return [When::Events::DataSet]
      #
      attr_reader :dataset

      #
      # 通し番号
      #
      # @return [Integer]
      #
      attr_reader :id

      #
      # CSVの一行分
      #
      # @return [Array<String>]
      #
      attr_reader :row

      #
      # ロール変数
      #
      # @return [Hash<String(prefix:name)=>Object>]
      #
      attr_accessor :role
      protected :role=

      #
      # RDF変数
      #
      # @return [Hash<String(prefix:name)=>Object>]
      #
      attr_accessor :rdf
      protected :rdf=

      #
      # CSV変数
      #
      # @return [Hash<String(番号)=>Object>]
      #
      attr_accessor :csv
      protected :csv=

      #
      # 当該順序キーで何番目のイベントか
      #
      # @return [Hash<String(prefix:name)=>Array(Integer(id))>]
      #
      attr_reader :order

      #
      # deep copy 時の元イベント
      #
      # @return [When::Events::Event]
      #
      attr_accessor :original
      protected :original=

      #
      # 日付または日付範囲
      #
      # @return [When::TM::TemporalPosition or When::Events::Range]
      #
      attr_accessor :date
      private :date=

      #
      # HAS_PART対象の文字列中の{}で囲まれた語に対して yield で指定された処理を行う
      #
      def each_word
        @role[HAS_PART].scan(/(\{+)(.*?)(\}+)/) do
          bra, word, cket = $~[1..3]
          next unless bra.length.odd? && cket.length.odd?
          yield(word)
        end
      end

      #
      # 指定の情報を{}部分のマークアップ処理など行って整形して返す
      #
      # @param [String] item 返す情報の名称
      # @param [Symbol] method 返す情報が属するグループ(:role, :rdf, :csv)
      #
      # @return [String]
      #
      # @note ブロックを渡された場合、そのブロックに{}部分のマークアップを依頼する
      #
      def abstract(item=ABSTRACT, method=:role)
        send(method)[item].gsub(/(\{+)(.*?)(\}+)/) {
          bra, word, cket = $~[1..3]
          '{'*(bra.length/2) + (block_given? ? yield(word) : word) + '}'*(cket.length/2)
        }
      end

      #
      # 指定の情報のIRIとその説明を返す
      #
      # @param [String] item 返す情報の名称
      # @param [Symbol] method 返す情報が属するグループ(:role, :rdf, :csv)
      #
      # @return [Array<String(IRI), String(説明)>]
      #
      def source(item=SOURCE, method=:role)
        iri = send(method)[item]
        return [nil, iri] unless /:\/\// =~ iri
        @dataset.prefix_description.each do |description|
          index = iri.index(description[0])
          return [iri, description[1]] if index && index == 0
        end
        [iri]
      end

      #
      # イベントが属するグループ(@role[When::Events::GROUP])を返す
      #
      # @return [String]
      #
      def group
        @role[GROUP]
      end

      #
      # 自身を主語とする RDF::Statement の Array を返す
      #
      # @return [Array<RDF::Statement>]
      #
      def statements
        unless @statements
          @statements = []
          raise ArgumentError, 'Role for rdf:subject not defined' unless @role.key?(SUBJECT)
          subject = @dataset.resource[@role[SUBJECT]]
          @role.each_pair do |predicate, object|
            case predicate
            when SUBJECT, ID, GRAPH, WHAT_DAY
              # Do nothing
            when HAS_PART
              if @role[HAS_PART].kind_of?(Array)
                words = @role[HAS_PART]
              else
                words = []
                each_word do |word|
                  words << word
                end
                words.uniq!
              end
              words.each do |word|
                @statements << ::RDF::Statement(subject, @dataset.resource[predicate], word)
              end
            when VALID
              if object.kind_of?(Range)
                object = object.original
              elsif object.respond_to?(:to_uri)
                object = object.to_uri
              end
              @statements << ::RDF::Statement(subject, @dataset.resource[predicate], object)
          # when ABSTRACT
          #   @statements << ::RDF::Statement(subject, @dataset.resource[predicate], abstract)
            else
              if [URI, IRI].include?(@dataset.role[predicate][:type])
                object = @dataset.resource[object]
              elsif object.respond_to?(:to_uri)
                object = object.to_uri
              elsif @dataset.role[predicate][:lang] != '' && object.kind_of?(String)
                object = ::RDF::Literal.new(object, {:language=>@dataset.role[predicate][:lang]})
              end
              @statements << ::RDF::Statement(subject, @dataset.resource[predicate], object)
            end
          end
        end
        @statements
      end

      #
      # イベントの複製
      #
      # @return [When::Events::Event] コピー結果
      #
      def deep_copy
        result          = self.dup
        result.csv      = @csv.dup
        result.rdf      = @rdf.dup
        result.role     = @role.dup
        result.original = self
        result
      end

      #
      # イベントの生成
      #
      # @param [When::Events::DataSet] dataset 所属する一言語対応データセット
      # @param [Integer] id 通し番号
      # @param [Array<String>] row CSVの一行分
      # @param [Hash<String=>Object>] row RDFの1クエリ分
      #
      def initialize(dataset, id, row)
        @dataset = dataset
        @id      = id
        @row     = row
        @role    = {}
        @rdf     = {}
        @csv     = {}
        @order   = {}

        case row
        when Hash
          @rdf = row
        when Array
          row.each_with_index do |item, index|
            @csv[(index+1).to_s] = item
          end

          dataset.rdf.each_pair do |item, definition|
            fields = []
            format = definition[:target].gsub(/\[(\d+)\]/) {
              field  =  row[$1.to_i-1]
              field  =  escape(field, definition[:type])
              fields << field
              '%s'
            }
            @rdf[item] = definition[:operation].call(self, format == '%s' ? fields.first : format % fields)
          end
        end

        @role[ID] = @rdf[ID] = id
        dataset.role.each_pair do |item, definition|
          fields = []
          format = definition[:target].gsub('%','%%').gsub(/\[(\d+)\]|<(.+?)>|\{(.+?)\}/) {|match|
            key  = $1 || $2 || $3
            field = case match
                    when /\A\[/ ; row[key.to_i-1]
                    when /\A</  ; @rdf[key]
                    when /\A\{/ ; @role[key]
                    end
            field  =  escape(field, definition[:type])
            fields << field
            '%s'
          }
          pre_operation = DataSet::Operations[item]
          @role[item] = 
            if pre_operation
              definition[:operation].call(self, pre_operation.call(self, format == '%s' ? fields.first : format % fields))
            else
              definition[:operation].call(self, format == '%s' ? fields.first : format % fields)
            end
        end

        @date = @role[VALID]
      end

      private

      # URI 仕様外の文字をエスケープする
      def escape(part, type)
        return part unless part.kind_of?(String)
        part = part.strip
        return part if /:\/\/|%/ =~ part
        case type
        when URI; CGI.escape(part.gsub(' ', '_')).gsub(/%2F/i,'/')
        when IRI; part.gsub(' ', '_')
        else part
        end
      end
    end
  end
end
