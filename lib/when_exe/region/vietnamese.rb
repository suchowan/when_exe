# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

require 'when_exe/region/chinese_calendar'

#
#  ベトナム王位年号一覧表
#
# （参考文献）
# コンサイス世界年表（三省堂）
# 歴代紀元編（台湾中華書局）
module When
  class TM::CalendarEra

    #
    # ベトナム
    #
    Vietnamese = [self, [
      "namespace:[ja=http://ja.wikipedia.org/wiki/, en=http://en.wikipedia.org/wiki/]",
      "locale:[=ja:, en=en:, alias]",
      "area:[ベトナム,Vietnam]",
      [self,
	"period:[呉朝]",
	["[呉権]1",	"[::_m:EpochEvents::Foundation]",	"name=[呉権];939^Chinese0939", "943="],
	["[天策王]1",	"[::_m:EpochEvents::Accession]",      "name=[天策王];952"],
	["[南晋王]1",	"[::_m:EpochEvents::Accession]",      "name=[南晋王];954"],
	["[呉昌熾]1",	"[::_m:EpochEvents::Accession]",      "name=[呉昌熾];966", "968"]
      ],
      [self,
	"period:[丁朝]",
	["[太平]1",	"[::_m:EpochEvents::Foundation]",      "name=[丁部領];968^Chinese0939"],
	["[太平]12",	"[::_m:EpochEvents::Accession]",	"name=[衛王];979", "980"]
      ],
      [self,
	"period:[前黎朝]",
	["[天福]1",	"[::_m:EpochEvents::Foundation]",	"name=[黎桓];980^Chinese0939"],
	["[興統]1",	"[::_m:EpochEvents::Accession]",		    "989"],
	["[応天]1",	"[::_m:EpochEvents::Accession]",		    "994"],
	["[応天]12",	"[::_m:EpochEvents::Accession]",	"name=[中宗];1005"],
	["[景瑞]1",	"[::_m:EpochEvents::Accession]",      "name=[臥朝王];1005", "1009"]
      ],
      [self,
	"period:[李朝]",
	["[順天]1",	"[::_m:EpochEvents::Foundation]",	"name=[太祖];1009^Chinese0939"],
	["[天成]1",	"[::_m:EpochEvents::Accession]",	"name=[太宗];1028"],
	["[通瑞]1",	"[::_m:EpochEvents::Accession]",		    "1034"],
	["[乾符有道]1",	"[::_m:EpochEvents::Accession]",		    "1039"],
	["[明道]1",	"[::_m:EpochEvents::Accession]",		    "1042"],
	["[天感聖武]1",	"[::_m:EpochEvents::Accession]",		    "1044"],
	["[崇興大宝]1",	"[::_m:EpochEvents::Accession]",		    "1049"],
	["[龍瑞太平]1",	"[::_m:EpochEvents::Accession]",	"name=[聖宗];1054"],
	["[彰聖嘉慶]1",	"[::_m:EpochEvents::Accession]",		    "1059"],
	["[龍章天嗣]1",	"[::_m:EpochEvents::Accession]",		    "1065"],
	["[天貺宝象]1",	"[::_m:EpochEvents::Accession]",		    "1067"],
	["[神武]1",	"[::_m:EpochEvents::Accession]",		    "1068"],
	["[太寧]1",	"[::_m:EpochEvents::Accession]",	"name=[仁宗];1072"],
	["[英武昭聖]1",	"[::_m:EpochEvents::Accession]",		    "1076"],
	["[広祐]1",	"[::_m:EpochEvents::Accession]",		    "1085"],
	["[会豊]1",	"[::_m:EpochEvents::Accession]",		    "1092"],
	["[龍符]1",	"[::_m:EpochEvents::Accession]",		    "1101"],
	["[会祥大慶]1",	"[::_m:EpochEvents::Accession]",		    "1109"],
	["[天符睿武]1",	"[::_m:EpochEvents::Accession]",		    "1118"],			# このあたり２年のズレがあるか？
	["[天符慶寿]1",	"[::_m:EpochEvents::Accession]",		    "1127"],
	["[天順]1",	"[::_m:EpochEvents::Accession]",	"name=[神宗];1128"],
	["[天彰宝嗣]1",	"[::_m:EpochEvents::Accession]",		    "1133.01.01"],
	["[紹明]1",	"[::_m:EpochEvents::Accession]",	"name=[英宗];1138"],
	["[大定]1",	"[::_m:EpochEvents::Accession]",		    "1140.01.01"],
	["[政隆宝応]1",	"[::_m:EpochEvents::Accession]",		    "1163.01.01"],
	["[天感至宝]1",	"[::_m:EpochEvents::Accession]",		    "1174.01.01"],
	["[貞符]1",	"[::_m:EpochEvents::Accession]",	"name=[高宗];1176"],
	["[天資嘉瑞]1",	"[::_m:EpochEvents::Accession]",		    "1186.01.01"],
	["[天資宝祐]1",	"[::_m:EpochEvents::Accession]",		    "1202.01.01"],
	["[治平龍応]1",	"[::_m:EpochEvents::Accession]",		    "1205"],
	["[建嘉]1",	"[::_m:EpochEvents::Accession]",	"name=[恵宗];1211"],
	["[天彰有道]1",	"[::_m:EpochEvents::Accession]",	"name=[昭皇];1224", "1225"]
      ],
      [self,
	"period:[陳朝]",
	["[建中]1",	"[::_m:EpochEvents::Foundation]",	"name=[太宗];1225^Chinese0939"],
	["[天応政平]1",	"[::_m:EpochEvents::Accession]",		    "1232.01.01"],
	["[元豊]1",	"[::_m:EpochEvents::Accession]",		    "1251.01.01"],
	["[紹隆]1",	"[::_m:EpochEvents::Accession]",	"name=[聖宗];1258"],
	["[宝符]1",	"[::_m:EpochEvents::Accession]",		    "1273.01.01"],
	["[紹宝]1",	"[::_m:EpochEvents::Accession]",	"name=[仁宗];1279"],
	["[重興]1",	"[::_m:EpochEvents::Accession]",		    "1285"],
	["[興隆]1",	"[::_m:EpochEvents::Accession]",	"name=[英宗];1293"],
	["[大慶]1",	"[::_m:EpochEvents::Accession]",	"name=[明宗];1314"],
	["[開泰]1",	"[::_m:EpochEvents::Accession]",		    "1324.01.01"],
	["[開祐]1",	"[::_m:EpochEvents::Accession]",	"name=[憲宗];1329"],
	["[紹豊]1",	"[::_m:EpochEvents::Accession]",	"name=[裕宗];1341"],
	["[大治]1",	"[::_m:EpochEvents::Accession]",		    "1358.01.01"],
	["[大定]1",	"[::_m:EpochEvents::Accession]",      "name=[楊日礼];1369"],
	["[紹慶]1",	"[::_m:EpochEvents::Accession]",	"name=[芸宗];1370"],
	["[隆慶]1",	"[::_m:EpochEvents::Accession]",	"name=[睿宗];1373"],
	["[昌符]1",	"[::_m:EpochEvents::Accession]",	"name=[廃帝];1377"],
	["[光泰]1",	"[::_m:EpochEvents::Accession]",	"name=[順宗];1388"],
	["[建新]1",	"[::_m:EpochEvents::Accession]",	"name=[少帝];1398", "1400="]
      ],
      [self,
	"period:[後陳朝]",
	["[興慶]1",	"[::_m:EpochEvents::Foundation]",     "name=[簡定帝];1407^Chinese0939"],
	["[重光]1",	"[::_m:EpochEvents::Accession]",      "name=[重光帝];1409", "1414.03="]
      ],
      [self,
	"period:[後黎朝]",
	["[順天]1",	"[::_m:EpochEvents::Foundation]",	"name=[太祖];1428^Chinese0939"],
	["[紹平]1",	"[::_m:EpochEvents::Accession]",	"name=[太宗];1434"],
	["[大宝]1",	"[::_m:EpochEvents::Accession]",		    "1440.01.01"],
	["[太和]1",	"[::_m:EpochEvents::Accession]",	"name=[仁宗];1443"],
	["[延寧]1",	"[::_m:EpochEvents::Accession]",		    "1454.01.01"],
	["[天興]1",	"[::_m:EpochEvents::Accession]",	"name=[廃帝];1459"],
	["[光順]1",	"[::_m:EpochEvents::Accession]",	"name=[聖宗];1460"],
	["[洪徳]1",	"[::_m:EpochEvents::Accession]",		    "1470.01.01"],
	["[景統]1",	"[::_m:EpochEvents::Accession]",	"name=[憲宗];1498"],
	["[泰貞]1",	"[::_m:EpochEvents::Accession]",	"name=[粛宗];1504"],
	["[端慶]1",	"[::_m:EpochEvents::Accession]",      "name=[威穆帝];1505"],
	["[洪順]1",	"[::_m:EpochEvents::Accession]",      "name=[襄翼帝];1509"],
	["[光紹]1",	"[::_m:EpochEvents::Accession]",	"name=[昭宗];1516"],
	["[統元]1",	"[::_m:EpochEvents::Accession]",	"name=[恭帝];1522", "1527="],
	["[元和]1",	"[::_m:EpochEvents::Accession]",	"name=[荘宗];1533"],
	["[順平]1",	"[::_m:EpochEvents::Accession]",	"name=[中宗];1549"],
	["[天祐]1",	"[::_m:EpochEvents::Accession]",	"name=[英宗];1557"],
	["[正治]1",	"[::_m:EpochEvents::Accession]",		    "1558.01.01"],
	["[洪福]1",	"[::_m:EpochEvents::Accession]",		    "1572.01.01"],
	["[嘉泰]1",	"[::_m:EpochEvents::Accession]",	"name=[世宗];1573"],
	["[光興]1",	"[::_m:EpochEvents::Accession]",		    "1578.01.01"],
	["[慎徳]1",	"[::_m:EpochEvents::Accession]",	"name=[敬宗];1600"],
	["[弘定]1",	"[::_m:EpochEvents::Accession]",		    "1600"],
	["[永祚]1",	"[::_m:EpochEvents::Accession]",	"name=[神宗];1619"],
	["[徳隆]1",	"[::_m:EpochEvents::Accession]",		    "1629.01.01"],
	["[陽和]1",	"[::_m:EpochEvents::Accession]",		    "1635.01.01"],
	["[福泰]1",	"[::_m:EpochEvents::Accession]",	"name=[真宗];1643", "1645^Chinese1645", ""],
	["[慶徳]1",	"[::_m:EpochEvents::Accession]",	"name=[神宗];1649"],
	["[盛徳]1",	"[::_m:EpochEvents::Accession]",		    "1653"],
	["[永寿]1",	"[::_m:EpochEvents::Accession]",		    "1658"],
	["[万慶]1",	"[::_m:EpochEvents::Accession]",	"name=[玄宗];1662"],
	["[景治]1",	"[::_m:EpochEvents::Accession]",		    "1663.01.01"],
	["[陽徳]1",	"[::_m:EpochEvents::Accession]",	"name=[嘉宗];1672"],
	["[徳元]1",	"[::_m:EpochEvents::Accession]",		    "1674"],
	["[永治]1",	"[::_m:EpochEvents::Accession]",	"name=[熙宗];1676"],
	["[正和]1",	"[::_m:EpochEvents::Accession]",		    "1680"],
	["[永盛]1",	"[::_m:EpochEvents::Accession]",	"name=[裕宗];1705"],
	["[保泰]1",	"[::_m:EpochEvents::Accession]",		    "1720.01.01"],
	["[永慶]1",	"[::_m:EpochEvents::Accession]",	"name=[廃帝];1729"],
	["[龍徳]1",	"[::_m:EpochEvents::Accession]",	"name=[純宗];1732"],
	["[永佑]1",	"[::_m:EpochEvents::Accession]",	"name=[懿宗];1735"],
	["[景興]1",	"[::_m:EpochEvents::Accession]",	"name=[顕宗];1740"],
	["[昭統]1",	"[::_m:EpochEvents::Accession]",	"name=[愍帝];1787", "1789.10="]
      ],
      [self,
	"period:[阮朝]",
	["[嘉隆]1",	"[::_m:EpochEvents::Foundation]",	"name=[世祖];1802^Chinese1645"],
	["[明命]1",	"[::_m:EpochEvents::Accession]",	"name=[聖祖];1820"],
	["[紹治]1",	"[::_m:EpochEvents::Accession]",	"name=[憲祖];1841"],
	["[嗣徳]1",	"[::_m:EpochEvents::Accession]",	"name=[翼宗];1848"],
	["[育徳]1",	"[::_m:EpochEvents::Accession]",      "name=[育徳帝];1883"],
	["[協和]1",	"[::_m:EpochEvents::Accession]",      "name=[協和帝];1883"],
	["[建福]1",	"[::_m:EpochEvents::Accession]",	"name=[簡宗];1884"],
	["[咸宜]1",	"[::_m:EpochEvents::Accession]",      "name=[咸宜帝];1885"],
	["[同慶]1",	"[::_m:EpochEvents::Accession]",	"name=[景宗];1885",
									    "1887.10.17^Gregorian?note=ChineseNotes", ""],
	["[成泰]1",	"[::_m:EpochEvents::Accession]",      "name=[成泰帝];1889"],
	["[維新]1",	"[::_m:EpochEvents::Accession]",      "name=[維新帝];1907"],
	["[啓定]1",	"[::_m:EpochEvents::Accession]",      "name=[啓定帝];1916"],
	["[保大]1",	"[::_m:EpochEvents::Accession]",      "name=[保大帝];1926", "1945.09.02="]
      ]
    ]]
  end
end
