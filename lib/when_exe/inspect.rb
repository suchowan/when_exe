# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  module Parts::Resource

    #
    # オブジェクトの内容を Hash 化
    #
    # @param [String, Integer] options {When::TM::TemporalPosition#_to_h}に渡す
    # @param [Hash] options 下記のとおり
    # @option options [Numeric] :precision 指定があれば「イベント名(イベント時刻)」出力の時刻を指定の精度に丸める
    # @option options [Boolean] :camel   true ならシンボルを camel case にする
    # @option options [String]  :locale  文字列化の locale(指定なしは M17nオブジェクトに変換)
    # @option options [Boolean] :simple  true ならIRI の先頭部分を簡約表現にする
    # @option options [Boolean] :residue true なら Residue をそのまま出力
    # @option options [Object]  :その他  各クラス#_to_h を参照
    #
    # @return [Hash] (Whenモジュール内のクラスは文字列 or M17n化)
    #
    def to_h(options={})
      _m17n_form(_to_h(options), options.kind_of?(Hash) ? options : {})
    end

    #
    # オブジェクトの内容を JSON 化
    #
    # @param [Object] options #to_h を参照
    #
    # @return [String] to_h 結果を JSON文字列化したもの
    #
    def _to_json(options={})
      JSON.dump(to_h(options))
    end

    #
    # _m17n_form のための要素生成
    # @private
    def _to_hash_value(options={})
       @_pool ? When::Parts::Resource._path_with_prefix(self, options[:simple]) : self
    end

    private
    #
    # 時間位置オブジェクトの内容を Hash 化
    #
    # @param [Object] options #to_h を参照
    #
    # @return [Hash]
    #   各クラスの HashProperty に列挙した属性のうち値が false/nil でないものを
    #     属性 => 値
    #   とする Hash
    #
    def _to_h(options={})
      hash = {}
      self.class::HashProperty.each do |property|
        method, skip = property
        value        = send(method)
        hash[method] = value unless value == skip || value.class == skip
      end
      hash
    end

    #
    # element を 文字列(M17n), Numeric あるいはそれらの Hash や Array に変換したもの
    #
    # @param [Object] element 変換元
    # @param [Hash] options 下記の通り
    # @option options [Numeric] :precision 指定があれば「イベント名(イベント時刻)」出力の時刻を指定の精度に丸める
    # @option options [Boolean] :camel     true ならシンボルを camel case にする
    # @option options [String]  :locale    文字列化の locale(指定なしは M17nオブジェクトに変換)
    # @option options [Boolean] :simple    true ならIRI の先頭部分を簡約表現にする
    # @option options [Boolean] :residue   true なら Residue をそのまま出力
    #
    # @return [Hash, Array] 変換結果
    #
    # @note element.events のある日付は _event_form で変換する
    #
    def _m17n_form(element, options={})
      result = element.respond_to?(:_event_form)    ? element._event_form(self, options[:precision]) :
               element.respond_to?(:_to_hash_value) ? element._to_hash_value(options)                :
               element.respond_to?(:label)         && element.label ?   element.label                :
        case element
        when Hash   ; Hash[*(element.keys.inject([]) { |s, k|
                        s + [_m17n_form(k, options), _m17n_form(element[k], options)]
                      })]
        when Array  ; element.map {|e| _m17n_form(e, options)}
        when Class  ; When::Parts::Resource._path_with_prefix(element, options[:simple])
        when Symbol ; options[:camel] ? element.to_s.split(/_/).map {|e| e.capitalize}.join('').to_sym : element
        when Numeric, FalseClass, TrueClass ; element
        else        ; element.to_s
        end
      result = When::Parts::Locale.translate(result,options[:locale]) if options[:locale] && result.kind_of?(String)
      result
    end
  end

  module Coordinates

    class Residue
      # 多言語対応文字列化
      #
      # @return [When::BasicTypes::M17n]
      #
      def to_m17n
        return m17n(@remainder.to_s)     unless label
        return label + "(#{difference})" unless @format
        label[0...0] + (@format % [label, difference, difference+1])
      end

      # 文字列化
      #
      # @return [String]
      #
      def to_s
        return @remainder.to_s                unless label
        return label.to_s + "(#{difference})" unless @format
        (@format % [label, difference, difference+1]).to_s
      end

      #
      # to_h のための要素生成
      # @private
      def _to_hash_value(options={})
        options[:residue] ? self : to_m17n
      end
    end

    class Pair
      #
      # to_h のための要素生成
      # @private
      def _to_hash_value(options={})
        to_s
      end
    end
  end

  module TM
    class TemporalPosition

      AMPM   = ['AM', 'PM'].map {|half| When::Parts::Resource._instance('_m:CalendarFormats::' + half)}
      Format = {
        'a' => ['%s',   'a'], 'A' => ['%s',   'A'], 'b' => ['%s',   'b'], 'B' => ['%s',   'B'],
        'c' => When::Parts::Resource._instance('_m:CalendarFormats::DateTime'),
        'C' => ['%02d', 'C'], 'd' => ['%02d', 'd'], 'D' => '%m/%d/%y',    'e' => ['%2d',  'd'],
        'E' => ['%s',   'E'], 'F' => ['%s',   'F'], 'G' => ['%d',   'G'], 'g' => ['%02d', 'g'],
        'h' => '%b',          'H' => ['%02d', 'H'], 'I' => ['%02d', 'I'], 'j' => ['%03d', 'j'],
        'k' => ['%2d',  'H'], 'l' => ['%2d',  'I'], 'm' => ['%02d', 'm'], 'M' => ['%02d', 'M'],
        'n' => '\n',          'p' => ['%s',   'p'], 'P' => ['%s',   'P'], 'r' => '%I:%M:%S %p',
        'R' => '%H:%M',       's' => ['%d',   's'], 'S' => ['%02d', 'S'], 't' => '\t',
        'T' => '%H:%M:%S',    'u' => ['%d',   'u'], 'U' => ['%02d', 'U'], 'V' => ['%02d', 'V'],
        'w' => ['%d',   'w'], 'W' => ['%02d', 'W'],
        'x' => When::Parts::Resource._instance('_m:CalendarFormats::Date'),
        'X' => When::Parts::Resource._instance('_m:CalendarFormats::Time'),
        'y' => ['%02d', 'y'], 'Y' => ['%4d',  'Y'], 'z' => ['%s',   'z'], 'Z' => ['%s',   'Z'],
        '+' => '%a %b %d %T %z %Y'
      }

      class << self

        # strftime で用いる書式のハッシュ
        attr_accessor :format

        # When::TM::TemporalPosition Class のグローバルな設定を行う
        #
        # @param [Hash] format strftime で用いる記号の定義
        #
        # @return [void]
        #
        # @note format の指定がない場合、format は Format(モジュール定数)と解釈する
        #
        def _setup_(format=nil)
          @format = format ? Format.merge(format) : Format
        end
      end

      #
      # 暦法名
      #
      # @return [Array<Class>] Class 暦法のクラスオブジェクト
      #
      def calendar_name
        [self.class]
      end

      #
      # 時法名
      #
      # @return [Array<String>] String 時法の IRI
      #
      def clock_name
        [When::Parts::Resource._path_with_prefix(clock)]
      end

      #
      # 参照ラベル
      #
      # @return [When::BasicTypes::M17n]
      #
      def reference_label
        [When::BasicTypes::M17n.new(self.class.to_s.split(/::/)[-1])]
      end

      # 含まれる週
      #
      # @overload week_included(ord, wkst, opt, block)
      #   @param [Numeric, Range] ord 週の番号(default: 今週)
      #     今週を 0 とする週番号(Integer) または週番号の範囲(Range)
      #       -1 - 先週
      #        0 - 今週
      #       +1 - 来週
      #   @param [String] wkst 週の開始曜日(defaultは 月曜)
      #   @param [When::CalendarTypes::CalendarNote] wkst 暦注オブジェクト
      #   @param [Array<When::CalendarTypes::CalendarNote, String>] wkst 暦注オブジェクトとそのイベントメソッド名
      #     (暦注オブジェクトは、そのIRI文字列を指定しても良い)
      #   @param [Hash] opt 下記の通り
      #   @option opt [Range] :Range 上位繰り返し範囲(ユリウス通日...ユリウス通日)
      #   @param [Block] block
      #
      # @note 引数 ord, wkst, opt はそのクラスで位置づけを判断するため、引数の順序は任意(省略も可)
      #
      # @return [Range] 含まれる週を範囲として表現する Range (block 指定なし)
      # @return [Array] 含まれる週の各日をブロックに渡した結果の Array (block 指定あり)
      #
      def week_included(*args)
        begin
          first, length, wkst, opt = _range(args, 'MO')
          case wkst
          when When::Coordinates::Residue
            today = self.floor
            begun = today.succ & wkst >> first-1
            unless @frame.equal?(begun.frame)
              begun  = (@frame ^ today).succ & wkst >> first-1
              middle = today
            end
            ended  = begun.succ & wkst >> length-1
          else
            begun = ended = nil
            if first <= 0
              it = wkst.enum_for(self.floor, :reverse)
              (1-first).times do
                begun = it.next
              end
            else
              it = wkst.enum_for(self.floor, :forward)
              first.times do
                begun = it.next
              end
            end
            it = wkst.enum_for(begun, :forward)
            (length+1).times do
              ended = it.next
            end
          end
          range = middle && block_given? ? [begun...middle, middle...ended] : [begun...ended]

        rescue RangeError
          range = [(@frame ^ self).week_included(*args)]
        end

        return range[0] unless block_given?

        (range.inject([]) {|s,r| s + r.map { |date|
          yield(date, !opt.key?(:Range) || opt[:Range].include?(date.to_i) ? DAY : nil)
        }}).unshift(yield(range[0].first, WEEK)).compact
      end

      # 含まれる月
      #
      # @overload month_included(ord, wkst, opt, block)
      #   @param [Numeric, Range] ord 月の番号(default: 今月)
      #     今月を 0 とする月番号(Integer) または月番号の範囲(Range)
      #       -1 - 先月
      #        0 - 今月
      #       +1 - 来月
      #   @param [String] wkst 週の開始曜日(defaultはなし)
      #   @param [When::CalendarTypes::CalendarNote] wkst 暦注オブジェクト
      #   @param [Array<When::CalendarTypes::CalendarNote, String>] wkst 暦注オブジェクトとそのイベントメソッド名
      #    (暦注オブジェクトは、そのIRI文字列を指定しても良い)
      #   @param [Hash] opt 下記の通り
      #   @option opt [Range] :Range 上位繰り返し範囲(ユリウス通日...ユリウス通日)
      #   @param [Block] block
      #
      # @note 引数 ord, wkst, opt はそのクラスで位置づけを判断するため、引数の順序は任意(省略も可)
      #
      # @return [Range] 含まれる月を範囲として表現する Range (block 指定なし)
      # @return [Array] 含まれる月の各日をブロックに渡した結果の Array (block 指定あり, wkst なし)
      # @return [Array<Array>] 含まれる月の各日をブロックに渡した結果の 七曜表(block 指定あり, wkst あり)
      #
      def month_included(*args, &block)
        first, length, wkst, opt = _range(args)
        if wkst
          (first...(first+length)).map {|i|
            begun = self.floor(MONTH,DAY) + When::TM::PeriodDuration.new([0,i,0])
            ended = begun                 + DurationP1M
            ended = ended.prev until begun.cal_date[MONTH-1] == ended.cal_date[MONTH-1]
            if ended.to_i <= begun.to_i
              ended = begun
              loop do
                succ  = ended.succ
                break unless succ.frame.equal?(begun.frame)
                ended = succ
              end
            end
            dates = [begun]
            loop do
              current = dates[-1].week_included(wkst)
              if current.last.to_i > ended.to_i
                dates[-1] = ended
                break (dates.map {|date| date.week_included(wkst, {:Range=>begun.to_i..ended.to_i}, &block)}).
                      unshift(yield(begun, MONTH)).compact
              elsif wkst.kind_of?(When::Coordinates::Residue)
                dates << dates[-1] + wkst.duration
              else
                it = wkst.enum_for(dates[-1], :forward)
                begin
                  date = it.next
                end while date.to_i == dates[-1].to_i
                date = date.to_cal_date unless date.instance_of?(TM::CalDate)
                dates << date
              end
            end
          }
        else
          begun = self.floor(MONTH,DAY) + When::TM::PeriodDuration.new([0, first,  0])
          ended = begun                 + When::TM::PeriodDuration.new([0, length, 0])
          loop do
            last = ended.prev
            break unless last.cal_date[MONTH-1] == ended.cal_date[MONTH-1]
            ended = last
          end
          if block_given?
            (begun...ended).map do |date|
              yield(date)
            end
          else
            begun...ended
          end
        end
      end

      # 含まれる年
      #
      # @overload month_included(ord, wkst, opt, block)
      #   @param [Numeric, Range] ord 年の番号(default: 今年)
      #     今年を 0 とする年番号(Integer) または年番号の範囲(Range)
      #       -1 - 先年
      #        0 - 今年
      #       +1 - 来年
      #   @param [String] wkst 週の開始曜日(defaultはなし)
      #   @param [When::CalendarTypes::CalendarNote] wkst 暦注オブジェクト
      #   @param [Array<When::CalendarTypes::CalendarNote, String>] wkst 暦注オブジェクトとそのイベントメソッド名
      #     (暦注オブジェクトは、そのIRI文字列を指定しても良い)
      #   @param [Hash] opt 下記の通り
      #   @option opt [Range] :Range 上位繰り返し範囲(ユリウス通日...ユリウス通日)
      #   @param [Block] block
      #
      # @note 引数 ord, wkst, opt はそのクラスで位置づけを判断するため、引数の順序は任意(省略も可)
      #
      # @return [Range] 含まれる年を範囲として表現する Range (block 指定なし)
      # @return [Array] 含まれる年の各日をブロックに渡した結果の Array (block 指定あり, wkst なし)
      # @return [Array<Array>] 含まれる年の各日をブロックに渡した結果の 七曜表(block 指定あり, wkst あり)
      #
      def year_included(*args, &block)
        first, length, wkst, opt = _range(args)
        if wkst
          (first...(first+length)).map {|i|
            begun   = _force_euqal_year(i)
            ended   = _force_euqal_year(i+1)
            current = begun
            result  = [yield(begun, YEAR)]
            while current < ended do
              result << current.month_included(wkst, &block)
              current += DurationP1M
            end
            result.compact
          }
        else
          begun = _force_euqal_year(first)
          ended = _force_euqal_year(first+length)
          if block_given?
            (begun...ended).map do |date|
              yield(date)
            end
          else
            begun...ended
          end
        end
      end

      # 指定の年初を探す
      def _force_euqal_year(diff)
        year = most_significant_coordinate * 1 + diff
        date = (self + When::TM::PeriodDuration.new([diff,0,0])).floor(YEAR,DAY)
        done = {}
        loop do
          case
          when date.most_significant_coordinate * 1 == year
            return date
          when date.most_significant_coordinate * 1 >  year
            next_date = (date-When::DurationP1Y).floor(YEAR,DAY)
            date = (date.to_i == next_date.to_i) ?
                     (date-When::DurationP1Y*2).floor(YEAR,DAY) :
                     next_date
          else
            next_date = (date+When::DurationP1Y).floor(YEAR,DAY)
            date = (date.to_i == next_date.to_i) ?
                     (date+When::DurationP1Y*2).floor(YEAR,DAY) :
                     next_date
          end
          raise RangeError, "can't find target date: #{self} -> #{year}" if done.key?(date.to_i)
          done[date.to_i] = true
        end
      end
      private :_force_euqal_year

      # 範囲の取得
      def _range(args, wkst=nil)
        ord  = 0
        opt  = {}
        args.each do |arg|
          case arg
          when Integer, Range ; ord  = arg
          when Hash           ; opt  = arg
          else                ; wkst = arg
          end
        end
        wkst, method = wkst
        wkst = When::Coordinates::Residue.day_of_week(wkst) || When.CalendarNote(wkst) if wkst
        wkst = wkst[method] if method
        return ord, 1, wkst, opt if ord.kind_of?(Integer)
        length  = ord.last - ord.first
        length += 1 unless ord.exclude_end?
        return ord.first, length, wkst, opt
      end
      private :_range

      #
      # 時間位置オブジェクトの暦注を取得し value を暦注の値 (String, When::BasicTypes::M17n or When::Coordinates::Residue)とする Hash で表現
      #
      # @param [String]  options { :notes   => String  } という Hash の指定と等価
      # @param [Integer] options { :indices => Integer } という Hash の指定と等価
      # @param [Hash] options 下記のとおり
      # @option options [When::CalendarTypes::CalendarNote, String] :calendar_note 暦注を計算する暦注オブジェクトまたはそのIRI
      # @option options [Object] その他のキー {When::CalendarTypes::CalendarNote#notes} を参照
      #
      # @return   [Array<Array<Hash{:note=>note, :value=>value}>>]
      #   [ note  [String, When::BasicTypes::M17n] 暦注名 ]
      #   [ value [String, When::BasicTypes::M17n, When::Coordinates::Residue] 暦注の値 ]
      #
      def notes(options={})
        _m17n_form(_notes(options), options.kind_of?(Hash) ? options : {})
      end

      #
      # 時間位置オブジェクトの暦注を取得
      #
      # @param [String]  options { :notes   => String  } という Hash の指定と等価
      # @param [Integer] options { :indices => Integer } という Hash の指定と等価
      # @param [Hash] options 下記のとおり
      # @option options [When::CalendarTypes::CalendarNote, String] :calendar_note 暦注を計算する暦注オブジェクトまたはそのIRI
      # @option options [Object] その他のキー {When::CalendarTypes::CalendarNote#notes} を参照
      #
      # @return   [Array<Array<Hash{:note=>note, :value=>value}>>]
      #   [ note  [String, When::BasicTypes::M17n, When::Coordinates::Residue] 暦注名 ]
      #   [ value [String, When::BasicTypes::M17n, When::Coordinates::Residue, When::TM::TemporalPosition] 暦注の値 ]
      #
      # @note
      #   When::TM::TemporalPosition の場合、events[0] に暦注名の入ったその暦注に該当する日付である。
      #   (例) Christian クラス で easter を計算した場合、当該年の復活祭の日付オブジェクトが返る。
      #   暦注サブクラスの場合、要素が増えたり、:note の暦注要素の型が変わったりすることがある。
      #
      def _notes(options={})
        _calendar_note(options).notes(self, options)
      end

      #
      # 暦注の一致 or 不一致
      #
      # @param [String]  options { :notes   => String  }  または { :value => String } という Hash の指定と等価
      #   (指定の notes が存在する場合は前者、しない場合は後者)
      # @param [Integer] options { :indices => Integer } という Hash の指定と等価
      # @param [Hash] options 下記のとおり
      # @option options [Object] :value 確認する暦注の値
      # @option options [Object] その他のキー {When::CalendarTypes::CalendarNote#notes} を参照
      #
      # @return [Boolean]
      #   [ true  - 暦注が一致   ]
      #   [ false - 暦注が不一致 ]
      #
      def note?(options={})
        _calendar_note(options).note?(self, options)
      end

      # 指定の日時が指定イベントに該当するか?
      #
      # @param [String]  options { :notes   => String  }  または  { :notes   => String } または { :value => String } という Hash の指定と等価
      #   (指定の event が存在する場合は前者、指定の notes が存在する場合は中央、しない場合は後者)
      # @param [Integer] options { :indices => Integer } という Hash の指定と等価
      # @param [Hash] options 下記のとおり
      # @option options [String] :event 確認するイベント名
      # @option options [Object] :value 確認する暦注の値
      # @option options [Object] その他のキー {When::CalendarTypes::CalendarNote#notes} を参照
      #
      # @return [Boolean]
      #   [ true  - 該当する   ]
      #   [ false - 該当しない ]
      #
      def is?(options=nil)
        calendar_note = _calendar_note(options)
        event = 
          case options
          when String ; options
          when Hash   ; options.delete(:event)
          else        ; calendar_note.event
          end
        event.to_s =~ /^([^\d]+)/ && calendar_note.respond_to?($1.downcase) ?
          calendar_note.include?(self, event) :
          calendar_note.note?(self,  options)
      end

      #
      # 時間位置オブジェクトの内容を Hash 化
      #
      # @param [String]  options { :notes   => String  } という Hash の指定と等価
      # @param [Integer] options { :indices => Integer } という Hash の指定と等価
      # @param [Hash] options 下記のとおり
      # @option options [When::CalendarTypes::CalendarNote, String] :calendar_note 暦注を計算する暦注オブジェクトまたはそのIRI
      # @option options [Object] その他のキー {When::CalendarTypes::CalendarNote#notes} を参照
      #
      # @return [Hash]
      #   - :sdn       日の通し番号 - ユリウス通日(Integer)
      #   - :calendar  calendar_name の結果       - Array<暦法または暦年代(, 付属情報..)>
      #   - :notes     Hash (の Array (の Array)) - _notes(options)
      #   clock が定義されている場合、さらに下記も出力する
      #   - :clock     時計(When::TM::Clock, When::V::Timezone, When::Parts::Timezone)
      #   - :clk_time  to_clock_time の結果       - ( 日, 時, 分, 秒 )
      #   - :dynamical dynamical_time / 秒
      #   - :universal universal_time / 秒
      #
      def _to_h(options={})
        hash = super.update({
          :sdn      => to_i,
          :calendar => calendar_name,
          :notes    => _notes(options)
        })

        hash.update({
          :clock     => clock,
          :clk_time  => to_clock_time,
          :dynamical => dynamical_time * clock.second,
          :universal => universal_time * clock.second
        }) if clock
        hash
      end

      # 多言語対応文字列化 - When.exe Standard Representation により多言語対応文字列化する
      #
      # @overload to_m17n()
      #
      # @return [When::BasicTypes::M17n]
      #
      def to_m17n(*args)
        return m17n(I[@indeterminated_position]) if [Unknown, Max, Min].include?(@indeterminated_position)
        return m17n(_to_s)
      end
      # @private
      alias :_to_s :to_s

      # 文字列化 - When.exe Standard Representation により文字列化する
      #
      # @overload to_s()
      #
      # @return [String]
      #
      def to_s(*args)
        to_m17n(*args).to_s
      end

      # URI要素化 - URI表現の要素として用いる形式に変換
      #
      # @overload to_uri()
      #
      # @return [String]
      #
      def to_uri(*args)
        _to_uri(to_s(*args))
      end

      # URI要素化(日付のみ) - 日付の部分をURI表現の要素として用いる形式に変換
      #
      # @overload to_date_uri()
      #
      # @return [String]
      #
      def to_date_uri(*args)
        _to_uri(to_s(*args).sub(/T([-+][\d:]+|Z|MTC)$/,''))
      end

      def _to_uri(date)
        uri  = date.gsub(/\./, '-').gsub(/%/, '@')
        uri += '^^' + @frame.iri.split(/\//)[-1] unless @calendar_era_name || @frame == When.Calendar('Gregorian')
        uri
      end
      private :_to_uri

      # 指定の書式による多言語対応文字列化 - pattern で指定した書式で多言語対応文字列化する
      #
      # @param [When::BasicTypes::M17n] pattern 書式
      # @param [String, Array<String>] locale 文字列化を行う locale の指定(デフォルト : オブジェクト生成時に保持している locale すべて)
      #
      # @return [When::BasicTypes::M17n]
      #
      def strftime(pattern, locale=nil)
        pattern = m17n([pattern]*self.keys.length, nil, nil, {:locale=>self.keys}) if pattern.instance_of?(String)
        pattern._printf([], locale) do |k, *t|
          _strftime(k, pattern, [''])
        end
      end

      # strftime で扱う項の値を取得する
      #
      # @param [String] designator 項目名
      # @param [String] locale 文字列化を行う場合の locale の指定(デフォルト to_s(代表値))
      # @param [Integer] d 日付が'年月日'、時刻が'時分秒'でない表現のための桁位置変更指示
      #   [ 年月に付く場合 - 大きいほうに位置をずらす ]
      #   [ 分秒に付く場合 - 小さいほうに位置をずらす ]
      # @param [Integer] e 月の省略名の文字数
      #
      # @return [designator に依存]
      #
      def term(designator, locale=nil, d=0, e=3)
        designator = When::Parts::Locale.translate(designator,locale)
        case designator
                                                                # 現在のロケールにおける曜日の省略名
        when 'a' ; When.Resource('_co:CommonResidue::Abbr_Day')[to_i % 7].translate(locale)
                                                                # 現在のロケールにおける曜日の完全な名前
        when 'A' ; When.Resource('_co:CommonResidue::Week')[to_i % 7].label.translate(locale)
        when 'b' ; (name(MONTH-d).translate(locale))[/^.{1,#{e}}/] # 現在のロケールにおける月の省略名
        when 'B' ; (name(MONTH-d).translate(locale))            # 現在のロケールにおける月の完全な名前
        when 'C' ; year(d).div(100)                             # 世紀 (西暦年の上 2 桁)
        when 'd' ; day(d)                                       # 月内通算日
        when 'E' ; Array(calendar_era_name)[0].translate(locale)# 年号
        when 'F' ; floor(DAY).to_m17n.translate(locale)         # ISO 8601 形式の日付フォーマット
        when 'G' ; cwyear(d)                                    # ISO 8601 週単位表記の年
        when 'g' ; cwyear(d) % 100                              # ISO 8601 週単位表記の年の下2桁
        when 'H' ; hour(d)                                      # 24 時間表記での時
        when 'I' ; (hour(d)-1) % 12 + 1                         # 12 時間表記での時
        when 'j' ; yday(d)                                      # 年の初めから通算の日数
        when 'm' ; month(d)                                     # 月
        when 'M' ; minute(d)                                    # 分
        when 'p' ; (AMPM[hour(d).to_i.div(12)].translate(locale)).upcase   # 現在のロケールにおける「午前」「午後」に相当する文字列
        when 'P' ; (AMPM[hour(d).to_i.div(12)].translate(locale)).downcase # 前項を小文字で表記
        when 's' ; universal_time / Duration::SECOND      # 紀元 (1970-01-01T00:00:00Z) からの秒数
        when 'S' ; second(d)                                    # 秒 (10 進数表記)
        when 'u' ; cwday                                        # 週の何番目の日か(月曜日を 1 とする)
        when 'U' ; yweek(6, 7, d)                               # 年の初めからの通算の週番号(日曜日始まり)
        when 'V' ; cweek(d)                                     # ISO 8601 形式での年の始めからの週番号
        when 'w' ; wday                                         # 週の何番目の日 か(日曜日を 0 とする)
        when 'W' ; yweek(0, 7, d)                               # 年の初めからの通算の週番号(月曜日始まり)
        when 'y' ; year(d) % 100                                # 西暦の下2桁 (世紀部分を含まない年)
        when 'Y' ; year(d)                                      # 世紀部分を含めた ( 4 桁の) 西暦年
        when 'z' ; clock.to_basic                               # +hhmm や -hhmm の形式のタイムゾーン
        when 'Z' ; When::Parts::Locale.translate(clock.tzname[0],locale) # タイムゾーンまたはゾーン名または省略名
        else     ; designator
        end
      end

      private

      # 指定の書式による多言語対応文字列化
      #
      # @param [String] locale 文字列化を行う locale
      # @param [When::BasicTypes::M17n] pattern 書式
      #
      # @return [Array] 書式と文字列化項目からなる配列
      #
      def _strftime(locale, pattern, t)
        format, *terms = t
        pattern = pattern.translate(locale) if pattern.kind_of?(When::BasicTypes::M17n)
        pattern.scan(/(%[O\d]*(?:\.(\d+))?.)|(.)/) do |c,e,s|
          case c
          when /^%%/
            format += '%%'
          when /^%/
            action = (TemporalPosition.format || Format)[c[-1..-1]]
            case action
            when Array
              format += action[0]
              terms  << term(action[1], locale, c[1..-2].to_i, e||3)
            when String
              action = action.translate(locale) if action.kind_of?(When::BasicTypes::M17n)
              if (action =~ /%/)
                format, *terms = _strftime(locale, action, [format] + terms)
              else
                format += action
              end
            end
          else
            format += s
          end
        end
        [format] + terms
      end

      #
      # 使用する When::CalendarTypes::CalendarNote を決定する
      #
      #   options に副作用があることに注意
      #
      def _calendar_note(options)
        calendar_note   = options.delete(:calendar_note) if options.kind_of?(Hash)
        calendar_note ||= @frame ? @frame.note : 'JulianDayNotes'
        When.CalendarNote(calendar_note)
      end
    end

    class JulianDate

      # 多言語対応文字列化 - ユリウス日を多言語対応文字列化する
      #
      # @param [Integer] precision どの桁まで多言語対応文字列化するか、分解能で指定する
      #
      # @return [When::BasicTypes::M17n]
      #
      def to_m17n(precision=@precision)
        return m17n(to_s(precision))
      end

      # 文字列化 - ユリウス日を文字列化する
      #
      # @param [Integer] precision どの桁まで多言語対応文字列化するか、分解能で指定する
      #
      # @return [String]
      #
      def to_s(precision=@precision)
        coordinate = (precision <= When::DAY) ? to_i : to_f
        coordinate.to_s
      end
    end

    class ClockTime

      # 要素の多言語対応文字列化
      #
      # @param [Integer] index 多言語対応文字列化する要素の指定
      # @param [When::BasicTypes::M17n] format 多言語対応文字列化の書式
      #
      # @return [When::BasicTypes::M17n]
      #
      def name(index, format=nil)
        digit      = _digit(index) {|digit| digit > DAY}
        coordinate = @clk_time[digit]
        return m17n(format % coordinate) if format

        indices  = @frame.indices[digit-1]
        if indices
          trunk  = indices.trunk
          branch = indices.branch
        end
        format = branch ? m17n("%02d:") : "%02d"
        return m17n(format % coordinate) unless trunk
        trunk  = trunk[coordinate * 1]
        return m17n(trunk) unless branch
        return trunk.prefix(branch[coordinate * 0])
      end

      # 多言語対応文字列化 - When.exe Standard Representation により多言語対応文字列化する
      #
      # @param [Integer] precision どの桁まで多言語対応文字列化するか、分解能で指定する
      #
      # @return [When::BasicTypes::M17n]
      #
      def to_m17n(precision=@precision)
        time  = m17n('T' + _time_to_s(precision))
        if @frame
          time += @frame.zone unless Clock.is_local_time_set? && @frame.equal?(Clock.local_time)
        end
        return time
      end

      # 文字列化 - When.exe Standard Representation により文字列化する
      #
      # @param [Integer] precision どの桁まで多言語対応文字列化するか、分解能で指定する
      #
      # @return [String]
      #
      def to_s(precision=@precision)
        time  = 'T' + _time_to_s(precision)
        if @frame
          time += @frame.zone unless Clock.is_local_time_set? && @frame.equal?(Clock.local_time)
        end
        return time
      end

      # 時
      #
      # @param [Integer] d  時刻が'時分秒'でない表現のための桁位置変更指示(小さいほうに位置をずらす)
      #
      # @return [Numeric] 自身の「時」
      #
      def hour(d=0)
        @clk_time[HOUR+d]
      end

      # 分
      #
      # @param [Integer] d  時刻が'時分秒'でない表現のための桁位置変更指示(小さいほうに位置をずらす)
      #
      #
      # @return [Numeric] 自身の「分」
      #
      def minute(d=0)
        @clk_time[MINUTE+d]
      end
      alias :min :minute

      # 秒
      #
      # @param [Integer] d  時刻が'時分秒'でない表現のための桁位置変更指示(小さいほうに位置をずらす)
      #
      #
      # @return [Numeric] 自身の「秒」
      #
      def second(d=0)
        @clk_time[SECOND+d]
      end
      alias :sec :second

      #protected
      #
      # 時間帯以外の部分の文字列化
      #
      # @param [Integer] precision どの桁まで多言語対応文字列化するか、分解能で指定する
      #
      # @return [String]
      #
      # @private
      def _time_to_s(precision=@precision)
        terms   = []
        format  = ''
        format += Pair::DL2[@clk_time[0] * 0] || ':' if @frame.pair[0] || @clk_time[0].kind_of?(Pair)

        # 時分
        digits = [@clk_time.length-2, precision].min
        if digits > 0
          terms  += @clk_time[1..-1]
          format += "%02d:" * digits
          format  = format[0..-2] if precision == digits
        end

        # 秒
        digits  = [precision - @clk_time.length + 1, STRING-SECOND].min
        if digits == 0
          format += "%02d"
        elsif digits > 0
          factor  = 10**digits
          terms[-1] = ((@clk_time[-1] + 1E-6) * factor).floor.to_f / factor  # 切り捨て(10で割る丸めガードあり)
          format += "%02.#{digits}f"
        end

        # 結果
        time = Pair._format([format] + terms)
        time.sub(/([^\d])(\d)\./, '\10\2.')
      end

      #
      # to_h のための要素生成
      # @private
      def _to_hash_value(options={})
        clk_time.map {|e| _m17n_form(e, options) }
      end
    end

    class CalDate

      #
      # 暦法名
      #
      # @return [Array] ( name, epoch, reverse, go back )
      #   - name         暦法または暦年代 ({When::TM::Calendar}, {When::TM::CalendarEra})
      #   - epoch        暦元             (Integer)
      #   - reverse      暦年の順序       (Boolean)
      #      [ false, nil 昇順 ]
      #      [ true       降順 ]
      #   - go back      参照イベントより前の暦日か(Boolean)
      #      [ false, nil 否   ]
      #      [ true       然り ]
      #
      def calendar_name
        void, epoch, reverse, back = @calendar_era_name
        name = [@calendar_era || @frame, epoch, reverse, back]
        name.pop until name[-1]
        return name
      end

      #
      # 参照ラベル
      #
      # @return [When::BasicTypes::M17n]
      #
      def reference_label
        return @calendar_era.hierarchy.map {|e| e.label} if @calendar_era
        return [@frame.label] if @frame.label
        [When::BasicTypes::M17n.new(@frame.class.to_s.split(/::/)[-1])]
      end

      #
      # Hash 化
      #
      # @param [String]  options { :notes   => String  } という Hash の指定と等価
      # @param [Integer] options { :indices => Integer } という Hash の指定と等価
      # @param [Hash] options 下記のとおり
      # @option options [When::CalendarTypes::CalendarNote, String] :calendar_note 暦注を計算する暦注オブジェクトまたはそのIRI
      # @option options [Object] その他のキー {When::CalendarTypes::CalendarNote#notes} を参照
      #
      # @return [Hash]
      #   - :calendar calendar_name の結果 ( name, epoch, reverse, go back )
      #     - name     暦法または暦年代 ({When::TM::Calendar}, {When::TM::CalendarEra})
      #     - epoch    暦元             (Integer)
      #     - reverse  暦年の順序       (Boolean)
      #        [ false, nil 昇順 ]
      #        [ true       降順 ]
      #     - go back      参照イベントより前の暦日か(Boolean)
      #        [ false, nil 否   ]
      #        [ true       然り ]
      #   - :cal_date cal_date の内容 (year, month, day)
      #      [ year  - 年 ({Numeric}) ]
      #      [ month - 月 ({Numeric}) ]
      #      [ day   - 日 ({Numeric}) ]
      #   - :clk_time to_clock_time の結果 ( 日, 時, 分, 秒 )
      #   - :notes  Hash (の Array (の Array)) - _notes(options)
      #
      def _to_h(options={})
        super.update({:cal_date=>@cal_date})
      end

      # 要素の多言語対応文字列化
      #
      # @param [Integer] index 多言語対応文字列化する要素の指定
      # @param [When::BasicTypes::M17n] format 多言語対応文字列化の書式
      #
      # @return [When::BasicTypes::M17n]
      #
      def name(index, format=nil)
        digit      = _digit(index) {|digit| digit <= DAY}
        coordinate = @cal_date[digit-1]
        return m17n(format % coordinate) if format

        indices = @frame.indices[digit-1]
        if indices
          trunk  = indices.trunk
          branch = indices.branch
        end
        format = branch ? m17n("%02d-") : "%02d"
        return m17n(format % coordinate) unless trunk
        trunk  = trunk[coordinate * 1]
        return m17n(trunk) unless branch
        return trunk.prefix(branch[coordinate * 0||0])
      end

      # 日
      #
      # @param [Integer] d  日付が'年月日'でない表現のための桁位置変更指示(大きいほうに位置をずらす)
      #
      # @return [Numeric] 自身の「日」
      #
      def day(d=0)
        @cal_date[DAY-1-d]
      end

      # 月内通日
      #
      # @param [Integer] d  日付が'年月日'でない表現のための桁位置変更指示(大きいほうに位置をずらす)
      #
      # @return [Numeric] 自身の「月内通日」(1始まり)
      #
      def mday(d=0)
        to_i - floor(MONTH-d).to_i + 1
      end

      # 年内通日
      #
      # @param [Integer] d  日付が'年月日'でない表現のための桁位置変更指示(大きいほうに位置をずらす)
      #
      # @return [Numeric] 自身の「年内通日」(1始まり)
      #
      def yday(d=0)
        to_i - floor(YEAR-d).to_i + 1
      end

      # 七曜
      #
      # @return [Numeric] 自身の「七曜」(日曜 0 始まり)
      #
      def wday
        (to_i + 1) % 7
      end

      # 七曜(暦週)
      #
      # @return [Numeric] 自身の「七曜」(月曜 1 始まり)
      #
      def cwday
        (to_i  % 7) + 1
      end

      # 暦週
      #
      # @param [Integer] d  日付が'年月日'でない表現のための桁位置変更指示(大きいほうに位置をずらす)
      #
      # @return [Numeric] 自身の「暦週」
      #
      def cweek(d=0)
        [1,0,-1].each do |i|
          start = ((self + PeriodDuration.new(i, YEAR-d)).floor(YEAR-d,DAY) + PeriodDuration.new(4, DAY)) & Residue.new(0,7,-1)
          return ((to_i - start.to_i).div 7) + 1 if self >= start
        end
        raise IndexError, 'Cannot decide year number'
      end

      # 月内通週
      #
      # @param [Integer] w 週の最初の曜日(0:月,.., 6:日)
      # @param [Integer] m 一週間の日数
      # @param [Integer] d  日付が'年月日'でない表現のための桁位置変更指示(大きいほうに位置をずらす)
      #
      # @return [Numeric] 自身の「月内通週」(その月に完全に含まれる最初の週を1とする)
      #
      def mweek(w=6, m=7, d=0)
        1 + (to_i - (floor(MONTH-d,DAY) & Residue.new(w,m)).to_i).div(7)
      end

      # 年内通週
      #
      # @param [Integer] w 週の最初の曜日(0:月,.., 6:日)
      # @param [Integer] m 一週間の日数
      # @param [Integer] d  日付が'年月日'でない表現のための桁位置変更指示(大きいほうに位置をずらす)
      #
      # @return [Numeric]
      #     自身の「年内通週」(その年に完全に含まれる最初の週を1とする)
      #
      def yweek(w=6, m=7, d=0)
        1 + (to_i - (floor(YEAR-d,DAY) & Residue.new(w,m)).to_i).div(7)
      end

      # 月
      #
      # @param [Integer] d  日付が'年月日'でない表現のための桁位置変更指示(大きいほうに位置をずらす)
      #
      # @return [Numeric] 自身の「月」
      #
      def month(d=0)
        @cal_date[MONTH-1-d]
      end
      alias :mon :month

      # 年内通月
      #
      # @param [Integer] d1  日付が'年月日'でない表現のための桁位置変更指示-年用(大きいほうに位置をずらす)
      # @param [Integer] d2  日付が'年月日'でない表現のための桁位置変更指示-月用(大きいほうに位置をずらす)
      #
      # @return [Numeric] 自身の「年内通月」(1始まり)
      #
      def ymon(d1=0, d2=0)
        current = floor(YEAR-d1, MONTH-d2)
        @frame._length(@cal_date[(YEAR-1-d1)...(MONTH-1-d2)]).times do |i|
          return i+1 if current == self
          current = current.succ
        end
        raise IndexError, 'Cannot decide month number'
      end

      # 年
      #
      # @param [Integer] d  日付が'年月日'でない表現のための桁位置変更指示(大きいほうに位置をずらす)
      #
      # @return [Numeric] 自身の「年」
      #
      def year(d=0)
        @cal_date[YEAR-1-d]
      end

      # 暦週の年
      #
      # @param [Integer] d  日付が'年月日'でない表現のための桁位置変更指示(大きいほうに位置をずらす)
      #
      # @return [Numeric] 自身の「暦週の年」
      #
      def cwyear(d=0)
        [1,0,-1].each do |i|
          start = ((self + PeriodDuration.new(i, YEAR-d)).floor(YEAR-d,DAY) + PeriodDuration.new(4, DAY)) & Residue.new(0,7,-1)
          return year(d)+i if self >= start
        end
        raise IndexError, 'Cannot decide year number'
      end

      # 多言語対応文字列化 - When.exe Standard Representation により多言語対応文字列化する
      #
      # @param [Integer] precision どの桁まで多言語対応文字列化するか、分解能で指定する
      # @param [false]   round 常に切り捨てる(DateAndTimeとの互換性のためのダミーの引数)
      #
      # @return [When::BasicTypes::M17n]
      #
      def to_m17n(precision=@precision, round=false)
        date = m17n(_date_to_s(precision))
        return date unless @calendar_era
        return _parent_labels.inject(m17n(@calendar_era_name[0])) {|era_name, parent|
          era_name.prefix(m17n(parent) + '::')
        } + date
      end

      # 文字列化 - When.exe Standard Representation により文字列化する
      #
      # @param [Integer] precision どの桁まで多言語対応文字列化するか、分解能で指定する
      # @param [false]   round 常に切り捨てる(DateAndTimeとの互換性のためのダミーの引数)
      #
      # @return [String]
      #
      def to_s(precision=@precision, round=false)
        date = _date_to_s(precision)
        return date unless @calendar_era
        return _parent_labels.inject(@calendar_era_name[0].to_s) {|era_name, parent|
          parent.to_s + '::' + era_name
        } + date
      end

      # event を 文字列化 - 日時で与えられた event を文字列化する
      #
      # @param [When::TM::TemporalPosition] other 時系の歩度を比較する基準(nilは比較しない)
      # @param [Numeric] round_precision イベント名(イベント)出力の場合の時刻の丸め位置(nilなら丸めない)
      #
      # @return [String]
      #
      # @note
      #   events 配列なし          - 日時をそのまま文字列化
      #   日時の精度が日より細かい - イベント名(イベント時刻)
      #   日時の精度が日           - イベント名(当日までの経過日数)
      #
      def _event_form(other=nil, round_precision=nil)
        return to_m17n unless events
        return events[0] + '(' + _clk_time_for_inspect(round_precision).to_s(round_precision || precision)[/[:*=0-9]+/] + ')' if precision > When::DAY
        return events[0] unless other
        other = JulianDate.dynamical_time(other.dynamical_time,
                  {:time_standard=>time_standard}) unless time_standard.rate_of_clock == other.time_standard.rate_of_clock
        events[0] + '('  + (other.to_i - to_i).to_s + ')'
      end

      private

      # 日付の年号に曖昧性がある場合の親年号の label の Array
      #
      # @return [Array<String>]
      #
      def _parent_labels
        return [] unless (area   = When::TM::CalendarEra[nil]) &&
                         (period = area[nil])
        list = []
        era  = @calendar_era
        while (labels = period[era.label.to_s]) &&
              (epoch  = labels[era.epoch_year]) &&
              (epoch.size > 1) &&
              (parent = era.parent).respond_to?(:epoch_year)
          list << parent.label
          era = parent
        end
        list
      end

      # 日付の年号以外の部分を文字列化する
      #
      # @param [Integer] precision どの桁まで多言語対応文字列化するか、分解能で指定する
      #
      # @return [String]
      #
      def _date_to_s(precision)
        # 準備
        precision = [precision, 1 - @cal_date.length].max
        precision = [precision, DAY].min
        terms  = []
        ext_dg = [(@extra_year_digits||1).to_i, 0].max

        # 年
        year_by_epoch = @cal_date[0]
        if @calendar_era_name
          era, epoch, reverse = @calendar_era_name
          year_in_term        = reverse ? -year_by_epoch : year_by_epoch
          year_by_calendar    = epoch + year_by_epoch if epoch
          terms  << year_in_term
          format = (0..99) === (year_in_term * 1) ? "%02d." : "%04d."
          if year_by_calendar && year_by_calendar != year_in_term
            terms  << (year_by_calendar * 1)
            format += "(%04d)"
          end
        else
          terms  << year_by_epoch
          format = (0..9999) === (year_by_epoch * 1) ? "%04d." : "%+0#{5+ext_dg}d."
        end

        # 月日
        ((1-@cal_date.length)..-1).each do |i|
          break if (i >= precision)
          terms  << @cal_date[i]
          format += "%02d."
        end

        # 結果
        date = Pair._format([format] + terms)
        date.sub!(/([^\d])\(([-+\d]+)\)/, '(\2)\1') if era
        date = date[0..-2] unless @frame.pair[precision-1] || date[-1..-1] != '.'
        date.gsub!(/\./, '-') if (@frame.indices.length <= DefaultDateIndices.length) && !era
        return date
      end
    end

    class DateAndTime < CalDate

      # 要素の多言語対応文字列化
      #
      # @param [Integer] index 多言語対応文字列化する要素の指定
      # @param [When::BasicTypes::M17n] format 多言語対応文字列化の書式
      #
      # @return [When::BasicTypes::M17n]
      #
      def name(index, format=nil)
        digit = _digit(index)
        (digit <= DAY) ? super : @clk_time.name(digit, format)
      end

      # 多言語対応文字列化 - When.exe Standard Representation により多言語対応文字列化する
      #
      # @param [Integer] precision どの桁まで多言語対応文字列化するか、分解能で指定する
      # @param [true, false] round 指定の桁までで丸める(true)か, 切り捨てる(false)か
      # @note 丸めるのは precision が When::DAY よりも高精度の場合のみである
      #
      # @return [When::BasicTypes::M17n]
      #
      def to_m17n(precision=@precision, round=false)
        super + _clk_time_for_inspect(round ? precision : nil).to_m17n(precision)
      end

      # 文字列化 -When.exe Standard Representation により文字列化する
      #
      # @param [Integer] precision どの桁まで多言語対応文字列化するか、分解能で指定する
      # @param [true, false] round 指定の桁までで丸める(true)か, 切り捨てる(false)か
      # @note 丸めるのは precision が When::DAY よりも高精度の場合のみである
      #
      # @return [String]
      #
      def to_s(precision=@precision, round=false)
        super + _clk_time_for_inspect(round ? precision : nil).to_s(precision)
      end

      # 出力に使用する clk_time の作成
      def _clk_time_for_inspect(precision)
        return @clk_time unless precision && precision > When::DAY
        base = self + When::TM::Duration.new(@clk_time.frame._round_value(precision))
        base.clk_time.clk_time[When::HOUR] = @clk_time.clk_time[When::HOUR] + 1 unless self.to_i == base.to_i
        return base.clk_time
      end
      private :_clk_time_for_inspect

      # 時
      #
      # @param [Integer] d  時刻が'時分秒'でない表現のための桁位置変更指示(小さいほうに位置をずらす)
      #
      # @return [Numeric] 自身の「時」
      #
      def hour(d=0)
        @clk_time.hour(d)
      end

      # 分
      #
      # @param [Integer] d  時刻が'時分秒'でない表現のための桁位置変更指示(小さいほうに位置をずらす)
      #
      # @return [Numeric] 自身の「分」
      #
      def minute(d=0)
        @clk_time.minute(d)
      end
      alias :min :minute

      # 秒
      #
      # @param [Integer] d  時刻が'時分秒'でない表現のための桁位置変更指示(小さいほうに位置をずらす)
      #
      # @return [Numeric] 自身の「秒」
      #
      def second(d=0)
        @clk_time.second(d)
      end
      alias :sec :second
    end
  end
end
