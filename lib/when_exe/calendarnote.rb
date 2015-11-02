# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2015 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When

  #
  # 暦注 - Calendar Note
  #
  class CalendarNote < TM::ReferenceSystem

    #
    # 暦注要素への名前アクセス機能提供
    #
    # @private
    module LabelAccess
      attr_reader :_pool

      #
      # 暦注要素への名前(label)によるアクセス
      #
      # @param [Numeric] key 配列インデックスと見なしてアクセス
      # @param [String]  key 名前(label)と見なしてアクセス
      #
      # @return [Object] 暦注要素
      #
      def [](key)
        return super if key.kind_of?(Numeric)
        @_pool ||= Hash[*(inject([]) {|pair, v| pair << v.label.to_s << v})]
        @_pool[key]
      end
    end

    #
    # 暦注要素であることを示す
    #
    module NoteElement
    end

    #
    # 暦注検索結果を保存するコンテナ
    #
    module NotesContainer

      class << self
        #
        # 永続データに暦注検索結果を登録する
        #
        # @private
        def register(notes, persistence, sdn)
          if persistence
            persistence.store(sdn, notes)
            persistence.extend(self)
          end
          notes.extend(self)
        end

        #
        # 永続データから暦注検索結果を取り出す
        #
        # @private
        def retrieve(persistence, sdn)
          return false unless persistence
          persistence.fetch(sdn, false)
        end

        #
        # パターンの値の一致を判定する
        #
        # @private
        def verify(pattern, value)
          value = value.label if !value.kind_of?(When::BasicTypes::M17n) && value.respond_to?(:label)
          pattern = When::EncodingConversion.to_internal_encoding(pattern)
          pattern.kind_of?(Regexp) ? value =~ pattern : value == pattern
        end
      end

      # 暦注検索結果コンテナの次元を下げる
      #
      # @param [Boolean] compact 余分な nil や空配列を除去するか否か
      #
      # @return [NotesContainer]
      #
      def simplify(compact=true)
        if kind_of?(Hash) && !key?(:note)
          # Persistent NotesContainer
          simplified = {}
          each_pair do |key, value|
            value = value.simplify(compact) if value.kind_of?(NotesContainer)
            simplified[key] = value if value
          end
        else
          # Non-Persistent NotesContainer
          simplified = self
          simplified = _compact(simplified) if compact
          simplified = simplified[0] while simplified.kind_of?(Array) && simplified.size <= 1
        end
         _bless(simplified)
      end

      # 暦注検索結果コンテナのハッシュ要素
      #
      # @param [Boolean] compact 余分な nil や空配列を除去するか否か
      # @param [Symbol] symbol 取り出したいハッシュ要素(:note, :value, etc.)
      #
      # @return [Array] ハッシュ要素からなる配列(元の構造が配列であった場合)
      #
      # @note 引数 symbol が Integer の場合は添え字とみなして元の配列の要素を取り出す
      #
      def value(compact=true, symbol=:value)
        if kind_of?(Hash) && !key?(:note)
          # Persistent NotesContainer
          sliced = {}
          each_pair do |key, val|
            sliced[key] = val[symbol]
          end
        else
          # Non-Persistent NotesContainer
          return _bless(slice(symbol)) if symbol.kind_of?(Integer)
          sliced = _dig(self) {|target| target.fetch(symbol, nil)}
        end
        sliced = _bless(sliced)
        compact ? sliced.simplify : sliced
      end

      # 暦注検索結果コンテナのハッシュ要素
      #
      # @param [Symbol] symbol 取り出したいハッシュ要素(:note, :value, etc.)
      #
      # @return [Array] ハッシュ要素からなる配列(元の構造が配列であった場合)
      #
      # @note 引数 symbol が Integer の場合は添え字とみなして元の配列の要素を取り出す
      #
      def [](symbol)
        value(false, symbol)
      end

      # 暦注検索結果コンテナの条件に合う要素を抽出する
      #
      # @param [Hash{Symbol=>String or Regexp}] condition 条件
      # @param [Boolean] compact 余分な nil や空配列を除去するか否か
      #
      # @return [Array] ハッシュ要素からなる配列(元の構造が配列であった場合)
      #
      def subset(condition, compact=true)
        if kind_of?(Hash) && !key?(:note)
          # Persistent NotesContainer
          result = {}
          each_pair do |key, value|
            value = value.subset(condition, compact) if value.kind_of?(NotesContainer)
            result[key] = value if value
          end
        else
          # Non-Persistent NotesContainer
          result = _dig(self) {|target|
            (condition.each_pair {|key, pattern| break nil unless NotesContainer.verify(pattern, target[key])}) ? target : nil
          }
          result = _compact(result) if compact
        end
        _bless(result)
      end

      private

      #
      # 対象オブジェクトを NotesContainer にする
      #
      def _bless(target)
        target.extend(NotesContainer) if target && !equal?(target)
        target
      end

      #
      # 多次元配列要素に対して再帰的に要素を抽出して操作を施す
      #
      def _dig(list, &block)
        return yield(list) unless list.kind_of?(Array)
        list.map {|element| _dig(element, &block)}
      end

      #
      # 多次元配列要素に対して再帰的に作用し nil や空配列を削除する
      #
      def _compact(list)
        return list unless list.kind_of?(Array)
        result = list.map {|element| _compact(element)}.compact
        return result unless result.empty?
        nil
      end
    end

    #
    # 暦法によってイベントの動作を変えるか否か
    #
    CalendarDepend = false

    # @private
    HashProperty = [:event]

    # デフォルトイベント名
    #
    # @return [String]
    #
    # @note イベント名の後ろに数字が使われている場合、数字部分以降はイベントメソッドの引数になります。
    #        SolarTermsクラスで 'term180' は、太陽黄経180度のイベントすなわち秋分を意味します。
    #
    attr_accessor :event
    private :event=

    # デフォルトイベントの指定
    #
    # @param  [String] event 指定値を@eventとした新しいオブジェクトを作る
    #
    # @return [When::CalendarNote]
    #
    def copy(event)
      c = self.clone
      c.send(:event=, event)
      c
    end

    # 典型的なイベントの発生間隔
    #
    # @param  [String] event
    #
    # @return [When::TM::PeriodDuration]
    #
    def duration(event=@event)
      void, event, parameter = event.split(/\A([^\d]+)/)
      send((event+'_delta').downcase.to_sym, parameter)
    end

    # 指定の日時が指定イベントに該当するか?
    #
    # @param  [When::TM::TemporalPosition] date チェックされる日時
    # @param  [String] event チェックするイベント名
    #
    # @return [Boolean]
    #   [ true  - 該当する   ]
    #   [ false - 該当しない ]
    #
    def include?(date, event=@event)
      enum_for(date, :forward, event.downcase).next.include?(date)
    end

    # Enumeratorの生成
    #
    # @overload enum_for(range, options={})
    #   @param [Range, When::Parts::GeometricComplex] range
    #     [ 始点 - range.first ]
    #     [ 終点 - range.last  ]
    #   @param [Hash] options 以下の通り
    #   @option options [String]  :event イベント名(デフォルトは@event)
    #   @option options [Integer] :count_limit 繰り返し回数(デフォルトは指定なし)
    #
    # @overload enum_for(first, direction=:forward, options={})
    #   @param [When::TM::TemporalPosition] first 始点
    #   @param [Symbol] direction (options[:direction]で渡してもよい)
    #     [:forward] 昇順(デフォルト)
    #     [:reverse] 降順
    #   @param [Hash] options 以下の通り
    #   @option options [String]  :event イベント名(デフォルトは@event)
    #   @option options [Integer] :count_limit 繰り返し回数(デフォルトは指定なし)
    #
    # @return [Enumerator]
    #
    def enum_for(*args)
      params  = args.dup
      options = params[-1].kind_of?(Hash) ? params.pop.dup : {}
      options[:event] ||= @event
      self.class::Enumerator.new(*(params[0].kind_of?(Range) ?
        [self, params[0],                        options] :
        [self, params[0], params[1] || :forward, options]))
    end
    alias :to_enum :enum_for

    # 暦注の計算
    #
    # @param [When::TM::TemporalPosition] date 暦注を計算する日時
    # @param [When::TM::TemporalPosition 以外] date When::TM::TemporalPosition に変換して使用する
    # @param [String]  options { :notes => String } という Hash の指定と等価
    # @param [Integer] options { :indices => Integer} という Hash の指定と等価
    # @param [Hash] options 下記のとおり
    # @option options [Integer]              :indices    Integerで指定した暦座標の暦注を計算
    #   [ When::DAY  ( 0) - 日 ]
    #   [ When::MONTH(-1) - 月 ]
    #   [ When::YEAR (-2) - 年 ]
    #
    # @option options [Array<Integer>]       :indices     Integerで指定したすべて暦座標の暦注を計算
    # @option options [nil]                  :indices     すべての暦座標の暦注を計算(デフォルト)
    # @option options [String]               :notes       計算する暦注名(日の暦注)
    # @option options [Integer]              :notes       計算する暦注のビット配列(日の暦注)
    # @option options [Array<Array<String>>] :notes       計算する暦注名の Array の Array
    # @option options [Array<Integer>]       :notes       計算する暦注のビット配列の Array
    # @option options [:all]                 :notes       すべての暦注を計算
    # @option options [:prime, nil]          :notes       @prime に登録した暦注を計算、@prime未登録なら :all と同じ(デフォルト)
    # @option options [Hash]                 :persistence {ユリウス通日=>暦注計算結果}を保持する永続オブジェクト
    # @option options [Hash]                 :conditions  暦注計算の条件
    #     [ :location    => 暦注計算の基準となる場所(String or When::Coordinates::Spatial) ]
    #     [ その他のキー => 個々の暦注クラスごとにその他のキーを使用できる ]
    #
    # @option options [Hash]                 その他のキー date を When::TM::TemporalPosition に変換するために使用する
    #                                        see {When::TM::TemporalPosition._instance}
    #
    # @note CalendarNoteオブジェクト生成時に _normalize メソッド内で @prime 変数を設定しておけば、
    #       本メソッドの :prime オプションで参照される。(Balinese#_normalize等参照)
    #
    # @note 暦注のビットアドレスは、暦注サブクラスのNotes定数の中の定義順序による。
    #       When::CalendarNote クラスの場合 new の引数とした暦注要素リストの定義順序による。
    #       ビットアドレスの値が 1 の暦注が計算対象となる。
    #
    # @return [Array<Array<Hash>>] 暦注計算結果(When::CalendarNote::NotesContainerモジュールをextendしている)
    #     [ :note  => 暦注要素 (When::Coordinates::Residue, String, When::BasicTypes::M17n) ]
    #     [ :value => 暦注の値 (When::Coordinates::Residue, String, When::BasicTypes::M17n, When::TM::TemporalPosition) ]
    #
    # @note
    #   戻り値の :value が When::TM::TemporalPosition の場合、その日時オブジェクトの events[0] に暦注名の入った
    #   暦注に該当する日付である。(例) Christian クラス で easter を計算した場合、当該年の復活祭の日付オブジェクトが返る。
    # @note
    #   暦注サブクラスの場合、暦注要素が増えたり、:note の暦注要素の型が変わったりすることがある。
    #
    def notes(date, options={})
      dates, indices, notes, persistence, conditions, options = _parse_note(date, options)
      retrieved = NotesContainer.retrieve(persistence, date.to_i)
      return retrieved unless retrieved == false
      NotesContainer.register(indices.map {|i|
        next [] unless i <= date.precision
        _note_values(dates, notes[i-1], _all_keys[i-1], _elements[i-1]) do |dates, focused_notes, notes_hash|
          focused_notes.each do |note|
            notes_hash[note] ||= _note_element(note, i, conditions, dates)
          end
          notes_hash
        end
      }, persistence, date.to_i)
    end

    #
    # 暦注の一致 or 不一致
    #
    # @param [When::TM::TemporalPosition] date 暦注を確認する日時
    # @param [When::TM::TemporalPosition 以外] date When::TM::TemporalPosition に変換して使用する
    # @param [String]  options { :notes   => String } または { :value => String } という Hash の指定と等価
    #                 (指定の notes が存在する場合は前者、しない場合は後者)
    # @param [Integer] options { :indices => Integer } という Hash の指定と等価
    # @param [Hash]    options 下記のとおり
    # @option options [暦注の値] :value 確認する暦注の値(または正規表現)
    # @option options [それぞれ] その他 {When::CalendarNote#notes} を参照
    #
    # @return [Boolean]
    #   [ true  - 暦注が一致   ]
    #   [ false - 暦注が不一致 ]
    #
    def note?(date, options={})
      options = _find_note(options)    if options.kind_of?(String) || options.kind_of?(Regexp)
      pattern = options.delete(:value) if options.kind_of?(Hash)
      result  = notes(date, options)
      result.flatten!
      result.delete_if {|hash| hash.empty?}
      return false unless result.size > 0
      return true unless pattern
      result.each do |hash|
        return true if NotesContainer.verify(pattern, hash[:value])
      end
      return false
    end

    # 年の名前を暦注として返す
    # @method year
    #   @return [When::BasicTypes::M17n]

    # 月の名前を暦注として返す
    # @method month
    #   @return [When::BasicTypes::M17n]

    # 日の名前を暦注として返す
    # @method day
    #   @return [When::BasicTypes::M17n]

    #
    # 標準的な暦注として、暦座標の値の名前を暦注として返すメソッドを登録
    #
    # @private
    ['year', 'month', 'day'].each do |c|
      module_eval %Q{
        def #{c}(date)
          date.name('#{c}')
        end
      }
    end

    private

    #
    # 年月日暦注計算の共通処理 - コールバック元
    #
    def _note_values(dates, focused_notes, all_notes, note_objects)
      return [] unless dates && all_notes

      # prepare focused notes
      case focused_notes
      when Integer
        bits = ~focused_notes << 1
        focused_notes = all_notes.dup.delete_if { (bits>>=1)[0] == 1 }
      when []
        focused_notes = all_notes
      when nil
        focused_notes = []
      end
      focused_notes = focused_notes.dup
      not_focused_notes = all_notes - focused_notes
      notes = {}
      not_focused_notes.each do |note|
        notes[note] = true
      end
      focused_notes.each do |note|
        notes[note] = nil
      end

      # update notes
      focused_notes_actual = focused_notes.dup
      notes = yield(dates, focused_notes_actual, notes)
      notes.keys.each do |note|
        notes.delete(note) unless focused_notes_actual.include?(note)
      end

      # return Array of Hash
      focused_notes.map {|note|
        nobj = note_objects[note]
        case notes[note]
        when nil, false ; {}
        when Hash       ; {:note=>nobj.label}.merge(notes[note])
        else
          if nobj.respond_to?(:to_note_hash)
            nobj.to_note_hash(notes[note], dates)
          else
            {:note=>nobj.kind_of?(String) ? nobj : nobj.label, :value=>notes[note]}
          end
        end
      }
    end

    #
    # オブジェクトの正規化
    #
    def _normalize(args=[], options={})
      @_elements = (args.size == 0 && self.class.const_defined?(:Notes)) ?
        When::Parts::Resource.base_uri + self.class.to_s.split(/::/)[1..-1].join('/') + '/Notes' :
        _to_iri(args, options[:prefix] || '_co:')
      if @_elements.kind_of?(Array)
        @_elements.each do |e|
          e.extend LabelAccess
        end
      end
    end

    #
    # 再帰的に配列の中を Resource化する
    #
    def _to_iri(args, prefix)
      args.map {|arg|
        case arg
        when String
          arg, method = $1, $2 if (arg =~ /\A(.+)#([_A-Z0-9]+)\z/i)
          obj = When.Resource(arg, prefix)
          obj = obj.copy(method) if method
          obj.extend NoteElement
          obj
        when Array
          _to_iri(arg, prefix)
        else
          arg
        end
      }
    end

    #
    # 暦日を当該暦注計算用クラスに変換
    #
    #   基底クラスである本クラスでは何もしないで、引数をそのまま返す
    #
    def _to_date_for_note(date)
      date
    end

    # 暦注要素
    #
    # @return [Array<Array<When::Parts::Resource>>]
    #
    def _elements
      @_elements = When.Resource(@_elements) if @_elements.kind_of?(String)
      @_elements
    end

    #
    # [[暦注名]](全暦注)
    #
    # @return [Array<Array<String, When::BasicTypes::M17n>>]
    #
    def _all_keys
      @_all_keys ||= _elements.map { |c|
        c.map {|n|
          n.label.to_s
        }
      }
    end

    #
    # [[暦注名]](主要暦注)
    #
    # @return [Array<Array<When::Parts::Resource>>]
    #
    def _prime_keys
      @prime ||= _all_keys
    end

    #
    # notes メソッドの引数を parse する
    #
    # @return [Array] dates, indices, notes
    #
    def _parse_note(date, options)
      options = 
        case options
        when Hash    ; When::EncodingConversion.to_internal_encoding(options)
        when String  ; {:notes   => When::EncodingConversion.to_internal_encoding(options)}
        when Integer ; {:indices => options}
        else         ; {}
        end
      conditions  = options.delete(:conditions) || {}
      _opt        = options.dup
      persistence = _opt.delete(:persistence)
      notes       = _notes(_opt.delete(:notes)  || :prime)
      indices     = _indices(_opt.delete(:indices), notes)
      _opt.keys.each do |key|
         conditions[key] = _opt[key] unless date.class::FormOptions.include?(key)
      end
      [_to_date_for_note(date), indices, notes, persistence, conditions, options]
    end

    #
    # 暦注を計算する暦座標の配列
    #
    # @return [Array<Integer>]
    #
    def _indices(indices, notes)
      case indices
      when nil   ; (0...notes.size).to_a.reverse.map {|i| -i}
      when Range ; indices.to_a
      when Array ; indices
      else       ; [indices.to_i]
      end
    end

    #
    # notes メソッドの 文字列引数の意味を解釈する
    #
    # @return [Hash] options for note String
    #
    def _find_note(note)
      note = When::EncodingConversion.to_internal_encoding(note)
      _elements.each_index do |index|
        return {:notes=>note, :indices => [-index]} if _elements[-1-index]._pool[note]
      end
      {:value => note}
    end

    #
    # 計算する暦注
    #
    # @return [Array<Array<String>, Integer>]
    #
    def _notes(notes)
      case notes
      when :all    ; _all_keys
      when :prime  ; _prime_keys
      when Integer ; [notes]
      when String  ; [[notes]]
      else         ; notes
      end
    end

    #
    # 暦注の計算
    #
    # @return [Object] 暦注の値
    #
    def _note_element(note, index, conditions, dates)
      void, event, *parameter = note.split(/\A([^\d]+)/)
      method = event.downcase
      parameter << conditions unless conditions.empty?
      return send(method, dates, *parameter) if respond_to?(method)
      root = _elements[index-1][note]
      parent, leaf = root.iri.split('/Notes') if root.kind_of?(When::Parts::Resource)
      parent = When.Resource(parent) if leaf
      return parent.send(method, dates, *parameter) if parent.respond_to?(method)
      root.send(When::Coordinates::PRECISION_NAME[index].downcase, dates)
    end

    #
    # イベントを取得する Enumerator
    #
    class Enumerator < When::Parts::Enumerator

      #
      # 次のイベントを得る
      #
      # @return [When::TM::TemporalPosition]
      #
      def _succ
        @current = (@current==:first) ? @first : event_eval(@current + @delta)
      end

      # オブジェクトの生成
      #
      # @overload initialize(parent, range, options)
      #   @param [When::CalendarNote] parent 暦注アルゴリズム
      #   @param [Range, When::Parts::GeometricComplex] range
      #     [ 始点 - range.first ]
      #     [ 終点 - range.last  ]
      #   @param [Hash] options 以下の通り
      #   @option options [String]  :event イベント名
      #   @option options [Integer] :count_limit 繰り返し回数(デフォルトは指定なし)
      #
      # @overload initialize(parent, first, direction, options)
      #   @param [When::CalendarNote] parent 暦注アルゴリズム
      #   @param [When::TM::TemporalPosition] first 始点
      #   @param [Symbol] direction (options[:direction]で渡してもよい)
      #     [:forward] 昇順(デフォルト)
      #     [:reverse] 降順
      #   @param [Hash] options 以下の通り
      #   @option options [String]  :event イベント名
      #   @option options [Integer] :count_limit 繰り返し回数(デフォルトは指定なし)
      #
      def initialize(*args)
        if args[1].kind_of?(Range)
          parent, range, options = args
          first     = range.first
          last      = range.last
          direction = first < last ? :forward : :reverse
        else
          parent, first, direction, options = args
        end
        direction = options[:direction] if options[:direction]
        @parent = parent
        event   = options.delete(:event)
        case event
        when String ; void, @event, @parameter = event.split(/\A([^\d]+)/)
        else        ;       @event, @parameter = [parent.event, event]
        end
        @delta = @parent.send((@event+'_delta').to_sym, @parameter)
        instance_eval %Q{
          def event_eval(date)
            @parent.#{@event}(date, @parameter)
          end
        }
        date = event_eval(first)
        if direction == :reverse
          @delta = -@delta
          date   = event_eval(first + @delta) if first.to_i < date.to_i
        else
          date   = event_eval(first + @delta) if first.to_i > date.to_i
        end
        range ?
          super(@parent, range.exclude_end? ? date...last : date..last, options) :
          super(@parent, date, direction, options)
      end
    end

    #
    # 暦週
    #
    class Week < CalendarNote

      class << self

        private

        #
        # Fixed Week definitions
        #
        def fixed_week_definitions(month_length=7*4)
          calendar = to_s.split('::').last.sub(/Week$/,'')
          name     = When.CalendarNote(calendar + 'Week/Notes::day::Week')[0].to_s.downcase
          module_eval %Q{
            def #{name}(date, parameter=nil)
              event_name = 'from_#{name}'
              date  = When::#{calendar}.jul_trans(date, {:events=>[event_name], :precision=>When::DAY})
              y,m,d = date.cal_date
              dow   = d <= #{month_length} ? (d-1) % 7 : d - #{month_length-6}
              return date if dow == 0
              date -= When::TM::PeriodDuration.new([0,0,dow])
              date.events = [event_name]
              date
            end

            def week(date, base=nil)
              date    = _to_date_for_note(date)
              y, m, d = date.cal_date
              index   = d <= #{month_length} ? (d-1) % 7 : d - #{month_length-6}
              length  = (base||date).length(When::MONTH) - #{month_length-7}
              {:value=>@days_of_week[index], :position=>[index, length]}
            end

            def _to_date_for_note(date)
              date = When::#{calendar}.jul_trans(date) unless date.frame.equal?(When::#{calendar})
              date
            end

            def _normalize(args=[], options={})
              @event ||= '#{name}'
              super
            end
          }
        end
      end

      #
      # 暦週要素
      #
      class DayOfWeek < When::BasicTypes::M17n

        # 当該暦週要素の標準的な出現間隔
        #
        # @return [Integer]
        #
        attr_reader :delta

        # 所属する暦週オブジェクト
        #
        # @return [When::CalendarNote]
        #
        def week_note
          @week_note ||= When.CalendarNote(iri.split('/Notes').first)
        end

        # 当日または直前に当該暦週要素が現れる日付
        #
        # @return [When::TM::TemporalPosition]
        #
        def just_or_last(date)
          date = week_note._to_date_for_note(date)
          ([parent.child.length, @delta[When::DAY]].max*2).times do
            if equal?(week_note.week(date)[:value])
               date.events ||= []
               date.events << self
               return date
            end
            date -= When::P1D
          end
          raise ArgumentError, "#{self} not found"
        end

        private

        #
        # オブジェクトの正規化
        #
        def initialize(*args)
          super
          @delta = When::P1D * @delta.to_i if @delta && ! @delta.kind_of?(When::TM::Duration)
        end
      end

      #
      # 曜日の名前の一覧
      #
      # @param [When::TM::TemporalPosition] date
      #
      # @return [Array<When::CalendarNote::Week::DayOfWeek>]
      #
      def week_labels(date)
        @days_of_week.child[0...week(date)[:position].last]
      end

      # 七曜
      #
      # @param [When::TM::TemporalPosition] date
      #
      # @return [When::Coordinates::Residue] 七曜
      #
      def common_week(date)
        When.Residue('Week')[date.to_i % 7]
      end

      #
      # オブジェクトの正規化
      #
      def _normalize(args=[], options={})
        super
        @days_of_week ||= When.CalendarNote("#{self.class.to_s.split('::').last}/Notes::day::Week")
        @days_of_week.child.length.times do |index|
          name = @days_of_week.child[index].translate('en').downcase.gsub(/[- ]/, '_')
          self.class.module_eval %Q{
            def #{name}(date, parameter=nil)
              @days_of_week.child[#{index}].just_or_last(date)
            end
          } unless respond_to?(name)
          self.class.module_eval %Q{
            def #{name}_delta(parameter=nil)
              @days_of_week.child[#{index}].delta
            end
          } unless respond_to?(name + '_delta')
        end
      end

      #
      # イベントを取得する Enumerator
      #
      class Enumerator < When::CalendarNote::Enumerator

        #
        # 次のイベントを得る
        #
        # @return [When::TM::TemporalPosition]
        #
        def succ
          value = @current
          plus  = @delta.sign > 0
          if @current==:first
            @first   = event_eval(@first) unless plus
            @current = @first
          else
            if plus
              @current = event_eval(@current + @delta)
            else
              @last    = event_eval(@current - When::P1D)
              @current = event_eval(@current + @delta)
              unless [@current.to_i, value.to_i].include?(@last.to_i)
                @current = @last
                return value
              end
            end
            @current = event_eval(@current + @delta * 2) if @current.to_i == value.to_i
          end
          return value
        end
      end
    end
  end
end
