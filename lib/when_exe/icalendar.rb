# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

#
#  An implementation of RFC 5545 - iCalendar ( http://tools.ietf.org/html/rfc5545 )
#
# == Extensions of RFC 5545
# === Multi Calendar
# * CALSCALE Property can specify calendars other than GREGORIAN
#     The value of CALSCALE Property is capitalized.
# * Date and Time Representation of DTSTART Property
#     When.exe Standard Representation is available except ','. (',' cannot be used as a decimal mark)
#     Calendar can be specified by a notation '^^calnedar' or '^calnedar'.
#    (same as epoch of When::TM::CalendarEra)
# === The extension of RRULE property
# * FREQ=duration
#     When.exe Standard Representation により duration を指定できる。
#     ただし、この指定は BYxxx とは共存できない。
# * BYHOUR=h(,..)
#     h に When.exe Standard Representation を使用できる
#     example: 'BYHOUR=1,2'
#       夏時間から標準時間への切り替え時に 夏時間の1時,標準時間の2時 を生成
#     example: 'BYHOUR=1,1=,2'
#       夏時間から標準時間への切り替え時に 夏時間の1時,標準時間の1時,標準時間の2時 を生成
#     他のソフトウェアとの互換性を損なう可能性があるが、本ライブラリは両方の動作の違いを
#     記述できる必要があると判断。
# * BYDAY/c=n*e±s(,..)
#     c で指定したWhen::CalendarTypes::CalendarNoteオブジェクトのイベントeのうち、
#     n番目のものについて、その±s日目
#     デフォルトは n=all, s=0, cとeは省略不可(eはcのメソッドとして定義されている必要がある)
#     example: 'BYDAY/Christian=easter-2' は、キリスト教の聖金曜日
#     example: 'BYDAY/SolarTerms=term180' は、秋分日(太陽黄経が180度になる日)
# * BYDAY/d=n*m±s(,..);DAYST=b
#     ユリウス日をdで除した余りがmになる日のうち、n番目のものについて、その±s日目
#     m は b を基点として計算する
#     デフォルトは n=all, s=0, b=0, dとmは省略不可
#     /d がない場合、次項のBYWEEKDAYとして扱い、RFC 5545に対する互換性を確保する
# * BYWEEKDAY=n*m±s(,..);WKST=b
#     ユリウス日を7で除した余りがmになる日のうち、n番目のものについて、その±s日目
#     m は b を基点として計算する(mとbはともに文字列'MO','TU','WE','TH','FR','SA','SU'で指定)
#     デフォルトは n=all, s=0, b=MO, mは省略不可
# * BYYEAR/d=n*m±s(,..);YEARST=b
#     通年をdで除した余りがmになる年のうち、n番目のものについて、その±s年目
#     m は b を基点として計算する
#     デフォルトは n=all, s=0, b=4, dとmは省略不可
#     通年の意味は暦法に依存する
# === icd 形式の多言語対応
# * NAMESPACE Property を追加
# * LOCALE Property を追加
# * SUMMARY Property で[...]表現を多言語対応文字列として解釈する
# === Content Lines
#   RFC 5545 3.1 Content Lines では、記述が75文字を超える場合、改行してインデントする。
#   本ライブラリでは文字数によらず、BEGIN:の次の行を基準にして、より深いインデントがある場合は、
#   論理的1行を物理的に分割したものとみなして解釈している。実質的には上位互換と判断している
#
# == Limitations from RFC 5545
# * VALARM
#   VENENT や VTODO に包含されている VALARM は無視される。
#   包含元のイベントからの差分時刻での計算に対応していないため。
# * RRULE
#   BYYEARDAY, BYMONTHDAY, BYDAY が存在する場合 BYWEEKDAY の n と s は指定できない。
#   BYYEARDAY, BYMONTHDAY, BYWEEKDAY が存在する場合 BYDAY の n と s は指定できない。
module When::V

  # iCalendar を構成するクラス群の共通抽象クラス
  #
  #   RFC 5545 のクラスは、有無のチェックを除いてProperty の扱いが共通なので、
  #   Property の扱いを、本クラスにまとめて記述している。
  #
  class Root < When::BasicTypes::Object

    Properties      = [[],[],[],[],[]]
    Classes         = nil
    DefaultUnique   = ['calscale', 'namespace', 'locale']
    DefaultOptional = ['x_prop', 'iana_prop']
    AwareProperties = DefaultUnique + 
                      ['tzoffsetfrom', 'tzoffsetto', 'tzname',
                       'dtstart', 'dtend', 'due',
                       'repeat', 'duration',
                       'rrule', 'rdate', 'exdate', 'exevent',
                       'summary', 'freebusy']

    #
    # iCalendar クラス群の属性
    # @return [Hash] { String => When::Parts::Resource::ContentLine }
    #
    attr_reader :property

    #
    # デフォルトのWhen::TM::Calendar
    # @return [When::TM::Calendar]
    #
    # @note
    #   RFC 5545 では、'GREGORIAN' のみ指定可能としている。
    #   CALSCALE Property 文字列を capitalize したものに、
    #   prefix _c:(=http://hosi.org/When/CalendarTypes/)を補い
    #   When::TM::Calendar オブジェクトの定義を取得する。
    #
    attr_reader :calscale

    # 指定の日時を含むか?
    #
    # @param [When::TM::TemporalPosition] date
    #
    # @return [Boolean]
    #   [ true  - 含む     ]
    #   [ false - 含まない ]
    #
    def include?(date)
      first = enum_for(date).next
      return first.include?(date) if first.kind_of?(When::Parts::GeometricComplex)
      return first == date if first.precision <= date.precision
      return false
    end

    # イテレータの生成
    # @private
    def _enumerator(*args)
      options = When::Parts::Enumerator._options(args)
      args << options
      exdate  = options[:exdate]

      enumerators = _enumerator_list(args)
      raise ArgumentError, "No enumerator exists" if (enumerators.length==0)

      # Enumerator の生成
      enumerator =
        if (enumerators.length==1 && exdate.node.size==0)
          enumerators[0]
        else
          options[:exdate] = exdate
          When::Parts::Enumerator::Integrated.new(self, enumerators, *args)
        end
      if ::Object.const_defined?(:Date) && (args[0].kind_of?(Range) ? args[0].first : args[0]).kind_of?(::Date)
        enumerator.instance_eval %Q{
          alias :_succ_of_super :succ
          def succ
            result = _succ_of_super
            case result
            when When::TM::DateAndTime ; result.to_date_time
            when When::TM::CalDate     ; result.to_date
            else                       ; result
            end
          end
        }
      end
      enumerator
    end
    alias :to_enum  :_enumerator
    alias :enum_for :_enumerator

    private

    # オブジェクトの生成
    def initialize(*args)
      # option の取得
      options = args[-1].kind_of?(Hash) ? args.pop.dup : {}

      # 包含関係
      @_pool = {}
      @_pool['..'] = options['..']

      # parsed 部の属性化
      @property  = {}
      @namespace = @_pool['..'].respond_to?(:namespace) ? @_pool['..'].namespace : {}
      if options['.']
        _parse_from_file(options)
      else
        _parse_from_code(options)
      end
      _set_variables

      # 属性の存在チェック & 設定
      _initialize_attributes(_attribute_appearance(self.class::Properties)) # .const_get(:Properties)))

      # 包含オブジェクトの生成
      _child(options, self.class::Classes) #.const_get(:Classes))
    end

    # ファイルからの属性読み込み
    def _parse_from_file(options)
      options['.'].each do |v|
        v = When::Parts::Resource._parse(v)
        _parse_altid(@property, v) if v.kind_of?(ContentLine)
      end

      keys = @property.keys
      if keys.delete('namespace')
        content = @property['namespace'][0]
        @property['namespace'] = content if @property['namespace'].size == 1
        if content.attribute['prefix']
          begin
            @namespace[content.attribute['prefix'].object] = content.object
          end while (content = content.same_altid)
        else
          @namespace.update(When::Parts::Locale._namespace(content.object))
        end
      end

      keys.each do |key|
        @property[key].each do |content|
          content.object = When::BasicTypes::M17n.new(content, @namespace, []) if content.same_altid
        end
        @property[key] = @property[key][0] if @property[key].size == 1
      end
    end

    # コードからの属性読み込み
    def _parse_from_code(options)
      options.each_pair do |key, value|
        @property[key] = ContentLine.new(key, value) if key.kind_of?(String)
      end
      @property['dtstamp'] ||= ContentLine.new('dtstamp',
                                           When.now.to_s.gsub(/[-:]/,'')) if self.class::Properties[0].index('dtstamp')
      @property['uid']     ||= ContentLine.new('uid',
                                           @property['dtstamp'].object + '-auto') if self.class::Properties[0].index('uid')
    end

    # @propertyの個別属性化
    def _set_variables
      @property.each_key do |key|
        next if respond_to?(key)
        instance_eval %Q{
          def #{key}
            @property['#{key}'].object
          end
        }
      end
    end

    # 包含オブジェクトの生成
    def _child(options, classes)
      @child = []
      opt = options.dup
      opt['..'] = self
      if options['.']
        options['.'].each do |v|
          next unless (v.kind_of?(Array) && v[0].kind_of?(Class))
          raise ArgumentError, "The #{self.class} cannot include #{v[0]}" if (classes && !classes.index(v[0]))
          opt['.'] = v
          obj = v[0].new(opt)
          @child << obj
          @_pool[obj.label.to_s] = obj
        end
      else
        options.each_pair do |key, value|
          next unless key.kind_of?(Class)
          obj = key.new(opt.merge(value))
          @child << obj
          @_pool[obj.label.to_s] = obj
        end
      end
    end

    # attribute の出現数のチェック
    def _attribute_appearance(attributes)

      require_unique, require, unique, almost_unique, optional = attributes

      # REQUIRED but MUST NOT occur more than once
      require_unique.each do |key|
        unless @property[key].kind_of?(When::Parts::Resource::ContentLine)
          raise ArgumentError, "The #{key.upcase.gsub(/_/,'-')} is REQUIRED but MUST NOT occur more than once"
        end
      end

      # REQUIRED and MAY occur more than once
      require.each do |key|
        unless @property[key]
          raise ArgumentError, "The #{key.upcase.gsub(/_/,'-')} is REQUIRED and MAY occur more than once"
        end
        @property[key] = [@property[key]] if (@property[key].kind_of?(When::Parts::Resource::ContentLine))
      end

      # OPTIONAL but MUST NOT occur more than once
      (unique + DefaultUnique).each do |key|
        if (@property[key].kind_of?(Array))
          raise ArgumentError, "The #{key.upcase.gsub(/_/,'-')} is OPTIONAL but MUST NOT occur more than once"
        end
      end

      # OPTIONAL but SHOULD NOT occur more than once
      almost_unique.each do |key|
        if (@property[key].kind_of?(Array))
          raise ArgumentError, "The #{key.upcase.gsub(/_/,'-')} is OPTIONAL but SHOULD NOT occur more than once"
        end
      end

      # OPTIONAL and MAY occur more than once
      (optional + DefaultOptional).each do |key|
        @property[key] = [@property[key]] if (@property[key].kind_of?(When::Parts::Resource::ContentLine))
      end

      # Other Properties
      allowed_attributes = require_unique + require + unique + almost_unique + optional + DefaultUnique + DefaultOptional
      #@property.each_key do |key|
      #  raise ArgumentError, "The #{key.upcase.gsub(/_/,'-')} is not allowed" unless allowed_attributes.index(key)
      #end

      return (AwareProperties & allowed_attributes)
    end

    # attribute の設定
    def _initialize_attributes(aware)

      # calscale の登録
      @calscale = @_pool['..'].calscale if @_pool['..'].respond_to?(:calscale)
      @calscale = @property['calscale'].object if @property['calscale']
      @calscale = When.Resource((@calscale||'GREGORIAN').capitalize, '_c:') unless (@calscale.kind_of?(When::TM::Calendar))

      # locale の登録
      @locale = @_pool['..'].respond_to?(:locale) ? @_pool['..'].locale : []
      @locale = When::Parts::Locale._locale(@property['locale'].object) if @property['locale']

      # tzoffsetfrom の登録
      if @property['tzoffsetfrom']
        object = @property['tzoffsetfrom'].object
        new_zone = object.to_s   # See RFC5545 page.66
        @tzoffsetfrom = When.Clock(object).dup
        @tzoffsetfrom.tz_prop = self
      else
        new_zone = ''
      end

      # tzoffsetto, tzname の登録
      if @property['tzoffsetto']
        clock = When.Clock(@property['tzoffsetto'].object).dup
        clock.tz_prop = self
        @tzname = []
        (@property['tzname']||[]).each do |tzname|
          tz = tzname.object # ↓このチェックは不十分?
          When::TM::Clock.synchronize do
            raise ArgumentError, "Conflict tzname: #{tz}" if When::TM::Clock[tz] &&
                                                             When::TM::Clock[tz].universal_time != clock.universal_time
            When::TM::Clock[tz] = clock
          end
          @tzname << tz
        end
        @tzoffsetto = clock
        @tzname = @tzname[0] if (@tzname.length <= 1)
      end

      # due の登録
      date_options = {:frame=>@calscale}
      if @property['due']
        @due = When.when?(@property['due'].attribute['.']         ? @property['due'].attribute['.'] + new_zone :
                                                                    @property['due'].object, date_options)
      end

      # dtstart の登録
      if @property['dtstart']
        @dtstart = When.when?(@property['dtstart'].attribute['.'] ? @property['dtstart'].attribute['.'] + new_zone :
                                                                    @property['dtstart'].object, date_options)
        @dtstart.clk_time.frame = @tzoffsetfrom unless (new_zone == '') # See RFC5545 page.66

        @first_occurrence = "Include"
      else
        @dtstart = When.now(@due||{})
        @first_occurrence = "Don't care"
      end

      # dtend の登録
      if @property['dtend']
        @dtend = When.when?(@property['dtend'].attribute['.']     ? @property['dtend'].attribute['.'] + new_zone :
                                                                    @property['dtend'].object, date_options)
      end

      # repeat の登録
      if aware.index('repeat')
        raise ArgumentError, "The DURATION MUST occur" if ( @property['repeat'] && !@property['duration'])
        raise ArgumentError, "The REPEAT MUST occur"   if (!@property['repeat'] &&  @property['duration'])
        if @property['repeat']
          @repeat = @property['repeat'].object.to_i
        end
      end

      # duration の登録
      if aware.index('duration')
        if @property['duration']
          raise ArgumentError, "The DURATION should appear with DTSTART" unless (@dtstart||@repeat)
          raise ArgumentError, "The DTEND and DURATION are exclusive"    if (@dtend)
          raise ArgumentError, "The DUE and DURATION are exclusive"      if (@due)
          duration = @property['duration'].object
          duration = When.Duration(duration) unless duration.kind_of?(Numeric)
        elsif @dtend
          duration = When::TM::IntervalLength.difference(@dtend, @dtstart)
        end
        duration_precision = When::Coordinates::PERIOD[duration.to_s]
        @duration = duration unless (duration_precision && @dtstart.precision <= duration_precision)
      end

      # rrule の登録
      if aware.index('rrule')
        @rrule = []
        @rrule = @property['rrule'].map {|v| Event::Enumerator._decode_rule(v.object, @dtstart, new_zone)} if @property['rrule']
      end

      # rdate の登録
      if aware.index('rdate')
        @rdate   = []
        @exevent = []
        @exdate  = When::Parts::GeometricComplex.new()
        if (@property['rdate'])
          @rdate = @property['rdate'].inject([]) do |sum, v|
            if v.kind_of?(When::Parts::Resource::ContentLine)
              if new_zone == ''
                sum += When.when?(v.attribute['.'].split(/,/), date_options)
              else
                sum += When.when?((v.attribute['.'].split(/,/).map {|d| d + new_zone}), date_options)
              end
            else
              sum << v
            end
          end
        end
        unless new_zone == ''
          @rdate.each do |date|
            date.clk_time.frame = @tzoffsetto
          end
        end
      end

      # exdate の登録
      if @property['exdate']
        dates  = @property['exdate'].inject([]) do |sum, v|
          if v.kind_of?(When::Parts::Resource::ContentLine)
            sum += When.when?(v.attribute['.'].split(/,/), date_options)
          else
            sum << v
          end
        end
        dates.each do |date|
          @exdate |= date
        end
      end

      # exevent の登録
      if @property['exevent']
        @exevent += @property['exevent'].object.split(/,/)
      end

      # summary の登録
      term_options = {'namespace'=>@namespace, 'locale'=>@locale}
      if @property['summary']
        text = @property['summary'].object
        @summary = (text =~ /^\[/) ? m17n(text, nil, nil, term_options) : text
      end

      # freebusy の登録
      if aware.index('freebusy')
        @freebusy  = []
        if (@property['freebusy'])
          @freebusy = @property['freebusy'].inject([]) do |sum, v|
            if v.kind_of?(When::Parts::Resource::ContentLine)
              sum += When.when?((v.attribute['.']||v.object).split(/,/), date_options)
            else
              sum << v
            end
          end
        end
        @rdate = @freebusy
        @rrule = []
      end
    end
  end

  # ひとつの ics 形式ファイルをまとめて保持する
  #
  #   BEGIN:VCALENADR...END:VCALENDAR のブロックに対応
  #
  class Calendar < Root

    Properties= [['prodid', 'version'], [],
                 ['method'], [], []]
    Classes   = nil

    attr_accessor :child
    protected :child=

    # When::V::Event の検索
    #
    # @param [Hash] keys { key => value }
    #
    # @return [When::V::Calendar] key で指定する Property の値が value に一致する When::V::Event のみを持つ self の複製を作る
    #   (一致の判断は演算子 === による)
    #
    def intersection(keys={})
      copy = self.dup
      copy.child = @child.select {|ev|
        if ev.kind_of?(Event)
          keys.each_pair do |key, value|
            case value
            when String ; break unless ev.property[key].object.index(value)
            when Regexp ; break unless (ev.property[key].object =~ value)
            end
          end
        else
          true
        end
      }
      return copy
    end

    # @private
    def _enumerator_list(args)
      (@child.reject {|el| !el.kind_of?(Event)}).inject([]) { |sum, ev|
        sum += ev._enumerator_list(args)
      }
    end
  end

  # Eventを定義する
  #
  #   BEGIN:VEVENT...END:VEVENT のブロックに対応
  #
  class Event < Root

    Properties= [['dtstamp', 'uid', 'dtstart'], [],
                 ['class', 'created', 'description', 'geo',
                  'last_modified', 'location', 'organizer', 'priority',
                  'seq', 'status', 'summary', 'transp',
                  'url', 'recurid', 'dtend', 'duration'], [],
                 ['rrule',
                  'attach', 'attendee', 'categories', 'comment', 'contact',
                  'exdate', 'exevent', 'rstatus', 'related',
                  'resources', 'rdate']]
    # Classes   = [V::Root, V::Alarm]

    class << self
      include When::Parts::Resource::Pool

      # 最大打ち切り時間
      # @return [When::TM::IntervalLength]
      attr_reader :default_until

      # When::V::Event Class のグローバルな設定を行う
      #
      # @param [When::TM::IntervalLength] default_until
      #
      # @note
      #   RRULE の条件が成立しない場合に無限ループにおちいることを避けるため
      #   他に指定がなくとも、計算を打ち切るようにしている。その打ち切り時間
      #   (When.now + default_until)を本メソッドで指定している。
      #   default_until の指定がない場合、default_until は 1000年と解釈する。
      #
      # @note
      #   本メソッドでマルチスレッド対応の管理変数の初期化を行っている。
      #   このため、本メソッド自体はスレッドセーフでない。
      #
      def _setup_(default_until=nil)
        @_lock_ = Mutex.new if When.multi_thread
        @_pool = {}
        @default_until = default_until
      end
    end

    # SUMMARY Property
    #
    # @return [String, When::BasicTypes::M17n]
    #
    attr_reader :summary

    # RRULE Property
    #
    # @return [Hash]
    #
    # @note
    #   iCalendar の RRULE を Hash に展開したものを保持している。
    #   RRULE は、年のサイクルや7日以外の日のサイクルおよび夏時間の切り替えを
    #   扱えるように RFC 5545 から拡張されている。
    #
    attr_reader :rrule

    # DTSTART Property
    #
    # @return [When::TM::TemporalPosition, When::Parts::GeometricComplex]
    #
    attr_reader :dtstart

    # DTEND Property
    #
    # @return [When::TM::TemporalPosition, When::Parts::GeometricComplex]
    #
    attr_reader :dtend

    # DURATION Property
    #
    # @return [When::TM::Duration]
    #
    # @note
    #   DTSTART Property が保持する When::TM::TemporalPosition の分解能で識別できない
    #   時間差はイベント継続中とみなすので、例えば分解能が DAY の場合、DURATION Porperty
    #   に When.Duration('P1D')と指定する必要はない。
    #   DTEND Property が指定された場合、DURATION Property に変換して保持する。
    #
    attr_reader :duration

    # EXDATE Property
    #
    # @return [When::Parts::GeometricComplex]
    #
    attr_reader :exdate

    # RDATE Property
    #
    # @return [Array<When::TM::TemporalPosition, When::Parts::GeometricComplex>]
    #
    # @note
    #   RRULE の COUNT が指定されている場合、後で途中の系列を抜き出すような指定をされても
    #   よいように、Enumerator 生成時にCOUNT分の計算をして RDATE Property に登録する。
    #   このため、COUNTに大きな値を指定すると、Enumerator 生成に予想外の時間がかかることが
    #   ある。
    #
    attr_reader :rdate

    # DTSTART Property を first occurrence とするか
    #
    # @return [String]
    #   [ 'Include' - first occurrence とする ]
    #   [ 'Exclude' - first occurrence しない ]
    #   [ それ以外  - RRULE により該当する場合に first occurrence とする ]
    #
    # @note
    #   RFC 5545 では 'Include' となっているが、それ以外の振る舞いが可能なように拡張。
    #
    attr_reader :first_occurrence # See RFC 5545 [Page 41] 3rd paragraph

    # ユニーク識別名 - UID Property をユニーク識別名とする。
    #
    # @return [String]
    #
    def label
      @label ||= @property['uid'].object
    end

    # 最後のイベント
    #
    # @return [When::TM::TemporalPosition, When::Parts::GeometricComplex]
    #
    # @note
    #   無限に続く可能性がある場合、When::TimeValue::Max(+Infinity)
    #
    def dtstop
      return @dtstop if (@dtstop)

      @dtstop = @dtstart
      @rdate.each do |date|
        @dtstop = date if (date > @dtstop)
      end
      @rrule.each do |rrule|
        unless (rrule['UNTIL'])
          @dtstop = When::TimeValue::Max
          break
        end
        @dtstop = rrule['UNTIL'] if (rrule['UNTIL'] > @dtstop)
      end
      return @dtstop
    end

    # 順次実行
    #
    # @overload each()
    #
    # @overload each(range, count_limit=nil)
    #   @param [Range, When::Parts::GeometricComplex] range 始点-range.first, 終点-range.last
    #   @param [Integer] count_limit 繰り返し回数(デフォルトは指定なし)
    #
    # @overload each(first, direction, count_limit)
    #   @param [When::TM::TemporalPosition] first  始点
    #   @param [Symbol]  direction   :forward - 昇順, :reverse - 降順
    #   @param [Integer] count_limit 繰り返し回数(デフォルトは指定なし)
    #
    # @return [Enumerator]
    #
    # @note block が与えられている場合、yield する。
    #
    def each(*args, &block)
      if args.length > 0
        super
      else
        super(@dtstart, &block)
      end
    end

    # @private
    def _enumerator_list(args)
      options = args[-1]
      rdate = @rdate.dup
      options[:exdate]  = @exdate.dup if @exdate
      options[:exevent] = @exevent.map {|v| self[v]} if @exevent
      case (options['1st'] || @first_occurrence).capitalize
      when 'Include' ; rdate.unshift(@duration ? When::Parts::GeometricComplex.new(@dtstart, @duration) : @dtstart)
      when 'Exclude' ; options[:exdate] |= @dtstart
      end

      # 配下の Enumerator の初期化
      enumerators = []
      @rrule.each do |rrule|
        if @due && !(rrule['UNTIL'] && rrule['UNTIL'] <= @due)
          rrule = rrule.dup
          rrule['UNTIL'] = @due
        end
        if rrule['COUNT']
          Event::Enumerator.new(self, rrule, @dtstart, @duration, @dtstart, options).each {|date| rdate << date }
        else
          enumerators << Event::Enumerator.new(self, rrule, @dtstart, @duration, *args)
        end
      end

      enumerators.unshift(When::Parts::Enumerator::Array.new(self, rdate, *args[1..-1])) if (rdate.length > 0)

      return enumerators
    end
  end

  # Alarm を定義する
  #
  #   BEGIN:VALARM...END:VALARM のブロックに対応
  #
  class Alarm < Event

    # ユニーク識別名 - ACTION Property をユニーク識別名とする。
    # @return [String]
    def label
      @label ||= @property['action'].object # TODO
    end

    # @private
    def initialize(options)
      # 包含関係
      @_pool = {}
      @_pool['..'] = options['..']

      # parsed 部の属性化
      _parsed(options)

      # 属性の存在チェック
      case (@property['action'].kind_of?(When::Parts::Resource::ContentLine) && @property['action'].object)
      when 'AUDIO'
        aware = _attribute_appearance([
          ['action', 'trigger'], [],
          ['duration', 'repeat', 'attach'], [], []])
      when 'DISPLAY'
        aware = _attribute_appearance([
          ['action', 'description', 'trigger'], [],
          ['duration', 'repeat'], [], []])
      when 'EMAIL'
        aware = _attribute_appearance([
          ['action', 'description', 'trigger', 'summary'], ['attendee'],
          ['duration', 'repeat'], [], ['attach']])
      else
        raise ArgumentError, "The ACTION is invalid"
      end

      # 属性の設定
      _initialize_attributes(aware)

      # 包含オブジェクトがないことの確認
      _child(options, [])
    end
  end

  # Todo を定義する
  #
  #   BEGIN:VTODO...END:VTODO のブロックに対応
  #
  class Todo < Event
    Properties= [['dtstamp', 'uid'], [],
                 ['class', 'completed', 'created', 'description',
                  'dtstart', 'geo', 'last_modified', 'location', 'organizer',
                  'percent', 'priority', 'recurid', 'seq', 'status',
                  'summary', 'url'], ['due', 'duration'],
                 ['rrule',
                  'attach', 'attendee', 'categories', 'comment', 'contact',
                  'exdate', 'exevent', 'rstatus', 'related', 'resources',
                  'rdate']]
    Classes   = [Alarm]
  end

  # Journal を定義する
  #
  #   BEGIN:VJOURNAL...END:VJOURNAL のブロックに対応
  #
  class Journal < Event

    Properties= [['dtstamp', 'uid'], [],
                 ['class', 'created', 'dtstart',
                  'last_modified', 'organizer', 'recurid', 'seq',
                  'status', 'summary', 'url'], [],
                 ['rrule',
                  'attach', 'attendee', 'categories', 'comment', 'contact',
                  'description', 'exdate', 'exevent', 'related', 'rdate',
                  'rstatus']]
    Classes   = []
  end

  # Freebusy を定義する
  #
  #   BEGIN:VFREEBUSY...END:VFREEBUSY のブロックに対応
  #
  class Freebusy < Event

    Properties= [['dtstamp', 'uid'], [],
                 ['contact', 'dtstart', 'dtend',
                  'organizer', 'url'], [],
                 ['attendee', 'comment', 'freebusy', 'rstatus']]
    Classes   = []

    attr_reader :freebusy
  end

  #
  # Timezone Property の共通抽象クラス
  #
  class TimezoneProperty < Event

    Properties= [['dtstart', 'tzoffsetto', 'tzoffsetfrom'], [],
                 [], [], ['rrule',
                  'comment', 'rdate', 'tzname']]
    Classes   = []

    # TZNAME Property
    #
    # @return [Array<String(サブクラスであるWhen::BasicTypes::M17nでもよい)>]
    #
    # @note
    #   RFC 5545 は複数個の指定を許しているため、Array としている。
    #
    attr_reader :tzname

    # TZOFFSETFROM Property
    #
    # @return [When::TM::Clock]
    #
    # @note
    #   イベント時刻前の時間帯
    #   保持する When::TM::Clock の tz_prop は、本オブジェクトを参照している。
    #
    attr_reader :tzoffsetfrom

    # TZOFFSETTO Property
    #
    # @return [When::TM::Clock]
    #
    # @note
    #    イベント時刻後の時間帯
    #    保持する When::TM::Clock の tz_prop は、本オブジェクトを参照している。
    #
    attr_reader :tzoffsetto

    # ユニーク識別名 - DTSTART Property をユニーク識別名とする
    # @return [String]
    def label
      @label ||= @property['dtstart'].attribute['.']
    end
  end

  # 標準時間帯を定義する
  #
  #   BEGIN:STANDARD...END:STANDARD のブロックに対応
  #
  class Standard < TimezoneProperty
  end

  # 夏時間帯を定義する
  #
  #   BEGIN:DAYLIGHT...END:DAYLIGHT のブロックに対応
  #
  class Daylight < TimezoneProperty
  end

  # Timezone を定義する
  #
  #   BEGIN:VTIMEZONE...END:VTIMEZONE のブロックに対応
  #
  class Timezone < Root

    Properties= [['tzid'], [],
                 ['last_modified', 'tzurl', 'x_lic_location'], [], []]
    Classes   = [Standard, Daylight]

    class << self; include When::Parts::Resource::Pool; end

    include When::Parts::Timezone::Base

    # ユニーク識別名 - TZID Property をユニーク識別名とする
    # @return [String]
    def label
      @label ||= @property['tzid'].object
    end

    # 同一の時間帯を用いた期間
    #
    # @param [When::TM::TemporalPositionに変換可能な型] current_date  期間に含まれる日時
    #
    # @return [Range]
    #   [ 期間が過去または未来に対して無限に続く場合は、GeometricComplex ]
    #   [ 期間が有界の場合は、start...end という形式の Range ]
    #
    def current_period(current_date=Time.now)
      current_date = When.when?(current_date) unless current_date.kind_of?(When::TM::TemporalPosition)
      period = _tz_period(current_date.universal_time)
      range  = period[1]
      return range if range.kind_of?(Range)
      GeometricComplex.new([period], !range)
    end

    # @private
    def _daylight(time)
      raise ArgumentError, "Needless daylight saving time evaluation" unless _need_validate
      frame, cal_date, clk_time = time
      time   = frame.to_universal_time(cal_date, clk_time, @standard) if clk_time
      ndate  = _neighbor_event_date(time)
      nprop  = ndate.clock.tz_prop
      time   = frame.to_universal_time(cal_date, clk_time, nprop.tzoffsetfrom) if clk_time && !@standard.equal?(nprop.tzoffsetfrom)
      (time >= ndate.universal_time) ? nprop.tzoffsetto : nprop.tzoffsetfrom
    end

    # @private
    def _need_validate
      (@difference != 0)
    end

    private

    # オブジェクトの生成
    def initialize(options)
      super

      @child.each do |prop|
        @dtstart = prop.dtstart if (@dtstart==nil || prop.dtstart < @dtstart)
        @dtstop  = prop.dtstop  unless (prop.dtstop.kind_of?(When::TimeValue) &&
                                        @dtstop.kind_of?(When::TimeValue)     &&
                                        prop.dtstop <= @dtstop)
        [prop.tzoffsetfrom, prop.tzoffsetto].each do |tz|
          @daylight = tz if (@daylight==nil || tz.universal_time < @daylight.universal_time)
          @standard = tz if (@standard==nil || tz.universal_time > @standard.universal_time)
        end
      end
      @difference = @standard.universal_time - @daylight.universal_time

      name   = @property['tzid'].object
      case self.class[name]
      when nil   ; self.class[name]  =  self
      when Array ; self.class[name] <<  self
      else       ; self.class[name]  = [self.class[name], self]
      end

      @_lock_ = Mutex.new if When.multi_thread
      @range  = []
    end

    # 指定の日時に最も近い、時間帯変更イベントの日時
    #
    # @param [Numeric] current_time 捜索の基点の日時の universal time
    #
    # @return [When::TM::TemporalPosition] 捜索の基点の日時に最も近い、時間帯変更イベントの日時
    #
    def _neighbor_event_date(current_time)
      _tz_period(current_time)[0]
    end

    def _tz_period(current_time)
      return [@dtstart, false] if (current_time <= @dtstart.universal_time)
      return [@dtstop,  true ] if (@dtstop.kind_of?(When::TimeValue) &&
                                    current_time >= @dtstop.universal_time)

      # Thread 要注意 - @range は生成後に更新
      synchronize do
        @range.each do |range|
          from = current_time - range.first.universal_time
          to   = range.last.universal_time  - current_time
          return [(from < to) ? range.first : range.last, range] if (from >= 0 && to > 0)
        end
        early = _neighbor(current_time, :reverse)
        late  = _neighbor(current_time, :forward)
        from  = current_time - early.universal_time
        to    = late.universal_time  - current_time
        @range << (early...late)
        return [(from < to) ? early : late, @range[-1]]
      end
    end

    def _neighbor(current_time, direction)
      event   = nil
      minimum = nil
      @child.each do |prop|
        date = prop.enum_for(current_time, direction, 1).succ
        if (date)
          diff = (date.universal_time - current_time).abs
          if (minimum == nil || minimum > diff)
            event   = date 
            minimum = diff
          end
        end
      end
      return event
    end
  end

  class Event < Root

    Classes   = [Root, Alarm]

    #
    # When::V::Event が使用する Enumerator
    #
    class Enumerator < When::Parts::Enumerator

      include When
      include Coordinates

      FreqIndex     = {'YEARLY'   =>YEAR, 'MONTHLY'   =>MONTH,
                       'WEEKLY'   =>WEEK, 'DAILY'     =>DAY,
                       'HOURLY'   =>HOUR, 'MINUTELY'  =>MINUTE, 'SECONDLY' =>SECOND}
      PostFreqIndex = {'BYYEAR'   =>YEAR, 'BYMONTH'   =>MONTH,  'BYWEEKNO' =>WEEK,
                       'BYYEARDAY'=>DAY,  'BYMONTHDAY'=>DAY,
                       'BYWEEKDAY'=>DAY,  'BYDAY'     =>DAY,
                       'BYHOUR'   =>HOUR, 'BYMINUTE'  =>MINUTE, 'BYSECOND' =>SECOND}

      # RRULE Property - iCalendar の RRULE を Hash に展開したものを保持している
      # @return [Hash]
      attr_reader :rule

      # 繰り返しの始点
      # @return [When::TM::TemporalPosition, When::Parts::GeometricComplex]
      attr_reader :dtstart

      # 多重繰り返しロジック
      # @return [Array<When::V::Event::Enumerator::Logic>]
      attr_reader :logics

      # 多重繰り返しの現在状態
      # @return [Array<When::V::Event::Enumerator::Step>]
      attr_accessor :steps
      protected :steps=

      #
      # 巻き戻す
      #
      # @return [rewind された self]
      #
      def _rewind
        @steps = [Step.new(_first_seed(@first, @dtstart))]
        super
      end

      private

      # オブジェクトの生成
      def initialize(*args)
        @options = When::Parts::Enumerator._options(args)
        @exdate  = @options.delete(:exdate)
        @exevent = @options.delete(:exevent)
        @parent, @rule, @dtstart, @duration, *args = args
        @dtstart = When.when?(@dtstart)
        @rule    = self.class._decode_rule(@rule, @dtstart) if (@rule.kind_of?(String))
        @logics  = @rule[:logics]
        @tz_prop = nil
        if (@dtstart.kind_of?(When::TM::DateAndTime))
          clock = @dtstart.clock
          if (clock.kind_of?(When::TM::Clock) && 
              clock.tz_prop.kind_of?(TimezoneProperty) &&
             (clock.tz_prop.dtstart == @dtstart))
            @tz_prop = @dtstart.clock.tz_prop
            @dtstart = @dtstart.dup._copy({:tz_prop=>nil, :validate=>:done})
          end
        end
        _range(args)
        _rewind
      end

      def _copy
        copy = super
        copy.steps = @steps.dup
        return copy
      end

      def _first_seed(target, dtstart)
        if (@rule['FREQ'].kind_of?(When::TM::Duration))
          @interval  = @rule['FREQ']
          @interval *= @rule['INTERVAL'] unless (@rule['INTERVAL'] == 1)
        else
          @interval  = When::TM::PeriodDuration.new(@rule['INTERVAL'], FreqIndex[@rule['FREQ']])
        end
        return dtstart if (dtstart == target)
        interval_time = (dtstart + @interval) - dtstart
        return dtstart if (interval_time == 0)
        duration = target.kind_of?(Numeric) ? target - dtstart.universal_time : (target - dtstart).duration
        div, mod = duration.divmod(interval_time.duration)
        seed = dtstart + (@interval * div)
        case @direction
        when :reverse ; seed += @interval while (seed <= target)
        else          ; seed -= @interval while (seed >= target)
        end
        return seed
      end

      def _next_seed(seed)
        case @direction
        when :reverse ; return seed - @interval
        else          ; return seed + @interval
        end
      end

      def _succ(depth=0)
        return nil if (@rule['COUNT'] && (@count >= @rule['COUNT']))
        step = @steps[depth]
        unless (step)
          step = Step.new(_candidates(depth-1))
          @steps[depth..-1] = [step]
        end

        case depth
        when 0
          if (@logics.length == 0)
            result = @steps[0]._current_date
            @steps[0..-1] = [Step.new(_next_seed(result))]
          else
            loop do
              result = _succ(depth+1)
              break if (result)
              @steps[0..-1] = [Step.new(_next_seed(@steps[0]._current_date))]
            end
          end
          return (@direction==:reverse) ? nil : :next if (@dtstart > result)
          return (@direction==:reverse) ? :next : nil if (@rule['UNTIL'] && (result > @rule['UNTIL']))
          if (@tz_prop)
            result = result.dup._copy({:tz_prop=>nil, :validate=>:done})
            result.clock.tz_prop = @tz_prop
          end
          return result

        when logics.length
          step._inc
          return step._previuos_date

        else
          while (step._current_date) do
            result = _succ(depth+1)
            return result if (result)
            @steps[depth..-1] = [step._inc]
          end
          return nil
        end
      end

      def _candidates(depth)
        # logics と seed
        logics = @logics[depth]
        seed   = @steps[depth]._current_date
        logics.cash ||= {}
        return logics.cash[seed.universal_time] if logics.cash[seed.universal_time]

        # 上下限の決定
        lower_bound, higher_bound = logics._bound(seed, @rule['WKST'])

        # 候補
        list = logics._candidates(lower_bound, higher_bound).reject { |date|
          # See RFC 5545 [Page 43] invalid date (e.g., February 30)
          !(lower_bound.universal_time <= date.universal_time && date.universal_time < higher_bound.universal_time)
        }
        list = Array._sort(list, @direction)
        list = Array._sort((@rule['BYSETPOS'].map {|pos| list[pos]}).compact, @direction) if @rule['BYSETPOS']

        # 結果をCash
        logics.cash[seed.universal_time] = list
      end

      # @private
      def self._decode_rule(description, dtstart, new_zone='')
        # 指定の読み込み
        if description.kind_of?(Hash)
          rule = description
        else
          rule = {}
          description.split(/;/).each do |pair|
            raise ArgumentError, "Invalid RRULE format" unless pair =~ /^([^\/=]+)(\/(.+))?=(.*)$/
            k, f, c, v = $~[1..4]
            case k
            when 'BYYEAR', 'BYDAY', 'YEARPOS', 'DAYPOS', 'YEARST', 'DAYST'
              rule[k] ||= {}
              c       ||= ""
              raise ArgumentError, "The #{k}#{f} part MUST NOT occur more than once" if (rule[k][c])
              rule[k][c] = v
            else
              raise ArgumentError, "Invalid RRULE format" if (f)
              raise ArgumentError, "The #{k} part MUST NOT occur more than once" if (rule[k])
              rule[k] = v
            end
          end
        end

        # 整合性確認と省略された指定の設定
        raise ArgumentError, "The UNTIL and COUNT are exclusive" if (rule['UNTIL'] && rule['COUNT'])
        rule['FREQ'] = When.Duration(rule['FREQ']) unless rule['FREQ'].kind_of?(When::TM::Duration) ||
                                                           FreqIndex.key?(rule['FREQ'])
        if (rule['UNTIL'].kind_of?(String))
          rule['UNTIL']   += new_zone unless rule['UNTIL'] =~ /Z$/
          rule['UNTIL']    = When.when?(rule['UNTIL'])
        end
        unless rule['UNTIL']
          rule['UNTIL'] = When.now + (Event.default_until || 1000*When::TM::Duration::YEAR)
        end
        rule['COUNT']      = rule['COUNT'].to_i if (rule['COUNT'])
        rule['INTERVAL']   = (rule['INTERVAL'] || 1).to_i
        rule['WKST']       = Residue.day_of_week(rule['WKST'] || 'MO')

        if (rule['BYSETPOS'])
          rule['BYSETPOS'] = rule['BYSETPOS'].split(/,/).map {|v|
            pos  = v.to_i
            pos -= 1 if (pos>0)
            pos
          }
        end
        ['YEARPOS', 'DAYPOS', 'YEARST', 'DAYST'].each do |by_part|
          if (rule[by_part])
            rule[by_part].each_pair do |c,v|
              rule[by_part][c] = v.to_i
            end
          else
            rule[by_part] = {}
          end
        end

        if (rule['BYDAY'])
          v = rule['BYDAY'].delete("")
          if (v)
            raise ArgumentError, "The BYWEEKDAY and BYDAY are exclusive" if (rule['BYWEEKDAY'])
            rule['BYWEEKDAY'] = v
          end
          rule.delete('BYDAY') if rule['BYDAY'].size == 0
        end

        count = 0
        if (rule['BYWEEKNO'])
          raise ArgumentError, "The 'BYWEEKNO' is not allowed" unless (rule['FREQ'] == 'YEARLY')
          count += 1
        end
        count += 1 if (rule['BYYEARDAY'])
        raise ArgumentError, "The 'BYMONTHDAY' is not allowed" if (rule['BYMONTHDAY'] && (count>0))
        count += 1 if (rule['BYMONTH'])
        raise ArgumentError, "The BYMONTH, BYWEEKNO and BYYEARDAY are exclusive" if (count > 1)

        # ロジックオブジェクトの生成
        if (rule['BYWEEKDAY'])
          rule['BYWEEKDAY'] = Logic::Weekday.new('BYWEEKDAY', rule['BYWEEKDAY'])
        end

        ['YEAR', 'DAY'].each do |part|
          by_part = 'BY' + part
          if (rule[by_part])
            rule[by_part].each_pair do |ref,list|
              position = rule[(by_part == 'BYYEAR') ? 'YEARPOS' : 'DAYPOS'][ref]
              start    = rule[(by_part == 'BYYEAR') ? 'YEARST'  : 'DAYST' ][ref]
              rule[by_part][ref] = ((ref.to_i==0) ? Logic::Enumerator :
                                                    Logic::Residue).new(by_part, list, position, ref, start)
            end
          end
        end

        ['MONTH', 'WEEKNO', 'YEARDAY', 'MONTHDAY'].each do |part|
          by_part = 'BY' + part
          rule[by_part] = Logic.const_get(part.capitalize).new(by_part, rule[by_part]) if rule[by_part]
        end

        ['HOUR', 'MINUTE', 'SECOND'].each do |part|
          by_part = 'BY' + part
          clock   = dtstart.clock
          leap    = dtstart.time_standard.has_leap?
          if rule[by_part]
            if clock
              index = When::Coordinates::PRECISION[part]
              lower = clock.base[index]
              upper = clock.unit[index] + lower
            end
            rule[by_part] = Logic.const_get(part.capitalize).new(by_part, rule[by_part], lower, upper, leap)
          end
        end

        freq_index = FreqIndex[rule['FREQ']]
        if (dtstart && dtstart.has_time?)
          ['HOUR', 'MINUTE', 'SECOND'].each do |part|
            by_part = 'BY' + part
            if (rule[by_part]==nil && freq_index && freq_index < PostFreqIndex[by_part])
              base = dtstart[PostFreqIndex[by_part]]
              rule[by_part] = Logic.const_get(part.capitalize).new(by_part, base) unless (base == 0)
            end
          end
        end

        # 配列に登録
        logics = []
        ['BYYEAR', 'BYMONTH',  'BYWEEKNO', 'BYYEARDAY', 'BYMONTHDAY', 'BYDAY', 'BYWEEKDAY',
         'BYHOUR', 'BYMINUTE', 'BYSECOND'].each do |by_part|
          if (rule[by_part])
            if (rule[by_part].kind_of?(Hash))
              rule[by_part].each_pair do |ref,logic|
                raise ArgumentError, "The #{by_part} must have class specification" if (ref == "")
                logic.freq_index = freq_index
                logics << logic
              end
            else
              rule[by_part].freq_index = freq_index
              logics << rule[by_part]
            end
            rule.delete(by_part)
            freq_index = [PostFreqIndex[by_part], freq_index].max if freq_index
          end
        end
        raise ArgumentError, "BY part must not be specified" if rule['FREQ'].kind_of?(When::TM::Duration) &&
                                                                logics.length > 0
        rule[:logics] = logics
        rule[:parsed] = description
        return rule
      end

      #
      # 多重繰り返しの現在状態
      #
      class Step

        attr_reader :index
        attr_reader :date

        # @private
        def _current_date
          return @date[@index]
        end

        # @private
        def _previuos_date
          return @date[@index-1]
        end

        # @private
        def _inc
          @index += 1
          return self
        end

        # @private
        def initialize(date)
          @index = 0
          @date  = date.kind_of?(Array) ? date : [date]
        end
      end

      #
      # 多重繰り返しロジック
      #
      class Logic
        attr_accessor :freq_index
        attr_reader :by_part
        attr_reader :list
        attr_accessor :cash
        #protected :cash=

        # @private
        def _bound(seed, week_start)
          if (@freq_index == When::WEEK)
            # 週の初め
            bound = seed & week_start
            if (bound == seed)
              lower_bound  = bound.floor(When::DAY, nil)
              higher_bound = lower_bound  + week_start.duration
            else
              higher_bound = bound.floor(When::DAY, nil)
              lower_bound  = higher_bound - week_start.duration
            end
          else
            # 指定桁で切り捨て/切り上げ
            lower_bound  = seed.floor(@freq_index, nil)
            higher_bound = seed.ceil(@freq_index, nil)
          end
          return [lower_bound, higher_bound]
        end

        # 候補日時の生成
        # @private
        def _candidates(lower_bound, higher_bound)
          # TODO unitBaseの扱い
          return @list.map { |ord|
            if (ord >= 0)
              period = ord - 1
              bound  = lower_bound
            else
              period = ord
              bound  = higher_bound
            end
            index  = PostFreqIndex[@by_part]
            period = ord-bound[index] if (index>0)
            result = bound + When::TM::PeriodDuration.new(period, index)
            if period > 0 && result.universal_time < lower_bound.universal_time
              clock  = result.clock
              case clock.tz_prop
              when When::V::TimezoneProperty ; clock = clock.tz_prop.tzoffsetto
              when When::Parts::Timezone     ; clock = clock.tz_prop.standard
              end
              result = result._copy({:date=>result.cal_date, :validate=>:done, :events=>nil,
                                     :time=>result.clk_time._copy({:clock=>clock})})
            end
            result
          }
        end

        # @private
        def initialize(by_part, list)
          @by_part = by_part
          @list =
            case list
            when String ; When::Coordinates::Pair::_en_pair_array(list)
            when Array  ;
            else        ; [list]
            end
        end

        #
        # 剰余類を用いた繰り返し
        #   曜日の指定などに用いる
        #
        class Residue < Logic
          # @private
          def _candidates(lower_bound, higher_bound)
            candidate = []
            @list.each do |ord|
              nth, residue, period = ord
              shift = (period[PostFreqIndex[@by_part]] != 0)
              raise ArgumentError, "n*m+/-s format not permitted" if (nth || shift) && @freq_index >= When::DAY
              if (nth)
                date  = ((nth >= 0) ? lower_bound  & residue :
                                      higher_bound & residue)
                date += period if shift
                candidate << date
              else
                (lower_bound ^ residue).each do |date|
                  date += period if shift
                  break unless date < higher_bound
                  candidate << date
                end
              end
            end
            return candidate
          end

          # @private
          def initialize(by_part, list, position, ref, start)
            @by_part = by_part
            divisor  = When::Coordinates::Pair._en_number(ref)
            @list    = list.split(/,/).map {|w|
              raise ArgumentError, "The #{by_part} rule format error" unless w =~ /^(([-+]?\d+)\*)?(.+?)([-+]\d+)?$/
              nth, spec, period = $~[2..4]
              nth    = (nth) ? nth.to_i : position
              period = When::TM::PeriodDuration.new((period||0).to_i, PostFreqIndex[@by_part])
              args   = [spec.to_i, divisor, (nth) ? ((nth>0) ? nth-1 : nth) : 0]
              case by_part
              when 'BYYEAR'
                start ||=  4
                start   = start % divisor
                args << {'year'=>start}
              when 'BYDAY'
                start ||= 11
                start   = start % divisor
                args << {'day'=>start} unless (start == 0)
              end
              residue = When::Coordinates::Residue.new(*args)
              [nth, residue, period]
            }
          end
        end

        #
        # 外部 Enumerator 用いた繰り返し
        #   春分日、秋分日、復活祭などの指定に用いる
        #
        class Enumerator < Logic
          attr_reader :ref
          attr_reader :start

          # @private
          def _candidates(lower_bound, higher_bound)
            candidate = []
            @list.each do |ord|
              nth, spec, period = ord
              shift = (period[PostFreqIndex[@by_part]] != 0)
              raise ArgumentError, "n*e+/-s format not permitted" if (nth || shift) && @freq_index >= When::DAY
              if (nth==nil || nth>0)
                enum = @ref.enum_for(lower_bound, :forward, spec)
              else
                enum = @ref.enum_for(higher_bound, :reverse, spec)
              end
              if (nth)
                date = nil
                nth.abs.times {date = enum.succ}
                date += period if shift
                candidate << date
              else
                enum.each do |date|
                  date += period if shift
                  break unless date < higher_bound
                  candidate << date
                end
              end
            end
            return candidate
          end

          # @private
          def initialize(by_part, list, position, ref, start)
            @by_part = by_part
            @ref     = When.Resource(ref, '_n:')
            @start   = start
            @list    = list.split(/,/).map {|w|
              raise ArgumentError, "The #{by_part} rule format error" unless w =~ /^(([-+]?\d+)\*)?(.+?)([-+]\d+)?$/
              nth, spec, period = $~[2..4]
              nth    = (nth) ? nth.to_i : position
              period  = When::TM::PeriodDuration.new((period||0).to_i, PostFreqIndex[@by_part])
              [nth, spec, period]
            }
          end
        end

        #
        # BYMONTHを実装
        # @private
        class Month < Logic
        end

        #
        # BYWEEKNOを実装
        # @private
        class Weekno < Logic
          # @private
          def _bound(seed, week_start)
            duration = week_start.duration
            center   = duration / 2
            # 1月4日を含む週
            return [seed.floor(When::YEAR, nil), seed.ceil(When::YEAR, nil)].map { |s|
              s += center
              bound  = s & week_start
              bound -= duration if (bound > s)
              bound
            }
          end
        end

        #
        # BYYEARDAYを実装
        # @private
        class Yearday < Logic
        end

        #
        # BYMONTHDAYを実装
        # @private
        class Monthday < Logic
        end

        #
        # BYWEEKDAY(=BYDAY)を実装
        # @private
        class Weekday < Residue
          # @private
          def initialize(by_part, list)
            @by_part = by_part
            @list    = list.split(/,/).map {|w|
              raise ArgumentError, "The BYDAY rule format error" unless w =~ /^([-+]?\d+)?(MO|TU|WE|TH|FR|SA|SU)([-+]\d+)?$/
              nth, spec, period = $~[1..3]
              if nth
                nth = nth.to_i
                nth = (nth>0) ? nth-1 : nth
              end
              residue = When::Coordinates::Residue.day_of_week(spec) >> (nth||0)
              [nth, residue, When::TM::PeriodDuration.new([0,0,(period||0).to_i])]
            }
          end
        end

        #
        # BYHOURを実装
        # @private
        class Hour < Logic
          # @private
          def initialize(by_part, list, lower=nil, upper=nil, leap=false)
            super(by_part, list)
            if lower
              @list.each do |v|
                raise ArgumentError, "#{by_part} out of range: #{v}" unless lower <= v && v < upper
              end
            end
          end
        end

        #
        # BYMINUTEを実装
        # @private
        class Minute < Hour
        end

        #
        # BYSECONDを実装
        # @private
        class Second < Logic
          # @private
          def initialize(by_part, list, lower=nil, upper=nil, leap=false)
            super(by_part, list)
            if lower
              @list = @list.map {|v|
                v -= 1 if leap && upper <= v && v < upper+1
                raise ArgumentError, "#{by_part} out of range: #{v}" unless lower <= v && v < upper
                v
              }
            end
          end
        end
      end
    end
  end
end
