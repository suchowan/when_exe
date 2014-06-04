# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

require 'when_exe/region/japanese'

module When
  module CalendarTypes

    #
    # 日本の朔閏表
    #
    Japanese = [PatternTableBasedLuniSolar, {
      'origin_of_MSC'=>454, 'origin_of_LSC'=>1886926,
      'indices'=> [
           When.Index('Japanese::Month', {:branch=>{1=>When.Resource('_m:Calendar::閏')}}),
           When::Coordinates::DefaultDayIndex
       ],
      'before'    => 'JapaneseTwin::平朔儀鳳暦',
      'after'     => 'JapaneseTwin::旧暦',
      'note'      => 'Japanese',
      'rule_table'=> %w(
							aBcDeFgHiJkL	aBCdEfGhIjKl
	AbCcDeFGhIjKl	AbCdEfGhIjKL	aBcDeFgHiJkLl	AbCDeFgHiJkL	aBcDeFGhIjKl
	AbCdEfGhIiJKl	AbCdEfGhIjKl	AbCDeFgHiJkL	aBcDeEFgHiJkL	aBcDeFgHiJKl
	AbCdEfGhIjKl	AaBCdEfGhIjKl	AbCdEFgHiJkL	aBcDeFgHiJKkL	aBcDeFgHiJkL
	aBCdEfGhIjKl	AbCdEFgGhIjKl	AbCdEfGhIJkL	aBcDeFgHiJkL	aBCcDeFgHiJkL
	aBcDEfGhIjKl	AbCdEfGhIJkLl	AbCdEfGhIjKl	ABcDeFgHiJkL	aBcDEfGhIiJkL
	aBcDeFgHIjKl	AbCdEfGhIjKl	ABcDeEfGhIjKl	AbCDeFgHiJkL	aBcDeFgHIjKl
	AaBcDeFgHiJkL	AbCdEfGhIjKl	AbCDeFgHiJjKl	AbCdEfGHiJkL	aBcDeFgHiJkL
	AbCdEfGgHiJkL	aBCdEfGhIjKl	AbCdEfGHiJkL	aBcDdEfGhIjKL	aBcDeFgHiJkL
	aBCdEfGhIjKlL	aBcDeFGhIjKl	AbCdEfGhIjKL	aBcDeFgHhIjKl	ABcDeFgHiJkL

	aBcDeFGhIjKl	AbCdEeFgHiJKl	AbCdEfGhIjKl	ABcDeFgHiJkL	aBbCdEFgHiJkL
	aBcDeFgHiJKl	AbCdEfGhIjJkL	AbCdEfGhIjKl	AbCdEFgHiJkL	aBcDeFfGhIJkL
	aBcDeFgHiJkL	AbCdEfGhIjKl	AbCcDEfGhIjKl	AbCdEfGhIJkL	aBcDeFgHiJkLL
	aBcDeFgHiJkL	aBcDEfGhIjKl	AbCdEfGhIIjKl	AbCdEfGhIjKl	ABcDeFgHiJkL
	aBcDEeFgHiJkL	aBcDeFgHIjKl	AbCdEfGhIjKl	ABbCdEfGhIjKl	AbCDeFgHiJkL
	aBcDeFgHIjKkL	aBcDeFgHiJkL	AbCdEfGhIjKl	AbCDeFgGhIjKl	AbCdEfGHiJkL
	aBcDeFgHiJkL	AbCcDeFgHiJkL	aBCdEfGhIjKl	AbCdEfGHiJkLl	AbCdEfGhIjKL
	aBcDeFgHiJkL	aBCdEfGhIiJkL	aBcDeFGhIjKl	AbCdEfGhIjKL	aBcDeEfGhIjKl
	ABcDeFgHiJkL	aBcDeFGhIjKl	AaBcDeFgHiJKl	AbCdEfGhIjKl	ABcDeFgHiJjKl
	AbCdEFgHiJkL	aBcDeFgHiJKl	AbCdEfGgHiJkL	AbCdEfGhIjKl	AbCdEFgHiJkL

	aBcDdEfGhIJkL	aBcDeFgHiJkL	AbCdEfGhIjKlL	aBcDEfGhIjKl	AbCdEfGhIJkL
	aBcDeFgHhIjKL	aBcDeFgHiJkL	aBcDEfGhIjKl	AbCdEeFgHIjKl	AbCdEfGhIjKL
	aBcDeFgHiJkL	aBbCDeFgHiJkL	aBcDeFgHIjKl	AbCdEfGhIjJKl	AbCdEfGhIjKl
	AbCDeFgHiJkL	aBcDeFfGHiJkL	aBcDeFgHiJKl	AbCdEfGhIjKl	AbCDdEfGhIjKl
	AbCdEfGHiJkL	aBcDeFgHiJKlL	aBcDeFgHiJkL	aBCdEfGhIjKl	AbCdEfGHhIjKl
	AbCdEfGhIJkL	aBcDeFgHiJkL	aBCdEeFgHiJkL	aBcDeFGhIjKl	AbCdEfGhIjKL
	aBbCdEfGhIjKl	ABcDeFgHiJkL	aBcDeFGhIjKkL	aBcDeFgHiJKl	AbCdEfGhIjKl
	ABcDeFgGhIjKl	AbCdEFgHiJkL	aBcDeFgHiJKl	AbCcDeFgHiJkL	AbCdEfGhIjKl
	AbCdEFgHiJkLl	AbCdEfGhIJkL
					aBcDeFgHiJkL	AbCdEfGhIiJkL	aBcDEfGhIjKl
	AbCdEfGhIJkL	aBcDeEfGhIjKL	aBcDeFgHiJkL	aBcDEfGhIjKl	AaBcDeFgHIjKl

	AbCdEfGhIjKL	aBcDeFgHiJjKl	AbCDeFgHiJkL	aBcDeFgHIjKl	AbCdEfGgHiJKl
	AbCdEfGhIjKl	AbCDeFgHiJkL	aBcCdEfGHiJkL	aBcDeFgHiJKl	AbCdEfGhIjKkL
	aBCdEfGhIjKl	AbCdEfGHiJkL	aBcDeFgHhIJkL	aBcDeFgHiJkL	aBCdEfGhIjKl
	AbCdEeFGhIjKl	AbCdEfGhIJkL	aBcDeFgHiJkL	aBBcDeFgHiJkL	aBcDeFGhIjKl
	AbCdEfGhIJjKl	AbCdEfGhIjKl	ABcDeFgHiJkL	aBcDeFGgHiJkL	aBcDeFgHIjKl
	AbCdEfGhIjKl	ABcDdEfGhIjKl	AbCdEFgHiJkL	aBcDeFgHIjKlL	aBcDeFgHiJkL
	AbCdEfGhIjKl	AbCdEFgHhIjKl	AbCdEfGHiJkL	aBcDeFgHiJkL	AbCdEeFgHiJkL
	aBcDEfGhIjKl	AbCdEfGHiJkL	aBbCdEfGhIjKL	aBcDeFgHiJkL	aBcDEfGhIjKkL
	aBcDeFgHIjKl	AbCdEfGhIjKL	aBcDeFgGhIjKl	AbCDeFgHiJkL	aBcDeFgHIjKl
	AbCcDeFgHiJKl	AbCdEfGhIjKl	AbCDeFgHiJkLl	AbCdEfGHiJkL	aBcDeFgHiJKl

	AbCdEfGhIiJkL	aBCdEfGhIjKl	AbCdEfGHiJkL	aBcDeEfGhIJkL	aBcDeFgHiJkL
	aBCdEfGhIjKl	AaBcDeFGhIjKl	AbCdEfGhIJkL	aBcDeFgHiJjKl	ABcDeFgHiJkL
	aBcDeFGhIjKl	AbCdEfGgHIjKl	AbCdEfGhIjKl	ABcDeFgHiJkL	aBcCdEFgHiJkL
	aBcDeFgHIjKl	AbCdEfGhIjKkL	AbCdEfGhIjKl	AbCdEFgHiJkL	aBcDeFgHIiJkL
	aBcDeFgHiJkL	AbCdEfGhIjKl	AbCdEFfGhIjKl	AbCdEfGHiJkL	aBcDeFgHiJkL
	AbBcDeFgHiJkL	aBcDEfGhIjKl	AbCdEfGHiJjKl	AbCdEfGhIjKL	aBcDeFgHiJkL
	aBcDEfGgHiJkL	aBcDeFGhIjKl	AbCdEfGhIjKL	aBcDdEfGhIjKl	AbCDeFgHiJkL
	aBcDeFGhIjKlL	aBcDeFgHiJKl	AbCdEfGhIjKl	AbCDeFgHhIjKl	AbCdEFgHiJkL
	aBcDeFgHiJKl	AbCdEeFgHijKL	aBCdEfGhIjKl	AbCdEFgHiJkL	aBbCdEfGhIJkL
	aBcDeFgHiJKl	aBcDEfgHIjKLl	AbcDeFgHIjKL	aBcdEfgHIjKL	AbCdeFggHiJKL

	aBCdeFghIjKL	aBCdEfGhIjkL	AbCdDEfGhIjkL	aBCdEfGHiJkL	abCdEfGHiJKl
	AabCdEfGHiJKl	AbcDefGHiJKL	aBcdEfgHhIJKl	ABcdEfgHiJKl	ABcDeFghIjKl
	ABCdEfFgHijKl	ABcDEfGhIjkL	aBcDEfGhIJkL	abBcDeFGhIJkL	abCdEfGhIJKl
	AbcDefGhIJKkL	AbcDefGhIJkL	ABcdEfgHiJkL	ABcDeFggHiJkL	AbCDeFghIjKl
	AbCDeFgHIjkL	aBcDdEFgHIjKl	aBcDeFgHIjKL	abCdeFgHIJkL	AabCdeFgHIjKL
	AbcDefGHijKL	AbCdEfgHiIjKL	aBCdEfgHiJkL	AbCdEFghIjKl	AbCDeFfGhIjKl
	AbCdEfGHiJkL	aBcdEFgHIjKL	aBccdEfGHiJKl	AbCdeFgHiJKL	aBcDefGhIjKKl
	ABcDefGhIjKl	ABCdEfgHiJkL	aBCdEfGgHiJkL	aBcDEfGhIjKl	AbCdEfGHiJkL
	aBccDeFGhIJkL	aBcdEfGhIJKl	AbCdeFgHiJKL	aAbCdeFghIJkL	ABcDefGhiJKl
	ABcDEfgHiIjKl	AbCDeFgHiJkL	aBcDeFGhIjKl	AbcDEeFgHIjKl	AbcDeFgHIJkL

	aBcdEfGhIJkL	AbCcdEfgHIjKL	AbCdeFghIJkL	ABcDefGhiJjKL	AbCdEfGhiJkL
	AbCDeFgHiJkL	aBcDeFGhHiJkL	abCdEFgHIjKl	AbcDeFgHIjKL	aBcdDefGHiJKL
	aBcdEfGhIjKl	ABCdeFghIjKLl	ABCdeFghIjKL	aBCdEfGhiJkL	aBCdEFgHiJjkL
	aBCdEfGHiJkL	abCdEfGHiJKl	AbcDeFfGhIJKl	AbcDefGhIJKL	aBcdEfgHiJKL
	aBCcdEfgHiJKl	ABcDeFghIjKL	aBcDEfGhIjkKL	aBcDeFGhIjkL	aBcDEfGHiJkL
	abCdEfGHhIJkL	aBcdEfgHIJkL	AbCDefghIJKl	ABcDeefGhIJKL	aBcdEfgHiJKL
	aBcDeFghIjKl	AAbCDeFghIjKl	ABcDeFGhIjkL	aBcDeFGhIiJKl	aBcDeFgHIJkL
	abCdEfgHIjKL	AbCdeeFgHiJKL	aBcDefGhIjKL	AbCdEfgHiJkL	ABcCdEfGhiJkL
	aBCDeFghIjKl	ABcdEFgHIjKkl	AbCdEfGHiJkL	aBcdEfGHiJKL	abCdeFgGHiJKL
	abCdeFgHiJKL	aBcDefGhIjKL	AbCdEefGhiJKL	aBCdEfgHiJkL	aBCdEfGhIjKl

	AaBcDeFGhIjKl	AbcDEfGHiJkL	aBcdEfGHiJJkL	aBcdEfGhIJKl	AbCdeFghIJKL
	aBcDefFghIJKL	aBcDefGhIjKl	ABcDEfgHijKL	aBbCDeFgHiJkL	aBcDeFGhIJkl
	AbcDeFGhIJkLl	AbcDeFgHIJkL	aBcdEfGhIJkL	AbCdeFggHIjKL	AbCdeFghIjKL
	AbCDefGhiJKl	AbCDdEfGhIjkL	AbCDeFgHiJkL	aBcDeFgHIjKl	AAbcdEFgHIjKl
	AbcDeFgHIjKL	AbcdEfgHIiJKL	aBcdEfgHIjKL	aBCdeFghIjKL	AbCdEfGghIjKl
	ABCdEfGhiJkL	aBCdEfGHiJkL	AbccDEfGHiJkL	abCdEfGHiJKl	AbcDEfgHiJKLl
	AbcDefGHiJKL	AbcdEfgHiJKL	aBCdeFggHiJKl	ABcDeFghIjKL	aBcDEfGhiJkL
	aBcDEeFGhIjkL	aBcDeFGhIJkL	abCdEfGHiJKl	AabCdeFGhIJKl	AbcDefGhIJKl
	ABcdEfgHiIJkL	ABcdEfgHiJKl	ABcDeFghIjKl	ABcDEfGgHijKl	AbCDeFgHIjKl
	aBcDeFGhIJkL	abCcDeFgHIJkL	abCdeFgHIJkL	AbcDefGhIJkLL	AbcDefGhIjKL

	AbCdEfgHiJkL	AbCDeFghHiJkL	aBCdEFghIjKl	AbCdEFgHiJKL	abcDdEfGHiJKl
	aBcdEfGHIjKL	abCdeFgHIjKL	AbbCdeFgHiJKL	aBcDefGhIjKL	AbCdEfgHiJJkL
	aBCdEfgHiJkL	AbCdEFgHijKl	AbCDeFfGhIJkl	AbCdEfGHiJKl	AbcDeFgHIjKL
	aBccdEfGHiJKL	aBcdeFgHiJKL	aBCdefGhIjKLl	ABcDeFghIjKL	aBCdEfGhiJkL
	aBCdEfGhHiJkL	aBcDEfGhIjKL	abCdEfGHiJKL	abcDdeFGhIJkL	AbcdEfGhIJKl
	ABcdeFgHiJKl	ABbCdeFgHiJkL	ABcDefGhIjKl	ABcDEfgHiJjKl	AbCDeFgHiJkL
	aBcDeFGhIjKl	AbCdEfGgHIjKl	AbCdeFgHIJkL	aBcdEfGhIJkL	AbCcDefGhIjKL
	AbCdEfghIJkL	ABcDefGhIjKkL	AbCdEfGhIjKl	AbCdEFgHiJkL	aBcDeFgHIiJkl
	ABcdEfGHIjKL	abCdeFgHIjKL	aBcDeeFgHiJKL	aBcdEfgHIjKL	AbCdEfghIjKL
	AaBCdeFgHijKL	aBCdEfGhIjKl	AbCdEFgHiJjKl	AbCdEfGHiJkL	abCdEfGHiJKl

	AbCdeFfGhIJKl	AbCdefGHiJKL	aBcDefgHiJKL	aBCcDefgHiJKl	ABcDeFgHijKL
	aBcDEfGhIjkLl	ABcDeFGhIjKl	aBcDeFGhIJkL	abCdEfGhHIJkL	aBcdEfGhIJKl
	AbCdefGhIJKl	ABcDeefGhIJkL	ABcdEfgHiJkL	ABcDeFgHijKl	ABbCDeFgHijKl
	AbCDeFgHIjKl	aBcDeFGhIJjKl	aBcDeFgHIjKL	aBcdeFgHIJkL	AbCdefFgHIjKL
	AbCdefGhIjKL	AbCdEfgHiJkL	AbCDdEfgHiJkL	aBCdEFghIjKl	AbCdEFgHiJKll
	AbCdEfGHiJKl	aBcDefGHIjKL	aBcdeFgHHiJKL	aBcdeFgHiJKL	aBcDefGhIjKL
	aBCdEefGhIjKl	ABCdEfgHiJkL	aBCdEfGhIjKl	AaBcDEfGhIjKl	AbCdEfGHiJkL
	aBcdEfGHiJKkl	ABcdEfGhIJkl	ABCdeFgHiJKl	ABcDefGgHiJkL	ABcDefGhIjKl
	ABcDEfgHiJkL	aBcCDeFgHijKL	aBcDeFGhIjKl	AbCdeFGhIJkLl	AbcDeFgHIJkL
	aBcdEfGhIJkL	AbCdeFggHIjKL	AbCdeFghIJkL	AbCDefGhiJKl	AbCDeEfGhIjKl

	AbCDeFgHiJkL	aBcDeFgHIjKl	AabCdEfGHIjKl	AbcDeFgHIjKL	aBcdEfgHIiJKL
	aBcdEfgHIjKL	AbCdeFghIjKL	AbCdEfGghIjKL	aBCdEfGhIjkL	AbCdEFgHiJkL
	abCcDEfGHiJkL	abCdEfGHiJKl	AbcDeFgHiJKLl	AbcDefGhIJKl	ABcdEfgHiJKL
	aBCdeFghHiJKl	ABcDeFghIjKL	aBcDEfGhIjkL	aBCdEeFGhIjKl	aBcDeFGhIJkL
	abCdEfGhIJKl	AbbCdeFGhIJKl	AbcDefGhIJKl	ABcdEfgHiJJkL	AbCdEfghIJkL
	ABcDeFghIjKl	ABcDEfGghIjKl	AbCDeFgHIjKl	aBcDeFGhIJkL	abCcDeFgHIjKL
	abCdeFgHIJkL	AbcDefGhIJkLL	aBcDefGhIjKL	AbCdEfgHiJkL	AbCDeFghHiJkL
	aBCdEfGhIjKl	AbCdEFgHiJkL	aBcDeEfGHiJKl	aBcdEfGHIjKL	abCdeFgHIjKL
	AbbCdeFgHiJKL	aBcDefGhIjKL	aBCdEfgHiJjKl	ABcDeFgHiJkL	aBCdEfGhIjKl
	AbCdEfGGhIjKl	AbcDeFGHiJkL	aBcdEfGHiJKl	AbCcdEfGhIJKl	AbCdeFgHiJKl

	ABcDefGhiJKLl	ABcDefGhiJKl	ABcDeFgHiJkL	aBcDEfGhIiJkL	aBcDeFGhIjKl
	AbcDeFGhIJkL	aBcdEeFgHIJkL	aBcdEfGhIJkL	AbCdeFghIJkL	ABbCdeFghIJkL
	AbCDefGhiJKl	AbCDeFgHiJjKl	AbCdEFgHiJkL	abCDeFgHIjKl	AbcDeFfGHIjKl
	AbcDeFgHIjKL	aBcdEfgHIjKL	AbCddEfgHIjKL	AbCdeFghIjKL	AbCdEfGhiJkLL
	aBCdEfGhIjkL	AbCdEFgHiJkL	abCdEFgHIiJkL	abCdEfGHiJKl	AbcDeFgHiJKL
	aBcdEefGHiJKL	aBcdEfgHiJKL	aBCdeFghIjKL	aBBcDeFghIjKL	aBcDEfGhIjkL
	aBCdEfGHiJjKl	aBcDeFGhIJkL	abCdEfGhIJKl	AbcDefFGhIJKl	AbcDefGhIJKl
	ABcdEfgHiJKl	ABCddEfgHiJkL	ABcDeFghIjKl	ABcDeFGhiJkLl	AbCDeFgHIjKl
	aBcDeFGhIjKL	abCdEfGhIIjKL	abCdeFgHIJkL	AbcDefGhIJkL	AbCdEefGhIjKL
	AbCdEfgHiJkL	AbCDeFghIjKl	AaBCdEfGhIjKl	AbCdEFgHiJkL	aBcDeFgHIjjKL

	aBcdEfGHIjKL	abCdeFgHIjKL	aBcDefGgHiJKL	aBcDefGhIjKL	aBCdEfgHiJkL
	aBCcDEfgHiJkL	aBCdEfGhIjKl	AbCdEfGHiJkLl	AbCdEfGHiJkL	aBcdEfGHiJKl
	AbCdeFgHhIJKl	AbCdeFgHiJKl	ABcDefGhIjKl	ABCdEefGhiJKl	ABcDeFgHiJkL
	aBcDEfGhIjKl	AaBcDeFGhIjKl	AbcDeFGhIJkL	aBcdEfGhIJjKL	aBcdEfGhIJkL
	AbCdeFghIJkL	ABcDefGghIJkL	AbCDefGhiJKl	AbCDeFgHiJkL	aBcDdEFgHiJkL
	abCDeFgHIjKl	AbcDeFgHIJkLl	AbcDeFgHIjKL	aBcdEfgHIjKL	AbCdeFghHiJKL
	aBCdeFghIjKL	AbCDefGhiJkL	AbCDeFfGhIjkL	aBCdEfGHiJkL	abCdEFgHIjKl
	AbbCdEfGHiJKl	AbcDefGHiJKL	aBcdEfgHiJJKl	ABcdEfgHiJKL	aBCdeFghIjKL
	aBCdEfGghIjKl	ABcDEfGhiJkL	aBcDEfGhIJkl	AbCcDeFGhIJkl	AbCdEfGhIJKl
	AbcDefGhIJKl	AAbcDefGhIJKl	ABcdEfgHiJKl	ABcDeFghIiJkL	ABcDeFghIjKl

	ABcDeFGhiJkL	aBcDEeFgHiJkL	aBcDeFGhIjKL	abCdeFGhIJkL	AbbCdeFgHIJkL
	AbcDefGhIJkL	AbCdEfgHiJjKL	AbCdEfgHiJkL	AbCDeFghIjKl	AbCDeFgGhIjKl
	AbCdEFgHiJkL	aBcDeFgHIjKL	abCcdEfGHIjKL	abCdeFgHiJKL	aBcDefGhIjKL
	AaBcDefGhIjKL	aBCdEfgHiJkL	aBCdEfGhIiJkL	aBcDEfGhIjKl	AbCdEfGHiJkL
	aBcdEeFGHiJkL	aBcdEfGHiJKl	AbCdeFgHiJKL	aBbCdeFghIJKl	ABcDefGhiJKl
	ABCdEfgHijJKl	ABcDeFgHiJkL	aBcDEfGhIjKl	AbCdEfGgHIjKl	AbcDeFGhIJkL
	aBcdEfGhIJKl	AbCddEfgHIJkL	AbCdeFghIJkL	ABcDefGhiJKlL	AbCdEfGhiJkL
	AbCDeFgHiJkl	ABcDeFGhIiJkl	AbCdEFgHIjKl	AbcDeFgHIJkL	aBcdEeFgHIjKL
	aBcdEfgHIjKL	AbCdeFghIjKL	AbBCdeFghIjKL	aBCdEfGhiJkL	AbCDeFgHijJkL
	aBCdEfGHiJkl	AbCdEFgHiJKl	AbcDeFfGHiJKl	AbcDefGHiJKL	aBcdEfgHiJKL

	aBCddEfgHiJKL	aBcDeFghIjKL	aBCdEfGhiJkLl	ABcDEfGhiJkL	aBcDEfGhIJkl
	AbCdEfGHiIjKl	AbCdEfGhIJKl	AbcDefGhIJKl	ABcdEefGhIJKl	ABcdEfgHiJKl
	ABcDeFghIjKl	ABbCDeFghIjKl	ABcDeFgHiJkL	aBcDeFGhIjjKL	aBcDeFgHIjKL
	abCdeFGhIJkL	AbcDefGgHIJkL	AbcDefGhIjKL	AbCdEfgHiJkL	ABcDdEfgHiJkL
	AbCDefGhIjKl	AbCDeFgHiJkLl	AbCdEFgHiJkL	aBcDeFgHIjKl	AbCdeFgHIiJKl
	AbCdeFgHiJKL	aBcDefGhIjKL	AbCdEffGhIjKL	aBCdEfgHiJkL	aBCdEfGhIjKl
	AbBcDEfGhIjKl	AbCdEfGHiJkL	aBcdEfGHiJjKL	aBcdEfGHiJKl	AbCdeFgHiJKL
	aBcDefGghIJKl	ABcDefgHiJKl	ABCdeFgHijKL	aBCdDeFgHiJkL	aBcDEfGhIjKl
	AbcDEfGHiJkLl	AbcDeFGhIJkL	aBcdEfGhIJKl	AbCdeFghHIJkL	AbCdefGhIJkL
	ABcDefGhiJKl	ABcDeFfGhiJkL	AbCDeFgHijKl	ABcDeFGhIjKl	aBbCdEFgHIjKl

	AbcDeFgHIJkL	aBcdEfgHIJjKL	aBcdeFgHIjKL	AbCdefGhIjKL	AbCDefGghIjKL
	aBCdEfGhiJkL	AbCDeFgHijKl	AbCDdEfGHiJkl	AbCdEfGHiJKl	AbcDeFgHIjKL
	aAbcDefGHiJKL	aBcdeFgHiJKL	aBCdeFghIiJKL	aBcDeFghIjKL	aBCdEfGhiJkL
	aBCdEFfGhiJkL	aBcDEfGhIJkl	AbCdEfGHiJKl	AbbCdeFGhIJKl	AbcDefGhIJKl
	ABcdEfgHiJjKL	AbCdEfgHiJKl	ABcDeFghIjKl	ABcDEfGghIjKl	ABcDeFgHiJkL
	aBcDeFGhIjKl	AbCcDeFgHIjKl	AbCdeFgHIJkL	AbcDefGhIJKl	AaBcDefGhIjKL
	AbCdEfgHiJkL	ABcDeFghIiJkL	AbCDefGhIjKl	AbCDeFgHiJkL	aBcDeFFgHiJkL
	aBcdEFgHIjKl	AbCdeFgHIjKL	aBbCdeFgHiJKL	aBcDefGhIjKL	AbCdEfghIjJKL
	aBCdeFgHijKL	aBCdEfGhIjKl	AbCdEFggHIjKl	AbCdEfGHiJkL	aBcdEfGHiJKl
	AbCddEfGhIJKl	AbCdeFgHiJKL	aBcDefgHiJKLl	ABcDefgHiJKl	ABcDeFgHijKL

	aBCdEfGhIijKL	aBcDeFGhIjKl	aBcDEfGhIJkL	aBcdEeFGhIJkL	aBcdEfGhIJKl
	AbCdefGhIJKl	ABcCdefGhIJkL	ABcDefgHiJKl	ABcDeFgHijjKL	AbCDeFgHijKl
	ABcDeFGhIjKl	aBcDeFGgHIjKl	aBcDeFgHIJkL	aBcdEfgHIJkL	AbCddeFgHIjKL
	AbCdefGhIjKL	AbCdEfgHiJkL	AaBCdEfGhiJkL	AbCdEFgHijKl	AbCDeFgHIijKl
	AbCdEfGHiJKl	aBcDeFgHIjKL	aBcdeEfGHiJKL	aBcdeFgHiJKL	aBCdefGhIjKL
	AbCcDefGhIjKL	aBCdEfGhiJkL	aBCdEfGhIjjKL	aBcDEfGhIjKl	AbCdEfGHiJKl
	aBcDefGGhIJKl	AbcdEfGhIJKl	ABcdeFgHiJKL	aBcDdeFgHiJKl	ABcDefGhIjKl
	ABcDEfgHiJkLl	AbCDeFgHiJkL	aBcDeFGhIjKl	AbCdEfGhIJjKl	AbCdeFgHIJkL
	AbcdEfGhIJKl	AbCdeFfGhIjKL	AbCdEfghIJkL	ABcDefGhIjKl	ABbCdEfGhIjKl
	AbCDeFgHiJkL	aBcDeFGhIjjKL	aBcdEFgHIjKl	AbcDeFgHIjKL	aBcDefGgHiJKL

	aBcDefgHIjKL	AbCdEfghIjKL	AbCDdeFgHijKL	aBCdEfGhIjKl	AbCdEFgHiJkLl
	AbCdEfGHiJkL	abCdEfGHiJKl	AbcDeFgHhIjKL	AbCdefGHiJKL	aBcDefgHiJKL
	aBCdeFfgHiJKl	ABcDeFgHijKL	aBCdEfGhIjkL	aBCcDeFGhIjKl	aBcDeFGhIJkL
	abCdEfGHijjKL	AbCdEfGhIJKl	AbCdefGhIJKl	ABcDefgGhIJkL	ABcdEfgHiJKl
	ABcDeFghIjKl	ABcDEeFgHijKl	AbCDeFgHIjKl	aBcDeFGhIJkL	aaBcDeFgHIjKL
	aBcdeFgHIJkL	AbCdefGhIIjKL	AbCdefGhIjKL	AbCdEfgHiJkL	AbCDeFfgHiJkL
	AbCdEFgHijKl	AbCdEFgHiJKl	aBbCdEfGHiJKl	aBcDeFgHIjKL	aBcdeFgHIjjKL
	AbCdeFgHiJKL	aBcDefGhIjKL	AbCdEfggHIjKL	aBCdEfgHiJkL	aBCdEfGhIjKl
	AbCdDEfGhIjKl	AbCdEfGHiJKl	aBcdEfGHiJKl	ABbcdEfGhIJKl	AbCdeFgHiJKL
	aBcDefGhIiJKl	ABcDefGhIjKl	ABcDEfgHiJkL	aBcDEfFgHiJkL	aBcDeFGhIjKl

	AbCdeFGhIJkL	aBbcDeFgHIJkL	aBcdEfGhIJKl	AbCdeFghIJjKL	AbCdeFghIJkL
	ABcDefGhiJKl	ABcDeFggHIjKl	AbCDeFgHiJkL	aBcDeFgHIjKl	AbcDdEFgHIjKl
	AbcDeFgHIjKL	aBcdEfGhIjKL	AaBcdEfgHIjKL	AbCdeFghIjKL	AbCDefGhiIjKL
	aBCdEfGhIjkL	AbCdEFgHiJkL	abCdEFfGHiJkL	abCdEfGHiJKl	AbcDeFgHiJKL
	aBccDefGHiJKL	aBcdEfgHiJKL	aBCdeFghIjjKL	AbCDeFghIjKL	aBCdEfGhIjkL
	aBCdEfGgHIjKl	aBcDeFGhIJkL	abCdEfGHiJKl	AbcDdeFGhIJKl	AbcDefGhIJKl
	ABcdEfgHiJKl	AAbCdEfgHiJkL	ABcDeFghIjKl	ABcDEfGhIijKl	AbCDeFgHIjKl
	aBcDeFGhIJkL	abCdEeFgHIjKL	abCdeFgHIJkL	AbCdefGhIJkL	ABccDefGhIjKL
	AbCdEfgHiJkL	AbCDeFghIjjKL	aBCdEfGhIjKl	AbCdEFgHiJkL	aBcDeFggHIJkL
	aBcDefGHIjKL	abCdeFgHIjKL	AbcDdeFgHiJKL	aBcDefGhIjKL	aBCdEfgHiJkL

	AaBCdEfgHiJkL	aBCdEfGhIjKl	AbCdEFgHiJjKl	AbCdEfGHiJkL	aBcdEfGHiJKl
	AbCdeFfGhIJKl	AbCdeFgHiJKL	aBcDefGhIjKL	aBCcDefGhIjKl	ABcDeFgHiJkL
	aBcDEfGhIjjKL	aBcDeFGhIjKl	AbcDeFGhIJkL	aBcdEfGgHIJkL	aBcdEfGhIJKl
	AbCdeFghIJkL	ABcDeeFghIJkL	AbCDefGhiJKl	ABcDeFgHiJkL	aAbCdEFgHiJkL
	aBcDeFgHIjKl	AbcDeFgHIJjKl	AbcDeFgHIjKL	aBcdEfgHIjKL	AbCdeFfgHIjKL
	AbCdeFghIjKL	AbCdEfGhiJkL	AbCCdEfGhIjkL	AbCdEFgHiJkL	abCdEFgHIjKkL
	abCdEfGHiJKl	AbcDeFgHiJKL	aBcdEfgGhIJKl	ABcdEfgHiJKL	aBCdeFghIjKL
	aBCdEeFghIjKL	aBcDEfGhIjkL	aBCdEfGHiJkL	aaBcDeFGhIJkL	abCdEfGhIJKl
	AbcDefGHiIjKL	AbcDefGhIJKl	ABcdEfgHiJKl	ABcDeFfgHiJkL	ABcDeFghIjKl
	ABcDEfGhiJkL	aBbCDeFgHIjKl	aBcDeFGhIJkL	abCdEfGhIjjKL	AbCdeFgHIJkL

	AbcDefGhIJkL	ABcdEfgHhIjKL	AbCdEfgHiJkL	AbCDeFghIjKl	AbCDdEfGhIjKl
	AbCdEFgHiJkL	aBcDeFgHIjKL	aaBcdEfGHIjKL	abCdeFgHIjKL	AbcDefGhIiJKL
	aBcDefGhIjKL	aBCdEfgHiJkL	aBCDeFfgHiJkL	aBCdEfGhIjKl	AbCdEfGHiJkL
	aBbCdEfGHiJkL	aBcdEfGHiJKl	AbCdeFgHiJjKL	AbCdeFgHiJKL	aBcDefGhiJKl
	ABCdEfgHhiJKl	ABcDeFgHiJkL	aBcDEFghIjKl	AbCdEeFGhIjKl	AbcDeFGhIJkL
	aBcdEfGhIJKl	AaBcdEfGhIJkL	AbCdeFghIJkL	ABcDefGhiIjKL	AbCDefGhiJKl
	AbCDeFgHiJkL	aBcDeFGgHiJkL	abCDeFgHIjKl	AbcDeFgHIJkL	aBccDeFgHIjKL
	aBcdEfgHIjKL	AbCdeFghIJkKL	AbCdeFghIjKL	AbCdEfGhiJkL	AbCDeFgHhIjkL
	AbCdEFgHiJkL	abCdEFgHIjKl	AbcDdEfGHiJKl	AbcDefGHiJKL	aBcdEfgHiJKL
	AbBcdEfgHiJKL	aBCdeFghIjKL	aBCdEfGhiJjKl	ABcDEfGhiJkL	aBCdEfGHiJkl

	AbCdEfFGhIJkL	abCdEfGhIJKl	AbcDefGHiJKL	aBccDefGhIJKl	ABcdEfgHiJKl
	ABcDeFghIjKkL	ABcDeFghIjKl	ABcDeFGhiJkL	aBcDEfGhHiJkL	aBcDeFGhIjKL
	abCdeFGhIJkL	AbcDdeFgHIJkL	AbcDefGhIJkL	AbCdEfgHiJkL	ABbCdEfgHiJkL
	AbCDeFghIjKl	AbCDeFgHiJjKl	AbCdEFgHiJkL	aBcDeFgHIjKL	abCdeFfGHIjKL
	abCdeFgHIjKL	aBcDefGhIjKL	AbCcDefGhIjKL	aBCdEfgHiJkL	aBCdEfGhIjKkL
	aBCdEfGhIjKl	AbCdEfGHiJkL	aBcdEFgHIiJkL	aBcdEfGHiJKl	AbCdeFgHiJKL
	aBcDeeFgHiJKl	ABcDefGhiJKl	ABCdEfgHijKL	aABcDeFgHiJkL	aBcDEfGhIjKl
	AbCdEfGHiJjKl	AbcDeFGhIJkL	aBcdEfGhIJKl	AbCdeFfGhIJkL	AbCdeFghIJkL
	ABcDefGhiJKl	ABcCdEfGhiJKl	AbCDeFgHiJkl	ABcDeFGhIjKkL	abCdEFgHIjKl
	AbcDeFgHIJkL	aBcdEfGgHIjKL	aBcdEfgHIjKL	AbCdeFghIjKL	AbCDeeFghIjKL

	AbCdEfGhiJkL	AbCDeFgHijKl	AaBCdEfGHiJkl	AbCdEFgHIjKl	AbcDeFgHIjjKL
	AbcDefGHiJKL	aBcdEfgHiJKL	AbCdeFfgHiJKL	aBcDeFghIjKL	aBCdEfGhiJkL
	aBCcDEfGhiJkL	aBcDEfGhIJkl	AbCdEfGHiJKlL	abCdEfGhIJKl	AbcDefGhIJKL
	aBcdEfgHhIJKl	ABcdEfgHiJKl	ABcDeFghIjKl	ABCdEeFghIjKl	ABcDeFgHiJkL
	aBcDEfGhIjKl	AaBcDeFGhIjKL	abCdeFGhIJkL	AbcDefGhIJKkL	AbcDefGhIJkL
	AbCdEfgHiJkL	ABcDeFggHiJkL	AbCDeFghIjKl	AbCDeFgHiJkL	aBcCdEFgHiJkL
	aBcDeFgHIjKl	AbCdeFgHIJkL	AabCdeFgHIjKL	aBcDefGhIjKL	AbCdEfgHhIjKL
	aBCdEfgHiJkL	aBCdEfGhIjKl	AbCdEEfGhIjKl	AbCdEfGHiJkL	aBcdEfGHIjKl
	AaBcdEfGHiJKl	AbCdeFgHiJKL	aBcDefGhiIJKl	ABcDefGhiJKl	ABCdeFgHijKL
	aBCdEfGgHiJkL	aBcDEfGhIjKl	AbCdEfGHiJkL	aBccDeFGhIJkL	aBcdEfGhIJKl

	AbCdeFghIJKkL	AbCdefGhIJkL	ABcDefGhiJKl	ABcDeFgHhiJkL	AbCDeFgHijKl
	ABcDeFGhIjKl	aBcDdEFgHIjKl	AbcDeFgHIJkL	aBcdEfGhIJkL	AbBcdeFgHIjKL
	AbCdefGhIjKL	AbCDefGhiJjKL	AbCdEfGhiJkL	AbCDeFgHijKl	AbCDeFfGHiJkl
	AbCdEFgHiJKl	AbcDeFgHIjKL	aBccDefGHiJKL	aBcdeFgHiJKL	aBCdeFghIjKLL
	aBcDeFghIjKL	aBCdEfGhiJkL	aBCdEFgHhiJkL	aBcDEfGhIJkl	AbCdEfGHiJKl
	AbcDdeFGhIJKl	AbcDefGhIJKl	ABcdEfgHiJKL	aBbCdEfgHiJKl	ABcDeFghIjKl
	ABCdEfGhiJjKl	ABcDeFgHiJkL	aBcDeFGhIjKl	AbCdEfGgHIjKL	abCdeFGhIJkL
	AbcDefGhIJKl	ABccDefGhIJkL	AbCdEfgHiJkL	ABcDeFghIjKkL	AbCDefGhIjKl
	AbCDeFgHiJkL	aBcDeFGhIiJkL	aBcdEFgHIjKl	AbCdeFgHIJkL	aBcDeeFgHIjKL
	aBcDefGhIjKL	AbCdEfghIJkL	AaBCdeFgHiJkL	aBCdEfGhIjKl	AbCdEFgHiJjKl

	AbCdEfGHiJkL	aBcdEfGHiJKl	AbCdeFfGHiJKl	AbCdeFgHiJKL	aBcDefgHiJKL
	aBCdDefgHiJKl	ABCdeFgHijKL	aBCdEfGhIjkLL	aBcDEfGhIjKl	AbcDEfGHiJkL
	aBcdEfGHhIJkL	aBcdEfGhIJKl	AbCdefGhIJKl	ABcDeefGhIJkL	ABcDefgHiJKl
	ABcDeFgHijKl	ABbCDeFgHijKl	ABcDeFGhIjKl	aBcDeFGhIJjKl	aBcDeFgHIJkL
	aBcdEfgHIJkL	AbCdefFgHIjKL	AbCdefGhIjKL	AbCdEfgHiJkL	AbCDdEfGhiJkL
	AbCDeFgHijKl	AbCDeFgHIjKll	AbCdEfGHiJKl	aBcDeFgHIjKL	aBcdeFgHHiJKL
	aBcdeFgHiJKL	aBCdefGhIjKL	AbCdEefGhIjKL	aBCdEfGhiJkL	aBcDEfGhIjKl
	AbCcDeFGhIjKl	AbcDeFGhIJkL	aBcdEfGhIJKl	AaBcdEfGhIJKl	AbCdeFghIJkL
	ABcDefGhhIJkL	AbCDefGhiJkL	ABcDeFgHijKl	ABcDEeFgHiJkl	AbCDeFgHIjKl
	AbcDeFGhIJkL	aBbcDeFgHIjKL	aBcdEfgHIjKL	AbCdeFghIiJKL	AbCdeFghIjKL

	AbCdEfGhiJkL	AbCDeFgHhiJkL	aBCdEFgHiJkl	AbCdEFgHIjKl	AbcDdEfGHiJKl
	AbcDefGHiJKL	aBcdEfgHiJKL	AaBcdEfgHiJKL	aBCdeFghIjKL	aBCdEfGhhIjKl
	ABCdEfGhiJkL	aBCdEfGHiJkl	AbCdEeFGhIJkL	abCdEfGHiJKl	AbcDefGHiJKL
	aBbcDefGhIJKl	ABcdEfgHiJKl	ABcDeFghIjJkL	ABcDeFghIjKl	ABcDEfGhiJkL
	aBcDEfGgHiJkL	aBcDeFGhIjKl	AbCdeFGhIJkL	AbcDdeFgHIJkL	AbcDefGhIJkL
	AbCdEfgHiJkL	AAbCdEfgHiJkL	AbCDeFghIjKl	AbCDeFgHiIjKl	AbCdEFgHiJkL
	aBcDeFgHIjKl	AbCdeEfGHIjKl	AbCdeFgHIjKL	aBcDefGhIjKL	AbCcDefGhIjKL
	aBCdEfgHijKL	aBCDeFghIjKkL	aBCdEfGhIjKl	AbCdEFgHiJkL	aBcdEFgGHiJkL
	aBcdEfGHiJKl	AbCdeFgHiJKL	aBcDdeFghIJKL	aBcDefGhiJKl	ABCdEfgHijKLl
	ABcDeFgHijKL	aBcDEfGhIjKl	aBCdEfGHiJjKl	AbcDeFGhIJkL	aBcdEfGhIJKl

	AbCdeFfGhIJkL	AbCdeFghIJkL	ABcDefGhiJKl	ABbCDefGhiJkL	ABcDeFgHijKl
	ABcDeFGhIjKkl	AbCDeFgHIjKl	AbcDeFgHIJkL	aBcdEfGgHIjKL	aBcdEfgHIjKL
	AbCdeFghIjKL	ABcDdeFghIjKL	AbCdEfGhiJkL	AbCDeFgHijKlL	aBCdEFgHiJkl
	AbCdEFgHIjKl	aBcDeFgHIiJKl	AbcDefGHiJKL	aBcdEfgHiJKL	AbCdeFfgHiJKL
	aBcDeFghIjKL	aBCdEfGhiJkL	aBCcDEfGhiJkL	aBCdEfGhIjKl	AbCdEfGHiJKll
	AbCdEfGhIJKl	AbcDefGhIJKl	ABcdEfgGhIJKl	ABcdEfgHiJKl	ABcDeFghIjKl
	ABCdEeFghIjKl	ABcDeFgHiJkL	aBcDEfGhIjKl	AaBcDeFGhIjKl	AbCdeFGhIJkL
	aBcDefGhIJJkL	AbcDefGhIJkL	AbCdEfgHiJkL	ABcDeFfgHiJkL	AbCDeFghIjKl
	AbCDeFgHiJkL	aBbCdEFgHiJkL	aBcDeFgHIjKl	AbCdeFgHIJkKl	AbCdeFgHIjKL
	aBcDefGhIjKL	AbCdEfggHiJKL	aBCdEfgHijKL	aBCDefGhIjkL	AbCDdEfGhIjKl

	AbCdEfGHiJkL	aBcdEfGHIjKl	AaBcdEfGHiJKl	AbCdeFgHiJKL	aBcDefgHhIJKl
	ABcDefgHiJKl	ABCdEfgHijKL	aBCdEfFgHijKl	ABcDEfGhIjKl	aBcDEfGHiJkL
	abBcDeFGhIJkL	aBcdEfGhIJKl	AbCdefGhIJKkL	AbCdefGhIJkL	ABcDefgHiJkL
	ABcDeFgHhiJkL	AbCDeFgHijKl	ABcDeFGhIjkL	aBcDdEFgHIjKl	aBcDeFgHIJkL
	aBcdEfGhIJkL	AaBcdeFgHIjKL	AbCdefGhIjKL	ABcdEfgHhIjKL	AbCdEfGhiJkL
	AbCDeFgHijKl	AbCDeFfGHijKl	AbCdEFgHiJKl	aBcDeFgHIjKL	abCcDefGHiJKL
	aBcdeFgHiJKL	AbCdefGhIjKKL	aBcDefGhIjKL	aBCdEfgHiJkL	aBCdEFggHiJkL
	aBcDEfGhIjKl	AbCdEfGHiJkL	aBcDdeFGhIJkL	aBcdEfGhIJKl	ABcdeFgHiJKL
	aAbCdeFgHiJKl	ABcDefGhIjKl	ABCdEfgHiIjKl	ABcDeFgHiJkL	aBcDEfGhIjKl
	AbCdEeFGhIjKl	AbCdeFGhIJkL	aBcdEfGhIJKl	AbCddEfGhIJkL	AbCdeFgHiJkL

	ABcDefGhIjKl	ABbCDefGhIjKl	AbCDeFgHiJkL	aBcDeFGgHiJkL	aBcdEFgHIjKl
	AbcDeFgHIJkL	aBcdEeFgHIjKL	aBcdEfgHIjKL	AbCdeFghIjKL	AbCCdeFghIjKL
	aBCdEfGhIjkL	AbCDeFgHhIjKl	aBCdEfGHiJkL	abCdEfGHIjKl	AbcDeEfGHiJKl
	AbCdefGHiJKL	aBcDefgHiJKL	aBCddEfgHiJKl	ABCdeFghIjKL	aBCdEfGhIjjKl
	ABcDEfGhIjkL	aBcDEfGHiJkL
					abCdEfFGhIJkL	abCdEfGhIJKl	AbCdefGhIJKl
	ABcDeefGhIJkL	ABcdEfgHiJkL	ABcDeFghIjKl	ABcCDeFgHijKl	ABcDeFGhIjkL
	aBcDeFGgHIjKl	aBcDeFgHIJkL	abCdEfgHIJkL	AbCdeeFgHIjKL	AbCdefGhIjKL
	AbCdEfgHiJkL	ABcDdEfgHiJkL	AbCDeFghIjKl	AbCDeFgHiJkLl	AbCdEFgHiJKl
	aBcDeFgHIjKL	abCdeFfGHiJKL	abCdeFgHiJKL	aBcDefGhIjKL	AbCdEefGhIjKL
	aBCdEfgHiJkL	aBCdEFghIjKl	AbCcDEfGhIjKl	AbCdEfGHiJkL	aBcdEfGHhIJkL
	aBcdEfGhIJKl	AbCdeFgHiJKL	aBcDeeFgHiJKl	ABcDefGhIjKl	ABCdEfgHiJkL
	aBCdDeFgHiJkL	aBcDEfGhIjKl	AbCdEfGhIJkL	aBbcDeFGhIJkL	aBcdEfGhIJKl
	AbCdeFfgHIJkL	AbCdeFghIJkL	ABcDefGhiJkL	ABcDEefGhIjkL	AbCDeFgHiJkL
	aBcDeFGhIjKl	AbbCdEFgHIjKl	AbcDeFgHIJkL	aBcdEfGgHIjKL	aBcdEfgHIjKL
	AbCdeFghIjKL	AbCDeeFghIjKL	aBCdEfGhIjkL	AbCdEFgHiJkl	AbCDdEfGHiJkL
	abCdEfGHiJKl	AbcDeFgHIjKL	aBbcDefGHiJKL	aBcdEfgHiJKL	aBCdeFfgHiJKl
	ABCdeFghIjKl	ABCdEfGhiJkL	aBCdEEfGhIjkL	aBcDEfGHiJkL	abCdEfGHiJKl
	AbcCdEfGhIJKl	AbcDefGhIJKl	ABcdEfgGhIJkL	ABcdEfgHiJkL	ABcDeFghIjKl
	ABcDEfFghIjKl	AbCDeFGhIjkL	aBcDeFGhIJkL	abCdDeFgHIjKL	abCdeFgHIJkL
	AbcDefGhIJkL	ABccDefGhIjKL)
      }
    ]

    #
    # 『唐・日本における進朔に関する研究』(2013-10版)を使用する場合の朔閏表
    #
    Japanese0764 = [PatternTableBasedLuniSolar, {
      'origin_of_MSC'=>764, 'origin_of_LSC'=>2000146,
      'indices'=> [
           When.Index('Japanese::Month', {:branch=>{1=>When.Resource('_m:Calendar::閏')}}),
           When::Coordinates::DefaultDayIndex
       ],
      'before'    => 'Japanese',
      'after'     => 'Japanese',
      'note'      => 'Japanese',
      'rule_table'=> %w(				aBCdEfGhiJkL	aBCdEFgHiJjkL
	aBCdEfGHiJkL	abCdEfGHiJKl	AbcDeFfGHiJKl	AbCdeFghIJKL	aBcdEfgHiJKL
	aBCcDefgHiJKl	ABCdeFgHijKL	aBcDEfGhIjkKL	aBcDEfGhIjkL	AbcDEfGHiJkL
	aBcdEfGHhIJkL	aBcdEfgHIJkL	AbCDefghIJKl	ABcDeefGhIJKL	aBcDefgHiJKL
	aBcDeFgHijKl	AAbCDeFghIjKl	ABcDeFGhIjkL	aBcDeFGhIiJKl	aBcDeFgHIJkL
	aBcdEfgHIjKL	AbCdeeFgHiJKL	aBCdefGhIjKL	AbCdEfgHiJkL	ABcCdEfGhiJkL
	AbCDeFgHijKl	ABcDeFgHIjKkl	AbCdEfGHiJkL	aBcdEfGHiJKL	abCdeFgGHiJKL
	abCdeFgHiJKL	aBcDefGhIjKL	AbCdEefGhiJKL	aBCdEfgHiJkL	aBCdEfGhIjKl

	AaBcDeFGhIjKl	AbcDEfGHiJkL	aBcdEfGHiJJkL	aBcdEfGhIJKl	AbCdeFghIJKL
	aBcDefFghIJKL	aBcDefGhIjKl	ABcDEfgHijKL	aBbCDeFgHiJkL	aBcDeFGhIJkl
	AbcDeFGhIJkLl	AbcDeFgHIJkL	aBcdEfGhIJKl	AbCdeFggHIjKL	AbCdeFghIjKL
	ABcDefGhiJKl	AbCDdEfGhIjkL	AbCDeFgHiJkL	aBcDeFgHIjKl	AabCdEFgHIjKl
	AbcDeFgHIjKL	aBcdEfgHIiJKL	aBcdEfgHIjKL	aBCdeFghIjKL	AbCdEfGghIjKl
	ABCdEfGhiJkL	aBCdEfGHiJkL	AbccDEfGHiJkL	abCdEfGHiJKl	AbcDEfgHiJKLl
	AbcDefGHiJKL	AbcdEfgHiJKL	aBCdeFggHiJKl	ABcDeFghIjKL	aBCdEfGhiJkL
	aBCdEeFGhIjkL	aBcDeFGhIJkL	abCdEfGHiJKl	AabCdeFGhIJKl	AbcDefGhIJKl
	ABcdEfgHiIJkL	ABcdEfgHiJKl	ABcDeFghIjKl	ABcDEfGgHijKl	AbCDeFgHIjKl
	aBcDeFGhIJkL	abCcDeFgHIJkL	abCdeFgHIJkL	AbcDefGhIJkLL	AbcDefGhIjKL

	AbCdEfgHiJkL	AbCDeFghHiJkL	AbCdEFghIjKl	AbCdEFgHiJKL	abcDdEfGHiJKl
	aBcdEfGHIjKL	abCdeFgHIjKL	AbbCdeFgHiJKL	aBcDefGhIjKL	AbCdEfgHiJJkL
	aBCdEfgHiJkL)
      }
    ]
  end
end
