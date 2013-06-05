# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2012 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  module Ephemeris

    #------------------------------------------
    #     惑星位置計算用データ
    #------------------------------------------

    # 水星の日心黄経
    # @private
    P1L =
      [[LIN   ,  252.2502    ,  149474.0714   ,  0.0003   ],
       [COS   ,   84.7947    ,  149472.5153   , 23.4405   ],
       [COST  ,   84.7947    ,  149472.5153   ,  0.0023   ],
       [COS   ,  259.589     ,  298945.031    ,  2.9818   ],
       [COST  ,  259.589     ,  298945.031    ,  0.0006   ],
       [COS   ,   74.38      ,  448417.55     ,  0.5258   ],
       [COS   ,  137.84      ,  298945.77     ,  0.1796   ],
       [COS   ,  249.2       ,  597890.1      ,  0.1061   ],
       [COS   ,  143.0       ,  149473.3      ,  0.085    ],
       [COS   ,  312.6       ,  448418.3      ,  0.076    ],
       [COS   ,  127.4       ,  597890.8      ,  0.0256   ],
       [COS   ,   64.0       ,  747362.6      ,  0.023    ],
       [COS   ,  302.0       ,  747363.0      ,  0.0081   ],
       [COS   ,  148.0       ,       1.0      ,  0.0069   ],
       [COS   ,  239.0       ,  896835.0      ,  0.0052   ],
       [COS   ,  117.0       ,  896836.0      ,  0.0023   ],
       [COS   ,   85.0       ,    6356.0      ,  0.0019   ],
       [COS   ,   54.0       , 1046308.0      ,  0.0011   ],
       [COS   ,  234.0       ,   32437.0      ,  0.001    ],
       [COS   ,  171.0       ,  143403.0      ,  0.0009   ],
       [COS   ,  268.0       ,  155828.0      ,  0.0006   ],
       [COS   ,  292.0       , 1046308.0      ,  0.0005   ],
       [COS   ,   84.0       ,  143117.0      ,  0.0004   ],
       [COS   ,   63.0       ,  181909.0      ,  0.0003   ],
       [COS   ,  288.0       ,  123392.0      ,  0.0003   ],
       [COS   ,   11.0       ,  448419.0      ,  0.0003   ]]
    # 水星の日心黄緯
    # @private
    P1B =
      [[COS   ,  113.919     ,  149472.886    ,  6.7057   ],
       [COST  ,  113.919     ,  149472.886    ,  0.0017   ],
       [COS   ,  119.12      ,       0.37     ,  1.4396   ],
       [COST  ,  119.12      ,       0.37     ,  0.0005   ],
       [COS   ,  288.71      ,  298945.4      ,  1.3643   ],
       [COST  ,  288.71      ,  298945.4      ,  0.0005   ],
       [COS   ,  103.51      ,  448417.92     ,  0.3123   ],
       [COS   ,  278.3       ,  597890.4      ,  0.0753   ],
       [COS   ,   55.7       ,  149472.1      ,  0.0367   ],
       [COS   ,   93.1       ,  747362.9      ,  0.0187   ],
       [COS   ,  230.0       ,  298945.0      ,  0.005    ],
       [COS   ,  268.0       ,  896835.0      ,  0.0047   ],
       [COS   ,  342.0       ,  448419.0      ,  0.0028   ],
       [COS   ,  347.0       ,  298946.0      ,  0.0023   ],
       [COS   ,  157.0       ,  597891.0      ,  0.002    ],
       [COS   ,   83.0       , 1046308.0      ,  0.0012   ],
       [COS   ,  331.0       ,  747364.0      ,  0.0009   ],
       [COS   ,   45.0       ,  448417.0      ,  0.0009   ],
       [COS   ,  352.0       ,  149474.0      ,  0.0005   ],
       [COS   ,  146.0       ,  896836.0      ,  0.0003   ]]
    # 水星の動径
    # @private
    P1R =
      [[LIN   ,    0.395283  ,       0.000002 ,  0.0      ],
       [COS   ,  354.795     ,  149472.515    ,  0.078341 ],
       [COST  ,  354.795     ,  149472.515    ,  0.000008 ],
       [COS   ,  169.59      ,  298945.03     ,  0.007955 ],
       [COST  ,  169.59      ,  298945.03     ,  0.000002 ],
       [COS   ,  344.38      ,  448417.55     ,  0.001214 ],
       [COS   ,  159.2       ,  597890.0      ,  0.000218 ],
       [COS   ,  334.0       ,  747363.0      ,  0.000042 ],
       [COS   ,  149.0       ,  896835.0      ,  0.000006 ]]

    # 金星の日心黄経
    # @private
    P2L =
      [[LIN   , 310.1735     ,    +585.19212  ,  3E-8     ],
       [SINL  , 107.44       ,   +1170.37     , -0.0503   ],
       [SIN   , 248.6        ,     -19.34     , -0.0048   ],
       [SIN   , 198          ,    +720.0      , -0.0004   ]]
    # 金星の日心黄経の補正
    # @private
    P2dL =
      [[SIN   , 178.954      ,    +585.1781011,  0.7775   ,+1.38E-7   ],
       [SINT  , 178.954      ,    +585.1781011, -0.00005  ,+1.38E-7   ],
       [SIN   , 357.9        ,   +1170.35     , +0.0033   ],
       [SIN   , 242.3        ,    +450.37     , +0.0031   ],
       [SIN   , 273.5        ,    +675.55     , +0.0020   ],
       [SIN   ,  31.1        ,    +225.18     , +0.0014   ],
       [SIN   , 233.1        ,     +90.38     , +0.0010   ],
       [SIN   , 350          ,      +1.5      , +0.0008   ],
       [SIN   , 136          ,    +554.8      , +0.0008   ],
       [SIN   , 295          ,    +540.7      , +0.0004   ],
       [SIN   ,  61          ,     -44.4      , +0.0004   ],
       [SIN   ,  17          ,     -30.3      , +0.0004   ],
       [SIN   , 125          ,    +900.7      , +0.0003   ],
       [SIN   ,  44          ,     +11.0      , +0.0003   ]]
    # 金星の日心黄緯
    # @private
    P2B =
      [[SINL  , 233.72       ,    +585.183    , +0.05922  ]]
    # 金星の動径の対数
    # @private
    P2Q =
      [[LIN   ,  -0.140658   ,       0.0      ,  0.0      ],
       [COS   , 178.954      ,    +585.178    , -0.002931 ],
       [COS   , 357.9        ,   +1170.35     , -0.000015 ],
       [COS   ,  62.3        ,    +450.37     , +0.000010 ],
       [COS   ,  93          ,    +675.6      , +0.000008 ]]

    # 火星の日心黄経
    # @private
    P4L =
      [[LIN   , 249.3542     ,    +191.4169632,  3.11E-8  ],
       [SINL  ,  40.01       ,    +382.8184846, -0.0149   ,6.22E-8],
       [SIN   , 248.6        ,     -19.34136  , -0.00478  ],
       [SIN   , 198          ,    +720.01539  , -0.00037  ]]
    # 火星の日心黄経の補正
    # @private
    P4dL =
      [[SIN   , 273.768      ,    +191.39855  ,+10.6886   ,1.76E-8   ],
       [SINT  , 273.768      ,    +191.39855  , +0.00010  ,1.76E-8   ],
       [SIN   , 187.54       ,    +382.79710  , +0.6225   ,3.52E-8   ],
       [SIN   , 101.31       ,    +574.19566  , +0.0503   ,5.28E-8   ],
       [SIN   ,  62.31       ,      +0.198    , +0.0146   ],
       [SIN   ,  71.8        ,    +161.05     , +0.0071   ,10E-8     ],
       [SIN   , 230.2        ,    +130.71     , +0.0061   ,18E-8     ],
       [SIN   ,  15.1        ,    +765.5942   , +0.0046   , 8E-8     ],
       [SIN   , 147.5        ,    +322.11     , +0.0045   ],
       [SIN   , 279.3        ,     -22.81     , +0.0039   ],
       [SIN   , 207.7        ,    +168.59     , +0.0024   ],
       [SIN   , 140.1        ,    +145.78     , +0.0020   ],
       [SIN   , 224.7        ,     +10.98     , +0.0018   ],
       [SIN   , 221.8        ,     -45.62     , +0.0014   ],
       [SIN   ,  91.4        ,     -30.34     , +0.0010   ],
       [SIN   , 268          ,    +100.4      , +0.0009   ],
       [SIN   , 343          ,     352.5      , +0.0009   ],
       [SIN   ,  71          ,    +123.0      , +0.0007   ],
       [SIN   , 203          ,    +291.8      , +0.0007   ],
       [SIN   ,  62          ,    +513.5      , +0.0006   ],
       [SIN   , 289          ,    +957.0      , +0.0005   ],
       [SIN   ,  13          ,    +167.0      , +0.0005   ],
       [SIN   , 318          ,     -60.7      , +0.0004   ],
       [SIN   , 318          ,    +179.2      , +0.0004   ],
       [SIN   ,  85          ,      +8.9      , +0.0004   ],
       [SIN   ,  57          ,    +483.2      , +0.0004   ],
       [SIN   ,   7          ,    -214.2      , +0.0004   ],
       [SIN   ,   1          ,    +100.2      , +0.0003   ]]
    # 火星の日心黄緯
    # @private
    P4B =
      [[SINL  , 200.00       ,    +191.4092423,  0.03227  , 2.949E-8  ],
       [SINLT , 200.00       ,    +191.4092423, -1.06029E-7,2.949E-8  ]]
    # 火星の動径の対数
    # @private
    P4Q =
      [[LIN   ,  +0.183844   ,       0.0      ,  0.0      ],
       [COS   , 273.768      ,    +191.39855  , -0.040421 ,1.76E-8   ],
       [COS   , 187.54       ,    +382.79710  , -0.002825 ,3.52E-8   ],
       [COS   , 101.31       ,    +574.19566  , -0.000249 ,5.28E-8   ],
       [COS   ,  15.1        ,    +765.5942   , -0.000024 ,7.04E-8   ],
       [COS   , 251.7        ,    +161.05     , +0.000023 ],
       [COS   , 327.6        ,    +322.11     , +0.000022 ],
       [COS   ,  50.2        ,    +130.71     , +0.000017 ],
       [COS   ,  27          ,    +168.6      , +0.000007 ],
       [COS   , 320          ,    +145.8      , +0.000006 ]]

    # 木星の日心平均黄経
    # @private
    P5L =
      [[LIN   , 355.1734     ,     +30.36303  ,  2.24E-8  ]]
    # 木星の日心黄経の補正
    # @private
    P5dL =
      [[LIN   , 341.5208     ,     +30.3490575,  2.24E-8  ],
       [LIN   ,  +0.0004     ,       0.0      ,  0.0      ],
       [SIN   , 245.94       ,     -30.3490575, +0.0350   ,-2.24E-8   ],
       [SINT  , 245.94       ,     -30.3490575, +0.00028  ,-2.24E-8   ],
       [SIN   , 162.78       ,      +0.38394  , -0.0019   ],
       [SINT  , 162.78       ,      +0.38394  , -0.000015 ],
       [SIN   , 162.78       ,      +0.38394  , +0.3323   ],
       [SIN   ,  38.46       ,     -36.25584  , +0.0541   ,+5.92E-8   ],
       [SIN   , 293.42       ,     -29.94148  , +0.0447   ,+1.93E-7   ],
       [SIN   ,  44.50       ,      -5.90678  , +0.0342   ,+8.15E-8   ],
       [SIN   , 201.25       ,     -24.03470  , +0.0230   ,+1.11E-7   ],
       [SIN   , 109.99       ,     -18.12792  , +0.0222   ,+2.96E-8   ],
       [SIN   , 248.6        ,     -19.34     , -0.0048   ],
       [SIN   , 184.6        ,     -11.81     , +0.0047   ],
       [SIN   , 150.1        ,     -54.38     , +0.0045   ],
       [SIN   , 130.7        ,     -42.16     , +0.0042   ],
       [SIN   ,   7.6        ,      +6.31     , +0.0039   ],
       [SIN   , 163.2        ,     +12.22     , +0.0031   ],
       [SIN   , 145.6        ,      +0.77     , +0.0031   ],
       [SIN   , 191.3        ,      -0.23     , +0.0024   ],
       [SIN   , 148.4        ,     +24.44     , +0.0019   ],
       [SIN   , 197.9        ,     -29.941    , +0.0017   ],
       [SIN   , 307.9        ,     +36.66     , +0.0010   ],
       [SIN   , 227.5        ,     -72.51     , +0.0010   ],
       [SIN   , 269.0        ,     -60.29     , +0.0010   ],
       [SIN   , 278.7        ,     -29.53     , +0.0010   ],
       [SIN   ,  52          ,     -66.6      , +0.0008   ],
       [SIN   ,  24          ,     -35.8      , +0.0008   ],
       [SIN   , 356          ,      -5.5      , +0.0005   ],
       [SIN   , 186          ,     -23.6      , +0.0005   ],
       [SIN   , 344          ,      -5.9      , +0.0004   ],
       [SIN   , 222          ,     -48.1      , +0.0004   ],
       [SIN   , 198          ,    +720.0      , -0.0004   ],
       [SIN   , 140          ,     -48.5      , +0.0004   ],
       [SIN   , 104          ,     -24.0      , +0.0004   ],
       [SIN   , 317          ,     -30.3      , +0.0003   ],
       [SIN   , 280          ,     -17.7      , +0.0003   ],
       [SIN   , 262          ,     -60.7      , +0.0003   ],
       [SIN   , 211          ,     -26.1      , +0.0003   ],
       [SIN   , 209          ,     +42.6      , +0.0003   ],
       [SIN   ,   1          ,     -90.6      , +0.0003   ]]
    # 木星の日心黄緯
    # @private
    P5B =
      [[SIN   , 291.9        ,     -29.94     , +0.0010   ],
       [SIN   , 196          ,     -24.0      , +0.0003   ]]
    # 木星の動径の対数
    # @private
    P5Q =
      [[COS   , 245.93       ,     -30.3490575,  0.000132 ,-2.24E-8   ],
       [COST  , 245.93       ,     -30.3490575, +0.0000011,-2.24E-8   ],
       [COS   ,  38.47       ,     -36.25584  , +0.000230 ,+5.92E-8   ],
       [COS   , 293.36       ,     -29.94148  , -0.000168 ,+1.93E-7   ],
       [COS   , 200.5        ,     -24.03470  , +0.000074 ,+1.11E-7   ],
       [COS   , 110.0        ,     -18.12792  , +0.000055 ,+2.96E-8   ],
       [COS   ,  39.3        ,      -5.90678  , +0.000038 ,+8.15E-8   ],
       [COS   , 150.9        ,     -54.33     , +0.000024 ],
       [COS   , 336.4        ,      +0.41     , +0.000023 ],
       [COS   , 131.7        ,     -42.16     , +0.000019 ],
       [COS   , 180          ,     -11.8      , +0.000009 ],
       [COS   , 277          ,     -60.3      , +0.000007 ],
       [COS   , 330          ,     +24.4      , +0.000006 ],
       [COS   ,  53          ,     -66.6      , +0.000006 ],
       [COS   , 188          ,      +6.3      , +0.000006 ],
       [COS   , 251          ,     -72.5      , +0.000006 ],
       [COS   , 198          ,     -29.9      , +0.000006 ],
       [COS   , 353.5        ,     +12.22     , +0.000005 ]]
    # 木星への土星からの摂動項
    # @private
    P5n = [+5.5280,     +0.1666, +0.0079, +0.0003]
    # @private
    P5l = [+0.0075,     +5.94,  +13.6526, +0.01396925]
    # @private
    P5t = [+0.022889, +272.975,  +0.0128, +0.00010,  +35.52]
    # @private
    P5r = [+5.190688,   +0.048254]

    # 土星の日心平均黄経
    # @private
    P6L =
      [[LIN   , 104.1602     ,     +12.2351075,  5.195E-8 ]]
    # 土星の日心黄経の補正
    # @private
    P6dL =
      [[LIN   ,  12.3042     ,     +12.2211383,  5.195E-8 ],
       [LIN   ,  +0.0008     ,       0.0      ,  0.0      ],
       [SIN   , 250.29       ,     +12.2211383, +0.0934   ,5.195E-8  ],
       [SINT  , 250.29       ,     +12.2211383, +0.00075  ,5.195E-8  ],
       [SIN   , 265.8        ,     -11.8135619, +0.0057   ,1.631E-7  ],
       [SINT  , 265.8        ,     -11.8135619, +0.00005  ,1.631E-7  ],
       [SIN   , 162.7        ,      +0.38394  , +0.0049   ],
       [SINT  , 162.7        ,      +0.38394  , +0.00004  ],
       [SIN   , 262.0        ,     +24.44     , +0.0019   ],
       [SINT  , 262.0        ,     +24.44     , +0.00002  ],
       [SIN   , 342.74       ,      +0.38394  , +0.8081   ],
       [SIN   ,   3.57       ,     -11.8135619, +0.1900   ,+1.63E-7   ],
       [SIN   , 224.52       ,      -5.9067809, +0.1173   ,+8.153E-8  ],
       [SIN   , 176.6        ,      +6.31     , +0.0093   ],
       [SIN   , 218.5        ,     -36.26     , +0.0089   ],
       [SIN   ,  10.4        ,      -0.23     , +0.0080   ],
       [SIN   ,  56.8        ,      +0.63     , +0.0078   ],
       [SIN   , 325.4        ,      +0.77     , +0.0074   ],
       [SIN   , 209.4        ,     -24.03     , +0.0073   ],
       [SIN   , 202.0        ,     -11.59     , +0.0064   ],
       [SIN   , 248.6        ,     -19.34     , -0.0048   ],
       [SIN   , 105.2        ,     -30.35     , +0.0034   ],
       [SIN   ,  23.6        ,     -15.87     , +0.0034   ],
       [SIN   , 348.4        ,     -11.41     , +0.0025   ],
       [SIN   , 102.5        ,      -7.94     , +0.0022   ],
       [SIN   ,  53.5        ,      -3.65     , +0.0021   ],
       [SIN   , 220.4        ,     -18.13     , +0.0020   ],
       [SIN   , 326.7        ,     -54.38     , +0.0018   ],
       [SIN   , 173.0        ,      -5.50     , +0.0017   ],
       [SIN   , 165.5        ,      -5.91     , +0.0014   ],
       [SIN   , 307.9        ,     -42.16     , +0.0013   ],
       [SIN   , 292          ,     -29.9      , +0.0009   ],
       [SIN   , 287          ,     -17.7      , +0.0009   ],
       [SIN   , 299          ,     -48.5      , +0.0008   ],
       [SIN   , 146          ,     +24.4      , +0.0007   ],
       [SIN   , 155          ,     +12.2      , +0.0007   ],
       [SIN   , 123          ,     +12.6      , +0.0007   ],
       [SIN   , 199.7        ,     -12.4      , +0.0005   ],
       [SIN   , 146          ,     -10.0      , +0.0005   ],
       [SIN   ,   6          ,     +12.6      , +0.0005   ],
       [SIN   ,  75          ,     -72.5      , +0.0005   ],
       [SIN   ,  57          ,     -60.3      , +0.0004   ],
       [SIN   , 137          ,     -23.8      , +0.0004   ],
       [SIN   , 187          ,     -23.6      , +0.0004   ],
       [SIN   , 198          ,    +720.0      , -0.0004   ],
       [SIN   , 255          ,      -0.2      , +0.0003   ],
       [SIN   , 202          ,      -7.3      , +0.0003   ],
       [SIN   , 182          ,      +4.3      , +0.0003   ],
       [SIN   , 122          ,      -7.9      , +0.0003   ],
       [SIN   ,  87          ,      +6.3      , +0.0003   ],
       [SIN   , 116          ,     -24.0      , +0.0003   ],
       [SIN   , 111          ,     -20.1      , +0.0003   ]]
    # 土星の日心黄緯
    # @private
    P6B =
      [[SIN   ,   3.9        ,     -11.81     , +0.0024   ],
       [SIN   , 269          ,      -5.9      , +0.0008   ],
       [SIN   , 135          ,     -30.3      , +0.0005   ]]
    # 土星の動径の対数
    # @private
    P6Q =
      [[LIN   ,  +0.000183   ,       0.0      ,  0.0      ],
       [COS   ,  70.28       ,     +12.2211383,  0.000354 ,5.195E-8  ],
       [COST  ,  70.28       ,     +12.2211383, +0.0000028,5.195E-8  ],
       [COS   , 265.8        ,     -11.8135619, +0.000021 ,1.631E-7  ],
       [COST  , 265.8        ,     -11.8135619, +0.0000002,1.631E-7  ],
       [COS   ,   3.43       ,     -11.8135619, +0.000701 ,1.631E-7  ],
       [COS   , 110.54       ,     -18.1279192, +0.000378 ,2.958E-8  ],
       [COS   , 219.13       ,      -5.9067809, +0.000244 ,+8.153E-7 ],
       [COS   , 158.22       ,      +0.38394  , +0.000114 ],
       [COS   , 218.1        ,     -36.26     , +0.000064 ],
       [COS   , 215.8        ,     -24.03     , +0.000042 ],
       [COS   , 201.8        ,     -11.59     , +0.000024 ],
       [COS   ,   1.3        ,      +6.31     , +0.000024 ],
       [COS   , 307.7        ,     +12.22     , +0.000019 ],
       [COS   , 326.3        ,     -54.38     , +0.000015 ],
       [COS   , 311.1        ,     -42.16     , +0.000010 ],
       [COS   ,  83.2        ,     +24.44     , +0.000010 ],
       [COS   , 348          ,     -11.4      , +0.000009 ],
       [COS   , 129          ,     -30.3      , +0.000008 ],
       [COS   , 295          ,     -29.9      , +0.000006 ],
       [COS   , 148          ,     -48.5      , +0.000006 ],
       [COS   , 103          ,      -7.9      , +0.000006 ],
       [COS   , 318          ,     +24.4      , +0.000005 ],
       [COS   ,  24          ,     -15.9      , +0.000005 ]]
    # 土星への木星からの摂動項
    # @private
    P6n = [+6.4215,     +0.2248, +0.0109, +0.0006]
    # @private
    P6l = [+0.0272,   +135.53,  +91.8560, +0.01396925]
    # @private
    P6t = [+0.043519, +337.763,  +0.0286, +0.00023,  +77.06]
    # @private
    P6r = [+9.508863,   +0.056061]

    # 天王星の日心黄経
    # @private
    P7L =
      [[LIN   ,  313.33676   ,     428.7288   ,  0.0003   ],
       [COS   ,   48.8503    ,     460.61987  ,  5.35857  ],
       [COST  ,  114.0274    ,     705.15539  ,  3.20671  ],
       [COST  ,  317.7651    ,     597.77389  ,  2.69325  ],
       [COS   ,  188.3245    ,     919.0429   ,  0.58964  ],
       [COS   ,  354.5935    ,    1065.1192   ,  0.12397  ],
       [COS   ,  351.028     ,    2608.702    ,  0.01475  ],
       [COS   ,  247.7       ,    1968.3      ,  0.0009   ],
       [COS   ,   10.4       ,    5647.4      ,  0.00036  ],
       [COS   ,  183.6       ,    2356.6      ,  0.00017  ],
       [COS   ,  321.9       ,    2873.2      ,  0.00017  ],
       [COS   ,  313.4       ,    3798.6      ,  0.00015  ],
       [COS   ,  308.1       ,    3157.9      ,  0.00014  ]]
    # 天王星の日心黄緯
    # @private
    P7B =
      [[COST  ,  188.32394   ,     507.52281  ,  1.78488  ],
       [COS   ,  128.15303   ,     419.91739  ,  1.15483  ],
       [COS   ,  273.6644    ,     652.9504   ,  0.67756  ],
       [COST  ,  354.9571    ,     892.2869   ,  0.56518  ],
       [COS   ,   83.3517    ,     998.0302   ,  0.1349   ],
       [LIN   ,   -0.02997   ,       0.0      ,  0.0      ],
       [COST  ,  263.0       ,    1526.5      ,  0.00036  ],
       [COS   ,  194.2       ,    3030.9      ,  0.00025  ]]
    # 天王星の動径
    # @private
    P7R =
      [[LIN   ,   19.203034  ,       0.0      ,  0.0      ],
       [COS   ,  320.313     ,     408.729    ,  0.90579  ],
       [COST  ,   19.879     ,     440.702    ,  0.361949 ],
       [COST  ,  307.419     ,     702.024    ,  0.166685 ],
       [COS   ,   67.99      ,     799.95     ,  0.06271  ],
       [LIN   ,    0.0       ,       0.042617 ,  0.0      ],
       [COS   ,   80.4       ,    2613.7      ,  0.004897 ],
       [COS   ,  202.0       ,    1527.0      ,  0.000656 ],
       [COS   ,  321.0       ,    2120.0      ,  0.000223 ],
       [COS   ,   37.0       ,    3104.0      ,  0.000205 ],
       [COS   ,  100.0       ,    5652.0      ,  0.00012  ]]

    # 海王星の日心黄経
    # @private
    P8L =
      [[LIN   ,  -55.13323   ,     219.93503  ,  0.0003   ],
       [COS   ,  167.7269    ,     221.3904   ,  0.9745   ],
       [COST  ,  332.797     ,     684.128    ,  0.04403  ],
       [COST  ,  342.114     ,     904.371    ,  0.02928  ],
       [COS   ,   50.826     ,     986.281    ,  0.01344  ],
       [COS   ,    0.09      ,    2815.89     ,  0.00945  ],
       [COS   ,  309.35      ,    2266.5      ,  0.00235  ],
       [COS   ,  127.61      ,    2279.43     ,  0.00225  ],
       [COS   ,   19.2       ,    5851.6      ,  0.00023  ]]
    # 海王星の日心黄緯
    # @private
    P8B =
      [[COS   ,   83.11018   ,     218.87906  ,  1.76958  ],
       [LIN   ,    0.01725   ,       0.0      ,  0.0      ],
       [COS   ,  338.864     ,     447.128    ,  0.01366  ],
       [COS   ,  224.7       ,    1107.1      ,  0.00015  ],
       [COS   ,  187.5       ,    2596.7      ,  0.00015  ],
       [COS   ,  243.9       ,    3035.0      ,  0.00012  ]]
    # 海王星の動径
    # @private
    P8R =
      [[LIN   ,   30.073033  ,       0.0      ,  0.0      ],
       [COS   ,   79.994     ,     222.371    ,  0.260457 ],
       [COST  ,  195.7       ,     515.2      ,  0.009784 ],
       [COS   ,   90.1       ,    2815.4      ,  0.004944 ],
       [COS   ,  308.1       ,     524.0      ,  0.003364 ],
       [COS   ,  104.0       ,    1025.1      ,  0.002579 ],
       [COS   ,  111.0       ,    5845.0      ,  0.00012  ]]

    # 冥王星の日心黄経
    # @private
    P9L =
      [[LIN   ,  241.82574   ,     179.09519  , -0.0091   ],
       [COS   ,  298.348019  ,     246.556453 , 15.81087  ],
       [COS   ,  351.67676   ,     551.3471   ,  1.18379  ],
       [COS   ,   41.989     ,     941.622    ,  0.07886  ],
       [COS   ,   60.35      ,    2836.46     ,  0.00861  ],
       [COS   ,  112.91      ,    1306.75     ,  0.0059   ],
       [COS   ,   19.01      ,    2488.14     ,  0.00145  ],
       [COS   ,   77.9       ,    5861.8      ,  0.00022  ],
       [COS   ,  293.0       ,    3288.8      ,  0.00013  ]]
    # 冥王星の日心黄緯
    # @private
    P9B =
      [[COS   ,   42.574982  ,     172.554318 , 17.0455   ],
       [COS   ,   66.1535    ,     415.6063   ,  2.4531   ],
       [LIN   ,   -2.30285   ,       0.0      ,  0.0      ],
       [COS   ,  105.084     ,     713.1227   ,  0.26775  ],
       [COS   ,  146.66      ,    1089.202    ,  0.01855  ],
       [COS   ,  293.06      ,    2658.22     ,  0.00119  ],
       [COS   ,   18.8       ,    3055.6      ,  0.00098  ],
       [COS   ,  213.7       ,    1532.6      ,  0.0009   ],
       [COS   ,  254.2       ,    2342.3      ,  0.00042  ]]
    # 冥王星の動径
    # @private
    P9R =
      [[LIN   ,   38.662489  ,       0.0      ,  0.0      ],
       [COS   ,  198.4973    ,     181.3383   ,  8.670489 ],
       [COS   ,  228.717     ,     475.963    ,  0.333884 ],
       [COS   ,  252.9       ,     909.8      ,  0.008426 ],
       [COST  ,   31.0       ,    1425.9      ,  0.007619 ],
       [COS   ,  149.4       ,    2831.6      ,  0.004902 ],
       [COST  ,  199.5       ,    2196.1      ,  0.002543 ],
       [COS   ,  114.1       ,    1748.0      ,  0.001188 ],
       [COS   ,   15.0       ,    3188.0      ,  0.00039  ],
       [COS   ,  169.0       ,    5860.0      ,  0.000116 ]]

    class Datum < CelestialObject

      # Far planets - Mercury, Uranus, Neptune and Pluto
      #
      # 起動要素の精度が低く、平均運動がユリウス世紀あたりの値である
      #
      class Far < Datum

        # 位置 (黄道座標)
        #
        # @param [Numeric] t ユリウス日(Terrestrial Time)
        # @param [When::TM::TemporalPosition] t
        #
        # @return [When::Ephemeris::Coords]
        #
        def _coords(t)
          c = julian_century_from_2000(+t)
          Coords.polar(
            trigonometric(c, @phi)       / 360,
            trigonometric(c, @theta)     / 360,
            trigonometric(c, @radius)    / 360,
            trigonometric(c, @phi, 0, 1) / 360).nutation(c)
        end

        # 平均運動 / (DEG/YEAR)
        #
        # @return [Numeric]
        #
        def mean_motion
          100.0 * super
        end
      end

      # Near planets - Venus and Mars
      #
      # 起動要素の精度が高く、平均運動が年あたりの値である
      #
      class Near < Datum

        #
        # 位置 (黄道座標)
        #
        # @param [Numeric] t ユリウス日(Terrestrial Time)
        # @param [When::TM::TemporalPosition] t
        #
        # @return [When::Ephemeris::Coords]
        #
        def _coords(t)
          y  = julian_year_from_1975(+t)
          dl = trigonometric(y, @dl)
          Coords.polar(
                  trigonometric(y, @phi, dl)    / 360,
             asin(trigonometric(y, @theta, dl)) / CIRCLE,
              10**trigonometric(y, @radius),
                  trigonometric(y, @phi, 0, 1)  / 360)
        end
      end

      #   Big planets - Jupiter and Saturn
      #
      #   軌道が互いに影響を与えており、共鳴項が大きい
      #
      class Big < Datum

        # 位置 (黄道座標)
        #
        # @param [Numeric] t ユリウス日(Terrestrial Time)
        # @param [When::TM::TemporalPosition] t
        #
        # @return [When::Ephemeris::Coords]
        #
        def _coords(t)
          y  = julian_year_from_1975(+t)
          phi = nn = trigonometric(y, @nn)
          @jsn.each_index do |k|
            phi += @jsn[k] * sind((k+1)*nn)
          end
          Coords.polar(
                      (phi+ @jsl[0]*sind(2*phi+@jsl[1]) + @jsl[2] + @jsl[3]*y) / 360,
                                               asin(@jst[0]*sind(phi+@jst[1])) / CIRCLE +
            ((@jst[2]+@jst[3]*y)*sind(phi+@jst[4]) + trigonometric(y, @theta)) / 360,
                 10**(trigonometric(y,@radius)) * @jsr[0]/(1+@jsr[1]*cosd(phi)),
                                                  trigonometric(y, @phi, 0, 1) / 360)
        end
      end
    end

    # 水星
    Mercury = Datum::Far.new(   2440.0,  0.00347  ,  1.16, {:phi=>P1L, :theta=>P1B,  :radius=>P1R})

    # 金星
    Venus   = Datum::Near.new(  5988.0,  0.00484  , -4.00, {:phi=>P2L, :dl=>P2dL, :theta=>P2B, :radius=>P2Q})

    # 火星
    Mars    = Datum::Near.new(  3397.0,  0.00700  , -1.30, {:phi=>P4L, :dl=>P4dL, :theta=>P4B, :radius=>P4Q})

    # 木星
    Jupiter = Datum::Big.new(  71398.0,  0.01298  , -8.93, {:phi=>P5L, :nn=>P5dL, :theta=>P5B, :radius=>P5Q,
                                                            :jsn=>P5n, :jsl=>P5l, :jst=>P5t, :jsr=>P5r})

    # 土星
    Saturn  = Datum::Big.new(  60330.0,  0.01756  , -8.68, {:phi=>P6L, :nn=>P6dL, :theta=>P6B, :radius=>P6Q,
                                                            :jsn=>P6n, :jsl=>P6l, :jst=>P6t, :jsr=>P6r})

    # 天王星
    Uranus  = Datum::Far.new(  25400.0,  0.02490  , -6.85, 2433283, 2473460, {:phi=>P7L, :theta=>P7B, :radius=>P7R})

    # 海王星
    Neptune = Datum::Far.new(  24300.0,  0.03121  , -7.05, 2433283, 2473460, {:phi=>P8L, :theta=>P8B, :radius=>P8R})

    # 冥王星
    Pluto   = Datum::Far.new(   1180.0,  0.03461  , -1.00, 2433283, 2473460, {:phi=>P9L, :theta=>P9B, :radius=>P9R})
  end
end
