# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2021 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

#
# 天体の位置計算用モジュール
#
module When::Ephemeris

  autoload :Sun,     'when_exe/ephemeris/sun'
  autoload :Mercury, 'when_exe/ephemeris/planets'
  autoload :Venus,   'when_exe/ephemeris/planets'
  autoload :Earth,   'when_exe/ephemeris/sun'
  autoload :JGD2000, 'when_exe/ephemeris/sun'
  autoload :Mars,    'when_exe/ephemeris/planets'
  autoload :Jupiter, 'when_exe/ephemeris/planets'
  autoload :Saturn,  'when_exe/ephemeris/planets'
  autoload :Uranus,  'when_exe/ephemeris/planets'
  autoload :Neptune, 'when_exe/ephemeris/planets'
  autoload :Pluto,   'when_exe/ephemeris/planets'
  autoload :Moon,    'when_exe/ephemeris/moon'
  autoload :Shadow,  'when_exe/ephemeris/moon'
  autoload :V50,     'when_exe/ephemeris/v50'
  autoload :Hindu,   'when_exe/region/indian'

  autoload :SolarFormulaWithTable, 'when_exe/ephemeris/term_table'
  autoload :LunarFormulaWithTable, 'when_exe/ephemeris/phase_table'

  include Math

  DAY       =   86400.0            # 日 / 秒
  BCENT     =   36524.2194         # ベッセル世紀
  JCENT     =   36525.0            # ユリウス世紀
  JYEAR     = JCENT/100            # ユリウス年
  EPOCH1800 = 2378496.0            # 1800 I 0.5
  EPOCH1900 = 2415021.0            # 1900 I 1.5
  EPOCH1975 = 2442412.5            # 1975 I 0.0
  EPOCH2000 = 2451545.0            # 2000 I 1.5

  DEG     = PI / 180               # 度     / radian
  CIRCLE  = 2 * PI                 # 全円周 / radian
  AU      = 1.49597870E8           # 天文単位距離 / km
  C0      = 299792.458*86400*JCENT # 光速度 / (km/ユリウス世紀)
  PSEC    = 360.0*60.0*60.0/(2*PI) # パーセク / AU
  FARAWAY = 10000.0 * PSEC         # 遠距離物体のための仮定義

  # 演算の番号
  LIN   = -1
  SIN   =  0
  COS   =  1
  SINT  =  2
  COST  =  3
  SINL  =  4
  COSL  =  5
  SINLT =  6
  COSLT =  7
  AcS   =  8

  module_function

  #
  # 多項式
  #
  # @param [Numeric] t 独立変数
  # @param [Array<Numeric>] equ 係数の Array
  #
  # @return [Numeric]
  #
  def polynomial(t, equ)
    equ.reverse.inject(0) {|sum, v| sum * t + v}
  end

  #
  # 三角関数の和
  #
  # @param [Numeric] t 独立変数
  # @param [Array<Numeric>] equ 係数の Array
  # @param [Numeric] dl 位相補正値(デフォルト 補正なし)
  # @param [Integer] count 打ち切り項数(デフォルト 打ち切りなし)
  #
  # @return [Numeric]
  #
  def trigonometric(t, equ, dl=0.0, count=0)
    t2 = t * t
    equ[0..(count-1)].inject(0) do |sum, v|
      op, epoch, freq, amp, sqr = v
      ds = epoch + t * freq
      if (op < 0) # 直線
        ds += t2 * amp
      else        # 三角関数
        ds += t2 * sqr if sqr
        ds += dl  if (op[2]==1) # delta L is exist
        ds  = amp * ((op[0]==1) ? cosd(ds) : sind(ds))
        ds *= t   if (op[1]==1) # time proportional
      end
      sum += ds
    end
  end

  # arc sin / radian
  # @param [Numeric] x 独立変数
  # @return [Numeric]
  def asin(x)
    atan2(x, sqrt(1-x*x))
  end

  # arc cos / radian
  # @param [Numeric] x 独立変数
  # @return [Numeric]
  def acos(x)
    atan2(sqrt(1-x*x), x)
  end

  # 度のcos
  # @param [Numeric] x 独立変数
  # @return [Numeric]
  def cosd(x)
    cos(x * DEG)
  end

  # 度のsin
  # @param [Numeric] x 独立変数
  # @return [Numeric]
  def sind(x)
    sin(x * DEG)
  end

  # 度のtan
  # @param [Numeric] x 独立変数
  # @return [Numeric]
  def tand(x)
    tan(x * DEG)
  end

  # 円周単位のcos
  # @param [Numeric] x 独立変数
  # @return [Numeric]
  def cosc(x)
    cos(x * CIRCLE)
  end

  # 円周単位のsin
  # @param [Numeric] x 独立変数
  # @return [Numeric]
  def sinc(x)
    sin(x * CIRCLE)
  end

  # 円周単位のtan
  # @param [Numeric] x 独立変数
  # @return [Numeric]
  def tanc(x)
    tan(x * CIRCLE)
  end

  #
  # 極座標→直交座標(3次元)
  #
  # @param [Numeric] phi    経度 / CIRCLE
  # @param [Numeric] theta  緯度 / CIRCLE
  # @param [Numeric] radius 距離
  #
  # @return [Array<Numeric>] ( x, y, z )
  #   [ x - x 座標 ]
  #   [ y - y 座標 ]
  #   [ z - z 座標 ]
  #
  def _to_r3(phi, theta, radius)
    c, s = cosc(theta), sinc(theta)
    return [radius*c*cosc(phi), radius*c*sinc(phi), radius*s]
  end

  #
  # 直交座標→極座標(3次元)
  #
  # @param [Numeric] x  x 座標
  # @param [Numeric] y  y 座標
  # @param [Numeric] z  z 座標
  #
  # @return [Array<Numeric>] ( phi, theta, radius )
  #   [ phi    - 経度 / CIRCLE ]
  #   [ theta  - 緯度 / CIRCLE ]
  #   [ radius - 距離 ]
  #
  def _to_p3(x, y, z)
    phi, radius = _to_p2(x,  y)
    theta, radius = _to_p2(radius, z)
    return [phi, theta, radius]
  end

  #
  # 直交座標→極座標(2次元)
  #
  # @param [Numeric] x  x 座標
  # @param [Numeric] y  y 座標
  #
  # @return [Array<Numeric>] ( phi, radius )
  #   [ phi    - 経度 / CIRCLE ]
  #   [ radius - 距離 ]
  #
  def _to_p2(x, y)
    return [0.0, 0.0] if x==0 && y==0
    return [atan2(y,x)/CIRCLE, sqrt(x*x+y*y)]
  end

  #
  # 回転(2次元)
  #
  # @param [Numeric] x  x 座標
  # @param [Numeric] y  y 座標
  # @param [Numeric] t  回転角 / CIRCLE
  #
  # @return [Array<Numeric>] ( x, y )
  #   [ x - x 座標 ]
  #   [ y - y 座標 ]
  #
  def _rot(x, y, t)
    c, s = cosc(t), sinc(t)
    return [x*c - y*s, x*s + y*c]
  end

  # 時間の単位の換算 - 1975年元期の dynamical_time / ユリウス年
  #
  # @param [Numeric] tt ユリウス日(Terrestrial Time)
  #
  # @return [Numeric]
  #
  def julian_year_from_1975(tt)
    return (tt - EPOCH1975) / JYEAR
  end

  # 時間の単位の換算 - 2000年元期の dynamical_time / ユリウス世紀
  #
  # @param [Numeric] tt ユリウス日(Terrestrial Time)
  #
  # @return [Numeric]
  #
  def julian_century_from_2000(tt)
    return (tt - EPOCH2000) / JCENT
  end

  # Δε
  #
  # @param [Numeric] c 2000年からの経過世紀
  #
  # @return [Numeric] 緯度の章動 / CIRCLE
  #
  def delta_e(c)
    trigonometric(c, 
      [[COS   ,  125.04      ,   -1934.136    , +0.00256  ],
       [COS   ,  200.93      ,  +72001.539    , +0.00016  ]]) / 360
  end
  alias :deltaE :delta_e

  # Δφ
  #
  # @param [Numeric] c 2000年からの経過世紀
  #
  # @return [Numeric] 経度の章動 / CIRCLE
  #
  def delta_p(c)
    trigonometric(c, 
      [[SIN   ,  125.04      ,   -1934.136    , -0.00478  ],
       [SIN   ,  200.93      ,  +72001.539    , +0.00037  ]]) / 360
  end
  alias :deltaP :delta_p

  # 黄道傾角
  #
  # @param [Numeric] c 2000年からの経過世紀
  #
  # @return [Numeric] 黄道傾角 / CIRCLE
  #
  def obl(c)
    return (23.43929 + -0.013004*c + 1.0*delta_e(c)) / 360
  end

  # func の逆変換
  #
  # @param [Numeric] t0    独立変数の初期近似値
  # @param [Numeric] y0    逆変換される関数値(nil なら極値を求める)
  # @param [Numeric] delta 戻り値が周期量である場合の周期
  # @param [Numeric] count 収束までの最大繰り返し回数
  # @param [Float]   error 収束と判断する誤差
  # @param [Block]   func  逆変換される関数
  #
  # @return [Numeric] 逆変換結果
  #
  def root(t0, y0=nil, delta=0, count=10, error=1E-6, &func)

    # 近似値0,1
    diff  = [0.01, error*1000].min
    t     = [t0-diff,         t0+diff        ]
    y     = [func.call(t[0]), func.call(t[1])]
    y.map! {|y1| _adjust(y1, y0, delta)} unless delta==0

    # 近似値2(1次関数による近似)
    t << (y0 ? (t[1]-t[0])/(y[1]-y[0])*(y0-y[0])+t[0] : t0)

    # 繰り返し
    i = count
    while ((t[2]-t[1]).abs > error) && (i > 0)
      # 予備計算
      y << func.call(t[2])
      y[2] = _adjust(y[2], y0, delta) unless delta==0
      break if y0 && (y[2]-y0).abs <= error / 10

      # printf("t=%20.7f,L=%20.7f\n",t[2],y[2])
      t01     = t[0]-t[1]
      t02,y02 = t[0]-t[2], y[0]-y[2]
      t12,y12 = t[1]-t[2], y[1]-y[2]

      # 2次関数の係数
      a = ( y02     / t02 - y12     / t12) / t01
      b = (-y02*t12 / t02 + y12*t02 / t12) / t01
      c = y[2]

      if y0
        # 判別式
        if (discriminant = b*b-4*a*(c-y0)) < 0
          # 近似値(1次関数による近似)
          if y12 == 0
            i = -1
            break
          end
          t << t12/y12*(y0-y[1]) + t[1]
        else
          # 近似値(2次関数による近似)
          sqrtd = Math.sqrt(discriminant)
          sqrtd = -sqrtd if b < 0
          t << (t[2] + 2*(y0-c)/(b+sqrtd)) # <-桁落ち回避
        end
      else
        t << (t[2] - b / (2*a))
      end

      t.shift
      y.shift
      i -= 1
    end
    return t[2] if i > 0
    return t[1] + (t[0]-t[1]) / (y[0]-y[1]) * (y0-y[1]) if y0 && count < 6
    raise RangeError, "The result does not converge - #{t}->#{y}."
  end

  # y が周期量である場合の周期の補正
  def _adjust(y1, y0, delta)
    (-2..+2).to_a.map {|i| y1 + i * delta}.sort_by {|y| (y-y0).abs}[0]
  end
  private :_adjust

  #
  # 天体の座標
  #
  class Coords

    include When::Ephemeris

    class << self
      alias :polar :new

      # オブジェクトの生成
      #
      # @param [Numeric] x  x 座標
      # @param [Numeric] y  y 座標
      # @param [Numeric] z  z 座標
      # @param [Numeric] c  周回数(デフォルト - phi から生成)
      #
      #   極座標との1対1対応を保証するため、z軸の周りを何週して
      #   現在の位置にあるかを保持する
      #
      # @return [When::Ephemeris::Coords]
      # 
      def rectangular(x, y, z, c=nil)
        Coords.new(x, y, z, c, {:system=>:rectangular})
      end
    end

    # 直交座標
    #
    # @return [Array<Numeric>] ( x, y, z )
    #   [ x - x 座標 ]
    #   [ y - y 座標 ]
    #   [ z - z 座標 ]
    #
    def rectangular
      @x, @y, @z = _to_r3(@phi, @theta, @radius) unless @z
      return [@x, @y, @z]
    end

    # x 座標
    #
    # @return [Numeric]
    #
    def x ; @x || rectangular[0] ; end

    # y 座標
    #
    # @return [Numeric]
    #
    def y ; @y || rectangular[1] ; end

    # z 座標
    #
    # @return [Numeric]
    #
    def z ; @z || rectangular[2] ; end

    # 極座標
    #
    # @return  [Array<Numeric>] ( phi, theta, radius, c )
    #   [ phi    - 経度 / CIRCLE ]
    #   [ theta  - 緯度 / CIRCLE ]
    #   [ radius - 距離   ]
    #   [ c      - 周回数 ]
    #
    def polar
      @phi, @theta, @radius = _to_p3(@x, @y, @z) unless @radius
      @c ||=  @phi
      @phi -= (@phi - @c).round
      return [@phi, @theta, @radius, @c]
    end

    # 経度 / CIRCLE
    #
    # @return [Numeric]
    #
    def phi ; @phi || polar[0] ; end

    # 緯度 / CIRCLE
    #
    # @return [Numeric]
    #
    def theta ; @theta || polar[1] ; end

    # 距離
    #
    # @return [Numeric]
    #
   def radius ; @radius || polar[2] ; end

    # 周回数
    #
    # @return [Numeric]
    #
    def c  ; @c  || polar[3] ; end

    # 要素参照
    #
    # @param [String, Symbol] z 要素名('x', 'y', 'z', 'phi', 'theta', 'r', 'c', :x, :y, :z, :phi, :theta, :r, :c)
    #
    # @return [Numeric] 要素の値
    #
    def [](z)
      send(z.to_sym)
    end

    # 加法
    #
    # @param  [When::Ephemeris::Coords] other
    #
    # @return [When::Ephemeris::Coords]
    #
    def +(other)
      raise TypeError, 'operand should be When::Ephemeris::Coords' unless other.kind_of?(Coords)
      self.class.rectangular(x+other.x, y+other.y, z+other.z, c+other.c)
    end

    # 減法
    #
    # @param  [When::Ephemeris::Coords] other
    #
    # @return [When::Ephemeris::Coords]
    #
    def -(other)
      raise TypeError, 'operand should be When::Ephemeris::Coords' unless other.kind_of?(Coords)
      self.class.rectangular(x-other.x, y-other.y, z-other.z, c-other.c)
    end

    # 点対称の反転
    #
    # @return [When::Ephemeris::Coords]
    #
    def -@
      self.class.polar(phi+0.5, -theta, radius, c)
    end

    # X 軸を軸とする回転
    #
    # @param [Numeric] t 回転角 / CIRCLE
    #
    # @return [When::Ephemeris::Coords]
    #
    def rotate_x(t)
      cos = cosc(t)
      sin = sinc(t)
      self.class.rectangular(x, y*cos-z*sin, y*sin+z*cos, c)
    end

    # Y 軸を軸とする回転
    #
    # @param [Numeric] t 回転角 / CIRCLE
    #
    # @return [When::Ephemeris::Coords]
    #
    def rotate_y(t)
      cos = cosc(t)
      sin = sinc(t)
      self.class.rectangular(z*sin+x*cos, y, z*cos-x*sin, c)
    end

    # Z 軸を軸とする回転
    #
    # @param [Numeric] t 回転角 / CIRCLE
    #
    # @return [When::Ephemeris::Coords]
    #
    def rotate_z(t)
      self.class.polar(phi+t, theta, radius, c+t)
    end

    #
    # 章動
    #
    # @param [Numeric] c 2000年からの経過世紀
    #
    # @return [When::Ephemeris::Coords]
    #
    def nutation(c)
      rotate_z(delta_p(c)).rotate_x(delta_e(c))
    end

    #
    # 歳差
    #
    # @param [Numeric] dt 分点からの経過時間 / ベッセル世紀
    # @param [Numeric] t0 分点               / ベッセル世紀
    #
    # @return [When::Ephemeris::Coords]
    #
    def precession(dt, t0)
      return self if (theta.abs>=0.25)

      b0 = dt / (360 * 3600.0)
      b1 = [+0.302, +0.018]
      b2 = [+0.791, +0.001]
      b3 = [-0.462, -0.042]

      b1.unshift(2304.250 + 1.396 * t0)
      b2.unshift(polynomial(dt, b1))
      b3.unshift(2004.682 - 0.853 * t0)

      z0 = b0 * b2[0]
      zt = b0 * polynomial(dt, b2)
      th = b0 * polynomial(dt, b3)

      a  = phi + z0
      b  = th / 2
      cA = cosc(a)
      sA = sinc(a)
      tB = tanc(b)
      q  = sinc(th)*(tanc(theta) + tB*cA)

      dRA = atan2(q*sA, 1-q*cA) / CIRCLE
      dDC = atan2(tB*(cA-sA*tanc(dRA/2)), 1) / CIRCLE

      self.class.polar(phi + dRA + z0 + zt, theta + 2*dDC, radius, @c)
    end

    # 地心視差 (黄道座標) / 地心位置 -> 測心位置(観測地中心位置) 
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    # @param [When::TM::TemporalPosition] t
    # @param [When::Coordinates::Spatial] loc 観測地
    #
    # @return [When::Ephemeris::Coords]
    #
    def parallax(t, loc)
      return self if loc.alt==When::Coordinates::Spatial::Center
      self - loc.coords_diff(t)
    end

    # 赤道座標 -> 黄道座標
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    # @param [When::TM::TemporalPosition] t
    # @param [When::Coordinates::Spatial] loc 観測地
    #
    # @return [When::Ephemeris::Coords]
    #
    def r_to_y(t, loc=nil)
      t   = +t
      loc = loc.datum unless loc.kind_of?(Datum)
      n   = loc.axis_of_rotation(t) if loc
      if (n)
        c = rotate_z(+0.25 - n.radius).
            rotate_y(+0.25 - n.theta).
            rotate_z(+n.phi)
      else
        c = self
      end
      return c.rotate_x(-obl(julian_century_from_2000(t)))
    end

    # 黄道座標 -> 赤道座標
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    # @param [When::TM::TemporalPosition] t
    # @param [When::Coordinates::Spatial] loc 観測地
    #
    # @return [When::Ephemeris::Coords]
    #
    def y_to_r(t, loc=nil)
      t   = +t
      c   = rotate_x(+obl(julian_century_from_2000(t)))
      loc = loc.datum unless loc.kind_of?(Datum)
      n   = loc.axis_of_rotation(t) if loc
      return c unless n
      c.rotate_z(-n.phi).
        rotate_y(-0.25 + n.theta).
        rotate_z(-0.25 + n.radius)
    end

    # 赤道座標 -> 赤道座標[時角]
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    # @param [When::TM::TemporalPosition] t
    # @param [When::Coordinates::Spatial] loc 観測地
    #
    # @return [When::Ephemeris::Coords]
    #
    def r_to_rh(t, loc)
      rotate_z(-loc.local_sidereal_time(t) / 24)
    end

    # 赤道座標[時角] -> 地平座標
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    # @param [When::TM::TemporalPosition] t
    # @param [When::Coordinates::Spatial] loc 観測地
    #
    # @return [When::Ephemeris::Coords]
    #
    def rh_to_h(t, loc)
      rotate_y(loc.lat / (360.0*loc.degree) - 0.25)
    end

    # 赤道座標 -> 地平座標
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    # @param [When::TM::TemporalPosition] t
    # @param [When::Coordinates::Spatial] loc 観測地
    #
    # @return [When::Ephemeris::Coords]
    #
    def r_to_h(t, loc)
      rotate_z(-loc.local_sidereal_time(t) / 24).
      rotate_y(loc.lat / (360.0*loc.degree) - 0.25)
    end

    # 球面の余弦 spherical law of cosines
    #
    # @param [When::Ephemeris::Coords] other
    #
    # @return [Numeric]
    #
    def spherical_law_of_cosines(other)
      sinc(theta)*sinc(other.theta) + cosc(theta)*cosc(other.theta)*cosc(phi-other.phi)
    end

    # 太陽から見た地球と惑星の視距離の余弦 - cosine of angle Earth - Sun - Planet
    #
    # @return [Numeric]
    #
    alias :cos_esp :spherical_law_of_cosines

    # 地球から見た惑星と太陽の視距離の余弦 - cosine of angle Planet - Earth - Sun
    #
    # @param [When::Ephemeris::Coords] planet
    #
    # @return [Numeric]
    #
    def cos_pes(planet)
      spherical_law_of_cosines(self - planet)
    end

    # 惑星から見た太陽と地球の視距離の余弦(惑星の満ち具合) - cosine of angle Sun - Planet - Earth
    #
    # @param [When::Ephemeris::Coords] planet
    #
    # @return [Numeric]
    #
    def cos_spe(planet)
      planet.spherical_law_of_cosines(planet - self)
    end

    # 惑星の明るさ - luminosity used cosine of angle Sun - Planet - Earth
    #
    # @param [When::Ephemeris::Coords] planet
    #
    # @return [Numeric]
    #
    def luminosity_spe(planet)
      difference = planet - self
      (planet.spherical_law_of_cosines(difference) + 1) / ( 2 * planet.radius * planet.radius * difference.radius * difference.radius)
    end

    # オブジェクトの生成
    #
    # @overload initialize(x, y, z, options={ :system=>:rectangular })
    #   引数パターン 1
    #   @param [Numeric] x x 座標
    #   @param [Numeric] y y 座標
    #   @param [Numeric] z z 座標
    #   @param [Hash] options {  :system=>:rectangular }
    #
    # @overload initialize(phi, theta, radius, c, options={})
    #   @param [Numeric] phi    経度 / CIRCLE
    #   @param [Numeric] theta  緯度 / CIRCLE
    #   @param [Numeric] radius 距離
    #   @param [Numeric] c      周回数
    #   @param [Hash] options {  :system=>:rectangular以外 }
    #
    # @note c - 周回数(デフォルト - phi から生成) z軸の周りを何週して現在の位置にあるかを保持する
    #
    def initialize(*args)
      @options = args[-1].kind_of?(Hash) ? args.pop.dup : {}
      if @options[:system] == :rectangular
        @x, @y, @z, @c = args
        @x  ||= 0.0  # X座標
        @y  ||= 0.0  # Y座標
        @z  ||= 0.0  # Z座標
      else
        @phi, @theta, @radius, @c = args
        @phi    ||=  0.0  # 経度
        @theta  ||=  0.0  # 緯度
        @radius ||=  1.0  # 距離
        @c      ||=  @phi # 周期番号
        @phi     -= (@phi - @c).round
      end
    end
  end

  # 天体
  #
  #   天体の特性を定義する
  #
  class CelestialObject < When::BasicTypes::Object

    include When::Ephemeris

    # 光行差 / 度
    # @return [Numeric]
    attr_reader :aberration

    # 光度   / magnitude
    # @return [Numeric]
    attr_reader :luminosity

    # 天体位置 (黄道座標)
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    # @param [When::TM::TemporalPosition] t
    # @param [When::Coordinates::Spatial, When::Ephemeris::Datum] base 基準地
    #
    # @return [When::Ephemeris::Coords]
    #
    def coords(t, base=nil)
      t = +t
      target_coords = self._coords(t)
      return target_coords unless base
      base_coords = base._coords(t)
      differrence = target_coords - base_coords
      delta_phi   = differrence.phi - base_coords.phi
      phi         = differrence.phi
      theta       = differrence.theta
      if @aberration && @aberration != 0
        phi -= @aberration / 360 * cosc(differrence.phi - target_coords.phi) / target_coords.radius
      end
      if base.respond_to?(:aberration)
        phi   += base.aberration / 360 / cosc(theta) * cosc(delta_phi) / base_coords.radius
        theta -= base.aberration / 360 * sinc(theta) * sinc(delta_phi) / base_coords.radius
      end
      Coords.polar(phi, theta, differrence.radius, differrence.c)
    end
  end

  # 天球上の物体
  #
  #   天球上の物体の特性を定義する
  #   天球上にあるため、座標の基準にならない
  #
  class Star < CelestialObject
    # 分点 / YEAR
    # @return [Numeric]
    attr_reader :t0

    # 赤経 / DEG
    # @return [Numeric]
    attr_reader :phi

    # 赤緯 / DEG
    # @return [Numeric]
    attr_reader :theta

    # 視差 / milli arc SECOND
    # @return [Numeric]
    attr_reader :parallax

    # 固有運動(赤経) / (milli arc SECOND / year)
    # @return [Numeric]
    attr_reader :delta_phi

    # 固有運動(赤経) / (milli arc SECOND / year)
    # @return [Numeric]
    attr_reader :delta_theta

    # 視線速度  / (km/s)
    # @return [Numeric]
    attr_reader :delta_radius

    # 視半径 / CIRCLE
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    # @param [When::TM::TemporalPosition] t
    # @param [When::Coordinates::Spatial, When::Ephemeris::Datum] base 基準地
    #
    # @return [Numeric]
    #
    def apparent_radius(t, base=nil)
      0
    end

    # 視光度 / magnitude
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    # @param [When::TM::TemporalPosition] t
    # @param [When::Coordinates::Spatial, When::Ephemeris::Datum] base 基準地
    #
    # @return [Numeric]
    #
    def apparent_luminosity(t, base=nil)
      @luminosity
    end

    # Bayer 名
    #
    # @return [String]
    #
    def bayer_name
      @bayer
    end

    # @private
    def _normalize(args=[], options={})
      t0, phi, theta, parallax, delta_phi, delta_theta, delta_radius, luminosity, bayer = args
      @t0           ||= t0           || 2000.0
      @phi          ||= phi          ||    0.0
      @theta        ||= theta        ||   90.0
      @parallax     ||= parallax     ||    0.0
      @delta_phi    ||= delta_phi    ||    0.0
      @delta_theta  ||= delta_theta  ||    0.0
      @delta_radius ||= delta_radius ||    0.0
      @distance     ||= PSEC / ([@parallax, 0.1].max / 1000.0)
      @luminosity   ||= luminosity
      @bayer        ||= bayer
    end

    # 恒星
    class Fixed < Star

      Coef  = 100.0 / (3600*1000)

      # 天体位置 (黄道座標)
      #
      # @param [Numeric] t ユリウス日(Terrestrial Time)
      # @param [When::TM::TemporalPosition] t
      #
      # @return [When::Ephemeris::Coords]
      #
      def _coords(t)
        t  = +t
        c2000 = julian_century_from_2000(t)
        c1900 = (@t0-1900.0)/100.0
        dt    = (t-(EPOCH1900-0.68648354))/BCENT - c1900
        Coords.polar(
            (@phi      + dt * @delta_phi   * Coef) / 360,
            (@theta    + dt * @delta_theta * Coef) / 360,
             @distance - dt * @delta_radius / (AU/(BCENT*86400.0))).
          precession(dt, c1900).
          rotate_x(-obl(c2000)).
          nutation(c2000)
      end
    end

    # 春分点
    class Vernal < Star

      # 天体位置 (黄道座標)
      #
      # @param [Numeric] t ユリウス日(Terrestrial Time)
      # @param [When::TM::TemporalPosition] t
      #
      # @return [When::Ephemeris::Coords]
      #
      def _coords(t)
        Coords.polar(0, 0, FARAWAY)
      end
    end

    # 北極
    class Pole < Star

      # 天体位置 (黄道座標)
      #
      # @param [Numeric] t ユリウス日(Terrestrial Time)
      # @param [When::TM::TemporalPosition] t
      #
      # @return [When::Ephemeris::Coords]
      #
      def _coords(t)
        Coords.polar(0, +0.25, FARAWAY).r_to_y(+t)
      end
    end
  end

  # 座標の基準になる天体
  #
  #   座標の基準になる天体の特性を定義する
  #
  class Datum < CelestialObject
    # 半径/km
    # @return [Numeric]
    attr_reader :surface_radius

    # 計算式の精度保証期間の下限 / ユリウス日
    # @return [Numeric]
    attr_reader :first_day

    # 計算式の精度保証期間の上限 / ユリウス日
    # @return [Numeric]
    attr_reader :last_day

    # 黄経の係数
    # @return [Array<Numeric>]
    attr_reader :phi

    # 黄経の補正の係数
    # @return [Array<Numeric>]
    attr_reader :dl

    # 黄緯の係数
    # @return [Array<Numeric>]
    attr_reader :theta

    # 動径の係数
    # @return [Array<Numeric>]
    attr_reader :radius

    # 木星と土星の相互摂動項
    # @return [Array<Numeric>]
    attr_reader :nn

    # 黄経の係数1 (木星-土星)
    # @return [Array<Numeric>]
    attr_reader :jsn

    # 黄経の係数2 (木星-土星)
    # @return [Array<Numeric>]
    attr_reader :jsl

    # 黄緯の係数 (木星-土星)
    # @return [Array<Numeric>]
    attr_reader :jst

    # 動径の係数 (木星-土星)
    # @return [Array<Numeric>]
    attr_reader :jsr

    # 惑星の形
    # @return [Array<Numeric>]
    attr_reader :shape

    # 自転 - 平均太陽の赤経(2000年分点)
    # @return [Array<Numeric>]
    attr_reader :sid

    # 天体の出没、薄明の閾値
    # @return [Hash<String=>Numeric>]
    attr_reader :zeros

    # 大気の補正
    # @return [Array<Numeric>]
    attr_reader :air

    # 自転軸
    # @return [Array<Numeric>]
    attr_reader :axis

    #
    # 平均運動 / (DEG / YEAR)
    #
    # @return [Numeric]
    #
    def mean_motion
      return @phi[0][2]
    end

    #
    # 光行差を含んだ平均黄経 / CIRCLE
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    # @param [When::TM::TemporalPosition] t
    #
    # @return [Numeric]
    #
    def mean_longitude(t)
      coord = _coords(t)
      coord.c - @aberration / coord.radius / 360
    end

    #
    # 光行差を含んだ真黄経 / CIRCLE
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    # @param [When::TM::TemporalPosition] t
    #
    # @return [Numeric]
    #
    def true_longitude(t)
      coord = _coords(t)
      coord.phi - @aberration / coord.radius / 360
    end

    #
    # 自転軸の歳差補正
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    # @param [When::TM::TemporalPosition] t
    #
    # @return [When::Ephemeris::Coords]
    #
    def axis_of_rotation(t)
      return nil unless @axis
      c1900 = (@axis[0]-1900.0)/100.0
      dt    = (+t-(EPOCH1900-0.68648354))/BCENT - c1900
      Coords.polar(
        (@axis[1][0] + dt * @axis[2][0]) / 360,
        (@axis[1][1] + dt * @axis[2][1]) / 360,
        (@axis[1][2] + dt * @axis[2][2]) / 360
      ).precession(dt, c1900)
    end

    # 均時差 / DAY
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    # @param [When::TM::TemporalPosition] t
    #
    # @return [Numeric]
    #
    def equation_of_time(t)
      t = +t
      c = julian_century_from_2000(t)
      coords = _coords(t)
      coords = coords.rotate_z(0.5 - (@aberration||0) / coords.radius / 360)
      coords = coords.y_to_r(t, self)
      return 0.5 - ((coords.phi - (@sid[0] + c * (@sid[1] + c * @sid[2])) / 24.0) % 1)
    end

    # 視半径 / CIRCLE
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    # @param [When::TM::TemporalPosition] t
    # @param [When::Coordinates::Spatial, When::Ephemeris::Datum] base 観測地
    #
    # @return [Numeric]
    #
    def apparent_radius(t, base=Earth)
      target_coords = self.coords(t, base)
      asin(@surface_radius / (target_coords.radius * AU)) / CIRCLE
    end

    # 視光度 / magnitude
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    # @param [When::TM::TemporalPosition] t
    # @param [When::Coordinates::Spatial, When::Ephemeris::Datum] base 観測地
    #
    # @return [Numeric]
    #
    def apparent_luminosity(t, base)
      return @luminosity - 2.5*log10(base._coords(t).luminosity_spe(self._coords(t)))
    end

    # 離角 / CIRCLE
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    # @param [When::TM::TemporalPosition] t
    # @param [When::Ephemeris::Datum] target 基準星
    # @param [When::Coordinates::Spatial, When::Ephemeris::Datum] base 観測地
    #
    # @return [Numeric]
    #
    def elongation(t, target=Sun, base=Earth)
      t = +t
      self_coords   = self.coords(t, base)
      target_coords = target.coords(t, base)
      elongation    = acos(self_coords.spherical_law_of_cosines(target_coords)) / CIRCLE
      difference    = (self_coords.phi - target_coords.phi + 0.5) % 1 - 0.5
      return (difference >= 0) ? elongation : -elongation
    end

    # 食分
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    # @param [When::TM::TemporalPosition] t
    # @param [When::Ephemeris::Datum] target 基準星
    # @param [When::Coordinates::Spatial, When::Ephemeris::Datum] base 観測地
    #
    # @return [Numeric]
    #
    def phase_of_eclipse(t, target, base=Earth)
      t = +t
      distance      = acos(self.coords(t, base).spherical_law_of_cosines(target.coords(t, base))) / CIRCLE
      self_radius   = self.apparent_radius(t, base)
      target_radius = target.apparent_radius(t, base)
      return (self_radius + target_radius - distance) / (2.0 * target_radius)
    end

    private

    def _normalize(args=[], options={})
      surface_radius, aberration, luminosity, first_day, last_day = args
      @surface_radius ||= surface_radius ||  AU
      @aberration     ||= aberration     ||   0.00
      @luminosity     ||= luminosity     || -15.00
      @first_day      ||= first_day      ||  990558
      @last_day       ||= last_day       || 3912515
    end
  end

  #
  # 暦法オブジェクトに天体暦機能を提供する
  #
  class Formula < When::BasicTypes::Object

    include When::Parts::MethodCash
    include When::Ephemeris

    #
    # 天体暦機能を When::TM::Calendar クラスに提供する
    #
    module ForwardedFormula

      private

      #
      # メソッドのレシーバーとなる Formulaオブジェクトを取得する
      #
      def forwarded_formula(name, date)
        return nil unless When::Ephemeris::Formula.method_defined?(name)
        return @formula[0] if @formula && @formula[0].location
        location   = date.location if date.respond_to?(:location)
        location ||= When::Coordinates::Spatial.default_location
        return nil unless location
        When.Resource('_ep:Formula?location=(' + location.iri + ')')
      end
    end

    # 計算対象 - 公式の指定
    # @return [String, Hash]
    attr_reader :formula

    # 観測地
    # @return [When::Coordinates::Spatial]
    attr_reader :location

    # 観測地の基準経度 / 度
    # @return [Numeric]
    attr_reader :long

    # 観測地の基準緯度 / 度
    # @return [Numeric]
    attr_reader :lat

    # 観測地の高度 / m
    # @return [Numeric]
    attr_reader :alt

    # 時刻系('universal' or 'dynamical')
    # @return [String]
    attr_reader :time_standard

    # 時刻系が dynamical か
    # @return [Boolean]
    attr_reader :is_dynamical

    # 天体オブジェクトを保持するハッシュ
    # @return [Hash<Symbol=>When::Ephemeris::Datum>]
    attr_reader :graha

    # Seed
    # @private
    CYCLE_0M =       0
    # @private
    CYCLE_1M = 1000000

    # Year Event
    Sgn = [[-1,+1],[-1,-1],[+1,-1],[+1,+1]]
    Bs  = [[11.0,  7.0, 11.0,  7.0],
           [11.0,  7.0, 11.0,  7.0],
           [11.0,  7.0, 11.0,  7.0],
           [14.0,  8.5, 14.0,  8.5],
           [16.0, 10.0, 16.0, 10.0],
           [17.0, 14.0, 17.0, 14.0],
           [17.0, 17.0, 17.0, 17.0]]

    # 日時 -> 周期番号
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    # @param [When::TM::TemporalPosition] t
    #
    # @return [Numeric] 周期番号
    #
    def time_to_cn(t)
      @proc.call(t)
    end

    # 周期番号 -> 日時
    #
    # @param [Numeric] cn 周期番号
    #
    # @return [Numeric] ユリウス日
    #
    def cn_to_time_(cn, time0=nil)
      time0 ||= (cn - @cycle_number_0m) / @cycle_number_1m
      root(time0, cn) {|t| time_to_cn(t)}
    end

    # 当該日付の月の位相の変化範囲
    #
    # @param [When::TM::TemporalPosition] date 日付
    #
    # @return [Array<Numeric>] 当該日付の月の位相の変化範囲
    #
    def phase_range(date)
      date = date.floor
      [date, date.succ].map {|d|
        time_to_cn(d)
      }
    end

    # 指定の周期番号パターンになる最も近い過去の日時
    #
    # @param [Numeric] date ユリウス日(Terrestrial Time)
    # @param [When::TM::TemporalPosition] date
    # @param [Numeric] n 相対周期番号(n=0 なら date または date の直前が基準)
    # @param [Numeric] d 単位周期数
    #
    # @return [Numeric, When::TM::TemporalPosition] 周期番号が d で割って n になる日時
    #
    def nearest_past(date, n=0, d=1)
      i, f = n.divmod(d)
      t0   = @is_dynamical ? +date : date.to_f
      cn   = time_to_cn(date).divmod(d)[0] * d + f
      cn  -= d while (t1 = cn_to_time(cn)) > t0
      _to_seed_type((i == 0) ? t1 : cn_to_time(cn+i*d), date)
    end

    # 天体の位置情報
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    # @param [When::TM::TemporalPosition] t
    # @param [Integer] system 座標系
    #
    #   [ 0 - 黄道座標       When::Coordinates::Spatial::ECLIPTIC      ]
    #   [ 1 - 赤道座標       When::Coordinates::Spatial::EQUATORIAL    ]
    #   [ 2 - 赤道座標[時角] When::Coordinates::Spatial::EQUATORIAL_HA ]
    #   [ 3 - 地平座標       When::Coordinates::Spatial::HORIZONTAL    ]
    #
    # @param [When::Ephemeris::CelestialObject] target 対象星
    #
    # @return [When::Ephemeris::Coords]
    #
    def _coords(t, system, target)
      pos = target.coords(t, @location)
      pos = pos.y_to_r(t, @location)  if system >= When::Coordinates::Spatial::EQUATORIAL
      pos = pos.r_to_rh(t, @location) if system >= When::Coordinates::Spatial::EQUATORIAL_HA
      pos = pos.rh_to_h(t, @location) if system >= When::Coordinates::Spatial::HORIZONTAL
      return pos
    end

    # 日没時に月が見えるか否か
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    # @param [When::TM::TemporalPosition] t
    #
    # @return [Numeric]
    #  [ 正 - 見える   ]
    #  [ 負 - 見えない ]
    #
    # @note 満月に近い場合は考慮されていません。主に新月の初見の確認に用います。
    #       Dr. Mohammad Ilyas“A Modern Guide to Astronomical Calculations of Islamic Calendar, Times & Qibla”(1984) p.99
    #       see {https://suchowan.at.webry.info/201303/article_10.html 2013-03-10 EphemerisBasedIslamic}
    #
    def moon_visibility(t)
      sun  = When.Resource('_ep:Sun')
      moon = When.Resource('_ep:Moon')

      # 日没時刻
      t = day_event(+t, +1, sun, 'Z')

      # 月の地平線からの高度
      h = _coords(t, When::Coordinates::Spatial::HORIZONTAL, moon).theta * 360.0

      # 月と太陽の離角
      p = moon.elongation(t, sun, @location) * 360.0

      # 指標の計算
      n = 4.0 - 0.1*p
      f = p < 40.0 ? 4.0 + n*(n+1)/2 : 4.0
      return (h / f - 1.0)
    end

    # 天体の出没最大高度日時
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    # @param [When::TM::TemporalPosition] t
    # @param [Integer] event
    #   [ -1   - 出       ]
    #   [  0   - 南中     ]
    #   [ +1   - 没       ]
    #   [  nil - 最大高度 ]
    # @param [When::Ephemeris::CelestialObject] target 対象星(デフォルトは太陽)
    # @param [Numeric] height 閾値高度/度
    # @param [String]  height
    #   [ '0' - 太陽の上端が地平線(大気差考慮) - 太陽のデフォルト     ]
    #   [ 'A' - 天体の中心が地平線(大気差考慮) - 太陽以外のデフォルト ]
    #   [ 'T' - 夜明け/日暮れ ]
    #
    # @return [Numeric, When::TM::TemporalPosotion] 計算結果
    #   [ t が ユリウス日(Terrestrial Time) => ユリウス日(Terrestrial Time) ]
    #   [ t が その他                       => When::TM::DateAndTime ]
    #
    def day_event(t, event, target=When.Resource('_ep:Sun'), height=nil)
      # 時刻の初期値
      dl  = @location.long / (360.0 * @location.degree)
      t0  = (+t + dl).round - dl
      dt  = _coords(t0, When::Coordinates::Spatial::EQUATORIAL, target).phi -
            @location.local_sidereal_time(t0) / 24.0 + 0.25 * (event||0)
      t0 += dt - dt.round

      # 天体の地平座標での高度または方位角
      case event
      when 0
        meridian = _coords(t0, When::Coordinates::Spatial::EQUATORIAL_HA, target).phi.round
      when +1, -1
        height ||= target.instance_of?(When::Ephemeris::Sun) ? '0' : 'A'
        if height.kind_of?(String)
          height = @location.datum.zeros[height.upcase]
          raise ArgumentError, 'invalid height string' unless height
        end
        height = height / 360.0 - (0.25 - @location.horizon) +
               [@location.alt / (1000.0 * @location.datum.air[0]), 1].min * @location.datum.zeros['A'] / 360.0
      else
        height = nil # 極値検索のため
      end

      # イベントの時刻
      _to_seed_type(
        event == 0 ? (root(t0, meridian, 1) {|t1| _coords(t1, When::Coordinates::Spatial::EQUATORIAL_HA, target).phi}) :
                     (root(t0, height     ) {|t1| _coords(t1, When::Coordinates::Spatial::HORIZONTAL, target).theta }),
       t)
    rescue RangeError
      nil
    end

    # 日の出の日時
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    # @param [When::TM::TemporalPosition] t
    # @param [Numeric] height 閾値高度/度
    # @param [String]  height
    #   [ '0' - 太陽の上端が地平線(大気差考慮) - 太陽のデフォルト     ]
    #   [ 'T' - 夜明け ]
    #
    # @return [Numeric, When::TM::TemporalPosotion] 日の出の日時(ユリウス日(Terrestrial Time)またはWhen::TM::DateAndTime
    #
    def sunrise(t, height='0')
      day_event(t, -1, When.Resource('_ep:Sun'), height)
    end

    # 日の入りの日時
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    # @param [When::TM::TemporalPosition] t
    # @param [Numeric] height 閾値高度/度
    # @param [String]  height
    #   [ '0' - 太陽の上端が地平線(大気差考慮) - 太陽のデフォルト     ]
    #   [ 'T' - 日暮れ ]
    #
    # @return [Numeric, When::TM::TemporalPosotion] 日の入りの日時(ユリウス日(Terrestrial Time)またはWhen::TM::DateAndTime
    #
    def sunset(t, height='0')
      day_event(t, +1, When.Resource('_ep:Sun'), height)
    end

    # 太陽の最大高度の日時
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    # @param [When::TM::TemporalPosition] t
    #
    # @return [Numeric, When::TM::TemporalPosotion] 太陽の最大高度の日時(ユリウス日(Terrestrial Time)またはWhen::TM::DateAndTime
    #
    def sun_noon(t)
      day_event(t, nil, When.Resource('_ep:Sun'))
    end

    # 太陽の南中の日時
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    # @param [When::TM::TemporalPosition] t
    #
    # @return [Numeric, When::TM::TemporalPosotion] 太陽の南中の日時(ユリウス日(Terrestrial Time)またはWhen::TM::DateAndTime
    #
    def meridian_passage_of_sun(t)
      day_event(t, 0, When.Resource('_ep:Sun'))
    end

    # 月の出の日時
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    # @param [When::TM::TemporalPosition] t
    # @param [Numeric] height 閾値高度/度
    # @param [String]  height
    #   [ 'A' - 月の中心が地平線 ]
    #
    # @return [Numeric, When::TM::TemporalPosotion] 月の出の日時(ユリウス日(Terrestrial Time)またはWhen::TM::DateAndTime
    #             該当時刻がなければ nil
    #
    def moonrise(t, height='A')
      day_event_in_the_day(t, -1, When.Resource('_ep:Moon'), height)
    end

    # 月の入りの日時
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    # @param [When::TM::TemporalPosition] t
    # @param [Numeric] height 閾値高度/度
    # @param [String]  height
    #   [ 'A' - 月の中心が地平線 ]
    #
    # @return [Numeric, When::TM::TemporalPosotion] 月の入りの日時(ユリウス日(Terrestrial Time)またはWhen::TM::DateAndTime
    #             該当時刻がなければ nil
    #
    def moonset(t, height='A')
      day_event_in_the_day(t, +1, When.Resource('_ep:Moon'), height)
    end

    # 月の最大高度の日時
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    # @param [When::TM::TemporalPosition] t
    #
    # @return [Numeric, When::TM::TemporalPosotion] 月の最大高度の日時(ユリウス日(Terrestrial Time)またはWhen::TM::DateAndTime
    #             該当時刻がなければ nil
    #
    def moon_noon(t)
      day_event_in_the_day(t, nil, When.Resource('_ep:Moon'))
    end

    # 月の南中の日時
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    # @param [When::TM::TemporalPosition] t
    #
    # @return [Numeric, When::TM::TemporalPosotion] 月の南中の日時(ユリウス日(Terrestrial Time)またはWhen::TM::DateAndTime
    #             該当時刻がなければ nil
    #
    def meridian_passage_of_moon(t)
      day_event_in_the_day(t, 0, When.Resource('_ep:Moon'))
    end

    # 日食の情報
    #
    # @param [When::TM::TemporalPosition] date
    # @param [Range<When::TM::TemporalPosition>] date
    # @param [Block] block
    #
    # @return [Array<String, Numeric, Array<Array<Numeric or When::TM::TemporalPosition, String>>>] 食の情報(のArray(dateがRangeの場合))
    #   @see When::Coordinates::Spatial#eclipse_info
    #
    def solar_eclipse(date, &block)
      location.solar_eclipse(date, &block)
    end

    # 月食の情報
    #
    # @param [When::TM::TemporalPosition] date
    # @param [Range<When::TM::TemporalPosition>] date
    #   @note Rangeの場合夜半より翌日に向けmargin経過時点より前は前日扱い
    # @param [When::TM::Duration] margin 
    # @param [Block] block
    #
    # @return [Array<String, Numeric, Array<Array<Numeric or When::TM::TemporalPosition, String>>>] 食の情報(のArray(dateがRangeの場合))
    #   @see When::Coordinates::Spatial#eclipse_info
    #
    def lunar_eclipse(date, margin=When::PT6H, &block)
      location.lunar_eclipse(date, margin, &block)
    end

    # 恒星の出没と太陽の位置関係に関するイベントの日時
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    # @param [When::TM::TemporalPosition] t
    # @param [Integer] event
    #   [ 0 - first visible rising (=ヘリアカル・ライジング) ]
    #   [ 1 - last  visible rising  ]
    #   [ 2 - last  visible setting ]
    #   [ 3 - first visible setting ]
    # @param [When::Ephemeris::CelestialObject] target 対象の恒星
    # @param [Numeric] hs 恒星の高度/度(地平線上が正)
    # @param [Numeric] bs 太陽の伏角/度(地平線上が負, よって通常は正です, デフォルトは Bs表引き)
    #
    # @return [Numeric, When::TM::TemporalPosotion] イベントの日時(ユリウス日(Terrestrial Time)またはWhen::TM::DateAndTime
    #
    def year_event(t, event, target, hs= @location.datum.zeros['A'], bs=nil)
      # difference of ecliptic longitude between zenith and target star 
      # when the event happens
      pos  = _coords(+t, When::Coordinates::Spatial::EQUATORIAL, target)
      long = @location.long / @location.degree
      lat  = @location.lat  / @location.degree
      dp   = (sind(hs) - sind(lat) * sinc(pos.theta)) / 
                        (cosd(lat) * cosc(pos.theta))

      return nil if dp.abs >= 1
      dp  = acos(dp) / CIRCLE

      # The Sun's height when the event happens
      unless bs
        mag = target.luminosity
        bs  = Bs[mag<-0.5 ?  0 : (mag<4.5 ? mag.round+1 : 6)][event]
      end

      # イベントの時刻
      zenith = Coords.polar(pos.phi+Sgn[event][0]*dp, lat/360.0).r_to_y(+t, @location)
      s   = sind(bs)/cosc(zenith.theta)
      arc = asin(s) / CIRCLE + 0.25
      lam = _true_sun(+t).floor+(zenith.phi+Sgn[event][1]*arc).divmod(1)[1]
      tt  = nil
      loop do
        tt = root(+t, lam) {|t1| _true_sun(t1)}
        break if tt >= +t
        lam += 1
      end
      _to_seed_type(day_event((tt+long/360.0).round, Sgn[event][0], When.Resource('_ep:Sun'), bs), t)
    rescue RangeError
      nil
    end

    # ユリウス日(Numeric)を seed と同じ型に変換して返します。
    #
    # @param [Numeric] d ユリウス日(Terrestrial Time)
    # @param [Numeric] seed
    # @param [Hash] seed
    # @param [When::TM::TemporalPosition] seed
    #
    # @return [Numeric, When::TM::TemporalPosotion]
    #
    def _to_seed_type(d, seed)
      case seed
      when Numeric         ; return d
      when When::TimeValue ; seed = seed._attr
      else                 ; seed = seed.dup
      end
      seed[:precision] = nil
      seed[:clock]   ||= When::TM::Clock.local_time
      t = When::TM::JulianDate._d_to_t(d)
      seed[:frame].jul_trans(@is_dynamical ? When::TM::JulianDate.dynamical_time(t, {:time_standard=>seed[:time_standard]}) :
                                             When::TM::JulianDate.universal_time(t), seed)
    end

    private

    # オブジェクトの正規化
    #
    #   @formula         = 計算対象/公式の指定
    #   @location        = 観測地
    #   @time_standard   = 時刻系('universal' or 'dynamical')
    #   @is_dynamical    = true: dynamical, false: universal
    #   @proc            = 計算手続き
    #   @cycle_number_0m =  t = CYCLE_0M日 での計算対象周期番号
    #   @cycle_number_1m =  t = CYCLE_1M日 までの計算対象周期番号の比例定数
    #   @lunation_0m     =  t = CYCLE_0M日 での朔望月番号
    #   @lunation_1m     =  t = CYCLE_1M日 までの朔望月番号の比例定数
    #   @sun_0m          =  t = CYCLE_0M日 での太陽年番号
    #   @sun_1m          =  t = CYCLE_1M日 までの太陽年番号の比例定数
    def _normalize(args=[], options={})
      @location         = When.Resource(@location, '_l:') if @location.kind_of?(String)
      @long, @lat, @alt = [@location.long / @location.degree,
                           @location.lat  / @location.degree,
                           @location.alt] if @location
      @formula        ||= '1L'
      @time_standard  ||= 'dynamical'
      @is_dynamical     = (@time_standard[0..0].downcase == 'd')

      _normalize_grahas

      @proc           ||=
        case @formula
        when Hash
          @formula['Rem'] = (-@formula['Epoch']) % @formula['Period']
          @is_dynamical ? proc {|t| (+t     + @formula['Rem']) / @formula['Period'] } :
                          proc {|t| (t.to_f + @formula['Rem']) / @formula['Period'] }
        when /\A(\d+)L->(\d+)S\z/
          m, s = $1.to_i, $2.to_i
          @lunation_0m =  _true_lunation_(CYCLE_0M)
          @lunation_1m = (_true_lunation_(CYCLE_1M) - @lunation_0m) / CYCLE_1M
          @is_dynamical ? proc {|t| s * p_lunation_to_sun(+t     / m) } :
                          proc {|t| s * p_lunation_to_sun(t.to_f / m) }
        when /\A(\d+)S->(\d+)L\z/
          s, m = $1.to_i, $2.to_i
          @sun_0m =  _true_sun_(CYCLE_0M)
          @sun_1m = (_true_sun_(CYCLE_1M) - @sun_0m) / CYCLE_1M
          @is_dynamical ? proc {|t| m * p_sun_to_lunation(+t     / s) } :
                          proc {|t| m * p_sun_to_lunation(t.to_f / s) }
        when /\A(\d+)M\+(\d+)S\z/
          s, m = $2.to_i, $1.to_i
          @is_dynamical ? proc{|t| s * p_true_sun(+t)     + m * p_true_moon(+t)    } :
                          proc{|t| s * p_true_sun(t.to_f) + m * p_true_moon(t.to_f)}
        when /\A(\d+)m\+(\d+)s\z/
          s, m = $2.to_i, $1.to_i
          @is_dynamical ? proc{|t| s * p_mean_sun(+t)     + m * p_mean_moon(+t)    } :
                          proc{|t| s * p_mean_sun(t.to_f) + m * p_mean_moon(t.to_f)}
        when /\A(\d+)S\z/ ; s=$1.to_i; @is_dynamical ? proc{|t| s * p_true_sun(+t)     } : proc{|t| s * p_true_sun(t.to_f)     }
        when /\A(\d+)s\z/ ; s=$1.to_i; @is_dynamical ? proc{|t| s * p_mean_sun(+t)     } : proc{|t| s * p_mean_sun(t.to_f)     }
        when /\A(\d+)M\z/ ; m=$1.to_i; @is_dynamical ? proc{|t| m * p_true_moon(+t)    } : proc{|t| m * p_true_moon(t.to_f)    }
        when /\A(\d+)m\z/ ; m=$1.to_i; @is_dynamical ? proc{|t| m * p_mean_moon(+t)    } : proc{|t| m * p_mean_moon(t.to_f)    }
        when /\A(\d+)L\z/ ; m=$1.to_i; @is_dynamical ? proc{|t| m * p_true_lunation(+t)} : proc{|t| m * p_true_lunation(t.to_f)}
        when /\A(\d+)l\z/ ; m=$1.to_i; @is_dynamical ? proc{|t| m * p_mean_lunation(+t)} : proc{|t| m * p_mean_lunation(t.to_f)}
        when /\A[YRH]\.(\w+)-(\w+)\z/i
          system  = 'YRH'.index($1.upcase)
          method  = $2.downcase
          target  = When.Resource($3.capitalize, '_ep:')
          @is_dynamical ? proc{|t| _coords(+t,     system, target)[method]} :
                          proc{|t| _coords(t.to_f, system, target)[method]}
        else ; raise ArgumentError, "Wrong formula format: #{@formula}"
        end

      @cycle_number_0m =  time_to_cn(CYCLE_0M)
      @cycle_number_1m = (time_to_cn(CYCLE_1M) - @cycle_number_0m) / CYCLE_1M
    end

    # 天体の設定
    def _normalize_grahas
      @graha = {:Sun => Datum::Sun, :Moon => Datum::Moon}
      return unless @formula == '2L'
      base   = @location || When.Resource('_ep:Earth')
      @graha.update({
        :Mercury => Hindu::ModernGraha.new(When.Resource('_ep:Mercury'), base),
        :Venus   => Hindu::ModernGraha.new(When.Resource('_ep:Venus'  ), base),
        :Mars    => Hindu::ModernGraha.new(When.Resource('_ep:Mars'   ), base),
        :Jupiter => Hindu::ModernGraha.new(When.Resource('_ep:Jupiter'), base),
        :Saturn  => Hindu::ModernGraha.new(When.Resource('_ep:Saturn' ), base)
      })
    end

    # 日付の一致する event を探す
    #
    #   見つからなければ nil
    #
    def day_event_in_the_day(t, event, target=When.Resource('_ep:Sun'), height=nil)
      today = t.to_i
      3.times do
        r = day_event(t, event, target, height)
        return r if t.kind_of?(Numeric) || today == r.to_i
        duration ||= When.Duration('P1D')
        if today > r.to_i
          t += duration
        else
          t -= duration
        end
      end
      nil
    end

    #
    # method cashing
    #
    def p_true_sun(t)          ; _true_sun(t)         end
    def p_mean_sun(t)          ; _mean_sun(t)         end
    def p_true_moon(t)         ; _true_moon(t)        end
    def p_mean_moon(t)         ; _mean_moon(t)        end
    def p_true_lunation(t)     ; _true_lunation(t)    end
    def p_mean_lunation(t)     ; _mean_lunation(t)    end
    def p_lunation_to_sun(cn)  ; _lunation_to_sun(cn) end
    def p_sun_to_lunation(cn)  ; _sun_to_lunation(cn) end

    # 太陽の視黄経を返します。
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    #
    # @return [Numeric]
    #
    def _true_sun_(t)
      @graha[:Sun].true_longitude(t)
    end

    # 月の視黄経を返します。
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    #
    # @return [Numeric]
    #
    def _true_moon_(t)
      @graha[:Moon].true_longitude(t)
    end

    # 月の位相(太陽と月の視黄経差)を返します。
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    #
    # @return [Numeric]
    #
    def _true_lunation_(t)
      _true_moon_(t) - _true_sun_(t)
    end

    # 太陽の平均黄経を返します。
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    #
    # @return [Numeric]
    #
    def _mean_sun_(t)
      @graha[:Sun].mean_longitude(t)
    end

    # 月の平均黄経を返します。
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    #
    # @return [Numeric]
    #
    def _mean_moon_(t)
      @graha[:Moon].mean_longitude(t)
    end

    # 月の位相(太陽と月の平均黄経差)を返します。
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    #
    # @return [Numeric]
    #
    def _mean_lunation_(t)
      _mean_moon_(t) - _mean_sun_(t)
    end

    # 朔望月番号を太陽年番号に変換して返します。
    #
    # @param [Numeric] cn 朔望月番号
    #
    # @return [Numeric]
    #
    def _lunation_to_sun_(cn)
      _true_sun(root((cn - @lunation_0m) / @lunation_1m, cn) {|x| _true_lunation(x)})
    end

    # 太陽年番号を朔望月番号に変換して返します。
    #
    # @param [Numeric] cn 太陽年番号
    #
    # @return [Numeric]
    #
    def _sun_to_lunation_(cn)
      _true_lunation(root((cn - @sun_0m) / @sun_1m, cn) {|x| _true_sun(x)})
    end
  end

  #
  #  一部表引き
  #
  class FormulaWithTable < Formula

    private

    # 周期番号 -> 日時
    #
    # @param [Numeric] cn 周期番号
    # @param [Numeric] time0 日時の初期近似値
    #
    # @return [Numeric] ユリウス日
    #
    def cn_to_time_(cn, time0=nil)
      count = ((cn - self.class::CycleBase) * self.class::CycleUnit / 360.0).floor
      return super unless count >= 0
      degree = (cn * self.class::CycleUnit) % 360
      degree = degree.round if (degree - degree.round).abs < 1.5E-8
      if degree == 360
        degree = 0
        count += 1
      end
      epoch = self.class::Epoch[degree]
      return super unless epoch
      delta = self.class::Delta[degree][count]
      return super unless delta
      epoch + count * self.class::CyclePeriod + delta * 1E-9
    end

    # オブジェクトの正規化
    def _normalize(args=[], options={})
      @formula = self.class::FormulaType
      super
    end
  end

  #
  # Luni-Solar Calendar Formula for Mean Lunation Type
  #
  class MeanLunation < Formula

    #
    # Lunar Calendar Formula
    #
    module LunarMethod

      private

      # 周期番号 -> 日時
      #
      # @param [Numeric] cn 周期番号
      # @param [Numeric] time0 日時の初期近似値
      #
      # @return [Numeric] ユリウス日
      #
      # @note 半ティティの日時の丸め誤差に配慮
      #
      def cn_to_time_(cn, time0=nil)
        time0 ||= (cn - @cycle_number_0m) / @cycle_number_1m
        return time0 if (cn * 60 - (cn * 60).round).abs > @cycle_precision
        ((time0 + 1.0/256 - @day_epoch) / @half_tithi).floor  * @half_tithi  + @day_epoch
      end
    end

    #
    # Solar Calendar Formula for Fixed Year Length Method
    #
    module SolarMethod

      private

      # 周期番号 -> 日時
      #
      # @param [Numeric] cn 周期番号
      # @param [Numeric] time0 日時の初期近似値
      #
      # @return [Numeric] ユリウス日
      #
      # @note 太陽黄経が整数になる日時の丸め誤差に配慮
      #
      def cn_to_time_(cn, time0=nil)
        time0 ||= (cn - @cycle_number_0m) / @cycle_number_1m
        return time0 if (cn * 360 - (cn * 360).round).abs > @cycle_precision
        ((time0 + 1.0/256 - @day_epoch) / @solar_degree).floor * @solar_degree + @day_epoch
      end
    end

    # 計算の基準経度 / 度
    # @return [Numeric]
    attr_reader :long

    # 計算の元期(年)
    # @return [Numeric]
    attr_reader :year_epoch

    # 計算の元期(月)
    # @return [Numeric]
    attr_reader :month_epoch

    # 計算の元期(日)
    # @return [Numeric]
    attr_reader :day_epoch

    # 回帰年
    # @return [Numeric]
    attr_reader :year_length

    # 恒星月
    # @return [Numeric]
    attr_reader :month_length

    # 朔望月
    # @return [Numeric]
    attr_reader :lunation_length

    # 統法
    # @return [Numeric]
    attr_reader :denominator

    # 太陽の平均黄経を返します。
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    #
    # @return [Numeric]
    #
    def _mean_sun_(t)  (t - @day_epoch) / @year_length + @year_epoch end

    # 月の平均黄経を返します。
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    #
    # @return [Numeric]
    #
    def _mean_moon_(t) (t - @day_epoch) / @month_length + @month_epoch end

    # 日の出の日時
    #
    # @param [Numeric] sdn ユリウス日(Terrestrial Time)
    # @param [Numeric] height 観測地の高度(本クラスでは使用しない)
    #
    # @return [Numeric] 日の出の日時のユリウス日
    #
    def sunrise(sdn, height=nil)
      return sdn.to_i - @long / 360.0 - 0.25
    end

    # 太陽の視黄経を返します。
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    #
    # @return [Numeric]
    #
    alias :_true_sun_ :_mean_sun_

    # 月の視黄経を返します。
    #
    # @param [Numeric] t ユリウス日(Terrestrial Time)
    #
    # @return [Numeric]
    #
    alias :_true_moon_ :_mean_moon_

    private

    # オブジェクトの正規化
    def _normalize(args=[], options={})
      Rational
      @time_standard   ||= 'universal'
      @epoch_shift     ||= 1721139        # 西暦 0 年  春分
      @day_shift       ||= Rational(-1,2) # 夜半 -1/2, 日出 -1/4
      @day_shift         = @day_shift.to_r
      @longitude_shift ||= Rational(-1,4) # 冬至 -1/4, 立春 -1/8
      @longitude_shift   = @longitude_shift.to_r
      @day_epoch         = (@day_epoch.to_f == @day_epoch.to_i ? @day_epoch.to_i : @day_epoch.to_f) + @day_shift
      @year_length       = @year_length.to_r
      @year_delta        = @year_delta.to_f * 1.0E-6 if @year_delta
      if @year_epoch
        @year_epoch      = @year_epoch.to_f
      else
        @year_epoch      = 0
        @year_epoch      = @longitude_shift - _mean_sun_(@epoch_shift).to_i
      end
      @cycle_precision ||= 1.0E-8
      @cycle_precision   = @cycle_precision.to_f

      if @lunation_length && /S/i !~ @formula
        # 月の位相の計算
        @lunation_length = @lunation_length.to_r
        @month_length    = 1 / (1.to_r/@year_length + 1.to_r/@lunation_length)
        @half_tithi      = @lunation_length / 60
        if @month_epoch
          @month_epoch   = @month_epoch.to_f
        else
          @month_epoch   = 0
          @month_epoch   = @longitude_shift - _mean_moon_(@epoch_shift).to_i
        end
        extend LunarMethod
      else
        # 太陽黄経の計算
        @solar_degree    = @year_length / 360
        extend SolarMethod
      end

      # 通法
      @denominator   = @denominator.to_i if @denominator
      @denominator ||= [@year_length, @lunation_length].map {|length| length.kind_of?(Rational) ? length.denominator : 0}.max
      super
    end
  end
end
