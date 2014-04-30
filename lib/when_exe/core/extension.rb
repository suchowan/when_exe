# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2013-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

require 'date'
require 'when_exe/core/duration'

#
# 標準クラスの拡張
#

#
# Extensions to Time class
#
class Time
  #
  # 対応する When::TM::JulianDate を生成
  #
  # @param [Hash] options 以下の通り
  # @option options [When::TM::Clock] :clock
  # @option options [When::Parts::Timezone] :tz
  #
  # @return [When::TM::JulianDate]
  #
  # @note core/extension
  #
  def julian_date(options={})
    options[:clock] ||= Clock(self.utc_offset)
    When::TM::JulianDate.universal_time(self.to_f * When::TM::IntervalLength::SECOND, options)
  end
  alias :to_julian_date :julian_date

  #
  # 対応する When::TM::DateAndTime を生成
  #
  # @param [Hash] options 暦法や時法などの指定
  #
  # @see When::TM::TemporalPosition._instance
  #
  # @return [When::TM::DateAndTime]
  #
  # @note core/extension
  #
  def tm_position(options={})
    When.at(self, options)
  end
  alias :to_tm_position :tm_position
end

#
# Extensions to Date class
#
class Date

  if When::TM.const_defined?(:TemporalPosition)

    include When::TM::TemporalPosition::Conversion

    #
    # 対応する When::TM::CalDate or DateAndTime を生成
    #
    # @param [Hash] options 暦法や時法などの指定
    #   see {When::TM::TemporalPosition._instance}
    #
    # @return [When::TM::CalDate, When::TM::DateAndTime]
    #
    # @note 暦法の指定がない場合、start メソッドの値によって
    #       Julian / Gregorian / Civil 暦法を選択する
    #
    def tm_position(options={})
      options[:frame] ||= When::CalendarTypes::Christian._default_start(self)
      super(options)
    end
    alias :to_tm_position :tm_position
  end

  alias :__method_missing :method_missing

  # その他のメソッド
  #
  # @note
  #   self で定義されていないメソッドは
  #   tm_position で変換して処理する
  #
  def method_missing(name, *args, &block)
    return __method_missing(name, *args, &block) if When::Parts::MethodCash::Escape.key?(name)
    self.class.module_eval %Q{
      def #{name}(*args, &block)
        result = tm_position.send("#{name}", *args, &block)
        case result
        when When::TM::DateAndTime ; result.to_date_time
        when When::TM::CalDate     ; result.to_date
        else                       ; result
        end
      end
    } unless When::Parts::MethodCash.escape(name)
    result = tm_position.send(name, *args, &block)
    case result
    when When::TM::DateAndTime ; result.to_date_time
    when When::TM::CalDate     ; result.to_date
    else                       ; result
    end
  end
end

