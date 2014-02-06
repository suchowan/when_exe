# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2014 Takashi SUGA

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
  CommonResidue = [{'V'=>{'0618'=>{'A'=>'awakening_of_insects=,*啓蟄',
                                   'B'=>'rain_water=,*雨水'}}}, When::BasicTypes::M17n, [
    "namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/]",
    "locale:[=en:, ja=ja:, tenreki, tibetan, yi, alias]",
    "names:[CommonResidue]",

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
      "names:[Abbr_Day, 週日略称]",
      "[Mon, 月, /date/abbr_day_names/1] ",
      "[Tue, 火, /date/abbr_day_names/2] ",
      "[Wed, 水, /date/abbr_day_names/3] ",
      "[Thu, 木, /date/abbr_day_names/4] ",
      "[Fri, 金, /date/abbr_day_names/5] ",
      "[Sat, 土, /date/abbr_day_names/6] ",
      "[Sun, 日, /date/abbr_day_names/0] "
    ],

    [Residue,
      "locale:[=en:, ja=ja:, alias]",
      "label:[StarMansion, *宿]", "divisor:28", "day:17",   "format:[%s(%02d)]",
      [Residue, "label:[Horn=,            *角宿,  Jiăo= ]", "remainder:0"],  #  1 α Vir 
      [Residue, "label:[Neck=,            *亢宿,  Kàng= ]", "remainder:1"],  #  2 κ Vir 
      [Residue, "label:[Root=,            *氐宿,  Dĭ=   ]", "remainder:2"],  #  3 α Lib 
      [Residue, "label:[Room=,            *房宿,  Fáng= ]", "remainder:3"],  #  4 π Sco 
      [Residue, "label:[Heart=,           *心宿,  Xīn=  ]", "remainder:4"],  #  5 σ Sco 
      [Residue, "label:[Tail=,            *尾宿,  Wěi=  ]", "remainder:5"],  #  6 μ Sco 
      [Residue, "label:[WinnowingBasket=, *箕宿,  Jī=   ]", "remainder:6"],  #  7 γ Sgr 
      [Residue, "label:[SouthernDipper=,  *斗宿,  Dǒu= ]", "remainder:7"],  #  8 φ Sgr 
      [Residue, "label:[Ox=,              *牛宿,  Niú=  ]", "remainder:8"],  #  9 β Cap 
      [Residue, "label:[Girl=,            *女宿,  Nǚ=  ]", "remainder:9"],  # 10 ε Aqr 
      [Residue, "label:[Emptiness=,       *虛宿,  Xū=   ]", "remainder:10"], # 11 β Aqr 
      [Residue, "label:[Rooftop=,         *危宿,  Wēi=  ]", "remainder:11"], # 12 α Aqr 
      [Residue, "label:[Encampment=,      *室宿,  Shì=  ]", "remainder:12"], # 13 α Peg 
      [Residue, "label:[Wall=,            *壁宿,  Bì=   ]", "remainder:13"], # 14 γ Peg 
      [Residue, "label:[Legs=,            *奎宿,  Kuí=  ]", "remainder:14"], # 15 η And 
      [Residue, "label:[Bond=,            *婁宿,  Lóu=  ]", "remainder:15"], # 16 β Ari 
      [Residue, "label:[Stomach=,         *胃宿,  Wèi=  ]", "remainder:16"], # 17 35 Ari 
      [Residue, "label:[HairyHead=,       *昴宿,  Mǎo= ]", "remainder:17"], # 18 17 Tau 
      [Residue, "label:[Net=,             *畢宿,  Bì=   ]", "remainder:18"], # 19 ε Tau 
      [Residue, "label:[TurtleBeak=,      *觜宿,  Zī=   ]", "remainder:19"], # 20 λ Ori 
      [Residue, "label:[ThreeStars=,      *參宿,  Shēn= ]", "remainder:20"], # 21 ζ Ori 
      [Residue, "label:[Well=,            *井宿,  Jǐng=]", "remainder:21"], # 22 μ Gem 
      [Residue, "label:[Ghost=,           *鬼宿,  Guǐ= ]", "remainder:22"], # 23 θ Cnc 
      [Residue, "label:[Willow=,          *柳宿,  Liǔ= ]", "remainder:23"], # 24 δ Hya 
      [Residue, "label:[Star=,            *星宿,  Xīng= ]", "remainder:24"], # 25 α Hya 
      [Residue, "label:[ExtendedNet=,     *張宿,  Zhāng=]", "remainder:25"], # 26 υ¹ Hya
      [Residue, "label:[Wings=,           *翼宿,  Yì=   ]", "remainder:26"], # 27 α Crt 
      [Residue, "label:[Chariot=,         *軫宿,  Zhěn= ]", "remainder:27"]  # 28 γ Crv 
    ],

    [Stem,
      "label:[Stem, *干]", "divisor:10", "day:11", "year:4",
      [Stem, "label:[kinoe,      *甲, 甲, 木男, 木公]", "remainder:0"],
      [Stem, "label:[kinoto,     *乙, 乙, 木女, 木母]", "remainder:1"],
      [Stem, "label:[hinoe,      *丙, 丙, 火男, 火公]", "remainder:2"],
      [Stem, "label:[hinoto,     *丁, 丁, 火女, 火母]", "remainder:3"],
      [Stem, "label:[tsuchinoe,  *戊, 戊, 土男, 土公]", "remainder:4"],
      [Stem, "label:[tsuchinoto, *己, 己, 土女, 土母]", "remainder:5"],
      [Stem, "label:[kanoe,      *庚, 庚, 金男, 銅公]", "remainder:6"],
      [Stem, "label:[kanoto,     *辛, 辛, 金女, 銅母]", "remainder:7"],
      [Stem, "label:[mizunoe,    *壬, 壬, 水男, 水公]", "remainder:8"],
      [Stem, "label:[mizunoto,   *癸, 癸, 水女, 水母]", "remainder:9"]
    ],

    [Branch,
      "label:[Branch, *支]", "divisor:12", "day:11", "year:4",
      [Branch, "label:[ne,        *子, 子, 鼠, 鼠]", "remainder: 0"],
      [Branch, "label:[ushi,      *丑, 好, 牛, 牛]", "remainder: 1"],
      [Branch, "label:[tora,      *寅, 寅, 虎, 虎]", "remainder: 2"],
      [Branch, "label:[u,         *卯, 栄, 兎, 兎]", "remainder: 3"],
      [Branch, "label:[tatsu,     *辰, 辰, 龍, 龍]", "remainder: 4"],
      [Branch, "label:[mi,        *巳, 巳, 蛇, 蛇]", "remainder: 5"],
      [Branch, "label:[uma,       *午, 午, 馬, 馬]", "remainder: 6"],
      [Branch, "label:[hitsuji,   *未, 未, 羊, 羊]", "remainder: 7"],
      [Branch, "label:[saru,      *申, 申, 猴, 猴]", "remainder: 8"],
      [Branch, "label:[tori,      *酉, 酉, 鷄, 鷄]", "remainder: 9"],
      [Branch, "label:[inu,       *戌, 戌, 狗, 狗]", "remainder:10"],
      [Branch, "label:[i,         *亥, 開, 猪, 猪]", "remainder:11"]
    ],

    [StemBranch,
      "label:[Stem-Branch, *干支]", "divisor:60", "day:11", "year:4", "format:[%s(%02d)]",
      [StemBranch, "label:[kinoe-ne=,           *甲子, 甲子, 木男鼠, 木公鼠]", "remainder: 0"],
      [StemBranch, "label:[kinoto-ushi=,        *乙丑, 乙好, 木女牛, 木母牛]", "remainder: 1"],
      [StemBranch, "label:[hinoe-tora=,         *丙寅, 丙寅, 火男虎, 火公虎]", "remainder: 2"],
      [StemBranch, "label:[hinoto-u=,           *丁卯, 丁栄, 火女兎, 火母兎]", "remainder: 3"],
      [StemBranch, "label:[tsuchinoe-tatsu=,    *戊辰, 戊辰, 土男龍, 土公龍]", "remainder: 4"],
      [StemBranch, "label:[tsuchinoto-mi=,      *己巳, 己巳, 土女蛇, 土母蛇]", "remainder: 5"],
      [StemBranch, "label:[kanoe-uma=,          *庚午, 庚午, 金男馬, 銅公馬]", "remainder: 6"],
      [StemBranch, "label:[kanoto-hitsuji=,     *辛未, 辛未, 金女羊, 銅母羊]", "remainder: 7"],
      [StemBranch, "label:[mizunoe-saru=,       *壬申, 壬申, 水男猴, 水公猴]", "remainder: 8"],
      [StemBranch, "label:[mizunoto-tori=,      *癸酉, 癸酉, 水女鷄, 水母鷄]", "remainder: 9"],
      [StemBranch, "label:[kinoe-inu=,          *甲戌, 甲戌, 木男狗, 木公狗]", "remainder:10"],
      [StemBranch, "label:[kinoto-i=,           *乙亥, 乙開, 木女猪, 木母猪]", "remainder:11"],
      [StemBranch, "label:[hinoe-ne=,           *丙子, 丙子, 火男鼠, 火公鼠]", "remainder:12"],
      [StemBranch, "label:[hinoto-ushi=,        *丁丑, 丁好, 火女牛, 火母牛]", "remainder:13"],
      [StemBranch, "label:[tsuchinoe-tora=,     *戊寅, 戊寅, 土男虎, 土公虎]", "remainder:14"],
      [StemBranch, "label:[tsuchinoto-u=,       *己卯, 己栄, 土女兎, 土母兎]", "remainder:15"],
      [StemBranch, "label:[kanoe-tatsu=,        *庚辰, 庚辰, 金男龍, 銅公龍]", "remainder:16"],
      [StemBranch, "label:[kanoto-mi=,          *辛巳, 辛巳, 金女蛇, 銅母蛇]", "remainder:17"],
      [StemBranch, "label:[mizunoe-uma=,        *壬午, 壬午, 水男馬, 水公馬]", "remainder:18"],
      [StemBranch, "label:[mizunoto-hitsuji=,   *癸未, 癸未, 水女羊, 水母羊]", "remainder:19"],
      [StemBranch, "label:[kinoe-saru=,         *甲申, 甲申, 木男猴, 木公猴]", "remainder:20"],
      [StemBranch, "label:[kinoto-tori=,        *乙酉, 乙酉, 木女鷄, 木母鷄]", "remainder:21"],
      [StemBranch, "label:[hinoe-inu=,          *丙戌, 丙戌, 火男狗, 火公狗]", "remainder:22"],
      [StemBranch, "label:[hinoto-i=,           *丁亥, 丁開, 火女猪, 火母猪]", "remainder:23"],
      [StemBranch, "label:[tsuchinoe-ne=,       *戊子, 戊子, 土男鼠, 土公鼠]", "remainder:24"],
      [StemBranch, "label:[tsuchinoto-ushi=,    *己丑, 己好, 土女牛, 土母牛]", "remainder:25"],
      [StemBranch, "label:[kanoe-tora=,         *庚寅, 庚寅, 金男虎, 銅公虎]", "remainder:26"],
      [StemBranch, "label:[kanoto-u=,           *辛卯, 辛栄, 金女兎, 銅母兎]", "remainder:27"],
      [StemBranch, "label:[mizunoe-tatsu=,      *壬辰, 壬辰, 水男龍, 水公龍]", "remainder:28"],
      [StemBranch, "label:[mizunoto-mi=,        *癸巳, 癸巳, 水女蛇, 水母蛇]", "remainder:29"],
      [StemBranch, "label:[kinoe-uma=,          *甲午, 甲午, 木男馬, 木公馬]", "remainder:30"],
      [StemBranch, "label:[kinoto-hitsuji=,     *乙未, 乙未, 木女羊, 木母羊]", "remainder:31"],
      [StemBranch, "label:[hinoe-saru=,         *丙申, 丙申, 火男猴, 火公猴]", "remainder:32"],
      [StemBranch, "label:[hinoto-tori=,        *丁酉, 丁酉, 火女鷄, 火母鷄]", "remainder:33"],
      [StemBranch, "label:[tsuchinoe-inu=,      *戊戌, 戊戌, 土男狗, 土公狗]", "remainder:34"],
      [StemBranch, "label:[tsuchinoto-i=,       *己亥, 己開, 土女猪, 土母猪]", "remainder:35"],
      [StemBranch, "label:[kanoe-ne=,           *庚子, 庚子, 金男鼠, 銅公鼠]", "remainder:36"],
      [StemBranch, "label:[kanoto-ushi=,        *辛丑, 辛好, 金女牛, 銅母牛]", "remainder:37"],
      [StemBranch, "label:[mizunoe-tora=,       *壬寅, 壬寅, 水男虎, 水公虎]", "remainder:38"],
      [StemBranch, "label:[mizunoto-u=,         *癸卯, 癸栄, 水女兎, 水母兎]", "remainder:39"],
      [StemBranch, "label:[kinoe-tatsu=,        *甲辰, 甲辰, 木男龍, 木公龍]", "remainder:40"],
      [StemBranch, "label:[kinoto-mi=,          *乙巳, 乙巳, 木女蛇, 木母蛇]", "remainder:41"],
      [StemBranch, "label:[hinoe-uma=,          *丙午, 丙午, 火男馬, 火公馬]", "remainder:42"],
      [StemBranch, "label:[hinoto-hitsuji=,     *丁未, 丁未, 火女羊, 火母羊]", "remainder:43"],
      [StemBranch, "label:[tsuchinoe-saru=,     *戊申, 戊申, 土男猴, 土公猴]", "remainder:44"],
      [StemBranch, "label:[tsuchinoto-tori=,    *己酉, 己酉, 土女鷄, 土母鷄]", "remainder:45"],
      [StemBranch, "label:[kanoe-inu=,          *庚戌, 庚戌, 金男狗, 銅公狗]", "remainder:46"],
      [StemBranch, "label:[kanoto-i=,           *辛亥, 辛開, 金女猪, 銅母猪]", "remainder:47"],
      [StemBranch, "label:[mizunoe-ne=,         *壬子, 壬子, 水男鼠, 水公鼠]", "remainder:48"],
      [StemBranch, "label:[mizunoto-ushi=,      *癸丑, 癸好, 水女牛, 水母牛]", "remainder:49"],
      [StemBranch, "label:[kinoe-tora=,         *甲寅, 甲寅, 木男虎, 木公虎]", "remainder:50"],
      [StemBranch, "label:[kinoto-u=,           *乙卯, 乙栄, 木女兎, 木母兎]", "remainder:51"],
      [StemBranch, "label:[hinoe-tatsu=,        *丙辰, 丙辰, 火男龍, 火公龍]", "remainder:52"],
      [StemBranch, "label:[hinoto-mi=,          *丁巳, 丁巳, 火女蛇, 火母蛇]", "remainder:53"],
      [StemBranch, "label:[tsuchinoe-uma=,      *戊午, 戊午, 土男馬, 土公馬]", "remainder:54"],
      [StemBranch, "label:[tsuchinoto-hitsuji=, *己未, 己未, 土女羊, 土母羊]", "remainder:55"],
      [StemBranch, "label:[kanoe-saru=,         *庚申, 庚申, 金男猴, 銅公猴]", "remainder:56"],
      [StemBranch, "label:[kanoto-tori=,        *辛酉, 辛酉, 金女鷄, 銅母鷄]", "remainder:57"],
      [StemBranch, "label:[mizunoe-inu=,        *壬戌, 壬戌, 水男狗, 水公狗]", "remainder:58"],
      [StemBranch, "label:[mizunoto-i=,         *癸亥, 癸開, 水女猪, 水母猪]", "remainder:59"]
    ],

    [Kyusei,
      "locale:[=en:, ja=ja:]",
      "label:[Kyusei=, *九星]", "divisor:9", "year:7",
      [Kyusei, "label:[KyuushiKasei=,    *九紫火星]", "remainder:0"],
      [Kyusei, "label:[HappakuDosei=,    *八白土星]", "remainder:1"],
      [Kyusei, "label:[SichisekiKinsei=, *七赤金星]", "remainder:2"],
      [Kyusei, "label:[RoppakuKinsei=,   *六白金星]", "remainder:3"],
      [Kyusei, "label:[GoouDosei=,       *五黄土星]", "remainder:4"],
      [Kyusei, "label:[ShirokuMokusei=,  *四緑木星]", "remainder:5"],
      [Kyusei, "label:[SampekiMokusei=,  *三碧木星]", "remainder:6"],
      [Kyusei, "label:[JikokuDosei=,     *二黒土星]", "remainder:7"],
      [Kyusei, "label:[IppakuSuisei=,    *一白水星]", "remainder:8"]
    ],

    [Residue,
      "locale:[=en:, ja=ja:, alias]",
      "label:[SolarTerm=en:Solar_term, *二十四節気]", "divisor:360",
      [Residue, "label:[vernal_equinox=,          *春分, 二月中=]  ", "remainder:0"  ],
      [Residue, "label:[clear_and_bright=,        *清明, 三月節=]  ", "remainder:15" ],
      [Residue, "label:[grain_rain=,              *穀雨, 三月中=]  ", "remainder:30" ],
      [Residue, "label:[start_of_summer=,         *立夏, 四月節=]  ", "remainder:45" ],
      [Residue, "label:[grain_full=,              *小満, 四月中=]  ", "remainder:60" ],
      [Residue, "label:[grain_in_ear=,            *芒種, 五月節=]  ", "remainder:75" ],
      [Residue, "label:[summer_solstice=,         *夏至, 五月中=]  ", "remainder:90" ],
      [Residue, "label:[minor_heat=,              *小暑, 六月節=]  ", "remainder:105"],
      [Residue, "label:[major_heat=,              *大暑, 六月中=]  ", "remainder:120"],
      [Residue, "label:[start_of_autumn=,         *立秋, 七月節=]  ", "remainder:135"],
      [Residue, "label:[limit_of_heat=,           *処暑, 七月中=]  ", "remainder:150"],
      [Residue, "label:[white_dew=,               *白露, 八月節=]  ", "remainder:165"],
      [Residue, "label:[autumnal_equinox=,        *秋分, 八月中=]  ", "remainder:180"],
      [Residue, "label:[cold_dew=,                *寒露, 九月節=]  ", "remainder:195"],
      [Residue, "label:[frost_descent=,           *霜降, 九月中=]  ", "remainder:210"],
      [Residue, "label:[start_of_winter=,         *立冬, 十月節=]  ", "remainder:225"],
      [Residue, "label:[minor_snow=,              *小雪, 十月中=]  ", "remainder:240"],
      [Residue, "label:[major_snow=,              *大雪, 十一月節=]", "remainder:255"],
      [Residue, "label:[winter_solstice=,         *冬至, 十一月中=]", "remainder:270"],
      [Residue, "label:[minor_cold=,              *小寒, 十二月節=]", "remainder:285"],
      [Residue, "label:[major_cold=,              *大寒, 十二月中=]", "remainder:300"],
      [Residue, "label:[start_of_spring=,         *立春, 正月節=]  ", "remainder:315"],
      [Residue, 'label:[#{A:rain_water=,          *雨水},正月中=]  ', "remainder:330"], # 戊寅・儀鳳暦では啓蟄
      [Residue, 'label:[#{B:awakening_of_insects=,*啓蟄},二月節=]  ', "remainder:345"]  # 戊寅・儀鳳暦では雨水
    ],

    [Residue,
      "locale:[=en:, ja=ja:]",
      "label:[LunarPhase=en:Lunar_phase, *月相]", "divisor:360",
      [Residue, "label:[New_moon=,           *朔  ]", "remainder:0"  ],
      [Residue, "label:[First_quarter_moon=, *上弦]", "remainder:90" ],
      [Residue, "label:[Full_moon=,          *望  ]", "remainder:180"],
      [Residue, "label:[Third_quarter_moon=, *下弦]", "remainder:270"]
    ]
  ]]
end
