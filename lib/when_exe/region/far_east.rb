# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

require 'when_exe/region/chinese'
require 'when_exe/region/chinese_calendar'

#
#  王位年号一覧表
#
# （参考文献）
# 東洋史辞典（東京創元社）
# コンサイス世界年表（三省堂）
# 朝鮮史（山川出版社）
# 歴代紀元編（台湾中華書局）に引用される新唐書
#
module When
  class TM::CalendarEra

    #
    # 満洲
    #
    Manchurian = [self, [
      "namespace:[ja=http://ja.wikipedia.org/wiki/, en=http://en.wikipedia.org/wiki/]",
      "locale:[=ja:, en=en:, alias]",
      "area:[満洲,Manchurian=en:Manchuria]",
      [self,
	"period:[震]",
	["[高王]1",	"[::_m:EpochEvents::Foundation]",	"name=[高王];698^Chinese0523", "713"]
      ],
      [self,
	"period:[渤海,Balhae]",
	["[高王]1",	"[::_m:EpochEvents::Accession]",	"name=[高王];713^Chinese0523"],
	["[仁安]1",	"[::_m:EpochEvents::Accession]",	"name=[武王];719"],		# コンサイスでは翌年が元年、以下翌年のものは(*)
	["[大興]1",	"[::_m:EpochEvents::Accession]",	"name=[文王];738"],
	["[廃王]1",	"[::_m:EpochEvents::Accession]",	"name=[廃王];794"],		# 朝鮮史では793?とする
	["[中興]1",	"[::_m:EpochEvents::Accession]",	"name=[成王];794"],		# 新唐書では786が元年？
	["[正暦]1",	"[::_m:EpochEvents::Accession]",	"name=[康王];795"],
	["[永徳]1",	"[::_m:EpochEvents::Accession]",	"name=[定王];809"],		# コンサイスでは翌年が元年
	["[朱雀]1",	"[::_m:EpochEvents::Accession]",	"name=[僖王];813"],		# 朝鮮史では817が末年		(*)
	["[太始]1",	"[::_m:EpochEvents::Accession]",	"name=[簡王];818"],		# 新唐書では前年が元年
	["[建興]1",	"[::_m:EpochEvents::Accession]",	"name=[宣王];818"],		# コンサイスでは翌年が元年	(*)
	["[咸和]1",	"[::_m:EpochEvents::Accession]",      "name=[彝震王];830"],		# （以後同様）			(*)
	["[虔晃王]1",	"[::_m:EpochEvents::Accession]",      "name=[虔晃王];857"],		# 新唐書には以後記載なし	(*)
	["[景王]1",	"[::_m:EpochEvents::Accession]",	"name=[景王];871"],		# 朝鮮史は871?			(*)
	["[瑋瑎]1",	"[::_m:EpochEvents::Accession]",	"name=[瑋瑎];893"],		# 朝鮮史では在位不明		(*)
	["[哀王]1",	"[::_m:EpochEvents::Accession]",	"name=[哀王];906",		#				(*)
									    "926="]
      ],
      [self,
	"period:[満洲国]",
	["[大同]1",	"[::_m:EpochEvents::Foundation]",	"name=[溥儀];1932-03-01^Gregorian?note=ChineseNotes"],
	["[康徳]1.03.01","",						    "1934-03-01", "1945-08-18="]
      ],
    ]]

    #
    # 柔然
    #
    Rouran = [self, [
      "namespace:[ja=http://ja.wikipedia.org/wiki/, en=http://en.wikipedia.org/wiki/]",
      "locale:[=ja:, en=en:, alias]",
      "area:[柔然,Rouran]",
      ["[永康]1",	"[::_m:EpochEvents::Accession]",	"name=[予成];464^Chinese0445"],
      ["[太平]1",	"[::_m:EpochEvents::Accession]",	"name=[豆崙];485"],
      ["[太安]1",	"[::_m:EpochEvents::Accession]",	"name=[那蓋];492"],
      ["[始平]1",	"[::_m:EpochEvents::Accession]",	"name=[伏図];506"],
      ["[建昌]1",	"[::_m:EpochEvents::Accession]",	"name=[醜奴];509", "520="]
    ]]

    #
    # 高昌
    #
    Gaochang = [self, [
      "namespace:[ja=http://ja.wikipedia.org/wiki/, en=http://en.wikipedia.org/wiki/]",
      "locale:[=ja:, en=en:, alias]",
      "area:[高昌,Gaochang]",
      ["[章和]1",	"[::_m:EpochEvents::Accession]",	  "name=[麹堅];531^Chinese0523"],
      ["[永平]1",	"[::_m:EpochEvents::Accession]",	"name=[麹玄喜];549"],
      ["[和平]1",	"[::_m:EpochEvents::Accession]",		"name=;551"],
      ["[建昌]1",	"[::_m:EpochEvents::Accession]",	"name=[麹宝茂];555"],
      ["[延昌]1",	"[::_m:EpochEvents::Accession]",	"name=[麹乾固];561"],
      ["[延和]1",	"[::_m:EpochEvents::Accession]",	"name=[麹伯雅];602"],
      ["[義和]1",	"[::_m:EpochEvents::Accession]",		"name=;614"],
      ["[重光]1",	"",					"name=[麹伯雅];620"],
      ["[延寿]1",	"[::_m:EpochEvents::Accession]",	"name=[麹文泰];624", "name=[麹智盛];640", "640="]
    ]]

    #
    # 雲南
    #
    Yunnan = [self, [
      "namespace:[ja=http://ja.wikipedia.org/wiki/, en=http://en.wikipedia.org/wiki/]",
      "locale:[=ja:, en=en:, alias]",
      "area:[雲南,Yunnan]",
      [self,
	"period:[南詔,Nanzhao]",
	["[閣羅鳳]1",	"[::_m:EpochEvents::Accession]",	"name=[閣羅鳳];748^Chinese0523"],
	["[賛普金重]1",	"[::_m:EpochEvents::Accession]",      "name=[賛普金重];752"],
	["[長寿]1",	"",						      "769"],
	["[見龍]1",	"[::_m:EpochEvents::Accession]",	"name=[異牟尋];780"],
	["[上元]1",	"",						      "784"],
	["[(上元)]2",	"",						      "785"],		# 元封?
	["[応道]1",	"[::_m:EpochEvents::Accession]",	"name=[尋閣勧];809"],
	["[龍興]1",	"[::_m:EpochEvents::Accession]",	"name=[勧龍晟];810"],
	["[全義]1",	"[::_m:EpochEvents::Accession]",	"name=[勧利晟];817"],
	["[大豊]1",	"",		      "820"],
	["[保和]1",	"[::_m:EpochEvents::Accession]",	"name=[晟豊祐];824"],
	["[(保和)]17",	"",		      "840"],		# 天啓?
	["[建極]1",	"[::_m:EpochEvents::Accession]",	  "name=[世隆];860"],
	["[(建極)]14",	"",						      "873", "878"]	# 法尭?
      ],
      [self,
	"period:[大封民]",
	["[貞明]1",	"[::_m:EpochEvents::Foundation]",	  "name=[隆舜];878^Chinese0523"],
	["[(貞明)]2",	"",						      "879"],		# 承智, 大同, 嵯耶?
	["[中興]1",	"[::_m:EpochEvents::Accession]",	"name=[舜化貞];898", "903"]
      ],
      [self,
	"period:[大長和]",
	["[安国]1",	"[::_m:EpochEvents::Foundation]",	"name=[鄭買嗣];903^Chinese0523"],
	["[始元]1",	"[::_m:EpochEvents::Accession]",	"name=[鄭仁旻];910"],
	["[(始元)]2",	"",						      "911"],		# 天瑞景星, 安和, 貞祐, 初暦, 孝治?
	["[天応]1",	"[::_m:EpochEvents::Accession]",	"name=[鄭隆亶];927", "928"]
      ],
      [self,
	"period:[大天興]",
	["[尊聖]1",	"[::_m:EpochEvents::Foundation]",	"name=[趙善政];928^Chinese0523", "930"]
      ],
      [self,
	"period:[大義寧]",
	["[興聖]1",	"[::_m:EpochEvents::Foundation]",	"name=[楊宇真];930^Chinese0523"],
	["[大明]1",	"",						      "931", "938="]
      ],
      [self,
	"period:[大理,Dali]",
	["[文徳]1",	"[::_m:EpochEvents::Foundation]",	"name=[段思平];0938^Chinese0523"],
	["[(文徳)]2",	"",						      "0939"],	# 神武?
	["[文経]1",	"[::_m:EpochEvents::Accession]",	"name=[段思英];0945"],
	["[至治]1",	"[::_m:EpochEvents::Accession]",	"name=[段思良];0946", "0947^Chinese0956", ""],
	["[明徳]1",	"[::_m:EpochEvents::Accession]",	"name=[段思聡];0952"],
	["[(明徳)]2",	"",						      "0953"],	# 広徳?
	["[順徳]1",	"",						      "0968"],
	["[明政]1",	"[::_m:EpochEvents::Accession]",	"name=[段素順];0969"],
	["[広明]1",	"[::_m:EpochEvents::Accession]",	"name=[段素英];0986"],
	["[明応]1",	"",						      "1005"],
	["[(明応)]2",	"",						      "1006"],	# 明聖, 明徳, 明治?
	["[明啓]1",	"[::_m:EpochEvents::Accession]",	"name=[段素廉];1010"],
	["[明通]1",	"[::_m:EpochEvents::Accession]",	"name=[段素隆];1023"],
	["[正治]1",	"[::_m:EpochEvents::Accession]",	"name=[段素真];1027"],
	["[聖明]1",	"[::_m:EpochEvents::Accession]",	"name=[段素興];1042"],
	["[(聖明)]2",	"",						      "1043"],	# 天明?
	["[保安]1",	"[::_m:EpochEvents::Accession]",	"name=[段思廉];1045"],
	["[正安]1",	"",						      "1053"],
	["[(正安)]4",	"",						      "1056"],	# 正徳, 保徳?
	["[上徳]1",	"[::_m:EpochEvents::Accession]",	"name=[段連義];1076"],
	["[広安]1",	"",						      "1077"],
	["[上明]1",	"[::_m:EpochEvents::Accession]",	"name=[段寿輝];1081"],
	["[保立]1",	"[::_m:EpochEvents::Accession]",	"name=[段正明];1082"],
	["[(保立)]2",	"",						      "1083"],	# 建安, 天祐?
	["[上治]1",	"[::_m:EpochEvents::Accession]",	"name=[高昇泰];1095"],
	["[天授]1",	"[::_m:EpochEvents::Accession]",	"name=[段正淳];1096"],
	["[開明]1",	"",						      "1097"],
	["[天正]1",	"",						      "1103"],
	["[文安]1",	"",						      "1105"],
	["[日新]1",	"[::_m:EpochEvents::Accession]",	"name=[段正厳];1109"],
	["[文治]1",	"",						      "1110"],
	["[(文治)]10",	"",						      "1119"],	# 永嘉?
	["[保天]1",	"",						      "1129"],
	["[(保天)]9",	"",						      "1137"],	# 広運?
	["[永貞]1",	"[::_m:EpochEvents::Accession]",	"name=[段正興];1148"],
	["[大宝]1",	"",						      "1149"],
	["[(大宝)]8",	"",						      "1156"],	# 龍興, 盛明, 建徳?
	["[利貞]1",	"[::_m:EpochEvents::Accession]",	"name=[段智興];1172"],
	["[盛徳]1",	"",						      "1176"],
	["[嘉会]1",	"",						      "1181"],
	["[元亨]1",	"",						      "1185"],
	["[(元亨)]12",	"",						      "1196"],	# 安定?
	["[鳳暦]1",	"[::_m:EpochEvents::Accession]",	"name=[段智廉];1201"],
	["[(鳳暦)]2",	"",						      "1202"],	# 元寿?
	["[天開]1",	"[::_m:EpochEvents::Accession]",	"name=[段智祥];1205"],
	["[天輔]1",	"",						      "1226"],
	["[(天輔)]2",	"",						      "1227"],	# 仁寿?
	["[道隆]1",	"[::_m:EpochEvents::Accession]",	"name=[段祥興];1239"],
	["[天定]1",	"[::_m:EpochEvents::Accession]",	"name=[段興智];1252", "1254="]
      ]
    ]]
  end
end