#
# Extensions to Numeric class
#
class Numeric

  include When::TM::TemporalPosition::Conversion if When::TM.const_defined?(:TemporalPosition)

  #
  # 曜日(剰余類)
  #
  # @return [When::Coordinates::Residue] 月曜を 0 とする七曜(剰余類)
  #
  # @note core/extension
  #
  def to_day_of_week
    When::Coordinates::Residue.day_of_week(self)
  end
  alias :day_of_week :to_day_of_week

  #
  # 月名
  #
  # self が 月番号の月名を返します
  #
  # @return [When::BasicTypes::M17n] 月名
  #
  # @note core/extension
  #
  def to_month_name
    When::BasicTypes::M17n.month_name(self)
  end
  alias :month_name :to_month_name

  # self を幹の要素と解釈してWhen::Coordinates::Pair を生成
  #
  # @see When::Coordinates::Pair._force_pair
  #
  # @return [When::Coordinates::Pair]
  #
  def to_pair(branch=nil)
    Coordinates::Pair._force_pair(self, branch)
  end
  alias :pair :to_pair

  #
  # self を秒数とみなして When::Parts::Timezone::Base を取得
  #
  # @return [When::Parts::Timezone::Base]
  #
  # @note core/extension
  #
  def clock
    When.Clock(self)
  end
  alias :to_clock :clock

  # メソッド名に相当する単位で表した When::TM::IntervalLength
  # @method unit_interval_length
  # @return [When::TM::IntervalLength]
  #
  # @note unit は second, minute, hour, day, week または
  #       seconds, minutes, hours, days, weeks に読み替える
  #
  # @note core/extension

  # メソッド名に相当する単位で表した When::TM::PeriodDuration
  # @method unit_period_duration
  # @return [When::TM::PeriodDuration]
  #
  # @note unit は second, minute, hour, day, week, month, year または
  #       seconds, minutes, hours, days, weeks, months, years に読み替える
  #
  # @note core/extension

  # @private
  When::TM::Duration::Unit.keys.each do |key|

    module_eval %Q{
      # for When::TM::IntervalLength
      def #{key}_interval_length
        When::TM::IntervalLength.new(self, '#{key}')
      end
      alias :#{key}s_interval_length :#{key}_interval_length

      # for When::TM::PeriodDuration
      def #{key}_period_duration
        When::TM::PeriodDuration.new(self, When::#{key.upcase})
      end
      alias :#{key}s_period_duration :#{key}_period_duration
    }
  end
end

#
# Extensions to String class
#
class String

  include When::Parts::Encoding

  #
  # self を When::BasicTypes::M17n に変換する
  #
  # @return [When::BasicTypes::M17n]
  #
  # @note core/extension
  #
  def to_m17n
    When::BasicTypes::M17n.new(self)
  end

  # 特定 locale に対応した文字列の取得
  #
  # @param [String] loc locale の指定
  #
  # @return [String] loc に対応した文字列
  #
  # @note core/extension
  #
  def translate(loc='')
    return encode($1) if loc =~ /\.(.+)$/
    return self
  end
  alias :/ :translate

  # 包摂リストに登録されている文字を包摂する
  #
  # @param [Hash] pattern 包摂ルール
  #
  # @return [String] 包摂結果
  #
  def ideographic_unification(pattern=When::Parts::Locale._unification)
    When::Parts::Locale.ideographic_unification(self, pattern)
  end

  #
  # self を IRI とみなして When::Parts::Resource を取得
  #
  # @param [String] namespace デフォルトの namespace
  #
  # @return [When::Parts::Resource]
  #
  # @note core/extension
  #
  def resource(namespace=nil)
    When::Parts::Resource._instance(self, namespace)
  end
  alias :to_resource :resource

  #
  # self をプレフィクス '_c:' を省略した IRI とみなして When::TM::Calendar を取得
  #
  # @return [When::TM::Calendar]
  #
  # @note core/extension
  #
  def calendar
    When::Parts::Resource._instance(self, '_c:')
  end
  alias :to_calendar :calendar

  #
  # self を時間帯文字列とみなして When::Parts::Timezone::Base を取得
  #
  # @return [When::Parts::Timezone::Base]
  #
  # @note core/extension
  #
  def clock
    When.Clock(self)
  end
  alias :to_clock :clock

  #
  # self をプレフィクス '_c:' を省略した IRI とみなして When::TM::CalendarNote を取得
  #
  # @return [When::TM::CalendarNote]
  #
  # @note core/extension
  #
  def calendar_note
    When::Parts::Resource._instance(self, '_n:')
  end
  alias :to_calendar_note :calendar_note

  #
  # self をプレフィクス '_e:' を省略した IRI とみなして When::TM::CalendarEra を取得
  #
  # @return [When::TM::CalendarEra]
  #
  # @note core/extension
  #
  def calendar_era
    When::Parts::Resource._instance(self, '_e:')
  end
  alias :to_calendar_era :calendar_era

  #
  # self をプレフィクス '_m:' を省略した IRI とみなして When::BasicTypes::M17n を取得
  #
  # @return [When::BasicTypes::M17n]
  #
  # @note core/extension
  #
  def m17n
    When::Parts::Resource._instance(self, '_m:')
  end

  # self を幹と枝の要素と解釈してWhen::Coordinates::Pair を生成
  #
  # @see When::Coordinates::Pair._force_pair
  #
  # @return [When::Coordinates::Pair]
  #
  def to_pair
    Coordinates::Pair._force_pair(self)
  end
  alias :pair :to_pair

  #
  # self を検索する暦年代とみなして登録された When::TM::CalendarEraを検索
  #
  # @overload calendar_era(options={}
  #   @param [Hash] options
  #   see alse {When.era}
  #
  # @return [Array<When::TM::CalendarEra>]
  #
  #   検索結果を When::TM::CalendarEra オブジェクトの Array で返す。
  #   ヒット数が不足している場合は、_setup_ で指定した順序で When::TM::CalendarEra オブジェクトを
  #   生成しつつ読み込んで検索する。
  #
  # @note core/extension
  #
  def era(*args)
    When::TM::CalendarEra._instance(*([self] + args))
  end
  alias :to_era :era

  #
  # self をWhen.exe Standard Expression とみなして When::TM::TemporalPosition を生成
  #
  # @param [Hash] options 暦法や時法などの指定
  #
  # @see When::TM::TemporalPosition._instance
  #
  # @return [When::TM::TemporalPosition]
  #
  # @note core/extension
  #
  def when?(options={})
    When.when?(self, options)
  end
  alias :tm_position    :when?
  alias :to_tm_position :when?

  #
  # 曜日(剰余類)
  #
  # self の最初の3文字から決定した七曜(剰余類)を返します。
  # 一致する七曜(剰余類)がない場合、名前の一致するその他の剰余類を探して返します。
  #
  # @return [When::Coordinates::Residue]
  #   [ 月曜を 0 とする七曜(剰余類)  ]
  #   [ 名前の一致するその他の剰余類 ]
  #
  # @note core/extension
  #
  def to_residue
    When::Coordinates::Residue.to_residue(self)
  end
  alias :residue     :to_residue
  alias :day_of_week :to_residue

  #
  # 月名
  #
  # self の最初の3文字から決定した月名を返します。
  # 一致する月名がない場合、名前の一致するその他のM17nを探して返します。
  # (self が M17n なら name 自身をそのまま返します)
  #
  # @return [When::BasicTypes::M17n] 月名
  #
  # @note core/extension
  #
  def to_month_name
    When::BasicTypes::M17n.month_name(self)
  end
  alias :month_name :to_month_name

  #
  # self をWhen.exe Standard Expression とみなして When::TM::TemporalPosition を生成し“^”演算を実行
  #
  # @return [When::TM::TemporalPosition の “^”演算結果]
  #
  # @note core/extension
  #
  def ^(other)
    When::TM::TemporalPosition._instance(self, {}) ^ other
  end
end

#
# Extensions to Regexp class
#
class Regexp

  include When::Parts::Encoding

  #
  # self を検索する暦年代にマッチする正規表現とみなして登録された When::TM::CalendarEraを検索
  #
  # @overload calendar_era(options={}
  #   @param [Hash] options
  #   see also {When.era}
  #
  # @return [Array<When::TM::CalendarEra>]
  #
  #   検索結果を When::TM::CalendarEra オブジェクトの Array で返す。
  #   ヒット数が不足している場合は、_setup_ で指定した順序で When::TM::CalendarEra オブジェクトを
  #   生成しつつ読み込んで検索する。
  #
  # @note core/extension
  #
  def era(*args)
    When::TM::CalendarEra._instance(*([self] + args))
  end
  alias :to_era :era

  # 包摂リストに登録されている文字を包摂する
  #
  # @param [Hash] pattern 包摂ルール
  #
  # @return [Regexp] 包摂結果
  #
  def ideographic_unification(pattern=When::Parts::Locale._unification)
    When::Parts::Locale.ideographic_unification(self, pattern)
  end
end

#
# Extensions to Array class
#
class Array
  #
  # self を暦要素の Array とみなして [When::TM::TemporalPosition] を生成
  #
  # @param [Hash] options 暦法や時法などの指定
  #   @option options [Symbol] :invalid
  #     [:raise     日時が存在しない場合例外発生              ]
  #     [:check     日時が存在しない場合 nil を返す           ]
  #     [その他/nil 日時が存在することを確認しない(デフォルト)]
  #   see also {When::TM::TemporalPosition._instance}
  #
  # @return [When::TM::TemporalPosition]
  # @raise [ArgumentError]
  #   options[ :invalid ] が :raise で、日時が存在しない場合
  #
  # @note core/extension
  #
  def tm_position(options={})
    When.TemporalPosition(*(self.dup << options))
  end
  alias :to_tm_position :tm_position

  # self を[幹,枝]と解釈してWhen::Coordinates::Pair を生成
  #
  # @see When::Coordinates::Pair._force_pair
  #
  # @return [When::Coordinates::Pair]
  #
  def to_pair
    Coordinates::Pair._force_pair(*self)
  end
  alias :pair :to_pair
end
