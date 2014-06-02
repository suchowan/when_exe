# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

require 'when_exe/ephemeris/sun'
module When
  module Ephemeris

    #------------------------------------------
    #     月と地球の本影 計算用データ
    #------------------------------------------

    # 月の地心黄経
    # @private
    P0dL =
      [[SIN   ,   93.8       ,      -1.33     ,  0.0040   ],
       [SIN   ,  248.6       ,     -19.34     ,  0.0020   ],
       [SIN   ,   66.0       ,       0.2      ,  0.0006   ],
       [SIN   ,  249.0       ,     -19.3      ,  0.0006   ]]
    # @private
    P0L =
      [[LIN   ,  124.8757417 ,  4812.6788201  , -1.330000E-7],
       [SINL  ,  338.9158263 ,  4771.9886313  ,  6.2887   ,+8.99400E-7], # 中心差 
       [SIN   ,  107.236832  ,   -4133.3536154,  1.2740   ,+1.22612E-6], # 出差
       [SIN   ,   51.678963  ,    8905.3422467,  0.6583   ,-0.32672E-6], # 二均差
       [SIN   ,  317.831653  ,    9543.9772627,  0.2136   ,+1.7988E-6 ], # 中心差 x 2
       [SIN   ,  176.528826  ,     359.990504 ,  0.1856   ,-1.561E-8  ], # 年差

       [SIN   ,  292.463     ,    9664.0403505,  0.1143   ,-0.6812E-6 ],
       [SIN   ,   86.16      ,     638.63475182, 0.0588   ,+2.1256E-6 ],
       [SIN   ,  103.78      ,   -3773.36305278, 0.0572   ,-1.22769E-6],
       [SIN   ,   30.58      ,   13677.331    ,  0.0533   ],
       [SIN   ,  124.86      ,   -8545.352    ,  0.0459   ],

       [SIN   ,  342.38      ,    4411.998    ,  0.0410   ],
       [SIN   ,   25.83      ,    4452.671    ,  0.0348   ], # 月角差( 二均差 / 2)
       [SIN   ,  155.45      ,    5131.979    ,  0.0305   ],
       [SIN   ,  240.79      ,     758.698    ,  0.0153   ],
       [SIN   ,  271.38      ,   14436.029    ,  0.0125   ],

       [SIN   ,  226.45      ,   -4892.052    ,  0.0110   ],
       [SIN   ,   55.58      ,  -13038.696    ,  0.0107   ],
       [SIN   ,  296.75      ,   14315.966    ,  0.0100   ],
       [SIN   ,   34.5       ,   -8266.71     ,  0.0085   ],
       [SIN   ,  290.7       ,   -4493.34     ,  0.0079   ],

       [SIN   ,  228.2       ,    9265.33     ,  0.0068   ],
       [SIN   ,  133.1       ,     319.32     ,  0.0052   ],
       [SIN   ,  202.4       ,    4812.66     ,  0.0050   ],
       [SIN   ,   68.6       ,     -19.34     ,  0.0048   ],
       [SIN   ,   34.1       ,   13317.34     ,  0.0040   ],

       [SIN   ,    9.5       ,   18449.32     ,  0.0040   ],
       [SIN   ,   93.8       ,      -1.33     ,  0.0040   ],
       [SIN   ,  103.3       ,   17810.68     ,  0.0039   ],
       [SIN   ,   65.1       ,    5410.62     ,  0.0037   ],
       [SIN   ,  321.3       ,    9183.99     ,  0.0027   ],

       [SIN   ,  174.8       ,  -13797.39     ,  0.0026   ],
       [SIN   ,   82.7       ,     998.63     ,  0.0024   ],
       [SIN   ,    4.7       ,    9224.66     ,  0.0024   ],
       [SIN   ,  121.4       ,   -8185.36     ,  0.0022   ],
       [SIN   ,  134.4       ,    9903.97     ,  0.0021   ],

       [SIN   ,  173.1       ,     719.98     ,  0.0021   ],
       [SIN   ,  100.3       ,   -3413.37     ,  0.0021   ],
       [SIN   ,  248.6       ,     -19.34     ,  0.0020   ],
       [SIN   ,   98.1       ,    4013.29     ,  0.0018   ],
       [SIN   ,  344.1       ,   18569.38     ,  0.0016   ],

       [SIN   ,   52.1       ,  -12678.71     ,  0.0012   ],
       [SIN   ,  250.3       ,   19208.02     ,  0.0011   ],
       [SIN   ,   81.0       ,   -8586.0      ,  0.0009   ],
       [SIN   ,  207.0       ,   14037.3      ,  0.0008   ],
       [SIN   ,   31.0       ,   -7906.7      ,  0.0008   ],

       [SIN   ,  346.0       ,    4052.0      ,  0.0007   ],
       [SIN   ,  294.0       ,   -4853.3      ,  0.0007   ],
       [SIN   ,   90.0       ,     278.6      ,  0.0007   ],
       [SIN   ,  237.0       ,    1118.7      ,  0.0006   ],
       [SIN   ,   82.0       ,   22582.7      ,  0.0005   ],

       [SIN   ,  276.0       ,   19088.0      ,  0.0005   ],
       [SIN   ,   73.0       ,  -17450.7      ,  0.0005   ],
       [SIN   ,  112.0       ,    5091.3      ,  0.0005   ],
       [SIN   ,  116.0       ,    -398.7      ,  0.0004   ],
       [SIN   ,   25.0       ,    -120.1      ,  0.0004   ],

       [SIN   ,  181.0       ,    9584.7      ,  0.0004   ],
       [SIN   ,   18.0       ,     720.0      ,  0.0004   ],
       [SIN   ,   60.0       ,   -3814.0      ,  0.0003   ],
       [SIN   ,   13.0       ,   -3494.7      ,  0.0003   ],
       [SIN   ,   13.0       ,   18089.3      ,  0.0003   ],

       [SIN   ,  152.0       ,    5492.0      ,  0.0003   ],
       [SIN   ,  317.0       ,     -40.7      ,  0.0003   ],
       [SIN   ,  348.0       ,   23221.3      ,  0.0003   ]]
    # 月の地心黄緯
    # @private
    P0dB =
      [[SIN   ,   68.64      ,     -19.341    ,  0.0267   ],
       [SIN   ,  342.0       ,     -19.36     ,  0.0043   ],
       [SIN   ,   93.8       ,      -1.33     ,  0.0040   ],
       [SIN   ,  248.6       ,     -19.34     ,  0.0020   ],
       [SIN   ,  358.0       ,     -19.4      ,  0.0005   ]]
    # @private
    P0B =
      [[SINL  ,  236.231     ,    4832.0201248,  5.1281218,-0.3406E-6 ],
       [SIN   ,  215.147     ,    9604.0088   ,  0.2806   ],
       [SIN   ,   77.316     ,      60.0316   ,  0.2777   ],
       [SIN   ,    4.563     ,   -4073.3220   ,  0.1732   ],
       [SIN   ,  308.98      ,    8965.374    ,  0.0554   ],

       [SIN   ,  343.48      ,     698.667    ,  0.0463   ],
       [SIN   ,  287.90      ,   13737.362    ,  0.0326   ],
       [SIN   ,  194.06      ,   14375.997    ,  0.0172   ],
       [SIN   ,   25.6       ,   -8845.31     ,  0.0093   ],
       [SIN   ,   98.4       ,   -4711.96     ,  0.0088   ],

       [SIN   ,    1.1       ,   -3713.33     ,  0.0082   ],
       [SIN   ,  322.4       ,    5470.66     ,  0.0043   ],
       [SIN   ,  266.8       ,   18509.35     ,  0.0042   ],
       [SIN   ,  188.0       ,   -4433.31     ,  0.0034   ],
       [SIN   ,  312.5       ,    8605.38     ,  0.0025   ],

       [SIN   ,  291.4       ,   13377.37     ,  0.0022   ],
       [SIN   ,  340.0       ,    1058.66     ,  0.0021   ],
       [SIN   ,  218.6       ,    9244.02     ,  0.0019   ],
       [SIN   ,  291.8       ,   -8206.68     ,  0.0018   ],
       [SIN   ,   52.8       ,    5192.01     ,  0.0018   ],

       [SIN   ,  168.7       ,   14496.06     ,  0.0017   ],
       [SIN   ,   73.8       ,     420.02     ,  0.0016   ],
       [SIN   ,  262.1       ,    9284.69     ,  0.0015   ],
       [SIN   ,   31.7       ,    9964.00     ,  0.0015   ],
       [SIN   ,  260.8       ,    -299.96     ,  0.0014   ],

       [SIN   ,  239.7       ,    4472.03     ,  0.0013   ],
       [SIN   ,   30.4       ,     379.35     ,  0.0013   ],
       [SIN   ,  304.9       ,    4812.68     ,  0.0012   ],
       [SIN   ,   12.4       ,   -4851.36     ,  0.0012   ],
       [SIN   ,  173.0       ,   19147.99     ,  0.0011   ],

       [SIN   ,  312.9       ,  -12978.66     ,  0.0010   ],
       [SIN   ,    1.0       ,   17870.7      ,  0.0008   ],
       [SIN   ,  190.0       ,    9724.1      ,  0.0008   ],
       [SIN   ,   22.0       ,   13098.7      ,  0.0007   ],
       [SIN   ,  117.0       ,    5590.7      ,  0.0006   ],

       [SIN   ,   47.0       ,  -13617.3      ,  0.0006   ],
       [SIN   ,   22.0       ,   -8485.3      ,  0.0005   ],
       [SIN   ,  150.0       ,    4193.4      ,  0.0005   ],
       [SIN   ,  119.0       ,   -9483.9      ,  0.0004   ],
       [SIN   ,  246.0       ,   23281.3      ,  0.0004   ],

       [SIN   ,  301.0       ,   10242.6      ,  0.0004   ],
       [SIN   ,  126.0       ,    9325.4      ,  0.0004   ],
       [SIN   ,  104.0       ,   14097.4      ,  0.0004   ],
       [SIN   ,  340.0       ,   22642.7      ,  0.0003   ],
       [SIN   ,  270.0       ,   18149.4      ,  0.0003   ],

       [SIN   ,  358.0       ,   -3353.3      ,  0.0003   ],
       [SIN   ,  148.0       ,   19268.0      ,  0.0003   ]]
    # 月の視差
    # @private
    P0P =
      [[COS   ,  338.92      ,    4771.98849108, 0.0518   ,+9.19178E-7],
       [COS   ,  287.2       ,   -4133.35355678, 0.0095   ,+1.2262E-6 ],
       [COS   ,   51.7       ,    8905.34223034, 0.0078   ,-0.3268E-6 ],
       [COS   ,  317.8       ,    9543.97698216, 0.0028   ,+1.7988E-6 ],
       [COS   ,   31.0       ,   13677.3      ,  0.0009   ],

       [COS   ,  305.0       ,   -8545.4      ,  0.0005   ],
       [COS   ,  284.0       ,   -3773.4      ,  0.0004   ],
       [COS   ,  342.0       ,    4412.0      ,  0.0003   ]]

    #
    # The Moon
    #
    class Moon < Datum

      class << self

        include Ephemeris

        # 月の真黄経 / CIRCLE
        #
        # @param [Numeric] t ユリウス日(Terrestrial Time)
        # @param [When::TM::TemporalPosition] t
        #
        # @return [Numeric]
        #
        def true_longitude(t)
          y = julian_year_from_1975(+t)
          return trigonometric(y, P0L, sind(trigonometric(y, P0dL))) / 360.0 + 38770.0
        end

        # 月の真黄緯/ CIRCLE
        #
        # @param [Numeric] t ユリウス日(Terrestrial Time)
        # @param [When::TM::TemporalPosition] t
        #
        # @return [Numeric]
        #
        def latitude(t)
          y = julian_year_from_1975(+t)
          return trigonometric(y, P0B, trigonometric(y, P0dB)) / 360.0
        end

        # 月の距離 / km
        #
        # @param [Numeric] t ユリウス日(Terrestrial Time)
        # @param [When::TM::TemporalPosition] t
        #
        # @return [Numeric]
        #
        def pi(t)
          return 6378.14 / ((trigonometric(julian_year_from_1975(+t), P0P) + 0.9507)*DEG)
        end

        # 月の平均黄経 / CIRCLE
        #
        # @param [Numeric] t ユリウス日(Terrestrial Time)
        # @param [When::TM::TemporalPosition] t
        #
        # @return [Numeric]
        #
        def mean_longitude(t)
          return trigonometric(julian_year_from_1975(+t), P0L, 0.0, 1) / 360.0 + 38770.0
        end
      end

      # 月の位置 (黄道座標)
      #
      # @param [Numeric] t ユリウス日(Terrestrial Time)
      # @param [When::TM::TemporalPosition] t
      #
      # @return [When::Ephemeris::Coords]
      #
      def _coords(t)
        t  = +t
        Coords.polar(Moon.true_longitude(t),
                     Moon.latitude(t),
                     Moon.pi(t)/AU,
                     Moon.mean_longitude(t)) +
        When.Resource('_ep:Earth')._coords(t)
      end

      # 真黄経 / CIRCLE
      #
      # @param [Numeric] t ユリウス日(Terrestrial Time)
      # @param [When::TM::TemporalPosition] t
      #
      # @return [Numeric]
      #
      def true_longitude(t)
        Moon.true_longitude(t)
      end

      # 平均黄経 / CIRCLE
      #
      # @param [Numeric] t ユリウス日(Terrestrial Time)
      # @param [When::TM::TemporalPosition] t
      #
      # @return [Numeric]
      #
      def mean_longitude(t)
        Moon.mean_longitude(t)
      end

      # 平均運動 / (DEG/YEAR)
      #
      # @return [Numeric]
      #
      def mean_motion
        P0L[0][2]
      end

      #
      # オブジェクトの生成
      # @private
      def initialize(*args)
        options = [args.pop] if args[-1].kind_of?(Hash)
        surface_radius, aberration, luminosity, *rest = args
        surface_radius ||= 1738.1
        aberration     ||=    0.00020
        luminosity     ||=    0.40
        args  = [surface_radius, aberration, luminosity] + rest
        args += options if options
        super(*args)
      end
    end

    #
    # The Shadow of the Earth
    #
    class Shadow < Earth

      # 地球の影の位置 (黄道座標)
      #
      # @param [Numeric] t ユリウス日(Terrestrial Time)
      # @param [When::TM::TemporalPosition] t
      #
      # @return [When::Ephemeris::Coords]
      #
      def _coords(t)
        t  = +t
        radius = Sun.pi(t) + Moon.pi(t)/AU
        dl = 0.5 + @aberration / radius / 360 # 略算式に含まれる光行差をキャンセルする
        Coords.polar(Sun.true_longitude(t)+dl, 0, radius, Sun.mean_longitude(t)+dl)
      end

      # 地球の影の視半径 / CIRCLE
      #
      # @param [Numeric] t ユリウス日(Terrestrial Time)
      # @param [When::TM::TemporalPosition] t
      # @param [When::Coordinates::Spatial] base 観測地
      #
      # @return [Numeric]
      #
      def apparent_radius(t, base=nil)
        t  = +t
        radius = Sun.pi(t) * AU
        (asin(surface_radius/Moon.pi(t)) -
         asin(Ephemeris::Sun::Radius/radius) +
         asin(surface_radius/radius)) * 1.02 / CIRCLE
      end
    end
  end
end
