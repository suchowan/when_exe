# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When

  class BasicTypes::M17n

    AncientOrient = [self, [
      "locale:[=en:, ja=ja:, alias]",
      "names:[AncientOrient=en:Ancient_Orient, 古代オリエント]",
      "[Babylonian=en:Babylonian_calendar, バビロニア暦]",
      "[Seleucid=en:Seleucid_era, セレウコス紀元=]",

      # Remarks
      '[based on Chris Bennett "Babylonian and Seleucid Dates" (Retrieved 2014-06-29)=http://suchowan.at.webry.info/201407/article_8.html,' +
       '典拠 - Chris Bennett "Babylonian and Seleucid Dates" (2014-06-29 閲覧)=]',

      '[based on R.A.Parker & W.H.Dubberstein "Babylonian Chronology 626B.C.-A.D.75"=http://suchowan.at.webry.info/201407/article_23.html,' +
       '典拠 - R.A.Parker & W.H.Dubberstein "Babylonian Chronology 626B.C.-A.D.75"=]',

      [self,
        "names:[IntercalaryMonth=en:Intercalation, 閏月]",
        "[%s I=,  第１=]",
        "[%s II=, 第２=]",
      ],

      [self,
        "names:[BabylonianMonth=en:Month, 月=ja:%%<月_(暦)>]",
        "[Nisānu=  ]",
        "[Āru=     ]",
        "[Simanu=  ]",
        "[Dumuzu=  ]",
        "[Abu=     ]",
        "[Ulūlu=   ]",
        "[Tišritum=]",
        "[Samna=   ]",
        "[Kislimu= ]",
        "[Ṭebētum= ]",
        "[Šabaṭu=  ]",
        "[Addaru=  ]"
      ],

      [self,
        "names:[SeleucidMonth=en:Month, 月=ja:%%<月_(暦)>]",
        "[Artemisios=    ]",
        "[Daisios=       ]",
        "[Panemos=       ]",
        "[Loios=         ]",
        "[Gorpiaios=     ]",
        "[Hyperberetaios=]",
        "[Dios=          ]",
        "[Apellaios=     ]",
        "[Audnaios=      ]",
        "[Peritios=      ]",
        "[Dystros=       ]",
        "[Xandikos=      ]"
      ]
    ]]
  end

  module CalendarTypes

    #
    #  Ancient Orient Dates
    #
    # From Chris Bennett, http://www.tyndalehouse.com/Egypt/ptolemies/chron/babylonian/chron_bab_intro_fr.htm
    #

    # Chris Bennett -330..-29
    _table_CB2 = %w(							AbCDeFgHIjkL
	aBcDeFGhIJklL	abcdEFGHIJkl	AbcDeFgHIjKL	aBcdEfGhIJkLL	AbCdEfGhIjkL
	aBcDeFGhiJkL	aBCdEFgHijKLl	abCDEFgHijkL	aBcDEfGhIJkLl	aBcDEFGhiJkL
	abCdEFGhIjKl	AbcDeFGhIjKlL	AbCdEfGhiJKl	ABcDeFghIjKl	ABcDEfGhiJkLl
	ABcDEfGhiJkl	ABcDEFghIjKl	aBCdEFfGhIjKl	aBcDEfGHiJkL	abCdEfGHiJKlL
	abCdEfGhIJKl	AbcDeFgHiJKl	AbCdEfGhIjKlL	AbCdEfGhIjKl	AbCDeFGhiJkl
	AbCDeFGHijKll	AbCdEFGHijKl	abCdEFGHIjkLl	abCDeFGHiJkL	abCdEfGHiJkL

	AbcDeFgHiJkLL	aBCdEfgHiJkL	aBCDeFghiJkL	aBCDEfGhiJklL	aBCDeFgHiJkl
	AbCdEFGhIjKl	aBcDeFFGhIjKl	aBcDeFgHIjKL	abCdeFgHIJkLL	abCdeFgHIjKL
	aBcDeFgHiJkL	aBCdEfGhIjkLl	ABcDEfGhIjkL	aBcDEFgHiJkl	AbCdEFGhIjKLl
	abCDeFgHIjKL	abcdEFGhIjKLl	aBcDeFgHiJKl	AbCdeFGhiJKl	AbCDeFgHijKlL
	AbCDEfgHijKl	AbCDEFghIjkL	aBcDEFgHiJklL	aBcDEfGhIJkl	AbCdEfGHiJKl
	aBcDefFGhIJkL	aBcDefgHIJkL	ABcdeFgHiJKlL	AbCdeFgHiJkL	AbCdEFgHijKl
	AbCDeFGhIjkLl	AbcDEFGhIjkL	abCdEFGhIJkl	AbcdEFGHiJKLl	abcDeFGhIJkL
	aBcdEfGHiJkLL	aBcdEFghIJkL	aBCdEfGhiJkL	aBCDeFgHijKll	ABCdEFgHijKl
	aBCdEFGhiJkL	abCDeFGhIjkLL	abCdEFgHIjKl	AbCdeFgHIjKL	aBcdEfFgHiJKL
	aBcDefGhIjKL	aBcDeFgHiJkLl	ABcDeFgHiJkl	AbCDeFGhIjKl	aBcDEfGHIjkLl

	aBcDeFGHiJkl	AbcDEfGHIjKl	AbcDeFGhIjKLl	AbcDeFGhIjKl	AbCDEfghIjKlL
	AbCDeFghIjkL	AbCDEfGhijKl	AbCDEFgHijKLl	aBcDEfGhIjKl	aBcDEfGhIJkl
	AbCdEfGhIJkLL	abCdEfGhIJkL	AbCdeFghIJkL	ABcdeFfGhIjKL	AbcDeFgHiJkL
	AbCDeFgHiJklL	aBcDEFgHiJkl	AbCdEFgHIjKl	aBcdEfGHIJkLl	abcDEFGhIJkL
	abcDeFGHiJkL	aBcDeFgHIjkLL	aBcDeFgHijKL	aBcDEFghIjkLl	ABcDEFghiJkL
	aBcDEFgHijKl	AbCdEFGhIjkLl	aBcDEFGHiJkl	aBcdEFgHiJKl	AbCdeFgHiJKLl
	AbCdefgHIJKl	ABcDeFghIjKl	ABCdEfFghIjKl	ABcDeFGhIjkL	AbcDeFGHiJklL
	abCdEFGHiJkl	AbcDeFGHIjKl	aBcdEfGHIjKlL	aBcdEfGHiJKl	AbCdeFGhIjKl
	AbCDeFgHijKlL	aBCDeFghIJkl	aBCDEfGhIjkLl	aBCDEfGhIjkL	abCDEfGHijKl
	AbcDEfGHiJkLl	AbCdEfGhIJkL	aBcDeFGhijKL	aBCdEfgHijKLL	aBCdEfgHijKL

	aBCDeFghIjKl	AbCDeFfGhIjKl	aBCdEFgHiJkL	abCdEfGHIJklL	abCdEfGHIjKl
	AbcDeFgHIJkL	aBcdEfGhIJkLl	AbCdEfGHijKl	ABcDEfGhiJkL	aBcDEFgHijkLl
	AbCDEFgHijkL	aBcDEFgHIjkLl	aBcDEFgHiJkL	abCdEFgHiJKl	AbcDeFgHiJKlL
	AbCdeFgHiJKl	ABcDefGhiJKl	ABcDEfgHijKlL	AbCDeFgHiJkl	AbCDEfGhIjKl
	aBcDeFFGhIjKl	aBcDeFGhIJkL	abCdeFGhIJKlL	abCdeFGhIJkL	AbcDeFgHiJkL
	AbCdEfGhIjKlL	AbCdEfGhIjkL	aBCdEFGhiJkl	AbCdEFGHijKll	ABcdEFGhIjKl
	abCDeFGHiJkLl	aBcDeFGhIjKl	aBCdEfGhIJkL	aBcDeFghIjKLL	aBcDeFghIjKL
	aBCdEfGhiJkL	aBCDeFgHijKlL	aBCdEfGHiJkl	AbCdEFgHIjKl	aBcdEFfGHIjKl
	aBcdeFGHIJkL	abCdeFgHIjKLl	AbCdeFgHIjKl	ABcdEFgHijKL	aBcDeFGhIjkLl
	AbCDEfGhIjkL	abCDEFgHiJkl	AbcDEFgHIjKll	AbcDEFgHiJkL	aBcDeFgHiJKlL

	aBcDeFghIJkL	AbCdEfgHiJkL	aBCDeFghIjKlL	AbCDeFghIjkL	AbCDEfGhiJkL
	abCDEFghIjKlL	abCDeFGhIJkl	AbcDeFgHIJkL	aBcdEfFgHIJkL	aBcdEfGhIJkL
	AbCdeFgHiJkLL	aBcDeFgHiJkL	aBCdEFgHijkL	aBCDEfGhiJklL	aBcDEFGhIjkl
	AbCdEFGHijKl	aBcDeFGHiJkLl	AbcDeFGhIjKL	aBcDeFghIjKLl	ABcDeFghIjKl
	ABCdEfGhiJkL	aBCdEFghIjKll	ABCdeFGhIjKl	aBcDEFgHiJkL	abCdEfGHIjKlL
	abCdEFGhiJKl	AbcDefGHiJKL	aBcdEffGHiJKl	AbCdEfGhIjKl	ABcDeFgHiJklL
	AbCdEFgHiJkl	ABCdEfGHijKl	aBcDeFGHIjkLl	abCdEFGHiJkL	abcDEfGHiJKl
	AbcDeFgHiJKlL	aBcDeFgHiJkL	AbCDeFghiJkLL	aBCDeFghiJkL	aBCDEfGhiJkl
	AbCDEfGhIjkLl	AbCDeFgHIjKl	aBcDeFgHIJkL	abCdEfgHIJkLL	abCdeFgHIjKL
	aBcDefGhIjKL	AbCdEffGhIjKL	aBcDEfGhIjkL	aBcDEFgHiJklL	aBcDEFgHiJkl

	AbcDEFGhIjKl	abCdEFGhIJklL	abCdEFgHIjKl	AbcDeFGhIjKL	aBcDeFgHijKLl
	ABcDeFghIjKl	ABcDEFghiJkLl	ABcDEfGhiJkL	aBcDEFgHijKl	AbCdEFgHiJkLl
	AbcDEfGhIJkL	aBcdEfGhIJKl	AbCdeFgHiJKLL	abCdeFghIJKl	ABcDefGhIjKl
	ABcDeFfGhIjKl	AbCDeFGhIjkL	abCdEFGHiJklL	abCdEFGHiJkl	AbcDeFGHiJkL
	abCdEfGHiJKlL	abCdEFgHiJkL	AbcDEfGhiJkL	AbCdEFgHijKlL	aBCDeFghIjkL
	aBCDeFGhiJklL	aBCdEFgHiJkL	abCDeFgHIjKl	AbcDeFgHIjKLl	AbcDeFgHiJKL
	aBcdEfGhIjKL	aBCdeFghIjKLl	ABcDeFgHiJkL	aBCdEfGhIjKl	aBcDEfFGhIjKl
	aBcDeFGHIjkL	abcDEfGHIjKlL	abcDEfGHIjKl	AbcdEFgHIjkL	AbCdEfGhIjKlL
	AbCdEFghIjKl	AbCDEfgHijKl	AbCDEFgHijkLl	AbCDEFghIjkL	aBcDEFgHiJkLl
	aBcDEfGhIJkL	abCdEfGhIJkL	AbcDeFghIJKlL	aBcDefGhIJkL	AbCdEfgHiJKl

	AbCDeFghIjKlL	aBCdEFgHiJkl	AbCDeFgHIjKl	aBcdEFFGhIjKl	abCdEFGhIJkL
	abcDeFGhIJkLl	AbcDeFGhIjKL	aBcDeFgHiJkL	aBCdEfGhIjkLl	ABcDEFghiJkL
	aBcDEFGhijKl	AbCdEFGhIjkLl	aBCdEFGhIjkL	aBcDeFgHIjKlL	aBcDeFgHiJKl
	AbCdEfgHiJKL	aBcDeFghIjKLl	ABcDefGhIjKl	ABcDEfGhiJkL	aBcDEfGhIjKlL
	aBcDeFGHiJkl)

    # Parker & Dubberstein -625..-331
    _table_PD1 = %w(							ABcDefGhIjKl
	ABcDeFGhIjkL	aBcDEfGHiJklL	aBcDeFGHiJkl	AbcDeFGHiJKl	aBcdEfFGHIjKl
	aBcdEfGHIjKl	AbCdeFGhIjKlL	AbCdeFGhiJkL	AbCDeFgHijKl	AbCDEfFgHijKl
	AbCDEfGhIjkL	abCDEFgHijKlL	abCDeFGhIjKl	AbcDEfGhIJkL	aBcdEfFgHIJkL
	aBcDefGhIJkL	AbCdEfgHiJkL	AbCDefGhIjKl	AbCDeFfGhIjKl	AbCdEFgHIjkLl
	aBcDEFgHIjkL	abCdEFgHIJkl	AbcdEFFgHIjKl	AbcDeFGhIjKL	aBcdEfGHiJkL

	aBcDeffGHIjkL	ABcDEfGhiJkL	aBcDEFfGhiJkl	AbCDEFghIjKl	aBcDEFFghIjKl
	aBcDEfGHiJkL	abCdEFgHiJKlL	abCdEfGhIJKl	AbCdeFghIJKl	ABcDefGhiJKlL
	AbCdEfGhIjkL	AbCdEFgHiJkl	AbCdEFGhIjKll	AbCdEFGhIjKl	aBcdEFGHiJkL
	abCdeFGHiJKl	AbcDefFGHiJkL	aBcDeFgHiJkL	AbCdEfGhIjKlL	aBCdEFghIjkL
	aBCDeFGhiJkl	AbCDEfGHijKll	AbCdEFGhIjKl	aBcDeFGhIJkLl	aBcDeFgHIjKL
	abCdEfGhIjKL	aBcDeFfgHiJKL	aBcDeFghIjKL	aBCdEfGhiJkLl	ABcDEfGhIjkL
	aBcDeFGHiJkl	AbcDEfGHIjKll	AbcDeFGHIjKl	aBcdEfGHIjKl	AbcDeFgHIjKL
	aBcdEfGHiJkL	aBcDeFFgHijKl	ABcDEfGhIjkLl	AbCDEFghIjkL	abCDEFgHiJkl
	aBcDEFGhIjKll	AbcDEFgHiJkL	aBcDeFgHiJKl	AbCdEfgHiJKlL	AbCdEfgHijKL
	ABcDeFghIjKlL	AbCdEFghIjKl	AbCdEFgHiJkLl	aBcDEFgHIjkL	abCdEFgHIJkl

	AbcDeFGhIJkLl	AbcDeFGhIJkL	aBcdEfGHiJkL	AbcDeFgHiJkL	AbCdEfFGhiJkL
	aBcDEfGHijKl	aBcDEFGhIjkLl	aBcDEFGhIjkl	AbCdEFgHIjKl	AbcDeFgHIJkLl
	AbcDeFGhIjKL	aBcDefGhiJKL	aBcDEfgHiJkL	aBCdEFfgHijKL	aBCdEFghIjKll
	ABcDEfGhiJkL	aBCdEfGHiJkL	abCDefGHIjKlL	abCdeFGHiJKl	AbcdEfGHIjKL
	aBcdEfFgHiJKl	AbCdEfGhIjKl	AbCDeFGhiJkl	AbCDeFFGhiJkl	AbCDEFghIjKl
	abCDEFgHiJkLl	abCDEfGHiJkL	abCdEFgHiJKl	aBcDeFgHiJKlL	aBcDeFgHiJkL
	AbCDefGhiJkL	AbCDEffGhiJkL	aBCDeFgHijKl	AbCDeFGhIjKll	AbCdEFgHIjKl
	aBcdEFgHIJkL	abCdeFgHIJkLL	abCdEfgHIJkL	aBcdEFgHIjkL	aBCdeFFgHijKL
	aBcDEfGhIjkL	aBcDEFgHiJklL	abCDEFGhiJkl	aBcDEFGhIjKl	abCdEFGhIJklL
	abCdEFgHIjKl	AbCdEfGhIjKL	aBcDeFfGhiJKl	ABcDeFghIjKl	ABcDEfGhiJkL

	aBcDEFgHijKlL	aBcDEfGhIjKl	AbcDEfGHiJKll	AbcDeFGhIJkL	aBcdEfGhIJkL
	AbCdeFgHiJKlL	AbCdeFgHiJKl	AbCdEfGhIjKlL	aBCdEFgHijKl	AbCdEFGhIjkL
	abCdEFGHiJkll	AbCdEFGHijKl	aBcDeFGHiJkL	aBcdEFgHiJkLL	abCdEFghIjKL
	aBCdEfGhiJkL	AbCDeFfgHijKL	aBCDeFghIjkL	aBCDeFGhiJklL	aBCdEFgHiJkL
	abCdEFgHIjKl	AbcDeFgHIJkLl	AbcDefGHIjKL	aBcdEfgHIjKL	aBcDeFgHiJkLl
	ABcDeFgHiJkL	aBcDEfGHijKll	AbCDEfGHijkL	aBCDeFgHIjkl	AbcDEFGhIjKlL
	abcDEFgHIjKl	aBcDeFgHIjKl	AbCdEfGhIjKlL	AbCDeFghiJkL	AbCDEfGhijKl
	ABcDEFfgHijKl	AbCDEfGhIjkL	aBcDEfGHiJkLl	aBcDeFGhIJkL	abCdEfGhIJkL
	AbcDefGhIJKlL	aBcDefGhIJkL	AbCdEfgHiJKl	AbCDeFgHiJklL	aBCdEFgHiJkl
	AbCdEFGhIjKll	aBcDEFGhIjKl	abCdEFGHiJkL	abcDeFGHiJkLl	AbcDEfGhIjKL

	aBcDeFghIjKL	aBCdEfGhiJkLl	ABCdEFghiJkL	aBCdEFgHijKl	AbCdEFGhIjkLl
	aBCdEFgHiJkL	aBcDeFgHIjKlL	aBcdEfGHiJKl	AbCdeFgHiJKL	aBcDefGhIjKlL
	ABcDefGhIjKl	ABcDeFgHiJkL	aBcDEfGHiJkll	AbCDeFGHiJkl	aBcDeFGHIjKll
	aBcDeFGHiJkL	abCdEfGHiJKl	AbcDeFGhIjKlL	aBcDEfGhiJkL	AbCDeFgHijKl
	AbCDEfGhiJklL	aBCDEfGhiJkl	AbCDEfGHijKl	aBcDEFgHiJkLl	aBcDeFGhIJkL
	aBcdEfGhIJkLL	aBcdEfGhIjKL	AbCdeFgHiJkL	AbCDefGhIjKlL	aBCdEfGhIjKl
	aBCdEFgHiJkl	AbCdEFGhIjKll	AbcDEFgHIjKl	aBcdEFGhIJkLl	aBcdEFGhIjKL
	abCdEfGhIjKL	aBcDeFGhiJkLl	ABcDEfGhijKl	ABcDEFgHijkL	aBcDEFGhiJklL
	aBcDEFgHiJkl	AbCdEFgHIJkl	aBcDeFfGHiJKl	AbcDeFgHiJKl	ABcdEfgHiJKlL
	AbCdEfgHiJKl	ABcDeFghIjKl	ABcDEfGhIjkLl	AbCDeFGhIjkL	aBcDeFGHiJkl

	AbcDeFGHIjKll	AbcDeFGHiJKl	aBcdEfGHiJKlL	aBcdEFgHiJkL	AbCdEfGhIjkL
	AbCDeFgHijKlL	aBCDeFGhijKl	aBCDEfGhIjkL	abCDeFGHiJklL	abCDeFGhIjKl
	AbCdEfGhIJkL	aBcDeFfgHIjKL	aBcDefGhIjKL	aBCdEfgHiJkLl	ABCdEfgHiJkL
	aBCdEfGHijKlL	aBcDEfGhIJkl	aBcDEfGHIjKl	abCdEfGHIjKl	AbcDeFgHIJkLl
	AbcDeFgHIjKL	aBcdEFgHijKLl	AbCdEFgHijKl	AbCDEfGhiJkL	abCDEFgHijKll
	AbCDEFgHijKl	aBcDEFgHiJkL	abCdEFgHIjKlL	abCdEFgHiJKl	AbCdEfgHiJKl
	ABcDeFfgHiJkL	AbCdEfGhIjKl	AbCDEfgHiJklL	AbCDeFgHiJkl	AbCDeFGhIjKl
	aBcDeFGhIJkLl	aBcdEFgHIJkL	abCdeFGhIJKl	AbcDeFgHiJKlL	aBcDeFgHiJkL
	aBCdEfGhIjKlL	aBcDEFgHijkL	aBcDEFGhiJkl	AbCdEFGHijKll	AbCdEFGhIjKl
	aBcDeFGhIjKL	abCdEfGhIjKLl	ABcdEfGhIjKL	aBCdEfghIjKL	aBCDeFfghIjKl

	ABCdEfGhIjkL	aBCdEFgHiJklL	aBcDEfGHiJkl	AbCdEfGHIjKl	aBcdEfGHIjKLl
	aBcdEfGHiJKl	AbCdeFgHIjKl	ABcDeFgHiJkLl	AbCDeFgHijKl	AbCDEfGHijkLl
	AbCDEfGhIjkL	abCDEFgHiJkl	AbcDEFgHIjKll	AbcDEfGHiJkL	aBcDeFgHiJKl
	AbCdEfGhiJKlL	AbCdEfgHiJkL	AbCDeFghIjKl	AbCDEfFghIjKl) #AbCDeFgHIjkL

    # Parker & Dubberstein -330..-29
    _table_PD2 = %w(							AbCDeFgHIjkL
	aBcDeFGhIJklL	abCdEFgHIJkl	AbcDeFgHIJkL	aBcdEfGhIJkLL	AbCdEfGhIjkL
	aBcDeFGhiJkL	aBCdEFgHijKLl	aBcDEFgHijKl	AbcDEFGhIjkLl	aBcDEFGhiJkL
	abCdEFGhIjKl	AbcDeFGhIjKlL	AbCdEfGhiJKl	ABcDeFghIjKl	ABcDEfGhiJkLl
	ABcDEfGhiJkl	ABcDEFghIjKl	aBCdEFfGhIjKl	aBcDEfGHiJkL	abCdEfGHiJKlL
	abCdEfGhIJKl	AbcDeFgHiJKl	ABcdEfGhIjKlL	AbCdEfGhIjKl	AbCDeFGhiJkl
	AbCDeFGHijKll	AbCdEFGHijKl	aBcdEFGHiJkLl	aBcDeFGHiJkL	abCdEfGHiJkL

	AbcDeFgHiJkLL	aBCdEfgHiJkL	aBCDeFghiJkL	aBCDEfGhiJklL	aBCDeFgHiJkl
	AbCdEFGhIjKl	aBcDeFFGhIjKl	aBcDeFgHIjKL	abCdEfgHIJkLL	abCdeFgHIjKL
	aBcDeFgHiJkL	aBCdEfGhIjkLl	ABcDEfGhIjkL	aBcDEFgHiJkl	AbCdEFGhIjKll
	AbcDEFgHIjKl	aBcdEFGhIjKLl	aBcDeFgHiJKl	AbCdEfGhIjKl	AbCDeFgHijKlL
	AbCDEfgHijKl	AbCDEFghIjkL	aBcDEFgHiJklL	aBcDEfGhIJkl	AbCdEfGHiJKl
	aBcDefFGhIJkL	aBcDefGhIJKl	ABcdeFgHiJKlL	AbCdeFgHiJkL	AbCdEFgHijKl
	AbCDeFGhIjkLl	AbcDEFGhIjkL	abCdEFGhIJkl	AbcDeFGHiJKll	AbcDeFGhIJkL
	aBcdEFgHiJkLL	aBcdEFghIJkL	aBCdEfGhiJkL	aBCDefGHijKll	ABCdEFgHijKl
	aBCdEFGhiJkL	abCDeFGhIjKlL	abCdEFgHIjKl	AbCdeFgHIjKL	aBcDeFfgHiJKL
	aBcDefGhIjKL	aBcDeFgHiJkLl	ABcDeFgHiJkl	ABcDEfGHijKl	aBcDeFGHIjkLl

	aBcDeFGHIjkL	abCdEfGHIjKl	AbcDeFgHIjKLl	AbcdEFGhiJKl	AbCdEfGhIjKlL
	AbCDeFghIjkL	AbCDEfGhiJkl	AbCDEFgHijKll	AbCDEfGhIjKl	aBcDEfGHiJkL
	abCdEfGhIJKlL	abCdEfGhIJkL	AbCdeFghIJkL	AbCDefFghIJkL	AbCdEfGhIjkL
	AbCDeFgHiJklL	aBcDEFgHiJkl	AbCdEFGhiJKl	aBcdEFGhIJkLl	aBcdEFGhIJkL
	abCdeFGhIJkL	aBcDeFgHiJkLL	aBcDeFgHijKL	aBcDEFghIjkLl	ABcDEFghIjkL
	aBcDEFGhiJkl	AbCdEFGhIjKll	AbCdEFgHiJKl	aBcDeFgHiJKl	AbCdEfgHIjKLl
	AbCdEfgHiJKl	ABcDefGHijKl	ABCdEfFghIjKl	ABcDeFGhIjkL	AbcDeFGHiJklL
	abCdEFGHiJkl	AbcDeFGHIjKl	aBcdEfGHIjKlL	aBcdEfGHiJKl	AbCdeFGhIjKl
	AbCdEFgHijKlL	aBCDeFghIJkl	AbCDEfGhIjkLl	aBCDEfGhIjkL	abCDEfGHijKl
	AbcDEfGHiJkLl	AbCdEfGhIJkL	aBcDeFghIjKL	aBCdEfgHiJkLL	aBCdEfgHiJkL

	aBCDeFghIjKl	AbCDeFfGhIjKl	aBCdEFgHiJkL	abCdEfGHIJklL	abCdEfGHIjKl
	AbcDeFgHIJkL	aBcdEfGhIJkLl	AbCdEfGHijKl	ABcDeFGhiJkL	aBcDEFgHijKll
	AbCDEFgHijKl	aBcDEFGhIjkLl	aBcDEFgHiJkL	abCdEFgHiJKl	AbcDeFgHiJKlL
	AbCdeFgHiJKl	ABcDefGhiJKl	ABcDEfgHijKlL	AbCDeFgHiJkl	AbCDEfGhIjKl
	AbcDeFFGhIjKl	aBcDeFGhIJkL	abCdeFGhIJKlL	abCdeFGhIJkL	AbcDefGHiJkL
	AbCdEfGhIjKlL	AbCdEfGhIjkL	aBCdEFGhiJkl	AbCdEFGHijKll	AbCdEFGhIjKl
	aBcDeFGHiJkLl	aBcDEfGhIjKl	AbCdEfGhIJkL	aBcDeFghIjKLL	aBcDeFghIjKL
	aBCdEfGhiJkL	aBCDeFgHijKlL	aBcDEfGHiJkl	AbCdEfGHIjKl	aBcdEFfGHIjKl
	aBcdEfGHIjKL	abCdeFgHIjKLl	AbCdeFgHIjKl	ABcdEFgHijKl	ABcDeFGhIjkLl
	AbCDEfGhIjkL	abCDEFgHiJkl	AbcDEFgHIjKll	AbcDEFgHiJkL	aBcDeFgHiJKlL

	aBcDeFghIJkL	AbCdEfGhiJkL	aBCDeFghIjKlL	AbCDeFghIjKl	AbCDEfGhiJkL
	abCDEfGhIjKlL	abCDeFgHIJkl	AbcDeFgHIJkL	aBcdEfFgHIJkL	aBcdEfGhIJkL
	AbCdeFgHiJkLL	aBcDeFgHiJkL	aBCdEFgHijKl	aBCdEFGhiJkLl	aBcDEFGhIjkL
	abCdEFGHijKl	aBcDeFGHiJkLl	AbcDeFGhIjKL	aBcDeFghIjKLl	ABcDeFghIjKl
	ABCdEfGhijKL	aBCdEFghIjkLl	ABcDEfGhIjKl	aBcDEFgHiJkL	abCdEfGHIjKlL
	abCdEfGHiJKl	AbcDefGHiJKL	aBcdEffGHiJKl	AbCdEfGhIjKl	ABcDeFgHiJklL
	AbCdEFgHiJkl	AbCdEFGHijKl	aBcDeFGHIjkLl	abCdEFGHiJkL	abcDEfGHiJKl
	AbcDeFgHiJKlL	aBcDeFgHiJkL	aBCdEFghiJkLL	aBCDeFghiJkL	aBCDEfGhiJkl
	AbCDEfGhIjkLl	AbCDeFgHIjKl	aBcDeFgHIJkL	abCdEfgHIJkLL	abCdeFgHIjKL
	aBCdefGhIjKL	AbCdEffGhIjKL	aBcDEfGhIjkL	aBcDEFgHiJklL	aBcDEFgHiJkl

	AbcDEFGhIjKl	abCdEFGhIJkLl	abCDeFgHIjKl	AbcDeFGhIjKL	aBcDeFgHijKLl
	ABcDeFghIjKl	ABcDEFghiJkLl	AbCDEfGhiJkL	aBcDEFgHijKl	AbCdEFgHiJkLl
	AbcDEfGhIJkL	aBcdEfGhIJKl	AbCdeFgHiJKlL	AbCdeFgHiJKl	ABcDefGhIjKl
	ABcDeFfGhIjKl	AbCDeFGhIjkL	abCdEFGHiJklL	abCdEFGHiJkl	AbcDeFGHiJkL
	abCdEfGHiJKlL	abCdEFgHiJkL	aBcDEfGhiJkL	AbCdEFgHijKlL	aBCDeFghIjkL
	aBCDeFGhiJklL	aBCdEFgHiJkL	abCDeFGhIjKl	AbcDeFgHIjKLl	AbcDeFgHiJKL
	aBcdEfGhIjKL	aBCdeFghIjKLl	ABcDeFgHiJkL	aBCdEfGhIjKl	aBcDEfFGhIjKl
	aBcDeFGHIjkL	abcDEfGHIjKlL	abcDEfGHIjKl	AbcdEFgHIjkL	AbCdEfGhIjKlL
	AbCdEFghIjKl	AbCDEfgHijKl	AbCDEFgHijkLl	AbCDEFghIjkL	aBcDEFgHiJkLl
	aBcDEfGhIJkL	abCdEfGhIJkL	AbcDeFghIJKlL	aBcDefGhIJkL	AbCdEfgHiJKl

	AbCDeFghIjKlL	aBCdEFgHiJkl	AbCDeFgHIjKl	aBcdEFFGhIjKl	abCdEFGhIJkL
	abcDeFGhIJkLl	AbcDeFGhIjKL	aBcDeFgHiJkL	aBCdEfGhIjkLl	ABcDEFghiJkL
	aBcDEFGhijKl	AbCdEFGhIjkLl	aBCdEFGhIjkL	aBcDeFgHIjKlL	aBcDeFgHiJKl
	AbCdEfgHiJKL	aBcDeFghIjKLl	ABcDefGhIjKl	ABcDEfGhiJkL	aBcDEfGhIjKlL
	aBcDeFGHiJkl)

    _table_CB   = _table_PD1 + _table_CB2
    _table_PD   = _table_PD1 + _table_PD2
    _remarksCB  = When.M17n('AncientOrient::based on Chris Bennett "Babylonian and Seleucid Dates" (Retrieved 2014-06-29)')
    _remarksPD  = When.M17n('AncientOrient::based on R.A.Parker & W.H.Dubberstein "Babylonian Chronology 626B.C.-A.D.75"')

    _babylonian = [
      When.Index('AncientOrient::BabylonianMonth', {:branch=>{1=>When.Resource('_m:AncientOrient::IntercalaryMonth::*')[1]}}),
      When::Coordinates::DefaultDayIndex
    ]

    _seleucid = [
      When.Index('AncientOrient::SeleucidMonth', {:branch=>{1=>When.Resource('_m:AncientOrient::IntercalaryMonth::*')[1]}}),
      When::Coordinates::DefaultDayIndex
    ]

    # Chris Bennett
    Babylonian = [PatternTableBasedLuniSolar, {
      'label'        => 'AncientOrient::Babylonian',
      'remarks'      => _remarksCB,
      'origin_of_LSC'=> 1492871,
      'origin_of_MSC'=> -625,
      'rule_table'   => _table_CB,
      'indices'      => _babylonian
      }
    ]

    Seleucid = [PatternTableBasedLuniSolar, {
      'label'        => 'AncientOrient::Seleucid',
      'remarks'      => _remarksCB,
      'origin_of_LSC'=> 1492871,
      'origin_of_MSC'=> -314,
      'epoch_in_CE'  => -625,
      'rule_table'   => _table_CB,
      'indices'      => _seleucid
      }
    ]

    # R. A. Parker & W. H. Dubberstein
    BabylonianPDE = [PatternTableBasedLuniSolarWithEphemeris, {
      'label'        => 'AncientOrient::Babylonian',
      'remarks'      => _remarksPD,
      'origin_of_LSC'=> 1492871,
      'origin_of_MSC'=> -625,
      'engine'       => 'ChineseLuniSolar?time_basis=+03',
      'rule_table'   => %w(              N N A N N U N A N N U N
                           A N N U N N N U A N N U N N U N U N U
                           N A N N A N N A N N N U N A N N A N A
                           N N U N A N N A N N N N U A N N A N N
                           A N A N A N N A N N N U N A N N A N N
                           N U A N N A N N U N N U N A N N A N N
                           U N A N N A N N U N A N N A N N U N N
                           A N A N N A N a N N A N N A N N U N A
                           N N a N N a N A N N A N N A N N U N A
                           N N A N N a N A N N A N N A N N A N A
                           N N A N N a N A N N A N N A N N A N A
                           N N A N N A N A N N A N N A N N U N A
                           N N A N N A N A N N A N N a N N U N A
                           N A N N N A N A N N A N N A N N U N A
                           N N A N N A N A N N A N N A N N U N A
                           N N A N N A N A N N A N N A N N U N A),
      'subkey_table' => {'N'=>'ABCDEFGHIJKL',
                         'A'=>'ABCDEFGHIJKLL',
                         'a'=>'ABCDEFGHIJKLL',
                         'U'=>'ABCDEFFGHIJKL'
                        },
      'indices'      => _babylonian
      }
    ]

    BabylonianPD = [PatternTableBasedLuniSolar, {
      'label'        => 'AncientOrient::Babylonian',
      'remarks'      => _remarksPD,
      'origin_of_LSC'=> 1492871,
      'origin_of_MSC'=> -625,
      'rule_table'   => _table_PD,
      'indices'      => _babylonian
      }
    ]

    SeleucidPD = [PatternTableBasedLuniSolar, {
      'label'        => 'AncientOrient::Seleucid',
      'remarks'      => _remarksPD,
      'origin_of_LSC'=> 1492871,
      'origin_of_MSC'=> -314,
      'epoch_in_CE'  => -625,
      'rule_table'   => _table_PD,
      'indices'      => _seleucid
      }
    ]
  end

  class TM::CalendarEra

    # 古代オリエント
    AncientOrient = [self, [
      "locale:[=en:, ja=ja:]",
      "area:[AncientOrient=en:Ancient_Orient, 古代オリエント]",
      [self,
	"period:[Neo-Babylonian,新バビロニア]",
	["[Nabopolassar,                              ナボポラッサル                                    ]0",	"@F",	"-0625^BabylonianPD"],
	["[NebuchadnezzarII=en:Nebuchadnezzar_II,     ネブカドネザルII=ja:%%<ネブカドネザル2世>         ]1",	"@A",	"-0603"],
	["[AmelMarduk=en:Amel-Marduk,                 アメル・マルドゥク                                ]1",	"@A",	"-0561"], # 0?
	["[Neriglissar=en:Nergal-sharezer,            ネルガル・シャレゼル                              ]1",	"@A",	"-0559"], # 0?
	["[LabashiMarduk=en:Labashi-Marduk,           ラバシ・マルドゥク                                ]1",	"@A",	"-0555"], # 0?
	["[Nabonidus,                                 ナボニドゥス                                      ]1",	"@A",	"-0554", "-0538.10="]
      ],
      [self,
	"period:[Achaemenid,アケメネス朝]",
	["[CyrusII=en:Cyrus_the_Great,                キュロスII=ja:%%<キュロス2世>                     ]1",	"@F",	"-0549^BabylonianPD"],
	["[CambysesII=en:Cambyses_II,                 カンビュセスII=ja:%%<カンビュセス2世>             ]1",	"@A",	"-0528"],
	["[Bardiya,                                   スメルディス                                      ]1",	"@A",	"-0521"],
	["[DariusI=en:Darius_I,                       ダレイオスI=ja:%%<ダレイオス1世>                  ]1",	"@A",	"-0520"],
	["[XerxesI=en:Xerxes_I_of_Persia,             クセルクセスI=ja:%%<クセルクセス1世>              ]1",	"@A",	"-0484"],
	["[ArtaxerxesI=en:Artaxerxes_I_of_Persia,     アルタクセルクセスI=ja:%%<アルタクセルクセス1世>  ]1",	"@A",	"-0464"], # 0?
	["[XerxesII=en:Xerxes_II_of_Persia,           クセルクセスII=ja:%%<クセルクセス2世>             ]1",	"@A",	"-0423"],
	["[Sogdianus,                                 ソグディアノス                                    ]1",	"@A",	"-0423"],
	["[DariusII=en:Darius_II_of_Persia,           ダレイオスII=ja:%%<ダレイオス2世>                 ]1",	"@A",	"-0422"],
	["[ArtaxerxesII=en:Artaxerxes_II,             アルタクセルクセスII=ja:%%<アルタクセルクセス2世> ]1",	"@A",	"-0403"],
	["[ArtaxerxesIII=en:Artaxerxes_III_of_Persia, アルタクセルクセスIII=ja:%%<アルタクセルクセス3世>]1",	"@A",	"-0357"],
	["[ArtaxerxesIV=en:Arses_of_Persia,           アルセス                                          ]1",	"@A",	"-0337"], # 0?
	["[DariusIII=en:Darius_III_of_Persia,         ダレイオスIII=ja:%%<ダレイオス3世>                ]1",	"@A",	"-0335", "-0329="]
      ]
    ]]
  end
end
