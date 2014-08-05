# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

#
# When::TM::Duration のための標準クラスの拡張
#

#
# When::TM::Duration
#
# @private
class When::TM::Duration
  def rational_duration
    unless @rational_duration
      sec = duration / When::TM::Duration::SECOND
      mod = sec % When::TM::Duration::DAY.to_i
      if mod == 0 || mod != mod.to_i
        @rational_duration = @duration / When::TM::Duration::DAY
      else
        @rational_duration = Rational(sec.to_i, 86400)
      end
    end

    @rational_duration
  end
end

#
# Extensions to Date class
#
# @private
if ::Object.const_defined?(:Date) && ::Date.method_defined?(:+)
  class Date

    alias :_plus_  :+
    def +(other)
      other.kind_of?(When::TM::Duration) ? self + other.rational_duration : self._plus_(other)
    end


    alias :_minus_ :-
    def -(other)
      case other
      when When::TM::Duration ; self - other.rational_duration
      when When::TimeValue    ; self._minus_(other.to_date_or_datetime)
      else                    ; self._minus_(other)
      end
    end
  end
end

#
# Extensions to Time class
#
# @private
class Time

  alias :_plus_  :+
  def +(other)
    other.kind_of?(When::TM::Duration) ? self + other.to_f : self._plus_(other)
  end


  alias :_minus_ :-
  def -(other)
    other.kind_of?(When::TM::Duration) ? self - other.to_f : self._minus_(other)
  end
end

#
# Extensions to Numeric class
#
class Numeric

  #
  # メソッド名に相当する単位で表した When::TM::Duration
  # @method unit_duration
  # @return [When::TM::Duration]
  # @note unit は second, minute, hour, day, week または
  #       seconds, minutes, hours, days, weeks に読み替える
  # @note core/duration

  # @private
  When::TM::Duration::Unit.keys.each do |key|

    module_eval %Q{
      # for When::TM::Duration
      def #{key}_duration
        When::TM::Duration.new(self * When::TM::Duration::Unit['#{key}'])
      end
      alias :#{key}s_duration :#{key}_duration
    }
  end
end

#
# Extensions to Array class
#
class Array

  #
  # self を Array<日, 時, 分, 秒> とみなして When::TM::Duration を生成
  #
  # @return [When::TM::Duration]
  #
  # @note core/duration
  #
  def duration
    When::TM::Duration.dhms(*self)
  end
  alias :to_duration :duration
end
