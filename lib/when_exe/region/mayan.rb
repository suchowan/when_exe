# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When

  module Coordinates

    # Mayan Residue
    Mayan = [{'Epoch' => Hash.new {|hash, key|
                           epoch = key.to_i
                           hash[key] = key ? {
                             'Haab'    => ((300 + epoch) % 365).to_s,
                             'Trecena' => ((  8 + epoch) %  13).to_s,
                             'Tzolkin' => ((  4 + epoch) %  20).to_s,
                             'LoN'     => ((  3 + epoch) %   9).to_s
                           } : nil
                         }}, BasicTypes::M17n, [
      "namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/]",
      "locale:[=en:, ja=ja:, alias]",
      "names:[Mayan]",

      [Residue,
        "label:[Haab', ハアブ, Haab]", "divisor:365", 'day:#{Haab:300}', "format:[%2$d%1$s/365]",
        "namespace:[glyph=http://en.wikipedia.org/wiki/File:Maya-]",
        [Residue, "label:[Pop     =glyph:Pop.jpg,            ポプ,       Pop   ]", "remainder:  0"],
        [Residue, "label:[Wo'     =glyph:Dresden-wo.jpg,     ウオ,       Wo    ]", "remainder: 20"],
        [Residue, "label:[Sip     =glyph:Dresden-sip.jpg,    シプ,       Sip   ]", "remainder: 40"],
        [Residue, "label:[Sotz'   =glyph:Sotz.jpg,           ソッツ,     Sotz  ]", "remainder: 60"],
        [Residue, "label:[Sek     =glyph:Dresden-Sek.jpg,    セック,     Sek   ]", "remainder: 80"],
        [Residue, "label:[Xul     =glyph:Xul.png,            シュル,     Xul   ]", "remainder:100"],
        [Residue, "label:[Yaxk'in'=glyph:Dresden-Yaxkin.jpg, ヤシュキン, Yaxkin]", "remainder:120"],
        [Residue, "label:[Mol     =glyph:Mol.png,            モル,       Mol   ]", "remainder:140"],
        [Residue, "label:[Ch'en   =glyph:Dresden-Chen.jpg,   チェン,     Chen  ]", "remainder:160"],
        [Residue, "label:[Yax     =glyph:Dresden-Yax.jpg,    ヤシュ,     Yax   ]", "remainder:180"],
        [Residue, "label:[Sak'    =glyph:Dresden-Sak.jpg,    サック,     Sak   ]", "remainder:200"],
        [Residue, "label:[Keh     =glyph:Dresden-Keh.jpg,    ケフ,       Keh   ]", "remainder:220"],
        [Residue, "label:[Mak     =glyph:Dresden-Mak.png,    マック,     Mak   ]", "remainder:240"],
        [Residue, "label:[K'ank'in=glyph:Dresden-Kankin.png, カンキン,   Kankin]", "remainder:260"],
        [Residue, "label:[Muwan'  =glyph:Muan.jpg,           ムアン,     Muwan ]", "remainder:280"],
        [Residue, "label:[Pax     =glyph:Dresden-pax.jpg,    パシュ,     Pax   ]", "remainder:300"],
        [Residue, "label:[K'ayab  =glyph:Dresden-Kayab.png,  カヤブ,     Kayab ]", "remainder:320"],
        [Residue, "label:[Kumk'u  =glyph:Dresden-kumku.jpg,  クムク,     Kumku ]", "remainder:340"],
        [Residue, "label:[Wayeb'  =glyph:Dresden-wayeb.jpg,  ウェヤブ,   Wayeb ]", "remainder:360"]
      ],

      [Residue,
        "label:[Trecena, トレセナ=, Trecena]", "divisor:13", 'day:#{Trecena:8}', "format:[%1$s(%3$d/13)]"
      ],

      [Residue,
        "namespace:[glyph=http://en.wikipedia.org/wiki/File:MAYA-g-log-cal-]",
        "label:[Tzolk'in, ツォルキン, Tzolkin]", "divisor:20", 'day:#{Tzolkin:4}', "format:[%s(%d/20)]",
        [Residue, "label:[Imix'   =glyph:D01-Imix.png,     イミシュ,   Imix    =glyph:D01-Imix-cdxW.png    ]", "remainder: 0"],
        [Residue, "label:[Ik'     =glyph:D02-Ik.png,       イック,     Ik      =glyph:D02-Ik-cdxW.png      ]", "remainder: 1"],
        [Residue, "label:[Ak'b'al =glyph:D03-Akbal.png,    アクバル,   Akbal   =glyph:D03-Akbal-cdxW.png   ]", "remainder: 2"],
        [Residue, "label:[K'an    =glyph:D04-Kan.png,      カン,       Kan     =glyph:D04-Kan-cdxW.png     ]", "remainder: 3"],
        [Residue, "label:[Chikchan=glyph:D05-Chikchan.png, チクチャン, Chicchan=glyph:D05-Chikchan-cdxW.png]", "remainder: 4"],
        [Residue, "label:[Kimi    =glyph:D06-Kimi.png,     キミ,       Cimi    =glyph:D06-Kimi-cdxW.png    ]", "remainder: 5"],
        [Residue, "label:[Manik'  =glyph:D07-Manik.png,    マニク,     Manik   =glyph:D07-Manik-cdxW.png   ]", "remainder: 6"],
        [Residue, "label:[Lamat   =glyph:D08-Lamat.png,    ラマト,     Lamat   =glyph:D08-Lamat-cdxW.png   ]", "remainder: 7"],
        [Residue, "label:[Muluk   =glyph:D09-Muluk.png,    ムルク,     Muluc   =glyph:D09-Muluk-cdxW.png   ]", "remainder: 8"],
        [Residue, "label:[Ok      =glyph:D10-Ok.png,       オック,     Oc      =glyph:D10-Ok-cdxW.png      ]", "remainder: 9"],
        [Residue, "label:[Chuwen  =glyph:D11-Chuwen.png,   チュエン,   Chuen   =glyph:D11-Chuwen-cdxW.png  ]", "remainder:10"],
        [Residue, "label:[Eb'     =glyph:D12-Eb.png,       エブ,       Eb      =glyph:D12-Eb-cdxW.png      ]", "remainder:11"],
        [Residue, "label:[B'en    =glyph:D13-Ben.png,      ベン,       Ben     =glyph:D13-Ben-cdxW.png     ]", "remainder:12"],
        [Residue, "label:[Ix      =glyph:D14-Ix.png,       イシュ,     Ix      =glyph:D14-Ix-cdxW.png      ]", "remainder:13"],
        [Residue, "label:[Men     =glyph:D15-Men.png,      メン,       Men     =glyph:D15-Men-cdxW.png     ]", "remainder:14"],
        [Residue, "label:[Kib'    =glyph:D16-Kib.png,      キッブ,     Cib     =glyph:D16-Kib-cdxW.png     ]", "remainder:15"],
        [Residue, "label:[Kab'an  =glyph:D17-Kaban.png,    カーバン,   Caban   =glyph:D17-Kaban-cdxW.png   ]", "remainder:16"],
        [Residue, "label:[Etz'nab'=glyph:D18-Etznab.png,   エツナブ,   Etznab  =glyph:D18-Etznab-cdxW.png  ]", "remainder:17"],
        [Residue, "label:[Kawak   =glyph:D19-Kawak.png,    カワク,     Cauac   =glyph:D19-Kawak-cdxW.png   ]", "remainder:18"],
        [Residue, "label:[Ajaw    =glyph:D20-Ajaw.png,     アハウ,     Ahau    =glyph:D20-Ajaw-cdxW.png    ]", "remainder:19"],
      ],

      [Residue,
        "namespace:[glyph=http://www.pauahtun.org/G/G]",
        "label:[Lords_of_the_Night, 夜の九王]", "divisor:9", 'day:#{LoN:3}', "format:[%s(%d/9)]",
        [Residue, "label:[G9=glyph:9_m.png]", "remainder: 0"],
        [Residue, "label:[G1=glyph:1_m.png]", "remainder: 1"],
        [Residue, "label:[G2=glyph:2_m.png]", "remainder: 2"],
        [Residue, "label:[G3=glyph:3_m.png]", "remainder: 3"],
        [Residue, "label:[G4=glyph:4_m.png]", "remainder: 4"],
        [Residue, "label:[G5=glyph:5_m.png]", "remainder: 5"],
        [Residue, "label:[G6=glyph:6_m.png]", "remainder: 6"],
        [Residue, "label:[G7=glyph:7_m.png]", "remainder: 7"],
        [Residue, "label:[G8=glyph:8_m.png]", "remainder: 8"],
      ],
    ]]
  end

  class CalendarNote
    Mayan = [{},['Mayan#{?Epoch=Epoch}::Trecena', 'Mayan#{?Epoch=Epoch}::Tzolk\'in',
                      'Mayan#{?Epoch=Epoch}::Lords_of_the_Night', 'Mayan#{?Epoch=Epoch}::Haab\'']]
  end

  class TM::CalendarEra

    #
    # Mayan Long Count
    #
    LongCount = [{}, self, [
      "namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/]",
      "locale:[=en:, ja=ja:, alias]",
      'area:[LongCount#{?Epoch=Epoch}=en:Mesoamerican_Long_Count_calendar, マヤ長期暦=ja:%%<長期暦>]',
     ["[PHLC=, 先史時代=, PreHistoricLongCount=]0.0.0.0.0", "[Pre Historic=]",	'-13.0.0.0.0^LongCount#{?Epoch=Epoch}'],
     ["[HLC=,  歴史時代=, HistoricLongCount=]0.0.0.0.1",    "[Historic Age=]",	  "0.0.0.0.1"],
     ["[NLC=,  新時代=,   NewLongCount=]0.0.0.0.1",	    "[New Age=]",	 "13.0.0.0.1", "26.0.0.0.1"]
    ]]
  end

  module CalendarTypes

    _c20 = When.Index({:base=>0, :unit=>20})
    _c18 = When.Index({:base=>0, :unit=>18})

    #
    # Mayan Long Count
    #
    LongCount =  [{'Epoch' => Hash.new {|hash, key|
                                hash[key] = {
                                  'origin_of_LSC' => 584283 + key.to_i
                                }}}, CyclicTableBased, {
      'origin_of_LSC' => 584283,
      'rule_table'    => {
        'T' => {'Rule'  =>[360]},
        360 => {'Length'=>[20] * 18}
      },
      'indices'=> [_c20, _c20, _c18, _c20],
      'note'   => 'Mayan#{?Epoch=Epoch}'
    }]
  end
end
