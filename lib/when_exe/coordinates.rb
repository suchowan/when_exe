# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2022 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

#
# 座標の記述に用いる諸オブジェクト
#
module When::Coordinates
  # 変換テーブル
  PRECISION = {'YEAR'=>When::YEAR, 'MONTH' =>When::MONTH,  'WEEK'  =>When::WEEK,   'DAY'   =>When::DAY,
               'HOUR'=>When::HOUR, 'MINUTE'=>When::MINUTE, 'SECOND'=>When::SECOND, 'SYSTEM'=>When::SYSTEM}
  PERIOD    = {'P1Y' =>When::YEAR, 'P1M'   =>When::MONTH,  'P1W'   =>When::WEEK,   'P1D'   =>When::DAY,
               'PT1H'=>When::HOUR, 'PT1M'  =>When::MINUTE, 'PT1S'  =>When::SECOND,
               '1Y'  =>When::YEAR, '1M'    =>When::MONTH,  '1W'    =>When::WEEK,   '1D'    =>When::DAY,
               '1h'  =>When::HOUR, '1m'    =>When::MINUTE, '1s'    =>When::SECOND}
  VALUE     = {'DATE'=>When::DAY,  'TIME'  =>When::SYSTEM, 'DATE-TIME'=>When::SYSTEM} # RFC 5545
  PRECISION_NAME = PRECISION.invert
  PERIOD_NAME    = {When::YEAR=>'P1Y' , When::MONTH=>'P1M',   When::WEEK  =>'P1W', When::DAY=>'P1D',
                    When::HOUR=>'PT1H', When::MINUTE=>'PT1M', When::SECOND=>'PT1S'}
  MATCH     = {'NS'=>/(N|S|北緯|南緯)/, 'EW'=>/(E|W|東経|西経)/}

  # 60進->10進変換(1/225度単位)
  #
  # @param [String]   src 60進法で表した方向付きの数値
  # @param [String]   dir 方向 ('NS' または 'EW')
  # @param [Numeric]  degree 角度の単位 (1 => 1度, 225=> 1/225 度)
  #
  # @return [Numeric] 10進変換した数値 (src が nil なら0.0を、Numeric なら 225*src を返す)
  #
  def self.to_deg_225(src, dir, degree=Spatial::DEGREE)
    case src
    when String
      src = src.gsub(/_+/,'').gsub(/@/, '.')
      return src.to_r * degree if (src =~ /E[-+]/ || src !~ MATCH[dir])
      sign  = ($1 == dir[1..1]) ? -1 : +1
      value = src.gsub(MATCH[dir], '').strip
      if ((value + "00000") =~ /\A(\d+)\.(\d{2})(\d{2})(\d+)\z/)
        deg, min, sec, frac = $~[1..4]
        sec += "." + frac
      else
        deg, min, sec = value.split(/[^\d.]+/)
      end
      return sign * (deg.to_i *  degree +
                (min||0).to_f * (degree/60.0) +
                (sec||0).to_f * (degree/3600.0))
    when NilClass
      0.0
    when Numeric
      src * degree
    else
      raise TypeError, "Invalid Location Type"
    end
  end

  # 60進->10進変換(度単位)
  #
  # @param [String]   src 60進法で表した方向付きの数値
  # @param [String]   dir 方向 ('NS' または 'EW')
  #
  # @return [Numeric] 10進変換した数値 (src が nil なら0.0を、Numeric ならそのままsrcを返す)
  #
  def self.to_deg(src, dir)
    to_deg_225(src, dir) / Spatial::DEGREE
  end

  # 10進->60進変換
  #
  # @param [Numeric] src 数値
  # @param [String]  dir 方向 ('NS' または 'EW')
  # @param [Integer] round 秒の小数点以下最大桁数
  #
  # @return [String] 60進変換した数値
  #
  def self.to_dms(src, dir, round=6)
    dir      = (src >= 0) ? dir[0..0] : dir[1..1]
    deg, min  =     src.abs.divmod(1)
    min, sec  =    (60*min).divmod(1)
    sec       = (60*10**round*sec).round
    fig = round + 2
    round.times do
      div, mod = sec.divmod(10)
      if mod == 0
        fig -= 1
        sec  = div
      else
        break
      end
    end
    (['N','S'].include?(dir) ? "%02d.%02d%0#{fig}d%s" : "%03d.%02d%0#{fig}d%s") % [deg, min, sec, dir]
  end

  #
  # 剰余類
  #
  class Residue < When::BasicTypes::Object

    LabelProperty = 'label'

    class << self
      #
      # 曜日(剰余類)
      #
      # @param [Numeric] day 月曜を 0 とする七曜(剰余類)を返します
      # @param [String]  day 最初の3文字から決定した七曜(剰余類)を返します。
      #                      一致する七曜(剰余類)がない場合、名前の一致するその他の剰余類を探して返します。
      #
      # @return [When::Coordinates::Residue]
      #
      def day_of_week(day)
        return day if day.kind_of?(self)

        day ||= 0
        week  = When.Resource('_co:Common::Week')
        dow   = week.child
        case day
        when Numeric    ; return dow[day]
        when /\AWeek\z/ ; return week
        when String     ; day = When::EncodingConversion.to_internal_encoding(day)
        else            ; return nil
        end

        day, shift = day =~ /\A([-+\d]+)(.+)/ ? [$2, $1] : day.split(':', 2)
        residue = day.split('&').inject(nil) {|res,d|
          r = _day_of_week(d.strip, dow)
          return nil unless r
          res ? res & r : r
        }
        return residue unless shift
        shift << '1' unless shift =~ /\d/
        shift  = shift.to_i
        shift -= 1 if shift > 0
        residue >> shift
      end
      alias :to_residue :day_of_week

      def _day_of_week(day, dow)
        match = day[/\A...|^.{1,2}\z/]
        if match
          dow.size.times do |i|
            return dow[i] if dow[i].label.=~(/\A#{match}/i)
          end
        end

        ObjectSpace.each_object(self) do |object|
          return object if object.registered? && object.label.=~(/\A#{day}\z/)
        end

        return nil
      end
      private :_day_of_week

      # 汎用の mod
      #
      # @param [Numeric] nn 被除数
      # @param [Block] dd 手続き
      #
      #   nn  = rem + dd(quot)
      #
      #   div = dd(quot+1)-dd(quot)
      #
      #   となるように rem, div, quot を決めたい手続き
      #
      # @return [Array<Numeric>] [ quot, rem, div ]
      #   nn を dd で「割った」商(quot), 余り(rem)および除数(div)を返します。
      #   remは非負、quotは Integer。
      #
      def mod(nn, &dd)
        u = dd.call(0)
        y = ((nn-u)*256).divmod(dd.call(256)-u)[0] - 1
        w1, w2 = dd.call(y), dd.call(y+1)
        until  w1 <= nn && nn < w2
          if w2 <= nn then  y, w1, w2 = y+1, w2, dd.call(y+2)
          else              y, w1, w2 = y-1, dd.call(y-1), w1
          end
        end
        return y, nn-w1, w2-w1
      end

      # 中国剰余
      #
      # @param [Array<Numeric>] a [ num, den ] den で割って num 余ることを示す配列
      # @param [Array<Numeric>] b [ num, den ] den で割って num 余ることを示す配列
      #
      # @return [Array<Numeric>] a と b の条件をともに満たす [ num, den ]
      #
      def _china(a, b)
        b, a = a, b if (a[1] <= b[1])
        g, p, q = _gcd(a[1], b[1])
        return [((b[0]*a[1]*q-a[0]*b[1]*p)*(a[1]*q-b[1]*p)) % (a[1]*b[1]), a[1]*b[1]] if (g == 1)
        r = a[0] % g
        s = b[0] % g
        return nil unless (r == s)
        m = _china([(a[0]-r).div(g), a[1].div(g)], [(b[0]-s).div(g), b[1].div(g)])
        return nil unless (m)
        return [m[0]*g+r, m[1]*g]
      end

      private

      # 最大公約数
      def _gcd(a,b)
        c, x = a.divmod(b)
        g = [[a, 1, 0],
             [b, c, 1]]

        until (x == 0) do
          k = g[1][0].div(x)
          g << [x, k * g[1][1] + g[0][1], k * g[1][2] + g[0][2]]
          g.shift
          x = g[0][0] % g[1][0]
        end

        return [g[1][0]] + g[0][1..2]
      end
    end

    # @private
    HashProperty = [:label, :remainder, :divisor]

    # 剰余
    #
    # @return [Numeric]
    #
    attr_accessor :remainder
    protected :remainder=

    # 法
    #
    # @return [Integer] (>0)
    #
    attr_reader :divisor

    # 繰り上がり
    #
    # @return [Integer]
    #
    attr_accessor :carry
    protected :carry=

    # 周期分の補正の有無
    #
    # @return [Boolean]
    #
    attr_accessor :shifted
    protected :shifted=

    # 単位
    #
    # @return [Hash] { String=>Numeric }
    #
    #   Example : { 'day'=>11, 'year'=4 }
    #
    #     通日に適用するときは、11 ずらして計算 - 甲子日 = ユリウス日 11 + 60n
    #
    #     通年に適用するときは、 4 ずらして計算 - 甲子年 = 西暦 4 + 60n
    #
    attr_reader :units

    # units の指定
    #
    # @param [String] arg あらかじめ units に指定した単位を用いる
    #
    # @return [When::Coordinates::Residue]
    #
    def to(arg)
      return nil unless @units[arg]
      self.class.new(@remainder, @divisor, @carry, {arg=>@units[arg]})
    end
    alias :/ :to

    # オブジェクトの単位
    #
    # @return [String] 現在使用中の単位を返す
    #
    def event
      keys = @units.keys
      return (keys.size == 1) ? keys[0] : 'day'
    end

    # remainder の指定
    #
    # @param [Numeric] remainder 指定値を@remainderとする
    # @param [String]  remainder When::Parts::Resource の has-a 関係によりString に対応する子供オブジェクトを取得
    #
    # @return [When::Coordinates::Residue]
    #
    def [](remainder)
      return super if !remainder.kind_of?(Numeric) || (child && child.length == @divisor)
      return self  if remainder == 0 && !child
      remainder *= 1
      return self.class.new(@remainder+remainder, @divisor, @carry, @label, @format, @units) unless (child && child.length > 0)
      carry, remainder = (@remainder+remainder).divmod(@divisor)
      base = child.reverse.each do |residue|
        break residue if residue.remainder <= remainder
      end
      raise ArgumentError, "remainder out of range: #{remainder}" unless base.kind_of?(self.class)
      base = base.dup
      base.remainder = remainder
      base.carry    += carry
      return base
    end

    # 典型的なイベントの発生間隔
    #
    # @param [String] event
    #
    # @return [When::TM::PeriodDuration]
    #
    def duration(event=self.event)
      When::TM::PeriodDuration.new(@divisor, When::Coordinates::PRECISION[event.upcase])
    end

    # 派生オブジェクトと元オブジェクトの remainder の差
    # (派生オブジェクトとは、元オブジェクトに[]演算を施して @remainder を変えたオブジェクト)
    #
    # @return [Integer]
    #
    #   派生オブジェクトでない場合 : 自身の remainder
    #
    #   派生オブジェクトである場合 : 派生オブジェクトと元オブジェクトの remainder の差
    #
    def difference
      @difference ||= (registered? || iri !~ /:/) ? @remainder : @remainder - When.Resource(iri).remainder
    end

    # remainderの加算
    #
    #   other   : Numeric
    #
    # @return [When::Coordinates::Residue]
    #
    def +(other)
      carry, remainder = (@remainder + other).divmod(@divisor)
      return self.class.new(remainder, @divisor, @carry+carry, @units)
    end

    # remainderの減算
    #
    # @param [Numeric] other
    #
    # @return [When::Coordinates::Residue]
    #
    def -(other)
      carry, remainder = (@remainder - other).divmod(@divisor)
      return self.class.new(remainder, @divisor, @carry+carry, @units)
    end

    # carryの加算
    #
    # @param [Numeric] other
    #
    # @return [When::Coordinates::Residue]
    #
    def >>(other)
      result = self.class.new(@remainder, @divisor, @carry+other, @units)
      result.shifted = true
      result
    end

    # carryの減算
    #
    # @param [Numeric] other
    #
    # @return [When::Coordinates::Residue]
    #
    def <<(other)
      result = self.class.new(@remainder, @divisor, @carry-other, @units)
      result.shifted = true
      result
    end

    # 剰余類の共通集合
    #
    # @param [When::Coordinates::Residue] other
    #
    # @return [When::Coordinates::Residue]
    #
    def &(other)
      case other
      when Residue
        if self.units == other.units
          m = self.class._china([@remainder, @divisor], [other.remainder, other.divisor])
          u = units.dup
        else
          keys = units.keys & other.units.keys
          keys = ['day'] if keys == []
          return nil unless (keys.size==1)
          self_base  = self.units[keys[0]]  || 0
          other_base = other.units[keys[0]] || 0
          m = self.class._china([@remainder, @divisor],
                                [(other.remainder+other_base-self_base) % other.divisor, other.divisor])
          u = {keys[0]=>self_base}
        end
        return nil unless (m)
        return self.class.new(m[0], m[1], @carry, u)
      when Pair
        return Pair.new(self & other.trunk, other.branch)
      when Numeric
        keys = @units.keys
        d    = (keys.size == 1) ? @units[keys[0]] : (@units['day']||0)
        c, m = (other-d).divmod(@divisor)
        c += 1 if (m > @remainder)
        return (c + @carry) * @divisor + @remainder + d
      else
        position = When::TM::Position.any_other(other)
        raise TypeError, "Can't convert #{other.class} to When::TM::TemporalPosition" unless position
        return position & self
      end
    end

    # 剰余
    #
    # @param [When::TM::TemporalPosition, Numeric, When::Coordinates::Pair] other
    #
    # @return ['other' と同じクラス]
    #
    def %(other)
      case other
      when Pair
        return Pair.new(self % other.trunk, other.branch)
      when Numeric
        keys = @units.keys
        d    = (keys.size == 1) ? @units[keys[0]] : (@units['day']||0)
        return (other-d) % @divisor
      else
        position = When::TM::Position.any_other(other)
        raise TypeError, "Can't convert #{other.class} to When::TM::TemporalPosition" unless position
        return self[position % self]
      end
    end

    # Enumerator の生成
    #
    # @overload initialize()
    #
    # @overload initialize(range, count_limit=nil)
    #   @param [Range, When::Parts::GeometricComplex] range 始点-range.first, 終点-range.last
    #   @param [Integer] count_limit 繰り返し回数(デフォルトは指定なし)
    #
    # @overload initialize(first, direction, count_limit)
    #   @param [When::TM::TemporalPosition] first  始点
    #   @param [Symbol]  direction   :forward - 昇順, :reverse - 降順
    #   @param [Integer] count_limit 繰り返し回数(デフォルトは指定なし)
    #
    # @return [When::Coordinates::Residue::BestRationalApproximations] 引数なしの場合
    # @return [When::Coordinates::Residue::Enumerator]                 引数ありの場合
    #
    def _enumerator(*args)
      length  = args.length
      length -= 1 if args[-1].kind_of?(Hash)
      args.unshift(self)
      (length==0) ? BestRationalApproximations.new(self, *args) : Enumerator.new(*args)
    end
    alias :to_enum  :_enumerator
    alias :enum_for :_enumerator

    # オブジェクトの生成
    #
    # @overload initialize(remainder, divisor, carry=0, label=nil, format=nil, units={})
    #   @param [Numeric] remainder 剰余
    #   @param [Integer] divisor   法
    #   @param [Integer] carry     繰り上がり
    #   @param [String, When::BasicTypes::M17n] label  名前
    #   @param [String, When::BasicTypes::M17n] format 名前の書式
    #   @param [Hash] units 単位(下記の通り)
    #   @option units [Numeric] 'day'  通日に対して使用する場合のオフセット
    #   @option units [Numeric] 'year' 通年に対して使用する場合のオフセット
    #
    def initialize(*args)
      # units の取得
      options =_get_options(args).dup
      units   = {}
      list    = []
      options.each_pair do |key, value|
        if (PRECISION[key.upcase])
          list << key
          units[key.downcase] = _to_num(value)
        end
      end
      list.each do |key|
        options.delete(key)
      end
      options['units'] ||= {}
      options['units'].update(units)
      _set_variables(options)
      @units ||= {}

      # その他の変数
      remainder, divisor, carry, label, format = args
      @label     = label || @label
      @label     = m17n(@label, nil, nil, options) if (@label)
      @format    = format || @format
      @format    = m17n(@format, nil, nil, options) if (@format)
      _sequence
      @remainder = _to_num(remainder || @remainder)
      @divisor   = _to_num(divisor   || @divisor  )
      @carry     = _to_num(carry     || @carry    )
      raise RangeError, "Divisor shoud be Positive Numeric" if (@divisor <= 0)
      carry, @remainder = @remainder.divmod(@divisor)
      @carry += carry
      @shifted   = @carry != 0
    end

    private

    alias :_method_missing :method_missing

    # その他のメソッド
    #
    #   When::Coordinate::Residue で定義されていないメソッドは
    #   指定の桁での剰余算とみなす
    #
    def method_missing(name, *args, &block)
      return _method_missing(name, *args, &block) if When::Parts::MethodCash::Escape.key?(name) ||
                                                    !@units.key?(name.to_s.downcase)
      instance_eval %Q{
        def #{name}(*args, &block)
          self[args[0] % self.to("#{name.to_s.downcase}")]
        end
      } unless When::Parts::MethodCash.escape(name)
      self[args[0] % self.to(name.to_s.downcase)]
    end

    # 数値化
    def _to_num(s)
      case s
      when Numeric ; return s
      when nil     ; return 0
      when /\.|E/  ; return s.to_f
      else         ; return s.to_i
      end
    end

    #
    # 最良近似分数の系列を生成する Enumerator
    #
    class BestRationalApproximations < When::Parts::Enumerator

      # Enumerator の巻き戻し
      #
      # @return [void]
      #
      def _rewind
        @z = @x/@y
        @k = @z.floor
        @p = [1,@k]
        @q = [0, 1]
        super
      end

      # 最良近似分数を生成する
      #
      # @return [Array<Numeric>] ( remainder, divisor, error )
      #   [ remainder (Integer) 分子 ]
      #   [ divisor   (Integer) 分母 ]
      #   [ error     (Float)   誤差 ]
      #
      def succ
        value = @current
        if (@count_limit.kind_of?(Numeric) && @count >= @count_limit) ||
           (@error.kind_of?(Numeric) && @e && @error >= @e.abs)
          @current = nil
        else
          if @z==@k
            @e = 0
            @current = [@p[1], @q[1], 0]
          else
            @z = 1.0/(@z-@k)
            @k = @z.floor
            @e = @p[1].to_f/@q[1]-@x.to_f/@y
            @current = [@p[1], @q[1], @e]
            @p = [@p[1], @p[1]*@k + @p[0]]
            @q = [@q[1], @q[1]*@k + @q[0]]
          end
          @count += 1
        end
        return value
      end

      # オブジェクトの生成
      #
      # @overload initialize(parent, options={})
      #   @param [When::Coordinates::Residue] parent 生成元の剰余類オブジェクト
      #   @param [Hash] options 下記の通り
      #   @option options [Numeric] :error 収束とみなす誤差(デフォルト 1E-5)
      #   @option options [Integer] :count_limit 最大繰り返し回数
      #
      def initialize(*args)
        @y = args[0].divisor
        @x = args[0].remainder + @y * args[0].carry
        super
        @error       = @options[:error] || 1e-15
        @count_limit = @options[:count_limit]
      end
    end

    #
    # 指定の剰余となる通日or通年を生成する Enumerator
    #
    class Enumerator < When::Parts::Enumerator

      #
      # 次の通日or通年を得る
      #
      # @return [When::TM::TemporalPosition]
      #
      def succ
        value = @current
        @current = (@count_limit.kind_of?(Numeric) && @count >= @count_limit) ? nil :
                   (@current==:first) ? @first :
                   (@direction==:forward) ? @first & @parent >> @count : @first &  @parent << @count
        @count  += 1
        return value
      end

      # オブジェクトの生成
      #
      # @overload initialize(parent, range, count_limit=nil)
      #   @param [When::Coordinates::Residue] parent 生成元の剰余類オブジェクト
      #   @param [Range, When::Parts::GeometricComplex] range 始点-range.first, 終点-range.last
      #   @param [Integer] count_limit 繰り返し回数(デフォルトは指定なし)
      #
      # @overload initialize(parent, first, direction, count_limit)
      #   @param [When::Coordinates::Residue] parent 生成元の剰余類オブジェクト
      #   @param [When::TM::TemporalPosition] first  始点
      #   @param [Symbol]  direction   :forward - 昇順, :reverse - 降順
      #   @param [Integer] count_limit 繰り返し回数(デフォルトは指定なし)
      #
      def initialize(*args)
        case args[1]
        when When::TimeValue
          first   = args[1] & args[0]
          first   = args[1] & (args[0] << 1) if args[2] == :reverse && first > args[1]
          args[1] = first
        when Range
          first   =  args[1].first & args[0]
          args[1] = (args[1].exclude_end?) ? (first...args[1].last) : (first..args[1].last)
        else
          raise TypeError, "Second Argument should be 'When::TM::(Temporal)Position'"
        end
        @period = When::TM::PeriodDuration.new(args[0].divisor,
                                               When::Coordinates::PRECISION[args[0].units] || When::DAY)
        super(*args)
      end
    end
  end

  # 暦座標
  #
  #   暦座標の特性を定義する
  #
  class Index < When::BasicTypes::Object

    # 日時要素の要素数
    #
    # @return [Integer]
    #
    #   「時」なら 24, 「分」なら 60
    #
    #   日数や太陰太陽暦の月数のように不定の場合は nil
    #
    attr_reader :unit

    # 日時要素の下限
    #
    # @return [Integer]
    #
    #   年月日は 1, 時分秒は 0
    #
    attr_reader :base

    # 日時要素名(幹)
    #
    # @return [When::BasicTypes::M17n]
    #
    #   月の名称の配列などに用いる
    #
    attr_reader :trunk

    # 座標値のシフト
    #
    # @return [Integer](デフォルト 0)
    #
    #   月 - 名称を trunk 配列の何番目(0オリジン)からとるかを指定
    #
    #   日 - 剰余類のシフトを指定
    #
    attr_reader :shift

    # 日時要素名(枝)
    #
    # @return [Hash] { Numeric=>When::BasicTypes::M17n }
    #
    #   When::Coordinates::Pair の branch の値からprefix
    #
    #   (「閏」などの文字列)を引くための Hash
    #
    attr_reader :branch

    # 日時要素名(幹枝)
    #
    # @return [Hash] { When::Coordinates::Pair=>When::BasicTypes::M17n }
    #
    #   When::Coordinates::Pair から 日時要素名を引くための Hash
    #
    #   初期化時に @trunk, @branch から自動的に生成する
    #
    attr_reader :trunk_branch

    # インデクス(幹枝)
    #
    # @return [Hash] { String=>When::Coordinates::Pair }
    #
    #   日時要素名から When::Coordinates::Pair を引くための Hash
    #
    #   初期化時に @trunk, @branch から自動的に生成する
    #
    attr_reader :index

    # @private
    def self.precision(specification)
      return specification.to_i if (specification.kind_of?(Numeric))
      return (PRECISION[specification] || VALUE[specification] || When::SYSTEM)
    end

    private

    def _normalize(args=[], options={})
      @label  = m17n(@label, nil, nil, @options) if @label
      @unit   = @unit.to_i if @unit
      @base   = (@base  || 1).to_i
      @trunk  = When::BasicTypes::M17n.labels(args[0]) unless args.empty?
      @shift  = (@shift || 0).to_i
      @keys   = []
      if @trunk
        if @trunk.kind_of?(Array)
          m17n = {}
          @trunk.length.times do |i|
            m17n[(i-@shift) % @trunk.length + @base] = @trunk[i]
          end
          @trunk = m17n
        end
        raise TypeError, "Trunk must be Hash" unless @trunk.kind_of?(Hash)
        @trunk.values.each do |v|
          @keys |= v.keys if v.kind_of?(When::Locale)
        end
      end
      if @branch
        if @branch.kind_of?(Array)
          m17n = {}
          @branch.length.times do |i|
            m17n[i] = @branch[i]
          end
          @branch = m17n
        end
        raise TypeError, "Branch must be Hash" unless @branch.kind_of?(Hash)
        @branch.each_pair do |key, value|
          value  = When::BasicTypes::M17n.label(value)
          @keys |= value.keys if value.kind_of?(When::Locale)
          @branch[key] = value
        end
      end
      @trunk_branch = {}
      @index = {}
      if @trunk
        if @branch
          @trunk.keys.each do |t|
            @branch.keys.each do |b|
              @trunk_branch[Pair._en_pair(t,b)] = @trunk[t].prefix(@branch[b])
            end
          end
        else
          @trunk_branch = @trunk
        end
        @trunk_branch.each_pair do |k,v|
          v.values.each do |s|
            @index[s] = k
          end
        end
      end
    end
  end

  # 暦座標値
  #
  #   暦座標の値を表現する
  #
  class Pair < Numeric
    DL0 = {'-'=> 0,   '.'=> 0, ':'=> 0,   ','=> 0, ' '=> 0, '@'=>-2 }
    DL1 = {'!'=>-2.5, '%'=>-2, '&'=>-1.5, '*'=>-1, '+'=>-0.5,
           '<'=> 0.5, '='=> 1, '>'=> 1.5, '?'=> 2 }
    DL2 = DL1.invert

    class << self
      #
      # source を Numeric に変換する
      #
      # @param [Object] source
      # @param [Numeric] default source が nil の場合の代替値
      #
      # @return [Numeric]
      #
      def _en_number(source, default=0)
        return default unless(source)
        integer = source.to_i
        float   = source.to_f
        return (integer==float) ? integer : float
      end

      #
      # (source, branch) を When::Coordinates::Pair に変換する
      #
      # @param [Object] source
      # @param [Numeric] branch
      #
      # @return [When::Coordinates::Pair]
      #
      def _force_pair(source, branch=nil)
        case source
        when self
          return source
        when Numeric
          return new(_en_number(source), branch)
        when String
          tail   = source[-1..-1]
          branch = DL0[tail] || DL1[tail]
          source = (branch) ? source[0..-2] : source.dup
          trunk  = (source =~ /\.|E/i) ? source.to_f : source.to_i
          return new(trunk, branch)
        else
          raise TypeError, "Irregal type for #{self} :#{source}"
        end
      end

      #
      # branch が有効なら (source, branch) を When::Coordinates::Pair に変換する。
      #
      # @param [Object] trunk
      # @param [Numeric, String] branch
      #
      # @return [trunk自体]  branch が無効
      # @return [When::Coordinates::Pair]  branch が有効(非0)
      #
      def _en_pair(trunk, branch=nil)
        return trunk if (trunk.kind_of?(self))
        branch = DL0[branch] || DL1[branch] || branch
        trunk  = _en_number(trunk) if (trunk)
        return trunk unless (branch && branch != 0)
        return new(trunk, branch)
      end

      #
      # When::Coordinates::Pair の trunk と branch の和をとって Numeric 化する
      #
      # @param [When::Coordinates::Pair] source trunk と branch の和を返す
      # @param [Array] source 各要素を _de_pair した Arrayを返す
      # @param [その他 Numeric] source をそのまま返す
      #
      # @return [Numeric, Array<Numeric>]
      #
      def _de_pair(source)
        case source
        when Array
          return (source.map!{|v| _de_pair(v)})
        when self
          return source.sum
        when Numeric
          return source
        else
          raise TypeError, "Irregal type for #{self}"
        end
      end

      #
      # 文字列を When::Coordinates::Pair のArray 化する
      #
      # @param [String] source
      #
      # @return [Array<When::Coordinates::Pair>]
      #
      def _en_pair_array(source)
        source = $1 if source=~/\A\s*\[?(.+?)\]?\s*\z/
        source.split(/,/).map {|v|
           v =~ /\A\s*(.+?)([^\d\s])?\s*\z/
           _en_pair($1, $2)
        }
      end

      #
      # 日付を When::Coordinates::Pair のArray 化する
      #
      # @param [String] source
      #
      # @return [Array<When::Coordinates::Pair>]
      #
      def _en_pair_date_time(source)
        source = $1 if source =~ /\A\s*\[(.+)\]\s*\z/
        trunk, branch, *rest = source.strip.split(/([^\d])/)
        if trunk == ''
          sign = branch
          trunk, branch, *rest = rest
          trunk = sign + trunk if trunk
        end
        pairs = []
        while (trunk)
          pairs << _en_pair(trunk, branch)
          trunk, branch, *rest = rest
        end
        return pairs
      end

      #
      # branch文字を意識して、書式文字列により When::Coordinates::Pair の Array を文字列化
      #
      # @overload _format(format, list)
      #   @param [String] format 書式文字列
      #   @param [Array]  list   書式に従って文字列化されるオブジェクトの Array
      #
      # @return [String]
      #
      # @note %0s は文字列引数の表示を抑制するための指定となる。C言語のprintfと異なるので注意。
      #
      def _format(m17ns)
        index = 1
        m17ns[0].scan(/(%(?:(\d)\$)?[-+0# ]?[*\d.$]*[cspdiuboxXfgeEG])([-.:])?|(%%|.)/).inject('') { |form, m17n|
          t,i,s,c = m17n
          case t
          when '%0s'
            m17n[index..index] = nil
          when nil
            form  += c
          else
            suffix = DL2[m17ns[i ? i.to_i : index] * 0]  || s if s
            form  += t + ({nil=>'', '%'=>'%%'}[suffix]   || suffix)
            index += t.length - t.gsub(/\*/,'').length + 1
          end
          form
        } % m17ns[1..-1].map { |v| v.kind_of?(self) ? v.trunk : v }
      end
    end

    #
    # 暦要素の幹
    #
    # @return [Numeric] 年番号,月番号,日番号など暦要素の幹となる部分
    #
    attr_reader :trunk

    #
    # 暦要素の枝
    #
    # @return [Numeric] 暦要素のうち(閏であるかなど)幹で表現しきれない枝の部分
    #
    attr_reader :branch

    #
    # 暦要素の幹と枝の和
    #
    # @return [Numeric]
    #
    # @note
    #   個別の実装において、本変数が When::TM::Calendar や When::TM::Clock が扱うべき
    #   座標値を表すように配慮されている。
    #
    #   例: 会計年度など年の変わり目が暦年と異なる場合、trunk+=1, branch-=1 として、
    #       trunk が会計年度, sum が暦年を表現するようにできる。この場合、trunk は表記上の
    #       年、branch は会計年度と暦年にずれがあるという情報を表現していることになる。
    #
    attr_reader :sum

    #
    # Hash の key
    #  内容が同一であれば同一値を返す
    #
    # @return [Integer]
    #
    attr_reader :hash

    #
    # trunk の更新
    #
    # @param [Numeric] trunk 新しい trunk
    #
    # @return [When::Coordinates::Pair] 更新結果
    #
    def trunk=(trunk)
      @trunk = trunk
      _normalize
      self
    end

    #
    # branch の更新
    #
    # @param [Numeric] branch 新しい branch
    #
    # @return [When::Coordinates::Pair] 更新結果
    #
    def branch=(branch)
      @branch = branch
      _normalize
      self
    end

    # 属性 @sum を取得する
    #
    # @return [Numeric]
    #
    # @note
    #   When::Coordinates::Pair 以外の Numeric では、単項演算 + は恒等変換になる。
    #   このため、When::TM::Calendar や When::TM::Clock の実装は、暦要素が When::Coordinates::Pair か
    #   否かを判断することなく、暦要素に単項演算 + を施すことによって、必要な暦要素を取得できる。
    def +@
      return  @sum
    end

    # trunk の符号を反転する
    #
    # @return [When::Coordinates::Pair] Pair.new(-@trunk, @branch)
    #
    def -@
      return self.class.new(-@trunk, @branch)
    end

    # @trunk, @branch を取得する
    #
    # @param [Integer] other (1, 0, -1)
    #
    # @return [Numeric]
    #   [ other ==  1  -   @trunk  ]
    #   [ other ==  0  -   @branch ]
    #   [ other == -1  -  -@trunk  ]
    #
    # @note
    #   When::Coordinates::Pair 以外の Numeric では、1 による乗算は恒等変換になる。
    #   また、0 による乗算は恒に 0になる。
    #   このため、When::TM::Calendar や When::TM::Clock の実装は、暦要素が When::Coordinates::Pair か
    #   否かを判断することなく、暦要素に 1 による乗算を施すことによって、trunk に相当する値を、
    #   0 による乗算を施すことによって、branch に相当する値を取得できる。
    def *(other)
      case other
      when  1 ;  @trunk
      when  0 ;  @branch
      when -1 ; -@trunk
      else    ; raise ArgumentError, "Irregal designation : #{other}"
      end
    end

    # 加算
    #
    # @param [Numeric] other
    #
    # @return [When::Coordinates::Pair]
    #   other が When::Coordinates::Pair でない場合、trunk に対する加算となる
    #
    def +(other)
      return self.class.new(@trunk + other, @branch) unless other.kind_of?(self.class)
      return self.class.new(@trunk + other.trunk, @branch + other.branch)
    end

    # 減算
    #
    # @param [Numeric] other
    #
    # @return [When::Coordinates::Pair]
    #   other が When::Coordinates::Pair でない場合、trunk に対する減算となる
    #
    def -(other)
      return self.class.new(@trunk - other, @branch) unless other.kind_of?(self.class)
      return self.class.new(@trunk - other.trunk, @branch - other.branch)
    end

    # 商と剰余
    #
    # @param [Numeric] other
    #
    # @return [When::Coordinates::Pair]
    #     trunk に対する divmod となる
    #
    def divmod(other)
      div, mod = @trunk.divmod(other)
      return div, self.class.new(mod, @branch)
    end

    # 剰余
    #
    # @param [Numeric] other
    #
    # @return [When::Coordinates::Pair]
    #     trunk に対する % となる
    #
    def %(other)
      self.class.new(@trunk % other, @branch)
    end

    # 比較
    #
    # @param [Numeric] other
    #
    # @return [Integer] (負,0,正)
    #     trunk の比較が優先される
    #
    def <=>(other)
      other = self.class._force_pair(other)
      (@trunk <=> other.trunk).nonzero? || (@branch <=> other.branch)
    end

    # 文字列化
    #
    # @param [String] zero @branch == 0 を表現する文字列
    #
    # @return [String]
    #
    def to_s(zero='')
      return @trunk.to_s + (@branch==0 ? zero : DL2[@branch])
    end

    # 整数化
    #   Array の index 値を提供する場合に呼ばれる
    #
    # @return [Integer]
    #
    def to_i
      @sum.to_i
    end

    # 強制型変換
    # @private
    def coerce(other)
      [self.class._force_pair(other), self]
    end

    private

    # オブジェクトの生成
    #
    # @param [Numeric] trunk  幹
    # @param [Numeric] branch 枝
    #
    def initialize(trunk, branch=nil)
      @trunk  = trunk  || 0
      @branch = branch || 0
      _normalize
    end

    def _normalize
      @trunk = @trunk.to_i if (@trunk.kind_of?(Float) && @trunk.to_i == @trunk.to_f)
      @sum   = @trunk
      if (@branch.kind_of?(Numeric))
        @branch = @branch.to_i if (@branch.to_i == @branch.to_f)
        @sum   += @branch      if (@trunk)
      end
      @hash = [self.class, @trunk, @branch].hash
    end
  end

  # 暦座標値
  #
  #   閏秒のある暦座標の値を表現する
  #
  class LeapSeconds < Pair

    #
    # 閏秒の単位 / When::TM::Duration::SYSTEM
    #
    # @return [Numeric]
    #
    attr_reader :second

    #
    # trunk の整数部
    #
    # @return [Integer]
    #
    attr_reader :int

    #
    # trunk の小数部
    #
    # @return [Float]
    #
    attr_reader :frac

    # 加算
    #
    # @param [Numeric] other
    #
    # @return [When::Coordinates::LeapSeconds]
    #   other が When::Coordinates::LeapSeconds でない場合、trunk に対する加算となる
    #
    def +(other)
      return self.class.new(@trunk + +other, @branch, @second) unless other.kind_of?(self.class)
      return self.class.new(@trunk + other.trunk, @branch + other.branch, @second)
    end

    # 減算
    #
    # @param [Numeric] other
    #
    # @return [When::Coordinates::LeapSeconds]
    #   other が When::Coordinates::LeapSeconds でない場合、trunk に対する減算となる
    #
    def -(other)
      return self.class.new(@trunk - +other, @branch, @second) unless other.kind_of?(self.class)
      return self.class.new(@trunk - other.trunk, @branch - other.branch, @second)
    end

    # 商と剰余
    #
    # @param [Numeric] other
    #
    # @return [When::Coordinates::LeapSeconds]
    #   trunk に対する divmod となる
    #
    def divmod(other)
      div, mod = @trunk.divmod(other)
      return div, self.class.new(mod, @branch, @second)
    end

    # 比較
    #
    # @param [Numeric] other
    #
    # @return [Integer] (負,0,正)
    #   trunk の整数部, branch, trunk の小数部の順に比較する
    #
    def <=>(other)
      other = self.class.new(+other, 0, @second) unless other.kind_of?(self.class)
      raise ArgumentError, "length of unit 'second' mismatch" unless @second == other.second
      (@int <=> other.int).nonzero? || (@branch <=> other.branch).nonzero? || (@frac <=> other.frac)
    end

    # 文字列化
    #
    # @param [String] zero @branch==0 を表現する文字列
    #
    # @return [String]
    #
    def to_s(zero='')
      return @trunk.to_s + (@branch==0 ? zero : DL2[(@branch/@second).floor])
    end

    # 強制型変換
    # @private
    def coerce(other)
      [self.class.new(other, 0, @second), self]
    end

    # オブジェクトの生成
    #
    # @param [Numeric] trunk  幹
    # @param [Numeric] branch 枝
    # @param [Numeric] second 閏秒の単位
    #
    def initialize(trunk, branch, second)
      @second     = second
      @int, @frac = trunk.divmod(second)
      super(trunk, branch)
    end
  end

  #
  # 暦座標を扱う処理をまとめたモジュール
  #
  #   When::TM::Calendar と When::TM::Clock に共通する処理だが、ISO 19108 で両者の
  #   直接の superclass である、When::TM::ReferenceSystem は、これらの処理を持たない
  #   こととなっているため、When::TM::Calendar と When::TM::Clock の共通部分を
  #   モジュールとしてまとめた。
  #
  module Temporal

    include When::Parts::MethodCash

    # @private
    HashProperty =
      [[:origin_of_MSC, 0], [:origin_of_LSC, 0], [:index_of_MSC, 0], [:epoch_in_CE, 0], 
       :unit, :base, :pair, :note,
       :location, :time_basis, :border, :formula, :domain]

    # 年/日の原点(origin of most significant coordinate)
    #
    # @return [Integer]
    #
    attr_reader :origin_of_MSC

    # 日/秒の原点(origin of least significant coordinate)
    #
    # @return [Integer]
    #
    attr_reader :origin_of_LSC

    # インデクスオブジェクト
    #
    # @return [Array<When::Coordinates::Index>]
    #
    attr_reader :indices

    # 年/日のインデクス(index of most significant coordinate)
    #
    # @return [Integer]
    #
    attr_reader :index_of_MSC

    # 日時要素の要素数
    #
    # @return [Array<Integer, nil>]
    #
    #   Ex. [nil, 12],       [nil, 24, 60, 60]
    #
    #   初期化時に indices から自動生成する
    #
    attr_reader :unit

    # 日時要素の下限
    #
    # @return [Array<Integer, nil>]
    #
    #   Ex. [nil, 1,  1],    [nil,  0,  0,  0]
    #
    #   初期化時に indices から自動生成する
    #
    # @note 日付/日時の外部表現の「下限」を指定する。内部表現の下限は常に 0 である。
    # サブクラスが定義するメソッド _coordinates_to_number, _number_to_coordinates は内部表現を使用する。
    #
    attr_reader :base

    # 日時要素がPairであるべきか
    #
    # @return [Array<Boolean>]
    #
    #   Ex. [false] * 3,     [false] * 4
    #
    #   初期化時に indices から自動生成する
    #
    attr_reader :pair

    # 代表暦注
    #
    # @return [When::CalendarNote]
    # @return [Array<Array<klass, Array<klass, method, block>>>] 最外側のArray要素は年・月・日に対応
    #
    #   klass  [String, When::CalendarNote, When::Coordinates::Residue]
    #
    #   method [String, Symbol] (デフォルト 'day', 'month' or 'year' (対応する桁による))
    #
    #   block  [Block] (デフォルト なし)
    #
    def note
      case @note
      when String ; @note = When.CalendarNote(@note)
      when Array  ; @note = When::CalendarNote.new(*@note)
      end
      @note
    end

    #
    # 日時要素の正規化
    #
    # @param [Array<Numeric>] source 正規化しようとしている日時要素の Array
    # @param [Array<Numeric>] other  日時要素ごとに加減算を行う場合、加減算量の Array を指定する
    # @param [Block] block
    # @note
    #   日付要素と時刻要素に関連がある場合、block を指定して、両者の
    #   情報をやり取りする( yield で通日を渡し、通日を返してもらう)。
    #
    #   例1: 夏時間制を採用している場合、日付によって時刻の正規化の仕方が影響を受ける
    #
    #   例2: 日の境界が日没の場合、当該時刻が日没の前か後かで日付が変わる
    #
    # @return [Array<Numeric>] 正規化された日時要素の Array
    #
    #  日時要素は、それぞれの When::TM::Calendar や When::TM::Clock の実装に応じて有効な値となっている。
    #
    def _validate(source, other=nil, &block)
      return _encode(_decode(source, other, &block))
    end

    # 期間指定用 Array の桁数合わせ
    #
    # @param [Array<Numeric>] period
    #
    # @return [Array<Numeric>] 桁数合わせをした Array
    #
    def _arrange_length(period)
      return period unless period.kind_of?(Array)
      diff = @indices.length - period.length + 1
      return period if (diff == 0)
      return (diff > 0) ? Array.new(diff, 0) + period : period[(-diff)..-1]
    end

    # @private
    #
    # 対応する ::Date の start 属性
    def _default_start
      ::Date::GREGORIAN
    end

    # protected

    #
    # 日時要素の encode
    #
    # @param [Array<Numeric>] source 日時要素の内部表現に対応する Array
    #
    # @return [Array<Numeric>] 日時要素の外部表現に対応する Array
    #
    def _encode(source, border=@border)
      # source は非破壊
      date = source.dup

      # 外部表現に戻す
      date[0] = +date[0]
      (@base.length-1).downto(@unit.length-1) do |i|
        date[i] = _from_index(date[0..i]) || date[i] + (@base[i]||0)
      end
      date[0] = source[0]

      # 結果を反映
      date = border._adjust_epoch(date, self) if border
      _encode_upper_structure(date)
    end

    private

    #
    # 日時要素の decode
    #
    # @param [Array<Numeric>] source 日時要素の外部表現に対応する Array
    #
    # @return [Array<Numeric>] 日時要素の内部表現に対応する Array
    #
    def _decode(source, other=nil)

      # other の正規化
      period = other ? other.dup : Array.new(@indices.length+1,0)

      # 上の位の集約
      date = _decode_upper_structure(source.dup)
      if (@index_of_MSC > 0) && other
        u = 1
        s = period[@index_of_MSC]
        (@index_of_MSC-1).downto(0) do |i|
          u *= @indices[i].unit
          s += u * period[i]
        end
        period = [s] + period[(@index_of_MSC+1)..-1]
      end

      # 下の位の既定値
      unless date[1] || !@border
        date[0...@base.length] = @border.border([@border._date_adjust(date[0])], self)
      end

      # 要素数固定部分の正規化(上 -> 下) - ISO8601 の 小数要素(ex. "T23:20.8")の処理
      coordinates = [date]
      coordinates << period if other
      coordinates.each do |coord|
        carry = 0
        @unit.length.times do |i|
          if carry == 0
            break unless coord[i]
          else
            coord[i] ||= 0
            coord[i]  += carry * unit[i]
          end
          if coord[i].kind_of?(Integer)
            carry = 0
          else
            if i < @unit.length-1
              carry    = (coord[i].kind_of?(Pair) ? coord[i].trunk : coord[i]) % 1
              coord[i] -= carry
            end
            coord[i] = coord[i].to_i if coord[i].kind_of?(Float) && coord[i] == coord[i].to_i
          end
        end
      end

      # 要素数固定部分の正規化(下 -> 上)
      carry = 0
      (@unit.length-1).downto(1) do |i|
        if date[i]
          digit = date[i] + ((other || date[i]>=0) ? period[i]-@base[i] : @unit[i])
        else
          digit = period[i]
        end
        carry, date[i] = (digit + carry).divmod(@unit[i])
      end
      year = date[0] + period[0] + carry

      # 要素数可変部分の正規化
      limit = @base.length-1
      count = nil
      date[0] = +year
      if @base.length > @unit.length
        @unit.length.upto(limit) do |i|
          len    = _length(date[0...i])
          if date[i]
            plus   = date[i]>=0
            digit  = !plus ? +date[i] : _to_index(date[0..i]) || +date[i] - @base[i]
            digit += (plus || other) ? period[i] : len
          else
            digit  = period[i]
          end

          if i==limit then 
            # 最下位
            if (0...len) === digit
              # 要素が範囲内
              date[i] = digit
            elsif other && period[i] == 0
              # 要素が範囲外で、加算自体はあるが“日”の加算なし
              date[i] = len-1
            else
              # 要素が範囲外で、加算自体がないか“日”の加算あり
              date[i] = 0
              count   = _coordinates_to_number(*date)+digit
              count   = yield(count) if block_given?
              date    = _number_to_coordinates(count)
            end

          else
            # 最下位以外
            #   要素が大きすぎる場合
            while digit >= len do
              digit -= len
              carry  = 1
              (i-1).downto(1) do |k|
                if date[k] >= _length(date[0...k])-1
                  date[k]  = 0
                  carry    = 1
                else
                  date[k] += 1
                  carry    = 0
                  break
                end
              end
              date[0] += carry
              len      = _length(date[0...i])
            end

            #   要素が小さすぎる場合
            while digit < 0 do
              date[i-1] -= 1
              digit     += _length(date[0...i])
              (i-1).downto(1) do |k|
                break if (date[k] >= 0)
                date[k-1] -= 1
                date[k]    = _length(date[0...k]) - 1
              end
            end

            # 要素が範囲内
            date[i] = digit
          end
        end
      end
      date[0] = year + (date[0] - +year)

      # 時刻部分による補正が入る場合
      if block_given? && !count
        count    = _coordinates_to_number(*date)
        modified = yield(count)
        date     = _number_to_coordinates(modified) unless count == modified
      end

      # 結果を返す
      return date
    end

    #
    # 日時要素の下限を取得する
    #
    # @param [Array<Numeric>] date 日時要素
    #
    # @return [Integer] 日時要素の下限
    #
    def _base(date)
      return @base[date.length]
    end

    #
    # 日時要素の番号から要素を取得する配列を返す
    #
    #def _ids(date)
    #  return nil
    #end

    #
    # 日時要素の要素数を取得する(直下の要素)
    #
    #def _length(date)
    #  return @unit[date.length]
    #end

    #
    # 日時要素の要素数を取得する(全要素)
    #
    # @param [Array<Numeric>] date 日時要素(内部表現)
    #
    # @return [Integer] 日時要素の要素数
    # @note 一般に date が 1要素ならその要素の年の日数、2要素ならその要素の年月の日数になる。
    #
    def _sum_(date)
      return @unit[date.length..-1].inject(1) {|p, u| p * u }
    end

    def _normalize_temporal

      # method cash
      @_m_cash_lock_ = Mutex.new if When.multi_thread

      # label
      @label = When::BasicTypes::M17n.label(@label)

      # Origin and Upper Digits
      @origin_of_MSC  ||= - @border.behavior * 1 if @border
      @origin_of_MSC    = Pair._en_number(@origin_of_MSC)
      @origin_of_LSC    = Pair._en_number(@origin_of_LSC)
      @index_of_MSC     = Pair._en_number(@index_of_MSC)
      if @index_of_MSC != 0
        extend OriginAndUpperDigits
      elsif @origin_of_MSC != 0
        extend OriginOnly
      end

      # unit
      @unit = [nil]
      (@index_of_MSC...@indices.length).each do |i|
        break unless @indices[i].unit
        @unit << @indices[i].unit
      end

      # base & pair
      @base = [nil]
      @pair = [false]
      (@index_of_MSC...@indices.length).each do |i|
        raise ArgumentError, "Base not defined" unless @indices[i].base
        @base <<  @indices[i].base
        @pair << (@indices[i].branch != nil)
      end
      extend IndexConversion unless @pair.uniq == [false]

      # note
      @note ||= 'Default'

      # keys
      @keys = @indices.inject(label.instance_of?(When::Locale) ? label.keys : []) {|key, index| key |= index.keys}
    end

    def _default_index_of_MSC
      unless @index_of_MSC
        [:_coordinates_to_number, :_coordinates_to_number_].each do |to_n|
          if respond_to?(to_n)
            @index_of_MSC = @indices.length - method(to_n).arity + 1
            break
          end
        end
      end
    end

    # 何もしない
    def _return_nil(source); nil end
    alias :_from_index :_return_nil
    alias :_to_index   :_return_nil

    def _do_nothing(source); source end
    alias :_encode_upper_structure :_do_nothing
    alias :_decode_upper_structure :_do_nothing

    # @private
    module IndexConversion
      #
      # indexのPair化
      #
      # @param [Array<Numeric>] date 最下位が index になっている日時要素
      #
      # @return [When::Coordinates::Pair] 最下位の index に対応する When::Coordinates::Pair
      #
      def _from_index(date)
        return nil unless @pair[date.size-1]
        ids = _ids(date[0..-2])
        m   = ids[date[-1]] if (ids)
        return Pair._force_pair(m) if (ids && m)
        return Pair.new(+date[-1]+@base[date.length-1], 0)
      rescue ArgumentError
        nil
      end

      #
      # Pairのindex化
      #
      # @param [Array<Numeric>] date 最下位が When::Coordinates::Pair になっている日時要素
      #
      # @return [When::Coordinates::Pair] 最下位の When::Coordinates::Pair に対応する index
      #
      def _to_index(date)
        return nil unless @pair[date.size-1]
        ids = _ids(date[0..-2])
        i   = ids.index(date[-1]) if ids
        return i if i
        return nil unless ids && date[-1].kind_of?(Pair)
        digit = Pair.new(date[-1].trunk, date[-1].branch)
        while digit.branch > 0
          digit.branch -= 1
          i = ids.index(digit)
          return i + date[-1].branch - digit.branch if i
        end
        return nil
      rescue ArgumentError
        nil
      end
    end

    alias :_method_missing :method_missing

    # その他のメソッド
    #   When::Coordinates::Temporal で定義されていないメソッドは
    #   処理を下記に移譲する(番号は優先順位)
    #     When::CalendarNote
    #       (1) @note
    #       (2) SolarTerms
    #       (3) LunarPhases
    #     When::Ephemeris::Formula
    #       (4)@formula[0]
    #
    def method_missing(name, *args, &block)
      unless When::Parts::MethodCash::Escape.key?(name)
        if note.respond_to?(name)
          if note.class::CalendarDepend
            instance_eval %Q{
              def #{name}(*args, &block)
                @note.send("#{name}", *(args + [self]), &block)
              end
            } unless When::Parts::MethodCash.escape(name)
            return @note.send(name, *(args + [self]), &block)
          else
            instance_eval %Q{
              def #{name}(*args, &block)
                @note.send("#{name}", *args, &block)
              end
            } unless When::Parts::MethodCash.escape(name)
            return @note.send(name, *args, &block)
          end
        end
        ['SolarTerms', 'LunarPhases'].each do |note|
          if When.CalendarNote(note).respond_to?(name)
            instance_eval %Q{
              def #{name}(*args, &block)
                When.CalendarNote("#{note}").send("#{name}", *args, &block)
              end
            } unless When::Parts::MethodCash.escape(name)
            return When.CalendarNote(note).send(name, *args, &block)
          end
        end
        if When::Ephemeris::Formula.method_defined?(name)
          unless respond_to?(:forwarded_formula, true)
            extend When::Ephemeris::Formula::ForwardedFormula
            @formula ||= When::Ephemeris::Formula.new({:location=>@location})
            @formula   = When.Resource(Array(@formula), '_ep:')
          end
          instance_eval %Q{
            def #{name}(*args, &block)
              forward = forwarded_formula("#{name}", args[0])
              return forward.send("#{name}", *args, &block) if forward
              _method_missing("#{name}", *args, &block)
            end
          } unless When::Parts::MethodCash.escape(name)
          forward = forwarded_formula(name, args[0])
          return forward.send(name, *args, &block) if forward
        end
      end
      _method_missing(name, *args, &block)
    end

    # @private
    module OriginOnly
      # 上の位の付加
      #
      # @param [Array<Numeric>] source 日時要素の内部表現に対応する Array
      #
      # @return [Array<Numeric>] 日時要素の外部表現に対応する Array
      #
      def _encode_upper_structure(source)
        date     = source.dup
        date[0] += @origin_of_MSC
        return date
      end

      # 上の位の除去
      #
      # @param [Array<Numeric>] source 日時要素の外部表現に対応する Array
      #
      # @return [Array<Numeric>] 日時要素の内部表現に対応する Array
      #
      def _decode_upper_structure(source)
        date     = source.dup
        date[0] -= @origin_of_MSC
        return date
      end
    end

    # @private
    module OriginAndUpperDigits
      # 上の位の付加
      #
      # @param [Array<Numeric>] source 日時要素の内部表現に対応する Array
      #
      # @return [Array<Numeric>] 日時要素の外部表現に対応する Array
      #
      def _encode_upper_structure(source)
        date     = source.dup
        date[0] += @origin_of_MSC
        @index_of_MSC.downto(1) do |i|
          carry, date[0] = (+date[0]).divmod(@indices[i-1].unit)
          date[0] += @indices[i-1].base
          date.unshift(carry)
        end
        return date
      end

      # 上の位の除去
      #
      # @param [Array<Numeric>] source 日時要素の外部表現に対応する Array
      #
      # @return [Array<Numeric>] 日時要素の内部表現に対応する Array
      #
      def _decode_upper_structure(source)
        date = source.dup
        u    = 1
        s    = 0
        @index_of_MSC.downto(1) do |i|
          s += u * (+date[i] - @indices[i-1].base) if (date[i])
          u *= @indices[i-1].unit
        end
        date[@index_of_MSC] = s + u * (+date[0]) - @origin_of_MSC
        return date[@index_of_MSC..-1]
      end
    end
  end

  #
  # 日時要素の境界 - Border
  #
  class Border < When::BasicTypes::Object
    #
    # 境界の振舞
    #
    # @return [Numeric]
    #
    #  Pair(-1,+1) - 暦年/暦日が進む(境界が前年/日にあり、境界後が当年/日の扱いになる)
    #
    #  Pair( 0, 0) - 暦年/暦日が戻る(境界が当年/日にあり、境界前が前年/日の扱いになる)
    #
    def behavior
      @border[0]
    end

    # 境界の取得
    #
    # @param [Array<Numeric>] date 境界を計算する年/日
    # @param [When::TM::ReferenceSystem] frame 使用する暦法/時法
    #
    # @return [Array<Numeric>] その年/日の境界
    #
    def border(date=[], frame=nil)
      last = date.length-1
      return @border if last<0
      b_date = date[0..last] + @border[(last+1)..-1]
      branch = @border[last] * 0
      b_date[last] = When::Coordinates::Pair.new(date[last] * 1, branch)
      return b_date
    end

    # 境界の正規化
    #
    # @param [Array<Numeric>] date 境界を計算する年/日
    # @param [When::TM::ReferenceSystem] frame 使用する暦法/時法
    #
    # @return [Array<Numeric>] その年/日の境界
    #
    def _adjust_epoch(date, frame=nil)
      s_date  = date.dup
      e_date  = border([+date[0]], frame)
      branch  = behavior * 0
      branch += 1 if (s_date[1..-1] <=> e_date[1..-1]) < 0
      s_date[0] = When::Coordinates::Pair.new(+s_date[0]-branch, branch)
      return s_date
    end

    # 日付の補正
    # @private
    def _date_adjust(source)
      source
    end

    private

    # 要素の正規化
    def _normalize(args=[], options={})
      @border = When::Coordinates::Pair._en_pair_date_time(@border) if @border.kind_of?(String)
    end
  end

  #
  # 日時要素の境界 - 年/日によって、異なる境界を使用する場合
  #
  class MultiBorder < Border

    #
    # 境界の配列
    # @return [Array<When::Coordinates::Border>]
    attr_reader :borders

    #
    # 境界の振舞
    #
    # @return [Numeric]
    #
    #   Pair(-1,+1) - 暦年/暦日が進む(境界が前年/日にあり、境界後が当年/日の扱いになる)
    #
    #   Pair( 0, 0) - 暦年/暦日が戻る(境界が当年/日にあり、境界前が前年/日の扱いになる)
    #
    def behavior
      @borders[0][:border].behavior
    end

    # 境界の取得
    #
    # @param [Array<Numeric>] date 境界を計算する年/日
    # @param [When::TM::ReferenceSystem] frame 使用する暦法/時法
    #
    # @return [Array<Numeric>] その年/日の境界
    #
    def border(date=[], frame=nil)
      last = date.length-1
      return @borders[0][:boder] if (last<0)
      @borders.each do |border|
        return border[:border].border(date, frame) if date[0] >= border[:key]
      end
      date[0..last]
    end

    # 境界の正規化
    #
    # @param [Array<Numeric>] date 境界を計算する年/日
    # @param [When::TM::ReferenceSystem] frame 使用する暦法/時法
    #
    # @return [Array<Numeric>] その年/日の境界
    #
    def _adjust_epoch(date, frame=nil)
      @borders.each do |border|
        next unless date[0] >= border[:key]
        s_date  = date.dup
        e_date  = border[:border].border(date[0..0], frame)
        branch  = border[:border].behavior * 0
        branch += 1 if ((s_date[1..-1] <=> e_date[1..-1]) < 0)
        s_date[0] = When::Coordinates::Pair.new(+s_date[0]-branch, branch)
        return s_date
      end
      date
    end

    private

    # 要素の正規化
    def _normalize(args=[], options={})
      if @borders.kind_of?(String)
        list = @borders.split(/(\(.+?\))/)
        list.shift if list[0]==''
        list.unshift(-Float::MAX) unless list[0] =~ /\(/
        list.push('0-1-1') if list[-1] =~ /\(/
        @borders = []
        loop do
          key, border, *list = list
          break unless key
          key = $1.to_i if key.kind_of?(String) && /\((.+?)\)/ =~ key
          @borders << {:key=>key, :border=>When.Border(border)}
        end
      end
      @borders = @borders.sort_by {|border| -border[:key]}
    end
  end

  #
  # 基準暦法の新年による境界
  #
  class CalendarBorder < Border

    class << self

      private

      def _behalf_of(iri)
        base = iri.dup.sub!('/Coordinates/','/CalendarTypes/')
        return nil unless base
        self.new({'engine'=>When::Parts::Resource._instance(base)})
      end
    end

    # 境界の取得
    #
    # @param [Array<Numeric>] date 境界を計算する年
    # @param [When::TM::ReferenceSystem] frame 使用する暦法/時法
    #
    # @return [Array<Numeric>] その年の境界
    #
    def border(date=[], frame=nil)
      last = date.length-1
      return @border if last<0
      args     = date.dup << {:frame=>@engine}
      args[0] += frame.origin_of_MSC + @border[last] * 1 + (frame.epoch_in_CE - @engine.epoch_in_CE)
      b_date   = frame._encode(frame._number_to_coordinates(When.tm_pos(*args).to_i), nil)
      branch   = @border[last] * 0
      b_date[last] = When::Coordinates::Pair.new(date[last] * 1, branch)
      return b_date
    end

    private

    # 要素の正規化
    def _normalize(args=[], options={})
      @border ||= [When::Coordinates::Pair.new(+1,-1),0,0]
      @border   = When::Coordinates::Pair._en_pair_date_time(@border) if @border.kind_of?(String)
      @engine   = When.Calendar(@engine)
    end
  end

  #
  # 日時要素の境界 - 日の出,日の入り
  #
  class DayBorder < Border

    # 境界の取得
    #
    # @param [Array<Numeric>] date 境界を計算する日
    # @param [When::TM::ReferenceSystem] clock 使用する時法
    #
    # @return [Array<Numeric>] その日の境界
    #
    # @note 属性 @event によって境界を計算する (see {When::Ephemeris::Formula#day_event})
    #
    def border(date=[], clock=When::UTC)
      return @border unless date[0] && clock.formula

      time =
        clock._number_to_coordinates(clock.second *
          clock.time_standard.from_dynamical_time(
            When::TM::JulianDate._d_to_t(
              clock.formula.first.day_event(
                clock.time_standard.to_dynamical_date(date[0] + @border[0]*0), @event, When.Resource('_ep:Sun'), @height
              ))))

      time[0] += When::TM::JulianDate::JD19700101
      time[0]  = When::Coordinates::Pair.new(time[0]-@border[0]*0, @border[0]*0) unless @border[0]*0 == 0
      clock._encode(time, false)
    end

    # 日付の補正
    # @private
    def _date_adjust(source)
      source * 1 + @border[0] * 0
    end
  end

  #
  # 日時要素の境界 - 日の出
  #
  class Sunrise < DayBorder

    private

    # 要素の正規化
    def _normalize(args=[], options={})
      @border   = [0,0,0,0]
      @event    = -1
      @height ||= '0'
    end
  end

  #
  # 日時要素の境界 - 日の入り
  #
  class Sunset < DayBorder

    private

    # 要素の正規化
    def _normalize(args=[], options={})
      @border   = [When::Coordinates::Pair.new(+1,-1),0,0,0]
      @event    = +1
      @height ||= '0'
    end
  end
end
