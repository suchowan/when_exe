# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When

  class BasicTypes::M17n

    CopticTerms = [self, [
      "namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/]",
      "locale:[=en:, ja=ja:, alias]",
      "names:[CopticTerms=]",
      "[Coptic=en:Coptic_calendar,       コプト暦    ]",
      "[Ethiopian=en:Ethiopian_calendar, エチオピア暦=en:Ethiopian_calendar]",

      [self,
        "names:[EgyptianMonth=, 月=ja:%%<月_(暦)>]",
        "[tut=,      トート=      ]",
        "[baba=,     バーバ=      ]",
        "[hatur=,    ハートール=  ]",
        "[kiyahak=,  キヤハーク=  ]",
        "[tuba=,     トーバ=      ]",
        "[amshir=,   アムシール=  ]",
        "[baramhat=, バラムハート=]",
        "[barmuda=,  バルムーダ=  ]",
        "[bashans=,  バシャンス=  ]",
        "[ba'una=,   バウーナ=    ]",
        "[abib=,     アビーブ=    ]",
        "[misra=,    ミスラー=    ]",
        "[epagomen=, エパゴメネ=  ]"
      ],

      [self,
        "names:[EthiopianMonth=, 月=ja:%%<月_(暦)>]",
        "[Mäskäräm=, マスカラム=  ]",
        "[Ṭəqəmt=,   テケルト=    ]",
        "[Ḫədar=,    ヘダル=      ]",
        "[Taḫśaś=,   ターサス=    ]",
        "[Ṭərr=,     テル=        ]",
        "[Yäkatit=,  イェカティト=]",
        "[Mägabit=,  メガビト=    ]",
        "[Miyazya=,  ミアジア=    ]",
        "[Gənbot=,   ゲエンポト=  ]",
        "[Säne=,     セネ=        ]",
        "[Ḥamle=,    ハムレ=      ]",
        "[Nähase=,   ネハッセ=    ]",
        "[Ṗagʷəmen=, パゴウメン=  ]"
      ]
    ]]
  end

  module CalendarTypes

    _egyptian_month_indices  = [
      When::Coordinates::Index.new({:unit =>13, :trunk=>When::Parts::Resource._instance('_m:CopticTerms::EgyptianMonth::*')}),
      When::Coordinates::Index.new
    ]

    _ethiopian_month_indices = [
      When::Coordinates::Index.new({:unit =>13, :trunk=>When::Parts::Resource._instance('_m:CopticTerms::EthiopianMonth::*')}),
      When::Coordinates::Index.new
    ]

    #
    # Coptic Calendar in Egypt and Ethiopia
    #
    Coptic =  [{'Epoch'=>{'284Y'=>{'origin_of_MSC' =>   1,
                                   'label'         => Parts::Resource._instance('_m:CopticTerms::Coptic'),
                                   'indices'       => _egyptian_month_indices},
                            '8Y'=>{'origin_of_MSC' => 277,
                                   'label'         => Parts::Resource._instance('_m:CopticTerms::Ethiopian'),
                                   'indices'       => _ethiopian_month_indices}}}, CyclicTableBased, {
      'label'         => Parts::Resource._instance('_m:CopticTerms::Coptic'),
      'origin_of_LSC' => 1825030,
      'origin_of_MSC' =>       1,
      'epoch_in_CE'   =>     285,
      'indices'       => _egyptian_month_indices,
      'rule_table' => {
        'T' => {'Rule'  =>[365,365,366,365]},
        365 => {'Length'=>[30]*12+[5]},
        366 => {'Length'=>[30]*12+[6]}
      }
    }]
  end
end
