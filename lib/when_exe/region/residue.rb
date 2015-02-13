# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2015 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::Coordinates

  # 十干
  class Stem       < Residue; end

  # 十二支
  class Branch     < Residue; end

  # 六十干支
  class StemBranch < Residue; end

  # 九星
  class Kyusei     < Residue; end

  # Common Residue
  Common = [{'V'=>{'0618'=>{'A'=>'Awakening Of Insects=en:Jingzhe,  *啓蟄,驚蟄',
                            'B'=>'Rain Water=en:Yushui_(solar_term),*雨水,雨水'}}}, When::BasicTypes::M17n, [
    "locale:[=en:, ja=ja:, zh=zh:, tenreki, tibetan, yi, alias]",
    "names:[Common]",

    [Residue,
      "label:[Week, 週]", "divisor:7", "day:0",
      [Residue, "label:[Monday,    月曜日, /date/day_names/1]", "remainder:0"],
      [Residue, "label:[Tuesday,   火曜日, /date/day_names/2]", "remainder:1"],
      [Residue, "label:[Wednesday, 水曜日, /date/day_names/3]", "remainder:2"],
      [Residue, "label:[Thursday,  木曜日, /date/day_names/4]", "remainder:3"],
      [Residue, "label:[Friday,    金曜日, /date/day_names/5]", "remainder:4"],
      [Residue, "label:[Saturday,  土曜日, /date/day_names/6]", "remainder:5"],
      [Residue, "label:[Sunday,    日曜日, /date/day_names/0]", "remainder:6"]
    ],

    [When::BasicTypes::M17n,
      "names:[Abbr_Day=, 週日略称=]",
      "[Mon, 月, /date/abbr_day_names/1] ",
      "[Tue, 火, /date/abbr_day_names/2] ",
      "[Wed, 水, /date/abbr_day_names/3] ",
      "[Thu, 木, /date/abbr_day_names/4] ",
      "[Fri, 金, /date/abbr_day_names/5] ",
      "[Sat, 土, /date/abbr_day_names/6] ",
      "[Sun, 日, /date/abbr_day_names/0] "
    ],

    [Residue,
      "locale:[=en:, ja=ja:, zh=zh:, alias]",
      "label:[LunarMansion=en:Lunar_mansion, *宿=ja:%%<月宿>]", "divisor:28", "day:17",   "format:[%s(%02d)=]",
      [Residue, "label:[Horn=,            *角宿, 角宿,  Jiăo= ]", "remainder:0"],  #  1 α Vir 
      [Residue, "label:[Neck=,            *亢宿, 亢宿,  Kàng= ]", "remainder:1"],  #  2 κ Vir 
      [Residue, "label:[Root=,            *氐宿, 氐宿,  Dĭ=   ]", "remainder:2"],  #  3 α Lib 
      [Residue, "label:[Room=,            *房宿, 房宿,  Fáng= ]", "remainder:3"],  #  4 π Sco 
      [Residue, "label:[Heart=,           *心宿, 心宿,  Xīn=  ]", "remainder:4"],  #  5 σ Sco 
      [Residue, "label:[Tail=,            *尾宿, 尾宿,  Wěi=  ]", "remainder:5"],  #  6 μ Sco 
      [Residue, "label:[WinnowingBasket=, *箕宿, 箕宿,  Jī=   ]", "remainder:6"],  #  7 γ Sgr 
      [Residue, "label:[SouthernDipper=,  *斗宿, 斗宿,  Dǒu= ]", "remainder:7"],  #  8 φ Sgr 
      [Residue, "label:[Ox=,              *牛宿, 牛宿,  Niú=  ]", "remainder:8"],  #  9 β Cap 
      [Residue, "label:[Girl=,            *女宿, 女宿,  Nǚ=  ]", "remainder:9"],  # 10 ε Aqr 
      [Residue, "label:[Emptiness=, *虛宿=ja:%%<虚宿>,虚宿,Xū=]", "remainder:10"], # 11 β Aqr 
      [Residue, "label:[Rooftop=,         *危宿, 危宿,  Wēi=  ]", "remainder:11"], # 12 α Aqr 
      [Residue, "label:[Encampment=,      *室宿, 室宿,  Shì=  ]", "remainder:12"], # 13 α Peg 
      [Residue, "label:[Wall=,            *壁宿, 壁宿,  Bì=   ]", "remainder:13"], # 14 γ Peg 
      [Residue, "label:[Legs=,            *奎宿, 奎宿,  Kuí=  ]", "remainder:14"], # 15 η And 
      [Residue, "label:[Bond=,            *婁宿, 婁宿,  Lóu=  ]", "remainder:15"], # 16 β Ari 
      [Residue, "label:[Stomach=,         *胃宿, 胃宿,  Wèi=  ]", "remainder:16"], # 17 35 Ari 
      [Residue, "label:[HairyHead=,       *昴宿, 昴宿,  Mǎo= ]", "remainder:17"], # 18 17 Tau 
      [Residue, "label:[Net=,             *畢宿, 畢宿,  Bì=   ]", "remainder:18"], # 19 ε Tau 
      [Residue, "label:[TurtleBeak=,      *觜宿, 觜宿,  Zī=   ]", "remainder:19"], # 20 λ Ori 
      [Residue, "label:[ThreeStars=,*參宿=ja:%%<参宿>,参宿,Shēn=]","remainder:20"],# 21 ζ Ori 
      [Residue, "label:[Well=,            *井宿, 井宿,  Jǐng=]", "remainder:21"], # 22 μ Gem 
      [Residue, "label:[Ghost=,           *鬼宿, 鬼宿,  Guǐ= ]", "remainder:22"], # 23 θ Cnc 
      [Residue, "label:[Willow=,          *柳宿, 柳宿,  Liǔ= ]", "remainder:23"], # 24 δ Hya 
      [Residue, "label:[Star=,            *星宿, 星宿,  Xīng= ]", "remainder:24"], # 25 α Hya 
      [Residue, "label:[ExtendedNet=,     *張宿, 張宿,  Zhāng=]", "remainder:25"], # 26 υ¹ Hya
      [Residue, "label:[Wings=,           *翼宿, 翼宿,  Yì=   ]", "remainder:26"], # 27 α Crt 
      [Residue, "label:[Chariot=,         *軫宿, 軫宿,  Zhěn= ]", "remainder:27"]  # 28 γ Crv 
    ],

    [Stem,
      "label:[Stem=en:Celestial_stem, *干=ja:%%<十干>]", "divisor:10", "day:11", "year:4",
      [Stem, "label:[Wood-yang=,  *甲, 甲, 甲=, 木男=, 木公=]", "remainder:0"],
      [Stem, "label:[Wood-yin=,   *乙, 乙, 乙=, 木女=, 木母=]", "remainder:1"],
      [Stem, "label:[Fire-yang=,  *丙, 丙, 丙=, 火男=, 火公=]", "remainder:2"],
      [Stem, "label:[Fire-yin=,   *丁, 丁, 丁=, 火女=, 火母=]", "remainder:3"],
      [Stem, "label:[Erath-yang=, *戊, 戊, 戊=, 土男=, 土公=]", "remainder:4"],
      [Stem, "label:[Erath-yin=,  *己, 己, 己=, 土女=, 土母=]", "remainder:5"],
      [Stem, "label:[Metal-yang=, *庚, 庚, 庚=, 金男=, 銅公=]", "remainder:6"],
      [Stem, "label:[Metal-yin=,  *辛, 辛, 辛=, 金女=, 銅母=]", "remainder:7"],
      [Stem, "label:[Water-yang=, *壬, 壬, 壬=, 水男=, 水公=]", "remainder:8"],
      [Stem, "label:[Water-yin=,  *癸, 癸, 癸=, 水女=, 水母=]", "remainder:9"]
    ],

    [Branch,
      "label:[Branch=en:Earthly_Branches, *支=ja:%%<十二支>]", "divisor:12", "day:11", "year:4",
      [Branch, "label:[Rat=,     *子, 子, 子=, 鼠=, 鼠=]", "remainder: 0"],
      [Branch, "label:[Ox=,      *丑, 丑, 好=, 牛=, 牛=]", "remainder: 1"],
      [Branch, "label:[Tiger=,   *寅, 寅, 寅=, 虎=, 虎=]", "remainder: 2"],
      [Branch, "label:[Rabbit=,  *卯, 卯, 栄=, 兎=, 兎=]", "remainder: 3"],
      [Branch, "label:[Dragon=,  *辰, 辰, 辰=, 龍=, 龍=]", "remainder: 4"],
      [Branch, "label:[Snake=,   *巳, 巳, 巳=, 蛇=, 蛇=]", "remainder: 5"],
      [Branch, "label:[Horse=,   *午, 午, 午=, 馬=, 馬=]", "remainder: 6"],
      [Branch, "label:[Goat=,    *未, 未, 未=, 羊=, 羊=]", "remainder: 7"],
      [Branch, "label:[Monkey=,  *申, 申, 申=, 猴=, 猴=]", "remainder: 8"],
      [Branch, "label:[Rooster=, *酉, 酉, 酉=, 鷄=, 鷄=]", "remainder: 9"],
      [Branch, "label:[Dog=,     *戌, 戌, 戌=, 狗=, 狗=]", "remainder:10"],
      [Branch, "label:[Pig=,     *亥, 亥, 開=, 猪=, 猪=]", "remainder:11"]
    ],

    [StemBranch,
      "label:[Stem-Branch=en:Sexagenary_cycle, *干支]", "divisor:60", "day:11", "year:4", "format:[%s(%02d)=]",
      [StemBranch, "label:[Wood-yang-Rat=,     *甲子, 甲子, 甲子=, 木男鼠=, 木公鼠=]", "remainder: 0"],
      [StemBranch, "label:[Wood-yin-Ox=,       *乙丑, 乙丑, 乙好=, 木女牛=, 木母牛=]", "remainder: 1"],
      [StemBranch, "label:[Fire-yang-Tiger=,   *丙寅, 丙寅, 丙寅=, 火男虎=, 火公虎=]", "remainder: 2"],
      [StemBranch, "label:[Fire-yin-Rabbit=,   *丁卯, 丁卯, 丁栄=, 火女兎=, 火母兎=]", "remainder: 3"],
      [StemBranch, "label:[Erath-yang-Dragon=, *戊辰, 戊辰, 戊辰=, 土男龍=, 土公龍=]", "remainder: 4"],
      [StemBranch, "label:[Erath-yin-Snake=,   *己巳, 己巳, 己巳=, 土女蛇=, 土母蛇=]", "remainder: 5"],
      [StemBranch, "label:[Metal-yang-Horse=,  *庚午, 庚午, 庚午=, 金男馬=, 銅公馬=]", "remainder: 6"],
      [StemBranch, "label:[Metal-yin-Goat=,    *辛未, 辛未, 辛未=, 金女羊=, 銅母羊=]", "remainder: 7"],
      [StemBranch, "label:[Water-yang-Monkey=, *壬申, 壬申, 壬申=, 水男猴=, 水公猴=]", "remainder: 8"],
      [StemBranch, "label:[Water-yin-Rooster=, *癸酉, 癸酉, 癸酉=, 水女鷄=, 水母鷄=]", "remainder: 9"],
      [StemBranch, "label:[Wood-yang-Dog=,     *甲戌, 甲戌, 甲戌=, 木男狗=, 木公狗=]", "remainder:10"],
      [StemBranch, "label:[Wood-yin-Pig=,      *乙亥, 乙亥, 乙開=, 木女猪=, 木母猪=]", "remainder:11"],
      [StemBranch, "label:[Fire-yang-Rat=,     *丙子, 丙子, 丙子=, 火男鼠=, 火公鼠=]", "remainder:12"],
      [StemBranch, "label:[Fire-yin-Ox=,       *丁丑, 丁丑, 丁好=, 火女牛=, 火母牛=]", "remainder:13"],
      [StemBranch, "label:[Erath-yang-Tiger=,  *戊寅, 戊寅, 戊寅=, 土男虎=, 土公虎=]", "remainder:14"],
      [StemBranch, "label:[Erath-yin-Rabbit=,  *己卯, 己卯, 己栄=, 土女兎=, 土母兎=]", "remainder:15"],
      [StemBranch, "label:[Metal-yang-Dragon=, *庚辰, 庚辰, 庚辰=, 金男龍=, 銅公龍=]", "remainder:16"],
      [StemBranch, "label:[Metal-yin-Snake=,   *辛巳, 辛巳, 辛巳=, 金女蛇=, 銅母蛇=]", "remainder:17"],
      [StemBranch, "label:[Water-yang-Horse=,  *壬午, 壬午, 壬午=, 水男馬=, 水公馬=]", "remainder:18"],
      [StemBranch, "label:[Water-yin-Goat=,    *癸未, 癸未, 癸未=, 水女羊=, 水母羊=]", "remainder:19"],
      [StemBranch, "label:[Wood-yang-Monkey=,  *甲申, 甲申, 甲申=, 木男猴=, 木公猴=]", "remainder:20"],
      [StemBranch, "label:[Wood-yin-Rooster=,  *乙酉, 乙酉, 乙酉=, 木女鷄=, 木母鷄=]", "remainder:21"],
      [StemBranch, "label:[Fire-yang-Dog=,     *丙戌, 丙戌, 丙戌=, 火男狗=, 火公狗=]", "remainder:22"],
      [StemBranch, "label:[Fire-yin-Pig=,      *丁亥, 丁亥, 丁開=, 火女猪=, 火母猪=]", "remainder:23"],
      [StemBranch, "label:[Erath-yang-Rat=,    *戊子, 戊子, 戊子=, 土男鼠=, 土公鼠=]", "remainder:24"],
      [StemBranch, "label:[Erath-yin-Ox=,      *己丑, 己丑, 己好=, 土女牛=, 土母牛=]", "remainder:25"],
      [StemBranch, "label:[Metal-yang-Tiger=,  *庚寅, 庚寅, 庚寅=, 金男虎=, 銅公虎=]", "remainder:26"],
      [StemBranch, "label:[Metal-yin-Rabbit=,  *辛卯, 辛卯, 辛栄=, 金女兎=, 銅母兎=]", "remainder:27"],
      [StemBranch, "label:[Water-yang-Dragon=, *壬辰, 壬辰, 壬辰=, 水男龍=, 水公龍=]", "remainder:28"],
      [StemBranch, "label:[Water-yin-Snake=,   *癸巳, 癸巳, 癸巳=, 水女蛇=, 水母蛇=]", "remainder:29"],
      [StemBranch, "label:[Wood-yang-Horse=,   *甲午, 甲午, 甲午=, 木男馬=, 木公馬=]", "remainder:30"],
      [StemBranch, "label:[Wood-yin-Goat=,     *乙未, 乙未, 乙未=, 木女羊=, 木母羊=]", "remainder:31"],
      [StemBranch, "label:[Fire-yang-Monkey=,  *丙申, 丙申, 丙申=, 火男猴=, 火公猴=]", "remainder:32"],
      [StemBranch, "label:[Fire-yin-Rooster=,  *丁酉, 丁酉, 丁酉=, 火女鷄=, 火母鷄=]", "remainder:33"],
      [StemBranch, "label:[Erath-yang-Dog=,    *戊戌, 戊戌, 戊戌=, 土男狗=, 土公狗=]", "remainder:34"],
      [StemBranch, "label:[Erath-yin-Pig=,     *己亥, 己亥, 己開=, 土女猪=, 土母猪=]", "remainder:35"],
      [StemBranch, "label:[Metal-yang-Rat=,    *庚子, 庚子, 庚子=, 金男鼠=, 銅公鼠=]", "remainder:36"],
      [StemBranch, "label:[Metal-yin-Ox=,      *辛丑, 辛丑, 辛好=, 金女牛=, 銅母牛=]", "remainder:37"],
      [StemBranch, "label:[Water-yang-Tiger=,  *壬寅, 壬寅, 壬寅=, 水男虎=, 水公虎=]", "remainder:38"],
      [StemBranch, "label:[Water-yin-Rabbit=,  *癸卯, 癸卯, 癸栄=, 水女兎=, 水母兎=]", "remainder:39"],
      [StemBranch, "label:[Wood-yang-Dragon=,  *甲辰, 甲辰, 甲辰=, 木男龍=, 木公龍=]", "remainder:40"],
      [StemBranch, "label:[Wood-yin-Snake=,    *乙巳, 乙巳, 乙巳=, 木女蛇=, 木母蛇=]", "remainder:41"],
      [StemBranch, "label:[Fire-yang-Horse=,   *丙午, 丙午, 丙午=, 火男馬=, 火公馬=]", "remainder:42"],
      [StemBranch, "label:[Fire-yin-Goat=,     *丁未, 丁未, 丁未=, 火女羊=, 火母羊=]", "remainder:43"],
      [StemBranch, "label:[Erath-yang-Monkey=, *戊申, 戊申, 戊申=, 土男猴=, 土公猴=]", "remainder:44"],
      [StemBranch, "label:[Erath-yin-Rooster=, *己酉, 己酉, 己酉=, 土女鷄=, 土母鷄=]", "remainder:45"],
      [StemBranch, "label:[Metal-yang-Dog=,    *庚戌, 庚戌, 庚戌=, 金男狗=, 銅公狗=]", "remainder:46"],
      [StemBranch, "label:[Metal-yin-Pig=,     *辛亥, 辛亥, 辛開=, 金女猪=, 銅母猪=]", "remainder:47"],
      [StemBranch, "label:[Water-yang-Rat=,    *壬子, 壬子, 壬子=, 水男鼠=, 水公鼠=]", "remainder:48"],
      [StemBranch, "label:[Water-yin-Ox=,      *癸丑, 癸丑, 癸好=, 水女牛=, 水母牛=]", "remainder:49"],
      [StemBranch, "label:[Wood-yang-Tiger=,   *甲寅, 甲寅, 甲寅=, 木男虎=, 木公虎=]", "remainder:50"],
      [StemBranch, "label:[Wood-yin-Rabbit=,   *乙卯, 乙卯, 乙栄=, 木女兎=, 木母兎=]", "remainder:51"],
      [StemBranch, "label:[Fire-yang-Dragon=,  *丙辰, 丙辰, 丙辰=, 火男龍=, 火公龍=]", "remainder:52"],
      [StemBranch, "label:[Fire-yin-Snake=,    *丁巳, 丁巳, 丁巳=, 火女蛇=, 火母蛇=]", "remainder:53"],
      [StemBranch, "label:[Erath-yang-Horse=,  *戊午, 戊午, 戊午=, 土男馬=, 土公馬=]", "remainder:54"],
      [StemBranch, "label:[Erath-yin-Goat=,    *己未, 己未, 己未=, 土女羊=, 土母羊=]", "remainder:55"],
      [StemBranch, "label:[Metal-yang-Monkey=, *庚申, 庚申, 庚申=, 金男猴=, 銅公猴=]", "remainder:56"],
      [StemBranch, "label:[Metal-yin-Rooster=, *辛酉, 辛酉, 辛酉=, 金女鷄=, 銅母鷄=]", "remainder:57"],
      [StemBranch, "label:[Water-yang-Dog=,    *壬戌, 壬戌, 壬戌=, 水男狗=, 水公狗=]", "remainder:58"],
      [StemBranch, "label:[Water-yin-Pig=,     *癸亥, 癸亥, 癸開=, 水女猪=, 水母猪=]", "remainder:59"]
    ],

    [Kyusei,
      "locale:[=en:, ja=ja:, zh=ja:]",
      "label:[Kyusei=, *九星, 九星]", "divisor:9", "year:7",
      [Kyusei, "label:[9-Purple-Fire=,  *九紫火星, 九紫火星]", "remainder:0"],
      [Kyusei, "label:[8-White-Earth=,  *八白土星, 八白土星]", "remainder:1"],
      [Kyusei, "label:[7-Red-Metal=,    *七赤金星, 七赤金星]", "remainder:2"],
      [Kyusei, "label:[6-White-Metal=,  *六白金星, 六白金星]", "remainder:3"],
      [Kyusei, "label:[5-Yellow-Earth=, *五黄土星, 五黄土星]", "remainder:4"],
      [Kyusei, "label:[4-Green-Wood=,   *四緑木星, 四緑木星]", "remainder:5"],
      [Kyusei, "label:[3-Blue-Wood=,    *三碧木星, 三碧木星]", "remainder:6"],
      [Kyusei, "label:[2-Black-Earth=,  *二黒土星, 二黒土星]", "remainder:7"],
      [Kyusei, "label:[1-White-Water=,  *一白水星, 一白水星]", "remainder:8"]
    ],

    [Residue,
      "locale:[=en:, ja=ja:, zh=zh:, alias]",
      "label:[SolarTerm=en:Solar_term, *二十四節気, 節気=zh:%%<节气>]", "divisor:360",
      [Residue, "label:[Vernal Equinox=en:Chunfen,                 *春分, 春分, 二月中=]  ", "remainder:0"  ],
      [Residue, "label:[Clear And Bright=en:Qingming,              *清明, 清明, 三月節=]  ", "remainder:15" ],
      [Residue, "label:[Grain Rain=en:Guyu,                        *穀雨, 穀雨, 三月中=]  ", "remainder:30" ],
      [Residue, "label:[Start Of Summer=en:Lixia,                  *立夏, 立夏, 四月節=]  ", "remainder:45" ],
      [Residue, "label:[Grain Full=en:Xiaoman,                     *小満, 小満, 四月中=]  ", "remainder:60" ],
      [Residue, "label:[Grain In Ear=en:Mangzhong,                 *芒種, 芒種, 五月節=]  ", "remainder:75" ],
      [Residue, "label:[Summer Solstice=en:Xiazhi,                 *夏至, 夏至, 五月中=]  ", "remainder:90" ],
      [Residue, "label:[Minor Heat=en:Xiaoshu,                     *小暑, 小暑, 六月節=]  ", "remainder:105"],
      [Residue, "label:[Major Heat=en:Dashu,                       *大暑, 大暑, 六月中=]  ", "remainder:120"],
      [Residue, "label:[Start Of Autumn=en:Liqiu,                  *立秋, 立秋, 七月節=]  ", "remainder:135"],
      [Residue, "label:[Limit Of Heat=en:Chushu,        *処暑, 処暑=zh:%%<处暑>,七月中=]  ", "remainder:150"],
      [Residue, "label:[White Dew=en:Bailu,                        *白露, 白露, 八月節=]  ", "remainder:165"],
      [Residue, "label:[Autumnal Equinox=en:Qiufen,                *秋分, 秋分, 八月中=]  ", "remainder:180"],
      [Residue, "label:[Cold Dew=en:Hanlu,                         *寒露, 寒露, 九月節=]  ", "remainder:195"],
      [Residue, "label:[Frost Descent=en:Shuangjiang_(solar_term), *霜降, 霜降, 九月中=]  ", "remainder:210"],
      [Residue, "label:[Start Of Winter=en:Lidong,                 *立冬, 立冬, 十月節=]  ", "remainder:225"],
      [Residue, "label:[Minor Snow=en:Xiaoxue,                     *小雪, 小雪, 十月中=]  ", "remainder:240"],
      [Residue, "label:[Major Snow=en:Daxue_(solar_term),          *大雪, 大雪, 十一月節=]", "remainder:255"],
      [Residue, "label:[Winter Solstice=en:Dongzhi_(solar_term),   *冬至, 冬至, 十一月中=]", "remainder:270"],
      [Residue, "label:[Minor Cold=en:Xiaohan,                     *小寒, 小寒, 十二月節=]", "remainder:285"],
      [Residue, "label:[Major Cold=en:Dahan_(solar_term),          *大寒, 大寒, 十二月中=]", "remainder:300"],
      [Residue, "label:[Start Of Spring=en:Lichun,                 *立春, 立春, 正月節=]  ", "remainder:315"],
      [Residue, 'label:[#{A:Rain Water=en:Yushui_(solar_term),     *雨水, 雨水},正月中=]  ', "remainder:330"], # 戊寅・儀鳳暦では啓蟄
      [Residue, 'label:[#{B:Awakening Of Insects=en:Jingzhe,       *啓蟄, 驚蟄},二月節=]  ', "remainder:345"]  # 戊寅・儀鳳暦では雨水
    ],

    [Residue,
      "locale:[=en:, ja=ja:, zh=zh:]",
      "label:[LunarPhase=en:Lunar_phase,     *月相, 月相]",   "divisor:360",
      [Residue, "label:[New_moon=,           *朔,   朔    ]", "remainder:0"  ],
      [Residue, "label:[First_quarter_moon=, *上弦, 上弦月]", "remainder:90" ],
      [Residue, "label:[Full_moon=,          *望,   望    ]", "remainder:180"],
      [Residue, "label:[Third_quarter_moon=, *下弦, 下弦月]", "remainder:270"]
    ]
  ]]
end
