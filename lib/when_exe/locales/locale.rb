# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

require 'when_exe/locales/encoding_conversion'

module When

  #
  # Multilingualization(M17n) 対応モジュール
  #
  #   When::BasicTypes::M17n の実装のうち When::BasicTypes 内部で
  #   定義すべきでない部分を切り出してモジュールとしている
  #
  module Locale

    # Locale 読み替えの初期設定
    DefaultAlias = {'alias'=>'ja', '日本語'=>'ja', '英語'=>'en'}

    # 省略時 Namespace
    DefaultNamespaces = Hash.new {|hash, key|
      hash[key] = "http://#{key}.wikipedia.org/wiki/"
      }.update({
      'mailto' => false,
      'https'  => false,
      'http'   => false,
      'ftp'    => false
    })

    # 漢字の包摂
    DefaultUnification = {
      '煕'=>'熙', '廣'=>'広', '寶'=>'宝', '國'=>'国',
      '應'=>'応', '觀'=>'観', '龜'=>'亀', '齊'=>'斉',
      '靈'=>'霊', '攝'=>'摂', '壽'=>'寿', '萬'=>'万',
      '廢'=>'廃', '顯'=>'顕', '會'=>'会', '聰'=>'聡',
      '總'=>'総', '證'=>'証', '禮'=>'礼', '竜'=>'龍'
    }

    # Escape
    # @private
    Escape = {
      "\\\\" => "\\",
      "\\n"  => "\n",
      "\\r"  => "\r",
      "\\,"  => ","
    }

    # Wikipedia の URL の正規表現
    # @private
    Ref  = /^http:\/\/(.+?)\.wikipedia\.org\/wiki\/([^#]+?)$/

    # Wikipedia の多言語リンクの正規表現
    # @private
    Link = /<li class="interlanguage-link interwiki-(.+?)"><a href="\/\/(.+?)\.wikipedia\.org\/wiki\/(.+?)" title="(.+?) – /

    class << self

      # Wikipedia の連続的な参照を抑制するための遅延時間/秒
      #
      # @return [Numeric]
      #
      attr_accessor :wikipedia_interval

      # When::Locale Module のグローバルな設定を行う
      #
      # @param [Hash] options 下記の通り
      # @option options [Hash]    :alias              Locale の読み替えパターンを Hash で指定する。
      # @option options [String]  :namespaces         名前空間定義の省略時に名前空間生成に用いる書式
      # @option options [Hash]    :unification        漢字の包摂パターンを Hash で指定する。
      # @option options [Numeric] :wikipedia_interval Wikipedia の連続的な参照を抑制するための遅延時間/秒
      #
      # @note
      #   :alias の指定がない場合、aliases は DefaultAlias(モジュール定数)と解釈する。
      #   :unification の指定がない場合、unifications は DefaultUnification(モジュール定数)と解釈する。
      #
      def _setup_(options={})
        @aliases            = options[:alias]       || DefaultAlias
        @namespaces         = options[:namespaces]  || DefaultNamespaces
        @unifications       = options[:unification] || DefaultUnification
        @wikipedia_interval = options[:wikipedia_interval]
      end

      # 設定情報を取得する
      #
      # @return [Hash] 設定情報
      #
      def _setup_info
        {:alias              => _alias,
         :namespaces         => _namespaces,
         :unification        => _unification,
         :wikipedia_interval => @wikipedia_interval}
      end

      # 特定 locale に対応した文字列の取得
      #
      # @param [String] source もとにする String または M17n
      #
      # @param[String] loc locale の指定 ( lang[-|_]country.encode )
      #   [ lang    - 言語               ]
      #   [ country - 国(省略可)         ]
      #   [ encode  - 文字コード(省略可) ]
      #
      # @return [String] loc に対応した文字列
      #
      # @note source が Hash や Array の場合、その構成要素を変換して返す
      # @note encode は通常大文字だが、大文字/小文字の変換は行わず指定されたまま使用している
      #
      def translate(source, loc='')
        return source unless loc
        case source
        when Hash
          result = {}
          source.each_pair do |key, value|
            result[translate(key, loc)] = translate(value, loc)
          end
          return result
        when Array
          return source.map {|value| translate(value, loc)}
        when Locale
          return source.translate(loc)
        when String
          return source.encode($1) if loc =~ /\.(.+)$/
        end
        source
      end

      # 包摂リストに登録されている文字を包摂する
      #
      # @param [When::Locale] source 文字を包摂しようとする国際化文字列
      # @param [String] source 文字を包摂しようとする文字列
      # @param [Regexp] source 文字を包摂しようとする正規表現
      # @param [Hash] pattern 包摂ルール
      #
      # @return [When::Locale] 文字を包摂した国際化文字列
      # @return [String] 文字を包摂した文字列
      # @return [Regexp] 文字を包摂した正規表現
      #
      def ideographic_unification(source, pattern=_unification)
        case source
        when When::Locale
          source.ideographic_unification(pattern)
        when Regexp
          Regexp.compile(ideographic_unification(source.source.encode('UTF-8'), pattern), source.options)
        when String
          source.gsub(/./) do |c|
            pattern[c] ? pattern[c] : c
          end
        else
          source
        end
      end

      # 文字列で表現された namespace 指定を Hash に変換する
      # @private
      def _namespace(source=nil)
        case source
        when Hash ; source
        when nil  ; {}
        when String
          namespace = {}
          source = $1 if (source=~/\A\s*\[?(.+?)\]?\s*\z/m)
          source.split(/[\n\r,]+/).each do |v|
            v.strip!
            next if (v=~/^#/)
            pair = [''] + v.split(/\s*=\s*/, 2)
            namespace[pair[-2]] = pair[-1]
          end
          namespace
        when When::Parts::Resource::ContentLine
          source.object.names
        else ; raise TypeError, "Irregal Namespace Type: #{source.class}"
        end
      end

      # locale 指定を Array に変換する
      # @private
      def _locale(source=nil)
        # default の Locale
        return [[nil, '', nil]] unless source

        # source の配列化
        if source.kind_of?(String)
          source = $1 if (source=~/\A\s*\[?(.+?)\]?\s*\z/m)
          source = source.scan(/((?:[^\\\n\r,]|\\.)+)(?:[\n\r,]+(?!\z))?|[\n\r,]+/m).flatten.map {|token|
            (token||'').gsub(/\\./) {|escape| Escape[escape] || escape}
          }
        end

        # 各Localeの展開
        source.map {|v|
          if v.kind_of?(String)
            v = v.strip
            next if (v=~/^#/)
            (v =~ /^(\*)?(.*?)(?:\s*=\s*(.*))?$/) ? $~[1..3] : [[nil, '', nil]]
          else
            v
          end
        }.compact
      end

      # 文字列 [.., .., ..] を分割する
      # @private
      def _split(source)
        line  = source.dup
        return [line] unless line =~ /,/
        list  = []
        b = d = s = 0
        (source.length-1).downto(0) do |i|
          bs = 0
          (i-1).downto(0) do |k|
            break unless (line[k,1] == '\\')
            bs += 1
          end
          next if (bs[0] == 1)
          case line[i,1]
          when "'"         ; s  = 1-s  if (d == 0)
          when '"'         ; d  = 1-d  if (s == 0)
          when ']','}',')' ; b += 1 if  (d+s == 0)
          when '[','{','(' ; b -= 1 if  (d+s == 0 && b > 0)
          when ','
            if (b+d+s == 0)
              list.unshift(line[i+1..-1])
              line = i > 0 ? line[0..i-1] : ''
            end
          end
        end
        list.unshift(line)
      end

      # locale 指定を解析して Hash の値を取り出す
      # @private
      def _hash_value(hash, locale, defaults=['', 'en'])
        locale = locale.sub(/\..*/, '')
        return hash[locale] if hash[locale]
        return _hash_value(hash, _alias[locale], defaults) if _alias[locale]
        language = locale.sub(/-.*/, '')
        return hash[language] if hash[language]
        defaults.each do |default|
          return hash[default] if hash[default]
        end
        return nil
      end

      # 漢字の包摂パターン
      # @private
      def _unification
        @unifications ||= DefaultUnification
      end

      # @private
      def _get_locale(locale, access_key)
        return nil unless access_key
        access_key = access_key.split(/\//).map {|key| key =~ /^[0-9]+$/ ? key.to_i : key}
        locale = locale.sub(/\..*/, '')
        [locale, locale.sub(/-.*/, '')].each do |loc|
          symbol = ('Locale_' + loc.sub(/-/,'_')).to_sym
          return {loc=>access_key.inject(const_get(symbol)) {|hash, key| hash = hash[key]}} if const_defined?(symbol)
        end
        return nil
      end

      private

      # Locale の読み替えパターン
      def _alias
        @aliases    ||= DefaultAlias
      end

      # 名前空間定義の省略時に名前空間生成に用いる書式
      def _namespaces
        @namespaces ||= DefaultNamespaces
      end

      # wikipedia オブジェクトの生成・参照
      def wikipedia_object(path, options={})
        query    = options.delete(:query)
        interval = options.key?(:interval) ? options.delete(:interval) : @wikipedia_interval
        return nil unless Object.const_defined?(:JSON) && path =~ Ref
        _wikipedia_relation(_wikipedia_object(path, $~[1], $~[2], query, interval, options), path, query)
      end

      # wikipedia の読み込み
      def _wikipedia_object(path, locale, file, query, interval, options)
        # 採取済みデータ
        title = URI.decode(file.gsub('_', ' '))
        mode  = "".respond_to?(:force_encoding) ? ':utf-8' : ''
        dir   = When::Parts::Resource.root_dir + '/data/wikipedia/' + locale
        FileUtils.mkdir_p(dir) unless FileTest.exist?(dir)

        open("#{dir}/#{file}.json", 'r'+mode) do |source|
          json = JSON.parse(source.read)
          json.update(Hash[*query.split('&').map {|pair| pair.split('=')}.flatten]) if query
          json.key?('names') ?
            When::BasicTypes::M17n.new(json) :
            When::Coordinates::Spatial.new(json)
        end

      rescue => no_file_error
        # 新しいデータ
        case interval
        when 0
          raise no_file_error
        when Numeric
          if @wikipedia_last_access
            delay = (@wikipedia_last_access + interval.abs - Time.now.to_f).ceil
            sleep(delay) if delay > 0
          end
        end
        contents = nil
        begin
          OpenURI
          source   = open(path, 'r'+mode)
          contents = source.read
        ensure
          @wikipedia_last_access = Time.now.to_f
          source.close if source
        end

        # wikipedia contents
        raise KeyError, 'Article not found: ' + title if contents =~ /<div class="noarticletext">/

        # word
        word = {
          :label => title,
          :names => {''=>title, locale=>title},
          :link  => {''=>path,   locale=>path  }
        }
        contents.scan(Link) do |link|
          word[:names][$~[1]] = $~[4]
          word[:link ][$~[1]] = "http://#{$~[1]}.wikipedia.org/wiki/#{$~[3]}"
        end
        object = When::BasicTypes::M17n.new(word)

        # location
        if contents =~ /tools\.wmflabs\.org\/geohack\/geohack\.php\?.+?params=(.+?[NS])_(.+?[EW])/
          location = {
            :label => object
          }
          location[:lat], location[:long] = $~[1..2].map {|pos|
            pos.gsub(/_(\d)[._]/, '_0\1_').sub('.', '_').sub('_', '.').gsub('_', '')
          }
          object = When::Coordinates::Spatial.new(location)
        end

        # save data
        open("#{dir}/#{file}.json", 'w'+mode) do |source|
          source.write(JSON.dump(object.to_h({:method=>:to_h}).update(options)))
        end
        query ? _wikipedia_object(path, locale, file, query) : object
      end

      # wikipedia オブジェクトの関連付け
      def _wikipedia_relation(object, path, query)
        code_space = path.sub(/[^\/]+$/, '')
        if object.kind_of?(When::Coordinates::Spatial)
          object.label._pool['..'] = object
          object._pool[object.label.to_s] = object.label
          object.send(:child=, [object.label])
          object.label.send(:code_space=, code_space)
        else
          object.send(:code_space=, code_space)
        end
        object._pool['..']  = path
        object._pool['..'] += '?' + query if query
        object
      end
    end

    # ローケール指定時の文字列
    #
    # @return [Hash]
    attr_reader :names

    # 有効なローケール指定
    #
    # @return [Array<String>]
    attr_reader :keys

    # 有効な文字列 - additional attribute
    #
    # @return [Array<String>]
    attr_reader :values

    # 文字列の説明 - additional attribute
    #
    # @return [Hash] { anyURI }
    attr_reader :link

    # Rails 用 I18n 定義へのアクセス・キー
    #
    # @return [String]
    attr_reader :access_key
    protected :access_key

    # 特定 locale に対応した文字列の取得
    #
    # @param [String] loc locale の指定 ( lang[-|_]country.encode )
    #   [ lang    - 言語               ]
    #   [ country - 国(省略可)         ]
    #   [ encode  - 文字コード(省略可) ]
    #
    # @return [String] loc に対応した文字列
    #
    def translate(loc='')
      return to_s unless loc
      loc = loc.sub('_', '-')
      lang, code = loc.split(/\./)
      result = _label_value(loc)
      return result if !code || @names.member?(loc)
      return result.encode(code)
    end
    alias :/ :translate

    # 特定 locale に対応した reference URI の取得
    #
    # @param [String] loc locale の指定
    #
    # @return [String] loc に対応した reference URI
    #
    def reference(loc='')
      loc ||= ''
      return Locale._hash_value(@link, loc.sub('_', '-'))
    end

    # 部分文字列
    #
    # @param [Range] range String#[] と同様の指定方法で範囲を指定する
    #
    # @return [When::Locale] 指定範囲に対応した部分文字列
    #
    def [](range)
      dup._copy({
        :label => to_s[range],
        :names => @names.keys.inject({}) {|l,k|
          l[k] =  @names[k][range]
          l
        }
      })
    end

    # 文字列の一致
    #
    # @param [String, Regexp] regexp マッチする正規表現
    #
    # @return [Integer] マッチした位置のindex(いずれかの locale でマッチが成功した場合)
    # @return [nil]     すべての locale でマッチに失敗した場合
    #
    def =~(regexp)
      @keys.each do |key|
        index = (@names[key] =~ regexp)
        return index if index
      end
      return nil
    end

    # 部分文字列の位置
    #
    # @param [String] other 部分文字列
    #
    # @return [Integer] 部分文字列の先頭のindex(いずれかの locale で部分文字列を含んだ場合)
    # @return [nil]     すべての locale で部分文字列を含まない場合
    #
    def index(other)
      @keys.each do |key|
        index = @names[key].index(Locale.translate(other, key))
        return index if index
      end
      return nil
    end

    # 文字列の連結
    #
    # @param [String, When::Toos::Locale] other 連結する文字列
    #
    # @return [When::Toos::Locale] 連結された文字列
    #
    def +(other)
      names = {}
      case other
      when Locale
        (@names.keys + other.names.keys).uniq.each do |key|
          names[key] = _label_value(key) + other._label_value(key)
        end
        links = other.link
      else
        @names.keys.each do |key|
          names[key] = _label_value(key) + other.to_s
        end
        links = {}
      end
      return dup._copy({:names=>names, :link=>links.merge(link), :label=>to_s + other.to_s})
    end

    # 書式指定による文字列化
    #
    # @param [Array<Object>] other 文字列化する Object の Array
    # @param [Array<String>] locale 文字列化を行う locale の指定(デフォルト : すべて)
    #
    # @return [When::Toos::Locale] 文字列化された Object
    #
    def _printf(other, locale=nil)
      # 処理する配列
      terms = other.kind_of?(Array) ? [self] + other : [self, other]

      # locale key の配列
      if locale == []
        keys = []
      else
        keys = terms.inject([]) {|k,t|
          k += t.keys if t.kind_of?(Locale)
          k
        }.uniq
        if locale
          locale = [locale] unless locale.kind_of?(Array)
          keys   = locale | (locale & keys)
        end
      end
      keys << nil if keys.include?('')

      # names ハッシュ
      names = keys.inject({}) {|l,k|
        l[k] = When::Coordinates::Pair._format(
                 (block_given? ? yield(k, *terms) : terms).map {|t|
                   t.kind_of?(Locale) ? t.translate(k) : t
                 }
               )
        l
      }

      # link ハッシュ
      links = terms.reverse.inject({}) {|h,t|
        h.update(t.link) if t.kind_of?(Locale)
        h
      }

      # 生成
      dup._copy({
        :label => keys.include?('') ? names.delete(nil) : (names[''] = names[keys[0]]),
        :names => names,
        :link  => links
      })
    end
    alias :% :_printf

    # ローケールの更新
    #
    # @param [Hash] options 下記の通り
    # @option options [String] カントリーコード 表現文字列
    # @option options [Hash]   :link            { カントリーコード => 参照URL文字列 }
    # @option options [String] :code_space      規格や辞書を特定するコードスペースのURL文字列
    # @option options [String] :label           代表文字列
    # @note Hashキーはすべて Optional で、存在するもののみ更新します
    #
    # @return [self] 更新された Object
    #
    def update(options={})
      options = options.dup
      @link.update(options.delete(:link))       if (options.key?(:link))
      @code_space = options.delete(:code_space) if (options.key?(:code_space))
      self[0..-1] = options.delete(:label)      if (options.key?(:label))
      unless (options.empty?)
        @names.update(options)
        @keys     = @names.keys.sort
        @values   = @names.values.sort.reverse
      end
      return self
    end

    # 包摂リストに登録されている文字を包摂する(自己破壊)
    #
    # @param [Hash] pattern 包摂ルール
    #
    # @return [When::Locale] self
    # @private
    def ideographic_unification!(pattern=_unification)
      names = {}
      @names.each_pair do |key, value|
        names[key] = Locale.ideographic_unification(value, pattern)
      end
      @names  = names
      @values = @names.values.sort.reverse
      self[0..-1] = Locale.ideographic_unification(self.to_s[0..-1], pattern)
      return self
    end
    protected :ideographic_unification!

    # 包摂リストに登録されている文字を包摂する(自己保存)
    #
    # @param [Hash] pattern 包摂ルール
    #
    # @return [When::Locale] 包摂結果
    #
    def ideographic_unification(pattern=_unification)
      dup.ideographic_unification!(pattern)
    end

    # 閏の表記を扱うための書式付整形
    # @private
    def prefix(other, locale=nil)
      return self.dup unless other
      other = m17n(other) unless other.kind_of?(Locale)
      other._printf(self, locale) do |k, *t|
        t[0]  = t[0].translate(k)
        t[0] += "%s" unless t[0] =~ /%[-+]?[.\d]*s/
        t
      end
    end

    protected

    # @private
    def _copy(options={})
      if options.key?('label') # for JSON
        opt = {}
        options.each_pair do |key, value|
          opt[key.to_sym] = value
        end
      else
        opt = options
      end

      self[0..-1] = opt[:label]      if opt[:label]
      if opt[:names]
        @names    = opt[:names]
        @keys     = @names.keys.sort
        @values   = @names.values.compact.sort.reverse
      end
      @label      = opt[:label]      if opt[:label]
      @link       = opt[:link]       if opt[:link]
      @access_key = opt[:access_key] if opt[:access_key]
      @code_space = opt[:code_space] if opt[:code_space]
      return self
    end

    # @private
    def _copy_all(other)
      _copy({:label      => other.to_s,
             :names      => other.names,
             :link       => other.link,
             :access_key => other.access_key,
             :code_space => other.code_space
            })
    end

    # locale 指定を解析して @names の値を取り出す
    # @private
    def _label_value(locale)
      label = Locale._hash_value(@names, locale, [])
      return label if label
      foreign  = Locale._get_locale(locale, @access_key)
      return @names[''] unless foreign
      english  = @names['en'] || @names['']
      addition = english.dup.sub!(/^#{Locale._get_locale('en', @access_key)['en']}/, '')
      foreign[locale] += addition if addition
      update(foreign)
      return Locale._hash_value(@names, locale)
    end

    private

    def _names(names, namespace, default_locale)

      # names, link の組み立て
      @names = {}
      @link  = {}

      if names.kind_of?(String)
        unless (names=~/\A\s*\[(.+?)\]\s*\z/m)
          names      = names.strip
          @names[''] = names
          @keys      = ['']
          @values    = [names]
          return names
        end
        names = $1.split(/[\n\r,]+/)
      end

      mark     = []
      asterisk = []
      default_locale  = default_locale.dup
      names.each do |v|
        v.strip!
        case v
        when '', /^#/ ;
        when /^\/(.+)/; @access_key = $1
        when /^(\*)?(?:([^=%]*?)\s*:)?\s*(.+?)\s*(=\s*([^=]+?(\?.+)?)?)?$/
          asterisk[0], locale, name, assignment, ref = $~[1..5]
          asterisk[1], locale, default_ref = default_locale.shift unless locale
          locale ||= ''
          ref    ||= default_ref unless (assignment)
          ref    ||= ''
          mark[0]  = locale if asterisk[0]
          mark[1]  = locale if asterisk[1]
          mark[2]  = locale unless mark[2]
          name = _replacement($1, locale, ($3 || @names['en'] || @names[''])) if name =~ /^_([A-Z_]+)_(\((.+)\))?$/
          @names[locale] = name
          if ref =~ /^(.+):/
            prefix = namespace[$1] || Locale.send(:_namespaces)[$1]
            ref.sub!(/^.+:/, prefix) if prefix
          end
          ref += '%%<' + name + '>' if ref =~ /[\/#:]$/
          @link[locale] = _encode(ref) unless ref == ''
        else ; raise ArgumentError, "Irregal locale format: " + v
        end
      end
      if Locale.wikipedia_interval && Locale.wikipedia_interval <= 0
        ['en', ''].each do |lc|
          if Locale::Ref =~ @link[lc] && $~[1] == 'en'
            object = Locale.send(:wikipedia_object, @link[lc])
            if object
              @names = object.names.merge(@names)
              @link  = object.link.merge(@link)
            end
            break
          end
        end
      end

      # keys, values の準備
      @keys   = @names.keys.sort
      @values = @names.values.sort.reverse

      # 代表名
      @names[mark[0] || mark[1] || mark[2]]
    end

    #
    # 英語表記を現地表記に置き換える
    #
    def _replacement(table, locale, name)
      Locale.const_get(table.split('_')[-1])[locale] ?
        Locale.send(table.downcase, name, locale) :
        name
    end

    # encode URI from patterns %%(...) or %.(...)
    def _encode(source)
      source.gsub(/%.<.+?>/) do |match|
        URI.encode(match[3..-2]).gsub('%', match[1..1])
      end
    end
  end
end
