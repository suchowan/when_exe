# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

require 'when_exe/region/chinese'
require 'when_exe/region/chinese_calendar'

#
#  朝鮮王位年号一覧表
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
#
module When
  class TM::CalendarEra

    #
    # 朝鮮半島
    #
    Korean = [self, [
      "namespace:[ja=http://ja.wikipedia.org/wiki/, en=http://en.wikipedia.org/wiki/]",
      "locale:[=ja:, en=en:, alias]",
      "area:[朝鮮=ja:%E5%85%83%E5%8F%B7#.E6.9C.9D.E9.AE.AE.E5.8D.8A.E5.B3.B6,Korea=en:Regnal_year#Korean]",
      [self,
	"period:[高句麗]",
	["[東明王]1",	"[::_m:EpochEvents::Foundation]",	"name=[東明王];-36^Chinese_103"],
	["[瑠璃王]1",	"[::_m:EpochEvents::Accession]",	"name=[瑠璃王];-18"],
	["[大武神王]1",	"[::_m:EpochEvents::Accession]",      "name=[大武神王];018"],
	["[閔中王]1",	"[::_m:EpochEvents::Accession]",	"name=[閔中王];044"],
	["[慕本王]1",	"[::_m:EpochEvents::Accession]",	"name=[慕本王];048"],
	["[太祖王]1",	"[::_m:EpochEvents::Accession]",	"name=[太祖王];053"],
	["[次大王]1",	"[::_m:EpochEvents::Accession]",	"name=[次大王];146"],
	["[新大王]1",	"[::_m:EpochEvents::Accession]",	"name=[新大王];165"],
	["[故国川王]1",	"[::_m:EpochEvents::Accession]",      "name=[故国川王];179"],
	["[山上王]1",	"[::_m:EpochEvents::Accession]",	"name=[山上王];197"],			# 朝鮮史ではこれ以降を実在とする
	["[東川王]1",	"[::_m:EpochEvents::Accession]",	"name=[東川王];227", "239^Chinese0239", ""],
	["[中川王]1",	"[::_m:EpochEvents::Accession]",	"name=[中川王];248"],
	["[西川王]1",	"[::_m:EpochEvents::Accession]",	"name=[西川王];270"],
	["[烽上王]1",	"[::_m:EpochEvents::Accession]",	"name=[烽上王];292"],
	["[美川王]1",	"[::_m:EpochEvents::Accession]",	"name=[美川王];300"],
	["[故国原王]1",	"[::_m:EpochEvents::Accession]",      "name=[故国原王];331"],
	["[小獣林王]1",	"[::_m:EpochEvents::Accession]",      "name=[小獣林王];371"],
	["[故国壌王]1",	"[::_m:EpochEvents::Accession]",      "name=[故国壌王];384"],			# 朝鮮史では末年に？
	["[永楽]1",	"[::_m:EpochEvents::Accession]",	"name=[広開土];391"],                   # コンサイスでは翌年が元年
	["[長寿王]1",	"[::_m:EpochEvents::Accession]",	"name=[長寿王];413.01.01"],             # 朝鮮史では元年に？
	["[延寿]1",	"",						      "451^Chinese0445"],       # こよみ読み解き事典による
	["[文咨王]1",	"[::_m:EpochEvents::Accession]",	"name=[文咨王];492.01.01"],
	["[安臧王]1",	"[::_m:EpochEvents::Accession]",	"name=[安臧王];519"],
	["[安原王]1",	"[::_m:EpochEvents::Accession]",	"name=[安原王];531"],
	["[陽原王]1",	"[::_m:EpochEvents::Accession]",	"name=[陽原王];545"],
	["[平原王]1",	"[::_m:EpochEvents::Accession]",	"name=[平原王];559"],
	["[嬰陽王]1",	"[::_m:EpochEvents::Accession]",	"name=[嬰陽王];590^Chinese0523"],
	["[栄留王]1",	"[::_m:EpochEvents::Accession]",	"name=[栄留王];618"],
	["[宝臧王]1",	"[::_m:EpochEvents::Accession]",	"name=[宝臧王];642", "668.09.12="],	# 資治通鑑による、癸巳滅亡
     ],
      [self,
	"period:[百済]",
	["[温祚王]1",	"[::_m:EpochEvents::Foundation]",	"name=[温祚王];-17^Chinese_103"],
	["[多婁王]1",	"[::_m:EpochEvents::Accession]",	"name=[多婁王];028"],
	["[己婁王]1",	"[::_m:EpochEvents::Accession]",	"name=[己婁王];077"],
	["[蓋婁王]1",	"[::_m:EpochEvents::Accession]",	"name=[蓋婁王];128"],			# 朝鮮史では127が末年
	["[肖古王]1",	"[::_m:EpochEvents::Accession]",	"name=[肖古王];166"],
	["[仇首王]1",	"[::_m:EpochEvents::Accession]",	"name=[仇首王];214"],
	["[沙伴王]1",	"[::_m:EpochEvents::Accession]",	"name=[沙伴王];234"],
	["[古爾王]1",	"[::_m:EpochEvents::Accession]",	"name=[古爾王];234", "239^Chinese0239", ""],
	["[責稽王]1",	"[::_m:EpochEvents::Accession]",	"name=[責稽王];286"],
	["[汾西王]1",	"[::_m:EpochEvents::Accession]",	"name=[汾西王];298"],
	["[比流王]1",	"[::_m:EpochEvents::Accession]",	"name=[比流王];304"],			# 朝鮮史ではこれ以後を実在とする
	["[契王]1",	"[::_m:EpochEvents::Accession]",	  "name=[契王];344"],
	["[近肖古王]1",	"[::_m:EpochEvents::Accession]",      "name=[近肖古王];346"],
	["[近仇首王]1",	"[::_m:EpochEvents::Accession]",      "name=[近仇首王];375"],
	["[枕流王]1",	"[::_m:EpochEvents::Accession]",	"name=[枕流王];384"],
	["[辰斯王]1",	"[::_m:EpochEvents::Accession]",	"name=[辰斯王];385"],
	["[阿莘王]1",	"[::_m:EpochEvents::Accession]",	"name=[阿莘王];392"],
	["[腆支王]1",	"[::_m:EpochEvents::Accession]",	"name=[腆支王];405"],
	["[久爾辛王]1",	"[::_m:EpochEvents::Accession]",      "name=[久爾辛王];420"],
	["[毗有王]1",	"[::_m:EpochEvents::Accession]",	"name=[毗有王];427", "451^Chinese0445", ""],
	["[蓋鹵王]1",	"[::_m:EpochEvents::Accession]",	"name=[蓋鹵王];455"],
	["[文周王]1",	"[::_m:EpochEvents::Accession]",	"name=[文周王];475"],
	["[三斤王]1",	"[::_m:EpochEvents::Accession]",	"name=[三斤王];477"],			# 朝鮮史では末年に？
	["[東城王]1",	"[::_m:EpochEvents::Accession]",	"name=[東城王];479"],
	["[武寧王]1",	"[::_m:EpochEvents::Accession]",	"name=[武寧王];501"],
	["[聖王]1",	"[::_m:EpochEvents::Accession]",	  "name=[聖王];523.05.07"],		# 武寧王墓誌による
	["[威徳王]1",	"[::_m:EpochEvents::Accession]",	"name=[威徳王];554", "590^Chinese0523", ""],
	["[恵王]1",	"[::_m:EpochEvents::Accession]",	  "name=[恵王];598"],
	["[法王]1",	"[::_m:EpochEvents::Accession]",	  "name=[法王];599"],
	["[武王]1",	"[::_m:EpochEvents::Accession]",	  "name=[武王];600"],
	["[義慈王]1",	"[::_m:EpochEvents::Accession]",	"name=[義慈王];641", "660.08="]		# 資治通鑑による
      ],
      [self,
	"period:[新羅]",
	["[赫居世]1",	"[::_m:EpochEvents::Foundation]",	"name=[赫居世];-56^^Chinese_103"],
	["[南解王]1",	"[::_m:EpochEvents::Accession]",	"name=[南解王];004"],
	["[儒理王]1",	"[::_m:EpochEvents::Accession]",	"name=[儒理王];024"],
	["[脱解王]1",	"[::_m:EpochEvents::Accession]",	"name=[脱解王];057"],
	["[婆娑王]1",	"[::_m:EpochEvents::Accession]",	"name=[婆娑王];080"],
	["[祇摩王]1",	"[::_m:EpochEvents::Accession]",	"name=[祇摩王];112"],
	["[逸聖王]1",	"[::_m:EpochEvents::Accession]",	"name=[逸聖王];134"],
	["[阿達羅王]1",	"[::_m:EpochEvents::Accession]",      "name=[阿達羅王];154"],
	["[伐休王]1",	"[::_m:EpochEvents::Accession]",	"name=[伐休王];184"],
	["[奈解王]1",	"[::_m:EpochEvents::Accession]",	"name=[奈解王];196"],
	["[助賁王]1",	"[::_m:EpochEvents::Accession]",	"name=[助賁王];230", "239^Chinese0239", ""],
	["[沾解王]1",	"[::_m:EpochEvents::Accession]",	"name=[沾解王];247"],			# 朝鮮史では261が末年
	["[味鄒王]1",	"[::_m:EpochEvents::Accession]",	"name=[味鄒王];262"],
	["[儒礼王]1",	"[::_m:EpochEvents::Accession]",	"name=[儒礼王];284"],
	["[基臨王]1",	"[::_m:EpochEvents::Accession]",	"name=[基臨王];298"],
	["[訖解王]1",	"[::_m:EpochEvents::Accession]",	"name=[訖解王];310"],			# コンサイスはこれ以前の在位を記さない
	["[奈勿王]1",	"[::_m:EpochEvents::Accession]",	"name=[奈勿王];356"],                   # 朝鮮史ではこれ以後を実在とする
	["[実聖王]1",	"[::_m:EpochEvents::Accession]",	"name=[実聖王];402"],
	["[訥祇王]1",	"[::_m:EpochEvents::Accession]",	"name=[訥祇王];417", "451^Chinese0445", ""],
	["[慈悲王]1",	"[::_m:EpochEvents::Accession]",	"name=[慈悲王];458"],
	["[炤知王]1",	"[::_m:EpochEvents::Accession]",	"name=[炤知王];479"],
	["[智証王]1",	"[::_m:EpochEvents::Accession]",	"name=[智証王];500"],
	["[法興王]1",	"[::_m:EpochEvents::Accession]",	"name=[法興王];514"],
	["[真興王]1",	"[::_m:EpochEvents::Accession]",	"name=[真興王];540"],
	["[真智王]1",	"[::_m:EpochEvents::Accession]",	"name=[真智王];576"],
	["[真平王]1",	"[::_m:EpochEvents::Accession]",	"name=[真平王];579", "590^Chinese0523", ""],
	["[善徳女王]1",	"[::_m:EpochEvents::Accession]",      "name=[善徳女王];632"],
	["[真徳女王]1",	"[::_m:EpochEvents::Accession]",      "name=[真徳女王];647"],
	["[武烈王]1",	"[::_m:EpochEvents::Accession]",	"name=[武烈王];654"],
	["[文武王]1",	"[::_m:EpochEvents::Accession]",	"name=[文武王];661"],
	["[神文王]1",	"[::_m:EpochEvents::Accession]",	"name=[神文王];681"],
	["[孝昭王]1",	"[::_m:EpochEvents::Accession]",	"name=[孝昭王];692"],
	["[聖徳王]1",	"[::_m:EpochEvents::Accession]",	"name=[聖徳王];702"],
	["[孝成王]1",	"[::_m:EpochEvents::Accession]",	"name=[孝成王];737"],
	["[景徳王]1",	"[::_m:EpochEvents::Accession]",	"name=[景徳王];742"],
	["[恵恭王]1",	"[::_m:EpochEvents::Accession]",	"name=[恵恭王];765"],
	["[宣徳王]1",	"[::_m:EpochEvents::Accession]",	"name=[宣徳王];780"],
	["[元聖王]1",	"[::_m:EpochEvents::Accession]",	"name=[元聖王];785"],
	["[昭聖王]1",	"[::_m:EpochEvents::Accession]",	"name=[昭聖王];799.01.01"],
	["[哀荘王]1",	"[::_m:EpochEvents::Accession]",	"name=[哀荘王];800"],
	["[憲徳王]1",	"[::_m:EpochEvents::Accession]",	"name=[憲徳王];809"],
	["[興徳王]1",	"[::_m:EpochEvents::Accession]",	"name=[興徳王];826"],
	["[僖康王]1",	"[::_m:EpochEvents::Accession]",	"name=[僖康王];836"],
	["[閔哀王]1",	"[::_m:EpochEvents::Accession]",	"name=[閔哀王];838"],
	["[神武王]1",	"[::_m:EpochEvents::Accession]",	"name=[神武王];839"],
	["[文聖王]1",	"[::_m:EpochEvents::Accession]",	"name=[文聖王];839"],
	["[憲安王]1",	"[::_m:EpochEvents::Accession]",	"name=[憲安王];857"],
	["[景文王]1",	"[::_m:EpochEvents::Accession]",	"name=[景文王];861"],
	["[憲康王]1",	"[::_m:EpochEvents::Accession]",	"name=[憲康王];875"],
	["[定康王]1",	"[::_m:EpochEvents::Accession]",	"name=[定康王];886"],
	["[真聖女王]1",	"[::_m:EpochEvents::Accession]",      "name=[真聖女王];887^Chinese::宣明暦"],	# 東洋史辞典のみ１年遅
	["[孝恭王]1",	"[::_m:EpochEvents::Accession]",	"name=[孝恭王];897"],                   #        〃
	["[神徳王]1",	"[::_m:EpochEvents::Accession]",	"name=[神徳王];912"],                   #        〃
	["[景明王]1",	"[::_m:EpochEvents::Accession]",	"name=[景明王];917"],
	["[景哀王]1",	"[::_m:EpochEvents::Accession]",	"name=[景哀王];924"],
	["[敬順王]1",	"[::_m:EpochEvents::Accession]",	"name=[敬順王];927", "935="],
        [self,
	  "period:[(年号)]",
	  ["[建元]1",	"",					"name=[法興王];536^Chinese0445"],
	  ["[開国]1",	"",					"name=[真興王];551"],
	  ["[太昌,alias:大昌]1",	"",				      "568"],
	  ["[鴻済]1",	"",						      "572"],
	  ["[建福]1",	"",					"name=[真平王];584", "590^Chinese0523", ""],
	  ["[仁平]1",	"",				      "name=[善徳女王];634"],
	  ["[太和]1",	"[::_m:EpochEvents::Accession]",      "name=[真徳女王];647", "649="]
        ],
        [self,
	  "period:[長安]",										# １年で滅亡したと仮定
	  ["[慶雲]1",	"[::_m:EpochEvents::Foundation]",	"name=[金憲昌];822^^Chinese0523", "822="]
        ]
      ],
      [self,
	"period:[後百済]",										# 三国遺事による
	["[甄萱]1",	"[::_m:EpochEvents::Foundation]",	"name=[甄萱];900^Chinese::宣明暦", "936.09.08="]
      ],
      [self,
	"period:[後高句麗]",
	["[弓裔]1",	"[::_m:EpochEvents::Foundation]",	"name=[弓裔];901^Chinese::宣明暦"],
	["[摩震]1",	"[::_m:EpochEvents::Accession]",	"name=[武泰];904"],
	["[聖冊]1",	"",						    "905"],
	["[泰封]1",	"[::_m:EpochEvents::Accession]",    "name=[水徳万歳];911"],
	["[政開]1",	"",						    "914", "918.06"]
      ],
      [self,
	"period:[高麗]",
	["[天授]1",	"[::_m:EpochEvents::Foundation]",	"name=[太祖];918.06^Chinese::宣明暦"],	# 三国遺事による
	["[太祖]16",	"",						    "933"],
	["[恵宗]1",	"[::_m:EpochEvents::Accession]",	"name=[恵宗];944"],
	["[定宗]1",	"[::_m:EpochEvents::Accession]",	"name=[定宗];946"],
	["[光徳]1",	"[::_m:EpochEvents::Accession]",	"name=[光宗];950"],
	["[峻豊]1",	"[::_m:EpochEvents::Accession]",		    "962.01.01"],		# こよみ読み解き事典による
	["[光宗]14",	"[::_m:EpochEvents::Accession]",		    "963.01.01"],
	["[景宗]1",	"[::_m:EpochEvents::Accession]",	"name=[景宗];976"],
	["[成宗]1",	"[::_m:EpochEvents::Accession]",	"name=[成宗];982"],
	["[穆宗]1",	"[::_m:EpochEvents::Accession]",	"name=[穆宗];998"],
	["[顕宗]1",	"[::_m:EpochEvents::Accession]",	"name=[顕宗];1010"],
	["[徳宗]1",	"[::_m:EpochEvents::Accession]",	"name=[徳宗];1032"],
	["[靖宗]1",	"[::_m:EpochEvents::Accession]",	"name=[靖宗];1035"],
	["[文宗]1",	"[::_m:EpochEvents::Accession]",	"name=[文宗];1047"],
	["[順宗]1",	"[::_m:EpochEvents::Accession]",	"name=[順宗];1083"],
	["[宣宗]1",	"[::_m:EpochEvents::Accession]",	"name=[宣宗];1084"],
	["[献宗]1",	"[::_m:EpochEvents::Accession]",	"name=[献宗];1095"],
	["[粛宗]1",	"[::_m:EpochEvents::Accession]",	"name=[粛宗];1096"],
	["[睿宗]1",	"[::_m:EpochEvents::Accession]",	"name=[睿宗];1106"],
	["[仁宗]1",	"[::_m:EpochEvents::Accession]",	"name=[仁宗];1123"],
	["[毅宗]1",	"[::_m:EpochEvents::Accession]",	"name=[毅宗];1147"],
	["[明宗]0",	"[::_m:EpochEvents::Accession]",	"name=[明宗];1170.08"],			# 朝鮮史による
	["[神宗]1",	"[::_m:EpochEvents::Accession]",	"name=[神宗];1198"],
	["[熙宗]1",	"[::_m:EpochEvents::Accession]",	"name=[熙宗];1205"],
	["[康宗]1",	"[::_m:EpochEvents::Accession]",	"name=[康宗];1212"],
	["[高宗]1",	"[::_m:EpochEvents::Accession]",	"name=[高宗];1214"],
	["[元宗]1",	"[::_m:EpochEvents::Accession]",	"name=[元宗];1260"],
	["[忠烈王]1",	"[::_m:EpochEvents::Accession]",	"name=[忠烈王];1275"],
	["[忠宣王]1",	"[::_m:EpochEvents::Accession]",	"name=[忠宣王];1298.01"],		# 朝鮮史による
	["[忠烈王･再]24","[::_m:EpochEvents::Accession]",	"name=[忠烈王];1298.08"],               #      〃
	["[忠宣王･再]1","[::_m:EpochEvents::Accession]",	"name=[忠宣王];1309^Chinese0939"],
	["[忠粛王]1",	"[::_m:EpochEvents::Accession]",	"name=[忠粛王];1314"],
	["[忠恵王]1",	"[::_m:EpochEvents::Accession]",	"name=[忠恵王];1331"],
	["[忠粛王･再]1","[::_m:EpochEvents::Accession]",	"name=[忠粛王];1332"],
	["[忠恵王･再]1","[::_m:EpochEvents::Accession]",	"name=[忠恵王];1340"],
	["[忠穆王]1",	"[::_m:EpochEvents::Accession]",	"name=[忠穆王];1345"],
	["[忠定王]1",	"[::_m:EpochEvents::Accession]",	"name=[忠定王];1349.01.01"],
	["[恭愍王]1",	"[::_m:EpochEvents::Accession]",	"name=[恭愍王];1352"],
	["[禑王]1",	"[::_m:EpochEvents::Accession]",	  "name=[禑王];1375"],
	["[昌王]1",	"[::_m:EpochEvents::Accession]",	  "name=[昌王];1389"],
	["[恭譲王]1",	"[::_m:EpochEvents::Accession]",	"name=[恭譲王];1390", "1392.07.17"]	# コンサイスによる
      ],
      [self,
	"period:[朝鮮]",
	["[太祖]1.07.17","[::_m:EpochEvents::Foundation]",	"name=[太祖];1392-07-17^Chinese0939"],	# コンサイスによる
	["[定宗]1",	"[::_m:EpochEvents::Accession]",	"name=[定宗];1399"],
	["[太宗]1",	"[::_m:EpochEvents::Accession]",	"name=[太宗];1401"],
	["[世宗]1",	"[::_m:EpochEvents::Accession]",	"name=[世宗];1419"],
	["[文宗]1",	"[::_m:EpochEvents::Accession]",	"name=[文宗];1451"],
	["[端宗]1",	"[::_m:EpochEvents::Accession]",	"name=[端宗];1453"],
	["[世祖]1",	"[::_m:EpochEvents::Accession]",	"name=[世祖];1455"],
	["[睿宗]1",	"[::_m:EpochEvents::Accession]",	"name=[睿宗];1469"],
	["[成宗]1",	"[::_m:EpochEvents::Accession]",	"name=[成宗];1470"],
	["[燕山君]1",	"[::_m:EpochEvents::Accession]",      "name=[燕山君];1495"],
	["[中宗]1",	"[::_m:EpochEvents::Accession]",	"name=[中宗];1506"],
	["[仁宗]1",	"[::_m:EpochEvents::Accession]",	"name=[仁宗];1545"],
	["[明宗]1",	"[::_m:EpochEvents::Accession]",	"name=[明宗];1546"],
	["[宣祖]1",	"[::_m:EpochEvents::Accession]",	"name=[宣祖];1568"],
	["[光海君]8",	"[::_m:EpochEvents::Accession]",      "name=[光海君];1616"],
	["[仁祖]1",	"[::_m:EpochEvents::Accession]",	"name=[仁祖];1623"],
	["[孝宗]1",	"[::_m:EpochEvents::Accession]",	"name=[孝宗];1650", "1653^Chinese0939", ""],
	["[顕宗]1",	"[::_m:EpochEvents::Accession]",	"name=[顕宗];1660"],
	["[粛宗]1",	"[::_m:EpochEvents::Accession]",	"name=[粛宗];1675"],
	["[景宗]1",	"[::_m:EpochEvents::Accession]",	"name=[景宗];1721"],
	["[英祖]1",	"[::_m:EpochEvents::Accession]",	"name=[英祖];1725"],			# コンサイスでは英宗
	["[正祖]1",	"[::_m:EpochEvents::Accession]",	"name=[正祖];1777"],
	["[純祖]1",	"[::_m:EpochEvents::Accession]",	"name=[純祖];1801"],
	["[憲宗]1",	"[::_m:EpochEvents::Accession]",	"name=[憲宗];1835"],
	["[哲宗]1",	"[::_m:EpochEvents::Accession]",	"name=[哲宗];1850"],
	["[高宗]1",	"[::_m:EpochEvents::Accession]",	"name=[高宗];1864"],
	["[建陽]1",	"",		"1896.01.01^Gregorian?note=ChineseNotes",			# 朝鮮史による
									    "1897.10.01"]
      ],
      [self,
	"period:[大韓帝国]",
	["[光武]1",	"[::_m:EpochEvents::Foundation]",	"name=[高宗];1897.10.01^Gregorian?note=ChineseNotes"],
	["[隆熙]1",	"[::_m:EpochEvents::Accession]",	"name=[純宗];1907.07.19", "1910.08.22="]
      ]
    ]]
  end
end
