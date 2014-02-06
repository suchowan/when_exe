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
  # Multilingualization(M17n) 対応モジュール
  #
  #   When::BasicTypes::M17n の実装のうち When::BasicTypes 内部で
  #   定義すべきでない部分を切り出してモジュールとしている
  #
  module Locale

    # Locale 読み替えの初期設定
    DefaultAlias = {'alias'=>'ja', '日本語'=>'ja', '英語'=>'en'}

    # 漢字の包摂
    DefaultUnification = {
      '煕' => '熙',
      '廣' => '広',
      '寶' => '宝',
      '國' => '国',
      '應' => '応',
      '觀' => '観',
      '龜' => '亀',
      '齊' => '斉',
      '靈' => '霊',
      '攝' => '摂',
      '壽' => '寿',
      '萬' => '万',
      '廢' => '廃',
      '顯' => '顕',
      '會' => '会',
      '聰' => '聡',
      '總' => '総',
      '證' => '証',
      '禮' => '礼',
      '竜' => '龍',
    }

    # Escape
    # @private
    Escape = {
      "\\\\" => "\\",
      "\\n"  => "\n",
      "\\r"  => "\r",
      "\\,"  => ","
    }

    class << self

      # When::Parts::Locale Module のグローバルな設定を行う
      #
      # @param [Hash] options 下記の通り
      # @option options [Hash] :alias       Locale の読み替えパターンを Hash で指定する。
      # @option options [Hash] :unification 漢字の包摂パターンを Hash で指定する。
      #
      # @note
      #   :alias の指定がない場合、aliases は DefaultAlias(モジュール定数)と解釈する。
      #   :unification の指定がない場合、unifications は DefaultUnification(モジュール定数)と解釈する。
      #
      def _setup_(options={})
        @aliases      = options[:alias]       || DefaultAlias
        @unifications = options[:unification] || DefaultUnification
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
      # @param [When::Parts::Locale] source 文字を包摂しようとする国際化文字列
      # @param [String] source 文字を包摂しようとする文字列
      # @param [Regexp] source 文字を包摂しようとする正規表現
      # @param [Hash] pattern 包摂ルール
      #
      # @return [When::Parts::Locale] 文字を包摂した国際化文字列
      # @return [String] 文字を包摂した文字列
      # @return [Regexp] 文字を包摂した正規表現
      #
      def ideographic_unification(source, pattern=_unification)
        case source
        when When::Parts::Locale
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
            (v =~ /^(\*)?(.*?)(?:\s*=\s*(.+))?$/) ? $~[1..3] : [[nil, '', nil]]
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
      def _hash_value(hash, locale, default='')
        locale = locale.sub(/\..*/, '').sub(/-/,'_')
        return hash[locale] if (hash[locale])
        return _hash_value(hash, _alias[locale], default) if (_alias[locale])
        language = locale.sub(/_.*/, '')
        return hash[language] if (hash[language])
        return hash[default]
      end

      # @private
      def _unification
        @unifications || DefaultUnification
      end

      def _alias
        @aliases || DefaultAlias
      end
      private :_alias
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
      return Locale._hash_value(@link, loc)
    end

    # 部分文字列
    #
    # @param [Range] range String#[] と同様の指定方法で範囲を指定する
    #
    # @return [When::Parts::Locale] 指定範囲に対応した部分文字列
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
      else
        @names.keys.each do |key|
          names[key] = _label_value(key) + other.to_s
        end
      end
      return dup._copy({:names=>names, :label=>to_s + other.to_s})
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

      # 生成
      # @private
      dup._copy({
        :label => keys.include?('') ? names.delete(nil) : (names[''] = names[keys[0]]),
        :names => names
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
    # @return [When::Parts::Locale] self
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
    # @return [When::Parts::Locale] 包摂結果
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
      if (options.key?(:names))
        @names    = options[:names]
        @keys     = @names.keys.sort
        @values   = @names.values.compact.sort.reverse
      end
      @link       = options[:link]       if (options.key?(:link))
      @code_space = options[:code_space] if (options.key?(:code_space))
      @access_key = options[:access_key] if (options.key?(:access_key))
      self[0..-1] = options[:label]      if (options.key?(:label))
      return self
    end

    # @private
    def _copy_all(other)
      _copy({:names      => other.names,
             :link       => other.link,
             :code_space => other.code_space,
             :access_key => other.access_key,
             :label      => other.to_s
            })
    end

    # locale 指定を解析して @names の値を取り出す
    # @private
    def _label_value(locale)
      label = Locale._hash_value(@names, locale, nil)
      return label if label
      addition = When::BasicTypes::M17n._get_locale(locale, @access_key)
      return @names[''] unless addition
      update(addition)
      return Locale._hash_value(@names, locale)
    end

    private

    def _names(names, namespace, default_locale)

      # names, link の組み立て
      @names = {}
      @link  = {}

      if (names.kind_of?(String))
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
        when /^(\*)?(?:([^=%]*?)\s*:)?\s*(.+?)\s*(=\s*([^=]+?)?)?$/
          asterisk[0], locale, name, assignment, ref = $~[1..5]
          asterisk[1], locale, default_ref = default_locale.shift unless locale
          locale ||= ''
          ref    ||= default_ref unless (assignment)
          ref    ||= ''
          mark[0]  = locale if asterisk[0]
          mark[1]  = locale if asterisk[1]
          mark[2]  = locale unless mark[2]
          @names[locale] = name
          if (ref =~ /^(.+):/)
            prefix = namespace[$1]
            ref.sub!(/^.+:/, prefix) if (prefix)
          end
          ref += '%%<' + name + '>' if (ref =~ /[\/#:]$/)
          @link[locale] = _encode(ref)
        else ; raise ArgumentError, "Irregal locale format"
        end
      end

      # keys, values の準備
      @keys   = @names.keys.sort
      @values = @names.values.sort.reverse

      return @names[mark[0] || mark[1] || mark[2]]
    end

    # encode URI from patterns %%(...) or %.(...)
    def _encode(source)
      source.gsub(/%.<.+?>/) do |match|
        URI.encode(match[3..-2]).gsub('%', match[1..1])
      end
    end
  end
end
