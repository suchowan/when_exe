# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  module Parts::Locale

    #
    # IAST: International Alphabet of Sanskrit Transliteration
    #
    IAST = {
      'hi' => {
        '%s' => '%s',

        "a"  => "अ",     "A"  => "अ",
        "ā"  => "आ",     "Ā"  => "आ",
        "i"  => "इ",      "I"  => "इ",
        "ī"  => "ई",      "Ī"  => "ई",
        "u"  => "उ",      "U"  => "उ",
        "ū"  => "ऊ",      "Ū"  => "ऊ",
        "ṛ"  => "ऋ",     "Ṛ"  => "ऋ",
        "ṝ"  => "ॠ",     "Ṝ"  => "ॠ",
        "ḷ"  => "ऌ",      "Ḷ"  => "ऌ",
        "ḹ"  => "ॡ",      "Ḹ"  => "ॡ",
        "e"  => "ए",      "E"  => "ए",
        "ai" => "ऐ",      "Ai" => "ऐ",
        "o"  => "ओ",     "O"  => "ओ",
        "au" => "औ",     "Au" => "औ",
        "ṃ"  => "अं",    "Ṃ"  => "अं",
        "ḥ"  => "अः",   "Ḥ"  => "अः",
        "'"  => "अऽ",

        "K"  => "क",     "k"  => "क",
        "C"  => "च",      "c"  => "च",
        "Ṭ"  => "ट",      "ṭ"  => "ट",
        "T"  => "त",      "t"  => "त",
        "P"  => "प",      "p"  => "प",
        "Kh" => "ख",     "kh" => "ख",
        "Ch" => "छ",     "ch" => "छ",
        "Ṭh" => "ठ",      "ṭh" => "ठ",
        "Th" => "थ",      "th" => "थ",
        "Ph" => "फ",     "ph" => "फ",
        "G"  => "ग",      "g"  => "ग",
        "J"  => "ज",     "j"  => "ज",
        "Ḍ"  => "ड",      "ḍ"  => "ड",
        "D"  => "द",      "d"  => "द",
        "B"  => "ब",      "b"  => "ब",
        "Gh" => "घ",      "gh" => "घ",
        "Jh" => "झ",     "jh" => "झ",
        "Ḍh" => "ढ",      "ḍh" => "ढ",
        "Dh" => "ध",      "dh" => "ध",
        "Bh" => "भ",      "bh" => "भ",
        "Ṅ"  => "ङ",      "ṅ"  => "ङ",
        "Ñ"  => "ञ",      "ñ"  => "ञ",
        "Ṇ"  => "ण",     "ṇ"  => "ण",
        "N"  => "न",      "n"  => "न",
        "M"  => "म",      "m"  => "म",
        "H"  => "ह",      "h"  => "ह",
        "Y"  => "य",      "y"  => "य",
        "R"  => "र",      "r"  => "र",
        "L"  => "ल",      "l"  => "ल",
        "V"  => "व",      "v"  => "व",
        "Ś"  => "श",      "ś"  => "श",
        "Ṣ"  => "ष",      "ṣ"  => "ष",
        "S"  => "स",      "s"  => "स"
      }
    }

    # @private
    IAST_keys = Hash[*(IAST.keys.map {|locale|
      [locale, Regexp.new(IAST[locale].keys.sort_by {|key| -key.length}.join('|'))]
    }).flatten]

    #
    # Convert IAST string to indic scripts
    #
    # @private
    def self.iast(string, locale)
      string.gsub(IAST_keys[locale]) {|code|
        IAST[locale][code]
      }
    end
  end

  class BasicTypes::M17n

    IndianTerms = [self, [
      "namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/, hi=http://hi.wikipedia.org/wiki/]",
      "locale:[=en:, ja=ja:, hi=hi:, alias]",
      "names:[IndianTerms=]",
      "[IndianNationalSolar=en:Indian_national_calendar, インド国定暦]",
      "[HinduSolar=en:Hindu_calendar,     インド太陽暦=ja:%%<ヒンドゥー暦>]",
      "[HinduLuniSolar=en:Hindu_calendar, インド太陰太陽暦=ja:%%<ヒンドゥー暦>]",

      [self,
        "names:[IntercalaryMonth=en:Intercalation, 閏月]",
        "[%s Śuklapakṣa=,        %s 白分=,   _IAST_]",
        "[%s Kṛṣṇapakṣa=,        %s 黒分=,   _IAST_]",
        "[adhika %s Śuklapakṣa=, 閏%s 白分=, _IAST_]",
        "[adhika %s Kṛṣṇapakṣa=, 閏%s 黒分=, _IAST_]"
      ],

      [self,
        "names:[IntercalaryDay=en:Intercalation, 閏日=ja:%%<閏>]",
        "[Double %s=,           欠=       ]",
        "[Intercalary %s=,      重=       ]"
      ],

      [self,
        "names:[LunarMonth=, 太陰月=ja:%%<月_(暦)>]",
        "[Mārgaśīra=en:Margashirsha,   マールガシールシャ=, _IAST_]",
        "[Pauṣa=en:Pausha,             パウシャ=,           _IAST_]",
        "[Māgha=en:Maagha,             マーガ=,             _IAST_]",
        "[Phālguna=en:Phalguna,        パールグナ=,         _IAST_]",
        "[Caitra=en:Chaitra,           チャイトラ=,         _IAST_]",
        "[Vaiśākha=en:Vaisakha,        ヴァイシャーカ=,     _IAST_]",
        "[Jyaiṣṭha=en:Jyeshta,         ジャイシュタ=,       _IAST_]",
        "[Āṣāḍha=en:Aashaadha,         アーシャーダ=,       _IAST_]",
        "[Śrāvaṇa=en:Shraavana,        シュラーヴァナ=,     _IAST_]",
        "[Bhādrapada=en:Bhadrapada,    バードラパダ=,       _IAST_]",
        "[Āśvina=en:Ashwin,            アーシュヴィナ=,     _IAST_]",
        "[Kārttika=en:Kartika_(month), カールッティカ=,     _IAST_]"
      ],

      [self,
        "names:[SolarMonth=, 太陽月=ja:%%<月_(暦)>]",
        "[Maysha=,                     白羊宮,              _IAST_]",
        "[Vrushabha=,                  金牛宮,              _IAST_]",
        "[Mithuna=,                    双児宮,              _IAST_]",
        "[Karka=,                      巨蟹宮,              _IAST_]",
        "[Simha=,                      獅子宮,              _IAST_]",
        "[Kanya=,                      処女宮,              _IAST_]",
        "[Tula=,                       天秤宮,              _IAST_]",
        "[Vrushchika=,                 天蝎宮,              _IAST_]",
        "[Dhanu=,                      人馬宮,              _IAST_]",
        "[Makar=,                      磨羯宮,              _IAST_]",
        "[Kumbha=,                     宝瓶宮,              _IAST_]",
        "[Meena=,                      双魚宮,              _IAST_]"
      ]
    ]]
  end

  module Coordinates

    # Location of cities in India
    IndianCities = [When::BasicTypes::M17n, [
      "namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/]",
      "locale:[=en:, ja=ja:, alias]",
      "names:[IndianCities]",
      [Spatial, "long:+82.5", "lat:N23.11", "label:[CentralIndia,       インド中部]"          ],
      [Spatial, "long:+82.5", "lat:+29.0",  "label:[NorthIndia,         インド北部]"          ],
      [Spatial, "long:+78.0", "lat:+27.2",  "label:[Agra,               アーグラ]"            ],
      [Spatial, "long:+72.6", "lat:+23.0",  "label:[Ahmedabad,          アフマダーバード]"    ],
      [Spatial, "long:+74.6", "lat:+26.5",  "label:[Ajmer,              アジメール]"          ],
      [Spatial, "long:+78.1", "lat:+27.9",  "label:[Aligarh,            アリーガル]"          ],
      [Spatial, "long:+74.9", "lat:+31.6",  "label:[Amritsar,           アムリトサル]"        ],
      [Spatial, "long:+77.6", "lat:+13.0",  "label:[Bangalore,          バンガロール]"        ],
      [Spatial, "long:+85.8", "lat:+20.2",  "label:[Bhuvaneswar,        ブヴァネーシュヴァル]"],
      [Spatial, "long:+80.3", "lat:+13.1",  "label:[Chennai,            チェンナイ, Madras]"  ],
      [Spatial, "long:+79.9", "lat: +6.9",  "label:[Colombo,            コロンボ]"            ],
      [Spatial, "long:+90.4", "lat:+23.7",  "label:[Dacca,              ダッカ]"              ],
      [Spatial, "long:+77.2", "lat:+28.6",  "label:[Delhi,              デリー]"              ],
      [Spatial, "long:+78.5", "lat:+17.4",  "label:[Hyderabad,          ハイデラバード]"      ],
      [Spatial, "long:+75.8", "lat:+26.9",  "label:[Jaipur,             ジャイプル]"          ],
      [Spatial, "long:+85.2", "lat:+27.7",  "label:[Kathmandu,          カトマンズ]"          ],
      [Spatial, "long:+76.2", "lat:+10.0",  "label:[Kochi,              コーチ, Cochin]"      ],
      [Spatial, "long:+88.4", "lat:+22.6",  "label:[Kolkata,            コルカタ, Calcutta]"  ],
      [Spatial, "long:+74.3", "lat:+31.6",  "label:[Lahor,              ラホール]"            ],
      [Spatial, "long:+77.7", "lat:+27.5",  "label:[Mathura,            マトゥラー]"          ],
      [Spatial, "long:+72.8", "lat:+19.0",  "label:[Mumbai,             ムンバイ, Bombay]"    ],
      [Spatial, "long:+76.6", "lat:+12.3",  "label:[Mysore,             マイソール]"          ],
      [Spatial, "long:+85.1", "lat:+25.6",  "label:[Patna,              パトナ]"              ],
      [Spatial, "long:+73.9", "lat:+18.5",  "label:[Pune,               プネー]"              ],
      [Spatial, "long:+74.8", "lat:+34.1",  "label:[Srinagar,           シュリーナガル]"      ],
      [Spatial, "long:+77.0", "lat: +8.5",  "label:[Thiruvananthapuram, ティルヴァナンタプラム, Trivandrum]"],
      [Spatial, "long:+83.0", "lat:+25.3",  "label:[Varanasi,           ワーラーナシー]"      ],
      [Spatial, "long:+75.8", "lat:+23.2",  "label:[Ujjain,             ウッジャイン]"        ]
    ]]
  end

  module Ephemeris

    #
    # Hindu Luni-Solar Calendar Formula
    #
    class Hindu < Formula

      # Basic Astronomical Constants for Surya-Siddhanta
      Tz =             0.5+75.8/360 # time difference between JulianDayNumber and Ujjain
      E  =       588_466 - Tz       # Yuga Epoch -3101-02-18T00:00:00
      P  =           180            # Precession cycles in yuga
      Ep =     1_903_318 - Tz       # Precession Epoch 499-01-01
      Ob =  24.0 / 360.0            # Obliquity of the ecliptic

      Grahas = {
        'SS' => {                         #     Previous  /  Newest
          :Star      => 1_582_237_800.0,  # 1_582_237_500 / 1_582_237_800
          :Sun       =>     4_320_000.0,
          :Moon      =>    57_753_336.0,
          :Mercury   =>    17_937_000.0,
          :Venus     =>     7_022_388.0,
          :Mars      =>     2_296_824.0,
          :Jupiter   =>       364_220.0,
          :Saturn    =>       146_564.0,
          :Candrocca =>       488_219.0,  #       488_203 /       488_219
          :Rahu      =>      -232_226.0
        },
        'SB' => {
          :Star      => 1_582_237_828.0,
          :Sun       =>     4_320_000.0,
          :Moon      =>    57_753_336.0,
          :Mercury   =>    17_937_060.0,
          :Venus     =>     7_022_376.0,
          :Mars      =>     2_296_832.0,
          :Jupiter   =>       364_220.0,
          :Saturn    =>       146_568.0,
          :Candrocca =>       488_203.0,   #      488_199 /       488_203
          :Rahu      =>      -232_238.0
        }
      }

      #
      # 日月五惑星とラーフおよびケートゥ
      #
      # @abstract
      class Graha
        include When::Ephemeris
      end

      #
      # 現代的“惑星”
      #
      class ModernGraha < Graha

        # 真黄経
        #
        # @param [Numeric] t ユリウス日
        #
        # @return [Numeric]
        #
        def true_longitude(t)
          @target.coords(t, @base).phi
        end

        # オブジェクトの生成
        #
        # @param [When::Ephemeris::Datum] target 天体
        # @param [When::Coordinates::Spatial] base 観測地
        #
        def initialize(target, base)
          @target = target
          @base   = base
        end
      end

      #
      # 古典的“惑星”
      #
      # @abstract
      class ClassicGraha < Graha

        # 平均黄経
        #
        # @param [Numeric] t ユリウス日
        #
        # @return [Numeric]
        #
        def mean_longitude(t)
          _mean_rotation(t - E)
        end

        # 真黄経
        #
        # @param [Numeric] t ユリウス日
        #
        # @return [Numeric]
        #
        def true_longitude(t)
          _true_rotation(t - E)
        end

        # 平均黄経
        #
        # @param [Numeric] ahar カリユガ暦元からの経過日数
        #
        # @return [Numeric]
        #
        def _mean_rotation(ahar)
          @rotation * ahar / @formula.civil_days
        end

        # オブジェクトの生成
        #
        # @param [When::Ephemeris::Formula] formula 親オブジェクト
        # @param [Numeric] rotation ユガあたりの回転数
        #
        def initialize(formula, rotation)
          @formula  = formula
          @rotation = rotation
        end
      end

      # 架空の“惑星” - ラーフ / 月軌道の遠地点としてのケートゥ
      class VirtualGraha < ClassicGraha

        # 平均黄経
        #
        # @param [Numeric] ahar カリユガ暦元からの経過日数
        #
        # @return [Numeric]
        #
        def _mean_rotation(ahar)
          super + @rotation0
        end
        alias :_true_rotation :_mean_rotation

        # オブジェクトの生成
        #
        # @param [When::Ephemeris::Formula] formula 親オブジェクト
        # @param [Numeric] rotation ユガあたりの回転数
        # @param [Numeric] rotation0 カリユガ暦元での回転量
        #
        def initialize(formula, rotation, rotation0)
          @rotation0 = rotation0 / 360.0
          super(formula, rotation)
        end
      end

      # 実在の“惑星”
      # @abstract
      class RealGraha < ClassicGraha

        # マンダ補正
        #
        # @param [Numeric] rot 平均近点角など / CIRCLE
        #
        # @return [Numeric]
        #
        def _manda_equation(rot)
          asin(@circumm * sinc(rot)) / CIRCLE
        end

        # オブジェクトの生成
        #
        # @param [When::Ephemeris::Formula] formula 親オブジェクト
        # @param [Numeric] rotation ユガあたりの回転数
        # @param [Numeric] circumm マンダ円の半径
        # @param [Numeric] apogee 近点黄経 / CIRCLE
        #
        def initialize(formula, rotation, circumm, apogee)
          @circumm = circumm / 360.0
          @apogee  = apogee  / 360.0
          super(formula, rotation)
        end
      end

      # 太陽と月 - 逆行しない“惑星”
      # @abstract
      class ConcentricGraha < RealGraha

        # 平均黄経
        #
        # @param [Numeric] ahar カリユガ暦元からの経過日数
        #
        # @return [Numeric]
        #
        def _mean_rotation(ahar)
          super + @epoch
        end

        # オブジェクトの生成
        #
        # @param [When::Ephemeris::Formula] formula 親オブジェクト
        # @param [Numeric] rotation ユガあたりの回転数
        # @param [Numeric] circumm マンダ円の半径
        # @param [Numeric] apogee 近点黄経 / CIRCLE
        # @param [Numeric] epoch カリユガ暦元での黄経 / CIRCLE
        #
        def initialize(formula, rotation, circumm, apogee, epoch)
          @epoch = epoch
          super(formula, rotation, circumm, apogee)
        end
      end

      # 太陽
      class Sun < ConcentricGraha

        # 真黄経
        #
        # @param [Numeric] ahar カリユガ暦元からの経過日数
        #
        # @return [Numeric]
        #
        def _true_rotation(ahar)
          mean  = _mean_rotation(ahar)
          mean - _manda_equation(mean - @apogee)
        end
      end

      # 月
      class Moon < ConcentricGraha

        # 真黄経
        #
        # @param [Numeric] ahar カリユガ暦元からの経過日数
        #
        # @return [Numeric]
        #
        def _true_rotation(ahar)
          mean  = _mean_rotation(ahar)
          mean - _manda_equation(mean - @formula.graha[:Candrocca]._mean_rotation(ahar))
        end
      end

      # 惑星 - 逆行するもの
      # @abstract
      class Planet < RealGraha

        # シグラ補正
        #
        # @param [Numeric] anomaly 平均近点角 / CIRCLE
        #
        # @return [Numeric]
        #
        def _sighra_equation(anomaly)
          atan2(@circums * sinc(anomaly), @circums * cosc(anomaly) + 1) / CIRCLE
        end

        # 平均シグラ
        #
        # @param [Numeric] ahar カリユガ暦元からの経過日数
        #
        # @return [Numeric]
        #
        def _mean_sighra(ahar)
          @sighra * ahar / @formula.civil_days
        end

        # 真黄経
        #
        # @param [Numeric] ahar カリユガ暦元からの経過日数
        # @param [Numeric] rotation 基準回転量 / CIRCLE
        #
        # @return [Numeric]
        #
        def _true_rotation(ahar, rotation)
          # first sighra correction
          delta = _sighra_equation(_mean_sighra(ahar) - rotation) / 2

          # first manda correction
          mean  = _mean_rotation(ahar) + delta
          delta = _manda_equation(mean - @apogee) / 2

          # second manda correction
          mean -= delta
          delta = _manda_equation(mean - @apogee)

          # second sighra correction
          mean  = _mean_rotation(ahar) - delta
          delta = _sighra_equation(_mean_sighra(ahar) - mean)

          # true rotation
          mean + delta
        end

        # オブジェクトの生成
        #
        # @param [When::Ephemeris::Formula] formula 親オブジェクト
        # @param [Numeric] rotation ユガあたりの回転数
        # @param [Numeric] circumm マンダ円の半径
        # @param [Numeric] apogee 近点黄経 / CIRCLE
        # @param [Numeric] sighra シグラ対象のカリユガあたりの回転数
        # @param [Numeric] circums シグラ円の半径
        #
        def initialize(formula, rotation, circumm, apogee, sighra, circums)
          @sighra  = sighra
          @circums = circums / 360.0
          super(formula, rotation, circumm, apogee)
        end
      end

      # 内惑星 - 水金
      class InferiorPlanet < Planet

        # 真黄経
        #
        # @param [Numeric] t ユリウス日
        #
        # @return [Numeric]
        #
        def true_longitude(t)
          ahar = t - E
          _true_rotation(ahar, @formula.graha[:Sun]._mean_rotation(ahar))
        end
      end

      # 外惑星 - 火木土
      class SuperiorPlanet < Planet

        # 真黄経
        #
        # @param [Numeric] t ユリウス日
        #
        # @return [Numeric]
        #
        def true_longitude(t)
          ahar = t - E
          _true_rotation(ahar, _mean_rotation(ahar))
        end
      end

      #
      # ユガの太陽日数
      #
      # @return [Numeric]
      #
      attr_reader :civil_days

      # 日の出の日時
      #
      # @param [Numeric] sdn ユリウス日
      # @param [When::TM::TemporalPosition] sdn
      # @param [nil] height 太陽高度(本クラスでは使用しない)
      #
      # @return [Integer, When::TM::DateAndTime] 日の出の日時
      #
      def sunrise(sdn, height=nil)
        t   = sdn.to_i - @long / 360.0 - 0.25
        p   = _mean_sun(t) +  P * (t - Ep) / @civil_days
        _to_seed_type(t - asin(tand(@lat)*tan(asin(sinc(p)*sinc(Ob)))) / CIRCLE, sdn)
      end

      # 日の入りの日時
      #
      # @param [Numeric] sdn ユリウス日
      # @param [When::TM::TemporalPosition] sdn
      # @param [nil] height 太陽高度(本クラスでは使用しない)
      #
      # @return [Integer, When::TM::DateAndTime] 日の入りの日時
      #
      def sunset(sdn, height=nil)
        t   = sdn.to_i - @long / 360.0 + 0.25
        p   = _mean_sun(t) +  P * (t - Ep) / @civil_days
        _to_seed_type(t + asin(tand(@lat)*tan(asin(sinc(p)*sinc(Ob)))) / CIRCLE, sdn)
      end

      # 太陽の南中の日時
      #
      # @param [Numeric] sdn ユリウス日
      # @param [When::TM::TemporalPosition] sdn
      #
      # @return [Integer, When::TM::DateAndTime] 太陽の南中の日時
      #
      def sun_noon(sdn)
        _to_seed_type(sdn.to_i - @long / 360.0, sdn)
      end

      private

      # オブジェクトの正規化
      def _normalize(args=[], options={})
        @time_standard ||= 'universal'
        @bija          ||= 'SB'
        super
      end

      # 九惑星オブジェクトの生成
      def _normalize_grahas
        grahas = Grahas[@bija]

        # ユガあたりの暦定数
        @sidereal_days   = grahas[:Star]                        # 恒星日
        @solar_years     = grahas[:Sun]                         # 太陽年
        @civil_days      = @sidereal_days - @solar_years        # 太陽日
        @sidereal_months = grahas[:Moon]                        # 恒星月
        @synodic_months  = @sidereal_months - @solar_years      # 朔望月
        @adhimasas       = @synodic_months - 12 * @solar_years  # 閏月
        @tithis          = 30 * @sidereal_months                # 太陰日
        @ksayadinas      = @tithis - @civil_days                # 欠日

        # 九惑星
        @graha = {}
        @graha.update({
          :Sun       => Sun.new(           self, @solar_years,       13+50/60.0, 77+17/60.0, -3101)
        }) if @formula =~ /[SL]/i
        @graha.update({
          :Moon      => Moon.new(          self, @sidereal_months,   31+50/60.0,  0,        -28086),
          :Candrocca => VirtualGraha.new(  self, grahas[:Candrocca], 90.0)
        }) if @formula =~ /[ML]/i
        @graha.update({
          :Mercury   => InferiorPlanet.new(self, @solar_years,       29.0, 220+27/60.0, grahas[:Mercury], 131.5),
          :Venus     => InferiorPlanet.new(self, @solar_years,       11.5,  79+50/60.0, grahas[:Venus],   261.0),
          :Mars      => SuperiorPlanet.new(self, grahas[:Mars],      73.5, 130+02/60.0, @solar_years,     233.5),
          :Jupiter   => SuperiorPlanet.new(self, grahas[:Jupiter],   32.5, 171+18/60.0, @solar_years,      71.0),
          :Saturn    => SuperiorPlanet.new(self, grahas[:Saturn],    48.5, 236+37/60.0, @solar_years,      39.5),
          :Rahu      => VirtualGraha.new(  self, grahas[:Rahu],     180.0)
        }) if @formula == '2L'
      end
    end
  end

  class TM::CalendarEra

    IndianNationalSolar = [self, [
      "namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/]",
      "locale:[=en:, ja=ja:, alias]",
      "area:[IndianNationalSolar=en:Indian_national_calendar, インド国定暦]",
      ["[SE=, サカ暦=, alias:Saka_Era]1.1.1", "Calendar Epoch", "79-01-01^IndianNationalSolar"]
    ]]
  end

  module CalendarTypes

    #
    # Indian national solar calendar
    #
    IndianNationalSolar =  [CyclicTableBased, {
      'label'   => When.Resource('_m:IndianTerms::IndianNationalSolar'),
      'origin_of_LSC' => 1721140,
      'indices' => [
         When::Coordinates::Index.new({:unit =>12, :trunk=>When.Resource('_m:IndianTerms::LunarMonth::*'), :shift=>4}),
         When::Coordinates::DefaultDayIndex
       ],
      'rule_table'      => {
        'T'  => {'Rule'  =>['LC', 'SC', 'SC', 'SC']},
        'SC' => {'Rule'  =>[365]*4 + [366, 365, 365, 365]*24},
        'LC' => {'Rule'  =>[366, 365, 365, 365]*25},
        365  => {'Length'=>[30] + [31]*5 + [30]*6},
        366  => {'Length'=>       [31]*6 + [30]*6}
      },
    }]

    #
    # Hindu Solar Calendar
    #
    class HinduSolar  < EphemerisBasedSolar

      # protected

      # 月初の通日
      #
      # @param  [Integer] m 通月
      #
      # @return [Integer] 月初の通日
      #
      def _new_month_(m)
        new_month_time = @formula[0].cn_to_time(m + @cycle_offset)
        new_month_date = (new_month_time + 0.5 + @formula[0].long/360.0).floor
        sunrise_time = @formula[0].sunrise(new_month_date)
        (sunrise_time <= new_month_time) ? new_month_date : new_month_date-1
      end

      private

      # オブジェクトの正規化
      #
      #    @formula[0]   = 位相の計算に用いる太陽の Formula
      #    @cycle_offset = 位相のオフセット
      #    @start_month  = 暦年の最初の月
      #
      def _normalize(args=[], options={})
        @label ||= When.Resource('_m:IndianTerms::HinduSolar')
        @type  ||= 'SBS'
        raise ArgumentError, "Irregal formula: #{@formula}" unless @type.upcase =~ /^(M|SS|SB)(V|S|VZ|SZ)$/

        @location      ||=  HinduLuniSolar::Location[$1]
        @cycle_offset  ||=  HinduLuniSolar::CycleOffset[$1]
        @origin_of_MSC ||= -HinduLuniSolar::YearEpoch[$2]
        @epoch_in_CE   ||=  0
        @start_month   ||=  1 # Maysha
        @start_month     = @start_month.to_i
        @cycle_offset    = @cycle_offset.to_f + (@start_month - 1)
        formula  = @formula || HinduLuniSolar::Formula[$1]
        if formula.kind_of?(String)
          formula += (formula =~ /\?/) ? '&' : '?'
          @formula = [When.Resource("_ep:#{formula}location=(#{@location})&formula=12S")]
        end
        @indices        ||= [
          Coordinates::Index.new({:trunk=>When.Resource('_m:IndianTerms::SolarMonth::*'),
                                  :shift=>@start_month-1}),
          Coordinates::DefaultDayIndex
        ]

        super
      end
    end

    #
    # Hindu Luni-Solar Calendar
    #
    class HinduLuniSolar  < EphemerisBasedLuniSolar

      # Calendar Type
      Formula     = {'M'=>'Formula', 'SS'=>'Hindu?bija=SS', 'SB'=>'Hindu?bija=SB'}
      Location    = {'M'=>'_co:IndianCities::CentralIndia', 'SS'=>'_co:IndianCities::Ujjain', 'SB'=>'_co:IndianCities::Ujjain'}
      CycleOffset = {'M'=>+23.25/30, 'SS'=>0.0, 'SB'=>0.0}
      HinduStyle = {'A'=>0, 'P'=>1, 'PX'=>2}
      YearEpoch   = {'V'=>-58,'VZ'=>-57,'S'=>78, 'SZ'=>79}

      # White / black  month and leap month identification table

                   #[w]/b  [n]/l      #0     #1    #2
      LEAP_MAP  = {[nil,  false] => [ 0,    0,    0  ],
                   [nil,  true ] => [-1.5, -1.5, -1.5],
                   [true, false] => [+0.5, -0.5, -2.5],
                   [true, true ] => [-1,   -2,   -1  ]}

      # protected

      # 月初の通日
      #
      # @param  [Integer] m 通月
      #
      # @return [Integer] 月初の通日
      #
      def _new_month_(m)
        new_moon_time = @formula[-1].cn_to_time(m)
        new_moon_date = (new_moon_time + 0.5 + @formula[-1].long/360.0).floor
        sunrise_time = @formula[-1].sunrise(new_moon_date)
        (sunrise_time >= new_moon_time) ? new_moon_date : new_moon_date+1
      end

      # 年初の通月
      #
      # @param  [Integer] y 年
      #
      # @return [Integer] 年初の通月
      #
      def _new_year_month_(y)
        (Residue.mod(y-1) {|t| _tithi_to_coordinates(t*15)[0]})[0] + 1
      end

      # 朔望日 -> 年・月・日
      #
      # tithi   : 朔望日(月の位相 / (CIRCLE/30))
      #
      # @return [Array<Numeric>] ( y, m, d )
      #   [ y - 年(Integer) ]
      #   [ m - 月(When::Coordinates::Pair) ]
      #   [ d - 日(Integer) ]
      #
      def _tithi_to_coordinates(tithi)
        m, d = tithi.divmod(30)
        s    = [0,1,2].map {|i| (@formula[1].time_to_cn(30*(m+i)) - @cycle_offset).floor + 1 }
        f    = s[0]==s[1]
        if (d >= 15.0)
          d -=  15
          b  = true
          n  = true   unless @hindu_style==0
          f  = s[1]==s[2] if @hindu_style==1
        end
        y, m = (n ? s[1] : s[0]).divmod(12)
        return [y, Pair._force_pair(m+1, LEAP_MAP[[b,f]][@hindu_style]), d.floor]
      end

      # 日時要素の翻訳表の取得
      #
      # @overload _ids_(date)
      #   @param [Array<Numeric>] date ( 年 )
      #   @return [Array<When::Coordinates::Pair>] 1年の月の配置の翻訳表
      #
      # @overload _ids_(date)
      #   @param [Array<Numeric>] date ( 年 月 )
      #   @return [Array<When::Coordinates::Pair>] 1月の日の配置の翻訳表
      #   @note 月は 0 始まりの通番
      #
      def _ids_(date)
        y, m = date
        y    = +y
        mm   = _new_year_month(y)
        return (_table(_new_month_(mm+m.to_i)) {|i| _new_month(mm+m+i/15.0)}) if m
        table = (0...26).to_a.map {|i| _tithi_to_coordinates((mm+i)*15)[1]}
        table.pop while table[-1].trunk < 11
        return table
      end

      private

      # 日時要素の翻訳表の作成
      def _table(b0)
        table = [Pair._force_pair(0,0)]
        (1..16).each do |i|
          b1 = yield(i)
          case b1-b0
          when 0 ; table[-1] = Pair._force_pair(i-1, -2)
          when 1 ; table << Pair._force_pair(i, 0)
          when 2 ; table << Pair._force_pair(i, 0) << Pair._force_pair(i, 1)
          else   ; raise ArgumentError, "Irregal date span: #{b1-b0}"
          end
          b0 =  b1
        end
        table.pop while table[-1].trunk >= 16
        table.shift
        return table
      end

      # オブジェクトの正規化
      #
      #    @formula      = 位相の計算に用いる太陽・変換・月の Formula
      #    @cycle_offset = 位相のオフセット
      #    @hindu_style  = 閏月の表現方法
      #    @start_month  = 暦年の最初の月
      #
      def _normalize(args=[], options={})
        @label ||= When.Resource('_m:IndianTerms::HinduLuniSolar')
        @type  ||= 'SBSA'
        raise ArgumentError, "Irregal formula: #{@formula}" unless @type.upcase =~ /^(M|SS|SB)(V|S|VZ|SZ)(A|P|PX)$/

        @location      ||=  Location[$1]
        @cycle_offset  ||=  CycleOffset[$1]
        @origin_of_MSC ||= -YearEpoch[$2]
        @hindu_style   ||=  HinduStyle[$3]
        @epoch_in_CE   ||=  0
        @start_month   ||=  5 # Chaitra
        @start_month     = @start_month.to_i
        @cycle_offset    = @cycle_offset.to_f + (@start_month - 5)
        @hindu_style     = @hindu_style.to_i
        @origin_of_MSC   = @origin_of_MSC.to_i
        formula  = @formula || Formula[$1]
        if formula.kind_of?(String)
          formula += (formula =~ /\?/) ? '&' : '?'
          @formula = When.Resource(["_ep:#{formula}formula=12S",
                               "_ep:#{formula}formula=30L->12S",
                               "_ep:#{formula}location=(#{@location})&formula=2L"])
        end
        intercalary_month = When.Resource('_m:IndianTerms::IntercalaryMonth::*')
        intercalary_day   = When.Resource('_m:IndianTerms::IntercalaryDay::*')
        @indices        ||= [
          Coordinates::Index.new({:branch=>{-2.5 => intercalary_month[1],  #   黒分
                                            -2   => intercalary_month[3],  # 閏黒分
                                            -1.5 => intercalary_month[2],  # 閏白分
                                            -1   => intercalary_month[3],  # 閏黒分
                                            -0.5 => intercalary_month[1],  #   黒分
                                             0   => intercalary_month[0],  #   白分
                                            +0.5 => intercalary_month[1]}, #   黒分
                                  :trunk=>When.Resource('_m:IndianTerms::LunarMonth::*'),
                                  :shift=>@start_month-1}),
          Coordinates::Index.new({:branch=>{-2=>intercalary_day[0], -1=>intercalary_day[1]}})
        ]

        super
      end
    end
  end

  class CalendarNote
    #
    # ヒンドゥー系の暦注
    #
    class HinduNote < self

      NoteObjects = [When::BasicTypes::M17n, [
        "namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/, hi=http://hi.wikipedia.org/wiki/]",
        "locale:[=en:, ja=ja:, hi=hi:, alias]",
        "names:[Hindu]",

        # 年の暦注 ----------------------------
        [When::BasicTypes::M17n,
          "names:[year]",
          [When::BasicTypes::M17n,
            "names:[samvatsara, 木星年=]",
            "[Prabhava=,      プラバヴァ=,           _IAST_]", #  1
            "[Vibhava=,       ヴィバヴァ=,           _IAST_]", #  2
            "[Sukha=,         スカ=,                 _IAST_]", #  3
            "[Pramoda=,       プラモーダ=,           _IAST_]", #  4
            "[Prajāpati=,     プラジャーパティ=,     _IAST_]", #  5
            "[Aṅgiras=,       アンギラス=,           _IAST_]", #  6
            "[Śrīmukha=,      シュリームカ=,         _IAST_]", #  7
            "[Bhāva=,         バーヴァ=,             _IAST_]", #  8
            "[Yuvan=,         ユヴァン=,             _IAST_]", #  9
            "[Dhātṛ=,         ダートリ=,             _IAST_]", # 10
            "[Īśvara=,        イーシュヴァラ=,       _IAST_]", # 11
            "[Bahudhānya=,    バフダーニャ=,         _IAST_]", # 12
            "[Pramāthin=,     プラマーティン=,       _IAST_]", # 13
            "[Vikrama=,       ヴィクラマ=,           _IAST_]", # 14
            "[Vṛṣa=,          ヴリシャ=,             _IAST_]", # 15
            "[Chitrabhānu=,   チトラバーヌ=,         _IAST_]", # 16
            "[Subhānu=,       スバーヌ=,             _IAST_]", # 17
            "[Tāraṇa=,        ターラナ=,             _IAST_]", # 18
            "[Pārthiva=,      パールティヴァ=,       _IAST_]", # 19
            "[Vyaya=,         ヴヤヤ=,               _IAST_]", # 20
            "[Sarvajit=,      サルヴァジト=,         _IAST_]", # 21
            "[Sarvadhārin=,   サルヴァダーリン=,     _IAST_]", # 22
            "[Virodhin=,      ヴィローディン=,       _IAST_]", # 23
            "[Vikṛta=,        ヴィクリタ=,           _IAST_]", # 24
            "[Khara=,         カラ=,                 _IAST_]", # 25
            "[Nandana=,       ナンダナ=,             _IAST_]", # 26
            "[Vijaya=,        ヴィジャヤ=,           _IAST_]", # 27
            "[Jaya=,          ジャヤ=,               _IAST_]", # 28
            "[Manmatha=,      マンマタ=,             _IAST_]", # 29
            "[Durmukha=,      ドゥルムカ=,           _IAST_]", # 30
            "[Hemalamba=,     ヘマラムバ=,           _IAST_]", # 31
            "[Vilambin=,      ヴィラムビン=,         _IAST_]", # 32
            "[Vikārin=,       ヴィカーリン=,         _IAST_]", # 33
            "[Śārvarin=,      シャールヴァリン=,     _IAST_]", # 34
            "[Plava=,         プラヴァ=,             _IAST_]", # 35
            "[Śubhakṛt=,      シュバクリト=,         _IAST_]", # 36
            "[Śobhana=,       ショバナ=,             _IAST_]", # 37
            "[Krodhin=,       クロディン=,           _IAST_]", # 38
            "[Viśvāvasu=,     ヴィシュヴァーヴァス=, _IAST_]", # 39
            "[Parābhava=,     パラーバヴァ=,         _IAST_]", # 40
            "[Plavaṅga=,      プラヴァンガ=,         _IAST_]", # 41
            "[Kīlaka=,        キーラカ=,             _IAST_]", # 42
            "[Saumya=,        サウムヤ=,             _IAST_]", # 43
            "[Sādhāraṇa=,     サーダーラナ=,         _IAST_]", # 44
            "[Virodhakṛt=,    ヴィローダクリト=,     _IAST_]", # 45
            "[Paridhāvin=,    パリダーヴィン=,       _IAST_]", # 46
            "[Pramādin=,      プラマーディン=,       _IAST_]", # 47
            "[Ānanda=,        アーナンダ=,           _IAST_]", # 48
            "[Rākṣasa=,       ラークシャサ=,         _IAST_]", # 49
            "[Anala=,         アナラ=,               _IAST_]", # 50
            "[Piṅgala=,       ピンガラ=,             _IAST_]", # 51
            "[Kālayukta=,     カーラユクタ=,         _IAST_]", # 52
            "[Siddhārthin=,   シッダールティン=,     _IAST_]", # 53
            "[Raudra=,        ラウドラ=,             _IAST_]", # 54
            "[Durmati=,       ドゥルマティ=,         _IAST_]", # 55
            "[Dundubhi=,      ドゥンドゥビ=,         _IAST_]", # 56
            "[Rudhirodgārin=, ルディロードガーリン=, _IAST_]", # 57
            "[Raktākṣin=,     ラクタークシン=,       _IAST_]", # 58
            "[Krodhana=,      クローダナ=,           _IAST_]", # 59
            "[Kṣaya=,         クシャヤ=,             _IAST_]"  # 60
          ]
        ],

        # 月の暦注 ----------------------------
        [When::BasicTypes::M17n,
          "names:[month]",
          [When::BasicTypes::M17n,
            "names:[Month]"
          ]
        ],

        # 日の暦注 ----------------------------
        [When::BasicTypes::M17n,
          "names:[day]",

          [When::BasicTypes::M17n,
            "names:[tithi=, ティティ=ja:%%<ティティ>]",
            "[Amavasya,                   新月,  _IAST_]", # 新月
            "[Pratipad=en:Prathama_(day), １日=, _IAST_]", #  1
            "[Dwitiya,                    ２日=, _IAST_]", #  2
            "[Tritiya,                    ３日=, _IAST_]", #  3
            "[Chaturthi,                  ４日=, _IAST_]", #  4
            "[Panchami,                   ５日=, _IAST_]", #  5
            "[Ṣaṣṭhī=en:Shashti,          ６日=, _IAST_]", #  6
            "[Saptami,                    ７日=, _IAST_]", #  7
            "[Ashtami,                    ８日=, _IAST_]", #  8
            "[Navami,                     ９日=, _IAST_]", #  9
            "[Dashami,                    10日=, _IAST_]", # 10
            "[Ekadashi,                   11日=, _IAST_]", # 11
            "[Dwadashi,                   12日=, _IAST_]", # 12
            "[Thrayodashi,                13日=, _IAST_]", # 13
            "[Chaturdashi,                14日=, _IAST_]", # 14
            "[Purnima,                    満月,  _IAST_]"  # 満月
          ],

          [When::BasicTypes::M17n,
            "names:[vāra=, ヴァーラ=, _IAST_, *vara=]",
            "[Ravi=en:S%C5%ABrya, 日曜日, _IAST_]",
            "[Soma,               月曜日, _IAST_]",
            "[Maṅgala=en:Mangala, 火曜日, _IAST_]",
            "[Budha,              水曜日, _IAST_]",
            "[Guru,               木曜日, _IAST_]",
            "[Śukra=en:Shukra,    金曜日, _IAST_]",
            "[Śani=en:Shani,      土曜日, _IAST_]" 
          ],

          [When::BasicTypes::M17n,
            "names:[nakṣatra=, ナクシャトラ=, _IAST_, *naksatra=]",
            "[Aśvinī=en:Ashvin%C4%AB,                           アシュヴィニー=,     _IAST_, 婁宿]", #  1
            "[Bharaṇī=en:Bharan%C4%AB,                          バラニー=,           _IAST_, 胃宿]", #  2
            "[Kṛttikā=en:Krittik%C4%81,                         クリッティカー=,     _IAST_, 昴宿]", #  3
            "[Rohiṇī=en:Rohini_(nakshatra),                     ローヒニ―=,         _IAST_, 畢宿]", #  4
            "[Mṛgaśiras=en:Mrigash%C4%ABrsha,                   ムリガシラス=,       _IAST_, 觜宿]", #  5
            "[Ārdrā=en:Ardra_(nakshatra),                       アールドラー=,       _IAST_, 參宿]", #  6
            "[Punarvasu=en:Punarvasu,                           プナルヴァス=,       _IAST_, 井宿]", #  7
            "[Puṣya=en:Pushya,                                  プシュヤ=,           _IAST_, 鬼宿]", #  8
            "[Aśleṣā=en:%C4%80shlesh%C4%81,                     アーシュレーシャー=, _IAST_, 柳宿]", #  9
            "[Maghā=en:Magh%C4%81,                              マガー=,             _IAST_, 星宿]", # 10
            "[P. Phalguṇī=en:P%C5%ABrva_Phalgun%C4%AB,          P. パールグニー=,    _IAST_, 張宿]", # 11
            "[U. Phalguṇī=en:Uttara_Phalgun%C4%AB,              U. パールグニー=,    _IAST_, 翼宿]", # 12
            "[Hasta=en:Nakshatra#Divisions,                     ハスタ=,             _IAST_, 軫宿]", # 13
            "[Citrā=en:Nakshatra#Divisions,                     チトラー=,           _IAST_, 角宿]", # 14
            "[Svāti=en:Sv%C4%81t%C4%AB,                         スヴァーティー=,     _IAST_, 亢宿]", # 15
            "[Viśākha=en:Vish%C4%81kh%C4%81,                    ヴィシャーカー=,     _IAST_, 氐宿]", # 16
            "[Anurādhā=en:Anur%C4%81dh%C4%81,                   アヌラーダー=,       _IAST_, 房宿]", # 17
            "[Jyeṣṭha=en:Jyeshtha,                              ジェーシュター=,     _IAST_, 心宿]", # 18
            "[Mūla=en:Mula_(astrology),                         ムーラ=,             _IAST_, 尾宿]", # 19
            "[P. āṣāḍha=en:P%C5%ABrva_Ash%C4%81dh%C4%81,        P. アーシャーダー=,  _IAST_, 箕宿]", # 20
            "[U. āṣāḍha=en:Uttara_Ash%C4%81dh%C4%81,            U. アーシャーダー=,  _IAST_, 斗宿]", # 21
            "[Śravaṇa=en:Shravana,                              シュラヴァナ=,       _IAST_, 女宿]", # 22
            "[Śraviṣṭhā=en:Dhanishta,                           ダニシュター=,       _IAST_, 虛宿]", # 23
            "[Śatabhiṣak=en:Shatabhish%C4%81,                   シャタビシャジュ=,   _IAST_, 危宿]", # 24
            "[P. Bhādrapadā=en:P%C5%ABrva_Bh%C4%81drapad%C4%81, P. バードラパダー=,  _IAST_, 室宿]", # 25
            "[U. Bhādrapadā=en:Uttara_Bh%C4%81drapad%C4%81,     U. バードラパダー=,  _IAST_, 壁宿]", # 26
            "[Revatī=en:Revati_(nakshatra),                     レーヴァティー=,     _IAST_, 奎宿]"  # 27
          ],

          [When::BasicTypes::M17n,
            "names:[yoga=, ヨーガ=, _IAST_]",
            "[Viṣkambha=, ヴィシュカムバ=,   _IAST_]", #  1
            "[Prīti=,     プリーティ=,       _IAST_]", #  2
            "[Āyuśmān=,   アーユシュマー=,   _IAST_]", #  3
            "[Saubhāgya=, サウバーギャ=,     _IAST_]", #  4
            "[Śobhana=,   ショーバナ=,       _IAST_]", #  5
            "[Atigaṇḍa=,  アティガンダ=,     _IAST_]", #  6
            "[Sukarma=,   スカルマ=,         _IAST_]", #  7
            "[Dhṛti,      ドゥリティ=,       _IAST_]", #  8
            "[Śūla=,      シューラ=,         _IAST_]", #  9
            "[Gaṇḍa=,     ガンダ=,           _IAST_]", # 10
            "[Vṛddhi=,    ヴリッディ=,       _IAST_]", # 11
            "[Dhruva=,    ドルヴァ=,         _IAST_]", # 12
            "[Vyāghāta=,  ヴヤーガータ=,     _IAST_]", # 13
            "[Harṣaṇa=,   ハルシャナ=,       _IAST_]", # 14
            "[Vajra=,     ヴァジュラ=,       _IAST_]", # 15
            "[Siddhi=,    シッディ=,         _IAST_]", # 16
            "[Vyatīpāta=, ヴヤティーパータ=, _IAST_]", # 17
            "[Varīyas=,   ヴァリーヤス=,     _IAST_]", # 18
            "[Parigha=,   パリガ=,           _IAST_]", # 19
            "[Śiva=,      シヴァ=,           _IAST_]", # 20
            "[Siddha=,    シッダ=,           _IAST_]", # 21
            "[Sādhya=,    サーディヤ=,       _IAST_]", # 22
            "[Śubha=,     シュバ=,           _IAST_]", # 23
            "[Śukla=,     シュクラ=,         _IAST_]", # 24
            "[Brahman=,   ブラフマン=,       _IAST_]", # 25
            "[Māhendra=,  マーヘンドラ=,     _IAST_]", # 26
            "[Vaidhṛti=,  ヴァイドリティ=,   _IAST_]"  # 27
          ],

          [When::BasicTypes::M17n,
            "names:[Karaṇa=, カラナ=, _IAST_, *karana]",
            "[Bava=,      バヴァ=,           _IAST_]", # 1
            "[Bālava=,    バーラヴァ=,       _IAST_]", # 2
            "[Kaulava=,   カウラヴァ=,       _IAST_]", # 3
            "[Taitila=,   タイティラ=,       _IAST_]", # 4
            "[Gara=,      ガラ=,             _IAST_]", # 5
            "[Vaṇija=,    ヴァニジュ=,       _IAST_]", # 6
            "[Viṣṭi=,     ヴィシュティ=,     _IAST_]", # 7
            "[Kiṃtughna=, キンストゥグナ=,   _IAST_]", # A
            "[Śakuni=,    シャクニ=,         _IAST_]", # B
            "[Catuṣpāda=, チャトシュパダ=,   _IAST_]", # C
            "[Nāga=,      ナーガ=,           _IAST_]"  # D
          ]
        ]
      ]]

      NoteConsts = {
        'tithi' => {
          :formula => 15,
          :range   => (-1..2),
          :index   => [ 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,
                       15,1,2,3,4,5,6,7,8,9,10,11,12,13,14]
        },
        'naksatra' => {
          :formula => '27M',
          :range   => (-1..2),
          :index   => (0...27).to_a
        },
        'yoga' => {
          :formula => '27M+27S',
          :range   => (-1..2),
          :index   => (0...27).to_a
        },
        'karana' => {
          :formula => 30,
          :range   => (-2..3),
          :index   => [7] + (0...7).to_a * 8 + [8,9,10]
        }
      }

      #
      # pancanga 計算に必要となる情報をまとめた内部クラス
      #
      class Dates

        # @private
        attr_reader :o_date, :l_date, :root, :formula, :iri, :rises

        # 初期設定
        # @private
        def initialize(date)
          @o_date  = date
          clock    = date.clock
          frame    = date.frame if date.frame.kind_of?(When::CalendarTypes::HinduLuniSolar)
          @l_date  = (frame || When.Calendar('HinduLuniSolar?note=HinduNote')).jul_trans(date.to_i, {:clock=>'+05:30'})
          @root    = When.CalendarNote('HinduNote/NoteObjects')['day']
          @formula = @l_date.frame.formula[-1]
          @iri     = @formula.iri
          @rises   = [@formula.sunrise(@l_date), @formula.sunrise(@l_date+When.Duration('P1D'))]
        end

        # その他のメソッドは @l_date に移譲する
        def method_missing(name, *args, &block)
          self.class.module_eval %Q{
            def #{name}(*args, &block)
              @l_date.send("#{name}", *args, &block)
            end
          } unless When::Parts::MethodCash.escape(name)
          @l_date.send(name, *args, &block)
        end
      end

      #
      # 任意の暦をインド太陰太陽暦日に変換
      # @private
      def _to_date_for_note(date)
        Dates.new(date)
      end

      #
      # 木星年
      #
      # @param [Dates] dates
      #
      # @return [When::BasicTypes::M17n] 木星年の名称
      #
      # see {http://en.wikipedia.org/wiki/Samvatsara Samvatsara}
      #
      def samvatsara(dates)
        year_kali = dates.l_date.most_significant_coordinate + dates.l_date.frame._diff_to_CE + 3101
        year_mod  = year_kali >= jovian ? (year_kali + 12) % 60 :
                                         ((year_kali * 211 - 108).div(18000) + year_kali + 26) % 60
        When.CalendarNote('HinduNote/NoteObjects')['year']['samvatsara'][year_mod]
      end

      #
      # 木星年の計算方式に“South”を適用開始する年
      #
      # @return [Integer] 年(カリユガ紀元)
      #
      def jovian
        return @jovian if @jovian.kind_of?(Integer)
        @jovian = @jovian ? @jovian.to_i : 4009
      end

      #
      # ヴァーラ (七曜)
      #
      # @param [Dates] dates
      #
      # @return [Array<When::TM::TemporalPosition>] 日の出の時刻をイベント時刻とする
      #
      def vara(dates)
        rise        =  dates.rises[0]
        rise.events = [dates.root['vara'][(rise.to_i+1) % 7]]
        ['V:-', rise]
      end

      #
      # ヴァーラ以外
      #

      # 当該日付中でティティが変わる日時
      # @method tithi(dates)
      #   @param [Dates] dates
      #   @return [Array<When::TM::TemporalPosition>] イベント日時

      # 当該日付中でナクシャトラが変わる日時
      # @method naksatra(dates)
      #   @param [Dates] dates
      #   @return [Array<When::TM::TemporalPosition>] イベント日時

      # 当該日付中でヨーガが変わる日時
      # @method yoga(dates)
      #   @param [Dates] dates
      #   @return [Array<When::TM::TemporalPosition>] イベント日時

      # 当該日付中でカラナが変わる日時
      # @method karana(dates)
      #   @param [Dates] dates
      #   @return [Array<When::TM::TemporalPosition>] イベント日時
      #

      # @private
      NoteConsts.keys.each do |key|
        module_eval %Q{
          def #{key}(dates)
            pancanga(dates, '#{key}').map {|event| ['#{key[0..0].upcase}:-', event]}
          end
        }
      end

      #
      # ヴァーラ以外のイベント日時
      #
      # @param [Dates] dates
      # @param [String] key 'tithi', 'naksatra', 'yoga', 'karana' のいずれか
      # @return [Array<When::TM::TemporalPosition>] イベント日時
      #
      def pancanga(dates, key)
        pattern = NoteConsts[key]
        note    = dates.root[key]
        if pattern[:formula].kind_of?(Numeric)
          factor  = pattern[:formula].to_f
          formula = dates.formula
        else
          factor  = 1.0
          formula = When.Resource(dates.iri.sub(/formula=2L/, "formula=#{pattern[:formula]}"))
        end
        cn      = (formula.time_to_cn(dates.l_date) * factor).floor
        events  = []
        pattern[:range].each do |i|
          event = formula._to_seed_type(formula.cn_to_time((cn+i)/factor), dates.l_date)
          break if +event >= +dates.rises[1]
          next  if +event <  +dates.rises[0]
          event.events = [note[pattern[:index][(cn+i) % pattern[:index].length]]]
          events << event
        end
        events
      end
    end

    #
    # 日の出の九惑星の位置まで計算
    #
    class HinduNoteDetailed < HinduNote
      #
      # ヴァーラ (七曜)と九惑星の位置
      #
      # @param [Dates] dates
      # @return [Array<When::TM::TemporalPosition, Hash{ 惑星シンボル=>惑星の真黄経 }>]
      #   日の出の時刻をイベント時刻とし、その時刻での九惑星の位置を計算
      #
      def vara(dates)
        rise        =  dates.rises[0]
        rise.events = [dates.root['vara'][(rise.to_i+1) % 7]]
        t           = dates.formula.is_dynamical ? +rise : rise.to_f
        [['V:-', rise], dates.formula.graha.keys.inject({}) {|h,p|
          h.store(p, dates.formula.graha[p].true_longitude(t))
          h
        }]
      end
    end
  end
end
