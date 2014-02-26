# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When

  # ISO 19108 以外の ISO に規定のある基本的なデータ型
  # およびその subclass
  module BasicTypes

    #
    # ISO 8601 Date and Time Representation
    #
    # see {xml schema}[link:http://www.w3.org/2001/XMLSchema-datatypes#date_time]
    #
    class DateTime < String

      class << self

        # When.exe Standard Representation 形式の表現を分解してArray化する
        #
        # @param [String] date_time 日時を表現する When.exe Standard Representation 形式の文字列
        # @param [Hash] options
        # @option options [String, Array<String, Integer>] :era_name デフォルトの年号(Integerは0年に対応する通年)
        # @option options [Array<Numeric>] :abbr 上位省略形式で使用する上位部分
        # @option options [Integer] :extra_year_digits ISO8601拡大表記のための年の構成要素拡大桁数(省略時 1桁)
        #
        # @return [Array] format, date, time, clock, era
        #
        #   format (Symbol, nil)
        #     nil      通常形式
        #     :century 世紀指定形式   ('CC', '+CCCC', '-CCCC')
        #     :day     年間通算日形式 ('YYDDD'など)
        #     :week    暦週形式       ('YYWNN'など)
        #
        #   date  (Array<Numeric>) 日付部分
        #
        #   time  (Array<Numeric>) 時刻部分
        #
        #   clock (String)         時間帯
        #
        #   era   (String, Array<String, Integer>) 年号(Integerは0年に対応する通年)
        #
        def _to_array(date_time, options={})
          raise TypeError, "Argument is not ISO 8601 String" unless date_time.kind_of?(String)
          if options[:abbr].kind_of?(When::TimeValue)
            options[:abbr] = ((options[:frame]||When.Calendar('Gregorian')) ^ options[:abbr]).cal_date
          end
          date_time = date_time.gsub(/_([\d])/, '\1')
          begin
            return _to_array_basic(date_time, options)
          rescue ArgumentError
            return _to_array_extended(date_time, options)
          end
        end

        private

        # ISO 8601 基本形式の表現を分解して配列化する
        def _to_array_basic(date_time, options={})

          case date_time
          # basic date & time format (ISO 8601)
          when /^([-+W\d]+)(?:(T([.,\d]+)?)([A-Z]+(\?.+)?|[-+]\d+)?)?$/
            d, t, time, clock = $~[1..4]
            format, date  = Date._to_array_basic_ISO8601(d, options)

          # basic date & time format (JIS X0301)
          when /^([.\d]+)(?:(T([.,\d]+)?)([A-Z]+(\?.+)?|[-+]\d+)?)?$/
            raise ArgumentError, "Wrong date format" unless options[:era_name]
            d, t, time, clock = $~[1..4]
            format, date  = Date._to_array_basic_X0301(d, options)
            era = options[:era_name]

          # basic time format (ISO 8601)
          when /^(T(-{0,2}[.,\d]+)?)([A-Z]+(\?.+)?|[-+]\d+)?$/
            t, time, clock = $~[1..3]

          # not supported
          else
            raise ArgumentError, "Wrong date format: #{date_time}"
          end

          return [format, date, Time._to_array_basic(time, t, options),
                                Time._to_string_clock(clock), era]
        end

        # ISO 8601 拡張形式の表現を分解して配列化する
        def _to_array_extended(date_time, options={})

          case date_time
          # extended date & time format (ISO 8601)
          when /^([-+*&%@!>=<?\dW.]+)(?:(T([:*=.,\d]+)?)([A-Z]+(\?.+)?|[-+][:\d]+)?)?$/
            d, t, time, clock = $~[1..4]
            format, date  = Date._to_array_extended_ISO8601(d, options)

          # extended date & time format (JIS X0301)
          when  /^((.+::)?(\[[^\]]+\]|[^-+\d]+))([-+*&%@!>=<?\dW.\(\)]+)?(?:(T([:*=.,\d]+)?)([A-Z]+(\?.+)?|[-+][:\d]+)?)?$/
            era, parent, child, d, t, time, clock = $~[1..7]
            format, date, era = Date._to_array_extended_X0301(d, era, options)
            era ||= options[:era_name] if (d =~ /\./)

          # extended time format (ISO 8601)
          when /^(T(-{0,2}[:*=.,\d]+)?)([A-Z]+(\?.+)?|[-+][:\d]+)?$/
            t, time, clock = $~[1..3]

          # not supported
          else
            raise ArgumentError, "Wrong date format: #{date_time}"
          end

          return [format, date, Time._to_array_extended(time, t, options),
                                Time._to_string_clock(clock), era]
        end
      end
    end

    #
    # ISO 8601 Date Representation
    #
    # see {xml schema}[link:http://www.w3.org/2001/XMLSchema-datatypes#date]
    #
    class Date < DateTime

      # @private
      Extra_Year_Digits = Hash.new {|hash, key|
        ex = (key || 1).to_i
        hash[key] =
          if ex > 0
            [
              /^(\d{2})$/,
              /^([-+]\d{#{4+ex}})(\d{2})(\d{2})$/,
              /^([-+]\d{#{4+ex}})-(\d{2})$/,
              /^([-+]\d{#{4+ex}})$/,
              /^([-+]\d{#{4+ex}})W(\d{2})(\d{1})?$/,
              /^([+]\d{#{2+ex}})$/,
              /^([-]\d{#{2+ex}})$/,
              /^([-+]\d{#{4+ex}})(\d{3})$/
            ]
          elsif ex == 0
            [/^(\d{2})$/] + [/^(\d{4})$/] * 6
          else
            [/^(\d{4})$/] * 7
          end
      }

      class << self
        # ISO 8601 基本形式の表現を分解して配列化する
        def _to_array_basic_ISO8601(date, options={})
          by, bm, bd = options[:abbr]
          extra_reg  = Extra_Year_Digits[options[:extra_year_digits]]
          case date
          when nil                          ; return nil
          when /^(\d{4})(\d{2})(\d{2})$/    ; return nil,     [$1.to_i, $2.to_i, $3.to_i]          # 5.2.1.1
          when /^(\d{4})-(\d{2})$/          ; return nil,     [$1.to_i, $2.to_i]                   # 5.2.1.2
          when /^(\d{4})$/                  ; return nil,     [$1.to_i]                            # 5.2.1.2
          when extra_reg[0]                 ; return :century,[$1.to_i * 100]                      # 5.2.1.2
          when /^(\d{4})(\d{3})$/           ; return :day,    [$1.to_i, $2.to_i]                   # 5.2.2.1
          when /^(\d{4})W(\d{2})(\d{1})?$/  ; return :week,   [$1.to_i, $2.to_i, _int($3)]         # 5.2.3.1-2
          when extra_reg[1]                 ; return nil,     [$1.to_i, $2.to_i, $3.to_i]          # 5.2.1.4 a)
          when extra_reg[2]                 ; return nil,     [$1.to_i, $2.to_i]                   # 5.2.1.4 b)
          when extra_reg[3]                 ; return nil,     [$1.to_i]                            # 5.2.1.4 c)
          when extra_reg[4]                 ; return :week,   [$1.to_i, $2.to_i, _int($3)]         # 5.2.3.4 a-b)
          when extra_reg[5]                 ; return :century,[$1.to_i * 100]                      # 5.2.1.4 d)
          when extra_reg[6]                 ; return :century,[$1.to_i * 100]       unless by      # 5.2.1.4 d)
          when extra_reg[7]                 ; return :day,    [$1.to_i, $2.to_i]                   # 5.2.2.3 a)
          else                              ; raise ArgumentError, "Wrong date format" unless by
          end

          by = by.to_i
          case date
          when /^(\d{2})(\d{2})(\d{2})$/    ; return nil,     [_century($1,by), $2.to_i, $3.to_i]  # 5.2.1.3 a)
          when /^-(\d{2})(\d{2})?$/         ; return nil,     [_century($1,by), _int($2)]          # 5.2.1.3 b-c)
          when /^--(\d{2})(\d{2})?$/        ; return nil,     [by, $1.to_i,     _int($2)]          # 5.2.1.3 d-e)
          when /^(\d{2})(\d{3})$/           ; return :day,    [_century($1,by), $2.to_i]           # 5.2.2.2 a)
          when /^-(\d{3})$/                 ; return :day,    [by, $1.to_i]                        # 5.2.2.2 b)
          when /^(\d{2})W(\d{2})(\d{1})?$/  ; return :week,   [_century($1,by), $2.to_i, _int($3)] # 5.2.3.3 a-b)
          when /^-(\d{1})W(\d{2})(\d{1})?$/ ; return :week,   [_decade($1,by),  $2.to_i, _int($3)] # 5.2.3.3 c-d)
          when /^-W(\d{2})(\d{1})?$/        ; return :week,   [by, $1.to_i,     _int($2)]          # 5.2.3.3 e-f)
          else                              ; raise ArgumentError, "Wrong date format" unless bm
          end

          bm = bm.to_i
          case date
          when /^---(\d{2})$/               ; return nil,     [by, bm, $1.to_i]                    # 5.2.1.3 f)
          when /^-W-(\d{1})$/               ; return :week,   [by, bm, $1.to_i]                    # 5.2.3.3 g)
          when /^----$/                     ; return nil,     [by, bm, bd.to_i] if bd              # extension
          end

          raise ArgumentError, "Wrong date format: #{date}"
        end

        # JIS X0301 基本形式の表現を分解して配列化する
        def _to_array_basic_X0301(date, options={})
          raise ArgumentError, "Wrong date format" unless date =~ /\./
          date.scan(/\d+\./) do |part|
            raise ArgumentError, "Wrong date format" unless part.length == 3
          end
          _to_array_basic_ISO8601(date.gsub(/\./, ''), {:abbr=>options[:abbr]||1})
        end

        # ISO 8601 拡張形式の表現を分解して配列化する
        def _to_array_extended_ISO8601(date, options={})
          return nil unless date
          abbr = Array(options[:abbr]).dup
          unless date =~ /^([-+]?\d+#{abbr[0] ? '|-' : ''})([-*=.])?(.*)/
            raise ArgumentError, "Wrong date format: #{date}"
          end
          date = $3
          dd   = [Coordinates::Pair._en_pair(_completion($1, abbr.shift), $2)]
          while date =~ /^(\d+#{abbr[0] ? '|-' : ''})([-+*&%@!>=<?.])(.+)/
            date = $3
            dd << Coordinates::Pair._en_pair(_completion($1, abbr.shift), $2)
          end
          case date
          when /^W(\d+#{abbr[0] ? '|-' : ''})([-+*&%@!>=<?.])?(\d+)?([-*=?%@])?$/
            dd << Coordinates::Pair._en_pair(_completion($1, abbr.shift), $2)
            dd << Coordinates::Pair._en_pair($3, $4)
            return :week, dd
          when /^(\d{3})$/
            dd << $1.to_i
            return :day, dd
          when /^(\d+#{abbr[0] ? '|-' : ''})([-+*&%@!>=<?.])?$/
            dd << Coordinates::Pair._en_pair(_completion($1, abbr.shift), $2)
            return nil, dd
          when ''
            return nil, dd
          else
           raise ArgumentError, "Wrong date format: #{date}"
          end
        end

        # JIS X0301 拡張形式の表現を分解して配列化する
        def _to_array_extended_X0301(date, era, options={})
          if (date =~ /^([-+\d]+)\(([-+\d]+)\)(.*)$/)
            year = $2
            date = $1 + $3
          end
          format, date  = _to_array_extended_ISO8601(date, options)
          if (year)
            yy   = year.to_i
            ee   = date[0] * 1
            era  = [era, yy-ee, yy+ee]
          end
          return format, date, era
        end

        private

        def _completion(digits, base)
          case digits
          when nil           ; return nil
          when /^\d{5}/      ; raise ArgumentError, "Wrong date format: #{digits}"
          else               ; return digits.to_i unless base
          end

          base = base.to_i
          case digits
          when '-'           ; return base
          when /^-?(\d{1})$/ ; return _decade( $1, base)
          when /^-?(\d{2})$/ ; return _century($1, base)
          else               ; return digits.to_i
          end
        end

        def _century(year, base)
          quotient, remainder = base.divmod(100)
          year      = year.to_i
          quotient += 1 if year < remainder
          return quotient * 100 + year
        end

        def _decade(year, base)
          quotient, remainder = base.divmod(10)
          year      = year.to_i
          quotient += 1 if year < remainder
          return quotient * 10 + year
        end

        def _int(digits)
          return digits ? digits.to_i : nil
        end
      end
    end

    #
    # ISO 8601 Time Representation
    #
    # see {xml schema}[link:http://www.w3.org/2001/XMLSchema-datatypes#time]
    #
    class Time < DateTime

      class << self
        # 基本形式の表現を分解して配列化する
        def _to_array_basic(time, t, options={})
          return nil unless t
          return [0] unless time
          time.sub!(/,/, '.')
          unless (time =~ /^(\d{2}(?:\.\d+)?|-)(\d{2}(?:\.\d+)?|-)?(\d{2}(\.\d+)?)?$/)
            raise ArgumentError, "Wrong time format: #{time}"
          end
          indices = options[:frame] ? options[:frame].indices : Coordinates::DefaultDateIndices
          abbr = Array(options[:abbr]).dup
          abbr[0..indices.length] = []
          return [0, Coordinates::Pair._en_number($1=='-' ? abbr[0] : $1, nil),
                     Coordinates::Pair._en_number($2=='-' ? abbr[1] : $2, nil),
                     Coordinates::Pair._en_number($3, nil)]
        end

        # 拡張形式の表現を分解して配列化する
        def _to_array_extended(time, t, options={})
          return nil unless t
          return [0] unless time
          indices = options[:frame] ? options[:frame].indices : Coordinates::DefaultDateIndices
          abbr = Array(options[:abbr]).dup
          abbr[0..indices.length] = []
          time.sub!(/,/, '.')
          tt = [0]
          while time =~ /^(\d{2}(?:\.\d+)?|-)([:*=])(.+)/
            time = $3
            tt << Coordinates::Pair._en_pair($1=='-' ? abbr.shift : $1, $2)
          end
          case time
          when /^(\d{2}(\.\d+)?)$/
            tt << Coordinates::Pair._en_number($1, nil)
          when ''
          else
            raise ArgumentError, "Wrong time format: #{time}"
          end
          return tt
        end

        # 時間帯の表現を正規化する
        def _to_string_clock(clock)
          return nil unless clock
          return clock if (clock =~ /^[A-Z]+(\?.+)?$/)
          raise ArgumentError, "Wrong clock format: #{clock}" unless (clock =~ /^([-+])(\d{2})(?::?(\d{2}))?$/)
          s, h, m = $~[1..3]
          return s + h + ':' + (m||'00')
        end
      end
    end

    # コード
    # 
    # 当該コードを定義している辞書, シソーラスまたは機関への参照を
    # オプショナルな codeSpace 属性に保持することができる文字列
    #
    # see {http://schemas.opengis.net/gml/3.1.1/base/basicTypes.xsd#CodeType gml schema}
    #
    class Code < String

      # an optional codeSpace
      #
      # @return [String] anyURI (Optional)
      attr_reader :code_space
      alias :codeSpace :code_space

      # オブジェクトの生成
      #
      # @param [String] code Text token
      # @param [String] namespace code を定義している authority の URI
      #
      def initialize(code, namespace=nil)
        @code_space = namespace
        self[0..-1] = code
      end
    end

    #
    # == 多言語対応文字列
    #
    #   本ライブラリで用いる諸々の用語を多言語対応で曖昧性なく管理するため
    #   Code の subclass として定義する
    #
    # == 内部変数
    # ===  self[ 0..-1 ] : String
    #  インスタンスを代表する文字列
    #  通常の String として振舞う場合は、この文字列として振舞う
    #
    # ===  @locale     : Hash
    #  インスタンスがさす言葉の諸言語での表現を文字列として保持する
    #  locale指定('lang_country.encoding') => その locale での文字列
    #    locale指定の要素に省略がある場合、残った共通の要素によって文字列を特定する
    #    Ex. @locale = {'en'=>'March', 'ja'=>'三月'} ならば、locale が
    #        'en_US', 'en_GB' のいずれでもlocale での文字列は 'March'
    #
    # ===  @namespace  : Hash
    #  インスタンスがさす言葉の意味を特定するための authority の URI を保持する
    #  locale指定('lang_country.encoding') => その locale での authority の URI
    #    locale指定の要素に省略がある場合、残った共通の要素によってURIを特定する
    #    Ex. @locale = {'en'=>'en:March', 'ja'=>'ja:3%E6%9C%88'} ならば、locale が
    #        'en_US', 'en_GB' のいずれでもlocale での authority の URIは 'en:March'
    #  当該用語が標準管理機関で管理されていない場合、wikipedia の当該項目の URI を用いる
    #
    # ===  @code_space : String
    #  代表的な authority の URI
    #   @namespace[''] である
    #
    # see {When::Parts::Locale}, {When::Parts::Resource}
    #
    class M17n < Code
      include Parts::Locale
      include Parts::Resource

      # @private
      def self._get_locale(locale, access_key)
        return nil unless access_key
        access_key = access_key.split(/\//).map {|key| key =~ /^[0-9]+$/ ? key.to_i : key}
        locale = locale.sub(/\..*/, '').sub(/-/,'_')
        [locale, locale.sub(/_.*/, '')].each do |loc|
          symbol = ('Locale_' + loc).to_sym
          return {loc=>access_key.inject(const_get(symbol)) {|hash, key| hash = hash[key]}} if (const_defined?(symbol))
        end
        return nil
      end

      # @private
      HashProperty = [:label, :names, :link, :access_key, :code_space]

      #
      # 代表名
      #
      # @return [String]
      #
      attr_reader :label

      #
      # When::BasicTypes::M17n に変換する - 何もしないで自身を返す
      #
      # @return [When::BasicTypes::M17n]
      #
      def to_m17n
        self
      end

      # オブジェクトの生成
      #
      # @overload initialize(names, namespace={}, locale=[])
      #   @param [Array<String>] names
      #
      #     [String] '*locale:label=prefix:link'
      #       *       - 存在すれば、label をインスタンスを代表する文字列とする
      #       locale  - label に対応する locale指定(なければ、locale 引数の指定を用いる)
      #       label   - locale 指定に対応する label
      #       prefix:link - その locale での authority の URI
      #       prefix: - namespace 引数の指定により URI に展開する
      #       link    - なければ labelをURI encodeして用いる
      #
      #   @param [Hash] namespace { prefix=>uri }
      #
      #     lables, locale 引数の prefix の展開に用いる
      #
      #   @param [Array<String>] locale
      #
      #     [String] '*locale=prefix:link'
      #       *       - 存在すれば、label をインスタンスを代表する文字列とする
      #       locale  - locale指定
      #       prefix:link - authority の URI
      #       prefix: - namespace 引数の指定により URI に展開する
      #
      # @example
      #   M17n.new(['3月', 'fr:Mars=http://fr.wikipedia.org/wiki/Mars_(mois)', 'March'],
      #            {'en_wikipedia'=>'http://en.wikipedia.org/wiki/',
      #             'ja_wikipedia'=>'http://ja.wikipedia.org/wiki/'},
      #            ['=ja_wikipedia:', '*en=en_wikipedia:']) を行うと、生成された M17n では、
      #   @names     = {''  =>'3月', 'fr'=>'Mars', 'en'=>'March'}
      #   @namespace = {''  =>'http://ja.wikipedia.org/wiki/3%E6%9C%88',
      #                 'fr'=>'http://fr.wikipedia.org/wiki/Mars_(mois)',
      #                 'en'=>'http://en.wikipedia.org/wiki/March'}
      #   となり、通常の String として振舞う場合は 'March' として振舞う
      #
      def initialize(*args)
        rest, options = _attributes(args)
        _sequence

        return _pool[@label.to_s] ?
          _copy_all(_pool[@label.to_s]) :  # 階層になった Resource の代表ラベルのための生成
          _copy(options) if @label         # M17n#to_h の出力と書式互換の入力による生成

        case rest[0]
        when When::Parts::Resource::ContentLine
          content, namespace = rest
          namespace ||= {}
          names       = []
          locale      = []
          begin
            loc   = content.attribute['language'].object
            locale << [nil, loc, namespace[loc]]
            name  = content.object
            ref   = content.attribute['reference'] || content.attribute['url']
            name += '=' + (/^NUL$/i =~ ref.object ? '' : ref.object) if ref
            names << name
          end while (content = content.same_altid)
          @names     ||= names.reverse
          @namespace ||= namespace if namespace.kind_of?(Hash)
          @locale    ||= locale.reverse
        when nil ;
        else
          names, namespace, locale = rest
          @names       = names if names
          @namespace ||= Parts::Locale._namespace(namespace) if namespace
          @locale    ||= Parts::Locale._locale(locale)       if locale
        end
        @namespace ||= {}
        @locale    ||= []

        @code_space = @namespace['']
        self[0..-1] = @label = _names(@names, @namespace, @locale)
      end
    end

    #
    # Abstract class for instance having permanent life with IRI
    #
    # see {When::Parts::Resource}
    # see {http://schemas.opengis.net/gml/3.1.1/base/basicTypes.xsd#ObjectType gml schema}
    #
    class Object

      include Parts::Resource

      # 名前
      #
      # @return [String, When::BasicTypes::M17n]
      #
      attr_reader :label

      private

      # オブジェクトの初期化
      def initialize(*args)
        @_lock_ = Mutex.new if When.multi_thread
        _normalize(*_attributes(args))
        _sequence
      end
    end
  end

  #
  # RS::Identifier を提供する
  #
  module RS

    # 参照系の識別子
    #
    # see {http://schemas.opengis.net/gml/3.1.1/base/referenceSystems.xsd#IdentifierType gml schema}
    #
    class Identifier

      # The code or name for this Identifier
      #
      # @return [When::BasicTypes::Code]
      #
      attr_reader :name

      # Identifier of the version of the associated codeSpace or code
      #
      # @return [Array<String>]
      #
      attr_reader :version

      # Remarks about this code or alias
      #
      # @return [Array<String>] String は URI/IRI文字列の場合あり
      #
      attr_reader :remarks

      # オブジェクトの生成
      #
      # @param [When::BasicTypes::Code] name
      # @param [Array<String>] version
      # @param [Array<String>] remarks String は URI/IRI文字列の場合あり
      #
      def initialize(name, version=nil, remarks=nil)
        @name    = name
        @version = version
        @remarks = remarks
      end

      # その他のメソッド
      #
      # @note When::RS::Identifier で定義されていないメソッドは
      #   処理を @name (type: When::BasicTypes::Code) に委譲する
      #
      def method_missing(name, *args, &block)
        self.class.module_eval %Q{
          def #{name}(*args, &block)
            @name.send("#{name}", *args, &block)
          end
        } unless When::Parts::MethodCash.escape(name)
        @name.send(name, *args, &block)
      end
    end
  end

  #
  # EX::Extent を提供する
  #
  module EX

    # 参照系の時間的および空間的な使用範囲を記述する
    #
    # 本ライブラリでは、時間的使用範囲を記述ためにのみ使用している
    #
    # see {http://schemas.opengis.net/gml/3.1.1/base/referenceSystems.xsd#ExtentType gml schema}
    #
    class Extent

      # time periods
      #
      # 時間的使用範囲の上限と下限を示す
      #
      # @return [When::TM::Period]
      #
      attr_reader :temporal_extent
      alias :temporalExtent :temporal_extent

      # オブジェクトの生成
      #
      # @param [When::TM::Period] extent
      #
      def initialize(extent)
        @temporal_extent = extent
      end

      # その他のメソッド
      #
      # @note When::EX::Extent で定義されていないメソッドは
      #   処理を @temporal_extent (type: When::TM::Period) に委譲する
      #
      def method_missing(name, *args, &block)
        self.class.module_eval %Q{
          def #{name}(*args, &block)
            list = args.map {|arg| arg.kind_of?(self.class) ? arg.temporal_extent : arg}
            @temporal_extent.send("#{name}", *list, &block)
          end
        } unless When::Parts::MethodCash.escape(name)
        list = args.map {|arg| arg.kind_of?(self.class) ? arg.temporal_extent : arg}
        @temporal_extent.send(name, *list, &block)
      end
    end
  end
end
