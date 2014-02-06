# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

#
# Ruby .8.x 系のためのための互換性確保用コード
#

class String
  unless "1".respond_to?(:encode)
    require('iconv')
    # encode
    #
    # @param [String] code 文字コード
    #
    # @return [String] 文字コードcode に変換した文字列
    #
    def encode(code)
      return Iconv.iconv(code, 'UTF-8', self)[0]
    end
  end

  unless "1".respond_to?(:to_r)
    # to_r(もどき)
    #
    # 文字列を numeric に変換する
    # (できるだけ情報が落ちない型を選択)
    #
    # @return [Numeric]
    def to_r
      case self
      when /\.|E/i
        to_f
      when /\//
        Rational
        Rational(*split(/\//).map {|v| v.to_i})
      else
        to_i
      end
    end
  end

  unless "1".respond_to?(:ord)
    # 文字列の先頭文字のコードを取得する
    # (多バイト文字非対応)
    #
    # @return [Integer]
    def ord
      self[0]
    end
  end
end

#
# 例外クラス
#
unless Object.const_defined?(:StopIteration)
  # @private
  class StopIteration < IndexError
  end
end
