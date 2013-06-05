# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

require 'when_exe/region/japanese'
require 'when_exe/region/chinese_calendar'

#
#  琉球王位一覧表
#
# （参考文献）
# 沖縄県の歴史（山川出版社）巻末年表など
# 沖縄の歴史と文化（中公新書）
# コンサイス世界年表（三省堂）
#
module When
  class TM::CalendarEra

    #
    # 琉球王朝
    #
    Ryukyu = [self, [
      "namespace:[ja=http://ja.wikipedia.org/wiki/, en=http://en.wikipedia.org/wiki/]",
      "locale:[=ja:, en=en:, alias]",
      "area:[琉球,Ryukyu]",
      [self,
	"period:[舜天王統]",										#  嗣    ～ 没 or 譲位
	["[舜天]1",	"[::_m:EpochEvents::Accession]",	"name=[舜天];1187^Chinese0956"],        # 文治  3～嘉禎  3(1237)       72歳
	["[舜馬順熙]1",	"[::_m:EpochEvents::Accession]",	"name=[舜馬順熙];1238"],                # 嘉禎  4～宝治  2(1248)       64歳
	["[義本]1",	"[::_m:EpochEvents::Accession]",	"name=[義本];1249" , "1259"]            # 宝治  3～正嘉  3(1259) 英祖に譲位
      ],
      [self,
	"period:[英祖王統]",
	["[英祖]0",	"[::_m:EpochEvents::Accession]",	"name=[英祖];1259^Chinese0939"],	# 正元  2～正安 元(1299)  8  5 71歳
	["[大成]0",	"[::_m:EpochEvents::Accession]",	"name=[大成];1299-08-05"],              # 正安  2～延慶 元(1308) 12  8 62歳
	["[英慈]0",	"[::_m:EpochEvents::Accession]",	"name=[英慈];1308-12-08"],              # 延慶  2～正和  2(1313)  9 20 46歳
	["[玉城]0",	"[::_m:EpochEvents::Accession]",	"name=[玉城];1313-09-20"],              # 正和  3～延元 元(1336)  3 11 41歳
	["[西威]0",	"[::_m:EpochEvents::Accession]",	"name=[西威];1336-03-11", "1349-04-13"] # 延元  2～貞和  5(1349)  4 13 22歳
      ],
      [self,
	"period:[中山王国]",
	["[察度]0",	"[::_m:EpochEvents::Accession]",	"name=[察度];1349-04-13^Chinese0939"],	# 貞和  6～応永  2(1395) 10  5 75歳
	["[武寧]0",	"[::_m:EpochEvents::Accession]",	"name=[武寧];1395-10-05", "1406"]	# 応永  3～応永 13(1406) 尚巴志が滅ぼす
      ],
      [self,
	"period:[山北王国]",
	["[怕尼芝]1",	"[::_m:EpochEvents::Accession]",	"name=[怕尼芝];1322^Chinese0939"],	# 1383年初めて明に朝貢 
	["[珉]0",	"[::_m:EpochEvents::Accession]",	"name=[珉];1395"],
	["[攀安知]0",	"[::_m:EpochEvents::Accession]",	"name=[攀安知];1400", "1416="]		# 永楽元年(1403)衣冠束帯を乞う 尚巴志が滅ぼす
      ],
      [self,
	"period:[山南王国]",
	["[承察度]1",	"[::_m:EpochEvents::Accession]",	"name=[承察度];1337^Chinese0939"],	# 1380年初めて明に朝貢 
	["[汪英紫]1",	"[::_m:EpochEvents::Accession]",	"name=[汪英紫];1388"],
	["[汪応祖]0",	"[::_m:EpochEvents::Accession]",	"name=[汪応祖];1402"],			# 承察度の従弟 明永楽２年(1404)冊封
	["[他魯毎]0",	"[::_m:EpochEvents::Accession]",	"name=[他魯毎];1413", "1429="]		# 汪応祖の子 永楽14年(1416)冊封 尚巴志が滅ぼす
      ],
      [self,
	"period:[第一尚氏]",
	["[尚思紹王]1",	"[::_m:EpochEvents::Accession]",	"name=[尚思紹王];1406^Chinese0939"],	# 応永 13～応永 28(1421)
	["[尚巴志王]0",	"[::_m:EpochEvents::Accession]",	"name=[尚巴志王];1421"],                # 応永 29～永享 11(1439)  4 20 68歳
	["[尚忠王]0",	"[::_m:EpochEvents::Accession]",	"name=[尚忠王];1439-04-20"],            # 永享 12～文安 元(1444) 10 24 54歳
	["[尚思達王]0",	"[::_m:EpochEvents::Accession]",	"name=[尚思達王];1444-10-24"],          # 文安  2～宝徳 元(1449) 10 13 42歳
	["[尚金福王]0",	"[::_m:EpochEvents::Accession]",	"name=[尚金福王];1449-10-13"],          # 宝徳  2～享徳  2(1453)  4 29 56歳
	["[尚泰久王]0",	"[::_m:EpochEvents::Accession]",	"name=[尚泰久王];1453-04-29"],          # 享徳  3～長禄  4(1460)  6  5 46歳
	["[尚徳王]0",	"[::_m:EpochEvents::Accession]",	"name=[尚徳王];1460-06-05","1469-04-23"]# 寛正  2～応仁  3(1469)  4 22 29歳
      ],
      [self,
	"period:[第二尚氏]",
	["[尚円王]0",	"[::_m:EpochEvents::Accession]",	"name=[尚円王];1469-04-23^Chinese0939"],# 文明  2～文明  8(1476)  7 28 62歳
	["[尚宣威王]0",	"[::_m:EpochEvents::Accession]",	"name=[尚宣威王];1476-07-28"],          # 文明  9～同年   (1477)  8  4 48歳 没
	["[尚真王]1",	"[::_m:EpochEvents::Accession]",	"name=[尚真王];1477-08-05"],            # 文明  9～大永  6(1526) 12 11 62歳
	["[尚清王]0",	"[::_m:EpochEvents::Accession]",	"name=[尚清王];1526-12-12"],            # 大永  7～天文 24(1555)  6 25 59歳
	["[尚元王]0",	"[::_m:EpochEvents::Accession]",	"name=[尚元王];1555-06-25"],            # 弘治  2～元亀  3(1572)  4  1 45歳
	["[尚永王]0",	"[::_m:EpochEvents::Accession]",	"name=[尚永王];1572-04-01"],            # 天正 元～天正 16(1588) 11 25 30歳
	["[尚寧王]0",	"[::_m:EpochEvents::Accession]",	"name=[尚寧王];1588-11-25",             # 天正 17～元和  6(1620)  9 19 57歳
							 "1609-04-05^Japanese?note=ChineseNotes", ""],	# 慶長 14(1609)  4  5 尚寧、島津と和議
	["[尚豊王]0",	"[::_m:EpochEvents::Accession]",	"name=[尚豊王];1620-09-19"],            # 元和  7～寛永 17(1640)  5  4 51歳
	["[尚賢王]0",	"[::_m:EpochEvents::Accession]",	"name=[尚賢王];1640-05-04"],            # 寛永 18～正保  4(1647)  9 22 23歳
	["[尚質王]0",	"[::_m:EpochEvents::Accession]",	"name=[尚質王];1647-09-22"],            # 慶安 元～寛文  8(1668) 11 17 40歳
	["[尚貞王]0",	"[::_m:EpochEvents::Accession]",	"name=[尚貞王];1668-11-17"],            # 寛文  9～宝永  6(1709)  7 13 65歳
	["[尚益王]0",	"[::_m:EpochEvents::Accession]",	"name=[尚益王];1709-07-13"],            # 宝永  7～正徳  2(1712)  7 15 35歳
	["[尚敬王]0",	"[::_m:EpochEvents::Accession]",	"name=[尚敬王];1712-07-15"],            # 正徳  3～寛延  4(1751)  1 29 52歳
	["[尚穆王]0",	"[::_m:EpochEvents::Accession]",	"name=[尚穆王];1751-01-29"],            # 宝暦  2～寛政  6(1794)  4  8 56歳
	["[尚温王]0",	"[::_m:EpochEvents::Accession]",	"name=[尚温王];1794-04-08"],            # 寛政  7～享和  2(1802)  7 11 19歳
	["[尚成王]0",	"[::_m:EpochEvents::Accession]",	"name=[尚成王];1802-07-11"],            # 享和  3～同年   (1803) 12 26  4歳
	["[尚灝王]0",	"[::_m:EpochEvents::Accession]",	"name=[尚灝王];1803-12-26"],            # 文化 元～文政 10(1827) 出家
	["[尚育摂位=]0",	"",				"name=[尚育王];1827"],			# 文政 11(1828) 摂位
	["[尚育王]7",	"[::_m:EpochEvents::Accession]",	"name=[尚育王];1834-05-29"],            # 天保  6～弘化  4(1847)  9 17 35歳
	["[尚泰王]0",	"[::_m:EpochEvents::Accession]",	"name=[尚泰王];1847-09-17",             # 弘化  5～明治 12(1879)  3 31 琉球処分
								 "1873-01-01^Gregorian", "1879-03-31="] #          明治 34(1901)  8 19 59歳 没
      ]
    ]]
  end
end
