# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2013-2021 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

require 'when_exe/region/chinese/calendars'

#
#  朝鮮朔閏表および王位年号一覧表
#
# （参考文献）
# 東洋史辞典（東京創元社）
# コンサイス世界年表（三省堂）
# 朝鮮史（山川出版社）
# 三国遺事（六興出版）
# 歴代紀元編（台湾中華書局）に引用される新唐書
# 観象授時（月刊『言語』1991.12 特集・暦の記号学）
# 増補改訂中国の天文暦法（平凡社）P156
# 現代こよみ読み解き事典（柏書房）
# 韓國年暦大典（嶺南大学校出版部）
# 三国時代年曆表（Korea Astronomy Observatory）
# 高麗時代年曆表（Korea Astronomy Observatory）
# 朝鮮時代年曆表（Korea Astronomy Observatory）
# 朝鮮における時憲曆の受容過程とその思想的背景(東方學報 京都第84冊(2009) pp.302-281).
#
module When
  module CalendarTypes

    # 正月:A, ２月:B, ３月:C, ４月:D, ５月:E, ６月:F,
    # ７月:G, ８月:H, ９月:I, 10月:J, 11月:K, 12月:L
    # 大の月:大文字, 小の月:小文字
    # 同じアルファベットの連続の後者:閏月
    # #- は『韓國年暦大典』(1987年版)の中国-朝鮮差分が取り消されたもの
    # #! は全勇勳「朝鮮における時憲曆の受容過程とその思想的背景」で言及された年(最終的には差分でない)

    Korean = PatternTableBasedLuniSolar.join([
      PatternTableBasedLuniSolar,
      {
        'indices'=>  ChineseIndices,
        'before' => 'ChineseTwin::太初暦',
        'after'  => 'ChineseLuniSolar?time_basis=+09',
        'note'   => 'Chinese',
      },
      ['Chinese_103',  -60.. 263],             # 前漢～蜀漢(太初暦・四分暦)
      ['Chinese0239',  264.. 444],             # 三国・南朝(景初暦)
      ['Chinese0445',  445.. 589],             # 南朝(元嘉暦・大明暦)
      ['Chinese0523',  590.. 946],             # 隋・唐～五代前期(大業暦～調元暦)
      ['Chinese0956',  947..1279],             # 五代後期～南宋(調元暦～本天暦)
      ['Chinese0939', 1280..1653],             # 元・明・南明(重修大明暦・授時暦・大統暦)
      ['Chinese1645', 1654..1911]],            # 清(時憲暦)
      {
       -26 => {'aB'   => 'Ab'  },            # ベースとする中国暦日表の違い
       240 => {'Hi'   => 'hI'  },            # 四分・景初・乾象暦いずれにも不一致

       478 => {'bC'   => 'Bc'  },            # 日食記事による見直し(景初・元嘉・三紀・玄始暦いずれにも不一致)
       502 => {'D'    => 'E'   },            # 中国暦日表を計算による元嘉暦に戻す
       559 => {'De'   => 'eE'  },            # 日食記事による見直し(元嘉・大明・興和・天保・正光暦いずれにも不一致)
       575 => {'i'    => 'h'   },            # ベースとする中国暦日表の違い

       592 => {'FgHi' => 'fgHI'},
       716 => {'lL'   => 'Ll'  },            # ベースとする中国暦日表の違い
       768 => {'bC'   => 'Bc'  },
       795 => {'H'    => 'G'   },            # ベースとする中国暦日表の違い
       935 => {'Kl'   => 'kL'  },            # 宣明暦に一致(崇玄暦とは不一致)

      1022 => {'aB'  => 'Ab'  },             # 宣明暦に一致
      1025 => {'fG'  => 'Fg'  },             # 宣明・遼の大明暦に一致
      1032 => {'cD'  => 'Cd'  },
      1040 => {'dE'  => 'De', 'K'  => 'k' }, # ５月朔は宣明・遼の大明暦に一致
      1041 => {'a'   => 'A',  'Jk' => 'jK'}, # 12月朔は宣明・遼の大明暦に一致
      1048 => {'l'   => 'L'   },
      1049 => {'A'   => 'a',  'Kl' => 'kL'}, # 12月朔は宣明・遼の大明暦に一致
      1058 => {'l'   => 'L'   },
      1059 => {'A'   => 'a',  'Kl' => 'kL'}, # 12月朔は宣明・遼の大明暦に一致
      1067 => {'bC'  => 'aB'  },             # 宣明暦に一致(閏月２か月ずれ)
      1073 => {'kL'  => 'Kl'  },
      1078 => {'gHI' => 'GHi' },
      1079 => {'Ef'  => 'eF'  },
      1096 => {'bcDefGhIJKl' => 'BCdeFGhijkL' },
      1114 => {'bC'  => 'Bc'  },
      1118 => {'dE'  => 'De'  },
      1149 => {'efG' => 'Efg' },
      1244 => {'fGH' => 'FGh' },
      1252 => {'eF'  => 'Ef'  },
      1253 => {'Hi'  => 'hI'  },             # 重修大明暦に一致(たまたま?宣明暦にも一致)
      1270 => {'jjK' => 'jKk' },             # 重修大明暦に一致
      1276 => {'Ab'  => 'aB'  },             # 重修大明暦に一致

      1287 => {'bCD' => 'BCd' },             # ベースとする中国暦日表の違い
      1300 => {'HIj' => 'hIJ' },
      1365 => {'aB'  => 'Ab'  },
      1397 => {'bC'  => 'Bc'  },
      1399 => {'De'  => 'dE'  },
      1430 => {'Cd'  => 'cD'  },
   #- 1437 => {'kL'  => 'Kl'  },
      1440 => {'kL'  => 'Kl'  },
      1444 => {'kL'  => 'Kl'  },
      1462 => {'Jk'  => 'jK'  },
      1495 => {'fG'  => 'Fg'  },
      1530 => {'Ab'  => 'aB'  },
      1581 => {'Ij'  => 'iJ'  },
      1588 => {'bCD' => 'BCd','Kl' =>'kL'},
      1597 => {'Hi'  => 'hI'  },
   #- ,        'L'   =>'l' },
   #- 1598 => {'a'   => 'A'   },
      1599 => {'l'   => 'L'   },
      1600 => {'A'   => 'a'   },
      1602 => {'hI'  => 'Hi'  },
      1608 => {'l'   => 'L'   },
      1609 => {'A'   => 'a'   },
   #- 1615 => {'Fg'  => 'fG', 'Hh' =>'hH'},
   #- 1619 => {'L'   => 'l'   },
   #- 1620 => {'a'   => 'A'   },
   #- 1642 => {'Fg'  => 'fG'  },
   #- 1644 => {'fG'  => 'Fg'  },
   #- 1649 => {'iJ'  => 'Ij'  },
   #- 1650 => {'kL'  => 'Kl'  },
      1652 => {'hIJ' => 'HIj' },

   #- 1664 => {'bC'  => 'Bc'  },
   #- 1674 => {'aB'  => 'Ab'  },
      1677 => {'iJ'  => 'Ij'  },
      1698 => {'jK'  => 'Jk'  },
   #! 1705 => {'Kl'  => 'kL'  },
      1709 => {'aB'  => 'Ab', 'jK' =>'Jk' },
      1727 => {'cC'  => 'Cc'  },
      1730 => {'Cd'  => 'cD'  },
   #! 1735 => 『英祖實録』巻38 10年4月10日(乙卯) 是以我國明年曆與彼國所同者,只是置閏與月朔大小,而節候則日時皆不同
      1751 => {'Jk'  => 'jK'  },
      1778 => {'Cd'  => 'cD'  },
      1841 => {'kL'  => 'Kl'  }
    })
  end

  class TM::CalendarEra

    #
    # 朝鮮半島
    #
    Korean = [self, [
      "locale:[=ja:, en=en:, alias]",
      "area:[朝鮮=ja:%%<元号>#%.<朝鮮半島>,Korea=en:Regnal_year#Korean]",
      [self,
	"period:[高句麗]",
	["[<東明王>=ja:%%<東明聖王>]1",	"@F",	"name=[東明王=ja:%%<東明聖王>];-36^Korean"],
	["[<瑠璃王>=ja:%%<瑠璃明王>]1",	"@A",	"name=[瑠璃王=ja:%%<瑠璃明王>];-18"],
	["[<大武神王>]1",		"@A", "name=[大武神王];018"],
	["[<閔中王>]1",			"@A",	"name=[閔中王];044"],
	["[<慕本王>]1",			"@A",	"name=[慕本王];048"],
	["[<太祖王>=ja:%%<太祖大王>]1",	"@A",	"name=[太祖王=ja:%%<太祖大王>];053"],
	["[<次大王>]1",			"@A",	"name=[次大王];146"],
	["[<新大王>]1",			"@A",	"name=[新大王];165"],
	["[<故国川王>]1",		"@A", "name=[故国川王];179"],
	["[<山上王>]1",			"@A",	"name=[山上王];197"],						# 朝鮮史ではこれ以降を実在とする
	["[<東川王>]1",			"@A",	"name=[東川王];227"],
	["[<中川王>]1",			"@A",	"name=[中川王];248"],
	["[<西川王>]1",			"@A",	"name=[西川王];270"],
	["[<烽上王>]1",			"@A",	"name=[烽上王];292"],
	["[<美川王>]1",			"@A",	"name=[美川王];300"],
	["[<故国原王>]1",		"@A", "name=[故国原王];331"],
	["[<小獣林王>]1",		"@A", "name=[小獣林王];371"],
	["[<故国壌王>]1",		"@A", "name=[故国壌王];384"],						# 朝鮮史では末年に？
	["[永楽=ja:%%<永楽_(高句麗)>]1","@A",	"name=[広開土王=ja:%%<好太王>];391"],				# コンサイスでは翌年が元年
	["[<長寿王>]1",			"@A",	"name=[長寿王];413.01.01", "492.01.01"],			# 朝鮮史では元年に？
	["[延寿=ja:%%<延寿_(高句麗)>]1","",		      "451"],						# Wikipedia
	["[<文咨王>=ja:%%<文咨明王>]1",	"@A",	"name=[文咨王=ja:%%<文咨明王>];492.01.01"],
	["[<安臧王>]1",			"@A",	"name=[安臧王];519"],
	["[<安原王>]1",			"@A",	"name=[安原王];531"],
	["[<陽原王>]1",			"@A",	"name=[陽原王];545"],
	["[<平原王>]1",			"@A",	"name=[平原王];559"],
	["[<嬰陽王>]1",			"@A",	"name=[嬰陽王];590"],
	["[<栄留王>]1",			"@A",	"name=[栄留王];618"],
	["[<宝臧王>=ja:%%<宝蔵王>]1","@A","name=[宝臧王=ja:%%<宝蔵王>];642", "668.09.12="],			# 資治通鑑による、癸巳滅亡
     ],
      [self,
	"period:[百済]",
	["[<温祚王>]1",				"@F",	"name=[温祚王];-17^Korean"],
	["[<多婁王>]1",				"@A",	"name=[多婁王];028"],
	["[<己婁王>]1",				"@A",	"name=[己婁王];077"],
	["[<蓋婁王>]1",				"@A",	"name=[蓋婁王];128"],					# 朝鮮史では127が末年
	["[<肖古王>]1",				"@A",	"name=[肖古王];166"],
	["[<仇首王>]1",				"@A",	"name=[仇首王];214"],
	["[<沙伴王>]1",				"@A",	"name=[沙伴王];234"],
	["[<古爾王>=ja:%%<古尓王>]1",		"@A",	"name=[古爾王=ja:%%<古尓王>];234"],
	["[<責稽王>]1",				"@A",	"name=[責稽王];286"],
	["[<汾西王>]1",				"@A",	"name=[汾西王];298"],
	["[<比流王>]1",				"@A",	"name=[比流王];304"],					# 朝鮮史ではこれ以後を実在とする
	["[<契王>]1",				"@A",	  "name=[契王];344"],
	["[<近肖古王>]1",			"@A", "name=[近肖古王];346"],
	["[<近仇首王>]1",			"@A", "name=[近仇首王];375"],
	["[<枕流王>]1",				"@A",	"name=[枕流王];384"],
	["[<辰斯王>]1",				"@A",	"name=[辰斯王];385"],
	["[<阿莘王>=ja:%%<阿シン王>]1",		"@A",	"name=[阿莘王=ja:%%<阿シン王>];392"],
	["[<腆支王>]1",				"@A",	"name=[腆支王];405"],
	["[<久爾辛王>=ja:%%<久尓辛王>]1",	"@A", "name=[久爾辛王=ja:%%<久尓辛王>];420"],
	["[<毗有王>=ja:%%<毘有王>]1",		"@A",	"name=[毗有王=ja:%%<毘有王>];427"],
	["[<蓋鹵王>]1",				"@A",	"name=[蓋鹵王];455"],
	["[<文周王>]1",				"@A",	"name=[文周王];475"],
	["[<三斤王>]1",				"@A",	"name=[三斤王];477"],					# 朝鮮史では末年に？
	["[<東城王>]1",				"@A",	"name=[東城王];479"],
	["[<武寧王>]1",				"@A",	"name=[武寧王];501"],
	["[<聖王>=ja:%%<聖王_(百済)>]1",	"@A",	   "name=[聖王=ja:%%<聖王_(百済)];523.05.07"],		# 武寧王墓誌による
	["[<威徳王>=ja:%%<威徳王_(百済)>]1",	"@A", "name=[威徳王=ja:%%<威徳王_(百済)>];554"],
	["[<恵王>=ja:%%<恵王_(百済)>]1",	"@A",	  "name=[恵王=ja:%%<恵王_(百済)>];598"],
	["[<法王>=ja:%%<法王_(百済)>]1",	"@A",	  "name=[法王=ja:%%<法王_(百済)>];599"],
	["[<武王>=ja:%%<聖王_(百済)>]1",	"@A",	  "name=[武王=ja:%%<武王_(百済)>];600"],
	["[<義慈王>]1",				"@A",			   "name=[義慈王];641", "660.08="]	# 資治通鑑による
      ],
      [self,
	"period:[新羅]",
	["[<赫居世>=ja:%%<赫居世居西干>]1",	"@F", "name=[赫居世=ja:%%<赫居世居西干>];-56^^Korean"],
	["[<南解王>=ja:%%<南解次次雄>]1",	"@A",	"name=[南解王=ja:%%<南解次次雄>];004"],
	["[<儒理王>=ja:%%<儒理尼師今>]1",	"@A",	"name=[儒理王=ja:%%<儒理尼師今>];024"],
	["[<脱解王>=ja:%%<脱解尼師今>]1",	"@A",	"name=[脱解王=ja:%%<脱解尼師今>];057"],
	["[<婆娑王>=ja:%%<婆娑尼師今>]1",	"@A",	"name=[婆娑王=ja:%%<婆娑尼師今>];080"],
	["[<祇摩王>=ja:%%<祇摩尼師今>]1",	"@A",	"name=[祇摩王=ja:%%<祇摩尼師今>];112"],
	["[<逸聖王>=ja:%%<逸聖尼師今>]1",	"@A",	"name=[逸聖王=ja:%%<逸聖尼師今>];134"],
	["[<阿達羅王>=ja:%%<阿達羅尼師今>]1",  "@A","name=[阿達羅王=ja:%%<阿達羅尼師今>];154"],
	["[<伐休王>=ja:%%<伐休尼師今>]1",	"@A",	"name=[伐休王=ja:%%<伐休尼師今>];184"],
	["[<奈解王>=ja:%%<奈解尼師今>]1",	"@A",	"name=[奈解王=ja:%%<奈解尼師今>];196"],
	["[<助賁王>=ja:%%<助賁尼師今>]1",	"@A",	"name=[助賁王=ja:%%<助賁尼師今>];230"],
	["[<沾解王>=ja:%%<沾解尼師今>]1",	"@A",	"name=[沾解王=ja:%%<沾解尼師今>];247"],			# 朝鮮史では261が末年
	["[<味鄒王>=ja:%%<味鄒尼師今>]1",	"@A",	"name=[味鄒王=ja:%%<味鄒尼師今>];262"],
	["[<儒礼王>=ja:%%<儒礼尼師今>]1",	"@A",	"name=[儒礼王=ja:%%<儒礼尼師今>];284"],
	["[<基臨王>=ja:%%<基臨尼師今>]1",	"@A",	"name=[基臨王=ja:%%<基臨尼師今>];298"],
	["[<訖解王>=ja:%%<訖解尼師今>]1",	"@A",	"name=[訖解王=ja:%%<訖解尼師今>];310"],			# コンサイスはこれ以前の在位を記さない
	["[<奈勿王>=ja:%%<奈勿尼師今>]1",	"@A",	"name=[奈勿王=ja:%%<奈勿尼師今>];356"],			# 朝鮮史ではこれ以後を実在とする
	["[<実聖王>=ja:%%<実聖尼師今>]1",	"@A",	"name=[実聖王=ja:%%<実聖尼師今>];402"],
	["[<訥祇王>=ja:%%<訥祇麻立干>]1",	"@A",	"name=[訥祇王=ja:%%<訥祇麻立干>];417"],
	["[<慈悲王>=ja:%%<慈悲麻立干>]1",	"@A",	"name=[慈悲王=ja:%%<慈悲麻立干>];458"],
	["[<炤知王>=ja:%%<ショウ知麻立干>]1", "@A", "name=[炤知王=ja:%%<ショウ知麻立干>];479"],
	["[<智証王>=ja:%%<智証麻立干>]1",	"@A",	"name=[智証王=ja:%%<智証麻立干>];500"],
	["[<法興王>]1",	"@A",	"name=[法興王];514"],
	["[<真興王>]1",	"@A",	"name=[真興王];540"],
	["[<真智王>]1",	"@A",	"name=[真智王];576"],
	["[<真平王>]1",	"@A",	"name=[真平王];579"],
	["[<善徳女王>]1","@A","name=[善徳女王];632"],
	["[<真徳女王>]1","@A","name=[真徳女王];647"],
	["[<武烈王>]1",	"@A",	"name=[武烈王];654"],
	["[<文武王>]1",	"@A",	"name=[文武王];661"],
	["[<神文王>]1",	"@A",	"name=[神文王];681"],
	["[<孝昭王>]1",	"@A",	"name=[孝昭王];692"],
	["[<聖徳王>]1",	"@A",	"name=[聖徳王];702"],
	["[<孝成王>=ja:%%<孝成王_(新羅)>]1", "@A", "name=[孝成王=ja:%%<孝成王_(新羅)>];737"],
	["[<景徳王>]1",	"@A",	"name=[景徳王];742"],
	["[<恵恭王>]1",	"@A",	"name=[恵恭王];765"],
	["[<宣徳王>]1",	"@A",	"name=[宣徳王];780"],
	["[<元聖王>]1",	"@A",	"name=[元聖王];785"],
	["[<昭聖王>]1",	"@A",	"name=[昭聖王];799.01.01"],
	["[<哀荘王>]1",	"@A",	"name=[哀荘王];800"],
	["[<憲徳王>]1",	"@A",	"name=[憲徳王];809"],
	["[<興徳王>]1",	"@A",	"name=[興徳王];826"],
	["[<僖康王>]1",	"@A",	"name=[僖康王];836"],
	["[<閔哀王>]1",	"@A",	"name=[閔哀王];838"],
	["[<神武王>]1",	"@A",	"name=[神武王];839"],
	["[<文聖王>]1",	"@A",	"name=[文聖王];839"],
	["[<憲安王>]1",	"@A",	"name=[憲安王];857"],
	["[<景文王>]1",	"@A",	"name=[景文王];861"],
	["[<憲康王>]1",	"@A",	"name=[憲康王];875"],
	["[<定康王>]1",	"@A",	"name=[定康王];886"],
	["[<真聖女王>]1","@A","name=[真聖女王];887"],			# 東洋史辞典のみ１年遅
	["[<孝恭王>]1",	"@A",	"name=[孝恭王];897"],			#        〃
	["[<神徳王>]1",	"@A",	"name=[神徳王];912"],			#        〃
	["[<景明王>]1",	"@A",	"name=[景明王];917"],
	["[<景哀王>]1",	"@A",	"name=[景哀王];924"],
	["[<敬順王>]1",	"@A",	"name=[敬順王];927", "935="],
        [self,
	  "period:[年号=]",
	  ["[建元=ja:%%<建元_(新羅)>]1",	"",	"name=[法興王];536^Korean"],
	  ["[開国=ja:%%<開国_(新羅)>]1",	"",	"name=[真興王];551"],
	  ["[大昌,alias:太昌=ja:%%<大昌>]1",	"",		      "568"],
	  ["[鴻済]1",				"",		      "572"],
	  ["[建福=ja:%%<建福_(新羅)>]1",	"",	"name=[真平王];584"],
	  ["[仁平=ja:%%<仁平_(新羅)>]1",	"",   "name=[善徳女王];634"],
	  ["[太和=ja:%%<太和_(新羅)>]1",	"@A", "name=[真徳女王];647", "649="]
        ],
        [self,
	  "period:[長安=zh:%%<長安國>]", # １月で滅亡と仮定
	  ["[慶雲=ja:%%<慶雲_(金憲昌)>]1",	"@F",	"name=[金憲昌=zh:%%<金憲昌>];822.03^^Korean", "822.03="]
        ]
      ],
      [self,
	"period:[後百済]",		# 三国遺事による
	["[<甄萱>]1",	"@F",			 "name=[甄萱];900^Korean", "936.09.08="]
      ],
      [self,
	"period:[後高句麗]",
	["[<弓裔>=ja:%%<弓裔>]1",	"@F",	 "name=[弓裔];901^Korean", "904"],
	[self,
	  "period:[摩震=ja:%%<後高句麗>]",
	  ["[武泰=ja:%%<武泰_(後高句麗)>]1", "", "name=[弓裔];904^Korean"],
	  ["[聖冊]1",	"",				     "905", "911"]
	],
	[self,
	  "period:[泰封=ja:%%<後高句麗>]",
	  ["[水徳万歳]1",		"",	 "name=[弓裔];911^Korean"],
	  ["[政開]1",			"",		     "914", "918.06"]
	]
      ],
      [self,
	"period:[高麗]",
	["[天授=ja:%%<天授_(高麗)>]1",		"@F",	"name=[太祖=ja:%%<太祖_(高麗王)>];918.06^Korean"],	# 三国遺事による
	["[<太祖>=ja:%%<太祖_(高麗王)>]16",	"",					 "933"],
	["[<恵宗>=ja:%%<恵宗_(高麗王)>]1",	"@A",	"name=[恵宗=ja:%%<恵宗_(高麗王)>];944"],
	["[<定宗>=ja:%%<定宗_(高麗王)>]1",	"@A",	"name=[定宗=ja:%%<定宗_(高麗王)>];946"],
	["[光徳=ja:%%<光徳_(高麗)>]1",		"@A",	"name=[光宗=ja:%%<光宗_(高麗王)>];950"],
	["[<光宗>=ja:%%<光宗_(高麗王)>]3",	"@A",					 "952"],
      # ["[峻豊]1",				"@A",					 "962.01.01"],		# こよみ読み解き事典による Wikipedia で否定
	["[<景宗>=ja:%%<景宗_(高麗王)>]1",	"@A",	"name=[景宗=ja:%%<景宗_(高麗王)>];976"],
	["[<成宗>=ja:%%<成宗_(高麗王)>]1",	"@A",	"name=[成宗=ja:%%<成宗_(高麗王)>];982"],
	["[<穆宗>=ja:%%<穆宗_(高麗王)>]1",	"@A",	"name=[穆宗=ja:%%<穆宗_(高麗王)>];998"],
	["[<顕宗>=ja:%%<顕宗_(高麗王)>]1",	"@A",	"name=[顕宗=ja:%%<顕宗_(高麗王)>];1010"],
	["[<徳宗>=ja:%%<徳宗_(高麗王)>]1",	"@A",	"name=[徳宗=ja:%%<徳宗_(高麗王)>];1032"],
	["[<靖宗>=ja:%%<靖宗_(高麗王)>]1",	"@A",	"name=[靖宗=ja:%%<靖宗_(高麗王)>];1035"],
	["[<文宗>=ja:%%<文宗_(高麗王)>]1",	"@A",	"name=[文宗=ja:%%<文宗_(高麗王)>];1047"],
	["[<順宗>=ja:%%<順宗_(高麗王)>]1",	"@A",	"name=[順宗=ja:%%<順宗_(高麗王)>];1083"],
	["[<宣宗>=ja:%%<宣宗_(高麗王)>]1",	"@A",	"name=[宣宗=ja:%%<宣宗_(高麗王)>];1084"],
	["[<献宗>=ja:%%<献宗_(高麗王)>]1",	"@A",	"name=[献宗=ja:%%<献宗_(高麗王)>];1095"],
	["[<粛宗>=ja:%%<粛宗_(高麗王)>]1",	"@A",	"name=[粛宗=ja:%%<粛宗_(高麗王)>];1096"],
	["[<睿宗>=ja:%%<睿宗_(高麗王)>]1",	"@A",	"name=[睿宗=ja:%%<睿宗_(高麗王)>];1106"],
	["[<仁宗>=ja:%%<仁宗_(高麗王)>]1",	"@A",	"name=[仁宗=ja:%%<仁宗_(高麗王)>];1123"],
	["[<毅宗>=ja:%%<毅宗_(高麗王)>]1",	"@A",	"name=[毅宗=ja:%%<毅宗_(高麗王)>];1147"],
	["[<明宗>=ja:%%<明宗_(高麗王)>]0",	"@A",	"name=[明宗=ja:%%<明宗_(高麗王)>];1170.08"],		# 朝鮮史による
	["[<神宗>=ja:%%<神宗_(高麗王)>]1",	"@A",	"name=[神宗=ja:%%<神宗_(高麗王)>];1198"],
	["[<熙宗>=ja:%%<熙宗_(高麗王)>]1",	"@A",	"name=[熙宗=ja:%%<熙宗_(高麗王)>];1205"],
	["[<康宗>=ja:%%<康宗_(高麗王)>]1",	"@A",	"name=[康宗=ja:%%<康宗_(高麗王)>];1212"],
	["[<高宗>=ja:%%<高宗_(高麗王)>]1",	"@A",	"name=[高宗=ja:%%<高宗_(高麗王)>];1214"],
	["[<元宗>=ja:%%<元宗_(高麗王)>]1",	"@A",	"name=[元宗=ja:%%<元宗_(高麗王)>];1260"],
	["[<忠烈王>]1",				"@A",			   "name=[忠烈王];1275"],
	["[<忠宣王>]1",				"@A",			   "name=[忠宣王];1298.01"],		# 朝鮮史による
	["[<忠烈王･再>=ja:%%<忠烈王>]24",	"@A",			   "name=[忠烈王];1298.08"],		#      〃
	["[<忠宣王･再>=ja:%%<忠宣王>]1",	"@A",			   "name=[忠宣王];1309"],
	["[<忠粛王>]1",				"@A",			   "name=[忠粛王];1314"],
	["[<忠恵王>]1",				"@A",			   "name=[忠恵王];1331"],
	["[<忠粛王･再>=ja:%%<忠粛王>]1",	"@A",			   "name=[忠粛王];1332"],
	["[<忠恵王･再>=ja:%%<忠恵王>]1",	"@A",			   "name=[忠恵王];1340"],
	["[<忠穆王>]1",				"@A",			   "name=[忠穆王];1345"],
	["[<忠定王>]1",				"@A",			   "name=[忠定王];1349.01.01"],
	["[<恭愍王>]1",				"@A",			   "name=[恭愍王];1352"],
	["[<禑王>=ja:%%<王ウ_(高麗王)>]1",	"@A",   "name=[禑王=ja:%%<王ウ_(高麗王)>];1375"],
	["[<昌王>=ja:%%<王昌_(高麗王)>]1",	"@A",   "name=[昌王=ja:%%<王昌_(高麗王)>];1389"],
	["[<恭譲王>]1",				"@A",		   "name=[恭譲王];1390", "1392.07.17"]		# コンサイスによる
      ],
      [self,
	"period:[朝鮮=ja:%%<李氏朝鮮>]",
	["[<太祖>=ja:%%<李成桂>]1.07.17",	"@F",	       "name=[太祖=ja:%%<李成桂>];1392-07-17^Korean"],	# コンサイスによる
	["[<定宗>=ja:%%<定宗_(朝鮮王)>]1",	"@A",	"name=[定宗=ja:%%<定宗_(朝鮮王)>];1399"],
	["[<太宗>=ja:%%<太宗_(朝鮮王)>]1",	"@A",	"name=[太宗=ja:%%<太宗_(朝鮮王)>];1401"],
	["[<世宗>=ja:%%<世宗_(朝鮮王)>]1",	"@A",	"name=[世宗=ja:%%<世宗_(朝鮮王)>];1419"],
	["[<文宗>=ja:%%<文宗_(朝鮮王)>]1",	"@A",	"name=[文宗=ja:%%<文宗_(朝鮮王)>];1451"],
	["[<端宗>=ja:%%<端宗_(朝鮮王)>]1",	"@A",	"name=[端宗=ja:%%<端宗_(朝鮮王)>];1453"],
	["[<世祖>=ja:%%<世祖_(朝鮮王)>]1",	"@A",	"name=[世祖=ja:%%<世祖_(朝鮮王)>];1455"],
	["[<睿宗>=ja:%%<睿宗_(朝鮮王)>]1",	"@A",	"name=[睿宗=ja:%%<睿宗_(朝鮮王)>];1469"],
	["[<成宗>=ja:%%<成宗_(朝鮮王)>]1",	"@A",	"name=[成宗=ja:%%<成宗_(朝鮮王)>];1470"],
	["[<燕山君>]1",				"@A",			   "name=[燕山君];1495"],
	["[<中宗>=ja:%%<中宗_(朝鮮王)>]1",	"@A",	"name=[中宗=ja:%%<中宗_(朝鮮王)>];1506"],
	["[<仁宗>=ja:%%<仁宗_(朝鮮王)>]1",	"@A",	"name=[仁宗=ja:%%<仁宗_(朝鮮王)>];1545"],
	["[<明宗>=ja:%%<明宗_(朝鮮王)>]1",	"@A",	"name=[明宗=ja:%%<明宗_(朝鮮王)>];1546"],
	["[<宣祖>]1",				"@A",			     "name=[宣祖];1568"],
	["[<光海君>]1",				"@A",			   "name=[光海君];1609"],
	["[<仁祖>]1",				"@A",			     "name=[仁祖];1623"],
	["[<孝宗>=ja:%%<孝宗_(朝鮮王)>]1",	"@A",	"name=[孝宗=ja:%%<孝宗_(朝鮮王)>];1650"],
	["[<顕宗>=ja:%%<顕宗_(朝鮮王)>]1",	"@A",	"name=[顕宗=ja:%%<顕宗_(朝鮮王)>];1660"],
	["[<粛宗>=ja:%%<粛宗_(朝鮮王)>]1",	"@A",	"name=[粛宗=ja:%%<粛宗_(朝鮮王)>];1675"],
	["[<景宗>=ja:%%<景宗_(朝鮮王)>]1",	"@A",	"name=[景宗=ja:%%<景宗_(朝鮮王)>];1721"],
	["[<英祖>=ja:%%<英祖_(朝鮮王)>]1",	"@A",	"name=[英祖=ja:%%<英祖_(朝鮮王)>];1725"],		# コンサイスでは英宗
	["[<正祖>]1",				"@A",			     "name=[正祖];1777"],
	["[<純祖>]1",				"@A",			     "name=[純祖];1801"],
	["[<憲宗>=ja:%%<憲宗_(朝鮮王)>]1",	"@A",	"name=[憲宗=ja:%%<憲宗_(朝鮮王)>];1835"],
	["[<哲宗>=ja:%%<哲宗_(朝鮮王)>]1",	"@A",	"name=[哲宗=ja:%%<哲宗_(朝鮮王)>];1850"],
	["[<高宗>=ja:%%<高宗_(朝鮮王)>]1",	"@A",	"name=[高宗=ja:%%<高宗_(朝鮮王)>];1864"],
	["[建陽]1",				"",					 "1896.01.01^Gregorian?note=Chinese",	# 朝鮮史による
	    "1897.10.01"]
      ],
      [self,
	"period:[大韓帝国]",
	["[光武=ja:%%<光武_(元号)>]1",	"@F",	"name=[高宗=ja:%%<高宗_(朝鮮王)>];1897.10.01^Gregorian?note=Chinese"],
	["[隆熙]1",			"@A",	"name=[純宗=ja:%%<純宗_(朝鮮王)>];1907.07.19", "1910.08.29="]
      ]
    ]]
  end
end
