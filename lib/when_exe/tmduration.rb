# -*- coding: utf-8 -*-
=begin
  Minimum subset - A multicultural and multilingualized calendar library based on ISO 8601, ISO 19108 and RFC 5545

  Copyright (C) 2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.

=end

module When

  # 分解能定数

  CENTURY = -4
  DECADE  = -3
  YEAR    = -2
  MONTH   = -1
  WEEK    = -0.5
  DAY     =  0
  HOUR    =  1
  MINUTE  =  2
  SECOND  =  3
  STRING  =  5
  SYSTEM  =  (Float::MANT_DIG*0.3).to_i

  #
  # (5.2) Temporal Objects Package
  #
  #
  module TM

    # 時間次元における長さ又は距離を記述するために使うデータ型
    #
    # see {gml schema}[link:http://schemas.opengis.net/gml/3.1.1/base/temporal.xsd#duration]
    #
    class Duration

      # 物理的な時間間隔の定数
      #
      #  時間の「秒」を Float で表現して丸め誤差が発生しない範囲で、
      #  もっとも大きな時間間隔(86400s を 2 の因数で割りつくした値)
      #  を単位 SYSTEM とする
      #
      SYSTEM = 1.0
      DAY    = SYSTEM * 675
      YEAR   = DAY    * 365.2425
      MONTH  = YEAR   /  12
      WEEK   = DAY    *   7
      HOUR   = DAY    /  24
      MINUTE = HOUR   /  60
      SECOND = MINUTE /  60

      UnitName      = {YEAR=>'year', MONTH =>'month',  WEEK  =>'week',   DAY   =>'day',
                       HOUR=>'hour', MINUTE=>'minute', SECOND=>'second', SYSTEM=>'system'}
      Unit          =  UnitName.invert
      DurationUnits = [DAY, HOUR, MINUTE, SECOND]

      #
      # オブジェクト生成用クラスメソッド
      #
      class << self
        #
        # 日時分秒からのオブジェクト生成
        #
        # @param [Array<Numeric>] value ( 日, 時, 分, 秒 ) 下位の桁は省略可
        #
        # @return [When::TM::Duration]
        #
        def dhms(*value)
          units = DurationUnits.dup
          Duration.new(value.inject(0) {|s,v| s + v * units.shift})
        end

        #
        # メソッド名に相当する単位で表した value に対応する When::TM::Duration を生成する
        # @method unit
        # @param [Numeric] value 
        # @return [When::TM::Duration]
        # @note unit は second, minute, hour, day, week に読み替える

        # @private
        Unit.keys.each do |key|
          module_eval %Q{
            def #{key}(value)
              new(value * Unit['#{key}'])
            end
          }
        end
      end

      # 時間間隔の長さ (128秒単位)
      #
      # @return [Numeric]
      #
      attr_accessor :duration

      #
      # メソッド名に相当する単位で表した時間間隔の大きさ
      # @method unit
      # @return [Numeric]
      # @note unit は second, minute, hour, day, week に読み替える

      # @private
      Unit.keys.each do |key|
        module_eval %Q{
          def #{key}
            duration / Unit['#{key}']
          end
        }
      end

      # 時間間隔の長さ / 秒
      #
      # @return [Float]
      #
      def to_f
        duration / SECOND
      end
      alias :to_float :to_f

      # 時間間隔の長さ / 秒
      #
      # @return [Integer] (四捨五入値)
      #
      def to_i
        to_f.round
      end
      alias :to_int :to_i

      # 符号反転
      #
      # @return [When::TM::Duration]
      #
      def -@
        Duration.new(-@duration)
      end

      # 絶対値
      #
      # @return [When::TM::Duration]
      #
      def abs
        sign >= 0 ? self.dup : -self
      end

      # 符号
      #
      # @return [Integer] 0 との比較により、負,0,正の値を返す
      #
      def sign
        @duration <=> 0
      end

      # 比較
      #
      # @param [Numeric, When::TM::Duration] other
      #
      # @return [Integer] other との比較により、負,0,正の値を返す
      #
      def <=>(other)
        self.to_f <=> other.to_f
      end

      # オブジェクトの同値
      #
      # @param [Object] other
      #
      # @return [Boolean]
      #   [ true  - 同値   ]
      #   [ false - 非同値 ]
      #
      def ==(other)
        return false unless other.instance_of?(self.class)
        return self.duration == other.duration
      end

      #
      # 加算
      #
      # @param [Numeric, When::TM::Duration] other 秒数とみなす
      # @param [その他] other 日時とみなす
      #
      # @return [When::TM::Duration] (other が Numeric, When::TM::Duration の場合)
      # @return [other と同じクラス] (other がその他の場合)
      #
      def +(other)
        case other
        when Duration ; Duration.new(@duration + other.duration)
        when Numeric  ; Duration.new(@duration + other * SECOND)
        else          ; other + self
        end
      end

      #
      # 減算
      #
      # @param [Numeric, When::TM::Duration] other 秒数とみなす
      #
      # @return [When::TM::Duration]
      #
      def -(other)
        Duration.new(@duration - (other.kind_of?(Duration) ? other.duration : other * SECOND))
      end

      #
      # 乗算
      #
      # @param [Numeric] other 
      #
      # @return [When::TM::Duration]
      #
      def *(other)
        Duration.new(@duration * other)
      end

      #
      # 除算
      #
      # @param [Numeric, When::TM::Duration] other 秒数とみなす
      #
      # @return [When::TM::Duration] (other が Numeric  の場合)
      # @return [Numeric]            (other が When::TM::Duration の場合)
      #
      def /(other)
        other.kind_of?(Duration) ? @duration / other.duration : Duration.new(@duration / other)
      end

      #
      # 時間間隔を日時分秒を表すArrayに変換する
      #
      # @param [Integer] n 最下位要素のインデクス(デフォルト When::SECOND)
      #
      # @return [Array] [ 日, 時, 分, 秒 ]
      #
      def to_dhms(n=When::SECOND)
        a = []
        m = @duration
        n.times do |i|
          d, m = m.divmod(DurationUnits[i])
          a << d
        end
        a << m / DurationUnits[n]
        a
      end

      #
      # 時間間隔の要素を取り出す
      #
      # @param [Integer] n 要素のインデクス
      #
      # @return [Numeric] (秒は Float, その他は Integer)
      #
      def [](n)
        to_dhms([n+1,When::SECOND].min)[n]
      end

      #
      # 指定時刻よりselfの時間間隔だけ後の時刻オブジェクト
      #
      # @param [::Time, When::TM::TemporalPosition] time 指定時刻
      #
      # @return [引数と同種の時刻オブジェクト]
      #
      def after(time=Time.now)
        time + self
      end
      alias :since :after

      #
      # 指定時刻よりselfの時間間隔だけ前の時刻オブジェクト
      #
      # @param [::Time, When::TM::TemporalPosition] time 指定時刻
      #
      # @return [引数と同種の時刻オブジェクト]
      #
      def before(time=Time.now)
        time - self
      end
      alias :ago :before

      # When::TM::Duration オブジェクトを分かりやすい文字列にして返します
      #
      # @return [String] to_s と同様
      #
      def inspect
        to_s
      end

      # 文字列化
      #
      # @return [String]
      #
      def to_s
        to_dhms.to_s
      end

      #
      # When::TM::Duration への変換
      #
      # @note 必ずコピーを作る
      #
      # @return [When::TM::Duration]
      #
      def to_duration
        Duration.new(duration)
      end

      #
      # ActiveSupport::Duration への変換
      #
      # @return [ActiveSupport::Duration]
      #
      def to_as_duration
        [[:weeks, WEEK], [:days, DAY], [:hours, HOUR], [:minutes, MINUTE], [:seconds, SECOND]].each do |unit|
          div, mod = duration.divmod(unit[1])
          return div.send(unit[0]) if mod == 0
        end
        (duration / SECOND).seconds
      end

      # coerce
      # @private
      def coerce(other)
        [other, @duration]
      end

      #
      # Duration オブジェクトの初期化
      #
      # @param [Numeric] value Duration値 / 128秒
      #
      def initialize(value)
        @duration = value
      end
    end
  end
end
