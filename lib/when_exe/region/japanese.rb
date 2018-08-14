# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2018 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  class BasicTypes::M17n

    Japanese = [self, [
      "locale:[=ja:, en=en:, alias=ja:]",
      "names:[日本, Japan]",
      "[現代日本=, ModernJapanese=, *Modern=]",

      # Remarks
      "[典拠 - 科研22520700=," +
      "*based on Research Project 22520700=http://suchowan.at.webry.info/201401/article_25.html]",

      [self,
        "names:[月の名前=ja:%%<月_(暦)>, month name=en:Month, zh:該月的名稱=, *alias:Month]",
        "[正月=ja:%%<1月_(旧暦)>,    Month 1=,  睦月  ]",
        "[二月=ja:%%<2月_(旧暦)>,    Month 2=,  如月  ]",
        "[三月=ja:%%<3月_(旧暦)>,    Month 3=,  弥生  ]",
        "[四月=ja:%%<4月_(旧暦)>,    Month 4=,  卯月  ]",
        "[五月=ja:%%<5月_(旧暦)>,    Month 5=,  皐月  ]",
        "[六月=ja:%%<6月_(旧暦)>,    Month 6=,  水無月]",
        "[七月=ja:%%<7月_(旧暦)>,    Month 7=,  文月  ]",
        "[八月=ja:%%<8月_(旧暦)>,    Month 8=,  葉月  ]",
        "[九月=ja:%%<9月_(旧暦)>,    Month 9=,  長月  ]",
        "[十月=ja:%%<10月_(旧暦)>,   Month 10=, 神無月]",
        "[十一月=ja:%%<11月_(旧暦)>, Month 11=, 霜月  ]",
        "[十二月=ja:%%<12月_(旧暦)>, Month 12=, 師走  ]"
      ],

      [self,
        "names:[源氏物語, The_Tale_of_Genji]",
        "[桐壺,                            Kiritsubo=,         ]",
        "[帚木=ja:%%<帚木_(源氏物語)>,     Hahakigi=,          ]",
        "[空蝉=ja:%%<空蝉_(源氏物語)>,     Utsusemi=,          ]",
        "[夕顔=ja:%%<夕顔_(源氏物語)>,     Yūgao=,             ]",
        "[若紫,                            Wakamurasaki=,      ]",
        "[末摘花=ja:%%<末摘花_(源氏物語)>, Suetsumuhana,       ]",
        "[紅葉賀,                          Momiji no Ga=,      ]",
        "[花宴,                            Hana no En=,        ]",
        "[葵=ja:%%<葵_(源氏物語)>,         Aoi=,               ]",
        "[賢木,                            Sakaki=,            ]",
        "[花散里,                          Hana Chiru Sato=,   ]",
        "[須磨=ja:%%<須磨_(源氏物語)>,     Suma=,              ]",
        "[明石=ja:%%<明石_(源氏物語)>,     Akashi=,            ]",
        "[澪標=ja:%%<澪標_(源氏物語)>,     Miotsukushi=,       ]",
        "[蓬生,                            Yomogiu=,           ]",
        "[関屋=ja:%%<関屋_(源氏物語)>,     Sekiya=,            ]",
        "[絵合,                            E Awase=,           ]",
        "[松風=ja:%%<松風_(源氏物語)>,     Matsukaze=,         ]",
        "[薄雲,                            Usugumo=,           ]",
        "[朝顔=ja:%%<朝顔_(源氏物語)>,     Asagao=,            ]",
        "[少女=ja:%%<少女_(源氏物語)>,     Otome=,             ]",
        "[玉鬘=ja:%%<玉鬘_(源氏物語)>,     Tamakazura=,        ]",
        "[初音=ja:%%<初音_(源氏物語)>,     Hatsune=,           ]",
        "[胡蝶=ja:%%<胡蝶_(源氏物語)>,     Kochō=,             ]",
        "[蛍=ja:%%<蛍_(源氏物語)>,         Hotaru=,            ]",
        "[常夏,                            Tokonatsu=,         ]",
        "[篝火,                            Kagaribi=,          ]",
        "[野分=ja:%%<野分_(源氏物語)>,     Nowaki=,            ]",
        "[行幸=ja:%%<行幸_(源氏物語)>,     Miyuki=,            ]",
        "[藤袴,                            Fujibakama=,        ]",
        "[真木柱,                          Makibashira=,       ]",
        "[梅枝,                            Mume ga E=,         ]",
        "[藤裏葉,                          Fuji no Uraba=,     ]",
        "[若菜=ja:%%<若菜_(源氏物語)>,     Wakana=,            ]",
        "[柏木=ja:%%<柏木_(源氏物語)>,     Kashiwagi=,         ]",
        "[横笛=ja:%%<横笛_(源氏物語)>,     Yokobue=,           ]",
        "[鈴虫,                            Suzumushi=,         ]",
        "[夕霧=ja:%%<夕霧_(源氏物語)>,     Yūgiri=,            ]",
        "[御法,                            Minori=,            ]",
        "[幻=ja:%%<幻_(源氏物語)>,         Maboroshi=,         ]",
        "[匂宮,                            Niō Miya=,          ]",
        "[紅梅=ja:%%<紅梅_(源氏物語)>,     Kōbai=,             ]",
        "[竹河,                            Takekawa=,          ]",
        "[橋姫=ja:%%<橋姫_(源氏物語)>,     Hashihime=,         ]",
        "[椎本,                            Shī ga Moto=,       ]",
        "[総角=ja:%%<総角_(源氏物語)>,     Agemaki=,           ]",
        "[早蕨,                            Sawarabi=,          ]",
        "[宿木,                            Yadorigi=,          ]",
        "[東屋,                            Azumaya=,           ]",
        "[浮舟=ja:%%<浮舟_(源氏物語)>,     Ukifune,            ]",
        "[蜻蛉=ja:%%<蜻蛉_(源氏物語)>,     Kagerō=,            ]",
        "[手習,                            Tenarai=,           ]",
        "[夢浮橋,                          Yume no Ukihashi=,  ]"
      ]
    ]]

    JapaneseHoliday = [self, [
      "locale:[=ja:, en=en:, zh=zh:, alias=ja:]",
      "names:[日本の祝祭日=ja:%%<国民の祝日>, JapaneseHoliday=en:Public_holidays_in_Japan, 日本假期=zh:日本公共假日]",
      "[元旦,                         New Year's Day            ]",
      "[四方拝,                       New Year's Day            ]",
      "[元日,                         New Year's Day            ]",
      "[元始祭,                       New Year's Party=         ]",
      "[新年宴会,                     New Year's Party=         ]",
      "[成人の日,                     Coming of Age Day         ]",
      "[小正月,                       First Full Moon Festival  ]",
      "[紀元節,                       National Foundation Day   ]",
      "[建国記念の日,                 National Foundation Day   ]",
      "[天長節,                       The Emperor's Birthday    ]",
      "[天皇誕生日,                   The Emperor's Birthday    ]",
      "[みどりの日,                   Greenery Day              ]",
      "[昭和の日,                     Shōwa Day                 ]",
      "[憲法記念日,                   Constitution Memorial Day ]",
      "[こどもの日,                   Children's Day (Japan)    ]",
      "[七夕節句=ja:%%<七夕>,         Qixi Festival             ]",
      "[お盆,                         Bon Festival              ]",
      "[海の日,                       Marine Day                ]",
      "[山の日,                       Mountain Day=             ]",
      "[重陽節句,                     Double Ninth Festival     ]",
      "[敬老の日,                     Respect for the Aged Day  ]",
      "[神嘗祭,                       Kan'namesai=              ]",
      "[体育の日,                     Health and Sports Day     ]",
      "[スポーツの日,                 Sports Day                ]",
      "[春季皇霊祭,                   Vernal Kōreisai=en:K%C5%8Dreisai           ]",
      "[春分の日,                     Vernal Equinox Day                         ]",
      "[秋季皇霊祭,                   Autumnal Kōreisai=en:K%C5%8Dreisai         ]",
      "[秋分の日,                     Autumnal Equinox Day                       ]",
      "[明治節,                       The emperor Maiji's Birthday=en:Culture_Day]",
      "[文化の日,                     Culture Day                                ]",
      "[大嘗祭,                       Enthronement of the Japanese Emperor       ]",
      "[大饗第1日,                    Enthronement of the Japanese Emperor       ]",
      "[新嘗祭,                       Labor Thanksgiving Day                     ]",
      "[勤労感謝の日,                 Labor Thanksgiving Day                     ]",
      "[振替休日,                     Substitute holiday                         ]",
      "[国民の休日,                   National Day Off=                          ]",
      "[即位の礼,                     Enthronement of the Japanese Emperor       ]",
      "[即位の礼正殿の儀,             Enthronement of the Japanese Emperor       ]",
      "[神武天皇祭,                   EmperorJimmu's Death anniversary=          ]",
      "[孝明天皇祭=ja:%%<先帝祭>,     Emperor Kōmei's Death anniversary=         ]",
      "[明治天皇祭=ja:%%<先帝祭>,     Emperor Meiji's Death anniversary=         ]",
      "[大正天皇祭=ja:%%<先帝祭>,     Emperor Taishō's Death anniversary=        ]",
      "[神武天皇即位日=ja:%%<紀元節>, National Foundation Day                    ]",
      "[弥生節句=ja:%%<上巳>,         Double Third Festival=                     ]",
      "[端午節句=ja:%%<端午>,         Double Fifth Festival=                     ]",
      "[田実節句=ja:%%<八朔>,         Hassaku=                                   ]",
      "[皇大神宮遷御当日=ja:%%<神宮式年遷宮>,            Rebuilding the Ise Grand Shrine= ]",
      "[皇太子明仁親王の結婚の儀=ja:%%<結婚の儀>,        Prince Akihito's wedding=        ]",
      "[皇太子徳仁親王の結婚の儀=ja:%%<結婚の儀>,        Prince Naruhito's wedding=       ]",
      "[天長節祝日=ja:%%<天皇誕生日>#%.<近世・現代>,     Emperor Taishō's Birth holiday=  ]",
      "[昭和天皇の大喪の礼=ja:%%<大喪の礼>#%.<昭和天皇>, Emperor Shōwa's funeral ceremony=]"
    ]]
  end
end
