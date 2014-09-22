# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

require 'when_exe/region/japanese/calendars'

module When
  class TM::CalendarEra

    #
    # 日本の年号
    #
    Japanese = [{}, self, [
      "locale:[=ja:, en=en:, alias]",
      'area:[日本#{?V=V}=ja:%%<元号>#%.<日本>,Japan#{?V=V}=en:Regnal_year#Japanese]',
      [self,
	"period:[飛鳥時代]",
	["[推古]1",			"@A",	"name=[推古];0593-01-01^Japanese"],
	["[舒明]1",			"@A",	"name=[舒明];0629-01-04"],
	["[皇極]1",			"@A",	"name=[皇極];0642-01-15"],
	["[大化]1",			"@A",	"name=[孝徳];0645-06-19"],
	["[白雉]1",			"@FE",	"	     0650-02-15"],
	["[斉明]1",			"@A",	"name=[斉明];0655-01-03"],
	["[天智]1",			"@A",	"name=[天智];0662-01-01"],
	["[弘文]1",			"@A",	"name=[弘文];0672-01-01"],
	["[天武]1",			"@A",	"name=[天武];0673-02-27"],
	["[朱鳥]1",			"",	"	     0686-07-20"],
	["[持統]1",			"@A",	"name=[持統];0687-01-01"],
	["[文武=ja:%%<文武天皇>]1",	"@A",	"name=[文武=ja:%%<文武天皇>];0697-08-01"],
	["[大宝=ja:%%<大宝_日本>]1",	"@FE",	"	     0701-03-21"],
	["[慶雲]1",			"@FE",	"	     0704-05-10"],
	["[和銅]1",			"@A",	"name=[元明];0708-01-11", "0710-03-10"]
      ],
      [self,
	"period:[奈良時代]",
	["[和銅]3",			"@A",	"name=[元明];0710-03-10^Japanese"],
	["[霊亀]1",			"@A",	"name=[元正];0715-09-02"],
	["[養老]1",			"@FE",	"	     0717-11-17"],
	["[神亀]1",		"[代始・祥瑞=]","name=[聖武=ja:%%<聖武天皇>];0724-02-04"],
	["[天平]1",			"@FE",	"	     0729-08-05"],
	["[天平感宝]1",			"@FE",	"	     0749-04-14"],
	["[天平勝宝]1",			"@A",	"name=[孝謙];0749-07-02"],
	["[天平宝字]1",			"@FE",	"	     0757-08-18",
				"name=[淳仁=ja:%%<淳仁天皇>];0758-08-01", '0764-01-01^Japanese#{V}', ""],
	["[天平神護]1",	"@A",	"name=[称徳=ja:%%<称徳天皇>];0765-01-07"],
	["[神護景雲]1",			"@FE",	"	     0767-08-16"],
	["[宝亀]1",		"[代始・祥瑞]",	"name=[光仁];0770-10-01"],
	["[天応=ja:%%<天応_(日本)>]1",	"@FE",	"	     0781-01-01"],
	["[延暦]1",	"@A",	"name=[桓武=ja:%%<桓武天皇>];0782-08-19", "0794-10-22"]
      ],
      [self,
	"period:[平安時代]",
	["[延暦]13",	"",	'name=[桓武=ja:%%<桓武天皇>];0794-10-22^Japanese#{V}'],
	["[大同=ja:%%<大同_(日本)>]1",	"@A",	"name=[平城=ja:%%<平城天皇>];0806-05-18"],
	["[弘仁]1",	"@A",	"name=[嵯峨=ja:%%<嵯峨天皇>];0810-09-19"],
	["[天長]1",	"@A",	"name=[淳和=ja:%%<淳和天皇>];0824-01-05"],
	["[承和=ja:%%<承和_(日本)>]1",	"@A",	"name=[仁明=ja:%%<仁明天皇>];0834-01-03"],
	["[嘉祥]1",			"@FE",	"	     0848-06-13"],
	["[仁寿]1","[代始・祥瑞=]","name=[文徳=ja:%%<文徳天皇>];0851-04-28"],
	["[斉衡]1",			"@FE",	"	     0854-11-30"],
	["[天安=ja:%%<天安_(日本)>]1",	"@FE",	"	     0857-02-21"],
	["[貞観=ja:%%<貞観_(日本)>]1",	"@A",	"name=[清和=ja:%%<清和天皇>];0859-04-15", "0862-01-01^Japanese", ""],
	["[元慶]1",		"[代始・祥瑞=]","name=[陽成];0877-04-16"],
	["[仁和]1",			"@A",	"name=[光孝];0885-02-21"],
	["[寛平]1",			"@A",	"name=[宇多];0889-04-27"],
	["[昌泰]1",	"@A",	"name=[醍醐=ja:%%<醍醐天皇>];0898-04-26"],
	["[延喜]1",			"@IY",	"	     0901-07-15"],
	["[延長=ja:%%<延長_(元号)>]1",	"@ND",	"	     0923-04=11"],
	["[承平=ja:%%<承平_(日本)>]1",	"@A",	"name=[朱雀=ja:%%<朱雀天皇>];0931-04-26"],
	["[天慶]1",			"@ND",	"	     0938-05-22"],
	["[天暦]1",	"@A",	"name=[村上=ja:%%<村上天皇>];0947-04-22"],
	["[天徳=ja:%%<天徳_(日本)>]1",	"@ND",	"	     0957-10-27"],
	["[応和]1",			"[災異・革年=]","    0961-02-16"],
	["[康保]1",			"[災異・革年=]","    0964-07-10"],
	["[安和]1",	"@A",	"name=[冷泉=ja:%%<冷泉天皇>];0968-08-13"],
	["[天禄]1",			"@A",	"name=[円融];0970-03-25"],
	["[天延]1",			"@ND",	"	     0973-12-20"],
	["[貞元=ja:%%<貞元_(日本)>]1",	"@ND",	"	     0976-07-13"],
	["[天元=ja:%%<天元_(日本)>]1",	"@ND",	"	     0978-11-29"],
	["[永観]1",			"@ND",	"	     0983-04-15"],
	["[寛和]1",	"@A",	"name=[花山=ja:%%<花山天皇>];0985-04-27"],
	["[永延]1",	"@A",	"name=[一条=ja:%%<一条天皇>];0987-04-05"],
	["[永祚=ja:%%<永祚_(日本)>]1",	"@ND",	"	     0989-08-08"],
	["[正暦]1",			"@ND",	"	     0990-11-07"],
	["[長徳]1",			"@ND",	"	     0995-02-22"],
	["[長保]1",			"@ND",	"	     0999-01-13"],
	["[寛弘]1",			"@ND",	"	     1004-07-20"],
	["[長和]1",	"@A",	"name=[三条=ja:%%<三条天皇>];1012-12-25"],
	["[寛仁]1",			"@A",	"name=[後一条];1017-04-23"],
	["[治安=ja:%%<治安_(元号)>]1",	"@IY",	"	     1021-02-02"],
	["[万寿]1",			"@IY",	"	     1024-07-13"],
	["[長元]1",			"@ND",	"	     1028-07-25"],
	["[長暦]1",			"@A",	"name=[後朱雀];1037-04-21"],
	["[長久]1",			"@ND",	"	     1040-11-10"],
	["[寛徳]1",			"@ND",	"	     1044-11-24"],
	["[永承]1",			"@A",	"name=[後冷泉];1046-04-14"],
	["[天喜]1",			"@ND",	"	     1053-01-11"],
	["[康平]1",			"@ND",	"	     1058-08-29"],
	["[治暦]1",			"@ND",	"	     1065-08-02"],
	["[延久]1",			"@A",	"name=[後三条];1069-04-13"],
	["[承保]1",	"@A",	"name=[白河=ja:%%<白河天皇>];1074-08-23"],
	["[承暦]1",			"@ND",	"	     1077-11-17"],
	["[永保]1",			"@IY",	"	     1081-02-10"],
	["[応徳]1",			"@IY",	"	     1084-02-07"],
	["[寛治]1",	"@A",	"name=[堀河=ja:%%<堀河天皇>];1087-04-07"],
	["[嘉保]1",			"@ND",	"	     1094-12-15"],
	["[永長]1",			"@ND",	"	     1096-12-17"],
	["[承徳]1",			"@ND",	"	     1097-11-21"],
	["[康和]1",			"@ND",	"	     1099-08-28"],
	["[長治]1",			"@ND",	"	     1104-02-10"],
	["[嘉承]1",			"@ND",	"	     1106-04-09"],
	["[天仁]1",	"@A",	"name=[鳥羽=ja:%%<鳥羽天皇>];1108-08-03"],
	["[天永]1",			"@ND",	"	     1110-07-13"],
	["[永久=ja:%%<永久_(元号)>]1",	"@ND",	"	     1113-07-13"],
	["[元永]1",			"@ND",	"	     1118-04-03"],
	["[保安=ja:%%<保安_(元号)>]1",	"@ND",	"	     1120-04-10"],
	["[天治]1",	"@A",	"name=[崇徳=ja:%%<崇徳天皇>];1124-04-03"],
	["[大治=ja:%%<大治_(日本)>]1",	"@ND",	"	     1126-01-22"],
	["[天承]1",			"@ND",	"	     1131-01-29"],
	["[長承]1",			"@ND",	"	     1132-08-11"],
	["[保延]1",			"@ND",	"	     1135-04-27"],
	["[永治]1",			"@IY",	"	     1141-07-10"],
	["[康治]1",	"@A",	"name=[近衛=ja:%%<近衛天皇>];1142-04-28"],
	["[天養]1",			"@IY",	"	     1144-02-23"],
	["[久安]1",			"@ND",	"	     1145-07-22"],
	["[仁平]1",			"@ND",	"	     1151-01-26"],
	["[久寿]1",			"@ND",	"	     1154-10-28"],
	["[保元]1",			"@A",	"name=[後白河];1156-04-27"],
	["[平治]1",	"@A",	"name=[二条=ja:%%<二条天皇>];1159-04-20"],
	["[永暦]1",			"@ND",	"	     1160-01-10"],
	["[応保]1",			"@ND",	"	     1161-09-04"],
	["[長寛]1",			"@ND",	"	     1163-03-29"],
	["[永万]1",			"@ND",	"	     1165-06-05"],
	["[仁安=ja:%%<仁安_(日本)>]1",	"@A",	"name=[六条=ja:%%<六条天皇>];1166-08-27"],
	["[嘉応]1",	"@A",	"name=[高倉=ja:%%<高倉天皇>];1169-04-08"],
	["[承安=ja:%%<承安_(日本)>]1",	"@ND",	"	     1171-04-21"],
	["[安元]1",			"@ND",	"	     1175-07-28"],
	["[治承]1",			"@ND",	"	     1177-08-04"],
	["[養和]1",	"@A",	"name=[安徳=ja:%%<安徳天皇>];1181-07-14"],
	["[寿永]1",	"@ND",	"	     1182-05-27", "1183-08-20"]
      ],
      [self,
	"period:[平氏方=ja:%%<平氏>]",
	["[寿永]2",	"",	"name=[安徳=ja:%%<安徳天皇>];1183-08-20^Japanese", "1185-03-24="]
      ],
      [self,
	"period:[源氏方=ja:%%<源氏>]",
	["[治承]5",	"",	"name=[高倉=ja:%%<高倉天皇>];1181-07-14^Japanese"],
	["[元暦]1",	"@A",	"name=[後鳥羽];1184-04-16", "1185-03-24="]
      ],
      [self,
	"period:[鎌倉時代]",
	["[元暦]2",			"",   "name=[後鳥羽];1185-03-24=^Japanese"],
	["[文治]1",			"@ND",	"	     1185-08-14"],
	["[建久]1",			"@ND",	"	     1190-04-11"],
	["[正治]1",	"@A","name=[土御門=ja:%%<土御門天皇>];1199-04-27"],
	["[建仁]1",			"@IY",	"	     1201-02-13"],
	["[元久]1",			"@IY",	"	     1204-02-20"],
	["[建永]1",			"@ND",	"	     1206-04-27"],
	["[承元]1",			"@ND",	"	     1207-10-25"],
	["[建暦]1",	"@A",	"name=[順徳=ja:%%<順徳天皇>];1211-03-09"],
	["[建保]1",			"@ND",	"	     1213-12-06"],
	["[承久]1",			"@ND",	"	     1219-04-12",
				"name=[仲恭=ja:%%<仲恭天皇>];1221-04-20", ""],
	["[貞応]1",			"@A", "name=[後堀河];1222-04-13"],
	["[元仁]1",			"@ND",	"	     1224-11-20"],
	["[嘉禄]1",			"@ND",	"	     1225-04-20"],
	["[安貞]1",			"@ND",	"	     1227-12-10"],
	["[寛喜]1",			"@ND",	"	     1229-03-05"],
	["[貞永]1",			"@ND",	"	     1232-04-02"],
	["[天福=ja:%%<天福_(日本)>]1",	"@A",	"name=[四条=ja:%%<四条天皇>];1233-04-15"],
	["[文暦]1",			"@ND",	"	     1234-11-05"],
	["[嘉禎]1",			"@ND",	"	     1235-09-19"],
	["[暦仁]1",			"@ND",	"	     1238-11-23"],
	["[延応]1",			"@ND",	"	     1239-02-07"],
	["[仁治]1",			"@ND",	"	     1240-07-16"],
	["[寛元]1",			"@A",	"name=[後嵯峨];1243-02-26"],
	["[宝治]1",			"@A",	"name=[後深草];1247-02-28"],
	["[建長]1",			"@ND",	"	     1249-03-18"],
	["[康元]1",			"@ND",	"	     1256-10-05"],
	["[正嘉]1",			"@ND",	"	     1257-03-14"],
	["[正元=ja:%%<正元_(日本)>]1",	"@ND",	"	     1259-03-26"],
	["[文応]1",	"@A",	"name=[亀山=ja:%%<亀山天皇>];1260-04-13"],
	["[弘長]1",			"@IY",	"	     1261-02-20"],
	["[文永]1",			"@IY",	"	     1264-02-28"],
	["[建治]1",			"@A",	"name=[後宇多];1275-04-25"],
	["[弘安]1",			"@ND",	"	     1278-02-29"],
	["[正応]1",	"@A",	"name=[伏見=ja:%%<伏見天皇>];1288-04-28"],
	["[永仁]1",			"@ND",	"	     1293-08-05"],
	["[正安]1",			"@A",	"name=[後伏見];1299-04-25"],
	["[乾元=ja:%%<乾元_(日本)>]1",	"@A",	"name=[後二条];1302-11-21"],
	["[嘉元]1",			"@ND",	"	     1303-08-05"],
	["[徳治]1",			"@ND",	"	     1306-12-14"],
	["[延慶=ja:%%<延慶_(日本)>]1",	"@A",	"name=[花園=ja:%%<花園天皇>];1308-10-09"],
	["[応長]1",			"@ND",	"	     1311-04-28"],
	["[正和]1",			"@ND",	"	     1312-03-20"],
	["[文保]1",			"@ND",	"	     1317-02-03"],
	["[元応]1",			"@A",	"name=[後醍醐];1319-04-28"],
	["[元亨]1",			"@IY",	"	     1321-02-23"],
	["[正中=ja:%%<正中_(元号)>]1",	"@ND",	"	     1324-12-09"],
	["[嘉暦]1",			"@ND",	"	     1326-04-26"],
	["[元徳]1",			"@ND",	"	     1329-08-29"],
	["[元弘]1",			"@ND",	"	     1331-08-09", "1333-05-18"]
      ],
      [self,
	"period:[大覚寺統]",
	["[元弘]3",	"",	"name=[後醍醐];1333-05-18^Japanese"],
	["[建武=ja:%%<建武_(日本)>]1",	"[撥乱帰正=]","	     1334-01-29", "1336-02-29"]
      ],
      [self,
	"period:[南朝]",
	["[延元]1",			"@ND",	"name=[後醍醐];1336-02-29^Japanese"],
	["[興国]1",			"@A",	"name=[後村上];1340-04-28"],
	["[正平=ja:%%<正平_(日本)>]1",	"@ND",	"	     1346-12-08"],
	["[建徳]1",	"@A",	"name=[長慶=ja:%%<長慶天皇>];1370-07-24"],
	["[文中]1",			"@ND",	"	     1372-04"],
	["[天授=ja:%%<天授_(日本)>]1",	"@ND",	"	     1375-05-27"],
	["[弘和]1",			"@IY",	"	     1381-02-10"],
	["[元中]1",	"@IY",	"name=[後亀山];1384-04-28", "1392-10=06"]
      ],
      [self,
	"period:[持明院統]",
	["[元徳]3",			"",	"      name=;1331-08-09^Japanese",
						"name=[光厳];1331-09-20", ""],
	["[正慶]1",	"@A",			"	     1332-04-28", "1333-05-18"]
      ],
      [self,
	"period:[北朝]",
	["[建武=ja:%%<建武_(日本)>]3",		"",   "name=;1336-02-29^Japanese",
				"name=[光明=ja:%%<光明天皇>];1336-08-15", ""],
	["[暦応]1",			"@A",	"	     1338-08-28"],
	["[康永]1",			"@ND",	"	     1342-04-27"],
	["[貞和]1",			"@ND",	"	     1345-10-21"],
	["[観応]1",	"@A",	"name=[崇光=ja:%%<崇光天皇>];1350-02-27", "1351-11-08"],
	["[観応]3",			"",   "name=[後光厳];1352-08-17"],
	["[文和]1",			"@A",	"	     1352-09-27"],
	["[延文]1",			"@ND",	"	     1356-03-28"],
	["[康安]1",			"@ND",	"	     1361-03-29"],
	["[貞治]1",			"@ND",	"	     1362-09-23"],
	["[応安]1",			"@ND",	"	     1368-02-18",
					      "name=[後円融];1371-03-23", ""],
	["[永和=ja:%%<永和_(日本)>]1",	"@A",	"	     1375-02-27"],
	["[康暦]1",			"@ND",	"	     1379-03-22"],
	["[永徳]1",			"@IY",	"	     1381-02-24"],
	["[至徳=ja:%%<至徳_(日本)>]1",	"[代始・革年=]","name=[後小松];1384-02-27"],
	["[嘉慶=ja:%%<嘉慶_(日本)>]1",	"@ND",	"	     1387-08-23"],
	["[康応]1",			"@ND",	"	     1389-02-09"],
	["[明徳]1",			"@ND",	"	     1390-03-26", "1392-10=06"]
      ],
      [self,
	"period:[室町時代]",
	["[明徳]3",			"",	"name=[後小松];1392-10=06^Japanese"],
	["[応永]1",			"@ND",	"	     1394-07-05",
				"name=[称光=ja:%%<称光天皇>];1412-08-29", ""],
	["[正長]1",			"",	"	     1428-04-27"],
	["[永享]1",			"@A",	"name=[後花園];1429-09-05"],
	["[嘉吉]1",			"@IY",	"	     1441-02-17"],
	["[文安]1",			"@IY",	"	     1444-02-05"],
	["[宝徳]1",			"@ND",	"	     1449-07-28"],
	["[享徳]1",			"@ND",	"	     1452-07-25"],
	["[康正]1",			"@ND",	"	     1455-07-25"],
	["[長禄]1",			"@ND",	"	     1457-09-28"],
	["[寛正]1",			"@ND",	"	     1460-12-21"],
	["[文正]1",			"@A",	"name=[後土御門];1466-02-28"],
	["[応仁]1",			"@ND",	"	     1467-03-05"],
	["[文明=ja:%%<文明_(日本)>]1",	"@ND",	"	     1469-04-28"],
	["[長享]1",			"@ND",	"	     1487-07-20"],
	["[延徳]1",			"@ND",	"	     1489-08-21"],
	["[明応]1",			"@ND",	"	     1492-07-19"],
	["[文亀]1",	"[代始・革年=]",	"name=[後柏原];1501-02-29"],
	["[永正]1",			"@IY",	"	     1504-02-30"],
	["[大永]1",			"@ND",	"	     1521-08-23"],
	["[享禄]1",			"@A",	"name=[後奈良];1528-08-20"],
	["[天文=ja:%%<天文_(元号)>]1",	"@ND",	"	     1532-07-29"],
	["[弘治=ja:%%<弘治_(日本)>]1",	"@ND",	"	     1555-10-23"],
	["[永禄]1",			"@A",	"name=[正親町];1558-02-28"],
	["[元亀]1",			"@ND",	"	     1570-04-23", "1573-07-28"]
      ],
      [self,
	"period:[安土桃山時代]",
	["[天正]1",			"@ND",	"	     1573-07-28^Japanese",
					      "name=[後陽成];1586-11-07", ""],
	["[文禄]1",			"@A",	"	     1592-12-08"],
	["[慶長]1",	"@ND",			"	     1596-10-27", "1603-02-12"]
      ],
      [self,
	"period:[江戸時代]",
	["[慶長]8",			"",	"name=[後陽成];1603-02-12^Japanese",
						"name=[後水尾];1611-03-27", ""],
	["[元和=ja:%%<元和_(日本)>]1",	"[代始・災異=]","     1615-07-13"],
	["[寛永]1",			"@IY",	"	     1624-02-30",
				"name=[明正=ja:%%<明正天皇>];1629-11-08", ""],
	["[正保]1",			"@A",	"name=[後光明];1644-12-16"],
	["[慶安]1",			"",	"	     1648-02-15"],
	["[承応]1",			"",	"	     1652-09-18"],
	["[明暦]1",			"@A",	"name=[後西];1655-04-13"],
	["[万治]1",			"@ND",	"	     1658-07-23"],
	["[寛文]1",			"@ND",	"	     1661-04-25",
						"name=[霊元];1663-01-26", ""],
	["[延宝]1",			"@ND",	"	     1673-09-21"],
	["[天和=ja:%%<天和_(日本)>]1",	"@IY",	"	     1681-09-29"],
	["[貞享]1",			"@IY",	"	     1684-02-21"],
	["[元禄]1",	"@A",	"name=[東山=ja:%%<東山天皇>];1688-09-30"],
	["[宝永]1",			"@ND",	"	     1704-03-13"],
	["[正徳=ja:%%<正徳_(日本)>]1",	"@A",	"name=[中御門];1711-04-25"],
	["[享保]1",			"[関東凶事=]","	     1716-06-22"],
	["[元文]1",	"@A",	"name=[桜町=ja:%%<桜町天皇>];1736-04-28"],
	["[寛保]1",			"@IY",	"	     1741-02-27"],
	["[延享]1",			"@IY",	"	     1744-02-21"],
	["[寛延]1",	"@A",	"name=[桃園=ja:%%<桃園天皇>];1748-07-12"],
	["[宝暦]1",			"",	"	     1751-10-27"],
	["[明和]1",			"@A",	"name=[後桜町];1764-06-02"],
	["[安永=ja:%%<安永_(元号)>]1",	"[代始・災異=]", "name=[後桃園];1772-11-16"],
	["[天明]1",			"@A",	"name=[光格];1781-04-02"],
	["[寛政]1",			"@ND",	"	     1789-01-25"],
	["[享和]1",			"@IY",	"	     1801-02-05"],
	["[文化=ja:%%<文化_(元号)>]1",	"@IY",	"	     1804-02-11"],
	["[文政]1",	"@A",	"name=[仁孝=ja:%%<仁孝天皇>];1818-04-22"],
	["[天保]1",			"@ND",	"	     1830-12-10"],
	["[弘化]1",			"@ND",	"	     1844-12-02"],
	["[嘉永]1",			"@A",	"name=[孝明];1848-02-28"],
	["[安政]1",			"@ND",	"	     1854-11-27"],
	["[万延]1",			"@ND",	"	     1860-03-18"],
	["[文久]1",			"@IY",	"	     1861-02-19"],
	["[元治]1",			"@IY",	"	     1864-02-20"],
	["[慶応]1",			"@ND",	"	     1865-04-08", "1868-09-08"]
      ],
      ["[明治,Meiji=en:Meiji_period,M]1",		"@A",
				"name=[明治天皇,Emperor_Meiji];1868-09-08^Japanese", "1873-01-01^Gregorian?note=Japanese", ""],
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
      "locale:[=ja:, en=en:, alias]",
      "area:[日本,Japan]",
      ["[伊藤博文]1.12.22",				"@A", "name=[明治天皇,Emperor_Meiji];1885-12-22^Gregorian"],
      ["[黒田清隆]1.04.30",				"@A", "1888-04-30"],
      ["[山県有明]1.12.24",				"@A", "1889-12-24"],
      ["[松方正義]1.05.06",				"@A", "1891-05-06"],
      ["[伊藤博文･再=ja:%%<伊藤博文>]1.08.08",		"@A", "1892-08-08"],
      ["[松方正義･再=ja:%%<松方正義>]1.09.18",		"@A", "1896-09-18"],
      ["[伊藤博文･三=ja:%%<伊藤博文>]1.01.12",		"@A", "1898-01-12"],
      ["[大隈重信]1.06.30",				"@A", "1898-06-30"],
      ["[山県有明･再=ja:%%<山県有明>]1.11.08",		"@A", "1898-11-08"],
      ["[伊藤博文･四=ja:%%<伊藤博文>]1.10.19",		"@A", "1900-10-19"],
      ["[桂太郎]1.06.02",				"@A", "1901-06-02"],
      ["[西園寺公望]1.01.07",				"@A", "1906-01-07"],
      ["[桂太郎･再=ja:%%<桂太郎>]1.07.14",		"@A", "1908-07-14"],
      ["[西園寺公望･再=ja:%%<西園寺公望>]1.08.30",	"@A", "1911-08-30", "name=[大正天皇,Emperor_Taishō];1912-07-30", ""],
      ["[桂太郎･三=ja:%%<桂太郎>]1.12.21",		"@A", "1912-12-21"],
      ["[山本権兵衛]1.02.20",				"@A", "1913-02-20"],
      ["[大隈重信･再=ja:%%<大隈重信>]1.04.16",		"@A", "1914-04-16"],
      ["[寺内正毅]1.10.09",				"@A", "1916-10-09"],
      ["[原敬]1.09.29",					"@A", "1918-09-29"],
      ["[高橋是清]1.11.13",				"@A", "1921-11-13"],
      ["[加藤友三郎]1.06.12",				"@A", "1922-06-12"],
      ["[山本権兵衛･再=ja:%%<山本権兵衛>]1.09.02",	"@A", "1923-09-02"],
      ["[清浦奎吾]1.01.07",				"@A", "1924-01-07"],
      ["[加藤高明]1.06.11",				"@A", "1924-06-11"],
      ["[若槻礼次郎]1.01.30",				"@A", "1926-01-30","name=[昭和天皇,Emperor_Shōwa];1926-12-25", ""],
      ["[田中義一]1.04.20",				"@A", "1927-04-20"],
      ["[浜口雄幸]1.07.02",				"@A", "1929-07-02"],
      ["[若槻礼次郎･再=ja:%%<若槻礼次郎>]1.04.14",	"@A", "1931-04-14"],
      ["[犬養毅]1.12.13",				"@A", "1931-12-13"],
      ["[斎藤実]1.05.26",				"@A", "1932-05-26"],
      ["[岡田啓介]1.07.08",				"@A", "1934-07-08"],
      ["[広田弘毅]1.03.09",				"@A", "1936-03-09"],
      ["[林銑十郎]1.02.02",				"@A", "1937-02-02"],
      ["[近衛文磨]1.06.04",				"@A", "1937-06-04"],
      ["[平沼騏一郎]1.01.05",				"@A", "1939-01-05"],
      ["[阿部信行]1.08.30",				"@A", "1939-08-30"],
      ["[米内光政]1.01.16",				"@A", "1940-01-16"],
      ["[近衛文磨･再=ja:%%<近衛文磨>]1.07.22",		"@A", "1940-07-22"],
      ["[東条英機]1.10.18",				"@A", "1941-10-18"],
      ["[小磯国昭]1.07.22",				"@A", "1944-07-22"],
      ["[鈴木貫太郎]1.04.07",				"@A", "1945-04-07"],
      ["[東久邇宮稔彦王]1.08.17",			"@A", "1945-08-17"],
      ["[幣原喜重郎]1.10.09",				"@A", "1945-10-09"],
      ["[吉田茂]1.05.22",				"@A", "1946-05-22"],
      ["[片山哲]1.05.24",				"@A", "1947-05-24"],
      ["[芦田均]1.03.10",				"@A", "1948-03-10"],
      ["[吉田茂･再=ja:%%<吉田茂>]1.10.19",		"@A", "1948-10-19"],
      ["[鳩山一郎]1.12.10",				"@A", "1954-12-10"],
      ["[石橋湛山]1.12.23",				"@A", "1956-12-23"],
      ["[岸信介]1.02.25",				"@A", "1957-02-25"],
      ["[池田勇人]1.07.19",				"@A", "1960-07-19"],
      ["[佐藤栄作]1.11.09",				"@A", "1964-11-09"],
      ["[田中角栄]1.07.07",				"@A", "1972-07-07"],
      ["[三木武夫]1.12.09",				"@A", "1974-12-09"],
      ["[福田赳夫]1.12.24",				"@A", "1976-12-24"],
      ["[大平正芳]1.12.07",				"@A", "1978-12-07"],
      ["[鈴木善幸]1.07.17",				"@A", "1980-07-17"],
      ["[中曽根康弘]1.11.27",				"@A", "1982-11-27"],
      ["[竹下登]1.11.06",				"@A", "1987-11-06",
      	 "name=[今上天皇=ja:%%<明仁>,Emperor_Kinjō=en:Akihito];1989-01-08", ""],
      ["[宇野宗佑]1.06.03",				"@A", "1989-06-03"],
      ["[海部俊樹]1.08.10",				"@A", "1989-08-10"],
      ["[宮沢喜一]1.11.05",				"@A", "1991-11-05"],
      ["[細川護熙]1.08.09",				"@A", "1993-08-09"],
      ["[羽田孜]1.04.28",				"@A", "1994-04-28"],
      ["[村山富市]1.06.30",				"@A", "1994-06-30"],
      ["[橋本龍太郎]1.01.11",				"@A", "1996-01-11"],
      ["[小渕恵三]1.07.30",				"@A", "1998-07-30"],
      ["[森喜朗]1.04.05",				"@A", "2000-04-05"],
      ["[小泉純一郎]1.04.26",				"@A", "2001-04-26"],
      ["[安倍晋三]1.09.26",				"@A", "2006-09-26"],
      ["[福田康夫]1.09.26",				"@A", "2007-09-26"],
      ["[麻生太郎]1.09.24",				"@A", "2008-09-24"],
      ["[鳩山由紀夫]1.09.16",				"@A", "2009-09-16"],
      ["[菅直人]1.06.08",				"@A", "2010-06-08"],
      ["[野田佳彦]1.09.02",				"@A", "2011-09-02"],
      ["[安倍晋三･再=ja:%%<安倍晋三>]1.12.26",		"@A", "2012-12-26"]
    ]]
  end
end
