# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When

  #
  # エンコーディングの変換
  #
  module EncodingConversion

    class << self
      if String.method_defined?(:encode)
        #
        # 内部エンコーディング文字列化
        #
        # @param [Object] source もとにする Object
        #
        # @return [Object] 内部エンコーディング化した Object
        #
        # @private
        def to_internal_encoding(source)
          default_internal = Encoding.default_internal||'UTF-8'
          case source
          when Locale ;  source.to_internal_encoding
          when String ; (source.encoding == default_internal) ?
                         source :
                         source.encode(default_internal)
          when Regexp ; (source.encoding == default_internal) ?
                         source :
                         Regexp.new(source.to_s.encode(default_internal))
          when Array  ;  source.map {|e| to_internal_encoding(e)}
          when Hash
            hash = {}
            source.each_pair do |key, value|
              hash[to_internal_encoding(key)] = to_internal_encoding(value)
            end
            hash
          else        ;  source.respond_to?(:to_internal_encoding) ? source.to_internal_encoding : source
          end
        end

        #
        # 外部エンコーディング文字列化
        #
        # @param [Object] source もとにする Object
        #
        # @return [Object] 外部エンコーディング化した Object
        #
        # @private
        def to_external_encoding(source)
          default_external = Encoding.default_external
          case source
          when Locale ;  source.to_external_encoding
          when String ; (source.encoding == default_external) ?
                         source :
                         source.encode(default_external)
          when Regexp ; (source.encoding == default_external) ?
                         source :
                         Regexp.new(source.to_s.encode(default_external))
          when Array  ;  source.map {|e| to_external_encoding(e)}
          when Hash
            hash = {}
            source.each_pair do |key, value|
              hash[to_external_encoding(key)] = to_external_encoding(value)
            end
            hash
          else        ;  source.respond_to?(:to_external_encoding) ? source.to_external_encoding : source
          end
        end

      else
        # 内部エンコーディング文字列化(ダミー)
        #
        # @param [String] string もとにする String または M17n
        #
        # @return [String] そのまま返す
        #
        def to_internal_encoding(string)
          string
        end
        #
        # 外部エンコーディング文字列化(ダミー)
        #
        # @param [String] string もとにする String または M17n
        #
        # @return [String] そのまま返す
        #
        def to_external_encoding(string)
          string
        end
      end
    end

    # 
    # 内部エンコーディング文字列化
    #
    def to_internal_encoding
      EncodingConversion.to_internal_encoding(self)
    end

    # 
    # 外部エンコーディング文字列化
    #
    def to_external_encoding
      EncodingConversion.to_external_encoding(self)
    end

    # 
    # 内部エンコーディング文字列化(単項)
    #
    def +@
      to_internal_encoding
    end

    # 
    # 外部エンコーディング文字列化(単項)
    #
    def -@
      to_external_encoding
    end
  end
end
