# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

require 'when_exe/region/chinese'

module When
  module CalendarTypes

    _IndicesM1 = [
      Coordinates::Index.new({:branch=>{1=>When.Resource('_m:CalendarTerms::閏')},
                              :trunk=>When.Resource('_m:ChineseTerms::Month::*')}),
      Coordinates::DefaultDayIndex
    ]

    _IndicesM12 = [
      Coordinates::Index.new({:branch=>{1=>When.Resource('_m:CalendarTerms::閏')},
                              :trunk=>When.Resource('_m:ChineseTerms::Month::*'), :shift=>1}),
      Coordinates::DefaultDayIndex
    ]

    _IndicesM11 = [
      Coordinates::Index.new({:branch=>{1=>When.Resource('_m:CalendarTerms::閏')},
                              :trunk=>When.Resource('_m:ChineseTerms::Month::*'), :shift=>2}),
      Coordinates::DefaultDayIndex
    ]

    # 秦・漢::      顓頊暦  -221 - -162 （冬至を１１月に固定） (歳首 建亥月)
    # 漢::          顓頊暦  -161 - -103 （雨水を１月に固定）   (歳首 建亥月)
    Chinese_221 = [PatternTableBasedLuniSolar, {
      'origin_of_MSC'=>-222, 'origin_of_LSC'=>1640021, 'border'=>'0*10-01',
      'indices'=> _IndicesM1,
      'rule_table'=> %w(
					AbCdEfGhIjKl	ABcDeFgHiJkL	aBcDeFGhIiJkL
	aBcDeFgHiJKl	AbCdEfGhIjKl	ABcDeFgHiIjKl	AbCdEFgHiJkL	aBcDeFgHIiJkL
	aBcDeFgHiJkL	AbCdEfGhIjKl	AbCdEFgHiIjKl	AbCdEfGHiJkL	aBcDeFgHiJkL
	AbCdEfGhIiJkL	aBCdEfGhIjKl	AbCdEfGHiIjKl	AbCdEfGhIjKL	aBcDeFgHiJkL
	aBCdEfGhIiJkL	aBcDeFGhIjKl	AbCdEfGhIJkL	aBcDeFgHiIjKl	ABcDeFgHiJkL

	aBcDeFGhIjKl	AbCdEfGhIIjKl	AbCdEfGhIjKl	ABcDeFgHiIjKl	AbCDeFgHiJkL
	aBcDeFgHIjKl	AbCdEfGhIiJkL	AbCdEfGhIjKl	AbCDeFgHiJkL	aBcDeFgHIiJkL
	aBcDeFgHiJKl	AbCdEfGhIiJkL	aBCdEfGhIjKl	AbCdEfGHiJkL	aBcDeFgHiIJkL
	aBcDeFgHiJkL	aBCdEfGhIjKl	AbCdEFgHiIjKl	AbCdEfGhIJkL	aBcDeFgHiJkL
	aBCdEfGhIiJkL	aBcDEfGhIjKl	AbCdEfGhIIjKl	AbCdEfGhIjKL	aBcDeFgHiJkL
	aBcDEfGhIiJkL	aBcDeFgHIjKl	AbCdEfGhIjKL	aBcDeFgHiIjKl	AbCDeFgHiJkL
	aBcDeFgHIiJkL	aBcDeFgHiJKl	AbCdEfGhIjKl	AbCDeFgHiIjKl	AbCdEFgHiJkL
	aBcDeFgHiJKl	AbCdEfGhIiJkL	aBCdEfGhIjKl	AbCdEFgHiIjKl	AbCdEfGhIJkL
	aBcDeFgHiJkL	AbCdEfGhIiJkL	aBcDEfGhIjKl	AbCdEfGhIJkL	aBcDeFgHiIjKL
	aBcDeFgHiJkL	aBcDEfGhIjKl	AbCdEfGHiIjKl	AbCdEfGhIjKL	aBcDeFgHiIjKl

	AbCDeFgHiJkL	aBcDeFGhIjKl	AbCdEfGhIiJKl	AbCdEfGhIjKl	ABcDeFgHiJkL
	aBcDeFGhIiJkL	aBcDeFgHiJKl	AbCdEfGhIiJkL	AbCdEfGhIjKl	AbCdEFgHiJkL
	aBcDeFgHIiJkL	aBcDeFgHiJkL	AbCdEfGhIjKl	AbCdEFgHiIjKl	AbCdEfGHiJkL
	aBcDeFgHiJkL	AbCdEfGhIiJkL	aBCdEfGhIjKl	AbCdEfGHiIjKl	AbCdEfGhIjKL
	aBcDeFgHiJkL	aBCdEfGhIiJkL	aBcDeFGhIjKl	AbCdEfGhIJkL	aBcDeFgHiIjKl
	ABcDeFgHiJkL	aBcDeFGhIiJkL	aBcDeFgHIjKl	AbCdEfGhIjKl	ABcDeFgHiIjKl
	AbCDeFgHiJkL	aBcDeFgHIjKl	AbCdEfGhIiJkL	AbCdEfGhIjKl	AbCDeFgHiJkL
	aBcDeFgHIiJkL	aBcDeFgHiJKl	AbCdEfGhIiJkL	aBCdEfGhIjKl	AbCdEfGHiJkL
	aBcDeFgHiIJkL	aBcDeFgHiJkL	aBCdEfGhIjKl	AbCdEFgHiIjKl	AbCdEfGhIJkL
	aBcDeFgHiIjKl	ABcdeFgHiJkL	)
      }
    ]

    # 漢・新::       太初暦   -103 -   84
    # 漢・魏::       四分暦     85 -  237
    # 蜀漢::         四分暦    221 -  264
    Chinese_103 = [PatternTableBasedLuniSolar, {
      'origin_of_MSC'=>-103, 'origin_of_LSC'=>1683490,
      'indices'=> _IndicesM1,
      'rule_table'=> %w(
			ABcdeFgHiJkL	aBCdEfGhIjKl	AbCdEfFGhIjKl	AbCdEfGhIJkL

	aBcDeFgHiJkL	aBCcDeFgHiJkL	aBcDEfGhIjKl	AbCdEfGhIJkLl	AbCdEfGhIjKl
	ABcDeFgHiJkL	aBcDEfGhIiJkL	aBcDeFgHIjKl	AbCdEfGhIjKL	aBcDeEfGhIjKl
	AbCDeFgHiJkL	aBcDeFgHIjKl	AaBcDeFgHiJKl	AbCdEfGhIjKl	AbCDeFgHiJjKl
	AbCdEFgHiJkL	aBcDeFgHiJKl	AbCdEfGgHiJkL	aBCdEfGhIjKl	AbCdEFgHiJkL
	aBcCdEfGhIJkL	aBcDeFgHiJkL	AbCdEfGhIjKkL	aBcDEfGhIjKl	AbCdEfGhIJkL
	aBcDeFgHhIjKL	aBcDeFgHiJkL	aBcDEfGhIjKl	AbCdEeFGhIjKl	AbCdEfGhIjKL
	aBcDeFgHiJkL	aAbCDeFgHiJkL	aBcDeFGhIjKl	AbCdEfGhIiJKl	AbCdEfGhIjKl
	ABcDeFgHiJkL	aBcDeFGgHiJkL	aBcDeFgHiJKl	AbCdEfGhIjKl	ABcDdEfGhIjKl
	AbCdEFgHiJkL	aBcDeFgHIjKlL	aBcDeFgHiJkL	AbCdEfGhIjKl	AbCdEFgHhIjKl
	AbCdEfGHiJkL	aBcDeFgHiJkL	AbCdEeFgHiJkL	aBCdEfGhIjKl	AbCdEfGHiJkL

	aBbCdEfGhIjKL	aBcDeFgHiJkL	aBCdEfGhIjJkL	aBcDeFGhIjKl	AbCdEfGhIJkL
	aBcDeFfGhIjKl	ABcDeFgHiJkL	aBcDeFGhIjKl	AbCcDeFgHIjKl	AbCdEfGhIjKl
	ABcDeFgHiJkLl	AbCDeFgHiJkL	aBcDeFgHIjKl	AbCdEfGhHiJkL	AbCdEfGhIjKl
	AbCDeFgHiJkL	aBcDdEfGHiJkL	aBcDeFgHiJKl	AbCdEfGhIjKl	AaBCdEfGhIjKl
	AbCdEfGHiJkL	aBcDeFgHiJJkL	aBcDeFgHiJkL	aBCdEfGhIjKl	AbCdEFfGhIjKl
	AbCdEfGhIJkL	aBcDeFgHiJkL	aBCcDeFgHiJkL	aBcDEfGhIjKl	AbCdEfGhIJkLl
	AbCdEfGhIjKL	aBcDeFgHiJkL	aBcDEfGhIiJkL	aBcDeFgHIjKl	AbCdEfGhIjKL
	aBcDeEfGhIjKl	AbCDeFgHiJkL	aBcDeFGhIjKl	AaBcDeFgHiJKl	AbCdEfGhIjKl
	AbCDeFgHiJjKl	AbCdEFgHiJkL	aBcDeFgHiJKl	AbCdEfGgHiJkL	AbCdEfGhIjKl
	AbCdEFgHiJkL	aBcCdEfGhIJkL	aBcDeFgHiJkL	AbCdEfGhIjKkL	aBcDEfGhIjKl

	AbCdEfGHiJkL	aBcDeFgHhIjKL	aBcDeFgHiJkL	aBcDEfGhIjKl	AbCdEeFGhIjKl
	AbCdEfGhIjKL	aBcDeFgHiJkL	aABcDeFgHiJkL	aBcDeFGhIjKl	AbCdEfGhIiJKl
	AbCdEfGhIjKl	ABcDeFgHiJkL	aBcDeFGgHiJkL	aBcDeFgHIjKl	AbCdEfGhIjKl
	ABcDdEfGhIjKl	AbCdEFgHiJkL	aBcDeFgHIjKlL	aBcDeFgHiJkL	AbCdEfGhIjKl
	AbCDeFgHhIjKl	AbCdEfGHiJkL	aBcDeFgHiJkL	AbCdEeFgHiJkL	aBCdEfGhIjKl
	AbCdEfGHiJkL	aBbCdEfGhIJkL	aBcDeFgHiJkL	aBCdEfGhIjJkL	aBcDeFGhIjKl
	AbCdEfGhIJkL	aBcDeFfGhIjKl	ABcDeFgHiJkL	aBcDEfGhIjKl	AbCcDeFgHIjKl
	AbCdEfGhIjKl	ABcDeFgHiJkLl	AbCDeFgHiJkL	aBcDeFgHIjKl	AbCdEfGhHiJKl
	AbCdEfGhIjKl	AbCDeFgHiJkL	aBcDdEfGHiJkL	aBcDeFgHiJKl	AbCdEfGhIjKl
	AaBCdEfGhIjKl	AbCdEFgHiJkL	aBcDeFgHiJJkL	aBcDeFgHiJkL	aBCdEfGhIjKl

	AbCdEFfGhIjKl	AbCdEfGhIJkL	aBcDeFgHiJkL	AbCcDeFgHiJkL	aBcDEfGhIjKl
	AbCdEfGhIJkLl	AbCdEfGhIjKL	aBcDeFgHiJkL	aBcDEfGhIiJkL	aBcDeFGhIjKl
	AbCdEfGhIjKL	aBcDeEfGhIjKl	AbCDeFgHiJkL	aBcDeFGhIjKl	AaBcDeFgHiJKl
	AbCdEfGhIjKl	ABcDeFgHiJjKl	AbCdEFgHiJkL	aBcDeFgHiJKl	AbCdEfGgHiJkL
	AbCdEfGhIjKl	AbCdEFgHiJkL	aBcCdEfGHiJkL	aBcDeFgHiJkL	AbCdEfGhIjKkL
	aBcDEfGhIjKl	AbCdEfGHiJkL	aBcDeFgHhIjKL	aBcDeFgHiJkL	aBCdEfGhIjKl
	AbCdEeFGhIjKl	AbCdEfGhIjKL	aBcDeFgHiJkL	aABcDeFgHiJkl	AbCdEfGhIjKl
	AbCDeFgHiJjKl	AbCdEfGHiJkL	aBcDeFgHiJKl	AbCdEfGgHiJkL	aBCdEfGhIjKl
	AbCdEFgHiJkL	aBcCdEfGhIJkL	aBcDeFgHiJkL	aBCdEfGhIjKkL	aBcDEfGhIjKl
	AbCdEfGhIJkL	aBcDeFgHhIjKL	aBcDeFgHiJkL	aBcDEfGhIjKl	AbCdEeFgHIjKl

	AbCdEfGhIjKL	aBcDeFgHiJkL	aAbCDeFgHiJkL	aBcDeFGhIjKl	AbCdEfGhIiJKl
	AbCdEfGhIjKl	AbCDeFgHiJkL	aBcDeFGgHiJkL	aBcDeFgHiJKl	AbCdEfGhIjKl
	ABcDdEfGhIjKl	AbCdEFgHiJkL	aBcDeFgHiJKlL	aBcDeFgHiJkL	AbCdEfGhIjKl
	AbCdEFgHhIjKl	AbCdEfGHiJkL	aBcDeFgHiJkL	AbCdEeFgHiJkL	aBcDEfGhIjKl
	AbCdEfGHiJkL	aBbCdEfGhIjKL	aBcDeFgHiJkL	aBCdEfGhIjJkL	aBcDeFGhIjKl
	AbCdEfGhIjKL	aBcDeFfGhIjKl	ABcDeFgHiJkL	aBcDeFGhIjKl	AbCcDeFgHIjKl
	AbCdEfGhIjKl	ABcDeFgHiJkLl	AbCdEFgHiJkL	aBcDeFgHIjKl	AbCdEfGhHiJkL
	AbCdEfGhIjKl	AbCDeFgHiJkL	aBcDdEfGHiJkL	aBcDeFgHiJkL	AbCdEfGhIjKl
	AaBCdEfGhIjKl	AbCdEfGHiJkL	aBcDeFgHiJJkL	aBcDeFgHiJkL	aBCdEfGhIjKl
	AbCdEfFGhIjKl	AbCdEfGhIJkL	aBcDeFgHiJkL	aBCcDeFgHiJkL	aBcDeFGhIjKl

	AbCdEfGhIJkLl	AbCdEfGhIjKl	ABcDeFgHiJkL	aBcDEfGhIiJkL	aBcDeFgHIjKl
	AbCdEfGhIjKl	ABcDeEfGhIjKl	AbCDeFgHiJkL	aBcDeFgHIjKl	AaBcDeFgHiJKl
	AbCdEfGhIjKl	AbCDeFgHiJjKl	AbCdEfGHiJkL	aBcDeFgHiJKl	AbCdEfGgHiJkL
	aBCdEfGhIjKl	AbCdEFgHiJkL	aBcCdEfGhIJkL	aBcDeFgHiJkL	aBCdEfGhIjKkL
	aBcDEfGhIjKl	AbCdEfGhIJkL	aBcDeFgHhIjKL	aBcDeFgHiJkL	aBcDEfGhIjKl
	AbCdEeFgHIjKl	AbCdEfGhIjKL	aBcDeFgHiJkL	aAbCDeFgHiJkL	aBcDeFGhIjKl
	AbCdEfGhIiJKl	AbCdEfGhIjKl	AbCDeFgHiJkL	aBcDeFGgHiJkL	aBcDeFgHiJKl
	AbCdEfGhIjKl	ABcDdEfGhIjKl	AbCdEFgHiJkL	aBcDeFgHiJKlL	aBcDeFgHiJkL
	AbCdEfGhIjKl	AbCdEFgHhIjKl	AbCdEfGHiJkL	aBcDeFgHiJkL	AbCdEeFgHiJkL
	aBcDEfGhIjKl	AbCdEfGHiJkL	aBbCdEfGhIjKL	aBcDeFgHiJkL	aBCdEfGhIjJkL

	aBcDeFGhIjKl	AbCdEfGhIjKL	aBcDeFfGhIjKl	ABcDeFgHiJkL	aBcDeFGhIjKl
	AbCcDeFgHIjKl	AbCdEfGhIjKl	ABcDeFgHiJkLl	AbCdEFgHiJkL	aBcDeFgHIjKl
	AbCdEfGhHiJkL	AbCdEfGhIjKl	AbCDeFgHiJkL	aBcDdEfGHiJkL	aBcDeFgHiJkL
	AbCdEfGhIjKl	AaBCdEfGhIjKl	AbCdEfGHiJkL	aBcDeFgHiJJkL	aBcDeFgHiJkL
	aBCdEfGhIjKl	AbCdEfFGhIjKl	AbCdEfGhIJkL	aBcDeFgHiJkL	aBCcDeFgHiJkL
	aBcDeFGhIjKl	AbCdEfGhIJkLl	AbCdEfGhIjKl	ABcDeFgHiJkL	aBcDEfGhIiJkL
	aBcDeFgHIjKl	AbCdEfGhIjKl	ABcDeEfGhIjKl	AbCDeFgHiJkL	aBcDeFgHIjKl
	AaBcDeFgHiJKl	AbCdEfGhIjKl	AbCDeFgHiJjKl	AbCdEfGHiJkL	aBcDeFgHiJKl
	AbCdEfGgHiJkL	aBCdEfGhIjKl	AbCdEFgHiJkL	aBcCdEfGhIJkL	aBcDeFgHiJkL
	aBCdEfGhIjKkL	aBcDEfGhIjKl	AbCdEfGhIJkL	aBcDeFgHhIjKL	aBcDeFgHiJkL

	aBcDEfGhIjKl	AbCdEeFgHIjKl	AbCdEfGhIjKL	aBcDeFgHiJkL	aAbCDeFgHiJkL
	aBcDeFGhIjKl	AbCdEfGhIiJKl	AbCdEfGhIjKl	AbCDeFgHiJkL	aBcDeFGgHiJkL
	aBcDeFgHiJKl	AbCdEfGhIjKl	ABcDdEfGhIjKl	AbCdEFgHiJkL	)
      }
    ]

    # 新::           太初暦      7 -   23 (歳首 建丑月)
    Chinese0008 = [PatternTableBasedLuniSolar, {
      'origin_of_MSC'=>7, 'origin_of_LSC'=>1723652, 'border'=>'0*12-01',
      'indices'=> _IndicesM12,
      'rule_table'=> %w(
        		aBcDeFgHiJkL	aABcDeFgHiJkL	aBcDeFGhIjKl	AbCdEfGhIiJKl
	AbCdEfGhIjKl	ABcDeFgHiJkL	aBcDeFGgHiJkL	aBcDeFgHIjKl	AbCdEfGhIjKl
	ABcDdEfGhIjKl	AbCdEFgHiJkL	aBcDeFgHIjKlL	aBcDeFgHiJkL	AbCdEfGhIjKl
	AbCDeFgHhIjKl	AbCdEfGHiJkL	aBcDeFgHiJkL	)
      }
    ]

    # 呉::           四分暦    222
    # 呉::           乾象暦    223 - 280
    Chinese0223 = [PatternTableBasedLuniSolar, {
      'origin_of_MSC'=>222, 'origin_of_LSC'=>1802173,
      'indices'=> _IndicesM1,
      'rule_table'=> %w(
			AbCdEfFGhIjKl	aBcDeFgHiJKl	AbCdEfGhIjKl	ABcDdEfGhIjKl
	AbCdEFgHiJkL	aBcDeFgHiJKlL	aBcDeFgHiJkL	aBCdEfGhIjKl	AbCdEFgHhIjKl
	AbCdEfGhIJkL	aBcDeFgHiJkL	aBCdEeFgHiJkL	aBcDEfGhIjKl	AbCdEfGhIJkL
	aBbCdEfGhIjKl	ABcDeFgHiJkL	aBcDEfGhIjJkL	aBcDeFgHIjKl	AbCdEfGhIjKl
	ABcDeFfGhIjKl	AbCDeFgHiJkL	aBcDeFgHIjKl	AbCcDeFgHiJKl	AbCdEfGhIjKl
	AbCDeFgHiJkLl	AbCdEfGhIJkL	aBcDeFgHiJkL	AbCdEfGhHiJkL	aBCdEfGhIjKl

	AbCdEfGHiJkL	aBcDdEfGhIjKL	aBcDeFgHiJkL	aBcDEfGhIjKl	AaBcDeFGhIjKl
	AbCdEfGhIjKL	aBcDeFgHiJjKl	AbCDeFgHiJkL	aBcDeFGhIjKl	AbCdEfGgHiJKl
	AbCdEfGhIjKl	AbCDeFgHiJkL	aBcCdEFgHiJkL	aBcDeFgHiJKl	AbCdEfGhIjKkL
	aBCdEfGhIjKl	AbCdEFgHiJkL	aBcDeFgHhIJkL	aBcDeFgHiJkL	aBCdEfGhIjKl
	AbCdEEfGhIjKl	AbCdEfGhIJkL	aBcDeFgHiJkL	aABcDeFgHiJkL	aBcDeFGhIjKl
	AbCdEfGhIJjKl	AbCdEfGhIjKl	ABcDeFgHiJkL	aBcDeFGgHiJkL	aBcDeFgHiJKl	)
      }
    ]

    # 魏::           四分暦    236
    # 魏::           景初暦    237 - 239 (歳首 建丑月)
    Chinese0237 = [PatternTableBasedLuniSolar, {
      'origin_of_MSC'=>236, 'origin_of_LSC'=>1807282, 'border'=>'0*12-01',
      'indices'=> _IndicesM12,
      'rule_table'=> %w(AaBcDeFgHiJKl	AbCdeFgHiJkL	aBcDeFGhIjJkL	aBcDeFgHiJKl)
      }
    ]

    # 魏・晋・宋::   景初暦    239  - 444 （泰始・永初暦も同じもの）
    # 及び十六国
    # 北魏::         景初暦    386? - 451
    Chinese0239 = [PatternTableBasedLuniSolar, {
      'origin_of_MSC'=>239, 'origin_of_LSC'=>1808404,
      'indices'=> _IndicesM1,
      'rule_table'=> %w(
        						aBcDeFgHiJKl	AbCdEfGhIjKl
	AbCDeFfGhIjKl	AbCdEFgHiJkL	aBcDeFgHiJKl	AbCcDeFgHiJkL	aBCdEfGhIjKl
	AbCdEFgHiJkLl	AbCdEfGhIJkL	aBcDeFgHiJkL	aBCdEfGhIiJkL	aBcDeFGhIjKl

	AbCdEfGhIJkL	aBcDeEfGhIjKl	ABcDeFgHiJkL	aBcDeFGhIjKl	AaBcDeFgHIjKl
	AbCdEfGhIjKl	ABcDeFgHiJjKl	AbCdEFgHiJkL	aBcDeFgHIjKl	AbCdEfGgHiJkL
	AbCdEfGhIjKl	AbCdEFgHiJkL	aBcCdEfGHiJkL	aBcDeFgHiJkL	AbCdEfGhIjKkL
	aBcDEfGhIjKl	AbCdEfGHiJkL	aBcDeFgHhIjKL	aBcDeFgHiJkL	aBcDEfGhIjKl
	AbCdEeFGhIjKl	AbCdEfGhIjKL	aBcDeFgHiJkL	aAbCDeFgHiJkL	aBcDeFGhIjKl
	AbCdEfGhIiJKl	AbCdEfGhIjKl	ABcDeFgHiJkL	aBcDeFGgHiJkL	aBcDeFgHiJKl
	AbCdEfGhIjKl	AbCDdEfGhIjKl	AbCdEFgHiJkL	aBcDeFgHiJKlL	aBcDeFgHiJkL
	aBCdEfGhIjKl	AbCdEFgHhIjKl	AbCdEfGhIJkL	aBcDeFgHiJkL	aBCdEeFgHiJkL
	aBcDEfGhIjKl	AbCdEfGhIJkL	aBbCdEfGhIjKl	ABcDeFgHiJkL	aBcDEfGhIjJkL
	aBcDeFgHIjKl	AbCdEfGhIjKl	ABcDeFfGhIjKl	AbCDeFgHiJkL	aBcDeFgHIjKl

	AbCcDeFgHiJkL	AbCdEfGhIjKl	AbCDeFgHiJkLl	AbCdEfGHiJkL	aBcDeFgHiJkL
	AbCdEfGhHiJkL	aBCdEfGhIjKl	AbCdEfGHiJkL	aBcDdEfGhIjKL	aBcDeFgHiJkL
	aBCdEfGhIjKl	AaBcDeFGhIjKl	AbCdEfGhIjKl	AbCDeFgHiJjKl	ABcDeFgHiJkL
	aBcDeFGhIjKl	AbCdEfGgHiJKl	AbCdEfGhIjKl	ABcDeFgHiJkL	aBcCdEFgHiJkL
	aBcDeFgHiJKl	AbCdEfGhIjKkL	AbCdEfGhIjKl	AbCdEFgHiJkL	aBcDeFgHhIJkL
	aBcDeFgHiJkL	AbCdEfGhIjKl	AbCdEEfGhIjKl	AbCdEfGhIJkL	aBcDeFgHiJkL
	AaBcDeFgHiJkL	aBcDEfGhIjKl	AbCdEfGhIJjKl	AbCdEfGhIjKL	aBcDeFgHiJkL
	aBcDEfGgHiJkL	aBcDeFgHIjKl	AbCdEfGhIjKL	aBcDdEfGhIjKl	AbCDeFgHiJkL
	aBcDeFgHIjKlL	aBcDeFgHiJKl	AbCdEfGhIjKl	AbCDeFgHhIjKl	AbCdEfGHiJkL
	aBcDeFgHiJKl	AbCdEeFgHiJkL	aBCdEfGhIjKl	AbCdEfGHiJkL	aBbCdEfGhIJkL

	aBcDeFgHiJkL	aBCdEfGhIjJkL	aBcDeFGhIjKl	AbCdEfGhIJkL	aBcDeFfGhIjKl
	ABcDeFgHiJkL	aBcDeFGhIjKl	AbCcDeFgHIjKl	AbCdEfGhIjKl	ABcDeFgHiJkLl
	AbCdEFgHiJkL	aBcDeFgHIjKl	AbCdEfGhHiJkL	AbCdEfGhIjKl	AbCdEFgHiJkL
	aBcDdEfGHiJkL	aBcDeFgHiJkL	AbCdEfGhIjKl	AaBcDEfGhIjKl	AbCdEfGhIJkL
	aBcDeFgHiJjKL	aBcDeFgHiJkL	aBcDEfGhIjKl	AbCdEfGgHIjKl	AbCdEfGhIjKL
	aBcDeFgHiJkL	aBcCDeFgHiJkL	aBcDeFgHIjKl	AbCdEfGhIjKLl	AbCdEfGhIjKl
	AbCDeFgHiJkL	aBcDeFgHIiJkL	aBcDeFgHiJKl	AbCdEfGhIjKl	AbCDeEfGhIjKl
	AbCdEfGHiJkL	aBcDeFgHiJKl	AaBcDeFgHiJkL	aBCdEfGhIjKl	AbCdEfGHiJjKl
	AbCdEfGhIJkL	aBcDeFgHiJkL	aBCdEfGgHiJkL	aBcDeFGhIjKl	AbCdEfGhIJkL
	aBcCdEfGhIjKl	ABcDeFgHiJkL	aBcDeFGhIjKkL	aBcDeFgHIjKl	AbCdEfGhIjKl

	ABcDeFgHhIjKl	AbCdEFgHiJkL	aBcDeFgHIjKl	AbCdEeFgHiJkL	AbCdEfGhIjKl
	AbCdEFgHiJkL	aBbCdEfGHiJkL	aBcDeFgHiJkL	AbCdEfGhIjJkL	aBcDEfGhIjKl
	AbCdEfGHiJkL	aBcDeFfGhIjKL	aBcDeFgHiJkL	aBcDEfGhIjKl	AbCcDeFGhIjKl
	AbCdEfGhIjKL	aBcDeFgHiJkLl	AbCDeFgHiJkL	aBcDeFGhIjKl	AbCdEfGhHiJKl
	AbCdEfGhIjKl	AbCDeFgHiJkL	aBcDdEFgHiJkL	aBcDeFgHiJKl	AbCdEfGhIjKl
	AaBCdEfGhIjKl	AbCdEFgHiJkL	aBcDeFgHiJJkL	aBcDeFgHiJkL	AbCdEfGhIjKl
	AbCdEFfGhIjKl	AbCdEfGhIJkL	aBcDeFgHiJkL	aBCcDeFgHiJkL	aBcDEfGhIjKl
	AbCdEfGhIJkLl	AbCdEfGhIjKl	ABcDeFgHiJkL	aBcDEfGhIiJkL	aBcDeFgHIjKl
	AbCdEfGhIjKl	ABcDeEfGhIjKl	AbCDeFgHiJkL	aBcDeFgHIjKl	AaBcDeFgHiJkL
	AbCdEfGhIjKl	AbCDeFgHiJJkl	AbCdEfGHiJkL	aBcDeFgHiJkL	AbCdEfGgHiJkL

	aBCdEfGhIjKl)
      }
    ]

    # 宋・斉・梁::   元嘉暦    445 -  509 （建元暦も同じもの）
    # 梁・陳::       大明暦    510 -  589
    # 及び後梁
    Chinese0445 = [PatternTableBasedLuniSolar, {
      'origin_of_MSC'=>445, 'origin_of_LSC'=>1883618,
      'indices'=> _IndicesM1,
      'rule_table'=> %w(
									AbCdEeFgHiJkL
	AbCdEfGhIjKl	AbCDeFgHiJkL	aBbCdEfGHiJkL	aBcDeFgHiJkL	AbCdEfGhIjJkL

	aBCdEfGhIjKl	AbCdEfGHiJkL	aBcDeFfGhIjKL	aBcDeFgHiJkL	aBCdEfGhIjKl
	AbCcDeFGhIjKl	AbCdEfGhIjKL	aBcDeFgHiJkLl	AbCDeFgHiJkL	aBcDeFGhIjKl
	AbCdEfGhIiJKl	AbCdEfGhIjKl	AbCDeFgHiJkL	aBcDeEFgHiJkL	aBcDeFgHiJKl
	AbCdEfGhIjKl	AaBCdEfGhIjKl	AbCdEFgHiJkL	aBcDeFgHiJKkL	aBcDeFgHiJkL
	aBCdEfGhIjKl	AbCdEFgGhIjKl	AbCdEfGhIJkL	aBcDeFgHiJkL	aBCcDeFgHiJkL
	aBcDEfGhIjKl	AbCdEfGhIJkLl	AbCdEfGhIjKl	ABcDeFgHiJkL	aBcDEfGhIiJkL
	aBcDeFgHIjKl	AbCdEfGhIjKl	ABcDeEfGhIjKl	AbCDeFgHiJkL	aBcDeFgHIjKl
	AaBcDeFgHiJkL	AbCdEfGhIjKl	AbCDeFgHiJjKl	AbCdEfGHiJkL	aBcDeFgHiJkL
	AbCdEfGgHiJkL	aBCdEfGhIjKl	AbCdEfGHiJkL	aBcDdEfGhIjKL	aBcDeFgHiJkL
	aBCdEfGhIjKlL	aBcDeFGhIjKl	AbCdEfGhIjKL	aBcDeFgHhIjKl	ABcDeFgHiJkL

	aBcDeFGhIjKl	AbCdDeFgHiJKl	AbCdEfGhIjKl	ABcDeFgHiJkL	aBbCdEFgHiJkL
	aBcDeFgHiJKl	AbCdEfGhIjJkL	AbCdEfGhIjKl	AbCdEFgHiJkL	aBcDeFfGhIJkL
	aBcDeFgHiJkL	AbCdEfGhIjKl	AbCcDEfGhIjKl	AbCdEfGhIJkL	aBcDeFgHiJkLl
	ABcDeFgHiJkL	aBcDEfGhIjKl	AbCdEfGhHIjKl	AbCdEfGhIjKl	ABcDeFgHiJkL
	aBcDEeFgHiJkL	aBcDeFgHIjKl	AbCdEfGhIjKl	ABbCdEfGhIjKl	AbCDeFgHiJkL
	aBcDeFgHIjJkL	aBcDeFgHiJkL	AbCdEfGhIjKl	AbCDeFfGhIjKl	AbCdEfGHiJkL
	aBcDeFgHiJkL	AbCcDeFgHiJkL	aBCdEfGhIjKl	AbCdEfGHiJkLl	AbCdEfGhIjKL
	aBcDeFgHiJkL	aBCdEfGhIiJkL	aBcDeFGhIjKl	AbCdEfGhIjKL	aBcDeEfGhIjKl
	ABcDeFgHiJkL	aBcDeFGhIjKl	AaBcDeFgHiJKl	AbCdEfGhIjKl	ABcDeFgHiJjKl
	AbCdEFgHiJkL	aBcDeFgHiJKl	AbCdEfGgHiJkL	AbCdEfGhIjKl	AbCdEFgHiJkL

	aBcCdEfGhIJkL	aBcDeFgHiJkL	AbCdEfGhIjKkL	aBcDEfGhIjKl	AbCdEfGhIJkL
	aBcDeFgHhIjKL	aBcDeFgHiJkL	aBcDEfGhIjKl	AbCdDeFgHIjKl	AbCdEfGhIjKL
	aBcDeFgHiJkL	aBbCDeFgHiJkL	aBcDeFgHIjKl	AbCdEfGhIjJKl	AbCdEfGhIjKl
	AbCDeFgHiJkL	aBcDeFfGHiJkL	aBcDeFgHiJKl	AbCdEfGhIjKl	AbCDdEfGhIjKl
	AbCdEfGHiJkL	aBcDeFgHiJKlL	aBcDeFgHiJkL	aBCdEfGhIjKl	AbCdEfGHiIjKl
	AbCdEfGhIJkL	aBcDeFgHiJkL	aBCdEeFgHiJkL	aBcDeFGhIjKl	AbCdEfGhIJkL
	aBbCdEfGhIjKl	ABcDeFgHiJkL	aBcDeFGhIjKkL	aBcDeFgHIjKl	AbCdEfGhIjKl
	ABcDeFgGhIjKl	AbCdEFgHiJkL	aBcDeFgHIjKl	AbCdDEfGhIjKl	)
      }
    ]

    # 後秦::         三紀暦    384 - 417
    Chinese0384 = [PatternTableBasedLuniSolar, {
      'origin_of_MSC'=>384, 'origin_of_LSC'=>1861352,
      'indices'=> _IndicesM1,
      'rule_table'=> %w(
							AbCdEfGhIjKl	AbCDeEfGhIjKl
	AbCdEfGHiJkL	aBcDeFgHiJkL	AaBcDeFgHiJkL	aBCdEfGhIjKl	AbCdEfGHiJjKl
	AbCdEfGhIjKL	aBcDeFgHiJkL	aBCdEfGgHiJkL	aBcDeFGhIjKl	AbCdEfGhIjKL
	aBcCdEfGhIjKl	ABcDeFgHiJkL	aBcDeFGhIjKkL	aBcDeFgHiJKl	AbCdEfGhIjKl

	ABcDeFgHhIjKl	AbCdEFgHiJkL	aBcDeFgHiJKl	AbCdEeFgHiJkL	AbCdEfGhIjKl
	AbCdEFgHiJkL	aBbCdEfGhIJkL	aBcDeFgHiJkL	AbCdEfGhIjJkL	aBcDEfGhIjKl
	AbCdEfGhIJkL	aBcDeFfGhIjKL	aBcDeFgHiJkL	aBcDEfGhIjKl	AbCcDeFgHIjKl
	AbCdEfGhIjKL	aBcDeFgHiJkLl	)
      }
    ]

    # 北涼::         玄始暦    412 - 439
    # 北魏::         玄始暦    452 - 522
    Chinese0412 = [PatternTableBasedLuniSolar, {
      'origin_of_MSC'=>412, 'origin_of_LSC'=>1871570,
      'indices'=> _IndicesM1,
      'rule_table'=> %w(
			aBcDeFgHhIjKL	aBcDeFgHiJkL	aBcDEfGhIjKl	AbCdEeFgHIjKl
	AbCdEfGhIjKL	aBcDeFgHiJkL	aBbCDeFgHiJkL	aBcDeFgHIjKl	AbCdEfGhIjKKl
	AbCdEfGhIjKl	AbCDeFgHiJkL	aBcDeFgGHiJkL	aBcDeFgHiJKl	AbCdEfGhIjKl
	AbCDdEfGhIjKl	AbCdEfGHiJkL	aBcDeFgHiJKl	AaBcDeFgHiJkL	aBCdEfGhIjKl
	AbCdEfGHiIjKl	AbCdEfGhIJkL	aBcDeFgHiJkL	aBCdEeFgHiJkL	aBcDeFGhIjKl
	AbCdEfGhIJkL	aBbCdEfGhIjKl	ABcDeFgHiJkL	aBcDeFGhIjKkL	aBcDeFgHIjKl
	AbCdEfGhIjKl	ABcDeFgHhIjKl	AbCdEFgHiJkL	aBcDeFgHIjKl	AbCdDeFgHiJkL
	AbCdEfGhIjKl	AbCdEFgHiJkLl	AbCdEfGHiJkL	aBcDeFgHiJkL	AbCdEfGhIiJkL

	aBcDEfGhIjKl	AbCdEfGHiJkL	aBcDeFfGhIjKL	aBcDeFgHiJkL	aBcDEfGhIjKl
	AbBcDeFGhIjKl	AbCdEfGhIjKL	aBcDeFgHiJjKl	AbCDeFgHiJkL	aBcDeFGhIjKl
	AbCdEfGgHiJKl	AbCdEfGhIjKl	AbCDeFgHiJkL	aBcDdEFgHiJkL	aBcDeFgHiJKl
	AbCdEfGhIjKl	AaBCdEfGhIjKl	AbCdEFgHiJkL	aBcDeFgHiIJkL	aBcDeFgHiJkL
	aBCdEfGhIjKl	AbCdEFfGhIjKl	AbCdEfGhIJkL	aBcDeFgHiJkL	aBCcDeFgHiJkL
	aBcDEfGhIjKl	AbCdEfGhIJkKl	AbCdEfGhIjKl	ABcDeFgHiJkL	aBcDEfGgHiJkL
	aBcDeFgHIjKl	AbCdEfGhIjKl	ABcDdEfGhIjKl	AbCDeFgHiJkL	aBcDeFgHIjKl
	AaBcDeFgHiJkL	AbCdEfGhIjKl	AbCDeFgHiIjKl	AbCdEfGHiJkL	aBcDeFgHiJkL
	AbCdEeFgHiJkL	aBCdEfGhIjKl	AbCdEfGHiJkL	aBbCdEfGhIjKL	aBcDeFgHiJkL
	aBCdEfGhIjKkL	aBcDeFGhIjKl	AbCdEfGhIjKL	aBcDeFgHhIjKl	ABcDeFgHiJkL

	aBcDeFGhIjKl	AbCdDeFgHiJKl	AbCdEfGhIjKl	ABcDeFgHiJkLl	AbCdEFgHiJkL
	aBcDeFgHiJKl	AbCdEfGhIiJkL	AbCdEfGhIjKl	AbCdEFgHiJkL	aBcDeFfGhIJkL
	aBcDeFgHiJkL	AbCdEfGhIjKl	AbBcDEfGhIjKl	AbCdEfGhIJkL	aBcDeFgHiJjKl
	ABcDeFgHiJkL	aBcDEfGhIjKl	AbCdEfGgHIjKl	AbCdEfGhIjKl	ABcDeFgHiJkL
	aBcDEeFgHiJkL	aBcDeFgHIjKl	)
      }
    ]

    # 東魏・北斉::   興和暦    540 - 550
    # 北斉::         天保暦    551 - 577
    Chinese0540 = [PatternTableBasedLuniSolar, {
      'origin_of_MSC'=>540, 'origin_of_LSC'=>1918317,
      'indices'=> _IndicesM1,
      'rule_table'=> %w(
									aBcDeEfGhIjKl
	ABcDeFgHiJkL	aBcDeFGhIjKl	AaBcDeFgHIjKl	AbCdEfGhIjKl	ABcDeFgHiJjKl
	AbCdEFgHiJkL	aBcDeFgHIjKl	AbCdEfGgHiJkL	AbCdEfGhIjKl	AbCdEFgHiJkL

	aBbCdEfGhIJkL	aBcDeFgHiJkL	AbCdEfGhIjKkL	aBcDEfGhIjKl	AbCdEfGhIJkL
	aBcDeFgHhIjKL	aBcDeFgHiJkL	aBcDEfGhIjKl	AbCdDeFgHIjKl	AbCdEfGhIjKL
	aBcDeFgHiJkLl	AbCDeFgHiJkL	aBcDeFgHIjKl	AbCdEfGhIjJKl	AbCdEfGhIjKl
	AbCDeFgHiJkL	aBcDeFfGHiJkL	aBcDeFgHiJKl	AbCdEfGhIjKl	AbBCdEfGhIjKl
	AbCdEfGHiJkL	aBcDeFgHiJKkL	aBcDeFgHiJkL	aBCdEfGhIjKl	AbCdEfGHhIjKl
	AbCdEfGhIJkL	aBcDeFgHiJkL	)
      }
    ]

    # 北魏・西魏::   正光暦    523 -  565
    # 及び北周
    # 東魏::         正光暦    534 -  539
    # 北周::         天和暦    566 -  578
    # 北周・隋::     大象暦    579 -  583
    # 隋::           開皇暦    584 -  596
    # 隋・唐::       大業暦    597 -  618
    # 唐::           戊寅暦    619 -  664
    # 唐・周::       麟徳暦    665 -  728 総法 1340(小余の分母)
    # 唐::           大衍暦    729 -  761 通法 3040(    〃    )
    # 唐::           五紀暦    762 -  783 通法 1340(    〃    )
    # 唐::           正元暦    784 -  806
    # 唐::           観象暦    807 -  821
    # 唐::           宣明暦    822 -  892 統法 8400(    〃    )
    # 唐～後晋::     崇玄暦    893 -  938
    # (後晋::        調元暦    939 -  943)
    # (後晋::        調元暦?   944 -  946)
    Chinese0523 = [PatternTableBasedLuniSolar, {
      'origin_of_MSC'=>523, 'origin_of_LSC'=>1912115,
      'indices'=> _IndicesM1,
      'rule_table'=> %w(
        				AbCdEfGhIjKL	aBbCdEfGhIjKl	AbCDeFgHiJkL
	aBcDeFgHIjKkL	aBcDeFgHiJKl	AbCdEfGhIjKl	AbCDeFgGhIjKl	AbCdEfGHiJkL
	aBcDeFgHiJKl	AbCcDeFgHiJkL	aBCdEfGhIjKl	AbCdEfGHiJkLl	AbCdEfGhIJkL
	aBcDeFgHiJkL	aBCdEfGhIiJkL	aBcDeFGhIjKl	AbCdEfGhIJkL	aBcDeEfGhIjKl
	ABcDeFgHiJkL	aBcDeFGhIjKl	AaBcDeFgHIjKl	AbCdEfGhIjKl	ABcDeFgHiJjKl
	AbCdEFgHiJkL	aBcDeFgHIjKl	AbCdEfGgHiJkL	AbCdEfGhIjKl	AbCdEFgHiJkL

	aBcDdEfGHiJkL	aBcDeFgHiJkL	AbCdEfGhIjKlL	aBcDEfGhIjKl	AbCdEfGHiJkL
	aBcDeFgHhIjKL	aBcDeFgHiJkL	aBcDEfGhIjKl	AbCdEeFGhIjKl	AbCdEfGhIjKL
	aBcDeFgHiJkL	aAbCDeFgHiJkL	aBcDeFGhIjKl	AbCdEfGhIiJKl	AbCdEfGhIjKL
	aBcDeFgHiJkL	AbCdEfGhHiJkL	aBCdEfGhIjKl	AbCdEfGHiJkL	aBcDdEfGhIjKL
	aBcDeFgHiJkL	aBCdEfGhIjKl	AaBcDeFGhIjKl	AbCdEfGhIJkL	aBcDeFgHiJjKl
	ABcDeFgHiJkL	aBcDeFGhIjKl	AbCdEfFgHIjKl	AbCdEfGhIJkL	aBcDeFgHiJkL
	AbCcDeFgHiJkL	aBcDEfGhIjKl	AbCdEfGhIJkLl	aBCdEfGhIjKl	AbCdEFgHiJkL
	aBcDeFgHhIJkL	aBcDeFgHiJkL	aBCdEfGhIjKl	AbCdDEfGhIjKl	AbCdEfGhIJkL
	aBcDeFgHiJkLl	ABcDeFgHiJkL	aBcDEfGhIjKl	AbCdEfGhIJjKl	AbCdEfGhIjKl
	ABcDeFgHiJkL	aBcDeEfGhIJkL	aBcDeFgHiJkL	aBCdEfGhIjKl	AaBcDeFGhIjKl

	AbCdEfGhIJkL	aBcDeFgHiJjKl	ABcDeFgHiJkL	aBcDeFGhIjKl	AbCdEfGgHIjKl
	AbCdEfGhIjKl	ABcDeFgHiJkL	aBcCdEFgHiJkL	aBcDeFgHIjKl	AbCdEfGhIjKkL
	AbCdEfGhIjKl	AbCdEFgHiJkL	aBcDeFgHIiJkL	aBcDeFgHiJkL	AbCdEfGhIjKl
	AbCdEEfGhIjKl	AbCdEfGHiJkL	aBcDeFgHiJkL	ABbcdEfGhIJKl	AbCdeFgHiJkL
	ABcDefGhIjJkL	AbCDefGhIjKl	ABcDeFgHiJkL	aBcDeFGgHiJkL	aBcDeFgHIjKl
	AbCdeFgHIJkL	aBccDeFgHIjKL	aBcdEfgHIjKL	AbCdEfghIJkLL	AbCdeFgHiJkL
	AbCdEfGhIjKl	AbCDeFgHhIjKl	AbCdEFgHiJkL	aBcdEFgHIjKl	AbCddEfGHIjKl
	AbCdeFgHiJKL	aBcDefGhIjKL	AbBcdEfgHiJKL	aBCdeFghIjKL	aBCdEfGhIjJkL
	aBcDEfGhIjKl	AbCdEfGHiJkL	aBcdEfFGhIJKl	aBcdEfGhIJKl	aBcDeFGhIjKl
	AbCcDeFgHiJKl	AbCdEfGhIjKl	AbCDeFgHiJkLl	AbCdEFgHiJkL	aBcDeFgHiJKl

	AbCdEfGhIiJkL	aBCdEfGhIjKl	AbCdEFgHiJkL	aBcDeEfGhIJkL	aBcDeFgHiJkL
	aBCdEfGhIjKl	AaBcDEfGhIjKl	AbCdEfGhIJkL	aBcDeFgHiJjKl	ABcDeFgHiJkL
	aBcDEfGhIjKl	AbCdEfGgHIjKl	AbCdEfGhIjKl	ABcDeFgHiJkL	aBcCDeFgHiJkL
	AbCdEfgHiJkL	AbCDeFghIjKlL	aBCdEfGhIjKl	AbCdEfGHiJKl	aBcDeFgHIiJKl
	aBcdEfGHiJKL	aBcdeFgHiJKL	aBcDeeFgHiJKL	aBcDefGhIjKL	aBCdEfgHiJkL
	aBCcDeFgHiJkL	aBcDEfGhIjKl	AbCdEfGHiJkKl	AbcDeFGhIJkL	aBcdEfGhIJKl
	AbCdeFgGhIJKl	AbCdeFghIJkL	ABcDefGhiJKL	aBcDEefGhIjKl	AbCDeFgHiJkL
	aBcDeFGhIjKl	AaBcDeFgHIjKl	AbcDeFgHIJkL	aBcdEfGhIIJkL	aBcdEfgHIjKL
	AbCdeFghIJkL	ABcDeeFghIJkL	AbCdEfGhIjKl	AbCDeFgHiJkL	aBbCdEFgHiJkL
	abCdEFgHIjKl	AbcDeFgHIJJkl	AbcDeFgHiJKL	aBcdEfgHIjKL	AbCdeFggHiJKL

	aBCdeFghIjKL	aBCdEfGhIjkL	AbCdDEfGhIjKl	aBCdEfGHiJkL	abCdEfGHiJKl
	AabCdEfGHiJKl	AbcDefGHiJKL	aBcdEfgHIiJKL	aBcdEfGhiJKL	aBCdEfgHiJkL
	aBCdEfFgHijKL	aBcDEfGhIjKl	aBCdEfGhIJkL	aBbcDeFGhIJkL	aBcdEfGhIJKl
	AbCdeFgHiJKlL	AbcDefGhIJkL	ABcdEfGhiJKL	aBcDeFggHiJkL	AbCDeFghIjKl
	AbCDEfgHIjkL	aBcDEeFGhIjKl	AbcDeFGhIJkL	abCdeFGhIJKlL	aBcdEfgHIJkL
	AbCdefGhIJkL	AbCDefGhiIJkL	aBCdEfgHiJkL	AbCdEfGhIjKl	AbCdEFfGhIjKl
	AbCdEfGHiJKl	aBcDeFgHIjKL	aBccDefGHiJKL	abCdeFgHiJKL	aBcDefGhIjKKl
	ABcDefGhIjKl	ABCdEfGhiJkL	aBCdEFgHhiJkL	aBcDEfGhIjKl	AbCdEfGHiJkL
	AbcDdEfGHiJKl	AbcDefGHiJKl	ABcdEfgHiJKL	aBBcdEfgHiJKl	ABcDeFghIjKl
	ABCdEfGhiJjKl	ABcDeFgHiJkL	aBcDEfGhIjKl	AbCdEfFgHIjKl	AbCdeFGhIJKl

	AbcDefGhIJKl	AbCcdEfGhIJkL	AbCdeFgHiJkL	ABcDefGhIjKkL	aBCdEfGhIjKl
	AbCDeFgHiJkL	aBcDeFGhHiJkL	aBcDeFgHIJkL	abCdeFgHIJkL	AbcDdeFgHIjKL
	aBcDefGhIJkL	AbCdEfgHiJkL	AaBCdEfgHiJkL	AbCdEfGhIjKl	AbCDeFgHiJjKl
	AbCdEfGHiJkL	aBcdEfGHIjKl	AbCdeFfGHiJKl	AbCdefGHiJKL	aBcDefGhiJKL
	aBCcdEfgHiJKL	aBcDeFgHijKL	aBCdEfGhIjKkl	ABcDEfGhIjKl	AbcDEfGHiJkL
	abCdEfGHhIJkL	aBcdEfGhIJKl	AbCdeFgHiJKl	ABcDeefGHiJKL	aBcdEfgHiJKl
	ABcDeFghIjKL	aAbCDeFgHijKl	ABcDeFGhIjKl	aBcDeFGhIJjKl	aBcDeFgHIJkL
	abCdeFgHIJkL	AbCdeeFgHIJkL	AbcDefGhIJkL	AbCdEfgHiJkL	ABcDdEfgHiJkL
	AbCdEFgHijKl	AbCDeFgHIjKll	AbCdEfGHIjKl	aBcDeFgHIjKL	aBcdEfgHHiJKL
	aBcdeFgHiJKL	aBcDefGhIjKL	AbCdEefGhIjKL	aBCdEfgHiJkL	aBCdEfGhIjKl

	AaBcDEfGhIjKl	AbCdEfGHiJKl	aBcdEfGHiJJKl	aBcdEfGhIJKl	AbCdeFgHiJKL
	aBcDefFgHiJKl	ABcDefGhIjKl	ABCdEfGhiJkL	aBCcDeFgHiJkL	aBcDEfGhIJkl
	AbCdEfGHiJKlL	abcDeFGhIJKl	AbcdEfGhIJKl	ABcdeFgHhIJKl	AbCdEfgHiJKl
	ABcDeFghIjKl	ABcDEefGhIjKl	AbCDeFgHiJkL	aBcDeFGhIjKl	AaBcDeFgHIjKl
	AbCdeFgHIJkL	AbcDefGhIJjKL	aBcDefGhIjKL	AbCdEfghIJkL	ABcDeFggHiJkL
	AbCDefGhIjKl	AbCDeFgHiJkL	aBcCdEFgHiJkL	aBcdEFgHIjKl	AbCdeFgHIjKLl
	AbCdeFgHiJKL	aBcDefGhIjKL	AbCdEfggHiJKL	aBCdeFgHijKL	aBCdEfGhIjKl
	AbCdEeFGhIjKl	AbCdEfGHiJkL	aBcdEfGHiJKl	AaBcdEfGhIJKl	AbCdeFgHiJKL
	aBcDefgHiIJKl	ABcDefgHiJkL	ABcDeFgHijKL	aBCdEfGgHijKL	aBcDeFGhIjKl
	aBcDEfGhIJkL	aBccDeFGhIJkL	aBcdEfGhIJKl	AbCdefGhIJKkL	AbCdefGhIJkL

	ABcDefgHiJkL	ABcDeFggHiJkL	AbCDeFgHijKl	AbCDeFgHIjKl	aBcDdEFgHIjKl
	aBcDeFgHIjKL	aBcdEfgHIJkL	AbBcdEfgHIjKL	AbCdefGhIjKL	AbCdEfGhiJjKL
	aBCdEfGhiJkL	AbCdEFgHijKl	AbCDeFfGhIJkl	AbCdEfGHiJKl	aBcDeFgHIjKL
	aBccdEfGHiJKL	aBcdeFgHiJKL	aBCdefGhIjKLl	ABcDeFghIjKL	aBCdEfGhiJkL
	aBCdEfGhHiJkL	aBcDEfGhIjKl	AbCdEfGHiJKl	aBcDdeFGhIJkL	AbcDefGhIJKl
	ABcdeFgHiJKl	ABbCdEfgHiJkL	ABcDeFghIjKl	ABcDEfgHiJjKl	AbCDeFgHiJkL
	aBcDeFGhIjKl	AbCdEfGgHIjKl	AbCdeFgHIJkL	aBcDefGhIJkL	AbCcDefGhIjKL
	AbCdEfgHiJkL	ABcDefGhIjKkL	AbCdEfGhIjKl	AbCDeFgHiJkL	aBcDeFgHIiJkL
	aBcdEfGHIjKl	AbcDeFgHIjKL	aBcDeeFgHiJKL	aBcdEfgHIjKL	AbCdEfghIjKL
	AaBCdeFgHijKL	aBCdEfGhIjKl	AbCdEFgHiJjKl	aBCdEfGHiJkL	abCdEfGHiJKl

	AbCdeFfGhIJKl	AbCdefGHiJKL	aBcDefgHiJKL	aBCdDefgHiJKl	ABcDeFgHijKL
	aBcDEfGhIjkLl	ABcDeFGhIjKl	aBcDeFGhIJkL	abCdEfGhHIJkL	aBcdEfGhIJKl
	AbCdefGhIJKl	ABcDeefGhIJkL	ABcdEfgHiJkL	ABcDeFgHijKl	ABbCDeFgHijKl
	AbCDeFgHIjKl	aBcDeFGhIJjKl	aBcDeFgHIjKL	aBcdeFgHIJkL	AbCdefFgHIjKL
	AbCdefGhIjKL	AbCdEfgHiJkL	AbCDdEfgHiJkL	aBCdEFgHijKl	AbCdEFgHiJKll
	AbCdEfGHiJKl	aBcDeFgHIjKL	aBcdeFgHHiJKL	aBcdeFgHiJKL	aBcDefGhIjKL
	aBCdEefGhIjKl	ABCdEfgHiJkL	aBCdEfGhIjKl	AaBcDEfGhIjKl	AbCdEfGHiJKl
	aBcDefGHiJKkl	ABcdEfGhIJkl	ABCdeFgHiJKl	ABcDefGgHiJkL	ABcDefGhIjKl
	ABcDEfgHiJkL	aBcCDeFgHiJkL	aBcDeFGhIjKl	AbCdeFGhIJkLl	AbcDeFgHIJkL
	aBcdEfGhIJkL)
      }
    ]

    # 唐・周::       麟徳暦    688 -  700 (歳首 建子月)
    Chinese0689 = [PatternTableBasedLuniSolar, {
      'origin_of_MSC'=>688, 'origin_of_LSC'=>1972387, 'border'=>'0*11-01',
      'indices'=> [
           Coordinates::Index.new({:branch=>{1=>When.Resource('_m:CalendarTerms::閏')},
                                   :trunk=>When.Resource('_m:ChineseTerms::MonthA::*')}),
           Coordinates::DefaultDayIndex
       ],
      'rule_table'=> %w(
        				AbcDeFgHIJkL	aBcdEfGhIIJkL	aBcdEfgHIjKL
	AbCdeFghIJkL	ABcDeeFghIJkL	AbCdEfGhIjKl	AbCDeFgHiJkL	aBbCdEFgHiJkL
	abCdEFgHIjKl	AbcDeFgHIJJkl	AbcDeFgHiJKL	aBcdEfgHIjKL	AbCdeFggHiJKL)
      }
    ]

    # 唐::           大衍暦    760-761 (歳首 建子月)
    # 唐::           五紀暦    762     (歳首 建子月)
    Chinese0761 = [PatternTableBasedLuniSolar, {
      'origin_of_MSC'=>760, 'origin_of_LSC'=>1998670, 'border'=>'0*11-01',
      'indices'=> [
           Coordinates::Index.new({:branch=>{1=>When.Resource('_m:CalendarTerms::閏')},
                                   :trunk=>When.Resource('_m:ChineseTerms::MonthB::*')}),
           Coordinates::DefaultDayIndex
       ],
      'rule_table'=> %w(AbcDdeFgHIjKL	aBcDefGhIJkL	AbCdEfgHiJkL)
      }
    ]

    # 後晋::         調元暦    939 -  943
    # 後晋::         調元暦?   944 -  946
    # 遼::           調元暦    947 -  994
    # 遼::           大明暦    995 - 1125
    # 金・西遼::     大明暦   1123 - 1181
    # 金・西遼:: 重修大明暦   1182 - 1234
    # 元::       重修大明暦   1215 - 1280
    # 元・明::       授時暦   1281 - 1644 （大統暦もほとんど同じ）
    # 南明::         大統暦   1645 - 1662
    Chinese0939 = [PatternTableBasedLuniSolar, {
      'origin_of_MSC'=>939, 'origin_of_LSC'=>2064050,
      'indices'=> _IndicesM1,
      'rule_table'=> %w(
							ABcDefGgHiJkL	ABcDefGhIjKl
	ABcDEfgHiJkL	aBcCDeFgHiJkL	aBcDeFGhIjKl	AbCdeFGhIJkLl	AbcDeFgHIJkL
	aBcdEfGhIJkL	AbCdeFggHIjKL	AbCdeFghIJkL	AbCDefGhIjKl	AbCDeEfGhIjKl

	AbCDeFgHiJkL	aBcDeFgHIjKl	AabCdEfGHIjKl	AbcDeFgHIjKL	aBcdEfgHIiJKL
	aBcdEfgHIjKL	AbCdeFghIjKL	AbCdEfGghIjKL	aBCdEfGhIjkL	AbCdEFgHiJkL
	abCcDEfGHiJkL	abCdEfGHiJKl	AbcDeFgHiJKLl	AbcDEfgHiJKL	aBcdEfgHiJKL
	aBCdeFghHiJKl	ABcDeFghIjKL	aBcDEfGhIjkL	aBCdEeFGhIjKl	aBcDeFGhIJkL
	abCdEfGhIJKl	AbbCdeFGhIJKl	AbcDefGhIJKl	ABcdEfgHiJJkL	AbCdEfgHiJkL
	ABcDeFghIjKl	ABcDEfGgHijKl	AbCDeFgHIjKl	aBcDeFGhIJkL	abCcDeFgHIjKL
	abCdeFgHIJkL	AbcDefGhIJkLL	AbcDefGhIjKL	AbCdEfgHiJkL	AbCDeFghHiJkL
	aBCdEfGhIjKl	AbCdEFgHiJkL	aBcDeEfGHiJKl	aBcdEfGHIjKL	abCdeFgHIjKL
	AbbCdeFgHiJKL	aBcDefGhIjKL	aBCdEfgHiJjKl	ABcDEfgHiJkL	aBCdEfGhIjKl
	AbCdEfGGhIjKl	AbCdEfGHiJKl	aBcdEfGHiJKl	AbCddEfGhIJKl	AbCdeFgHiJKl

	ABcDefGhiJKkL	ABcDefGhIjKl	ABcDeFgHiJkL	aBcDEfGhIiJkL	aBcDeFGhIjKl
	AbcDeFGhIJkL	aBcdEeFgHIJkL	aBcdEfGhIJkL	AbCdeFghIJkL	ABbCdeFghIJkL
	AbCDefGhiJKl	ABcDeFgHiJjKl	AbCdEFgHiJkL	abCDeFgHIjKl	AbcDeFgGHIjKl
	AbcDeFgHIjKL	aBcdEfgHIjKL	AbCddEfgHIjKL	AbCdeFghIjKL	AbCDefGhiJkLL
	aBCdEfGhIjkL	aBCdEFgHiJkL	abCdEFgHIiJkL	abCdEfGHiJKl	AbcDeFgHiJKL
	aBcdEefGhIJKl	ABcdEfgHiJKL	aBCdeFghIjKL	aBCcDeFghIjKl	ABcDEfGhIjkL
	aBCdEfGHiJjKl	aBcDeFGhIJkL	abCdeFGhIJKl	AbcDefFGhIJKl	AbcDefGhIJKl
	ABcdEfgHiJKl	ABcDdEfgHiJkL	ABcDeFghIjKl	ABcDEfGhIjkLl	AbCDeFgHIjkL
	aBcDeFGhIJkL	abCdeFGhIIjKL	abCdeFgHIJkL	AbcDefGhIJkL	ABcdEefGhIjKL
	AbCdEfgHiJkL	AbCDeFghIjKl	AaBCdEfGhIjKl	AbCdEFgHiJkL	aBcDeFgHIjKKl

	aBcdEfGHIjKL	abCdeFgHIjKL	AbcDefGgHiJKL	aBcDefGhIjKL	aBCdEfgHiJkL
	aBCcDEfgHiJkL	aBCdEfGhIjKl	AbCdEfGHiJkLl	AbCdEfGHiJkL	aBcdEfGHiJKl
	AbCdeFgHhIJKl	AbCdeFgHiJKl	ABcDefGhiJKl	ABCdEffGhiJKl	ABcDeFgHiJkL
	aBcDEfGhIjKl	AbCcDeFGhIjKl	AbcDeFGhIJkL	aBcdEfGhIJKkL	aBcdEfGhIJkL
	AbCdeFghIJkL	ABcDefGghIJkL	AbCDefGhiJkL	AbCDeFgHiJkl	ABcDdEFgHiJkL
	abCDeFgHIjKl	AbcDeFgHIJkLl	AbcDeFgHIjKL	aBcdEfgHIjKL	AbCdeFghHiJKL
	aBCdeFghIjKL	AbCdEfGhiJkL	AbCDeFfGhIjkL	aBCdEfGHiJkL	abCdEFgHIjKl
	AbbCdEfGHiJKl	AbcDefGHiJKL	aBcdEfgHiJKLl	ABcdEfgHiJKL	aBCdeFghIjKL
	aBCdEfGhhIjKl	ABcDEfGhiJkL	aBcDEfGHiJkL	abCdDeFGhIJkL	abCdEfGhIJKl
	AbcDefGhIJKl	ABbcDefGhIJKl	ABcdEfgHiJKl	ABcDeFghIiJkL	ABcDeFghIjKl

	ABcDeFGhiJkL	aBcDEfFgHIjkL	aBcDeFGhIJkL	abCdeFGhIJkL	AbCcdeFgHIJkL
	AbcDefGhIjKL	AbCdEfgHiJjKL	AbCdEfgHiJkL	AbCDeFghIjKl	AbCDeFgHhIjKl
	AbCdEFgHiJkL	aBcDeFgHIjKL	abCddEfGHIjKL	abCdeFgHiJKL	aBcDefGhIjKL
	AaBcDefGhIjKL	aBCdEfgHiJkL	aBCdEfGhIiJkL	aBcDEfGhIjKl	AbCdEfGHiJkL
	aBcdEeFGHiJkL	aBcdEfGHiJKl	AbCdeFgHiJKL	aBcCdeFghIJKl	ABcDefGhiJKl
	ABCdEfgHijKKl	ABcDeFgHiJkL	aBcDEfGhIjKl	AbCdEfGHhIjKl	AbcDeFGhIJkL
	aBcdEfGhIJKl	AbCddEfgHIJkL	AbCdeFghIJkL	ABcDefGhiJKl	ABbCDefGhiJkL
	AbCDeFgHiJkl	ABcDeFGhIjJkL	abCdEFgHIjKl	AbcDeFgHIJkL	aBcdEfFgHIjKL
	aBcdEfgHIjKL	AbCdeFghIjKL	AbCDdeFghIjKL	aBCdEfGhiJkL	AbCDeFgHiJkkL
	aBCdEfGHiJkl	ABcdEFgHiJKl	AbcDeFgHHiJKl	AbcDefGHiJKL	aBcdEfgHiJKL

	aBCddEfgHiJKL	aBCdeFghIjKL	aBCdEfGhiJkLl	ABcDEfGhiJkL	aBcDEfGHiJkl
	AbCdEfGHiJJkL	abCdeFGhIJKl	AbcDefGhIJKl	ABcdEffGhIJKl	ABcdEfgHiJKl
	ABcDeFghIjKl	ABbCDeFghIjKl	ABcDeFGhiJkL	aBcDeFGhIjKkL	aBcDeFgHIjKL
	abCdeFgHIJkL	AbcDefGgHIJkL	AbcDefGhIjKL	AbCdEfgHiJkL	ABcDeEfgHiJkL
	AbCDeFghIjKl	AbCDeFgHiJkL	aAbCdEFgHiJkL	aBcdEFgHIjKL	abCdeFgHIiJKL
	abCdeFgHiJKL	aBcDefGhIjKL	AbCdEffGhiJKL	aBCdEfgHiJkL	aBCdEfGhIjKl
	AbCcDEfGhIjKl	AbCdEfGHiJkL	aBcdEfGHiJKkL	aBcdEfGHiJKl	AbCdeFgHiJKL
	aBcDefGghIJKl	ABcDefGhiJKl	ABCdEfgHijKL	aBCdEeFgHiJkL	aBcDEfGhIjKl
	AbcDEfGHiJkL	aBbcDeFGhIJkL	aBcdEfGhIJKl	AbCdeFghIJJkL	AbCdeFghIJkL
	ABcDefGhiJKl	ABcDeFfGhiJkL	AbCDeFgHiJkl	ABcDeFGhIjKl	aBbCdEFgHIjKl

	AbcDeFgHIJkL	aBcdEfgHIJkLL	aBcdEfgHIjKL	AbCdeFghIjKL	AbCdEfGhhIjKL
	aBCdEfGhiJkL	AbCdEFgHijKl	AbCDdEfGHiJkL	abCdEfGHiJKl	AbcDeFgHIjKL
	aBbcDefGHiJKL	aBcdEfgHiJKL	aBCdeFghIiJKL	aBcDeFghIjKL	aBCdEfGhiJkL
	aBCdEFgGhiJkL	aBcDEfGhIJkl	AbCdEfGHiJKl	AbcCdeFGhIJKl	AbcDefGhIJKl
	ABcdEfgHiJKLl	ABcdEfgHiJKl	ABcDeFghIjKl	ABcDEfGhhIjKl	AbCDeFgHiJkL
	aBcDeFGhIjKl	AbCdEeFgHIjKL	abCdeFgHIJkL	AbcDefGhIJKl	ABbcDefGhIjKL
	AbCdEfgHiJkL	ABcDeFghIiJkL	AbCDefGhIjKl	AbCDeFgHiJkL	aBcDeFGgHiJkL
	aBcdEFgHIjKl	AbCdeFgHIjKL	aBcDdeFgHiJKL	aBcDefgHIjKL	AbCdEfgHijKLL
	aBCdEfgHijKL	aBCdEfGhIjKl	AbCdEFgHhIjKl	AbCdEfGHiJkL	aBcdEfGHiJKl
	AbCddEfGhIJKl	AbCdeFgHiJKL	aBcDefGhiJKL	aBBcDefGhiJKl	ABcDeFgHijKL

	aBcDEfGhIjJkl	ABcDeFGhIjKl	aBcDEfGhIJkL	aBcdEfFGhIJkL	aBcdEfGhIJKl
	AbCdefGhIJKl	ABcDdeFghIJkL	ABcDefgHiJkL	ABcDeFgHijKkL	AbCDeFgHijKl
	AbCDeFGhIjKl	aBcDeFGhIIjKl	AbcDeFgHIJkL	aBcdEfgHIJkL	AbCdeEfgHIjKL
	AbCdeFghIjKL	AbCdEfGhiJkL	AaBCdEfGhiJkL	AbCDeFgHijKl	AbCDeFgHIjKkl
	AbCdEfGHiJKl	AbcDeFgHIjKL	aBcdeFfGHiJKL	aBcdEfgHiJKL	aBCdeFghIjKL
	aBCcDeFghIjKL	aBCdEfGhiJkL	aBCdEfGHijKkL	aBcDEfGhIJkl	AbCdEfGHiJKl
	abCdEfGhHIJkL	aBcdEfgHIJKl	AbCdeFghIJkL	ABcDeeFghIjKL	AbCDefGhiJkL
	AbCDeFgHijKl	ABbCDeFgHijKl	AbCDeFgHIjKl	AbcDeFgHIJjKl	AbcDeFgHIjKL
	aBcdEfgHIjKL	AbCdeFfgHiJKL	AbCdeFghIjKL	AbCdEfGhiJkL	AbCDdEfGhiJkL
	aBCdEFgHiJkl	AbCdEFgHiJKll	AbCdEfGHiJKl	AbcDefGHiJKL	aBcdEfgHHIjKL

	aBcdEfgHiJKL	aBCdeFghIjKL	aBCdEeFghIjKl	ABcDEfGhiJkL	aBcDEfGhIjKl
	AaBcDeFGhIJkl	AbCdeFGhIJKl	AbcDefGhIJKkL	AbcDefGhIJKl	ABcdEfgHiJKl
	ABcDeFggHiJkL	ABcDeFghIjKl	ABcDeFgHiJkL	aBcCDeFgHiJkL	aBcDeFGhIjKl
	AbCdeFGhIJkL	AabCdeFgHIJkL	AbcDefGhIjKL	AbCdeFgHhIjKL	AbCdEfgHiJkL
	AbCDefGhIjKl	AbCDeEfGhIjKl	AbCdEFgHiJkL	aBcdEFgHIjKl	AaBcdEfGHIjKl
	AbCdeFgHiJKL	aBcDefGhIiJKL	aBcDefGhiJKL	aBCdEfgHijKL	aBCdEfGgHijKL
	aBCdEfGhIjKl	AbCdEfGHiJkL	aBccDeFGHiJkL	aBcdEfGHiJKl	AbCdeFGhiJKLl
	AbCdefGhIJKl	ABcDefgHiJKl	ABCdEfgHhiJKl	ABcDeFghIjKl	ABcDEfGhIjKl
	aBcDEeFGhIjKl	aBcDeFGhIJkL	aBcdEfGhIJKl	AbBcdeFgHIJkL	AbCdefGhIJkL
	ABcDefgHiJjKL	AbCdEfGhiJkL	AbCDeFgHijKl	ABcDeFGgHiJkl	AbCdEFgHIjKl

	aBcDeFgHIJkL	aBccDefGHIjKL	aBcdeFgHIjKL	AbCdefGhIjKL	AAbCdefGhIjKL
	AbCdEfGhiJkL	AbCDeFgHiiJkL	aBCdEfGHijKl	AbCdEFgHiJKl	aBcDeEfGHiJKl
	AbcDefGHiJKL	aBcdeFgHiJKL	AbCcdeFgHiJKL	aBcDefGhIjKL	aBCdEfGhiJjKl
	ABcDEfgHiJkL	aBcDEfGhIjKl	AbCdEfGGhIJkl	AbCdeFGhIJKl	aBcDefGhIJKl
	ABccdEfGhIJKl	AbCdeFgHiJKl	ABcDefGhIjKkL	ABcDefGhIjKl	ABcDeFgHiJkL
	aBcDEfGhIiJkL	aBcDeFGhIjKl	AbCdeFGhIJkL	aBcDeeFgHIJkL	aBcDefGhIjKL
	AbCdEfghIJkL	ABbCdeFgHiJkL	AbCDefGhIjKl	AbCDeFgHiJjKl	AbCdEFgHiJkL
	aBcdEFgHIjKl	AbCdeFfGHIjKl	AbCdeFgHiJKL	aBcDefgHIjKL	AbCdDefgHiJKL
	aBCdeFgHijKL	aBCdEfGhIjkLL	aBcDEfGhIjKl	AbCdEfGHiJkL	abCdEfGHIiJkL
	abCdEfGHiJKl	AbCdefGHiJKL	aBcDeefGhIJKl	ABcDefgHiJKl	ABCdeFghIjKL

	aBCcDeFgHijKl	ABcDEfGhIjKl	aBcDEfGHiJkKl	aBcDeFGhIJkL	abCdEfGhIJKl
	AbCdefGgHIJkL	AbCdefGhIJkL	ABcDefgHiJkL	ABcDdEfgHiJkL	AbCDeFgHijKl
	AbCDeFGhIjkLl	AbCdEFgHIjKl	aBcDeFgHIJkL	abCdeFgHIIjKL	aBcdeFgHIjKL
	AbCdefGhIjKL	AbCdEefGhIjKL	AbCdEfgHiJkL	AbCDeFgHijKl	AaBCdEfGhIjKl
	AbCdEfGHiJKl	aBcDeFgHIjKLl	aBcdEfGHiJKL	aBcdeFgHiJKL	aBcDefGgHiJKL
	aBcDefGhIjKL	aBCdEfgHiJkL	aBCdDEfgHiJkL	aBcDEfGhIjKl	AbCdEfGHiJkLl
	AbCdeFGhIJKl	aBcdEfGhIJKl	AbCdeFgHhIJKl	AbCdeFgHiJKl	ABcDefGhIjKl
	ABCdEffGhIjKl	ABcDeFgHiJkL	aBcDeFGhIjKl	AbBcDeFgHIjKl	AbcDeFgHIJkL
	aBcdEfGhIJKkL	aBcdEfgHIjKL	AbCdeFghIJkL	ABcDefGghIJkL	AbCDefGhIjKl
	AbCDeFgHiJkL	aBcDdEFgHiJkL	abCdEFgHIjKl	AbcDeFgHIjKL	aAbcDeFgHiJKL

	aBcdEfgHIjKL	AbCdeFghIiJKL	aBCdeFghIjKL	aBCdEfGhIjkL	AbCdEFfGhIjKl
	aBCdEfGHiJkL	abCdEfGHiJKl	AbbCdEfGhIJKl	AbcDefGHiJKL	aBcdEfgHiJKKl
	ABcdEfgHiJKl	ABCdeFghIJkL	aBCdEfGgHijKl	ABcDEfGhIjKl	aBcDEfGhIJkL
	abCcDeFGhIJkL	abCdeFGhIJKl	AbcDefGhIJKl	ABbcDefGhIJkL	ABcdEfgHiJkL
	ABcDeFghIiJkL	AbCDeFghIjKl	AbCDeFGhIjkL	aBcDeFFgHIjKl	aBcDeFgHIjKL
	abCdeFgHIJkL	AbbCdeFgHIjKL	AbcDefGhIjKL	AbCdEfgHiJjKL	aBCdEfgHiJkL
	aBCDeFghIjKl	AbCDeFgHhIjKl	AbCdEfGHiJKl	aBcDefGHIjKL	abCddEfGHiJKL
	abCdeFgHiJKL	aBcDefGhIjKL	AaBcDefGhIjKL	aBCdEfgHiJkL	aBCdEfGhIiJkL
	aBcDEfGhIjKl	AbCdEfGHiJkL	aBcdEeFGhIJkL	aBcdEfGhIJKl	AbCdefGHiJKL
	aBcCdeFghIJKl	ABcDefGhIjKl	ABcDEfgHiJkKl	AbCDeFgHiJkL	aBcDeFGhIjKl

	AbcDeFGgHIjKl	AbcDeFgHIJkL	aBcdEfGhIJKl	AbCddEfgHIjKL	AbCdeFghIJkL
	ABcDefGhiJkL	AAbCdEfGhIjKl	AbCDeFgHiJkL	aBcDeFGhIiJkL	abCdEFgHIjKl
	AbcDeFgHIjKL	aBcdEefGHiJKL	aBcdEfgHiJKL	AbCdeFghIjKL	AbCDdeFghIjKL
	aBCdEfGhIjkL	AbCdEFgHiJkLl	aBcDEfGHiJkL	abCdEfGHiJKl	AbcDeFgHhIJKl
	AbcDefGhIJKL	aBcdEfgHiJKL	aBCddEfgHiJKl	ABcDeFghIjKl	ABCdEfGhiJkLl
	ABcDeFGhIjkL	aBcDeFGhIJkL	abCdEfGHiJJkL	abCdeFGhIJKl	AbcDefGhIJKl
	ABcdEffGhIJkL	ABcdEfgHiJkL	ABcDeFghIjKl	ABbCDeFghIjKl	AbCDeFgHIjkL
	aBcDeFGhIJkLl	aBcDeFgHIjKL	abCdeFgHIJkL	AbcDefGgHIjKL	AbcDefGhIjKL
	AbCdEfgHiJkL	AbCDeEfgHiJkL	aBCdEFghIjKl	AbCdEFgHiJkL	aAbCdEfGHiJKl
	aBcdEfGHIjKL	abCdeFgHIiJKL	abCdeFgHiJKL	aBcDefGhIjKL	AbCdEffGhIjKl

	ABCdEfgHiJkL	aBCdEfGhIjKl	AbCcDEfGhIjKl	AbCdEfGHiJkL	aBcdEfGHiJKkL
	aBcdEfGhIJKl	AbCdeFgHiJKL	aBcDefGghIJkL	ABcDefGhiJKl	ABcDEfgHiJkL
	aBcDEeFgHiJkL	aBcDeFGhIjKl	AbcDeFGhIJkL	aBbcDeFgHIJkL	aBcdEfGhIJKl
	AbCdeFghIJjKL	AbCdeFghIJkL	ABcDefGhiJkL	ABcDeFfGhIjkL	AbCDeFgHiJkL
	abCDeFgHIjKl	AbbCdEfGHIjKl	AbcDeFgHIjKL	aBcdEfgHIjKLL	aBcdEfgHiJKL
	AbCdeFghIjKL	AbCDefGhhIjKL	aBCdEfGhiJkL	aBCdEFgHiJkl	AbCdDEfGHiJkL
	abCdEfGHIjKl	AbcDefGHiJKL	aBbcDefGhIJKL	aBcdEfgHiJKL	aBCdeFghIiJKl
	ABcDeFghIjKl	ABCdEfGhiJkL	abCDEfFGhIjKl	aBcDeFGhIJkL	abCdEfGHiJKl
	AbcCdeFgHIJKl	AbcDefGhIJKl	ABcdEfgHiJKkL	AbCdEfgHiJkL	ABcDeFghIjKl
	ABcDEfGhhIjKl	AbCDeFgHiJkL	aBcDeFGhIjKL	abCddEFgHIjKl	AbCdeFgHIJkL

	AbcDefGhIJkL	ABbcDefGhIjKL	AbCdEfgHiJkL	AbCDeFghIiJkL	aBCdEfGhIjKl
	AbCdEFgHiJkL	aBcDeFfGHiJkL	aBcdEfGHIjKl	AbCdeFgHIjKL	aBcCdeFgHiJKL
	aBcDefGhIjKL	AbCdEfgHiJkKl	ABCdEfgHiJkL	aBCdEfGhIjKl	AbCdEFgHhIjKl
	AbcDEfGHiJkL	aBcdEfGHiJKl	AbCddEfGhIJKl	AbCdeFghIJKL	aBcDefGhiJKl
	ABBcDefGhiJKl	ABcDeFgHiJkL	aBcDEfGhIjJkL	aBcDeFGhIjKl	AbcDeFGhIJkL
	aBcdEfFgHIJkL	aBcdEfgHIJKl	AbCdeFghIJkL	ABcDdeFghIJkL	ABcDefGhiJkL
	ABcDeFgHijKkL	AbCDeFgHiJkl	AbCDeFgHIjKl	AbcDeFgHHIjKl	AbcDeFgHIjKL
	aBcdEfgHIjKL	AbCddEfgHiJKL	AbCdeFghIjKL	AbCdEfGhiJkL	AaBCdEfGhiJkL
	aBCdEFgHiJkl	AbCdEFgHIjKkL	abCdEfGHiJKl	AbcDefGHiJKL	aBcdEffGhIJKL
	aBcdEfgHiJKL	aBCdeFghIjKL	aBCcDeFghIjKl	ABcDEfGhiJkL	aBCdEfGHiJkkL

	aBcDeFGhIJkL	abCdEfGhIJKl	AbcDefGgHIJKl	AbcDefGhIJKl	ABcdEfgHiJKl
	ABcDeEfgHiJkL	ABcDeFghIjKl	ABcDEfGhiJkL	aAbCDeFgHiJkL	aBcDeFGhIjKl
	AbCdeFGhIJjKl	AbCdeFgHIJkL)
      }
    ]

    # 後漢・後周::   調元暦?   947 -  955
    # 後周・北宋::   欽天暦    956 -  963
    # 北宋::         応天暦    964 -  982
    # 北宋::         乾元暦    983 - 1000
    # 北宋::         儀天暦   1001 - 1023
    # 北宋・西夏::   崇天暦   1024 - 1064
    # 北宋・西夏::   明天暦   1065 - 1067
    # 北宋・西夏::   崇天暦   1068 - 1074
    # 北宋・西夏::   奉元暦   1075 - 1093
    # 北宋・西夏::   観天暦   1094 - 1102
    # 北宋・西夏::   占天暦   1103 - 1105
    # 宋・西夏::     紀元暦   1106 - 1135
    # 南宋::         統元暦   1136 - 1167
    # 南宋::         乾道暦   1168 - 1176
    # 南宋::         淳熙暦   1177 - 1190
    # 南宋::         会元暦   1191 - 1198
    # 南宋::         統天暦   1199 - 1207
    # 南宋::         開禧暦   1208 - 1251
    # 南宋::         淳祐暦   1252       
    # 南宋::         会天暦   1253 - 1270
    # 南宋::         成天暦   1271 - 1276
    # 南宋::         本天暦   1277 - 1279
    Chinese0956 = [PatternTableBasedLuniSolar, {
      'origin_of_MSC'=>947, 'origin_of_LSC'=>2066974,
      'indices'=> _IndicesM1,
      'rule_table'=> %w(
			AbCdeFggHIjKL	AbCdeFghIJkL	AbCDefGhiJKl	AbCDeEfGhIjKl

	AbCDeFgHiJkL	aBcDeFgHIjKl	AabCdEfGHIjKl	AbcDeFgHIjKL	aBcdEfGhIiJKL
	aBcdEfgHIjKL	AbCdeFghIjKL	AbCdEfGgHijKL	aBCdEfGhIjKl	AbCdEFgHiJkL
	aBccDEfGHiJkL	abCdEfGHiJKl	AbcDeFgHiJKLl	AbCdefGHiJKL	aBcDefgHiJKL
	aBCdeFghHiJKl	ABcDeFghIjKL	aBcDEfGhIjkL	aBCdEeFGhIjKl	aBcDeFGhIJkL
	abCdEfGhIJKl	AbbCdeFGhIJKl	AbCdefGhIJKl	ABcdEfgHiJJkL	AbCdEfgHiJkL
	ABcDeFghIjKl	ABcDEfGgHijKl	AbCDeFgHIjKl	aBcDeFGhIJkL	abCcDeFgHIjKL
	abCdeFgHIJkL	AbcDefGhIJkLL	AbcDefGhIjKL	AbCdEfgHiJkL	AbCDeFghIiJkL
	AbCdEFghIjKl	AbCdEFgHiJkL	aBcDeEfGHiJKl	aBcdEfGHIjKL	abCdeFgHIjKL
	AbbCdeFgHiJKL	aBcDefGhIjKL	aBCdEfgHiJjKL	aBcDEfgHiJkL	aBCdEfGhIjKl
	AbCdEfGGhIjKl	AbCdEfGHiJKl	aBcdEfGHiJKl	AbCcdEfGhIJKl	AbCdeFgHiJKL

	aBcDefGhIjKLl	ABcDefGhIjKl	ABcDeFgHiJkL	aBcDEfGhIiJkL	aBcDeFGhIjKl
	AbcDeFGhIJkL	aBcdEeFgHIJkL	aBcdEfGhIJkL	AbCdeFghIJkL	ABbCdeFghIJkL
	AbCDefGhiJKl	AbCDeFgHiJjKl	AbCdEFgHiJkL	abCDeFgHIjKl	AbcDeFfGHIjKl
	AbcDeFgHIjKL	aBcdEfgHIjKL	AbCddEfgHIjKL	AbCdeFghIjKL	AbCdEfGhiJkLL
	aBCdEfGhIjKl	aBCdEFgHiJkL	abCdEFgHIiJkL	abCdEfGHiJkL	AbcDefGHiJKL
	aBcdEefGhIJKl	ABcdEfgHiJKL	aBCdeFghIjKL	aBBcDeFghIjKl	ABcDEfGhIjkL
	aBCdEfGHiJjKl	aBcDeFGhIJkL	abCdeFGhIJKl	AbcDefFGhIJKl	AbcDefGhIJKl
	ABcdEfgHiJKl	ABcDdEfgHiJkL	ABcDeFghIjKl	ABcDeFGhIjkLl	AbCdEFgHIjKl
	aBcDeFGhIJkL	abCdeFGhIIjKL	abCdeFgHIJkL	AbcDefGhIjKL	AbCdEefGhIjKL
	AbCdEfgHiJkL	AbCDeFghIjKl	AaBCdEfGhIjKl	AbCdEFgHiJKl	aBcDeFgHIjKKl

	aBcdEfGHIjKL	abCdeFgHIjKL	aBcDefGgHiJKL	aBcDefGhIjKL	aBCdEfgHiJkL
	aBCcDeFgHiJkL	aBCdEfGhIjKl	AbCdEfGHiJkLl	AbCdeFGHiJKl	aBcdEfGHiJKl
	AbCdeFgHhIJKl	AbCdeFgHiJKl	ABcDefGhiJKl	ABCdEefGhiJKl	ABcDeFgHiJkL
	aBcDEfGhIjKl	AbCcDeFGhIjKl	AbcDeFGhIJkL	aBcdEfGhIJKkL	aBcdEfgHIJkL
	AbCdeFghIJkL	ABcDefGghIJkL	AbCdEfGhiJkL	AbCDeFgHiJkL	aBcDdEFgHiJkL
	abCDeFgHIjKl	AbcDeFgHIJkL	aAbcDeFgHIjKL	aBcdEfgHIjKL	AbCdeFghIiJKL
	aBCdeFghIjKL	AbCdEfGhiJkL	AbCDeFfGhIjkL	aBCdEfGHiJkL	abCdEFgHIjKl
	AbbCdEfGHiJKl	AbcDefGHiJKL	aBcdEfgHiJKLl	ABcdEfgHiJKL	aBCdeFghIjKL
	aBCdEfGhhIjKl	ABcDEfGhiJkL	aBcDEfGHiJkl	AbCdDeFGhIJkL	abCdEfGhIJKl
	AbcDefGhIJKl	ABbcDefGhIJKl	ABcdEfgHiJKl	ABcDeFghIiJkL	ABcDeFghIjKl

	ABcDeFGhiJkL	aBcDEfFgHiJkL	aBcDeFgHIJkL	abCdeFGhIJkL	AbbCdeFgHIJkL
	AbcDefGhIjKL	AbCdEfgHiJjKL	AbCdEfgHiJkL	AbCDeFghIjKl	AbCDeFgHhIjKl
	AbCdEFgHiJkL	aBcDeFgHIjKL	abCddEfGHiJKL	abCdeFgHiJKL	aBcDefGhIjKL
	AaBcDefGhIjKL	aBCdEfgHiJkL	aBCdEfGhIiJkL	aBcDEfGhIjKl	AbCdEfGHiJkL
	aBcdEeFGhIJkL	aBcdEfGHiJKl	AbCdeFgHiJKL	aBcCdeFghIJKl	ABcDefGhiJKl
	ABCdEfgHijKKl	ABcDeFgHiJkL	aBcDEfGhIjKl	AbcDEfGHhIjKl	AbcDeFGhIJkL
	aBcdEfGhIJKl	AbCddEfgHIJkL	AbCdeFghIJkL	ABcDefGhiJkL	ABbCDefGhiJkL
	AbCDeFgHiJkl	ABcDeFGhIjJkL	abCdEFgHIjKl	AbcDeFgHIJkL	aBcdEfFgHIjKL
	aBcdEfgHIjKL	AbCdeFghIjKL	AbCDdeFghIjKL	aBCdEfGhiJkL	AbCDeFgHijKkL
	aBCdEfGHiJkl	AbCdEfGHiJKl	AbcDeFgHHiJKl	AbcDefGHiJKL	aBcdEfgHiJKL

	aBCddEfgHiJKL	aBcDeFghIjKL	aBCdEfGhiJkLl	ABcDEfGhiJkL	aBcDEfGhIJkl
	AbCdEfGHiJJkL	abCdeFGhIJKl	AbcDefGhIJKl	ABcdEffGhIJKl	ABcdEfgHiJKl
	ABcDeFghIjKl	ABbCDeFghIjKl	ABcDeFgHiJkL	aBcDeFGhIjKkL	aBcDeFgHIjKL
	abCdeFgHIJkL	AbcDefGgHIJkL	AbcDefGhiJKL	AbCdEfgHiJkL	ABcDeEfgHiJkL
	AbCDeFghIjKl	AbCDeFgHiJkL	aAbCdEFgHiJkL	aBcdEFgHIjKL	abCdeFgHIiJKl
	AbCdeFgHiJKL	aBcDefGhIjKL	AbCdEffGhIjKL	aBCdEfgHiJkL	aBCdEfGhIjKl
	AbCcDEfGhIjKl	AbCdEfGHiJkL	aBcdEfGHiJKkL	aBcdEfGhIJKl	AbCdeFgHiJKL
	aBcDefGghIJKl	ABcDefGhiJKl	ABCdEfgHijKL	aBCdEeFgHiJkL	aBcDEfGhIjKl
	AbcDEfGHiJkL	aBbcDeFGhIJkL	aBcdEfGhIJKl	AbCdeFghIJJkL	AbCdeFghIJkL
	ABcDefGhiJKl	ABcDeFfGhiJkL	AbCDeFgHijKl	ABcDeFGhIjKl	aBbCdEFgHIjKl

	AbcDeFgHIJkL	aBcdEfgHIJkLL	aBcdEfgHIjKL	AbCdeFghIjKL	AbCdEfGhhIjKL
	aBCdEfGhiJkL	AbCDeFgHiJkl	AbCDdEfGHiJkl	AbCdEfGHiJKl	AbcDeFgHIjKL
	aBbcDefGHiJKL	aBcdEfgHiJKL	aBCdeFghIiJKL	aBcDeFghIjKL	aBCdEfGhiJkL
	aBCdEFgGhiJkL	aBcDEfGhIJkl	AbCdEfGHiJKl	AbcCdeFGhIJKl	AbcDefGhIJKl
	ABcdEfgHiJKLl	ABcdEfgHiJKl	ABcDeFghIjKl	ABcDEfGhhIjKl	AbCDeFgHiJkL
	aBcDeFGhIjKl	AbCdEeFgHIjKL	abCdeFgHIJkL	AbcDefGhIJKl	ABbcDefGhIjKL
	AbCdEfgHiJkL	ABcDeFghIiJkL	AbCDefGhIjKl	AbCDeFgHiJkL	aBcDeFGgHiJkL
	aBcdEFgHIjKl	AbCdeFgHIjKL	aBcDdeFgHiJKL	aBcDefGhIjKL	AbCdEfgHijKLL
	aBCdEfgHijKL	aBCdEfGhIjKl	AbCdEFgHhIjKl	AbCdEfGHiJkL	aBcdEfGHiJKl
	AbCddEfGhIJKl	AbCdeFgHiJKL	aBcDefGhiJKL	aBBcDefGhiJKl	ABCdeFgHijKL

	aBCdEFghIjjKL	aBcDeFGhIjKl	aBcDEfGHiJkL	aBcdEfFGhIJkL	aBcdEfGhIJKl
	AbCdeFghIJKl	ABcDdeFghIJkL	ABcDefGhiJKl	ABcDeFgHijKkL	AbCDeFgHijKl
	AbCDeFGhIjKl	aBcDeFGhIIjKl	aBcDeFgHiJKL	aBcdEfgHIJkL	AbCdeEfgHIjKL
	AbCdeFghIjKL	AbCdEfGhiJkL	AaBCdEfGhiJkL	AbCDeFgHijKl	AbCDeFgHIjjKl
	AbCdEfGHiJKl	AbcDeFgHIjKL	aBcdEffGHiJKL	aBcdEfgHiJKL	aBCdeFghIjKL
	AbCcDeFghIjKL	aBCdEfGhiJkL	aBCdEfGHijKkL	aBcDEfGhIJkl	)
      }
    ]

    # 方臘::         紀元暦   1118 - 1120 (歳首 建子月)
    Chinese1119 = [PatternTableBasedLuniSolar, {
      'origin_of_MSC'=>1118, 'origin_of_LSC'=>2129431, 'border'=>'0*11-01',
      'indices'=> _IndicesM11,
      'rule_table'=> %w(		aBCdEfGhIiJkL	aBcDEfGhIjKl	AbCdEfGHiJkL)
      }
    ]

    # 清::           時憲暦   1645 - 1911
    Chinese1645 = [PatternTableBasedLuniSolar, {
      'origin_of_MSC'=>1645, 'origin_of_LSC'=>2321912,
      'indices'=> _IndicesM1,
      'rule_table'=> %w(
									aBcdEffGhIJKL
	aBcdEfgHiJKL	aBCdeFghIjKL	aBCdDeFghIjKl	ABcDEfGhiJkL	aBCdEfGHijKl

	AbBcDeFGhIJkl	AbCdEfGHiJKl	AbcDefFGhIJkL	AbcDefGhIJKl	ABcdEfgHiJKl
	ABcDeEfgHiJkL	ABcDeFghIjKl	ABcDEfGhiJkL	aBcCDeFgHiJkL	aBcDeFGhIjKl
	AbCdeFGgHIjKl	AbCdeFgHIJkL	AbcDefGhIJkL	AbCdEffGhIjKL	AbCdEfgHiJkL
	AbCDeFghIjKl	AbCDdEfGhIjKl	AbCdEFgHiJkL	aBcDeFgHIjKl	AbBcdEfGHIjKl
	AbCdeFgHIjKL	aBcDefGgHiJKL	aBcDefGhIjKL	aBCdEfgHijKL	aBCDeEfgHiJkL
	aBCdEfGhIjKl	AbCdEFgHiJkL	aBccDEfGHiJkL	aBcdEfGHiJKl	AbCdeFgHhIJKl
	AbCdeFghIJKl	ABcDefGhiJKl	ABCdEffGhiJKl	ABcDeFgHijKl	ABcDEfGhIjKl
	aBCdDeFGhIjKl	aBcDeFGhIJkL	aBcdEfGhIJKl	AbCcdEfgHIJkL	AbCdeFghIJkL
	ABcDefGghIjKL	AbCDefGhiJkL	ABcDeFgHijKl	ABcDeEFgHiJkl	AbCDeFgHIjKl
	aBcDeFgHIJkL	aBccDeFgHIjKL	aBcdEfgHIjKL	AbCdeFggHiJKL	AbCdeFghIjKL

	AbCdEfGhiJkL	AbCDeFfGhiJkL	aBCdEFgHijKl	AbCdEFgHIjKl	aBcDdEfGHiJKl
	AbcDefGHiJKL	aBcdEfgHiJKL	aBCcdEfgHiJKL	aBCdeFghIjKL	aBCdEfGghIjKl
	ABcDEfGhiJkL	aBcDEfGhIjKl	AbCdEeFGhIJkl	AbCdEfGhIJKl	AbcDefGhIJKl
	ABccDefGhIJKl	ABcdEfgHiJKl	ABcDeFghHiJkL	ABcDeFghIjKl	ABcDeFgHiJkL
	aBcDEfFgHiJkL	aBcDeFGhIjKl	AbCdeFGhIJkL	aBcDdeFgHIJkL	aBcDefGhIJkL
	AbCdEfgHiJkL	ABcCdEfgHiJkL	AbCDeFghIjKl	AbCDeFgGhIjKl	AbCdEFgHiJkL
	aBcDeFgHIjKl	AbCdeEfGHIjKl	AbCdeFgHIjKL	aBcDefGhIjKL	AbCdDefgHiJKL
	aBCdEfgHijKL	aBCdEfGhIijKL	aBCdEfGhIjKl	AbCdEfGHiJkL	aBcdEFfGHiJkL
	aBcdEfGHiJKl	AbCdeFgHiJKL	aBcDdefGhIJKl	ABcDefgHiJKl	ABCdEfgHijKL
	aBCcDeFgHijKl	ABcDEfGhIjKl	aBcDEfGGhIjKl	aBcDeFGhIJkL	aBcdEfGhIJKl

	AbCdeEfgHIJkL	AbCdefGhIJkL	ABcDefgHiJkL	ABcDdEfGhiJkL	AbCDeFgHijKl
	ABcDeFGhIijKl	AbCdEFgHIjKl	aBcDeFgHIJkL	abCdEfFgHIjKL	aBcdeFgHIjKL
	AbCdefGhIjKL	AbCDeefGhIjKL	AbCdEfgHiJkL	AbCDeFgHijKl	AbBCdEfGHijKl
	AbCdEFgHiJKl	aBcDeFgGHiJKl	aBcDefGHiJKL	aBcdeFgHiJKL	aBCdeeFgHiJKL
	aBcDefGhIjKL	aBCdEfgHiJkL	aBCcDEfgHiJkL	aBcDEfGhIjKl	AbCdEfGHiJjKl
	AbCdeFGhIJkL	aBcdEfGhIJKl	AbCdeFfGhIJKl	AbCdeFgHiJKl	ABcDefGhIjKl
	ABCdEefGhIjKl	ABcDeFgHiJkL	aBcDEfGhIjKl	AbCcDeFGhIjKl	AbCdeFGhIJkL
	aBcdEfGgHIJkL	aBcdEfGhIjKL	AbCdEfghIJkL	ABcDeeFgHiJkL	AbCDefGhIjKl
	AbCDeFgHiJkL	aBcDdEFgHiJkL	aBcdEFgHIjKl	AbcDeFgHIJkL	aBbcDeFgHiJKL
	aBcdEfgHIjKL	AbCdEffgHiJKL	aBCdeFghIjKL	aBCdEfGhIjkL	AbCDdEfGhIjKl

	aBCdEfGHiJkL	abCdEfGHIjKl	AbbCdEfGHiJKl	AbcDefGHiJKL	aBcDeffGhIJKl
	ABcDefgHiJKl	ABCdeFghIjKL	aBCdEeFgHijKl	ABcDEfGhIjkL	aBcDEfGHiJkL
	abCcDeFGhIJkL	abCdEfGhIJKl	AbCdefGhIJKl	ABbCdefGhIJkL	ABcdEfgHiJkL
	ABcDeFfgHiJkL	AbCDeFgHijKl	AbCDeFGhIjkL	aBcDdEFgHIjKl	aBcDeFgHIJkL
	abCdeFgHIJkL	AbCcdeFgHIjKL	AbCdefGhIjKL	AbCdEfgGhIjKL	AbCdEfgHiJkL
	AbCDeFghIjKl	AbCDeEfGhIjKl	AbCdEFgHiJkL	aBcDeFgHIjKL	abCddEfGHiJKL
	abCdeFgHiJKL	aBcDefGhIiJKL	aBcDefGhIjKL	aBCdEfgHiJkL	aBCdEFfgHiJkL
	aBcDEfGhIjKl	AbCdEfGHiJkL	aBcDdeFGhIJkL	aBcdEfGhIJKl	AbCdeFgHiJKL
	aBcCdeFgHiJkL	ABcDefGhIjKl	ABCdEfgGhIjKl	ABcDeFgHiJkL	aBcDEfGhIjKl
	AbCdEeFgHIjKl	AbcDeFgHIJkL	aBcdEfGhIJKl	AbCddEfGhIjKL	AbCdeFghIJkL

	ABcDefGhhIjKL	AbCDefGhIjkL	AbCDeFgHiJkL	aBcDeFGgHiJkL	abCdEFgHIjKl
	AbcDeFgHIJkL	aBcdEeFgHiJKL	aBcdEfgHIjKL	AbCdeFghIjKL	AbCCdeFghIjKL
	aBCdEfGhIjkL	AbCdEFgHhIjkL	aBCdEfGHiJkL	abCdEfGHiJKl	AbcDeEfGHiJKl
	AbcDefGHiJKL	aBcdEfgHiJKL	aBCddEfgHiJKl	ABCdeFghIjKl	ABCdEfGhiJjKl
	ABcDEfGhIjkL	aBcDEfGhIJkL	abCdEfFGhIJkL	abCdEfGhIJKl	AbcDefGhIJKl
	ABcdEefGhIJkL	ABcdEfgHiJkL	ABcDeFghIjKl	ABcCDeFghIjKl	AbCDeFGhIjkL
	aBcDeFGgHIjKl	aBcDeFgHIjKL	abCdeFgHIJkL	AbcDeeFgHIjKL	AbcDefGhIjKL
	AbCdEfgHiJkL	ABcDdEfgHiJkL	AbCDeFghIjKl	AbCDeFgHiJkL	aBbCdEFgHiJkL
	aBcDeFgHIjKL	abCdeFfGHiJKL	abCdeFgHiJKL	aBcDefGhIjKL	AbCdEefGhIjKl
	ABCdEfgHiJkL	aBCdEfGhIjKl	AbCcDEfGhIjKl	AbCdEfGHiJkL	aBcdEfGHhIJkL

	aBcdEfGhIJKl	AbCdeFgHiJKL	aBcDeeFghIJkL	ABcDefGhiJKl	ABcDEfgHiJkL
	aBCdDeFgHiJkL	aBcDeFGhIjKl	AbcDEfGhIJkL	aBbcDeFgHIJkL	aBcdEfGhIJKl
	AbCdeFfgHIjKL	)
      }
    ]
  end
end
