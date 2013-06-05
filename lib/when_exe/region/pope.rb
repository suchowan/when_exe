# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end


#
#  ローマ教皇一覧表
#
# （参考文献）
# カトリック教会文書資料集（エンデルレ書店）
# コンサイス世界年表（三省堂）
# BUKU PINTAR（UPAYA WAGRA NEGARA）
#
module When
  class TM::CalendarEra

# ローマ教皇
    Pope = [self, [
      "namespace:[ja=http://ja.wikipedia.org/wiki/, en=http://en.wikipedia.org/wiki/]",
      "locale:[=en:, ja=ja:, alias]",
      "area:[Pope,ローマ教皇]",
	["StPetros1",			"[::_m:EpochEvents::Accession]", "0042^Julian"], # <- (Gk.) Petrus <- (L.)
	["StLinus1",			"[::_m:EpochEvents::Accession]", "0067"], #
	["StAnacletus1",		"[::_m:EpochEvents::Accession]", "0076"], #
	["StClemens_I1",		"[::_m:EpochEvents::Accession]", "0088"], #
	["StEvaristus1",		"[::_m:EpochEvents::Accession]", "0097"], #
	["StAlexander_I1",		"[::_m:EpochEvents::Accession]", "0105"], #
	["StSixtus_I1",			"[::_m:EpochEvents::Accession]", "0115"], #
	["StTelesphorus1",		"[::_m:EpochEvents::Accession]", "0125"], #
	["StHyginus1",			"[::_m:EpochEvents::Accession]", "0136"], #
	["StPius_I1",			"[::_m:EpochEvents::Accession]", "0140"], #
	["StAnicetus1",			"[::_m:EpochEvents::Accession]", "0155"], #
	["StSoterus1",			"[::_m:EpochEvents::Accession]", "0166"], #
	["StEleutherius1",		"[::_m:EpochEvents::Accession]", "0175"], #
	["StVictor_I1",			"[::_m:EpochEvents::Accession]", "0189"], #
	["StZephyrinus1",		"[::_m:EpochEvents::Accession]", "0198"], #
	["StCallistus_I1",		"[::_m:EpochEvents::Accession]", "0217"], #
	["StUrbanus_I1",		"[::_m:EpochEvents::Accession]", "0222"], #
	["StPontianus1.07.01",		"[::_m:EpochEvents::Accession]", "0230.07.01"], # ～ 235.09.28
	["StAnterus1.11.21",		"[::_m:EpochEvents::Accession]", "0235.11.21"], # ～ 236.01.03
	["StFabianus1.01.10",		"[::_m:EpochEvents::Accession]", "0236.01.10"], # ～ 250.01.20
	["StCornelius1.03.01",		"[::_m:EpochEvents::Accession]", "0251.03.01"], # ～ 253.06/9?
	["StLucius_I1.06.25",		"[::_m:EpochEvents::Accession]", "0253.06.25"], # ～ 254.03.05
	["StStephanus_I1.05.12",	"[::_m:EpochEvents::Accession]", "0254.05.12"], # ～ 257.08.02
	["StSixtus_II1.08.30",		"[::_m:EpochEvents::Accession]", "0257.08.30"], # ～ 258.08.06
	["StDionysius1.07.22",		"[::_m:EpochEvents::Accession]", "0259.07.22"], # ～ 268.12.27?(259->260?)
	["StFelix_I1.01.05",		"[::_m:EpochEvents::Accession]", "0269.01.05"], # ～ 274.12.30
	["StEutychianus1.01.04",	"[::_m:EpochEvents::Accession]", "0275.01.04"], # ～ 283.12.08?
	["StCaius1.12.17",		"[::_m:EpochEvents::Accession]", "0283.12.17"], # ～ 295.04.22(295->296?)
	["StMarcellinus1.06.30",	"[::_m:EpochEvents::Accession]", "0295.06.30", "304.10.25="], # ～ 304.10.25(304.1.15?)
	["StMarcellius_I1.05.01",	"[::_m:EpochEvents::Accession]", "0308.05.01"], # ～ 309?.1.16(丸1年前へずれる?)
	["StEusebius1.04.18",		"[::_m:EpochEvents::Accession]", "0309.04.18"], # ～ 309?.8.17(309->310?)
	["StMelchiades1.07.02",		"[::_m:EpochEvents::Accession]", "0309.07.02"], # ～ 314.01.11
	["StSilvester_I1.01.31",	"[::_m:EpochEvents::Accession]", "0314.01.31"], # ～ 335.12.31
	["StMarcus1.01.18",		"[::_m:EpochEvents::Accession]", "0336.01.18"], # ～ 336.10.07
	["StIulius_I1.02.06",		"[::_m:EpochEvents::Accession]", "0337.02.06"], # ～ 352.04.12
	["Liberius1.05.17",		"[::_m:EpochEvents::Accession]", "0352.05.17"], # ～ 366.09.24
	["StDamasus_I1.10.01",		"[::_m:EpochEvents::Accession]", "0366.10.01"], # ～ 384.12.11
	["StSriicius1.12.11",		"[::_m:EpochEvents::Accession]", "0384.12.11"], # ～ 399.11.26(385.1.12就任?)
	["StAnastasius_I1.11.27",	"[::_m:EpochEvents::Accession]", "0399.11.27"], # ～ 402?.12.19(402->401?)
	["StInnocentius_I1.12.21",	"[::_m:EpochEvents::Accession]", "0402.12.21"], # ～ 417.03.12
	["StZosimus1.03.18",		"[::_m:EpochEvents::Accession]", "0417.03.18"], # ～ 418.12.26
	["StBonifatius_I1.12.29",	"[::_m:EpochEvents::Accession]", "0418.12.29"], # ～ 422.09.04
	["StCaelestinus_I1.09.10",	"[::_m:EpochEvents::Accession]", "0422.09.10"], # ～ 432.07.27
	["StSixtus_III1.07.31",		"[::_m:EpochEvents::Accession]", "0432.07.31"], # ～ 440.08.19/18?
	["StLeo_I1.09.29",		"[::_m:EpochEvents::Accession]", "0440.09.29"], # ～ 461.11.10
	["StHilarus1.11.19",		"[::_m:EpochEvents::Accession]", "0461.11.19"], # ～ 468.02.29
	["StSimplicius1.03.03",		"[::_m:EpochEvents::Accession]", "0468.03.03"], # ～ 483.03.10
	["StFelix_II1.03.13",		"[::_m:EpochEvents::Accession]", "0483.03.13"], # ～ 492.03.01(III とも)
	["StGelasius_I1.03.01",		"[::_m:EpochEvents::Accession]", "0492.03.01"], # ～ 496.11.21
	["Anastasius_II1.11.24",	"[::_m:EpochEvents::Accession]", "0496.11.24"], # ～ 498.11.17/19?
	["StSymmachus1.11.22",		"[::_m:EpochEvents::Accession]", "0498.11.22"], # ～ 514.07.19
	["StHormisdas1.07.20",		"[::_m:EpochEvents::Accession]", "0514.07.20"], # ～ 523.08.06
	["StIohannes_I1.08.13",		"[::_m:EpochEvents::Accession]", "0523.08.13"], # ～ 526.05.18
	["StFelix_III1.07.12",		"[::_m:EpochEvents::Accession]", "0526.07.12"], # ～ 530.09.22(IV とも)
	["Bonifatius_II1.09.22",	"[::_m:EpochEvents::Accession]", "0530.09.22"], # ～ 532.10.17
	["Iohannes_II1.01.02",		"[::_m:EpochEvents::Accession]", "0533.01.02"], # ～ 535.05.08
	["StAgapetus_I1.05.13",		"[::_m:EpochEvents::Accession]", "0535.05.13"], # ～ 536.04.22
	["StSilverius1.06.01",		"[::_m:EpochEvents::Accession]", "0536.06.01"], # ～ 537.11.11
	["Vigilius1.11.11",		"[::_m:EpochEvents::Accession]", "0537.11.11"], # ～ 555.06.07(537.3.29対立教皇)
	["Pelagius_I1.04.16",		"[::_m:EpochEvents::Accession]", "0556.04.16"], # ～ 561.03.03/4?
	["Iohannes_III1.07.17",		"[::_m:EpochEvents::Accession]", "0561.07.17"], # ～ 574.07.13
	["Benedictus_I1.06.02",		"[::_m:EpochEvents::Accession]", "0575.06.02"], # ～ 579.07.30
	["Pelagius_II1.11.26",		"[::_m:EpochEvents::Accession]", "0579.11.26"], # ～ 590.02.07
	["StGregorius_I1.09.03",	"[::_m:EpochEvents::Accession]", "0590.09.03"], # ～ 604.03.12
	["Sabinianus1.09.13",		"[::_m:EpochEvents::Accession]", "0604.09.13"], # ～ 606.02.22
	["Bonifatius_III1.02.19",	"[::_m:EpochEvents::Accession]", "0607.02.19"], # ～ 607.11.12
	["StBonifatius_IV1.08.25",	"[::_m:EpochEvents::Accession]", "0608.08.25"], # ～ 615.05.08
	["StDeusdedit1.10.19",		"[::_m:EpochEvents::Accession]", "0615.10.19"], # ～ 618.11.08
	["Bonifatius_V1.12.23",		"[::_m:EpochEvents::Accession]", "0619.12.23"], # ～ 625.10.25
	["Honorius_I1.10.27",		"[::_m:EpochEvents::Accession]", "0625.10.27", " 638.10.12="], # ～ 638.10.12
	["Seveninus1.05.28",		"[::_m:EpochEvents::Accession]", "0640.05.28"], # ～ 640.08.02
	["Iohannes_IV1.12.24",		"[::_m:EpochEvents::Accession]", "0640.12.24"], # ～ 642.10.24
	["Theodorus_I1.11.24",		"[::_m:EpochEvents::Accession]", "0642.11.24"], # ～ 649.05.14
	["StMartinus_I1.07.05",		"[::_m:EpochEvents::Accession]", "0649.07.05"], # ～ 653.06.17逮捕,655.9.16死亡
	["StEugenius_I1.08.10",		"[::_m:EpochEvents::Accession]", "0654.08.10"], # ～ 657.06.2/3?
	["StVitalianus1.07.30",		"[::_m:EpochEvents::Accession]", "0657.07.30"], # ～ 672.01.27
	["Adeodatus_II1.04.11",		"[::_m:EpochEvents::Accession]", "0672.04.11"], # ～ 676.06.17/16?
	["Donus1.11.02",		"[::_m:EpochEvents::Accession]", "0676.11.02"], # ～ 678.04.11
	["StAgatho1.06.27",		"[::_m:EpochEvents::Accession]", "0678.06.27"], # ～ 681.01.10
	["StLeo_II1.08.17",		"[::_m:EpochEvents::Accession]", "0682.08.17"], # ～ 683.07.03
	["StBenedictus_II1.06.26",	"[::_m:EpochEvents::Accession]", "0684.06.26"], # ～ 685.05.08
	["Iohannes_V1.07.23",		"[::_m:EpochEvents::Accession]", "0685.07.23"], # ～ 686.08.02
	["Conon1.10.21",		"[::_m:EpochEvents::Accession]", "0686.10.21"], # ～ 687.09.21
	["StSergius_I1.12.15",		"[::_m:EpochEvents::Accession]", "0687.12.15"], # ～ 701.09.08
	["Iohannes_VI1.10.30",		"[::_m:EpochEvents::Accession]", "0701.10.30"], # ～ 705.01.11
	["Iohannes_VII1.03.01",		"[::_m:EpochEvents::Accession]", "0705.03.01"], # ～ 707.10.18
	["Sisinnius1.01.15",		"[::_m:EpochEvents::Accession]", "0708.01.15"], # ～ 708.02.04
	["Constantinus1.03.25",		"[::_m:EpochEvents::Accession]", "0708.03.25"], # ～ 715.04.09
	["StGregorius_II1.05.15",	"[::_m:EpochEvents::Accession]", "0715.05.15"], # ～ 731.02.11
	["StGregorius_III1.03.18",	"[::_m:EpochEvents::Accession]", "0731.03.18"], # ～ 741.11.28/29
	["StZacharias1.12.10",		"[::_m:EpochEvents::Accession]", "0741.12.10"], # ～ 752.03.22(15?)
	["Stephanus_II1.03.23",		"[::_m:EpochEvents::Accession]", "0752.03.23"], # ～ 757.03.25(歴代に数えない)
	["Stephanus_II1.03.26",		"[::_m:EpochEvents::Accession]", "0752.03.26"], # ～ 757.04.26(IIIとも)
	["StPaulus_I1.05.29",		"[::_m:EpochEvents::Accession]", "0757.05.29"], # ～ 767.06.28
	["Stephanus_III1.08.07",	"[::_m:EpochEvents::Accession]", "0768.08.07"], # ～ 772.01.24(IVとも)
	["Hadrianus_I1.02.09",		"[::_m:EpochEvents::Accession]", "0772.02.09"], # ～ 795.12.25
	["StLeo_III1.12.27",		"[::_m:EpochEvents::Accession]", "0795.12.27"], # ～ 816.06.12
	["Stephanus_IV1.06.22",		"[::_m:EpochEvents::Accession]", "0816.06.22"], # ～ 817.01.24(Vとも)
	["StPaschalis_I1.01.25",	"[::_m:EpochEvents::Accession]", "0817.01.25"], # ～ 824.02.11
	["Eugenius_II1.02.11",		"[::_m:EpochEvents::Accession]", "0824.02.11"], # ～ 827.08.0?
	["Valentinus1.08.01",		"[::_m:EpochEvents::Accession]", "0827.08.01"], # ～ 827.09.0?
	["Gregorius_IV1.09.01",		"[::_m:EpochEvents::Accession]", "0827.09.01"], # ～ 844.01.0?
	["Sergius_II1.01.01",		"[::_m:EpochEvents::Accession]", "0844.01.01"], # ～ 847.01.27
	["StLeo_IV1.04.10",		"[::_m:EpochEvents::Accession]", "0847.04.10"], # ～ 855.07.17
	["Benedictus_III1.07.17",	"[::_m:EpochEvents::Accession]", "0855.07.17"], # ～ 858.04.17
	["StNicolaus_I1.04.24",		"[::_m:EpochEvents::Accession]", "0858.04.24"], # ～ 867.11.13
	["Hadrianus_II1.12.14",		"[::_m:EpochEvents::Accession]", "0867.12.14"], # ～ 872.12.14
	["Iohannes_VIII1.12.24",	"[::_m:EpochEvents::Accession]", "0872.12.24"], # ～ 882.12.16
	["Marinus_I1.12.16",		"[::_m:EpochEvents::Accession]", "0882.12.16"], # ～ 884.05.15
	["StHadrianus_III1.05.17",	"[::_m:EpochEvents::Accession]", "0884.05.17"], # ～ 885.09.0?
	["Stephanus_V1.09.01",		"[::_m:EpochEvents::Accession]", "0885.09.01"], # ～ 891.09.14(VIとも)
	["Formosus1.10.06",		"[::_m:EpochEvents::Accession]", "0891.10.06"], # ～ 896.04.04
	["Bonifatius_VI1.04.04",	"[::_m:EpochEvents::Accession]", "0896.04.04"], # ～ 896.04.0?
	["Stephanus_VI1.05.01",		"[::_m:EpochEvents::Accession]", "0896.05.01"], # ～ 897.08.0?(VIIとも)
	["Romanus1.08.01",		"[::_m:EpochEvents::Accession]", "0897.08.01"], # ～ 897.11.0?
	["Theodorus_II1.12.01",		"[::_m:EpochEvents::Accession]", "0897.12.01"], # ～ 897.12.0?
	["Iohannes_IX1.01.01",		"[::_m:EpochEvents::Accession]", "0898.01.01"], # ～ 900.01.0?
	["Benedictus_IV1.01.01",	"[::_m:EpochEvents::Accession]", "0900.01.01"], # ～ 903.07.0?
	["Leo_V1.07.01",		"[::_m:EpochEvents::Accession]", "0903.07.01"], # ～ 903.09.0?
	["Sergius_III1.01.29",		"[::_m:EpochEvents::Accession]", "0904.01.29"], # ～ 911.04.14
	["Anastasius_III1.04.14",	"[::_m:EpochEvents::Accession]", "0911.04.14"], # ～ 913.06.0?
	["Landus1.07.01",		"[::_m:EpochEvents::Accession]", "0913.07.01"], # ～ 914.02.0?
	["Iohannes_X1.03.01",		"[::_m:EpochEvents::Accession]", "0914.03.01"], # ～ 928.05.0?
	["Leo_VI1.05.01",		"[::_m:EpochEvents::Accession]", "0928.05.01"], # ～ 928.12.0?
	["Stephanus_VII1.12.01",	"[::_m:EpochEvents::Accession]", "0928.12.01"], # ～ 931.02.0?(VIIIとも)
	["Iohannes_XI1.02.01",		"[::_m:EpochEvents::Accession]", "0931.02.01"], # ～ 935.12.0?
	["Leo_VII1.01.03",		"[::_m:EpochEvents::Accession]", "0936.01.03"], # ～ 939.07.13
	["Stephanus_VIII1.07.14",	"[::_m:EpochEvents::Accession]", "0939.07.14"], # ～ 942.10.0?(IXとも)
	["Marinus_II1.10.30",		"[::_m:EpochEvents::Accession]", "0942.10.30"], # ～ 946.05.0?
	["Agapetus_II1.05.10",		"[::_m:EpochEvents::Accession]", "0946.05.10"], # ～ 955.12.0?
	["Iohannes_XII1.12.16",		"[::_m:EpochEvents::Accession]", "0955.12.16"], # ～ 964.05.14(963.12.4免職)
	["Leo_VIII1.12.06",		"[::_m:EpochEvents::Accession]", "0963.12.06"], # ～ 965.03.01
	["Benedictus_V1.05.22",		"[::_m:EpochEvents::Accession]", "0964.05.22"], # ～ 966.07.04(964.6.24免職)
	["Iohannes_XIII1.10.01",	"[::_m:EpochEvents::Accession]", "0965.10.01"], # ～ 972.09.06
	["Benedictus_VI1.01.19",	"[::_m:EpochEvents::Accession]", "0973.01.19"], # ～ 974.06.0?
	["Benedictus_VII1.10.01",	"[::_m:EpochEvents::Accession]", "0974.10.01"], # ～ 983.07.10
	["Iohannes_XIV1.12.01",		"[::_m:EpochEvents::Accession]", "0983.12.01"], # ～ 984.08.20
	["Iohannes_XV1.08.20",		"[::_m:EpochEvents::Accession]", "0985.08.20"], # ～ 996.03.0?
	["Gregorius_V1.05.03",		"[::_m:EpochEvents::Accession]", "0996.05.03"], # ～ 999.02.18
	["Silvester_II1.04.02",		"[::_m:EpochEvents::Accession]", "0999.04.02"], # ～1003.05.12
	["Iohannes_XVII1.06.01",	"[::_m:EpochEvents::Accession]", "1003.06.01"], # ～1003.12.0?
	["Iohannes_XVIII1.01.01",	"[::_m:EpochEvents::Accession]", "1004.01.01"], # ～1009.07.0?
	["Sergius_IV1.07.31",		"[::_m:EpochEvents::Accession]", "1009.07.31"], # ～1012.05.12
	["Benedictus_VIII1.05.18",	"[::_m:EpochEvents::Accession]", "1012.05.18"], # ～1024.04.09
	["Iohannes_XIX1.05.01",		"[::_m:EpochEvents::Accession]", "1024.05.01"], # ～1032.0?.0?
	["Benedictus_IX1.01.01",	"[::_m:EpochEvents::Accession]", "1032.01.01"], # ～1044.0?.0?
	["Silvester_III1.01.20",	"[::_m:EpochEvents::Accession]", "1045.01.20"], # ～1045.2?.10
	["Benedictus_IX'1.04.10",	"[::_m:EpochEvents::Accession]", "1045.04.10"], # ～1045.05.01(復位期間)
	["Gregorius_VI1.05.05",		"[::_m:EpochEvents::Accession]", "1045.05.05"], # ～1046.12.20
	["Clemens_II1.12.25",		"[::_m:EpochEvents::Accession]", "1046.12.25"], # ～1047.10.09
	["Benedictus_IX''1.11.08",	"[::_m:EpochEvents::Accession]", "1047.11.08"], # ～1048.07.17(復位期間)
	["Damasus_II1.07.17",		"[::_m:EpochEvents::Accession]", "1048.07.17"], # ～1048.08.09
	["StLeo_IX1.02.12",		"[::_m:EpochEvents::Accession]", "1049.02.12"], # ～1054.04.19
	["Victor_II1.04.16",		"[::_m:EpochEvents::Accession]", "1055.04.16"], # ～1057.07.28
	["Stephanus_IX1.08.03",		"[::_m:EpochEvents::Accession]", "1057.08.03"], # ～1058.03.29(Xとも)
	["Nicolaus_II1.12.06",		"[::_m:EpochEvents::Accession]", "1058.12.06"], # ～1061.07.27
	["Alexander_II1.10.01",		"[::_m:EpochEvents::Accession]", "1061.10.01"], # ～1073.04.21
	["StGregorius_VII1.04.22",	"[::_m:EpochEvents::Accession]", "1073.04.22"], # ～1085.05.25
	["Victor_III1.05.24",		"[::_m:EpochEvents::Accession]", "1086.05.24"], # ～1087.09.16St
	["Urbanus_II1.03.12",		"[::_m:EpochEvents::Accession]", "1088.03.12"], # ～1099.07.29St
	["Paschalis_II1.08.13",		"[::_m:EpochEvents::Accession]", "1099.08.13"], # ～1118.01.21
	["Gelasius_II1.01.24",		"[::_m:EpochEvents::Accession]", "1118.01.24"], # ～1119.01.28
	["Callistus_II1.02.02",		"[::_m:EpochEvents::Accession]", "1119.02.02"], # ～1124.12.13
	["Honorius_II1.12.15",		"[::_m:EpochEvents::Accession]", "1124.12.15"], # ～1130.02.13
	["Innocentius_II1.02.14",	"[::_m:EpochEvents::Accession]", "1130.02.14"], # ～1143.09.24
	["Caelestinus_II1.09.26",	"[::_m:EpochEvents::Accession]", "1143.09.26"], # ～1144.03.08
	["Lucius_II1.03.12",		"[::_m:EpochEvents::Accession]", "1144.03.12"], # ～1145.02.15
	["Eugenius_III1.02.15",		"[::_m:EpochEvents::Accession]", "1145.02.15"], # ～1153.07.08St
	["Anastasius_IV1.07.12",	"[::_m:EpochEvents::Accession]", "1153.07.12"], # ～1154.12.03
	["Hadrianus_IV1.12.04",		"[::_m:EpochEvents::Accession]", "1154.12.04"], # ～1159.09.01
	["Alexander_III1.09.07",	"[::_m:EpochEvents::Accession]", "1159.09.07"], # ～1181.08.30
	["Lucius_III1.09.01",		"[::_m:EpochEvents::Accession]", "1181.09.01"], # ～1185.11.25
	["Urbanus_III1.11.25",		"[::_m:EpochEvents::Accession]", "1185.11.25"], # ～1187.10.19/20
	["Gregorius_VIII1.10.21",	"[::_m:EpochEvents::Accession]", "1187.10.21"], # ～1187.12.17
	["Clemens_III1.12.19",		"[::_m:EpochEvents::Accession]", "1187.12.19"], # ～1191.03.0?
	["Caelestinus_III1.03.30",	"[::_m:EpochEvents::Accession]", "1191.03.30"], # ～1198.01.08
	["Innocentius_III1.01.08",	"[::_m:EpochEvents::Accession]", "1198.01.08"], # ～1216.07.16
	["Honorius_III1.07.18",		"[::_m:EpochEvents::Accession]", "1216.07.18"], # ～1227.03.18
	["Gregorius_IX1.03.19",		"[::_m:EpochEvents::Accession]", "1227.03.19"], # ～1241.08.22
	["Caelestinus_IV1.10.25",	"[::_m:EpochEvents::Accession]", "1241.10.25", "1241.11.10="], # ～1241.11.10
	["Innocentius_IV1.06.25",	"[::_m:EpochEvents::Accession]", "1243.06.25"], # ～1254.12.07
	["Alexander_IV1.12.12",		"[::_m:EpochEvents::Accession]", "1254.12.12"], # ～1261.05.25
	["Urbanus_IV1.08.29",		"[::_m:EpochEvents::Accession]", "1261.08.29"], # ～1264.10.02
	["Clemens_IV1.02.05",		"[::_m:EpochEvents::Accession]", "1265.02.05", "1268.11.29="], # ～1268.11.29
	["Gregorius_X1.09.01",		"[::_m:EpochEvents::Accession]", "1271.09.01"], # ～1276.01.10
	["Innocentius_V1.01.21",	"[::_m:EpochEvents::Accession]", "1276.01.21"], # ～1276.06.22
	["Hadrianus_V1.07.11",		"[::_m:EpochEvents::Accession]", "1276.07.11"], # ～1276.08.18
	["Iohannes_XXI1.09.08",		"[::_m:EpochEvents::Accession]", "1276.09.08"], # ～1277.05.20
	["Nicolaus_III1.11.25",		"[::_m:EpochEvents::Accession]", "1277.11.25"], # ～1280.08.22
	["Martinus_IV1.02.22",		"[::_m:EpochEvents::Accession]", "1281.02.22"], # ～1285.03.28
	["Honoirus_IV1.04.02",		"[::_m:EpochEvents::Accession]", "1285.04.02"], # ～1287.04.03
	["Nicolaus_IV1.02.22",		"[::_m:EpochEvents::Accession]", "1288.02.22", "1292.04.04="], # ～1292.04.04
	["StCaelestinus_V1.07.05",	"[::_m:EpochEvents::Accession]", "1294.07.05"], # ～1294.12.13
	["Bonifatius_VIII1.12.24",	"[::_m:EpochEvents::Accession]", "1294.12.24"], # ～1303.10.11
	["Benedictus_XI1.10.22",	"[::_m:EpochEvents::Accession]", "1303.10.22"], # ～1304.07.07
	["Clemens_V1.06.05",		"[::_m:EpochEvents::Accession]", "1305.06.05", "1314.04.20="], # ～1314.04.20
	["Iohannes_XXII1.08.07",	"[::_m:EpochEvents::Accession]", "1316.08.07"], # ～1334.12.04
	["Benedictus_XII1.12.20",	"[::_m:EpochEvents::Accession]", "1334.12.20"], # ～1342.04.25
	["Clemens_VI1.05.07",		"[::_m:EpochEvents::Accession]", "1342.05.07"], # ～1352.12.06
	["Innocentius_VI1.12.08",	"[::_m:EpochEvents::Accession]", "1352.12.08"], # ～1362.09.12
	["Urbanus_V1.09.28",		"[::_m:EpochEvents::Accession]", "1362.09.28"], # ～1370.12.19
	["Gregorius_XI1.12.30",		"[::_m:EpochEvents::Accession]", "1370.12.30", "1378.03.27="], # ～1378.03.27
	["Clemens_VII1", 		"[::_m:EpochEvents::Accession]", "1378"], # (*)
	["Benedictus_XIII1", 		"[::_m:EpochEvents::Accession]", "1394", "1417.07.26="], # ～1417.07.26 (*)
	["Urbanus_VI 1.04.08",		"[::_m:EpochEvents::Accession]", "1378.04.08"], # ～1389.10.15
	["Bonifatius_IX1.11.02",	"[::_m:EpochEvents::Accession]", "1389.11.02"], # ～1404.10.01
	["Innocentius_VII1.10.17",	"[::_m:EpochEvents::Accession]", "1404.10.17"], # ～1406.11.06
	["Gregorius_XII1.11.30",	"[::_m:EpochEvents::Accession]", "1406.11.30","1415.07.04="], # ～1415.07.04
	["Alexander_V1", 		"[::_m:EpochEvents::Accession]", "1409"], # (*)
	["Iohannes_XXIII'1", 		"[::_m:EpochEvents::Accession]", "1411","1415.05.29="], # ～1415.05.29 (*)
	["Martinus_V 1.11.11",		"[::_m:EpochEvents::Accession]", "1417.11.11"], # ～1431.02.20
	["Eugenius_IV1.03.03",		"[::_m:EpochEvents::Accession]", "1431.03.03"], # ～1447.02.23
	["Nicolaus_V1.03.06",		"[::_m:EpochEvents::Accession]", "1447.03.06"], # ～1455.03.24/25
	["Callistus_III1.04.08",	"[::_m:EpochEvents::Accession]", "1455.04.08"], # ～1458.08.06
	["Pius_II1.08.19",		"[::_m:EpochEvents::Accession]", "1458.08.19"], # ～1464.08.14
	["Paulus_II1.08.30",		"[::_m:EpochEvents::Accession]", "1464.08.30"], # ～1471.07.26
	["Sixtus_IV1.08.09",		"[::_m:EpochEvents::Accession]", "1471.08.09"], # ～1484.08.12
	["Innocentius_VIII1.08.29",	"[::_m:EpochEvents::Accession]", "1484.08.29"], # ～1492.07.25
	["Alexander_VI1.08.11",		"[::_m:EpochEvents::Accession]", "1492.08.11"], # ～1503.08.18
	["Pius_III1.09.22",		"[::_m:EpochEvents::Accession]", "1503.09.22"], # ～1503.10.18
	["Iulius_II1.10.31",		"[::_m:EpochEvents::Accession]", "1503.10.31"], # ～1513.02.21
	["Leo_X1.03.11",		"[::_m:EpochEvents::Accession]", "1513.03.11"], # ～1521.12.01
	["Hadrianus_VI1.01.09",		"[::_m:EpochEvents::Accession]", "1522.01.09"], # ～1523.09.14
	["Clemens_VII1.11.19",		"[::_m:EpochEvents::Accession]", "1523.11.19"], # ～1534.09.25
	["Paulus_III1.10.13",		"[::_m:EpochEvents::Accession]", "1534.10.13"], # ～1549.11.10
	["Iulius_III1.02.07",		"[::_m:EpochEvents::Accession]", "1550.02.07"], # ～1555.03.23
	["Marcellus_II1.04.09",		"[::_m:EpochEvents::Accession]", "1555.04.09"], # ～1555.05.01
	["Paulus_IV1.05.23",		"[::_m:EpochEvents::Accession]", "1555.05.23"], # ～1559.08.18
	["Pius_IV1.12.25",		"[::_m:EpochEvents::Accession]", "1559.12.25"], # ～1565.12.09
	["StPius_V1.01.07",		"[::_m:EpochEvents::Accession]", "1566.01.07"], # ～1572.05.01
	["Gregorius_XIII1.05.13",	"[::_m:EpochEvents::Accession]", "1572.05.13", "1582.10.15^Gregorian",""], # ～1585.04.10
	["Sixtus_V1.04.24",		"[::_m:EpochEvents::Accession]", "1585.04.24"], # ～1590.08.27
	["Urbanus_VII1.09.15",		"[::_m:EpochEvents::Accession]", "1590.09.15"], # ～1590.09.27
	["Gregorius_XIV1.12.05",	"[::_m:EpochEvents::Accession]", "1590.12.05"], # ～1591.10.17
	["Innocentius_IX1.10.29",	"[::_m:EpochEvents::Accession]", "1591.10.29"], # ～1591.12.30
	["Clemens_VIII1.01.30",		"[::_m:EpochEvents::Accession]", "1592.01.30"], # ～1605.05?.3
	["Leo_XI1.04.01",		"[::_m:EpochEvents::Accession]", "1605.04.01"], # ～1605.04.27
	["Paulus_V1.05.16",		"[::_m:EpochEvents::Accession]", "1605.05.16"], # ～1621.01.28
	["Gregorius_XV1.02.09",		"[::_m:EpochEvents::Accession]", "1621.02.09"], # ～1623.07.08
	["Urbanus_VIII1.08.06",		"[::_m:EpochEvents::Accession]", "1623.08.06"], # ～1644.07.29
	["Innocentius_X1.09.15",	"[::_m:EpochEvents::Accession]", "1644.09.15"], # ～1655.01.07
	["Alexander_VII1.04.07",	"[::_m:EpochEvents::Accession]", "1655.04.07"], # ～1667.05.22
	["Clemens_IX1.06.20",		"[::_m:EpochEvents::Accession]", "1667.06.20"], # ～1669.12.09
	["Clemens_X1.04.29",		"[::_m:EpochEvents::Accession]", "1670.04.29"], # ～1676.07.22
	["Innocentius_XI1.09.21",	"[::_m:EpochEvents::Accession]", "1676.09.21"], # ～1689.08.12
	["Alexander_VIII1.10.06",	"[::_m:EpochEvents::Accession]", "1689.10.06"], # ～1691.02.01
	["Innocentius_XII1.07.12",	"[::_m:EpochEvents::Accession]", "1691.07.12"], # ～1700.09.27
	["Clemens_XI1.11.23",		"[::_m:EpochEvents::Accession]", "1700.11.23"], # ～1721.03.19
	["Innocentius_XIII1.05.08",	"[::_m:EpochEvents::Accession]", "1721.05.08"], # ～1724.03.07
	["Benedictus_XIII1.05.29",	"[::_m:EpochEvents::Accession]", "1724.05.29"], # ～1730.02.21
	["Clemens_XII1.07.12",		"[::_m:EpochEvents::Accession]", "1730.07.12"], # ～1740.02.06
	["Benedictus_XIV1.08.17",	"[::_m:EpochEvents::Accession]", "1740.08.17"], # ～1758.05.03
	["Clemens_XIII1.07.06",		"[::_m:EpochEvents::Accession]", "1758.07.06"], # ～1769.02.02
	["Clemens_XIV1.05.19",		"[::_m:EpochEvents::Accession]", "1769.05.19"], # ～1774.09.22
	["Pius_VI1.02.15",		"[::_m:EpochEvents::Accession]", "1775.02.15"], # ～1799.08.29
	["Pius_VII1.03.14",		"[::_m:EpochEvents::Accession]", "1800.03.14"], # ～1823.08.20
	["Leo_XII1.09.28",		"[::_m:EpochEvents::Accession]", "1823.09.28"], # ～1829.02.10
	["Pius_VIII1.03.31",		"[::_m:EpochEvents::Accession]", "1829.03.31"], # ～1830.11.30
	["Gregorius_XVI1.02.02",	"[::_m:EpochEvents::Accession]", "1831.02.02"], # ～1846.06.01
	["Pius_IX1.06.16",		"[::_m:EpochEvents::Accession]", "1846.06.16"], # ～1878.02.07
	["Leo_XIII1.02.20",		"[::_m:EpochEvents::Accession]", "1878.02.20"], # ～1903.07.20
	["StPius_X1.08.04",		"[::_m:EpochEvents::Accession]", "1903.08.04"], # ～1914.08.20
	["Benedictus_XV1.09.03",	"[::_m:EpochEvents::Accession]", "1914.09.03"], # ～1922.01.22
	["Pius_XI1.02.06",		"[::_m:EpochEvents::Accession]", "1922.02.06"], # ～1939.02.10
	["Pius_XII1.03.02",		"[::_m:EpochEvents::Accession]", "1939.03.02"], # ～1958.10.09
	["Iohannes_XXIII1.10.28",	"[::_m:EpochEvents::Accession]", "1958.10.28"], # ～1963.06.03
	["Paulus_VI1.06.21",		"[::_m:EpochEvents::Accession]", "1963.06.21"], # ～1978.08.06
	["Iohannes_Paulus_I1.08.26",	"[::_m:EpochEvents::Accession]", "1978.08.26"], # ～1978.09.29
	["Iohannes_Paulus_II1.10.16",	"[::_m:EpochEvents::Accession]", "1978.10.16"], # ～2005.04.02
	["Benedictus_XVI1.04.19",	"[::_m:EpochEvents::Accession]", "2005.04.19"], # ～2013.02.28
	["Franciscus1.03.13",		"[::_m:EpochEvents::Accession]", "2013.03.13"]  # 現職
    ]]
  end
end
