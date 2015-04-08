# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2013-2015 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

#
# Ruby 1.8.x 系のためのための互換性確保用コード
#

class String
  unless method_defined?(:encode)
    require('iconv')
    #
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

  unless method_defined?(:to_r)
    #
    # to_r(もどき)
    #
    # 文字列を Rational or Integer に変換する
    #
    # @return [Numeric]
    def to_r
      case self
      when /\.|E/i
        to_f.to_r
      when /\//
        Rational
        Rational(*split(/\//).map {|v| v.to_i})
      else
        to_i
      end
    end
  end

  unless method_defined?(:ord)
    #
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
# 浮動小数点数
#
class Float
  unless const_defined?(:INFINITY)
    # @private
    INFINITY = MAX
  end

  unless method_defined?(:to_r)
    Rational
    # @private
    def to_r
      it  = When::Coordinates::Residue.new(self, 1).enum_for
      res = it.succ while it.has_next?
      Rational(*res[0..1])
    end
  end
end

#
# 例外クラス
#
unless ::Object.const_defined?(:StopIteration)
  # @private
  class StopIteration < IndexError
  end
end
