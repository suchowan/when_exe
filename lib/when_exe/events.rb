# -*- coding: utf-8 -*-
=begin
    Copyright (C) 2015 Takashi SUGA

    You may use and/or modify this file according to the license
    described in the LICENSE.txt file included in this archive.
=end

module When

  #
  # 時間座標を持つイベント記録の管理
  #
  module Events

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
        def dataset(language, limit=true)
          locale = key(language)
          if When.multi_thread
            thread = @threads[locale]
            joined =
              case limit
              when Numeric   ; thread.join(limit)
              when nil,false ; true
              else           ; thread.join
              end
            return nil unless joined
          end
          @datasets[locale]
        end

        # 多言語対応データセットオブジェクトの生成
        #
        # @param [String] uri データセット定義の所在
        # @param [Array<Array<String>>] rows 多言語対応データセット定義
        #
        def initialize(uri, rows)

          # 定義行を言語ごとに仕分けする
          definitions = []
          labels      = nil
          datasets    = nil
          rows.each do |row|
            items = row.map {|item| item.strip}
            next if items.first =~ /\A#/
            name, language= items.shift.split('@', 2)
            language    ||= ''
            language.sub!('_', '-')
            if definitions.last && name == definitions.last.first
              definitions.last.last[language] = items
            else
              definitions << [name, {language=>items}]
              definitions.last.last[''] ||= items
            end
            case definitions.last.first
            when '{rdfs:label}'  ; labels   = definitions.last.last
            when '{ts:reference}'; datasets = definitions.last.last
            end
          end

          # 名前オブジェクトを生成する
          @label = When::BasicTypes::M17n.new({
            'label'=>labels[''].first,
            'names'=>Hash[*(labels.keys.map   {|label|   [label,   labels[label].first    ]}).flatten],
            'link' =>Hash[*(datasets.keys.map {|dataset| [dataset, datasets[dataset].first]}).flatten]
          })
          @_pool = {'.'=>rows, @label.to_s=>@label}
          @child             = [@label]
          @label._pool['..'] = self

          # 各言語用のデータセットオブジェクトを生成する
          if When.multi_thread
            @datasets = {}
            @threads  = Hash[*(datasets.keys.map {|language|
              [language, Thread.new {
                @datasets[language] =
                  DataSet.new(definitions.map {|definition|
                    [definition.first] + definition.last[key(language, definition.last)]
                  }, uri)
              }]
            }).flatten]
          else
            @datasets = Hash[*(datasets.keys.map {|language|
              [language, DataSet.new(definitions.map {|definition|
                [definition.first] + definition.last[key(language, definition.last)]
              }, uri)]
            }).flatten]
          end
        end

        private

        # 言語コードに対応するキーを取得する
        def key(loc, hash=@datasets)
          loc = loc.sub('_', '-')
          return loc if hash.key?(loc)
          loc, = loc.split('.')
          return loc if hash.key?(loc)
          loc, = loc.split('-')
          return loc if hash.key?(loc)
          ''
        end
      end
    end

    #
    # 一言語対応データセット
    #
    #   特定の言語用データセットを保持する
    #
    class DataSet

      #
      # 定義済オブジェクト操作
      #
      Operations = Hash.new(proc {|obj| obj}).merge({
        '#to_i'       => proc {|obj| obj.to_i},
        '#to_f'       => proc {|obj| obj.to_f},
        '#first.to_i' => proc {|obj| obj.first.to_i},
        '#first.to_f' => proc {|obj| obj.first.to_f},
        '#last.to_i'  => proc {|obj| proc {|obj| obj.last.to_i}},
        '#last.to_f'  => proc {|obj| proc {|obj| obj.last.to_f}},
        '.when?'      => proc {|date| When.when?(date)},
        '.parse'      => proc {|date| Date.parse(date)}
      })

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
      # 名前空間
      #
      # @return [Hash<String(prefix)=>String(namespace)>]
      #
      attr_reader :prefix

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
      # 順序キーによる検索(整数変数)
      #
      # @param [String] edge 順序キー(ts:start, ts:until, ts:west, ts:east, ts:south, ts:north, ts:bottom, ts:top)
      # @param [Range] range 絞り込む範囲
      #
      # @return [Array<Integer>] イベントのIDの配列
      #
      def edge_included_i(edge, range)
        _edge_included(edge, Range.new(range.first.to_i, range.last.to_i, range.exclude_end?))
      end

      #
      # 順序キーによる検索(実数変数)
      #
      # @param [String] edge 順序キー(ts:start, ts:until, ts:west, ts:east, ts:south, ts:north, ts:bottom, ts:top)
      # @param [Range] range 絞り込む範囲
      #
      # @return [Array<Integer>] イベントのIDの配列
      #
      def edge_included_f(edge, range)
        _edge_included(edge, Range.new(range.first.to_f, range.last.to_f, range.exclude_end?))
      end

      #
      # 一言語対応データセットを生成する
      #
      # @param [Array<String>] definitions 定義行の情報
      # @param [String] uri 定義の所在のルート(ts:referenceが相対位置の場合に使用)
      #
      def initialize(definitions, uri='')
        @prefix = {}
        @role   = {}
        @rdf    = {}
        @csv    = {}
        @l_to_i = {}
        @i_to_l = {}
        @definitions = definitions
        @definitions.each do |definition|
          case definition.first
          when /\A(.+):\z/    ; @prefix[$1] = definition[1]
          when /\A<(.+)>\z/   ; @rdf[$1]    = operation(definition[1..2])
          when /\A\{(.+)\}\z/ ; @role[$1]   = operation(definition[1..2])
          when /\A\[(.+)\]\z/ ; @csv[$1]    = operation(definition[1..2])
          end
        end

        @events = []
        @index  = {}
        (@role.keys + @rdf.keys + @csv.keys).each {|item| @index[item] = Hash.new {|hash,key| hash[key]=[]}}
        target = @role['ts:reference'][:target]
        unless target =~ /:/ # Relative path
          path     = uri.split('/')
          path[-1] = target
          target   = path.join('/')
        end
        for_each_record(target, @role['ts:reference'][:original]) do |row|
          event = Event.new(self, @events.size+1, row)
          @events << event

          @role.keys.each do |item|
            case item
            when 'rdfs:label', 'ts:reference', 'ts:credit'
            when 'ts:existIn'
              event.role['ts:existIn'].scan(/(\{+)(.*?)(\}+)/) do
                bra, word, cket = $~[1..3]
                next unless bra.length.odd? && cket.length.odd?
                @index['ts:existIn'][word] << @events.size
              end
            when 'ts:whatDay'
              date = event.role['ts:whatDay']
              key = [date.class.to_s !~ /\AWhen/ ||
                     date.frame.kind_of?(When::CalendarTypes::Christian),
                     date.month * 1, date.day]
              @index['ts:whatDay'][key] << @events.size
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
            next unless definition[:index] == '<>'
            @order[item] = (1..@events.size).to_a.sort_by {|id| @events[id-1].send(method)[item]}
            @order[item].each_with_index do |id, index|
              @events[id-1].order[item] = index + 1
            end
          end
        end
        @index.each_value do |hash|
          hash.each_value do |value|
            value.uniq!
            value.sort_by! {|id| @events[id-1].order['ts:start']} if @order.key?('ts:start')
          end
        end
      end

      private

      # 定義行一行を解釈する
      def operation(definition)
        index, ope  = $~[1..2] if  /\A(<>|==)?(.+)\z/ =~ definition[1]
        {:target    => definition[0],
         :original  => definition[1],
         :index     => index || '',
         :operation =>
           if /\A\.strptime\((.+)\)\z/ =~ ope
             fmt = $1
             proc {|date| Date.strptime(date, fmt)}
           else
             Operations[ope]
           end
        }
      end

      # イベントを生成・登録
      def for_each_record(source, operation='csv with header')
        case operation
        when /(out|no)\s*header\s*(\((\d+)\))?/i
          @limit = $3.to_i if $3
          csv_row_vs_label([])
          CSV.foreach(source) do |row|
            yield(row)
            break if @limit && @events.size >= @limit
          end
        when /header\s*(\((\d+)\))?/i
          @limit = $2.to_i if $2
          CSV.foreach(source) do |row|
            if @row_vs_label
              yield(row)
            else
              csv_row_vs_label(row)
            end
            break if @limit && @events.size >= @limit
          end
        when /SPARQL/i
        when /\A\/(.+)\/(\((\d+)\))?\z/
          @limit = $3.to_i if $3
          rexp = RegExp.compile($1)
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
        return unless send(method)[item][:index] == '=='
        key = event.send(method)[item]
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
      attr_reader :role

      #
      # RDF変数
      #
      # @return [Hash<String(prefix:name)=>Object>]
      #
      attr_reader :rdf

      #
      # CSV変数
      #
      # @return [Hash<String(番号)=>Object>]
      #
      attr_reader :csv

      #
      # 当該順序キーで何番目のイベントか
      #
      # @return [Hash<String(prefix:name)=>Array(Integer(id))>]
      #
      attr_reader :order

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
      def abstract(item='dct:abstract', method=:role)
          send(method)[item].gsub(/(\{+)(.*?)(\}+)/) {
            bra, word, cket = $~[1..3]
            '{'*(bra.length/2) + (block_given? ? yield(word) : word) + '}'*(cket.length/2)
          }
      end

      #
      # イベントの生成
      #
      # @param [When::Events::DataSet] dataset 所属する一言語対応データセット
      # @param [Integer] 通し番号
      # @param [Array<String>] CSVの一行分
      #
      def initialize(dataset, id, row)
        @dataset = dataset
        @id      = id
        @row     = row
        @role    = {}
        @rdf     = {}
        @csv     = {}
        @order   = {}

        row.each_with_index do |item, index|
          @csv[(index+1).to_s] = item
        end

        dataset.rdf.each_pair do |item, definition|
          fields = []
          format = definition[:target].gsub(/\[(\d+)\]/) {
            fields << row[$1.to_i-1]
            '%s'
          }
          @rdf[item] = definition[:operation].call(format == '%s' ? fields.first : format % fields)
        end

        dataset.role.each_pair do |item, definition|
          fields = []
          format = definition[:target].gsub(/\[(\d+)\]|<(.+?)>|\{(.+?)\}/) {|match|
            key  = $1 || $2 || $3
            fields << case match
                      when /\A\[/ ; row[key.to_i-1]
                      when /\A</  ; @rdf[key]
                      when /\A\{/ ; @role[key]
                      end
            '%s'
          }
          @role[item] = definition[:operation].call(format == '%s' ? fields.first : format % fields)
        end
      end
    end

    #
    # イベント管理用範囲オブジェクト
    #
    class Range < ::Range

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

      # 指定オブジェクトが範囲内か？
      #
      # @param [Object] target 判定するオブジェクト
      #
      # @return [Boolean] 判定結果
      #
      def include?(target)
        return false if (exclude_end? && @until <= target) || (!exclude_end? && @until < target)

        case @start
        when ::Range
          return @start.include?(target)

        when Array
          @start.each do |range|
            return false if _range_exceeded?(range, target)
            return true if _target_included?(range, target)
          end
          return false

        when Enumerator
          begin
            while (range = @start.succ)
              return false if _range_exceeded?(range, target)
              return true if _target_included?(range, target)
            end
            return false
          ensure
            @start.rewind
          end
 
        else
          return @start <= target
        end
      end

      #
      # イベント管理用範囲オブジェクトの生成
      #
      # @param [Object] first 小さい方の境界
      # @param [Object] last 大きい方の境界
      # @param [Boolean] last 大きい方の境界を含まないか？
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
        target < (range.respond_to?(:first) ? range.first : range)
      end

      # target が含まれるか？
      def _target_included?(range, target)
        range.respond_to?(:include?) ? range.include?(target) : (range == target)
      end
    end
  end
end
