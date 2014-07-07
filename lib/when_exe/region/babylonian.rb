# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When

  class BasicTypes::M17n

    Babylonian = [self, [
      "locale:[=en:, ja=ja:, alias]",
      "names:[Babylonian=]",
      "[Babylonian=en:Babylonian_calendar, バビロニア暦]",
      "[Seleucid=en:Seleucid_era, セレウコス紀元=]",

      # Remarks
      '[based on Chris Bennett "Babylonian and Seleucid Dates" (Retrieved 2014-06-29)=' +
       'http://www.excite-webtl.jp/world/english/web/?wb_url=http%3a%2f%2fsuchowan%2eat%2ewebry%2einfo%2f201407%2farticle_8%2ehtml&wb_lp=JAEN,' +
       '典拠 - Chris Bennett "Babylonian and Seleucid Dates" (2014-06-29 閲覧)=http://suchowan.at.webry.info/201407/article_8.html]',

      [self,
        "names:[IntercalaryMonth=en:Intercalation, 閏月]",
        "[%s I=,  第１=]",
        "[%s II=, 第２=]",
      ],

      [self,
        "names:[BabylonianMonth, 月=ja:%%<月_(暦)>]",
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
        "names:[SeleucidMonth, 月=ja:%%<月_(暦)>]",
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
    #  Babylonian Dates
    #
    # From Chris Bennett, http://www.tyndalehouse.com/Egypt/ptolemies/chron/babylonian/chron_bab_intro_fr.htm
    #

    # Chris Bennett
    _table_CB = %w(							AbCDeFgHIjkL
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

    _table_PD = %w(							AbCDeFgHIjkL
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

    _remarks  = When.M17n('Babylonian::based on Chris Bennett "Babylonian and Seleucid Dates" (Retrieved 2014-06-29)')

    # Chris Bennett
    Babylonian = [PatternTableBasedLuniSolar, {
      'label'        => 'Babylonian::Babylonian',
      'remarks'      => _remarks,
      'origin_of_LSC'=> 1600628,
      'origin_of_MSC'=> -330,
      'rule_table'   => _table_CB,
      'indices'      => [
          When.Index('Babylonian::BabylonianMonth', {:branch=>{1=>When.Resource('_m:Babylonian::IntercalaryMonth::*')[1]}}),
          When::Coordinates::DefaultDayIndex
        ]
      }
    ]

    Seleucid = [PatternTableBasedLuniSolar, {
      'label'        => 'Babylonian::Seleucid',
      'remarks'      => _remarks,
      'origin_of_LSC'=> 1600628,
      'origin_of_MSC'=>  -19,
      'epoch_in_CE'  => -330,
      'rule_table'   => _table_CB,
      'indices'      => [
          When.Index('Babylonian::SeleucidMonth', {:branch=>{1=>When.Resource('_m:Babylonian::IntercalaryMonth::*')[1]}}),
          When::Coordinates::DefaultDayIndex
        ]
      }
    ]

    # R. A. Parker & W. H. Dubberstein
    BabylonianPD = [PatternTableBasedLuniSolar, {
      'label'        => 'Babylonian::Babylonian',
      'remarks'      => _remarks,
      'origin_of_LSC'=> 1600628,
      'origin_of_MSC'=> -330,
      'rule_table'   => _table_PD,
      'indices'      => [
          When.Index('Babylonian::BabylonianMonth', {:branch=>{1=>When.Resource('_m:Babylonian::IntercalaryMonth::*')[1]}}),
          When::Coordinates::DefaultDayIndex
        ]
      }
    ]

    SeleucidPD = [PatternTableBasedLuniSolar, {
      'label'        => 'Babylonian::Seleucid',
      'remarks'      => _remarks,
      'origin_of_LSC'=> 1600628,
      'origin_of_MSC'=>  -19,
      'epoch_in_CE'  => -330,
      'rule_table'   => _table_PD,
      'indices'      => [
          When.Index('Babylonian::SeleucidMonth', {:branch=>{1=>When.Resource('_m:Babylonian::IntercalaryMonth::*')[1]}}),
          When::Coordinates::DefaultDayIndex
        ]
      }
    ]
  end
end
