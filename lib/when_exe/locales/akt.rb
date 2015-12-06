# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014-2015 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

require 'when_exe/locales/transliteration_table'

module When
  module Locale

    #
    # AKT: Alphabet of Katakana Transliteration
    #
    # see { http://www.asahi-net.or.jp/~dy5h-kdm/end2.htm MadKod}
    #
    AKT = {
      'ja' => {
        "a"  =>"ア",   "i"  =>"イ",   "u"  =>"ウ",   "e"  =>"エ",   "o"  =>"オ",
        "ka" =>"カ",   "ki" =>"キ",   "ku" =>"ク",   "ke" =>"ケ",   "ko" =>"コ",   "k" =>"ク",
        "qa" =>"カ",   "qi" =>"キ",   "qu" =>"ク",   "qe" =>"ケ",   "qo" =>"コ",   "q" =>"ク",
        "ga" =>"ガ",   "gi" =>"ギ",   "gu" =>"グ",   "ge" =>"ゲ",   "go" =>"ゴ",   "g" =>"グ",
        "sa" =>"サ",   "si" =>"シ",   "su" =>"ス",   "se" =>"セ",   "so" =>"ソ",   "s" =>"ス",
        "za" =>"ザ",   "zi" =>"ヂ",   "zu" =>"ズ",   "ze" =>"ゼ",   "zo" =>"ゾ",   "z" =>"ズ",
        "ja" =>"ジャ", "ji" =>"ジ",   "ju" =>"ジュ", "je" =>"ジェ", "jo" =>"ジョ", "j" =>"ジュ",
        "ca" =>"カ",   "ci" =>"チ",   "cu" =>"ク",   "ce" =>"セ",   "co" =>"コ",   "c" =>"ク",
        "ta" =>"タ",   "ti" =>"ティ", "tu" =>"トゥ", "te" =>"テ",   "to" =>"ト",   "t" =>"ト",
        "tsa"=>"ツァ", "tsi"=>"ツィ", "tsu"=>"ツ",   "tse"=>"ツェ", "tso"=>"ツォ", "ts"=>"ツ",
        "da" =>"ダ",   "di" =>"ディ", "du" =>"ドゥ", "de" =>"デ",   "do" =>"ド",   "d" =>"ド",
        "na" =>"ナ",   "ni" =>"ニ",   "nu" =>"ヌ",   "ne" =>"ネ",   "no" =>"ノ",   "n" =>"ン",
        "ha" =>"ハ",   "hi" =>"ヒ",   "hu" =>"フ",   "he" =>"ヘ",   "ho" =>"ホ",   "h" =>"フ",
        "ba" =>"バ",   "bi" =>"ビ",   "bu" =>"ブ",   "be" =>"ベ",   "bo" =>"ボ",   "b" =>"ブ",
        "pa" =>"パ",   "pi" =>"ピ",   "pu" =>"プ",   "pe" =>"ペ",   "po" =>"ポ",   "p" =>"プ",
        "fa" =>"ファ", "fi" =>"フィ", "fu" =>"フ",   "fe" =>"フェ", "fo" =>"フォ", "f" =>"フ",
        "va" =>"ヴァ", "vi" =>"ヴィ", "vu" =>"ヴ",   "ve" =>"ヴェ", "vo" =>"ヴォ", "v" =>"ヴ",
        "ma" =>"マ",   "mi" =>"ミ",   "mu" =>"ム",   "me" =>"メ",   "mo" =>"モ",   "m" =>"ム",
        "mma"=>"ンマ", "mmi"=>"ンミ", "mmu"=>"ンム", "mme"=>"ンメ", "mmo"=>"ンモ",
        "ra" =>"ラ",   "ri" =>"リ",   "ru" =>"ル",   "re" =>"レ",   "ro" =>"ロ",   "r" =>"ル",
        "la" =>"ラ",   "li" =>"リ",   "lu" =>"ル",   "le" =>"レ",   "lo" =>"ロ",   "l" =>"ル",
        "wa" =>"ワ",   "wi" =>"ウィ", "wu" =>"ゥ",   "we" =>"ウェ", "wo" =>"ヲ",   "w" =>"ゥ",
        "wwa"=>"ウヮ", "wwi"=>"ウィ", "wwu"=>"ウゥ", "wwe"=>"ウェ", "wwo"=>"ウォ",
        "xa" =>"ァ",   "xi" =>"ィ",   "xu" =>"ゥ",   "xe" =>"ェ",   "xo" =>"ォ",   "x" =>"クス",
        "ya" =>"ヤ",   "yu" =>"ユ",   "yo" =>"ヨ",   "y"  =>"イ",
        "kya"=>"キャ", "kyu"=>"キュ", "kyo"=>"キョ",
        "kja"=>"キャ", "kvu"=>"キュ", "kjo"=>"キョ",
        "qja"=>"キャ", "qju"=>"キュ", "qjo"=>"キョ",
        "gya"=>"ギャ", "gyu"=>"ギュ", "gyo"=>"ギョ",
        "gja"=>"ギャ", "gju"=>"ギュ", "gjo"=>"ギョ",
        "sya"=>"シャ", "syu"=>"シュ", "syo"=>"ショ",
        "sja"=>"シャ", "sju"=>"シュ", "sjo"=>"ショ",
        "zya"=>"ジャ", "zyu"=>"ジュ", "zyo"=>"ジョ",
        "zja"=>"ヂャ", "zju"=>"ヂュ", "zjo"=>"ヂョ",
        "jya"=>"ジャ", "jyu"=>"ジュ", "jye"=>"ジェ", "jyo"=>"ジョ",
        "cyi"=>"チィ", "cyu"=>"チュ", "tyi"=>"ティ",
        "tyu"=>"テュ", "tye"=>"テェ", "tja"=>"チャ",
        "tju"=>"チュ", "tjo"=>"チョ", "-"  =>"ー",   "tsx"=>"ッ",
        "dyi"=>"ディ", "dyu"=>"デュ", "dye"=>"デェ",
        "dja"=>"ヂャ", "dju"=>"ヂュ", "djo"=>"ヂョ",
        "nya"=>"ニャ", "nyu"=>"ニュ", "nyo"=>"ニョ",
        "nva"=>"ニャ", "nvu"=>"ニュ", "nvo"=>"ニョ",
        "hya"=>"ヒャ", "hyu"=>"ヒュ", "hyo"=>"ヒョ",
        "bya"=>"ビャ", "byu"=>"ビュ", "byo"=>"ビョ",
        "pya"=>"ピャ", "pyu"=>"ピュ", "pyo"=>"ピョ",
        "fyu"=>"フュ", "vyu"=>"ヴュ",
        "mya"=>"ミャ", "myu"=>"ミュ", "myo"=>"ミョ",
        "mva"=>"ミャ", "mvu"=>"ミュ", "mvo"=>"ミョ",
        "rya"=>"リャ", "ryu"=>"リュ", "ryo"=>"リョ",
        "lya"=>"リャ", "lyu"=>"リュ", "lyo"=>"リョ",
        "wyi"=>"ウイ", "wyu"=>"ウユ", "wye"=>"ウエ",
        "xya"=>"ャ",   "xyu"=>"ュ",   "xyo"=>"ョ",
        "yya"=>"イャ", "yyi"=>"イィ", "yyu"=>"イュ", "yye"=>"イェ", "yyo"=>"イョ",
        "kwa"=>"クヮ", "kwi"=>"クィ", "kwu"=>"クゥ", "kwe"=>"クェ", "kwo"=>"クォ",
        "kha"=>"クァ", "khi"=>"クィ", "khu"=>"クゥ", "khe"=>"クェ", "kho"=>"クォ",
        "qha"=>"クァ", "qhi"=>"クィ", "qhu"=>"クゥ", "qhe"=>"クェ", "qho"=>"クォ",
        "gwa"=>"グヮ", "gwi"=>"グィ", "gwu"=>"グゥ", "gwe"=>"グェ", "gwo"=>"グォ",
        "gha"=>"グァ", "ghi"=>"グィ", "ghu"=>"グゥ", "ghe"=>"グェ", "gho"=>"グォ",
        "sha"=>"シャ", "shi"=>"シ",   "shu"=>"シュ", "she"=>"シェ", "sho"=>"ショ", "sh"=>"シュ",
        "swa"=>"スワ", "swi"=>"スィ", "swu"=>"スゥ", "swe"=>"スェ", "swo"=>"スヲ",
        "zha"=>"ツァ", "zhi"=>"ツィ", "zhu"=>"ズゥ", "zhe"=>"ツェ", "zho"=>"ツォ",
        "zxa"=>"ツァ", "zxi"=>"ツィ", "zxu"=>"ズゥ", "zxe"=>"ツェ", "zxo"=>"ツォ",
        "jxa"=>"ジァ", "jxi"=>"ジィ", "jxu"=>"ジゥ", "jxe"=>"ジェ", "jxo"=>"ジォ",
        "cha"=>"チャ", "chi"=>"チ",   "chu"=>"チュ", "che"=>"チェ", "cho"=>"チョ",
        "twa"=>"トワ", "twi"=>"ツイ", "twu"=>"トゥ", "twe"=>"ツエ", "two"=>"ツー",
        "tha"=>"スァ", "thi"=>"スィ", "thu"=>"スゥ", "the"=>"スェ", "tho"=>"スォ",
        "tza"=>"ツァ", "tzi"=>"ツィ", "tzu"=>"ズー", "tze"=>"ツェ", "tzo"=>"ツォ",
        "dwa"=>"ドワ", "dwi"=>"ドィ", "dwu"=>"ドゥ", "dwe"=>"ドェ", "dwo"=>"ドヲ",
        "dha"=>"ダー", "dhi"=>"ジー", "dhu"=>"ドフ", "dhe"=>"ドヘ", "dho"=>"ドホ",
        "dsa"=>"ドサ", "dsi"=>"ドシ", "dsu"=>"ズ",   "dse"=>"ドセ", "dso"=>"ドソ",
        "nxa"=>"ニァ", "nxi"=>"ニィ", "nxu"=>"ニゥ", "nxe"=>"ニェ", "nxo"=>"ニォ",
        "hwa"=>"ホヮ", "hwi"=>"ホィ", "hwu"=>"ホゥ", "hwe"=>"ホェ", "hwo"=>"ホォ",
        "bha"=>"バー", "bhi"=>"ビー", "bhu"=>"ブー", "bhe"=>"ベー", "bho"=>"ボー",
        "pwa"=>"プヮ", "pwi"=>"プィ", "pwu"=>"プゥ", "pwe"=>"プェ", "pwo"=>"プォ",
        "pha"=>"ファ", "phi"=>"フィ", "phu"=>"フュ", "phe"=>"フェ", "pho"=>"フォ",
        "vha"=>"ヒャ", "vhi"=>"ヒィ", "vhu"=>"ヒュ", "vhe"=>"ヒェ", "vho"=>"ヒョ",
        "mha"=>"ムァ", "mhi"=>"ムィ", "mhu"=>"ムゥ", "mhe"=>"ムェ", "mho"=>"ムォ",
        "mwa"=>"ムヮ", "mwi"=>"ムィ", "mwu"=>"ムゥ", "mwe"=>"ムェ", "mwo"=>"ムォ",
        "rja"=>"リャ", "rji"=>"リィ", "rju"=>"リュ", "rje"=>"リェ", "rjo"=>"リョ",
        "lja"=>"リャ", "lji"=>"リィ", "lju"=>"リュ", "lje"=>"リェ", "ljo"=>"リョ",
        "wha"=>"ホワ", "whi"=>"ホイ", "whu"=>"ホウ", "whe"=>"ホエ", "who"=>"ホオ",
        "wxa"=>"ヮ",   "wxi"=>"ヰ",   "wxu"=>"ゥ",   "wxe"=>"ヱ",   "wxo"=>"ウォ",
        "xwa"=>"ヮ",   "xwi"=>"ヰ",   "xwu"=>"ゥ",   "xwe"=>"ヱ",   "xwo"=>"ウォ"
      }
    }

    # @private
    IAST_K = {
      "Ā"  => "A-",     "ā"  => "a-",
      "Ī"  => "I-",     "ī"  => "i-",
      "Ū"  => "U-",     "ū"  => "u-",
      "E"  => "e-",     "e"  => "e-",
      "Ē"  => "e-",     "ē"  => "e-",
      "O"  => "O-",     "o"  => "o-",
      "Ō"  => "O-",     "ō"  => "o-",
      "Ṛ"  => "R:",      "ṛ"  => "r:",
      "Ṝ"  => "R:-",      "ṝ"  => "r:-",
      "R̥"  => "R:",      "r̥"  => "r:",
      "R̥̄"  => "R:-",      "r̥̄"  => "r:-",
      "Ḷ"  => "L:",      "ḷ"  => "l:",
      "Ḹ"  => "L:",      "ḹ"  => "l:",
      "Ṃ"  => "M:",      "ṃ"  => "m:",
      "Ṁ"  => "M:",      "ṁ"  => "m:",
      "Ḥ"  => "H:",      "ḥ"  => "h:",
      "C"  => "Ch",     "c"  => "ch",
      "Ṭ"  => "T",      "ṭ"  => "t",
      "Kh" => "K",      "kh" => "k",
      "Ch" => "Ch",     "ch" => "ch",
      "Ṭh" => "T",      "ṭh" => "t",
      "Th" => "T",      "th" => "t",
      "Ph" => "P",      "ph" => "p",
      "Ḍ"  => "D",      "ḍ"  => "d",
      "Gh" => "G",      "gh" => "g",
      "Jh" => "J",      "jh" => "j",
      "Ḍh" => "D",      "ḍh" => "d",
      "Dh" => "D",      "dh" => "d",
      "Bh" => "B",      "bh" => "b",
      "Ṅ"  => "N",      "ṅ"  => "n",
      "Ñ"  => "Ny",     "ñ"  => "ny",
      "Ṇ"  => "N",      "ṇ"  => "n",
      "Ś"  => "Sh",     "ś"  => "sh",
      "Ṣ"  => "Sh",     "ṣ"  => "sh"
    }

    # @private
    AKT_keys    = transliteration_keys_hash(AKT)

    # @private
    IAST_K_keys = transliteration_keys(IAST_K)

    # @private
    NumAlter1 = [['〇','零'], [/[壱壹]/,'一'], [/[弐貳]/,'二'], [/[弎参參]/,'三'], ['肆','四'],
                 ['伍','五'], ['陸','六'], ['柒','七'], ['捌','八'], ['玖','九'], ['拾','十'],
                 ['廿', '二十'], [/[卅丗]/, '三十'], ['卌', '四十'],
                 ['佰', '百'], ['仟', '千'], ['萬', '万'], ['秭', '𥝱']]

    # @private
    NumAlter2 = [['零〇','０'], ['一壱壹','１'], ['二弐貳','２'], ['三弎参參','３'], ['四肆','４'],
                 ['五伍','５'], ['六陸','６'], ['七柒','７'], ['八捌','８'], ['九玖','９']]

    # @private
    Numbers  = %w(零 一 二 三 四 五 六 七 八 九 十 百 千 万 億 兆 京 垓 𥝱
                  穣 溝 澗 正 載 極 恒河沙 阿僧祇 那由他 不可思議 無量大数)

    # @private
    NumRExp1 = /#{Numbers[10..12].reverse.map {|num| "(?:(.*)#{num})"}.join('?')}?(.*)/

    # public
    NumRExp3 = /([#{Numbers[0..12].join('')}廿卅丗卌]+)/

    # @private
    NumRExp4 = /#{Numbers[13..-1].reverse.map {|num| "(?:(.*)#{num})"}.join('?')}?(.*)/

    # @private
    NumMap   = Hash[*(Numbers[0..9].zip((0..9).to_a)).flatten]

    # @private
    DigitMap = [1,1,1,0]

    #
    # Convert AKT string to katakana scripts
    #
    def self.akt(string, locale='ja')
      string.downcase.
        gsub(/([^aeiou])\1/, 'ッ\1').
        gsub(/m([fpb])/, 'n\1').
        gsub(AKT_keys[locale]) {|code|
        AKT[locale][code] || code
      }
    end

    #
    # Convert IAST string to katakana scripts
    #
    def self.iast_akt(string, locale='ja')
      akt(
        string.gsub(IAST_K_keys) {|code| IAST_K[code] || code}.
        downcase.gsub(/(.):-?(.)|(.):-?\z/) {|code|
          "aeiou".index($2||':') ? $1 + $2   :
                         $1=='m' ? "ン#{$2}" :
                                   code.sub(':','i')
        }.
        gsub(/([rm])y/, '\1uy'),
        locale)
    end
 
    #
    # Convert kanji scripts to numeric
    #
    def self.k2a_digits(figures, force_alter=false)
      if force_alter
        figures = figures.dup
        NumAlter1.each {|alter| figures.gsub!(*alter)}
      end
      sum = 0
      NumRExp4 =~ figures
      $~.to_a[1..-1].each do |wide_match|
        if NumRExp1 =~ wide_match
          $~.to_a[1..-1].each_with_index do |match,digit|
            sum *= 10
            sum += (NumMap[match] || DigitMap[digit]) if match
          end
        else
          sum *= 10000
        end
      end
      sum
    end

    #
    # Convert zenkaku figures to numeric
    #
    def self.z2h_digits(figures, force_alter=false)
      if force_alter
        figures = figures.dup
        NumAlter2.each {|alter| figures.tr!(*alter)}
      end
      figures.tr('０１２３４５６７８９', '0123456789').to_i
    end
  end
end
