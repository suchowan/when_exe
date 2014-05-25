# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  module Ephemeris

    #------------------------------------------
    #   太陽・地球 位置計算用データ
    #------------------------------------------

    # 太陽の地心黄経
    # @private
    P3L    =
      [[LIN   ,  279.0357964 ,     360.007693787, 3.02500E-8],
       [SIN   ,  353.06      ,     719.981008 ,   0.02009 ,-2.98832E-8],
       [SIN   ,  248.64      ,     -19.34136  ,  -0.0048  ],
       [SIN   ,  285.0       ,     329.6446699,   0.0020  ,+8.0E-9    ],
       [SIN   ,  334.2       ,   -4452.671109 ,   0.0018  ,-0.1634E-6 ],

       [SIN   ,  293.7       ,      -0.2020   ,   0.00178 ],
       [SIN   ,  242.4       ,     450.3688   ,   0.0015  ,+1.4E-9    ],
       [SIN   ,  211.1       ,     225.1844   ,   0.0013  ,+0.7E-9    ],
       [SIN   ,  208.0       ,     659.2893   ,   0.0008  ,+1.6E-8    ],
       [SIN   ,   53.5       ,      90.3783   ,   0.0007  ],

       [SIN   ,   12.1       ,     -30.35     ,   0.0007  ],
       [SIN   ,  239.1       ,     337.18     ,   0.0006  ],
       [SIN   ,   10.1       ,      -1.50     ,   0.0005  ],
       [SIN   ,   99.1       ,     -22.81     ,   0.0005  ],
       [SIN   ,  264.8       ,     315.56     ,   0.0004  ],

       [SIN   ,  233.8       ,     299.30     ,   0.0004  ],
       [SIN   ,  198.1       ,     720.02     ,  -0.0004  ],
       [SIN   ,  349.6       ,    1079.97     ,   0.0003  ],
       [SIN   ,  241.2       ,     -44.43     ,   0.0003  ]]
    #  [SIN   ,   65.0       ,     -44.43     ,   0.0003  ]], 旧版
    # 太陽の動径の対数
    # @private
    P3Q    =
      [[COS   ,  356.53      ,     359.990504 ,  -0.007261 ,-1.49416E-8],
       [COST  ,  356.53      ,     359.990504 ,   0.0000002,-1.49416E-8],
       [COS   ,  353.1       ,     719.981008 ,  -0.000091 ,-2.98832E-8],
       [COS   ,  205.8       ,    4452.671109 ,   0.000013 ,-0.1634E-6 ],
       [COS   ,   62.0       ,     450.4      ,   0.000007 ,+1.4E-9    ],
       [COS   ,  105.0       ,     329.6      ,   0.000007 ,+8.0E-9    ]]

    #
    # The Sun
    #
    class Sun < Datum

      # @private
      Radius = 696000.0

      class << self

        include Ephemeris

        S0=[356.531, 359.990504, -1.49416E-8] # 太陽の中心差の位相
        S1=[  1.9159, -4.8E-5  , -1.44444E-9] # 太陽の中心差の振幅

        # 視黄経 / CIRCLE
        #
        # @param [Numeric] t ユリウス日(Terrestrial Time)
        # @param [When::TM::TemporalPosition] t
        #
        # @return [Numeric]
        #
        def true_longitude(t)
          y = julian_year_from_1975(+t)
          return (sind(S0[0]+y*(S0[1]+y*S0[2]))*(S1[0]+y*(S1[1]+y*S1[2])) +
                  trigonometric(y, P3L)) / 360.0 + 1974.0
        end

        # 距離 / AU
        #
        # @param [Numeric] t ユリウス日(Terrestrial Time)
        # @param [When::TM::TemporalPosition] t
        #
        # @return [Numeric]
        #
        def pi(t)
          return 10.0**(0.000030+trigonometric(julian_year_from_1975(+t), P3Q))
        end

        # 平均黄経 / CIRCLE
        #
        # @param [Numeric] t ユリウス日(Terrestrial Time)
        # @param [When::TM::TemporalPosition] t
        #
        # @return [Numeric]
        #
        def mean_longitude(t)
          return trigonometric(julian_year_from_1975(+t), P3L, 0.0, 1) / 360.0 + 1974.0
        end
      end

      # 位置 (黄道座標)
      #
      # @param [Numeric] t ユリウス日(Terrestrial Time)
      # @param [When::TM::TemporalPosition] t
      #
      # @return [When::Ephemeris::Coords]
      #
      def _coords(t)
        Coords.polar(0, 0, 0, 0)
      end

      # 視黄経 / CIRCLE
      #
      # @param [Numeric] t ユリウス日(Terrestrial Time)
      # @param [When::TM::TemporalPosition] t
      #
      # @return [0]
      #
      def true_longitude(t)
        0
      end

      # 平均黄経 / CIRCLE
      #
      # @param [Numeric] t ユリウス日(Terrestrial Time)
      # @param [When::TM::TemporalPosition] t
      #
      # @return [0]
      #
      def mean_longitude(t)
        0
      end

      # 平均運動 / (DEG/YEAR)
      #
      # @param [Numeric] t ユリウス日(Terrestrial Time)
      # @param [When::TM::TemporalPosition] t
      #
      # @return [0]
      #
      def mean_motion
        0
      end

      # オブジェクトの生成
      # @private
      def initialize(*args)
        options = [args.pop] if args[-1].kind_of?(Hash)
        surface_radius, aberration, luminosity, *rest = args
        surface_radius ||= Radius
        aberration     ||= 0.00000
        luminosity     ||= 4.58
        args  = [surface_radius, aberration, luminosity] + rest
        args += options if options
        super(*args)
      end
    end

    #
    # The Earth
    #
    class Earth < Datum

      # 地球の位置 (黄道座標)
      #
      # @param [Numeric] t ユリウス日(Terrestrial Time)
      # @param [When::TM::TemporalPosition] t
      #
      # @return [When::Ephemeris::Coords]
      #
      def _coords(t)
        t  = +t
        radius = Sun.pi(t)
        dl = 0.5 + @aberration / radius / 360 # 略算式に含まれる光行差をキャンセルする
        Coords.polar(Sun.true_longitude(t)+dl, 0, radius, Sun.mean_longitude(t)+dl)
      end

      # 地球の平均運動 / (DEG/YEAR)
      #
      # @return [Numeric]
      #
      def mean_motion
        P3L[0][2]
      end

      # オブジェクトの生成
      # @private
      def initialize(*args)
        options = {
          'shape' => [0.998327112, +0.001676399, -0.000003519, -11.514/60.0],
          'sid'   => [6.697375, 2400.0513369, 0.0000259],
          'zeros' => {'Z'=>0, 'A'=>-0.58555, '0'=>-0.85255, 'T'=>-7.36111},
          'air'   => [10.0, 0.40, 20.0]
        }
        options.update(args.pop) if args[-1].kind_of?(Hash)
        surface_radius, aberration, luminosity, *rest = args
        surface_radius ||= 6378.14
        aberration     ||=    0.0056932
        luminosity     ||=   -3.50
        args = [surface_radius, aberration, luminosity] + rest + [options]
        super(*args)
      end
    end

    #
    # Typical Geometrical Datum
    #
    # provisionally same as When::Ephemeris::Earth
    #
    class JGD2000 < Earth # TODO
    end
  end
end
