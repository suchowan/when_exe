# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  module Parts::Locale

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
        "ta" =>"タ",   "ti" =>"ティ", "tu" =>"ト",   "te" =>"テ",   "to" =>"ト",   "t" =>"ト",
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
    AKT_keys = Hash[*(AKT.keys.map {|locale|
      [locale, Regexp.new((AKT[locale].keys.sort_by {|key| -key.length} + ['%.*?[A-Za-z]']).join('|'))]
    }).flatten]

    #
    # Convert AKT string to indic scripts
    #
    # @private
    def self.akt(string, locale='ja')
      string.downcase.gsub(/(.)\1/) { |code|
        "aeiou".index($1) ? code : 'ッ' + $1
      }.gsub(AKT_keys[locale]) {|code|
        AKT[locale][code] || code
      }
    end
  end

  class BasicTypes::M17n

    JapaneseTerms = [self, [
      "namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/]",
      "locale:[=en:, ja=ja:, alias]",
      "names:[JapaneseTerms=]",

      [self,
        "names:[Month, 月=ja:%%<月_(暦)>]",
        "[1st Month=,  *睦月   ]",
        "[2nd Month=,  *如月   ]",
        "[3rd Month=,  *弥生   ]",
        "[4th Month=,  *卯月   ]",
        "[5th Month=,  *皐月   ]",
        "[6th Month=,  *水無月 ]",
        "[7th Month=,  *文月   ]",
        "[8th Month=,  *葉月   ]",
        "[9th Month=,  *長月   ]",
        "[10th Month=, *神無月 ]",
        "[11th Month=, *霜月   ]",
        "[12th Month=, *師走   ]"
      ],

      [self,
        "names:[Rokuyo=, *六曜]",
        "[Taian=,      *大安  ]",
        "[Shakko=,     *赤口  ]",
        "[Sensho=,     *先勝  ]",
        "[Tomobiki=,   *友引  ]",
        "[Senbu=,      *先負  ]",
        "[Butsumetsu=, *仏滅  ]"
      ],

      [self,
        "names:[The_Tale_of_Genji, *源氏物語]",
        "[Kiritsubo=,        *桐壺]",
        "[Hahakigi=,         *帚木=ja:%%<帚木_(源氏物語)>]",
        "[Utsusemi=,         *空蝉=ja:%%<空蝉_(源氏物語)>]",
        "[Yūgao=,            *夕顔=ja:%%<夕顔_(源氏物語)>]",
        "[Wakamurasaki=,     *若紫]",
        "[Suetsumuhana,      *末摘花=ja:%%<末摘花_(源氏物語)>]",
        "[Momiji no Ga=,     *紅葉賀]",
        "[Hana no En=,       *花宴]",
        "[Aoi=,              *葵=ja:%%<葵_(源氏物語)>]",
        "[Sakaki=,           *賢木]",
        "[Hana Chiru Sato=,  *花散里]",
        "[Suma=,             *須磨=ja:%%<須磨_(源氏物語)>]",
        "[Akashi=,           *明石=ja:%%<明石_(源氏物語)>]",
        "[Miotsukushi=,      *澪標=ja:%%<澪標_(源氏物語)>]",
        "[Yomogiu=,          *蓬生]",
        "[Sekiya=,           *関屋=ja:%%<関屋_(源氏物語)>]",
        "[E Awase=,          *絵合]",
        "[Matsukaze=,        *松風=ja:%%<松風_(源氏物語)>]",
        "[Usugumo=,          *薄雲]",
        "[Asagao=,           *朝顔=ja:%%<朝顔_(源氏物語)>]",
        "[Otome=,            *少女=ja:%%<少女_(源氏物語)>]",
        "[Tamakazura=,       *玉鬘=ja:%%<玉鬘_(源氏物語)>]",
        "[Hatsune=,          *初音=ja:%%<初音_(源氏物語)>]",
        "[Kochō=,            *胡蝶=ja:%%<胡蝶_(源氏物語)>]",
        "[Hotaru=,           *蛍=ja:%%<蛍_(源氏物語)>]",
        "[Tokonatsu=,        *常夏]",
        "[Kagaribi=,         *篝火]",
        "[Nowaki=,           *野分=ja:%%<野分_(源氏物語)>]",
        "[Miyuki=,           *行幸=ja:%%<行幸_(源氏物語)>]",
        "[Fujibakama=,       *藤袴]",
        "[Makibashira=,      *真木柱]",
        "[Mume ga E=,        *梅枝]",
        "[Fuji no Uraba=,    *藤裏葉]",
        "[Wakana=,           *若菜=ja:%%<若菜_(源氏物語)>]",
        "[Kashiwagi=,        *柏木=ja:%%<柏木_(源氏物語)>]",
        "[Yokobue=,          *横笛=ja:%%<横笛_(源氏物語)>]",
        "[Suzumushi=,        *鈴虫]",
        "[Yūgiri=,           *夕霧=ja:%%<夕霧_(源氏物語)>]",
        "[Minori=,           *御法]",
        "[Maboroshi=,        *幻=ja:%%<幻_(源氏物語)>]",
        "[Niō Miya=,         *匂宮]",
        "[Kōbai=,            *紅梅=ja:%%<紅梅_(源氏物語)>]",
        "[Takekawa=,         *竹河]",
        "[Hashihime=,        *橋姫=ja:%%<橋姫_(源氏物語)>]",
        "[Shī ga Moto=,      *椎本]",
        "[Agemaki=,          *総角=ja:%%<総角_(源氏物語)>]",
        "[Sawarabi=,         *早蕨]",
        "[Yadorigi=,         *宿木]",
        "[Azumaya=,          *東屋]",
        "[Ukifune,           *浮舟=ja:%%<浮舟_(源氏物語)>]",
        "[Kagerō=,           *蜻蛉=ja:%%<蜻蛉_(源氏物語)>]",
        "[Tenarai=,          *手習]",
        "[Yume no Ukihashi=, *夢浮橋]"
      ]
    ]]
  end

  module CalendarTypes

    #
    # 日本の朔閏表
    #
    Japanese = [PatternTableBasedLuniSolar, {
      'origin_of_MSC'=>454, 'origin_of_LSC'=>1886926,
      'indices'=> [
           Coordinates::Index.new({:branch=>{1=>When.Resource('_m:CalendarTerms::閏')},
                                   :trunk=>When.Resource('_m:JapaneseTerms::Month::*')}),
           Coordinates::DefaultDayIndex
       ],
      'note'      => 'JapaneseNote',
      'rule_table'=> %w(
							aBcDeFgHiJkL	aBCdEfGhIjKl
	AbCcDeFGhIjKl	AbCdEfGhIjKL	aBcDeFgHiJkLl	AbCDeFgHiJkL	aBcDeFGhIjKl
	AbCdEfGhIiJKl	AbCdEfGhIjKl	AbCDeFgHiJkL	aBcDeEFgHiJkL	aBcDeFgHiJKl
	AbCdEfGhIjKl	AaBCdEfGhIjKl	AbCdEFgHiJkL	aBcDeFgHiJKkL	aBcDeFgHiJkL
	aBCdEfGhIjKl	AbCdEFgGhIjKl	AbCdEfGhIJkL	aBcDeFgHiJkL	aBCcDeFgHiJkL
	aBcDEfGhIjKl	AbCdEfGhIJkLl	AbCdEfGhIjKl	ABcDeFgHiJkL	aBcDEfGhIiJkL
	aBcDeFgHIjKl	AbCdEfGhIjKl	ABcDeEfGhIjKl	AbCDeFgHiJkL	aBcDeFgHIjKl
	AaBcDeFgHiJkL	AbCdEfGhIjKl	AbCDeFgHiJjKl	AbCdEfGHiJkL	aBcDeFgHiJkL
	AbCdEfGgHiJkL	aBCdEfGhIjKl	AbCdEfGHiJkL	aBcDdEfGhIjKL	aBcDeFgHiJkL
	aBCdEfGhIjKlL	aBcDeFGhIjKl	AbCdEfGhIjKL	aBcDeFgHhIjKl	ABcDeFgHiJkL

	aBcDeFGhIjKl	AbCdEeFgHiJKl	AbCdEfGhIjKl	ABcDeFgHiJkL	aBbCdEFgHiJkL
	aBcDeFgHiJKl	AbCdEfGhIjJkL	AbCdEfGhIjKl	AbCdEFgHiJkL	aBcDeFfGhIJkL
	aBcDeFgHiJkL	AbCdEfGhIjKl	AbCcDEfGhIjKl	AbCdEfGhIJkL	aBcDeFgHiJkLL
	aBcDeFgHiJkL	aBcDEfGhIjKl	AbCdEfGhIIjKl	AbCdEfGhIjKl	ABcDeFgHiJkL
	aBcDEeFgHiJkL	aBcDeFgHIjKl	AbCdEfGhIjKl	ABbCdEfGhIjKl	AbCDeFgHiJkL
	aBcDeFgHIjKkL	aBcDeFgHiJkL	AbCdEfGhIjKl	AbCDeFgGhIjKl	AbCdEfGHiJkL
	aBcDeFgHiJkL	AbCcDeFgHiJkL	aBCdEfGhIjKl	AbCdEfGHiJkLl	AbCdEfGhIjKL
	aBcDeFgHiJkL	aBCdEfGhIiJkL	aBcDeFGhIjKl	AbCdEfGhIjKL	aBcDeEfGhIjKl
	ABcDeFgHiJkL	aBcDeFGhIjKl	AaBcDeFgHiJKl	AbCdEfGhIjKl	ABcDeFgHiJjKl
	AbCdEFgHiJkL	aBcDeFgHiJKl	AbCdEfGgHiJkL	AbCdEfGhIjKl	AbCdEFgHiJkL

	aBcDdEfGhIJkL	aBcDeFgHiJkL	AbCdEfGhIjKlL	aBcDEfGhIjKl	AbCdEfGhIJkL
	aBcDeFgHhIjKL	aBcDeFgHiJkL	aBcDEfGhIjKl	AbCdEeFgHIjKl	AbCdEfGhIjKL
	aBcDeFgHiJkL	aBbCDeFgHiJkL	aBcDeFgHIjKl	AbCdEfGhIjJKl	AbCdEfGhIjKl
	AbCDeFgHiJkL	aBcDeFfGHiJkL	aBcDeFgHiJKl	AbCdEfGhIjKl	AbCDdEfGhIjKl
	AbCdEfGHiJkL	aBcDeFgHiJKlL	aBcDeFgHiJkL	aBCdEfGhIjKl	AbCdEfGHhIjKl
	AbCdEfGhIJkL	aBcDeFgHiJkL	aBCdEeFgHiJkL	aBcDeFGhIjKl	AbCdEfGhIjKL
	aBbCdEfGhIjKl	ABcDeFgHiJkL	aBcDeFGhIjKkL	aBcDeFgHiJKl	AbCdEfGhIjKl
	ABcDeFgGhIjKl	AbCdEFgHiJkL	aBcDeFgHiJKl	AbCcDeFgHiJkL	AbCdEfGhIjKl
	AbCdEFgHiJkLl	AbCdEfGhIJkL
					aBcDeFgHiJkL	AbCdEfGhIiJkL	aBcDEfGhIjKl
	AbCdEfGhIJkL	aBcDeEfGhIjKL	aBcDeFgHiJkL	aBcDEfGhIjKl	AaBcDeFgHIjKl

	AbCdEfGhIjKL	aBcDeFgHiJjKl	AbCDeFgHiJkL	aBcDeFgHIjKl	AbCdEfGgHiJKl
	AbCdEfGhIjKl	AbCDeFgHiJkL	aBcCdEfGHiJkL	aBcDeFgHiJKl	AbCdEfGhIjKkL
	aBCdEfGhIjKl	AbCdEfGHiJkL	aBcDeFgHhIJkL	aBcDeFgHiJkL	aBCdEfGhIjKl
	AbCdEeFGhIjKl	AbCdEfGhIJkL	aBcDeFgHiJkL	aBBcDeFgHiJkL	aBcDeFGhIjKl
	AbCdEfGhIJjKl	AbCdEfGhIjKl	ABcDeFgHiJkL	aBcDeFGgHiJkL	aBcDeFgHIjKl
	AbCdEfGhIjKl	ABcDdEfGhIjKl	AbCdEFgHiJkL	aBcDeFgHIjKlL	aBcDeFgHiJkL
	AbCdEfGhIjKl	AbCdEFgHhIjKl	AbCdEfGHiJkL	aBcDeFgHiJkL	AbCdEeFgHiJkL
	aBcDEfGhIjKl	AbCdEfGHiJkL	aBbCdEfGhIjKL	aBcDeFgHiJkL	aBcDEfGhIjKkL
	aBcDeFgHIjKl	AbCdEfGhIjKL	aBcDeFgGhIjKl	AbCDeFgHiJkL	aBcDeFgHIjKl
	AbCcDeFgHiJKl	AbCdEfGhIjKl	AbCDeFgHiJkLl	AbCdEfGHiJkL	aBcDeFgHiJKl

	AbCdEfGhIiJkL	aBCdEfGhIjKl	AbCdEfGHiJkL	aBcDeEfGhIJkL	aBcDeFgHiJkL
	aBCdEfGhIjKl	AaBcDeFGhIjKl	AbCdEfGhIJkL	aBcDeFgHiJjKl	ABcDeFgHiJkL
	aBcDeFGhIjKl	AbCdEfGgHIjKl	AbCdEfGhIjKl	ABcDeFgHiJkL	aBcCdEFgHiJkL
	aBcDeFgHIjKl	AbCdEfGhIjKkL	AbCdEfGhIjKl	AbCdEFgHiJkL	aBcDeFgHIiJkL
	aBcDeFgHiJkL	AbCdEfGhIjKl	AbCdEFfGhIjKl	AbCdEfGHiJkL	aBcDeFgHiJkL
	AbBcDeFgHiJkL	aBcDEfGhIjKl	AbCdEfGHiJjKl	AbCdEfGhIjKL	aBcDeFgHiJkL
	aBcDEfGgHiJkL	aBcDeFGhIjKl	AbCdEfGhIjKL	aBcDdEfGhIjKl	AbCDeFgHiJkL
	aBcDeFGhIjKlL	aBcDeFgHiJKl	AbCdEfGhIjKl	AbCDeFgHhIjKl	AbCdEFgHiJkL
	aBcDeFgHiJKl	AbCdEeFgHijKL	aBCdEfGhIjKl	AbCdEFgHiJkL	aBbCdEfGhIJkL
	aBcDeFgHiJKl	aBcDEfgHIjKLl	AbcDeFgHIjKL	aBcdEfgHIjKL	AbCdeFggHiJKL

	aBCdeFghIjKL	aBCdEfGhIjkL	AbCdDEfGhIjkL	aBCdEfGHiJkL	abCdEfGHiJKl
	AabCdEfGHiJKl	AbcDefGHiJKL	aBcdEfgHhIJKl	ABcdEfgHiJKl	ABcDeFghIjKl
	ABCdEfFgHijKl	ABcDEfGhIjkL	aBcDEfGhIJkL	abBcDeFGhIJkL	abCdEfGhIJKl
	AbcDefGhIJKkL	AbcDefGhIJkL	ABcdEfgHiJkL	ABcDeFggHiJkL	AbCDeFghIjKl
	AbCDeFgHIjkL	aBcDdEFgHIjKl	aBcDeFgHIjKL	abCdeFgHIJkL	AabCdeFgHIjKL
	AbcDefGHijKL	AbCdEfgHiIjKL	aBCdEfgHiJkL	AbCdEFghIjKl	AbCDeFfGhIjKl
	AbCdEfGHiJkL	aBcdEFgHIjKL	aBccdEfGHiJKl	AbCdeFgHiJKL	aBcDefGhIjKKl
	ABcDefGhIjKl	ABCdEfgHiJkL	aBCdEfGgHiJkL	aBcDEfGhIjKl	AbCdEfGHiJkL
	aBccDeFGhIJkL	aBcdEfGhIJKl	AbCdeFgHiJKL	aAbCdeFghIJkL	ABcDefGhiJKl
	ABcDEfgHiIjKl	AbCDeFgHiJkL	aBcDeFGhIjKl	AbcDEeFgHIjKl	AbcDeFgHIJkL

	aBcdEfGhIJkL	AbCcdEfgHIjKL	AbCdeFghIJkL	ABcDefGhiJjKL	AbCdEfGhiJkL
	AbCDeFgHiJkL	aBcDeFGhHiJkL	abCdEFgHIjKl	AbcDeFgHIjKL	aBcdDefGHiJKL
	aBcdEfGhIjKl	ABCdeFghIjKLl	ABCdeFghIjKL	aBCdEfGhiJkL	aBCdEFgHiJjkL
	aBCdEfGHiJkL	abCdEfGHiJKl	AbcDeFfGhIJKl	AbcDefGhIJKL	aBcdEfgHiJKL
	aBCcdEfgHiJKl	ABcDeFghIjKL	aBcDEfGhIjkKL	aBcDeFGhIjkL	aBcDEfGHiJkL
	abCdEfGHhIJkL	aBcdEfgHIJkL	AbCDefghIJKl	ABcDeefGhIJKL	aBcdEfgHiJKL
	aBcDeFghIjKl	AAbCDeFghIjKl	ABcDeFGhIjkL	aBcDeFGhIiJKl	aBcDeFgHIJkL
	abCdEfgHIjKL	AbCdeeFgHiJKL	aBcDefGhIjKL	AbCdEfgHiJkL	ABcCdEfGhiJkL
	aBCDeFghIjKl	ABcdEFgHIjKkl	AbCdEfGHiJkL	aBcdEfGHiJKL	abCdeFgGHiJKL
	abCdeFgHiJKL	aBcDefGhIjKL	AbCdEefGhiJKL	aBCdEfgHiJkL	aBCdEfGhIjKl

	AaBcDeFGhIjKl	AbcDEfGHiJkL	aBcdEfGHiJJkL	aBcdEfGhIJKl	AbCdeFghIJKL
	aBcDefFghIJKL	aBcDefGhIjKl	ABcDEfgHijKL	aBbCDeFgHiJkL	aBcDeFGhIJkl
	AbcDeFGhIJkLl	AbcDeFgHIJkL	aBcdEfGhIJkL	AbCdeFggHIjKL	AbCdeFghIjKL
	AbCDefGhiJKl	AbCDdEfGhIjkL	AbCDeFgHiJkL	aBcDeFgHIjKl	AAbcdEFgHIjKl
	AbcDeFgHIjKL	AbcdEfgHIiJKL	aBcdEfgHIjKL	aBCdeFghIjKL	AbCdEfGghIjKl
	ABCdEfGhiJkL	aBCdEfGHiJkL	AbccDEfGHiJkL	abCdEfGHiJKl	AbcDEfgHiJKLl
	AbcDefGHiJKL	AbcdEfgHiJKL	aBCdeFggHiJKl	ABcDeFghIjKL	aBcDEfGhiJkL
	aBcDEeFGhIjkL	aBcDeFGhIJkL	abCdEfGHiJKl	AabCdeFGhIJKl	AbcDefGhIJKl
	ABcdEfgHiIJkL	ABcdEfgHiJKl	ABcDeFghIjKl	ABcDEfGgHijKl	AbCDeFgHIjKl
	aBcDeFGhIJkL	abCcDeFgHIJkL	abCdeFgHIJkL	AbcDefGhIJkLL	AbcDefGhIjKL

	AbCdEfgHiJkL	AbCDeFghHiJkL	aBCdEFghIjKl	AbCdEFgHiJKL	abcDdEfGHiJKl
	aBcdEfGHIjKL	abCdeFgHIjKL	AbbCdeFgHiJKL	aBcDefGhIjKL	AbCdEfgHiJJkL
	aBCdEfgHiJkL	AbCdEFgHijKl	AbCDeFfGhIJkl	AbCdEfGHiJKl	AbcDeFgHIjKL
	aBccdEfGHiJKL	aBcdeFgHiJKL	aBCdefGhIjKLl	ABcDeFghIjKL	aBCdEfGhiJkL
	aBCdEfGhHiJkL	aBcDEfGhIjKL	abCdEfGHiJKL	abcDdeFGhIJkL	AbcdEfGhIJKl
	ABcdeFgHiJKl	ABbCdeFgHiJkL	ABcDefGhIjKl	ABcDEfgHiJjKl	AbCDeFgHiJkL
	aBcDeFGhIjKl	AbCdEfGgHIjKl	AbCdeFgHIJkL	aBcdEfGhIJkL	AbCcDefGhIjKL
	AbCdEfghIJkL	ABcDefGhIjKkL	AbCdEfGhIjKl	AbCdEFgHiJkL	aBcDeFgHIiJkl
	ABcdEfGHIjKL	abCdeFgHIjKL	aBcDeeFgHiJKL	aBcdEfgHIjKL	AbCdEfghIjKL
	AaBCdeFgHijKL	aBCdEfGhIjKl	AbCdEFgHiJjKl	AbCdEfGHiJkL	abCdEfGHiJKl

	AbCdeFfGhIJKl	AbCdefGHiJKL	aBcDefgHiJKL	aBCcDefgHiJKl	ABcDeFgHijKL
	aBcDEfGhIjkLl	ABcDeFGhIjKl	aBcDeFGhIJkL	abCdEfGhHIJkL	aBcdEfGhIJKl
	AbCdefGhIJKl	ABcDeefGhIJkL	ABcdEfgHiJkL	ABcDeFgHijKl	ABbCDeFgHijKl
	AbCDeFgHIjKl	aBcDeFGhIJjKl	aBcDeFgHIjKL	aBcdeFgHIJkL	AbCdefFgHIjKL
	AbCdefGhIjKL	AbCdEfgHiJkL	AbCDdEfgHiJkL	aBCdEFghIjKl	AbCdEFgHiJKll
	AbCdEfGHiJKl	aBcDefGHIjKL	aBcdeFgHHiJKL	aBcdeFgHiJKL	aBcDefGhIjKL
	aBCdEefGhIjKl	ABCdEfgHiJkL	aBCdEfGhIjKl	AaBcDEfGhIjKl	AbCdEfGHiJkL
	aBcdEfGHiJKkl	ABcdEfGhIJkl	ABCdeFgHiJKl	ABcDefGgHiJkL	ABcDefGhIjKl
	ABcDEfgHiJkL	aBcCDeFgHijKL	aBcDeFGhIjKl	AbCdeFGhIJkLl	AbcDeFgHIJkL
	aBcdEfGhIJkL	AbCdeFggHIjKL	AbCdeFghIJkL	AbCDefGhiJKl	AbCDeEfGhIjKl

	AbCDeFgHiJkL	aBcDeFgHIjKl	AabCdEfGHIjKl	AbcDeFgHIjKL	aBcdEfgHIiJKL
	aBcdEfgHIjKL	AbCdeFghIjKL	AbCdEfGghIjKL	aBCdEfGhIjkL	AbCdEFgHiJkL
	abCcDEfGHiJkL	abCdEfGHiJKl	AbcDeFgHiJKLl	AbcDefGhIJKl	ABcdEfgHiJKL
	aBCdeFghHiJKl	ABcDeFghIjKL	aBcDEfGhIjkL	aBCdEeFGhIjKl	aBcDeFGhIJkL
	abCdEfGhIJKl	AbbCdeFGhIJKl	AbcDefGhIJKl	ABcdEfgHiJJkL	AbCdEfghIJkL
	ABcDeFghIjKl	ABcDEfGghIjKl	AbCDeFgHIjKl	aBcDeFGhIJkL	abCcDeFgHIjKL
	abCdeFgHIJkL	AbcDefGhIJkLL	aBcDefGhIjKL	AbCdEfgHiJkL	AbCDeFghHiJkL
	aBCdEfGhIjKl	AbCdEFgHiJkL	aBcDeEfGHiJKl	aBcdEfGHIjKL	abCdeFgHIjKL
	AbbCdeFgHiJKL	aBcDefGhIjKL	aBCdEfgHiJjKl	ABcDeFgHiJkL	aBCdEfGhIjKl
	AbCdEfGGhIjKl	AbcDeFGHiJkL	aBcdEfGHiJKl	AbCcdEfGhIJKl	AbCdeFgHiJKl

	ABcDefGhiJKLl	ABcDefGhiJKl	ABcDeFgHiJkL	aBcDEfGhIiJkL	aBcDeFGhIjKl
	AbcDeFGhIJkL	aBcdEeFgHIJkL	aBcdEfGhIJkL	AbCdeFghIJkL	ABbCdeFghIJkL
	AbCDefGhiJKl	AbCDeFgHiJjKl	AbCdEFgHiJkL	abCDeFgHIjKl	AbcDeFfGHIjKl
	AbcDeFgHIjKL	aBcdEfgHIjKL	AbCddEfgHIjKL	AbCdeFghIjKL	AbCdEfGhiJkLL
	aBCdEfGhIjkL	AbCdEFgHiJkL	abCdEFgHIiJkL	abCdEfGHiJKl	AbcDeFgHiJKL
	aBcdEefGHiJKL	aBcdEfgHiJKL	aBCdeFghIjKL	aBBcDeFghIjKL	aBcDEfGhIjkL
	aBCdEfGHiJjKl	aBcDeFGhIJkL	abCdEfGhIJKl	AbcDefFGhIJKl	AbcDefGhIJKl
	ABcdEfgHiJKl	ABCddEfgHiJkL	ABcDeFghIjKl	ABcDeFGhiJkLl	AbCDeFgHIjKl
	aBcDeFGhIjKL	abCdEfGhIIjKL	abCdeFgHIJkL	AbcDefGhIJkL	AbCdEefGhIjKL
	AbCdEfgHiJkL	AbCDeFghIjKl	AaBCdEfGhIjKl	AbCdEFgHiJkL	aBcDeFgHIjjKL

	aBcdEfGHIjKL	abCdeFgHIjKL	aBcDefGgHiJKL	aBcDefGhIjKL	aBCdEfgHiJkL
	aBCcDEfgHiJkL	aBCdEfGhIjKl	AbCdEfGHiJkLl	AbCdEfGHiJkL	aBcdEfGHiJKl
	AbCdeFgHhIJKl	AbCdeFgHiJKl	ABcDefGhIjKl	ABCdEefGhiJKl	ABcDeFgHiJkL
	aBcDEfGhIjKl	AaBcDeFGhIjKl	AbcDeFGhIJkL	aBcdEfGhIJjKL	aBcdEfGhIJkL
	AbCdeFghIJkL	ABcDefGghIJkL	AbCDefGhiJKl	AbCDeFgHiJkL	aBcDdEFgHiJkL
	abCDeFgHIjKl	AbcDeFgHIJkLl	AbcDeFgHIjKL	aBcdEfgHIjKL	AbCdeFghHiJKL
	aBCdeFghIjKL	AbCDefGhiJkL	AbCDeFfGhIjkL	aBCdEfGHiJkL	abCdEFgHIjKl
	AbbCdEfGHiJKl	AbcDefGHiJKL	aBcdEfgHiJJKl	ABcdEfgHiJKL	aBCdeFghIjKL
	aBCdEfGghIjKl	ABcDEfGhiJkL	aBcDEfGhIJkl	AbCcDeFGhIJkl	AbCdEfGhIJKl
	AbcDefGhIJKl	AAbcDefGhIJKl	ABcdEfgHiJKl	ABcDeFghIiJkL	ABcDeFghIjKl

	ABcDeFGhiJkL	aBcDEeFgHiJkL	aBcDeFGhIjKL	abCdeFGhIJkL	AbbCdeFgHIJkL
	AbcDefGhIJkL	AbCdEfgHiJjKL	AbCdEfgHiJkL	AbCDeFghIjKl	AbCDeFgGhIjKl
	AbCdEFgHiJkL	aBcDeFgHIjKL	abCcdEfGHIjKL	abCdeFgHiJKL	aBcDefGhIjKL
	AaBcDefGhIjKL	aBCdEfgHiJkL	aBCdEfGhIiJkL	aBcDEfGhIjKl	AbCdEfGHiJkL
	aBcdEeFGHiJkL	aBcdEfGHiJKl	AbCdeFgHiJKL	aBbCdeFghIJKl	ABcDefGhiJKl
	ABCdEfgHijJKl	ABcDeFgHiJkL	aBcDEfGhIjKl	AbCdEfGgHIjKl	AbcDeFGhIJkL
	aBcdEfGhIJKl	AbCddEfgHIJkL	AbCdeFghIJkL	ABcDefGhiJKlL	AbCdEfGhiJkL
	AbCDeFgHiJkl	ABcDeFGhIiJkl	AbCdEFgHIjKl	AbcDeFgHIJkL	aBcdEeFgHIjKL
	aBcdEfgHIjKL	AbCdeFghIjKL	AbBCdeFghIjKL	aBCdEfGhiJkL	AbCDeFgHijJkL
	aBCdEfGHiJkl	AbCdEFgHiJKl	AbcDeFfGHiJKl	AbcDefGHiJKL	aBcdEfgHiJKL

	aBCddEfgHiJKL	aBcDeFghIjKL	aBCdEfGhiJkLl	ABcDEfGhiJkL	aBcDEfGhIJkl
	AbCdEfGHiIjKl	AbCdEfGhIJKl	AbcDefGhIJKl	ABcdEefGhIJKl	ABcdEfgHiJKl
	ABcDeFghIjKl	ABbCDeFghIjKl	ABcDeFgHiJkL	aBcDeFGhIjjKL	aBcDeFgHIjKL
	abCdeFGhIJkL	AbcDefGgHIJkL	AbcDefGhIjKL	AbCdEfgHiJkL	ABcDdEfgHiJkL
	AbCDefGhIjKl	AbCDeFgHiJkLl	AbCdEFgHiJkL	aBcDeFgHIjKl	AbCdeFgHIiJKl
	AbCdeFgHiJKL	aBcDefGhIjKL	AbCdEffGhIjKL	aBCdEfgHiJkL	aBCdEfGhIjKl
	AbBcDEfGhIjKl	AbCdEfGHiJkL	aBcdEfGHiJjKL	aBcdEfGHiJKl	AbCdeFgHiJKL
	aBcDefGghIJKl	ABcDefgHiJKl	ABCdeFgHijKL	aBCdDeFgHiJkL	aBcDEfGhIjKl
	AbcDEfGHiJkLl	AbcDeFGhIJkL	aBcdEfGhIJKl	AbCdeFghHIJkL	AbCdefGhIJkL
	ABcDefGhiJKl	ABcDeFfGhiJkL	AbCDeFgHijKl	ABcDeFGhIjKl	aBbCdEFgHIjKl

	AbcDeFgHIJkL	aBcdEfgHIJjKL	aBcdeFgHIjKL	AbCdefGhIjKL	AbCDefGghIjKL
	aBCdEfGhiJkL	AbCDeFgHijKl	AbCDdEfGHiJkl	AbCdEfGHiJKl	AbcDeFgHIjKL
	aAbcDefGHiJKL	aBcdeFgHiJKL	aBCdeFghIiJKL	aBcDeFghIjKL	aBCdEfGhiJkL
	aBCdEFfGhiJkL	aBcDEfGhIJkl	AbCdEfGHiJKl	AbbCdeFGhIJKl	AbcDefGhIJKl
	ABcdEfgHiJjKL	AbCdEfgHiJKl	ABcDeFghIjKl	ABcDEfGghIjKl	ABcDeFgHiJkL
	aBcDeFGhIjKl	AbCcDeFgHIjKl	AbCdeFgHIJkL	AbcDefGhIJKl	AaBcDefGhIjKL
	AbCdEfgHiJkL	ABcDeFghIiJkL	AbCDefGhIjKl	AbCDeFgHiJkL	aBcDeFFgHiJkL
	aBcdEFgHIjKl	AbCdeFgHIjKL	aBbCdeFgHiJKL	aBcDefGhIjKL	AbCdEfghIjJKL
	aBCdeFgHijKL	aBCdEfGhIjKl	AbCdEFggHIjKl	AbCdEfGHiJkL	aBcdEfGHiJKl
	AbCddEfGhIJKl	AbCdeFgHiJKL	aBcDefgHiJKLl	ABcDefgHiJKl	ABcDeFgHijKL

	aBCdEfGhIijKL	aBcDeFGhIjKl	aBcDEfGhIJkL	aBcdEeFGhIJkL	aBcdEfGhIJKl
	AbCdefGhIJKl	ABcCdefGhIJkL	ABcDefgHiJKl	ABcDeFgHijjKL	AbCDeFgHijKl
	ABcDeFGhIjKl	aBcDeFGgHIjKl	aBcDeFgHIJkL	aBcdEfgHIJkL	AbCddeFgHIjKL
	AbCdefGhIjKL	AbCdEfgHiJkL	AaBCdEfGhiJkL	AbCdEFgHijKl	AbCDeFgHIijKl
	AbCdEfGHiJKl	aBcDeFgHIjKL	aBcdeEfGHiJKL	aBcdeFgHiJKL	aBCdefGhIjKL
	AbCcDefGhIjKL	aBCdEfGhiJkL	aBCdEfGhIjjKL	aBcDEfGhIjKl	AbCdEfGHiJKl
	aBcDefGGhIJKl	AbcdEfGhIJKl	ABcdeFgHiJKL	aBcDdeFgHiJKl	ABcDefGhIjKl
	ABcDEfgHiJkLl	AbCDeFgHiJkL	aBcDeFGhIjKl	AbCdEfGhIJjKl	AbCdeFgHIJkL
	AbcdEfGhIJKl	AbCdeFfGhIjKL	AbCdEfghIJkL	ABcDefGhIjKl	ABbCdEfGhIjKl
	AbCDeFgHiJkL	aBcDeFGhIjjKL	aBcdEFgHIjKl	AbcDeFgHIjKL	aBcDefGgHiJKL

	aBcDefgHIjKL	AbCdEfghIjKL	AbCDdeFgHijKL	aBCdEfGhIjKl	AbCdEFgHiJkLl
	AbCdEfGHiJkL	abCdEfGHiJKl	AbcDeFgHhIjKL	AbCdefGHiJKL	aBcDefgHiJKL
	aBCdeFfgHiJKl	ABcDeFgHijKL	aBCdEfGhIjkL	aBCcDeFGhIjKl	aBcDeFGhIJkL
	abCdEfGHijjKL	AbCdEfGhIJKl	AbCdefGhIJKl	ABcDefgGhIJkL	ABcdEfgHiJKl
	ABcDeFghIjKl	ABcDEeFgHijKl	AbCDeFgHIjKl	aBcDeFGhIJkL	aaBcDeFgHIjKL
	aBcdeFgHIJkL	AbCdefGhIIjKL	AbCdefGhIjKL	AbCdEfgHiJkL	AbCDeFfgHiJkL
	AbCdEFgHijKl	AbCdEFgHiJKl	aBbCdEfGHiJKl	aBcDeFgHIjKL	aBcdeFgHIjjKL
	AbCdeFgHiJKL	aBcDefGhIjKL	AbCdEfggHIjKL	aBCdEfgHiJkL	aBCdEfGhIjKl
	AbCdDEfGhIjKl	AbCdEfGHiJKl	aBcdEfGHiJKl	ABbcdEfGhIJKl	AbCdeFgHiJKL
	aBcDefGhIiJKl	ABcDefGhIjKl	ABcDEfgHiJkL	aBcDEfFgHiJkL	aBcDeFGhIjKl

	AbCdeFGhIJkL	aBbcDeFgHIJkL	aBcdEfGhIJKl	AbCdeFghIJjKL	AbCdeFghIJkL
	ABcDefGhiJKl	ABcDeFggHIjKl	AbCDeFgHiJkL	aBcDeFgHIjKl	AbcDdEFgHIjKl
	AbcDeFgHIjKL	aBcdEfGhIjKL	AaBcdEfgHIjKL	AbCdeFghIjKL	AbCDefGhiIjKL
	aBCdEfGhIjkL	AbCdEFgHiJkL	abCdEFfGHiJkL	abCdEfGHiJKl	AbcDeFgHiJKL
	aBccDefGHiJKL	aBcdEfgHiJKL	aBCdeFghIjjKL	AbCDeFghIjKL	aBCdEfGhIjkL
	aBCdEfGgHIjKl	aBcDeFGhIJkL	abCdEfGHiJKl	AbcDdeFGhIJKl	AbcDefGhIJKl
	ABcdEfgHiJKl	AAbCdEfgHiJkL	ABcDeFghIjKl	ABcDEfGhIijKl	AbCDeFgHIjKl
	aBcDeFGhIJkL	abCdEeFgHIjKL	abCdeFgHIJkL	AbCdefGhIJkL	ABccDefGhIjKL
	AbCdEfgHiJkL	AbCDeFghIjjKL	aBCdEfGhIjKl	AbCdEFgHiJkL	aBcDeFggHIJkL
	aBcDefGHIjKL	abCdeFgHIjKL	AbcDdeFgHiJKL	aBcDefGhIjKL	aBCdEfgHiJkL

	AaBCdEfgHiJkL	aBCdEfGhIjKl	AbCdEFgHiJjKl	AbCdEfGHiJkL	aBcdEfGHiJKl
	AbCdeFfGhIJKl	AbCdeFgHiJKL	aBcDefGhIjKL	aBCcDefGhIjKl	ABcDeFgHiJkL
	aBcDEfGhIjjKL	aBcDeFGhIjKl	AbcDeFGhIJkL	aBcdEfGgHIJkL	aBcdEfGhIJKl
	AbCdeFghIJkL	ABcDeeFghIJkL	AbCDefGhiJKl	ABcDeFgHiJkL	aAbCdEFgHiJkL
	aBcDeFgHIjKl	AbcDeFgHIJjKl	AbcDeFgHIjKL	aBcdEfgHIjKL	AbCdeFfgHIjKL
	AbCdeFghIjKL	AbCdEfGhiJkL	AbCCdEfGhIjkL	AbCdEFgHiJkL	abCdEFgHIjKkL
	abCdEfGHiJKl	AbcDeFgHiJKL	aBcdEfgGhIJKl	ABcdEfgHiJKL	aBCdeFghIjKL
	aBCdEeFghIjKL	aBcDEfGhIjkL	aBCdEfGHiJkL	aaBcDeFGhIJkL	abCdEfGhIJKl
	AbcDefGHiIjKL	AbcDefGhIJKl	ABcdEfgHiJKl	ABcDeFfgHiJkL	ABcDeFghIjKl
	ABcDEfGhiJkL	aBbCDeFgHIjKl	aBcDeFGhIJkL	abCdEfGhIjjKL	AbCdeFgHIJkL

	AbcDefGhIJkL	ABcdEfgHhIjKL	AbCdEfgHiJkL	AbCDeFghIjKl	AbCDdEfGhIjKl
	AbCdEFgHiJkL	aBcDeFgHIjKL	aaBcdEfGHIjKL	abCdeFgHIjKL	AbcDefGhIiJKL
	aBcDefGhIjKL	aBCdEfgHiJkL	aBCDeFfgHiJkL	aBCdEfGhIjKl	AbCdEfGHiJkL
	aBbCdEfGHiJkL	aBcdEfGHiJKl	AbCdeFgHiJjKL	AbCdeFgHiJKL	aBcDefGhiJKl
	ABCdEfgHhiJKl	ABcDeFgHiJkL	aBcDEFghIjKl	AbCdEeFGhIjKl	AbcDeFGhIJkL
	aBcdEfGhIJKl	AaBcdEfGhIJkL	AbCdeFghIJkL	ABcDefGhiIjKL	AbCDefGhiJKl
	AbCDeFgHiJkL	aBcDeFGgHiJkL	abCDeFgHIjKl	AbcDeFgHIJkL	aBccDeFgHIjKL
	aBcdEfgHIjKL	AbCdeFghIJkKL	AbCdeFghIjKL	AbCdEfGhiJkL	AbCDeFgHhIjkL
	AbCdEFgHiJkL	abCdEFgHIjKl	AbcDdEfGHiJKl	AbcDefGHiJKL	aBcdEfgHiJKL
	AbBcdEfgHiJKL	aBCdeFghIjKL	aBCdEfGhiJjKl	ABcDEfGhiJkL	aBCdEfGHiJkl

	AbCdEfFGhIJkL	abCdEfGhIJKl	AbcDefGHiJKL	aBccDefGhIJKl	ABcdEfgHiJKl
	ABcDeFghIjKkL	ABcDeFghIjKl	ABcDeFGhiJkL	aBcDEfGhHiJkL	aBcDeFGhIjKL
	abCdeFGhIJkL	AbcDdeFgHIJkL	AbcDefGhIJkL	AbCdEfgHiJkL	ABbCdEfgHiJkL
	AbCDeFghIjKl	AbCDeFgHiJjKl	AbCdEFgHiJkL	aBcDeFgHIjKL	abCdeFfGHIjKL
	abCdeFgHIjKL	aBcDefGhIjKL	AbCcDefGhIjKL	aBCdEfgHiJkL	aBCdEfGhIjKkL
	aBCdEfGhIjKl	AbCdEfGHiJkL	aBcdEFgHIiJkL	aBcdEfGHiJKl	AbCdeFgHiJKL
	aBcDeeFgHiJKl	ABcDefGhiJKl	ABCdEfgHijKL	aABcDeFgHiJkL	aBcDEfGhIjKl
	AbCdEfGHiJjKl	AbcDeFGhIJkL	aBcdEfGhIJKl	AbCdeFfGhIJkL	AbCdeFghIJkL
	ABcDefGhiJKl	ABcCdEfGhiJKl	AbCDeFgHiJkl	ABcDeFGhIjKkL	abCdEFgHIjKl
	AbcDeFgHIJkL	aBcdEfGgHIjKL	aBcdEfgHIjKL	AbCdeFghIjKL	AbCDeeFghIjKL

	AbCdEfGhiJkL	AbCDeFgHijKl	AaBCdEfGHiJkl	AbCdEFgHIjKl	AbcDeFgHIjjKL
	AbcDefGHiJKL	aBcdEfgHiJKL	AbCdeFfgHiJKL	aBcDeFghIjKL	aBCdEfGhiJkL
	aBCcDEfGhiJkL	aBcDEfGhIJkl	AbCdEfGHiJKlL	abCdEfGhIJKl	AbcDefGhIJKL
	aBcdEfgHhIJKl	ABcdEfgHiJKl	ABcDeFghIjKl	ABCdEeFghIjKl	ABcDeFgHiJkL
	aBcDEfGhIjKl	AaBcDeFGhIjKL	abCdeFGhIJkL	AbcDefGhIJKkL	AbcDefGhIJkL
	AbCdEfgHiJkL	ABcDeFggHiJkL	AbCDeFghIjKl	AbCDeFgHiJkL	aBcCdEFgHiJkL
	aBcDeFgHIjKl	AbCdeFgHIJkL	AabCdeFgHIjKL	aBcDefGhIjKL	AbCdEfgHhIjKL
	aBCdEfgHiJkL	aBCdEfGhIjKl	AbCdEEfGhIjKl	AbCdEfGHiJkL	aBcdEfGHIjKl
	AaBcdEfGHiJKl	AbCdeFgHiJKL	aBcDefGhiIJKl	ABcDefGhiJKl	ABCdeFgHijKL
	aBCdEfGgHiJkL	aBcDEfGhIjKl	AbCdEfGHiJkL	aBccDeFGhIJkL	aBcdEfGhIJKl

	AbCdeFghIJKkL	AbCdefGhIJkL	ABcDefGhiJKl	ABcDeFgHhiJkL	AbCDeFgHijKl
	ABcDeFGhIjKl	aBcDdEFgHIjKl	AbcDeFgHIJkL	aBcdEfGhIJkL	AbBcdeFgHIjKL
	AbCdefGhIjKL	AbCDefGhiJjKL	AbCdEfGhiJkL	AbCDeFgHijKl	AbCDeFfGHiJkl
	AbCdEFgHiJKl	AbcDeFgHIjKL	aBccDefGHiJKL	aBcdeFgHiJKL	aBCdeFghIjKLL
	aBcDeFghIjKL	aBCdEfGhiJkL	aBCdEFgHhiJkL	aBcDEfGhIJkl	AbCdEfGHiJKl
	AbcDdeFGhIJKl	AbcDefGhIJKl	ABcdEfgHiJKL	aBbCdEfgHiJKl	ABcDeFghIjKl
	ABCdEfGhiJjKl	ABcDeFgHiJkL	aBcDeFGhIjKl	AbCdEfGgHIjKL	abCdeFGhIJkL
	AbcDefGhIJKl	ABccDefGhIJkL	AbCdEfgHiJkL	ABcDeFghIjKkL	AbCDefGhIjKl
	AbCDeFgHiJkL	aBcDeFGhIiJkL	aBcdEFgHIjKl	AbCdeFgHIJkL	aBcDeeFgHIjKL
	aBcDefGhIjKL	AbCdEfghIJkL	AaBCdeFgHiJkL	aBCdEfGhIjKl	AbCdEFgHiJjKl

	AbCdEfGHiJkL	aBcdEfGHiJKl	AbCdeFfGHiJKl	AbCdeFgHiJKL	aBcDefgHiJKL
	aBCdDefgHiJKl	ABCdeFgHijKL	aBCdEfGhIjkLL	aBcDEfGhIjKl	AbcDEfGHiJkL
	aBcdEfGHhIJkL	aBcdEfGhIJKl	AbCdefGhIJKl	ABcDeefGhIJkL	ABcDefgHiJKl
	ABcDeFgHijKl	ABbCDeFgHijKl	ABcDeFGhIjKl	aBcDeFGhIJjKl	aBcDeFgHIJkL
	aBcdEfgHIJkL	AbCdefFgHIjKL	AbCdefGhIjKL	AbCdEfgHiJkL	AbCDdEfGhiJkL
	AbCDeFgHijKl	AbCDeFgHIjKll	AbCdEfGHiJKl	aBcDeFgHIjKL	aBcdeFgHHiJKL
	aBcdeFgHiJKL	aBCdefGhIjKL	AbCdEefGhIjKL	aBCdEfGhiJkL	aBcDEfGhIjKl
	AbCcDeFGhIjKl	AbcDeFGhIJkL	aBcdEfGhIJKl	AaBcdEfGhIJKl	AbCdeFghIJkL
	ABcDefGhhIJkL	AbCDefGhiJkL	ABcDeFgHijKl	ABcDEeFgHiJkl	AbCDeFgHIjKl
	AbcDeFGhIJkL	aBbcDeFgHIjKL	aBcdEfgHIjKL	AbCdeFghIiJKL	AbCdeFghIjKL

	AbCdEfGhiJkL	AbCDeFgHhiJkL	aBCdEFgHiJkl	AbCdEFgHIjKl	AbcDdEfGHiJKl
	AbcDefGHiJKL	aBcdEfgHiJKL	AaBcdEfgHiJKL	aBCdeFghIjKL	aBCdEfGhhIjKl
	ABCdEfGhiJkL	aBCdEfGHiJkl	AbCdEeFGhIJkL	abCdEfGHiJKl	AbcDefGHiJKL
	aBbcDefGhIJKl	ABcdEfgHiJKl	ABcDeFghIjJkL	ABcDeFghIjKl	ABcDEfGhiJkL
	aBcDEfGgHiJkL	aBcDeFGhIjKl	AbCdeFGhIJkL	AbcDdeFgHIJkL	AbcDefGhIJkL
	AbCdEfgHiJkL	AAbCdEfgHiJkL	AbCDeFghIjKl	AbCDeFgHiIjKl	AbCdEFgHiJkL
	aBcDeFgHIjKl	AbCdeEfGHIjKl	AbCdeFgHIjKL	aBcDefGhIjKL	AbCcDefGhIjKL
	aBCdEfgHijKL	aBCDeFghIjKkL	aBCdEfGhIjKl	AbCdEFgHiJkL	aBcdEFgGHiJkL
	aBcdEfGHiJKl	AbCdeFgHiJKL	aBcDdeFghIJKL	aBcDefGhiJKl	ABCdEfgHijKLl
	ABcDeFgHijKL	aBcDEfGhIjKl	aBCdEfGHiJjKl	AbcDeFGhIJkL	aBcdEfGhIJKl

	AbCdeFfGhIJkL	AbCdeFghIJkL	ABcDefGhiJKl	ABbCDefGhiJkL	ABcDeFgHijKl
	ABcDeFGhIjKkl	AbCDeFgHIjKl	AbcDeFgHIJkL	aBcdEfGgHIjKL	aBcdEfgHIjKL
	AbCdeFghIjKL	ABcDdeFghIjKL	AbCdEfGhiJkL	AbCDeFgHijKlL	aBCdEFgHiJkl
	AbCdEFgHIjKl	aBcDeFgHIiJKl	AbcDefGHiJKL	aBcdEfgHiJKL	AbCdeFfgHiJKL
	aBcDeFghIjKL	aBCdEfGhiJkL	aBCcDEfGhiJkL	aBCdEfGhIjKl	AbCdEfGHiJKll
	AbCdEfGhIJKl	AbcDefGhIJKl	ABcdEfgGhIJKl	ABcdEfgHiJKl	ABcDeFghIjKl
	ABCdEeFghIjKl	ABcDeFgHiJkL	aBcDEfGhIjKl	AaBcDeFGhIjKl	AbCdeFGhIJkL
	aBcDefGhIJJkL	AbcDefGhIJkL	AbCdEfgHiJkL	ABcDeFfgHiJkL	AbCDeFghIjKl
	AbCDeFgHiJkL	aBbCdEFgHiJkL	aBcDeFgHIjKl	AbCdeFgHIJkKl	AbCdeFgHIjKL
	aBcDefGhIjKL	AbCdEfggHiJKL	aBCdEfgHijKL	aBCDefGhIjkL	AbCDdEfGhIjKl

	AbCdEfGHiJkL	aBcdEfGHIjKl	AaBcdEfGHiJKl	AbCdeFgHiJKL	aBcDefgHhIJKl
	ABcDefgHiJKl	ABCdEfgHijKL	aBCdEfFgHijKl	ABcDEfGhIjKl	aBcDEfGHiJkL
	abBcDeFGhIJkL	aBcdEfGhIJKl	AbCdefGhIJKkL	AbCdefGhIJkL	ABcDefgHiJkL
	ABcDeFgHhiJkL	AbCDeFgHijKl	ABcDeFGhIjkL	aBcDdEFgHIjKl	aBcDeFgHIJkL
	aBcdEfGhIJkL	AaBcdeFgHIjKL	AbCdefGhIjKL	ABcdEfgHhIjKL	AbCdEfGhiJkL
	AbCDeFgHijKl	AbCDeFfGHijKl	AbCdEFgHiJKl	aBcDeFgHIjKL	abCcDefGHiJKL
	aBcdeFgHiJKL	AbCdefGhIjKKL	aBcDefGhIjKL	aBCdEfgHiJkL	aBCdEFggHiJkL
	aBcDEfGhIjKl	AbCdEfGHiJkL	aBcDdeFGhIJkL	aBcdEfGhIJKl	ABcdeFgHiJKL
	aAbCdeFgHiJKl	ABcDefGhIjKl	ABCdEfgHiIjKl	ABcDeFgHiJkL	aBcDEfGhIjKl
	AbCdEeFGhIjKl	AbCdeFGhIJkL	aBcdEfGhIJKl	AbCddEfGhIJkL	AbCdeFgHiJkL

	ABcDefGhIjKl	ABbCDefGhIjKl	AbCDeFgHiJkL	aBcDeFGgHiJkL	aBcdEFgHIjKl
	AbcDeFgHIJkL	aBcdEeFgHIjKL	aBcdEfgHIjKL	AbCdeFghIjKL	AbCCdeFghIjKL
	aBCdEfGhIjkL	AbCDeFgHhIjKl	aBCdEfGHiJkL	abCdEfGHIjKl	AbcDeEfGHiJKl
	AbCdefGHiJKL	aBcDefgHiJKL	aBCddEfgHiJKl	ABCdeFghIjKL	aBCdEfGhIjjKl
	ABcDEfGhIjkL	aBcDEfGHiJkL	)
      }
    ]

    #
    # 『唐・日本における進朔に関する研究』(2013-10版)を使用する場合の朔閏表
    #
    Japanese0764 = [PatternTableBasedLuniSolar, {
      'origin_of_MSC'=>764, 'origin_of_LSC'=>2000146,
      'indices'=> [
           Coordinates::Index.new({:branch=>{1=>When.Resource('_m:CalendarTerms::閏')},
                                   :trunk=>When.Resource('_m:JapaneseTerms::Month::*')}),
           Coordinates::DefaultDayIndex
       ],
      'note'      => 'JapaneseNote',
      'rule_table'=> %w(				aBCdEfGhiJkL	aBCdEFgHiJjkL
	aBCdEfGHiJkL	abCdEfGHiJKl	AbcDeFfGHiJKl	AbCdeFghIJKL	aBcdEfgHiJKL
	aBCcDefgHiJKl	ABCdeFgHijKL	aBcDEfGhIjkKL	aBcDEfGhIjkL	AbcDEfGHiJkL
	aBcdEfGHhIJkL	aBcdEfgHIJkL	AbCDefghIJKl	ABcDeefGhIJKL	aBcDefgHiJKL
	aBcDeFgHijKl	AAbCDeFghIjKl	ABcDeFGhIjkL	aBcDeFGhIiJKl	aBcDeFgHIJkL
	aBcdEfgHIjKL	AbCdeeFgHiJKL	aBCdefGhIjKL	AbCdEfgHiJkL	ABcCdEfGhiJkL
	AbCDeFgHijKl	ABcDeFgHIjKkl	AbCdEfGHiJkL	aBcdEfGHiJKL	abCdeFgGHiJKL
	abCdeFgHiJKL	aBcDefGhIjKL	AbCdEefGhiJKL	aBCdEfgHiJkL	aBCdEfGhIjKl

	AaBcDeFGhIjKl	AbcDEfGHiJkL	aBcdEfGHiJJkL	aBcdEfGhIJKl	AbCdeFghIJKL
	aBcDefFghIJKL	aBcDefGhIjKl	ABcDEfgHijKL	aBbCDeFgHiJkL	aBcDeFGhIJkl
	AbcDeFGhIJkLl	AbcDeFgHIJkL	aBcdEfGhIJKl	AbCdeFggHIjKL	AbCdeFghIjKL
	ABcDefGhiJKl	AbCDdEfGhIjkL	AbCDeFgHiJkL	aBcDeFgHIjKl	AabCdEFgHIjKl
	AbcDeFgHIjKL	aBcdEfgHIiJKL	aBcdEfgHIjKL	aBCdeFghIjKL	AbCdEfGghIjKl
	ABCdEfGhiJkL	aBCdEfGHiJkL	AbccDEfGHiJkL	abCdEfGHiJKl	AbcDEfgHiJKLl
	AbcDefGHiJKL	AbcdEfgHiJKL	aBCdeFggHiJKl	ABcDeFghIjKL	aBCdEfGhiJkL
	aBCdEeFGhIjkL	aBcDeFGhIJkL	abCdEfGHiJKl	AabCdeFGhIJKl	AbcDefGhIJKl
	ABcdEfgHiIJkL	ABcdEfgHiJKl	ABcDeFghIjKl	ABcDEfGgHijKl	AbCDeFgHIjKl
	aBcDeFGhIJkL	abCcDeFgHIJkL	abCdeFgHIJkL	AbcDefGhIJkLL	AbcDefGhIjKL

	AbCdEfgHiJkL	AbCDeFghHiJkL	AbCdEFghIjKl	AbCdEFgHiJKL	abcDdEfGHiJKl
	aBcdEfGHIjKL	abCdeFgHIjKL	AbbCdeFgHiJKL	aBcDefGhIjKL	AbCdEfgHiJJkL
	aBCdEfgHiJkL)
      }
    ]
  end

  class TM::CalendarEra

    #
    # 日本の年号
    #
    Japanese = [{}, self, [
      "namespace:[ja=http://ja.wikipedia.org/wiki/, en=http://en.wikipedia.org/wiki/]",
      "locale:[=ja:, en=en:, alias]",
      'area:[日本#{?V=V}=ja:%%<元号>#%.<日本>,Japan#{?V=V}=en:Regnal_year#Japanese]',
      [self,
	"period:[飛鳥時代]",
	["[推古]1",	"@A",	"name=[推古];0593-01-01^Japanese"],
	["[舒明]1",	"@A",	"name=[舒明];0629-01-04"],
	["[皇極]1",	"@A",	"name=[皇極];0642-01-15"],
	["[大化]1",	"@A",	"name=[孝徳];0645-06-19"],
	["[白雉]1",	"@FE",	"	     0650-02-15"],
	["[斉明]1",	"@A",	"name=[斉明];0655-01-03"],
	["[天智]1",	"@A",	"name=[天智];0662-01-01"],
	["[弘文]1",	"@A",	"name=[弘文];0672-01-01"],
	["[天武]1",	"@A",	"name=[天武];0673-02-27"],
	["[朱鳥]1",	"",	"	     0686-07-20"],
	["[持統]1",	"@A",	"name=[持統];0687-01-01"],
	["[文武]1",	"@A",	"name=[文武];0697-08-01"],
	["[大宝]1",	"@FE",	"	     0701-03-21"],
	["[慶雲]1",	"@FE",	"	     0704-05-10"],
	["[和銅]1",	"@A",	"name=[元明];0708-01-11", "0710-03-10"]
      ],
      [self,
	"period:[奈良時代]",
	["[和銅]3",	"@A",	"name=[元明];0710-03-10^Japanese"],
	["[霊亀]1",	"@A",	"name=[元正];0715-09-02"],
	["[養老]1",	"@FE",	"	     0717-11-17"],
	["[神亀]1",	"[代始・祥瑞]",	"name=[聖武];0724-02-04"],
	["[天平]1",	"@FE",	"	     0729-08-05"],
	["[天平感宝]1",	"@FE",	"	     0749-04-14"],
	["[天平勝宝]1",	"@A",	"name=[孝謙];0749-07-02"],
	["[天平宝字]1",	"@FE",	"	     0757-08-18",
				"name=[淳仁];0758-08-01", '0764-01-01^Japanese#{V}', ""],
	["[天平神護]1",	"@A",	"name=[称徳];0765-01-07"],
	["[神護景雲]1",	"@FE",	"	     0767-08-16"],
	["[宝亀]1",	"[代始・祥瑞]",	"name=[光仁];0770-10-01"],
	["[天応]1",	"@FE",	"	     0781-01-01"],
	["[延暦]1",	"@A",	"name=[桓武];0782-08-19", "0794-10-22"]
      ],
      [self,
	"period:[平安時代]",
	["[延暦]13",	"",	'name=[桓武];0794-10-22^Japanese#{V}'],
	["[大同]1",	"@A",	"name=[平城];0806-05-18"],
	["[弘仁]1",	"@A",	"name=[嵯峨];0810-09-19"],
	["[天長]1",	"@A",	"name=[淳和];0824-01-05"],
	["[承和]1",	"@A",	"name=[仁明];0834-01-03"],
	["[嘉祥]1",	"@FE",	"	     0848-06-13"],
	["[仁寿]1",	"[代始・祥瑞]",	"name=[文徳];0851-04-28"],
	["[斉衡]1",	"@FE",	"	     0854-11-30"],
	["[天安]1",	"@FE",	"	     0857-02-21"],
	["[貞観]1",	"@A",	"name=[清和];0859-04-15", "0862-01-01^Japanese", ""],
	["[元慶]1",	"[代始・祥瑞]",	"name=[陽成];0877-04-16"],
	["[仁和]1",	"@A",	"name=[光孝];0885-02-21"],
	["[寛平]1",	"@A",	"name=[宇多];0889-04-27"],
	["[昌泰]1",	"@A",	"name=[醍醐];0898-04-26"],
	["[延喜]1",	"@IY",	"	     0901-07-15"],
	["[延長]1",	"@ND",	"	     0923-04=11"],
	["[承平]1",	"@A",	"name=[朱雀];0931-04-26"],
	["[天慶]1",	"@ND",	"	     0938-05-22"],
	["[天暦]1",	"@A",	"name=[村上];0947-04-22"],
	["[天徳]1",	"@ND",	"	     0957-10-27"],
	["[応和]1",	"[災異・革年]",	"    0961-02-16"],
	["[康保]1",	"[災異・革年]",	"    0964-07-10"],
	["[安和]1",	"@A",	"name=[冷泉];0968-08-13"],
	["[天禄]1",	"@A",	"name=[円融];0970-03-25"],
	["[天延]1",	"@ND",	"	     0973-12-20"],
	["[貞元]1",	"@ND",	"	     0976-07-13"],
	["[天元]1",	"@ND",	"	     0978-11-29"],
	["[永観]1",	"@ND",	"	     0983-04-15"],
	["[寛和]1",	"@A",	"name=[花山];0985-04-27"],
	["[永延]1",	"@A",	"name=[一条];0987-04-05"],
	["[永祚]1",	"@ND",	"	     0989-08-08"],
	["[正暦]1",	"@ND",	"	     0990-11-07"],
	["[長徳]1",	"@ND",	"	     0995-02-22"],
	["[長保]1",	"@ND",	"	     0999-01-13"],
	["[寛弘]1",	"@ND",	"	     1004-07-20"],
	["[長和]1",	"@A",	"name=[三条];1012-12-25"],
	["[寛仁]1",	"@A",	"name=[後一条];1017-04-23"],
	["[治安]1",	"@IY",	"	     1021-02-02"],
	["[万寿]1",	"@IY",	"	     1024-07-13"],
	["[長元]1",	"@ND",	"	     1028-07-25"],
	["[長暦]1",	"@A",	"name=[後朱雀];1037-04-21"],
	["[長久]1",	"@ND",	"	     1040-11-10"],
	["[寛徳]1",	"@ND",	"	     1044-11-24"],
	["[永承]1",	"@A",	"name=[後冷泉];1046-04-14"],
	["[天喜]1",	"@ND",	"	     1053-01-11"],
	["[康平]1",	"@ND",	"	     1058-08-29"],
	["[治暦]1",	"@ND",	"	     1065-08-02"],
	["[延久]1",	"@A",	"name=[後三条];1069-04-13"],
	["[承保]1",	"@A",	"name=[白河];1074-08-23"],
	["[承暦]1",	"@ND",	"	     1077-11-17"],
	["[永保]1",	"@IY",	"	     1081-02-10"],
	["[応徳]1",	"@IY",	"	     1084-02-07"],
	["[寛治]1",	"@A",	"name=[堀河];1087-04-07"],
	["[嘉保]1",	"@ND",	"	     1094-12-15"],
	["[永長]1",	"@ND",	"	     1096-12-17"],
	["[承徳]1",	"@ND",	"	     1097-11-21"],
	["[康和]1",	"@ND",	"	     1099-08-28"],
	["[長治]1",	"@ND",	"	     1104-02-10"],
	["[嘉承]1",	"@ND",	"	     1106-04-09"],
	["[天仁]1",	"@A",	"name=[鳥羽];1108-08-03"],
	["[天永]1",	"@ND",	"	     1110-07-13"],
	["[永久]1",	"@ND",	"	     1113-07-13"],
	["[元永]1",	"@ND",	"	     1118-04-03"],
	["[保安]1",	"@ND",	"	     1120-04-10"],
	["[天治]1",	"@A",	"name=[崇徳];1124-04-03"],
	["[大治]1",	"@ND",	"	     1126-01-22"],
	["[天承]1",	"@ND",	"	     1131-01-29"],
	["[長承]1",	"@ND",	"	     1132-08-11"],
	["[保延]1",	"@ND",	"	     1135-04-27"],
	["[永治]1",	"@IY",	"	     1141-07-10"],
	["[康治]1",	"@A",	"name=[近衛];1142-04-28"],
	["[天養]1",	"@IY",	"	     1144-02-23"],
	["[久安]1",	"@ND",	"	     1145-07-22"],
	["[仁平]1",	"@ND",	"	     1151-01-26"],
	["[久寿]1",	"@ND",	"	     1154-10-28"],
	["[保元]1",	"@A",	"name=[後白河];1156-04-27"],
	["[平治]1",	"@A",	"name=[二条];1159-04-20"],
	["[永暦]1",	"@ND",	"	     1160-01-10"],
	["[応保]1",	"@ND",	"	     1161-09-04"],
	["[長寛]1",	"@ND",	"	     1163-03-29"],
	["[永万]1",	"@ND",	"	     1165-06-05"],
	["[仁安]1",	"@A",	"name=[六条];1166-08-27"],
	["[嘉応]1",	"@A",	"name=[高倉];1169-04-08"],
	["[承安]1",	"@ND",	"	     1171-04-21"],
	["[安元]1",	"@ND",	"	     1175-07-28"],
	["[治承]1",	"@ND",	"	     1177-08-04"],
	["[養和]1",	"@A",	"name=[安徳];1181-07-14"],
	["[寿永]1",	"@ND",	"	     1182-05-27", "1183-08-20"]
      ],
      [self,
	"period:[平氏方]",
	["[寿永]2",	"",	"	     1183-08-20^Japanese", "1185-03-24="]
      ],
      [self,
	"period:[源氏方]",
	["[治承]5",	"",	"name=[高倉];1181-07-14^Japanese"],
	["[元暦]1",	"@A",	"name=[後鳥羽];1184-04-16", "1185-03-24="]
      ],
      [self,
	"period:[鎌倉時代]",
	["[元暦]2",	"",	"name=[後鳥羽];1185-03-24=^Japanese"],
	["[文治]1",	"@ND",	"	     1185-08-14"],
	["[建久]1",	"@ND",	"	     1190-04-11"],
	["[正治]1",	"@A",	"name=[土御門];1199-04-27"],
	["[建仁]1",	"@IY",	"	     1201-02-13"],
	["[元久]1",	"@IY",	"	     1204-02-20"],
	["[建永]1",	"@ND",	"	     1206-04-27"],
	["[承元]1",	"@ND",	"	     1207-10-25"],
	["[建暦]1",	"@A",	"name=[順徳];1211-03-09"],
	["[建保]1",	"@ND",	"	     1213-12-06"],
	["[承久]1",	"@ND",	"	     1219-04-12",
				"name=[仲恭];1221-04-20", ""],
	["[貞応]1",	"@A",	"name=[後堀河];1222-04-13"],
	["[元仁]1",	"@ND",	"	     1224-11-20"],
	["[嘉禄]1",	"@ND",	"	     1225-04-20"],
	["[安貞]1",	"@ND",	"	     1227-12-10"],
	["[寛喜]1",	"@ND",	"	     1229-03-05"],
	["[貞永]1",	"@ND",	"	     1232-04-02"],
	["[天福]1",	"@A",	"name=[四条];1233-04-15"],
	["[文暦]1",	"@ND",	"	     1234-11-05"],
	["[嘉禎]1",	"@ND",	"	     1235-09-19"],
	["[暦仁]1",	"@ND",	"	     1238-11-23"],
	["[延応]1",	"@ND",	"	     1239-02-07"],
	["[仁治]1",	"@ND",	"	     1240-07-16"],
	["[寛元]1",	"@A",	"name=[後嵯峨];1243-02-26"],
	["[宝治]1",	"@A",	"name=[後深草];1247-02-28"],
	["[建長]1",	"@ND",	"	     1249-03-18"],
	["[康元]1",	"@ND",	"	     1256-10-05"],
	["[正嘉]1",	"@ND",	"	     1257-03-14"],
	["[正元]1",	"@ND",	"	     1259-03-26"],
	["[文応]1",	"@A",	"name=[亀山];1260-04-13"],
	["[弘長]1",	"@IY",	"	     1261-02-20"],
	["[文永]1",	"@IY",	"	     1264-02-28"],
	["[建治]1",	"@A",	"name=[後宇多];1275-04-25"],
	["[弘安]1",	"@ND",	"	     1278-02-29"],
	["[正応]1",	"@A",	"name=[伏見];1288-04-28"],
	["[永仁]1",	"@ND",	"	     1293-08-05"],
	["[正安]1",	"@A",	"name=[後伏見];1299-04-25"],
	["[乾元]1",	"@A",	"name=[後二条];1302-11-21"],
	["[嘉元]1",	"@ND",	"	     1303-08-05"],
	["[徳治]1",	"@ND",	"	     1306-12-14"],
	["[延慶]1",	"@A",	"name=[花園];1308-10-09"],
	["[応長]1",	"@ND",	"	     1311-04-28"],
	["[正和]1",	"@ND",	"	     1312-03-20"],
	["[文保]1",	"@ND",	"	     1317-02-03"],
	["[元応]1",	"@A",	"name=[後醍醐];1319-04-28"],
	["[元亨]1",	"@IY",	"	     1321-02-23"],
	["[正中]1",	"@ND",	"	     1324-12-09"],
	["[嘉暦]1",	"@ND",	"	     1326-04-26"],
	["[元徳]1",	"@ND",	"	     1329-08-29"],
	["[元弘]1",	"@ND",	"	     1331-08-09", "1333-05-18"]
      ],
      [self,
	"period:[大覚寺統]",
	["[元弘]3",	"",	"name=[後醍醐];1333-05-18^Japanese"],
	["[建武]1",	"[撥乱帰正]","	     1334-01-29", "1336-02-29"]
      ],
      [self,
	"period:[南朝]",
	["[延元]1",	"@ND",	"name=[後醍醐];1336-02-29^Japanese"],
	["[興国]1",	"@A",	"name=[後村上];1340-04-28"],
	["[正平]1",	"@ND",	"	     1346-12-08"],
	["[建徳]1",	"@A",	"name=[長慶];1370-07-24"],
	["[文中]1",	"@ND",	"	     1372-04"],
	["[天授]1",	"@ND",	"	     1375-05-27"],
	["[弘和]1",	"@IY",	"	     1381-02-10"],
	["[元中]1",	"@IY",	"name=[後亀山];1384-04-28", "1392-10=06"]
      ],
      [self,
	"period:[持明院統]",
	["[元徳]3",	"",	"      name=;1331-08-09^Japanese",
				"name=[光厳];1331-09-20", ""],
	["[正慶]1",	"@A",	"	     1332-04-28", "1333-05-18"]
      ],
      [self,
	"period:[北朝]",
	["[建武]3",	"",	"name=;1336-02-29^Japanese",
				"name=[光明];1336-08-15", ""],
	["[暦応]1",	"@A",	"	     1338-08-28"],
	["[康永]1",	"@ND",	"	     1342-04-27"],
	["[貞和]1",	"@ND",	"	     1345-10-21"],
	["[観応]1",	"@A",	"name=[崇光];1350-02-27", "1351-11-08"],
	["[観応]3",	"",	"name=[後光厳];1352-08-17"],
	["[文和]1",	"@A",	"	     1352-09-27"],
	["[延文]1",	"@ND",	"	     1356-03-28"],
	["[康安]1",	"@ND",	"	     1361-03-29"],
	["[貞治]1",	"@ND",	"	     1362-09-23"],
	["[応安]1",	"@ND",	"	     1368-02-18",
			      "name=[後円融];1371-03-23", ""],
	["[永和]1",	"@A",	"	     1375-02-27"],
	["[康暦]1",	"@ND",	"	     1379-03-22"],
	["[永徳]1",	"@IY",	"	     1381-02-24"],
	["[至徳]1",	"[代始・革年]",	"name=[後小松];1384-02-27"],
	["[嘉慶]1",	"@ND",	"	     1387-08-23"],
	["[康応]1",	"@ND",	"	     1389-02-09"],
	["[明徳]1",	"@ND",	"	     1390-03-26", "1392-10=06"]
      ],
      [self,
	"period:[室町時代]",
	["[明徳]3",	"",	"name=[後小松];1392-10=06^Japanese"],
	["[応永]1",	"@ND",	"	     1394-07-05",
				"name=[称光];1412-08-29", ""],
	["[正長]1",	"",	"	     1428-04-27"],
	["[永享]1",	"@A",	"name=[後花園];1429-09-05"],
	["[嘉吉]1",	"@IY",	"	     1441-02-17"],
	["[文安]1",	"@IY",	"	     1444-02-05"],
	["[宝徳]1",	"@ND",	"	     1449-07-28"],
	["[享徳]1",	"@ND",	"	     1452-07-25"],
	["[康正]1",	"@ND",	"	     1455-07-25"],
	["[長禄]1",	"@ND",	"	     1457-09-28"],
	["[寛正]1",	"@ND",	"	     1460-12-21"],
	["[文正]1",	"@A",	"name=[後土御門];1466-02-28"],
	["[応仁]1",	"@ND",	"	     1467-03-05"],
	["[文明]1",	"@ND",	"	     1469-04-28"],
	["[長享]1",	"@ND",	"	     1487-07-20"],
	["[延徳]1",	"@ND",	"	     1489-08-21"],
	["[明応]1",	"@ND",	"	     1492-07-19"],
	["[文亀]1",	"[代始・革年]",	"name=[後柏原];1501-02-29"],
	["[永正]1",	"@IY",	"	     1504-02-30"],
	["[大永]1",	"@ND",	"	     1521-08-23"],
	["[享禄]1",	"@A",	"name=[後奈良];1528-08-20"],
	["[天文]1",	"@ND",	"	     1532-07-29"],
	["[弘治]1",	"@ND",	"	     1555-10-23"],
	["[永禄]1",	"@A",	"name=[正親町];1558-02-28"],
	["[元亀]1",	"@ND",	"	     1570-04-23", "1573-07-28"]
      ],
      [self,
	"period:[安土桃山時代]",
	["[天正]1",	"@ND",	"	     1573-07-28^Japanese",
			      "name=[後陽成];1586-11-07", ""],
	["[文禄]1",	"@A",	"	     1592-12-08"],
	["[慶長]1",	"@ND",	"	     1596-10-27", "1603-02-12"]
      ],
      [self,
	"period:[江戸時代]",
	["[慶長]8",	"",	"name=[後陽成];1603-02-12^Japanese",
				"name=[後水尾];1611-03-27", ""],
	["[元和]1",	"[代始・災異]","     1615-07-13"],
	["[寛永]1",	"@IY",	"	     1624-02-30",
				"name=[明正];1629-11-08", ""],
	["[正保]1",	"@A",	"name=[後光明];1644-12-16"],
	["[慶安]1",	"",	"	     1648-02-15"],
	["[承応]1",	"",	"	     1652-09-18"],
	["[明暦]1",	"@A",	"name=[後西];1655-04-13"],
	["[万治]1",	"@ND",	"	     1658-07-23"],
	["[寛文]1",	"@ND",	"	     1661-04-25",
				"name=[霊元];1663-01-26", ""],
	["[延宝]1",	"@ND",	"	     1673-09-21"],
	["[天和]1",	"@IY",	"	     1681-09-29"],
	["[貞享]1",	"@IY",	"	     1684-02-21"],
	["[元禄]1",	"@A",	"name=[東山];1688-09-30"],
	["[宝永]1",	"@ND",	"	     1704-03-13"],
	["[正徳]1",	"@A",	"name=[中御門];1711-04-25"],
	["[享保]1",	"[関東凶事]","	     1716-06-22"],
	["[元文]1",	"@A",	"name=[桜町];1736-04-28"],
	["[寛保]1",	"@IY",	"	     1741-02-27"],
	["[延享]1",	"@IY",	"	     1744-02-21"],
	["[寛延]1",	"@A",	"name=[桃園];1748-07-12"],
	["[宝暦]1",	"",	"	     1751-10-27"],
	["[明和]1",	"@A",	"name=[後桜町];1764-06-02"],
	["[安永]1",	"[代始・災異]",	"name=[後桃園];1772-11-16"],
	["[天明]1",	"@A",	"name=[光格];1781-04-02"],
	["[寛政]1",	"@ND",	"	     1789-01-25"],
	["[享和]1",	"@IY",	"	     1801-02-05"],
	["[文化]1",	"@IY",	"	     1804-02-11"],
	["[文政]1",	"@A",	"name=[仁孝];1818-04-22"],
	["[天保]1",	"@ND",	"	     1830-12-10"],
	["[弘化]1",	"@ND",	"	     1844-12-02"],
	["[嘉永]1",	"@A",	"name=[孝明];1848-02-28"],
	["[安政]1",	"@ND",	"	     1854-11-27"],
	["[万延]1",	"@ND",	"	     1860-03-18"],
	["[文久]1",	"@IY",	"	     1861-02-19"],
	["[元治]1",	"@IY",	"	     1864-02-20"],
	["[慶応]1",	"@ND",	"	     1865-04-08", "1868-09-08"]
      ],
      ["[明治,Meiji=en:Meiji_period,M]1",		"@A",
				"name=[明治天皇,Emperor_Meiji];1868-09-08^Japanese", "1873-01-01^Gregorian?note=JapaneseNote", ""],
      ["[大正,Taishō=en:Taish%C5%8D_period,T]1.07.30",  "@A",
				"name=[大正天皇,Emperor_Taishō];1912-07-30"],
      ["[昭和,Shōwa=en:Sh%C5%8Dwa_period,S]1.12.25",    "@A",
				"name=[昭和天皇,Emperor_Shōwa];1926-12-25"],
      ["[平成,Heisei=en:Heisei_period,H]1.01.08",       "@A",
				"name=[今上天皇=ja:%%<明仁>,Emperor_Kinjō=en:Akihito];1989-01-08"]
    ]]

    #
    # 日本の総理大臣
    #
    JapanesePrimeMinister = [self, [
      "namespace:[ja=http://ja.wikipedia.org/wiki/, en=http://en.wikipedia.org/wiki/]",
      "locale:[=ja:, en=en:, alias]",
      "area:[日本,Japan]",
      ["伊藤博文1.12.22",      "@A", "name=[明治天皇,Emperor_Meiji];1885-12-22^Gregorian"],
      ["黒田清隆1.04.30",      "@A", "1888-04-30"],
      ["山県有明1.12.24",      "@A", "1889-12-24"],
      ["松方正義1.05.06",      "@A", "1891-05-06"],
      ["伊藤博文･再1.08.08",   "@A", "1892-08-08"],
      ["松方正義･再1.09.18",   "@A", "1896-09-18"],
      ["伊藤博文･三1.01.12",   "@A", "1898-01-12"],
      ["大隈重信1.06.30",      "@A", "1898-06-30"],
      ["山県有明･再1.11.08",   "@A", "1898-11-08"],
      ["伊藤博文･四1.10.19",   "@A", "1900-10-19"],
      ["桂太郎1.06.02",        "@A", "1901-06-02"],
      ["西園寺公望1.01.07",    "@A", "1906-01-07"],
      ["桂太郎･再1.07.14",     "@A", "1908-07-14"],
      ["西園寺公望･再1.08.30", "@A", "1911-08-30", "name=[大正天皇,Emperor_Taishō];1912-07-30", ""],
      ["桂太郎･三1.12.21",     "@A", "1912-12-21"],
      ["山本権兵衛1.02.20",    "@A", "1913-02-20"],
      ["大隈重信･再1.04.16",   "@A", "1914-04-16"],
      ["寺内正毅1.10.09",      "@A", "1916-10-09"],
      ["原敬1.09.29",          "@A", "1918-09-29"],
      ["高橋是清1.11.13",      "@A", "1921-11-13"],
      ["加藤友三郎1.06.12",    "@A", "1922-06-12"],
      ["山本権兵衛･再1.09.02", "@A", "1923-09-02"],
      ["清浦奎吾1.01.07",      "@A", "1924-01-07"],
      ["加藤高明1.06.11",      "@A", "1924-06-11"],
      ["若槻礼次郎1.01.30",    "@A", "1926-01-30","name=[昭和天皇,Emperor_Shōwa];1926-12-25", ""],
      ["田中義一1.04.20",      "@A", "1927-04-20"],
      ["浜口雄幸1.07.02",      "@A", "1929-07-02"],
      ["若槻礼次郎･再1.04.14", "@A", "1931-04-14"],
      ["犬養毅1.12.13",        "@A", "1931-12-13"],
      ["斎藤実1.05.26",        "@A", "1932-05-26"],
      ["岡田啓介1.07.08",      "@A", "1934-07-08"],
      ["広田弘毅1.03.09",      "@A", "1936-03-09"],
      ["林銑十郎1.02.02",      "@A", "1937-02-02"],
      ["近衛文磨1.06.04",      "@A", "1937-06-04"],
      ["平沼騏一郎1.01.05",    "@A", "1939-01-05"],
      ["阿部信行1.08.30",      "@A", "1939-08-30"],
      ["米内光政1.01.16",      "@A", "1940-01-16"],
      ["近衛文磨･再1.07.22",   "@A", "1940-07-22"],
      ["東条英機1.10.18",      "@A", "1941-10-18"],
      ["小磯国昭1.07.22",      "@A", "1944-07-22"],
      ["鈴木貫太郎1.04.07",    "@A", "1945-04-07"],
      ["東久迩宮稔彦王1.08.17","@A", "1945-08-17"],
      ["幣原喜重郎1.10.09",    "@A", "1945-10-09"],
      ["吉田茂1.05.22",        "@A", "1946-05-22"],
      ["片山哲1.05.24",        "@A", "1947-05-24"],
      ["芦田均1.03.10",        "@A", "1948-03-10"],
      ["吉田茂･再1.10.19",     "@A", "1948-10-19"],
      ["鳩山一郎1.12.10",      "@A", "1954-12-10"],
      ["石橋湛山1.12.23",      "@A", "1956-12-23"],
      ["岸信介1.02.25",        "@A", "1957-02-25"],
      ["池田勇人1.07.19",      "@A", "1960-07-19"],
      ["佐藤栄作1.11.09",      "@A", "1964-11-09"],
      ["田中角栄1.07.07",      "@A", "1972-07-07"],
      ["三木武夫1.12.09",      "@A", "1974-12-09"],
      ["福田赳夫1.12.24",      "@A", "1976-12-24"],
      ["大平正芳1.12.07",      "@A", "1978-12-07"],
      ["鈴木善幸1.07.17",      "@A", "1980-07-17"],
      ["中曽根康弘1.11.27",    "@A", "1982-11-27"],
      ["竹下登1.11.06",        "@A", "1987-11-06",
                     "name=[今上天皇=ja:%%<明仁>,Emperor_Kinjō=en:Akihito];1989-01-08", ""],
      ["宇野宗佑1.06.03",      "@A", "1989-06-03"],
      ["海部俊樹1.08.10",      "@A", "1989-08-10"],
      ["宮沢喜一1.11.05",      "@A", "1991-11-05"],
      ["細川護熙1.08.09",      "@A", "1993-08-09"],
      ["羽田孜1.04.28",        "@A", "1994-04-28"],
      ["村山富市1.06.30",      "@A", "1994-06-30"],
      ["橋本龍太郎1.01.11",    "@A", "1996-01-11"],
      ["小渕恵三1.07.30",      "@A", "1998-07-30"],
      ["森喜朗1.04.05",        "@A", "2000-04-05"],
      ["小泉純一郎1.04.26",    "@A", "2001-04-26"],
      ["安倍晋三1.09.26",      "@A", "2006-09-26"],
      ["福田康夫1.09.26",      "@A", "2007-09-26"],
      ["麻生太郎1.09.24",      "@A", "2008-09-24"],
      ["鳩山由紀夫1.09.16",    "@A", "2009-09-16"],
      ["菅直人1.06.08",        "@A", "2010-06-08"],
      ["野田佳彦1.09.02",      "@A", "2011-09-02"],
      ["安倍晋三･再1.12.26",   "@A", "2012-12-26"]
    ]]
  end
end
