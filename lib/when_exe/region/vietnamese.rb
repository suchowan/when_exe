# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2013-2015 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

require 'when_exe/region/chinese/calendars'

module When

  class BasicTypes::M17n

    Vietnamese = [self, [
      "locale:[=en:, ja=ja:, zh=zh:, alias]",
      "names:[Vietnam, ベトナム, 越南]"
    ]]

  end

  module CalendarTypes

    _year1884 = {
      'Years'  =>   1,
      'Months' =>  13,
      'Days'   => 385,
      'IDs'    => [1,2,3,4,5, When::Coordinates::Pair.new(5,1),6,7,8,9,10,11,12],
      'Length' => [31,29,29,30, 29, 29, 30, 29, 30, 30, 29, 30, 30],
      'Offset' => [ 0,31,60,89,119,148,177,207,236,266,296,325,355]
    }

    #
    #  ベトナム暦日
    #
    # （参考文献）
    # 岡崎彰「ベトナムの旧暦について」(「天文学史研究会」集録 第２回)
    # Đối chiếu lịch dương với lịch âm dương của Việt nam và Trung quốc 2030 năm (0001-2030)
    #

    # 欽授暦 1544 - 1788
    Vietnamese1544 = [PatternTableBasedLuniSolar, {
      'origin_of_MSC'=>1544, 'origin_of_LSC'=>2285027, 'indices'=> ChineseIndices,
      'before' => 'Chinese0939', 'after' => 'Vietnamese1789', 'note' => 'Chinese',
      'rule_table'=> %w(				AbCdEFgHiJkL	aAbCdEfGHiJKl
	aBcdEfGHIjKL	abCdeFgHIiJKL	abCdeFgHiJKL	aBcDefGhIjKL	AbCdEffGhIjKl

	ABCdEfgHiJkL	aBCdEfGhIjKl	AbCcDEfGhIjKl	AbCdEfGHiJkL	aBcdEfGHiJKkL
	aBcdEfGhIJKl	AbCdeFgHiJKL	aBcDefGghIJKl	ABcDefGhIjKl	ABcDEfgHiJkL
	aBcDEeFgHiJkL	aBcDeFGhIjKl	AbcDeFGhIJkL	aBbcDeFgHIJkL	aBcdEfGhIJKl
	AbCdeFghIJjKL	AbCdeFghIJkL	ABcDefGhiJkL	ABcDeFfGhIjKl	AbCDeFgHiJkL
	abCDeFgHIjKl	AbbCdEfGHIjKl	AbcDeFgHIjKL	aBcdEfgHIjKLL	aBcdEfgHiJKL
	AbCdeFghIjKL	AbCDefGhhIjKL	aBCdEfGhiJkL	aBCdEFgHiJkl	AbCdDEfGHiJkL
	abCdEfGHiJKl	AbcDefGHiJKL	aBbcDefGhIJKL	aBcdEfgHiJKL	aBCdeFghIiJKl
	ABcDeFghIjKl	ABCdEfGhiJkL	aBCdEfFGhIjkL	aBcDeFGhIJkL	abCdEfGHiJKl
	AbcCdeFgHIJKl	AbcDefGhIJKl	ABcdEfgHiJKkL	AbCdEfgHiJkL	ABcDeFghIjKl
	ABcDEfGhhIjKl	AbCDeFgHiJkL	aBcDeFGhIjKL	abCddEFgHIjKL	abCdeFgHIJkL

	AbcDefGhIJkL	ABbcDefGhIjKL	AbCdEfgHiJkL	AbCDeFghIiJkL	aBCdEfGhIjKl
	AbCdEFgHiJkL	aBcDeFfGHiJkL	aBcdEfGHIjKL	abCdeFgHIjKL	aBcCdeFgHiJKL
	aBcDefGhIjKL	AbCdEfgHiJkKl	ABCdEfgHiJkL	aBCdEfGhIjKl	AbCdEFgHhIjKl
	AbcDEFgHiJkL	aBcdEfGHiJKl	AbCddEfGhIJKl	AbCdeFghIJKL	aBcDefGhiJKl
	ABcCDefGhiJKl	ABcDeFgHiJkL	aBcDEfGhIjJkL	aBcDeFGhIjKl	AbcDeFGhIJkL
	aBcdEfFgHIJkL	aBcdEfgHIJKl	AbCdeFghIJkL	ABcDdeFghIJkL	ABcDefGhiJkL
	ABcDeFgHijKkL	AbCDeFgHiJkl	AbCDeFgHIjKl	AbcDeFgHHIjKl	AbcDeFgHIjKL
	aBcdEfgHIjKL	AbCddEfgHiJKL	AbCdeFghIjKL	AbCdEfGhiJkL	AaBCdEfGhiJkL
	aBCdEFgHiJkL	abCdEFgHIjKkL	abCdEfGHiJKl	AbcDefGHiJKL	aBcdEffGhIJKL
	aBcdEfgHiJKL	aBCdeFghIjKL	aBCdDeFghIjKl	ABcDEfGhiJkL	aBCdEfGHiJkkL

	aBcDeFGhIJkL	abCdEfGhIJKl	AbcDefGgHIJkL	AbcDefGhIJKl	ABcdEfgHiJKl
	ABcDeEfgHiJkL	ABcDeFghIjKl	ABcDEfGhiJkL	aAbCDeFgHiJkL	aBcDeFGhIjKl
	AbCdeFGhIJjKL	abCdeFgHIJkL	AbcDefGhIJkL	AbCdEffGhIjKL	AbCdEfgHiJkL
	AbCDeFghIjKl	AbCDdEfGhIjKl	AbCdEFgHiJkL	aBcDeFgHIjKlL	aBcdEfGHIjKl
	AbCdeFgHIjKL	aBcDefGhHiJKL	aBcDefGhIjKL	aBCdEfgHijKL	aBCDeeFgHiJkL
	aBCdEfGhIjKl	AbCdEfGHiJkL	aBbcDeFGHiJkL	aBcdEfGHiJKl	AbCdeFgHiJJKl
	AbCdeFghIJKL	aBcDefGhiJKl	ABCdEffGhiJKl	ABcDeFgHijKL	aBcDEfGhIjKl
	AbCcDeFGhIjKl	AbcDeFGhIJkL	aBcdEfGhIJKl	AaBcdEfgHIJKl	AbCdeFghIJkL
	ABcDefGhhIJkL	AbCDefGhiJkL	AbCDeFgHijKl	ABcDeEFgHiJkl	AbCdEFgHIjKl
	AbcDeFgHIJkL	aBbcDeFgHIjKL	aBcdEfgHIjKL	AbCdeFghIiJKL	AbCdeFghIjKL

	AbCdEfGhiJkL	AbCDeFgGhiJkL	aBCdEfGHiJkl	AbCdEFgHIjKl	aBccDEfGHiJKl
	AbcDefGHiJKL	aBcdEfgHiJKL	AaBcdEfgHiJKL	aBCdeFghIjKL	aBCdEfGhhIjKl
	ABcDEfGhiJkL	aBcDEfGhIjKl	AbCdEeFGhIJkl	AbCdeFGhIJKl	AbcDefGhIJKL
	aBbcDefGhIJKl	ABcdEfgHiJKl	ABcDeFghIjJkL	ABcDeFghIjKl	ABcDeFgHiJkL
	aBcDEfGgHiJkL	aBcDeFGhIjKl	AbCdeFGhIJkL	AbcDdeFgHIJkL	AbcDefGhIJkL
	AbCdEfgHiJkLL	AbCdEfgHiJkL	AbCDefGhIjKl	AbCDeFgHhIjKl	AbCdEFgHiJkL
	aBcdEFgHIjKl	AbCddEfGHIjKl	AbCdeFgHiJKL	aBcDefGhIjKL	AbCcDefGhiJKL
	aBCdEfgHijKL	aBCdEfGhIjKkL	aBCdEfGhIjKl	AbCdEfGHiJkL	aBcdEfGGHiJkL
	aBcdEfGHiJKl	AbCdeFgHiJKL	aBcDdefGhIJKl	ABcDefgHiJKl	ABCdeFgHijKLl
	ABcDeFgHijKl	ABcDEfGhIjKl	aBcDEfGHiIjKl	aBcDeFGhIJkL	aBcdEfGhIJKl

	AbCdeeFgHIJkL	AbCdefGhIJkL	ABcDefgHiJkL	ABbCdEfGhiJkL	AbCDeFgHijKl
	ABcDeFGhIjKkl	AbCdEFgHIjKl	aBcDeFgHIJkL	aBcdEffGHIjKL	aBcdeFgHIjKL
	AbCdefGhIjKL	ABcDdefGhIjKL	AbCdEfGhiJkL	AbCDeFgHijKlL	aBCdEfGHijKl
	AbCdEFgHiJKl	aBcDeFgHIiJKl	AbcDefGHiJKL	aBcdeFgHiJKL	AbCdeeFgHiJKL
	aBcDefGhIjKL	aBCdEfGhiJkL	aBBcDEfGhiJkL	aBcDEfGhIjKl	AbCdEfGHiJKkl
	AbCdeFGhIJKl	AbcDefGhIJKl	ABcdeFfGhIJKl	AbCdeFgHiJKl	ABcDeFghIjKl
	ABCdEefGhIjKl	ABcDeFgHiJkL	aBcDeFGhIjKl	AaBcDeFgHIjKl	AbCdeFgHIJkL
	aBcDefGhIIJkL	aBcDefGhIjKL	AbCdEfgHiJkL)
      }
    ]

    # 西山朝の暦 1789-1801
    Vietnamese1789 = [PatternTableBasedLuniSolar, {
      'origin_of_MSC'=>1789, 'origin_of_LSC'=>2374505, 'indices'=> ChineseIndices,
      'before' => 'Vietnamese1544', 'after' => 'Vietnamese1631', 'note' => 'Chinese',
      'rule_table'=> %w(				ABcDeeFgHiJkL	AbCDefGhIjKl
	AbCDeFgHiJkL	aBcDdEFgHiJkL	aBcdEFgHIjKl	AbcDeFgHIJkL	aBbcDeFgHIjKL
	aBcDefgHIjKL	AbCdEffgHiJKL	aBCdeFghIjKL	aBCdEfGhIjkL	AbCdDEfGhIjKl

	aBCdEfGHiJkL)
      }
    ]

    # 萬全暦 1631-1812
    Vietnamese1631 = [PatternTableBasedLuniSolar, {
      'origin_of_MSC'=>1631, 'origin_of_LSC'=>2316802, 'indices'=> ChineseIndices,
      'before' => 'Vietnamese1544', 'after' => 'Vietnamese1813', 'note' => 'Chinese',
      'rule_table'=> %w(
	ABcDeFgHiJklL	AbCDeFgHiJkL	aBcDeFGhIjKl	AbcDeFGhHIjKl	AbcDeFgHIjKL
	aBcdEfgHIjKL	AbCddEfgHiJKL	AbCdeFghIjKL	AbCDefGhiJkL	AaBCdEfGhIjkL
	AbCdEFgHiJkL	abCdEFgHIjKkL	abCdEfGHiJKl	AbcDeFgHiJKL	aBcdEffGhIJKL
	aBcdEfgHiJKL	aBCdeFghIjKL	aBCdDeFghIjKL	aBCdEfGhIjkL	aBCdEfGHiJKkl

	aBcDeFGhIJkL	abCdEfGHiJKl	AbcDefgGHIJkL	AbcDefGhIJKl	ABcdEfgHiJKl
	ABCdeEfgHiJkL	ABcDeFghIjKl	ABcDEfGhiJkL	AabCDeFgHIjkL	aBcDeFGhIJkL
	abCdEfGhIJjKL	abCdeFgHIJkL	AbcDefGhIJkL	ABcdEffGhIjKL	AbCdEfgHiJkL
	AbCDeFghIjKl	AbCDdEfGhIjKl	AbCdEFgHiJkL	aBcDeFgHIjKlL	aBcdEfGHIjKl
	AbCdeFgHIjKL	aBcDefGhHiJKL	aBcDefGhIjKL	AbCdEfgHiJkL	aBCDefFgHiJkL
	aBCdEfGhIjKl	AbCdEfGHiJkL	aBbCdEfGHiJkL	aBcdEfGHiJKl	AbCdeFgHiJJKl
	AbCdeFghIJKL	aBcDefGhiJKl	ABCdEffGhiJKl	ABcDeFgHijKl	ABcDEfGhIjKl
	aBCdDeFGhIjKl	AbcDeFGhIJkL	aBcdEfGhIJKl	AbCcdEfgHIJkL	AbCdeFghIJkL
	ABcDefGghIjKL	AbCDefGhiJkL	AbCDeFgHijKl	ABcDeEFgHiJkl	AbCDeFgHIjKl
	AbcDeFgHIJkL	aBccDeFgHIjKL	aBcdEfgHIjKL	AbCdeFggHiJKL	AbCdeFghIjKL

	AbCdEfGhiJkL	AbCDeFgGhiJkL	aBCdEfGHiJkl	AbCdEFgHIjKl	aBccDEfGHiJKl
	AbcDefGHiJKL	aBcdEfgHiJKL	AaBcdEfgHiJKL	aBCdeFghIjKL	aBCdEfGhhIjKl
	ABcDEfGhiJkL	aBcDEfGhIjKl	AbCdEeFGhIJkl	AbCdEfGhIJKl	AbcDefGhIJKL
	aBccDefGhIJKl	ABcdEfgHiJKl	ABcDeFghHiJkL	ABcDeFghIjKl	ABcDeFgHiJkL
	aBcDEfFgHiJkL	aBcDeFGhIjKl	AbCdeFGhIJkL	AbcDdeFgHIJkL	aBcDefGhIjKL
	AbCdEfgHiJkLL	AbCdEfgHiJkL	AbCDefGhIjKl	AbCDeFgHhIjKl	AbCdEFgHiJkL
	aBcdEFgHIjKl	AbCddEfGHIjKl	AbCdeFgHiJKL	aBcDefGhIjKL	AbCcDefGhiJKL
	aBCdEfgHijKL	aBCdEfGhIjKkL	aBCdEfGhIjKl	AbCdEfGHiJkL	aBcdEfGGHiJkL
	aBcdEfGHiJKl	AbCdeFgHiJKL	aBcDdefGhIJKl	ABcDefgHiJKl	ABCdEfgHijKLl
	ABcDeFgHijKl	ABcDEfGhIjKl	aBcDEfGHiIjKl	aBcDeFGhIJkL	aBcdEfGhIJKl

	AbCdeeFgHIJkL	AbCdefGhIJkL	ABcDefgHiJkL	ABbCdEfGhiJkL	AbCDeFgHijKl
	ABcDeFGhIjKkl	AbCdEFgHIjKl	aBcDeFgHIJkL	aBcdEffGHIjKL	aBcdeFgHIjKL
	AbCdefGhIjKL	ABcDdefGhIjKL	AbCdEfGhiJkL	AbCDeFgHijKlL	aBCdEfGHijKl
	AbCdEFgHiJKl	aBcDeFgHIiJKl	AbcDefGHiJKL	aBcdeFgHiJKL	AbCdeeFgHiJKL
	aBcDefGhIjKL	aBCdEfGhiJkL	aBBcDEfGhiJkL	aBcDEfGhIjKl	AbCdEfGHiJKkl
	AbCdeFGhIJKl	AbcDefGhIJKl	ABcdeFfGhIJKl	AbCdeFgHiJKl	ABcDeFghIjKl
	ABCdEefGhIjKl	ABcDeFgHiJkL	aBcDeFGhIjKl	AaBcDeFgHIjKl	AbCdeFgHIJkL
	aBcDefGhIIJkL	aBcDefGhIjKL	AbCdEfgHiJkL	ABcDeeFgHiJkL	AbCDefGhIjKl
	AbCDeFgHiJkL	aBbCdEFgHiJkL	aBcdEFgHIjKl	AbcDeFgHIJkKl	AbcDeFgHiJKL
	aBcDefgHIjKL	AbCdEfggHiJKL	aBCdeFghIjKL	aBCdEfGhIjkL	AbCDdEfGhIjKl

	aBCdEfGHiJkL	abCdEfGHIjKl	AabCdEfGHiJKl	AbcDefGHiJKL	aBcDefgHhIJKl
	ABcDefgHiJKl	ABCdeFghIjKL	aBCdEfFgHijKl	ABcDEfGhIjkL	aBcDEfGHiJkL
	abBcDeFGhIJkL	abCdEfGhIJKl)
      }
    ]

    # 協紀暦以降 1813-2030
    Vietnamese1813 = [PatternTableBasedLuniSolarExtended, {
      'origin_of_MSC'=>1813, 'origin_of_LSC'=>2383276, 'indices'=> ChineseIndices,
      'before' => 'Vietnamese1631', 'after' => 'ChineseLuniSolar?time_basis=+07',
      'note'   => 'Chinese',
      'rule_table'=> %w(		AbCdefGhIJKl	ABbCdefGhIJkL	ABcdEfgHiJkL
	ABcDeFfgHiJkL	AbCDeFgHijKl	AbCDeFGhIjkL	aBcDdEFgHIjKl	aBcDeFgHIJkL
	abCdeFgHIJkL	AbCcdeFgHIjKL	AbCdefGhIjKL	AbCdEfgGhIjKL	AbCdEfgHiJkL
	AbCDeFghIjKl	AbCDeEfGhIjKl	AbCdEFgHiJkL	aBcDeFgHIjKL	abCddEfGHiJKL
	abCdeFgHiJKL	aBcDefGhIiJKL	aBcDefGhIjKL	aBCdEfgHiJkL	aBCdEFfgHiJkL
	aBcDEfGhIjKl	AbCdEfGHiJkL	aBcDdeFGhIJkL	aBcdEfGhIJKl	AbCdeFgHiJKL
	aBcCdeFgHiJkL	ABcDefGhIjKl	ABCdEfgGhIjKl	ABcDeFgHiJkL	aBcDEfGhIjKl
	AbCdEeFgHIjKl	AbcDeFgHIJkL	aBcdEfGhIJKl	AbCddEfgHIjKL	AbCdeFghIJkL

	ABcDefGhhIjKL	AbCDefGhIjkL	AbCDeFgHiJkL	aBcDeFGgHiJkL	abCdEFgHIjKl
	AbcDeFgHIJkL	aBcdEeFgHiJKL	aBcdEfgHIjKL	AbCdeFghIjKL	AbCCdeFghIjKL
	aBCdEfGhIjkL	AbCdEFgHhIjkL	aBCdEfGHiJkL	abCdEfGHiJKl	AbcDeEfGHiJKl
	AbcDefGHiJKL	aBcdEfgHiJKL	aBCddEfgHiJKl	ABCdeFghIjKl	ABCdEfGhiJjKl
	ABcDEfGhIjkL	aBcDEfGhIJkL	abCdEfFGhIJkL	abCdEfGhIJKl	AbcDefGhIJKl
	ABcdEefGhIJkL	ABcdEfgHiJkL	ABcDeFghIjKl	ABcCDeFghIjKl	AbCDeFGhIjkL
	aBcDeFGgHIjKl	aBcDeFgHIjKL	abCdeFgHIJkl) + [_year1884] + %w(AbcDefGhIjKL
	AbCdEfgHiJkL	AbCDdEfgHiJkL	AbCDeFghIjKl	AbCDeFgHiJkL	aBbCdEfGHiJkL
	aBcDeFgHIjKL	abCdeFfGHiJKL	abCdeFgHiJKL	aBcDefGhIjKL	AbCdEefGhIjKL
	aBCdEfgHiJkL	aBCdEfGhIjKl	AbCcDEfGhIjKl	AbCdEfGHiJkL	aBcdEfGHhIJkL

	aBcdEfGhIJKl	AbCdeFgHiJKL	aBcDeeFghIJkL	ABcDefGhiJKl	ABcDEfgHiJkL
	aBCdDeFgHiJkL	aBcDeFGhIjKl	AbcDEfGhIJkL	aBbcDeFgHIJkL	aBcdEfGhIJKl
	AbCdeFfgHIjKL	AbCdeFghIJkL	ABcDefGhiJkL	ABcDeEfGhiJkL	AbCDeFgHiJkl
	ABcDeFGhIjKl	AbbCdEFgHIjKl	AbcDeFgHIjKL	aBcdEfgGHiJKL	aBcdEfgHiJKL
	AbCdeFghIjKL	AbCDeeFghIjKL	aBCdEfGhiJkL	aBCdEFgHiJkL	abCdDEfGHiJkL
	abCdEfGHiJKl	AbcDeFgHIjKL	aBbcDefGhIJKL	aBcdEfgHiJKL	aBCdeFfgHiJKl
	ABcDeFghIjKl	ABCdEfGhiJkL	aBCdEEfGhIjkL	aBcDEfGhIJkL	abCdEfGHiJKl
	AbcCdeFGhIJKl	AbcDefGhIJKl	ABcdEfgGhIJkL	ABcdEfgHiJkL	ABcDeFghIjKl
	ABcDEfFghIjKl	AbCDeFgHiJkL	aBcDeFGhIjKl	AbCdDeFgHIjKL	abCdeFgHIJkL
	AbcDefGhIJkL	ABbcDefGhIjKL	AbCdEfgHiJkL	AbCDeFggHiJkL	aBCdEFghIjKl

	AbCDeFgHiJkL	aBcDeEfGHiJkL	aBcdEfGHIjKl	AbCdeFgHIjKL	aBcCdeFgHiJKL
	aBcDefGhIjKL	AbCdEfgHhIjKl	ABCdEfgHiJkL	aBCdEfGhIjKl	AbCdEFfGhIjKl
	AbCdEfGHiJkL	aBcdEfGHiJKl	AbCddEfGhIJKl	AbCdeFgHiJKL	aBcDefGhiJKl
	ABCcDefGhiJKl	ABcDEfgHiJkl	ABcDEfGgHiJkl	ABcDeFGhIjKl	AbcDeFGhIJkL
	aBcdEeFgHIJkL	aBcdEfGhIJkL	AbCdeFghIJkL	ABcDdeFghIjKL	AbCDefGhiJkL
	ABcDeFgHhiJkL	AbCDeFgHiJkl	AbCDeFgHIjKl	aBcDeFFgHIjKl	AbcDeFgHIjKL
	aBcdEfgHIjKL	AbCddEfgHiJKL	AbCdeFghIjKL	AbCdEfGhiJkL	AbBCdEfGhiJkL
	aBCdEFgHijKl	AbCdEFgGHiJkl	AbCdEfGHiJKl	AbcDefGHiJKL	aBcdEefGhIJKL
	aBcdEfgHiJKL	aBCdeFghIjKL	aBCcDeFghIjKl	ABCdEfGhiJkL	aBCdEfGhHiJkL
	aBcDeFGhIjKl	AbCdEfGhIJKl	AbcDeeFGhIJkL	AbcDefGhIJKl	ABcdEfgHiJKl

	ABcDdEfgHiJkL	ABcDeFghIjKl	ABcDEfGhiJkL	aBbCDeFgHiJkL	aBcDeFGhIjKl
	AbCdeFGgHIjKl	AbCdeFgHIJkL	AbcDefGhIjKL	AbCdEefGhIjKL	AbCdEfgHiJkL
	AbCDeFghIjKl	AbCDdEfGhIjKl	AbCdEFgHiJkL	aBcDeFgHIiJkL	aBcdEfGHIjKl
	AbCdeFgHIjKL	aBcDefFgHiJKL	aBcDefGhiJKL	aBCdEfgHijKL	aBCDdEfgHijKL
	aBCdEfGhIjKl	AbCdEFgHiJkL	aBbcDEfGHiJkL	aBcdEfGHiJKl	AbCdeFfGhIJKl
	AbCdeFghIJKl	ABcDefGhiJKl	ABCdEefGhiJKl	ABcDeFgHijKl	ABcDEfGhIjKl)
      }
    ]
  end

  class TM::CalendarEra

    #
    #  ベトナム王位年号一覧表
    #
    # （参考文献）
    # コンサイス世界年表（三省堂）
    # 歴代紀元編（台湾中華書局）
    # wikipedia 元号一覧 (ベトナム)
    #
    Vietnamese = [{'LY'=>{'TT'    => {'A'=>'1072', 'B'=>'1076', 'C'=>'1138',    'D'=>'1140.02', 'E'=>'1224.10'},
                          'VSL'   => {'A'=>'1073', 'B'=>'1075', 'C'=>'1137.09', 'D'=>'1140.01', 'E'=>'1225.06'}},
                   'DN'=>{'KDVNT' => {'Z'=>'Chinese1645',  },
                          'LDNK'  => {'Z'=>'Vietnamese1813'}}}, self, [
      "locale:[=ja:, en=en:, alias]",
      'area:[ベトナム#{?LY=LY}#{&DN=DN}=ja:%%<元号>#%.<ベトナム>,Vietnam#{?LY=LY}#{&DN=DN}=en:Vietnam]',
      [self,
	"period:[前李朝=zh:%%<前李朝>,Early Lý Dynasty]",
	["[天徳=ja:%%<天徳_(前李朝)>,alias:大徳=ja:%%<天徳_(前李朝)>]1","@F","name=[李賁];544.01^Chinese0445", "548.03.21="],
	["[<桃郎王>=zh:%%<李天寶>]1",			"@A","name=[李天宝=zh:%%<李天寶>];548.03.21", "555="],
	["[<趙越王>=zh:%%<趙光復>]1",			"@A","name=[趙光復=zh:%%<趙光復>];548.03.21"],
	["[<後李南帝>=zh:%%<李佛子>]1",			"@A","name=[李仏子=zh:%%<李佛子>];571", "590^Chinese0523", "602="]
      ],
      [self,
	"period:[呉朝,Ngô Dynasty]",
	["[<呉権>]1",			"@F",	 "name=[呉権];939^Chinese0939"],
	["[<平王>=ja:%%<楊三哥>]1",	"@A",  "name=[楊三哥];944"],
	["[<天策王>=ja:%%<呉昌岌>]1",	"@A",  "name=[呉昌岌];951"],
	["[<南晋王>=ja:%%<呉昌文>]1",	"@A",  "name=[呉昌文];954"],
	["[<呉昌熾>]1",			"@A",  "name=[呉昌熾];966", "968"]
      ],
      [self,
	"period:[丁朝,Đinh Dynasty]",
	["[太平=ja:%%<太平_(丁朝)>]1",	"@F",  "name=[丁部領];970^Chinese0939",
				   "name=[衛王=ja:%%<丁セン>];979", "980="]
      ],
      [self,
	"period:[前黎朝,Early Lê dynasty]",
	["[天福=ja:%%<天福_(前黎朝)>]1",	"@F",	 "name=[黎桓];980^Chinese0939"],
	["[興統]1",				"@A",		     "989"],
	["[応天=ja:%%<応天_(前黎朝)>]1",	"",		     "994",
					  "name=[中宗=ja:%%<黎龍鉞>];1005", ""],
	["[景瑞=ja:%%<景瑞_(前黎朝)>,alias:建瑞=ja:%%<景瑞_(前黎朝)>]1","@A","name=[臥朝王=zh:%%<黎龍鋌>];1008", "1009="]
      ],
      [self,
	"period:[李朝,Lý Dynasty]",
	["[順天=ja:%%<順天_(李朝)>]1",	"@F",	"name=[太祖=ja:%%<李公蘊>];1010.01.01^Chinese0939"],
	["[天成=ja:%%<天成_(李朝)>,alias:徳成=ja:%%<天成_(李朝)>]1","@A","name=[太宗=zh:%%<李太宗>];1028.04.01"],
	["[通瑞]1",			"",		    "1034.04"],
	["[乾符有道]1",			"",		    "1039.06"],
	["[明道=ja:%%<明道_(李朝)>]1",	"",		    "1042.10"],
	["[天感聖武]1",			"",		    "1044.10"],
	["[崇興大宝]1",			"",		    "1049.03"],
	["[龍瑞太平]1",	"@A",	  "name=[聖宗=zh:%%<李聖宗>];1054.10"],
	["[彰聖嘉慶]1",			"",		    "1059"],
	["[龍彰天嗣]1",			"",		    "1066"],
	["[天貺宝象,alias:天祝宝象=ja:%%<天貺宝象>]1","",   "1068"],
	["[神武=ja:%%<神武_(李朝)>]1",	"",		    "1069"],
	["[太寧=ja:%%<太寧_(李朝)>,alias:泰寧=ja:%%<太寧_(李朝)>]1","@A",'name=[仁宗=zh:%%<李仁宗>];#{A:1072}'],
	["[英武昭聖=ja:%%<英武昭勝>,alias:英武昭勝=ja:%%<英武昭勝>]1","",'#{B:1076}'],
	["[広祐,alias:広佑=ja:%%<広祐>]1",	"",	    "1085"],
	["[会豊]1",			"",		    "1092"],
	["[龍符,alias:龍符元化=ja:%%<龍符>,alias:乾符=ja:%%<龍符>]1","","1101"],
	["[会祥大慶]1",			"",		    "1110"],
	["[天符睿武]1",			"",		    "1120"],
	["[天符慶寿]1",			"",		    "1127"],
	["[天順=ja:%%<天順_(李朝)>,alias:大順=ja:%%<天順_(李朝)>]1","@A","name=[神宗=zh:%%<李神宗>];1128"],
	["[天彰宝嗣]1",			"",		    "1133.01.01"],
	["[紹明]1",    "@A",  'name=[英宗=zh:%%<李英宗>];#{C:1138}'],
	["[大定=ja:%%<大定_(李朝)>]1",	"",		'#{D:1140.02}'],
	["[政隆宝応]1",			"",		    "1163.01.01"],
	["[天感至宝]1",			"",		    "1174.02"],
	["[貞符,alias:宝符=ja:%%<貞符>]1","@A","name=[高宗=ja:%%<李高宗>];1176"],
	["[天資嘉瑞]1",			"",		    "1186.07"],
	["[天嘉宝祐]1",			"",		    "1202.08"],
	["[治平龍応]1",			"",		    "1205.03"],
	["[建嘉]1",	"@A",	  "name=[恵宗=ja:%%<李恵宗>];1211"],
	["[天彰有道]1","@A",  'name=[昭皇=ja:%%<李昭皇>];#{E:1224.10}', "1225.12.11="]
      ],
      [self,
	"period:[陳朝,Trần Dynasty]",
	["[建中=ja:%%<建中_(陳朝)>]1",	"@F",	"name=[太宗=ja:%%<陳太宗>];1225.12.11^Chinese0939"],
	["[天応政平]1",			"",		    "1232.07.23"],
	["[元豊=ja:%%<元豊_(陳朝)>]1",	"",		    "1251.02"],
	["[紹隆]1",	"@A",	  "name=[聖宗=ja:%%<陳聖宗>];1258.02.24"],
	["[宝符]1",			"",		    "1273.01.01"],
	["[紹宝]1",	"@A",	  "name=[仁宗=ja:%%<陳仁宗>];1279.01"],
	["[重興=ja:%%<重興_(陳朝)>]1",	"",		    "1285.09"],
	["[興隆]1",	"@A",	  "name=[英宗=ja:%%<陳英宗>];1293.03.09"],
	["[大慶=ja:%%<大慶_(陳朝)>]1",	"@A",	"name=[明宗=ja:%%<陳明宗>];1314.03.18"],
	["[開泰=ja:%%<開泰_(陳朝)>]1",	"",		    "1324.01"],
	["[開祐]1",	"@A",	  "name=[憲宗=ja:%%<陳憲宗>];1329.02.15"],
	["[紹豊]1",	"@A",	  "name=[裕宗=ja:%%<陳裕宗>];1341.08.21"],
	["[大治=ja:%%<大治_(陳朝)>,alias:太治=ja:%%<大治_(陳朝)>]1","",	    "1358.01.01"],
	["[大定=ja:%%<大定_(陳朝)>]1",	"@A", "name=[昏徳公=ja:%%<楊日礼>];1369"],
	["[紹慶]1",	"@A",	  "name=[芸宗=ja:%%<陳芸宗>];1370"],
	["[隆慶=ja:%%<隆慶_(陳朝)>]1",	"@A",	"name=[睿宗=ja:%%<陳睿宗>];1373.01.01"],
	["[昌符]1",	"@A",	"name=[廃帝=ja:%%<陳陳ケン>];1377"],
	["[光泰]1",	"@A",	  "name=[順宗=ja:%%<陳順宗>];1388.12"],
	["[建新]1",	"@A",	  "name=[少帝=ja:%%<陳少帝>];1398", "1400="]
      ],
      [self,
	"period:[胡朝,Hồ Dynasty]",
	["[聖元,alias:元聖=ja:%%<聖元>,alias2:天聖=ja:%%<聖元>]1",	"@F", "name=[胡季犛];1400^Chinese0939"],
	["[紹成,alias:紹聖=ja:%%<紹成>]1","@A","name=[胡漢蒼];1401"],
	["[開大]1",		"",		     "1403", "1407="]
      ],
      [self,
	"period:[後陳朝,Later Trần dynasty]",
	["[興慶]1",	"@F", "name=[簡定帝];1407^Chinese0939"],
	["[重光=ja:%%<重光_(陳朝)>,alias:慶元=ja:%%<重光_(陳朝)>]1",	"@A", "name=[重光帝];1409", "1414.03="],
	["[天慶=ja:%%<天慶_(陳朝)>,alias:慶天=ja:%%<天慶_(陳朝)>]1","@A","name=[陳暠=zh:%%<陳暠_(越南君主)>];1426.11","1428.01.10="]
      ],
      [self,
	"period:[前期黎朝=ja:%%<黎朝>#%.<後黎朝前期>,Later Lê Dynasty early period]",
	["[順天=ja:%%<順天_(黎朝)>]1",	"@F",	"name=[太祖=ja:%%<黎利>];1428.04.15^Chinese0939"],
	["[紹平]1",			"@A",	"name=[太宗=ja:%%<黎太宗>];1434"],
	["[大宝=ja:%%<大宝_(黎朝)>]1",	"",				  "1440.01.01"],
	["[太和=ja:%%<大和_(黎朝)>,alias:大和=ja:%%<大和_(黎朝)>]1","@A","name=[仁宗=ja:%%<黎仁宗>];1443"],
	["[延寧]1",			"",				  "1454.01.01"],
	["[天興=ja:%%<天興_(黎朝)>,alias:天与=ja:%%<天興_(黎朝)>]1","@A","name=[廃帝=ja:%%<黎宜民>];1459.10.07"],
	["[光順]1",			"@A",	"name=[聖宗=ja:%%<黎聖宗>];1460.06.08"],
	["[洪徳=ja:%%<洪徳_(黎朝)>]1",	"",				  "1470.01.01"],
	["[景統]1",			"@A",	"name=[憲宗=ja:%%<黎憲宗>];1498"],
	["[泰貞]1",			"@A",	"name=[粛宗=ja:%%<黎粛宗>];1504.06"],
	["[端慶]1",			"@A", "name=[威穆帝];1505"],
	["[洪順=ja:%%<洪順_(黎朝)>]1","@A", "name=[襄翼帝=zh:%%<黎襄翼帝>];1509.12.04"],
	["[光紹]1",			"@A",	"name=[昭宗=zh:%%<黎昭宗>];1516.04.27"],
	["[統元]1",			"@A",	"name=[恭帝=zh:%%<黎恭皇>];1522.08", "1527.06="],
      ],
      [self,
	"period:[莫朝,Mạc dynasty]",
	["[明徳=ja:%%<明徳_(莫朝)>]1",	"@F",	"name=[太祖=ja:%%<莫登庸>];1527.06^Chinese0939"],
	["[大正=ja:%%<大正_(莫朝)>,alias:天正=ja:%%<大正_(莫朝)>,alias2:大政=ja:%%<大正_(莫朝)>]1","@A","name=[太宗=ja:%%<莫登エイ>];1530"],
	["[広和]1",		"@A",	"name=[憲宗=ja:%%<莫福海>];1541", "1544^Vietnamese1544", ""],
	["[永定=ja:%%<永定_(莫朝)>]1",	"@A",	"name=[宣宗=zh:%%<莫宣宗>];1547"],
	["[景暦,alias:景歴=ja:%%<景暦>]1","",				  "1548"],
	["[光宝]1",			"",				  "1554"],
	["[淳福]1",			"@A",	"name=[英宗=zh:%%<莫茂洽>];1562"],
	["[崇康]1",			"",				  "1566"],
	["[延成]1",			"",				  "1578"],
	["[端泰]1",			"",				  "1586"],
	["[興治]1",			"",				  "1588"],
	["[洪寧]1",			"",				  "1591"],
	["[武安]1",			"@A",	  "name=[景宗=zh:%%<莫全>];1592.10", "1593.01="],
	["[宝定]1",			"@A",	"name=[閔宗=zh:%%<莫敬止>];1592.12"],
	["[康佑,alias:康祐=ja:%%<康佑>]1",	"",			  "1593.01"],
	["[乾統=ja:%%<乾統_(莫朝)>]1",	"@A",	"name=[代宗=zh:%%<莫敬恭>];1593", "1625="],
	["[隆泰]1",			"@A",	"name=[光祖=zh:%%<莫敬寬>];1618", "1625="],
	["[順徳=ja:%%<順徳_(莫朝)>]1",	"@A",	"name=[明宗=zh:%%<莫敬宇>];1638", "1677="],
      ],
      [self,
	"period:[後期黎朝=ja:%%<黎朝>#%.<後黎朝後期>,Later Lê Dynasty warlord period]",
	["[元和=ja:%%<元和_(黎朝)>]1",	"@A",	"name=[荘宗=ja:%%<黎荘宗>];1533^Chinese0939", "1544^Vietnamese1544", ""],
	["[順平]1",			"@A",	"name=[中宗=ja:%%<黎中宗>];1549"],
	["[天祐=ja:%%<天祐_(黎朝)>,alias:天佑=ja:%%<天祐_(黎朝)>]1","@A","name=[英宗=zh:%%<黎英宗>];1557"],
	["[正治=ja:%%<正治_(黎朝)>]1",	"",				  "1558.01.01"],
	["[洪福]1",	"",						  "1572.01.01"],
	["[嘉泰=ja:%%<嘉泰_(黎朝)>]1",	"@A",	"name=[世宗=zh:%%<黎世宗>];1573"],
	["[光興=ja:%%<光興_(黎朝)>]1",	"",				  "1578.01.01"],
	["[慎徳]1",			"@A",	"name=[敬宗=zh:%%<黎敬宗>];1600.01"],
	["[弘定]1",			"",				  "1600.11"],
	["[永祚=ja:%%<永祚_(黎朝)>]1",	"@A",	"name=[神宗=zh:%%<黎神宗>];1619.06"],
	["[徳隆]1",			"",				  "1629.04"],
	["[陽和]1",	"",						  "1635.01.01"],
	["[福泰]1",			"@A",	"name=[真宗=zh:%%<黎真宗>];1643"],
	["[慶徳]1",			"@A",	"name=[神宗=zh:%%<黎神宗>];1649"],
	["[盛徳=ja:%%<盛徳_(黎朝)>]1",	"",				  "1653"],
	["[永寿=ja:%%<永寿_(黎朝)>]1",	"",				  "1658.02"],
	["[万慶]1",			"@A",	"name=[玄宗=zh:%%<黎玄宗>];1662"],
	["[景治]1",			"",				  "1663.01.01"],
	["[陽徳]1",			"@A",	"name=[嘉宗=zh:%%<黎嘉宗>];1672"],
	["[徳元]1",			"",				  "1674.10"],
	["[永治=ja:%%<永治_(黎朝)>]1",	"@A",	"name=[熙宗=zh:%%<黎熙宗>];1676"],
	["[正和=ja:%%<正和_(黎朝)>]1",	"",				  "1680.11"],
	["[永盛=ja:%%<永盛_(黎朝)>]1",	"@A",	"name=[裕宗=zh:%%<黎裕宗>];1705"],
	["[保泰]1",			"",				  "1720.01.01"],
	["[永慶]1",			"@A",	"name=[廃帝=zh:%%<黎維祊>];1729"],
	["[龍徳=ja:%%<龍徳_(黎朝)>]1",	"@A",	"name=[純宗=zh:%%<黎純宗>];1732"],
	["[永佑,alias:永祐=ja:%%<永佑>]1","@A", "name=[懿宗=zh:%%<黎懿宗>];1735"],
	["[景興]1",			"@A",	"name=[顕宗=zh:%%<黎顯宗>];1740"],
	["[昭統]1",			"@A", "name=[愍帝=zh:%%<黎昭統帝>];1787", "1789^Vietnamese1789", "1789.10="]
      ],
      [self,
	"period:[西山朝,Tây Sơn Dynasty]",
	[self,
	  "period:[帰仁朝廷=ja:%%<西山朝>#%.<帰仁朝廷>,Quy Nhơn]",
	  ["[泰徳]1",	"@F",      "name=[阮文岳=vi:%%<Nguyễn_Nhạc>];1778^Vietnamese1544"],
	  ["[<太祖>=vi:%%<Nguyễn_Nhạc>]12",	"",		    "1789^Vietnamese1789"],
	  ["[<孝公>=ja:%%<阮文宝>]1",	"@A", "name=[阮文宝];1793", "1798="]
        ],
	[self,
	  "period:[富春朝廷=ja:%%<西山朝>#%.<富春朝廷>,Phú Xuân]",
	  ["[光中]1",	"@A",		   "name=[阮恵,alias:阮光平=];1788^Vietnamese1544", "1789^Vietnamese1789", ""],
	  ["[景盛]1",	"@A", "name=[阮光纉=vi:%%<Nguyễn_Quang_Toản>];1793"],
	  ["[宝興]1",	"",					     "1801", "1802="],
        ]
      ],
      [self,
	"period:[広南=zh:%%<廣南國>,Nguyễn lords]",
	["[<阮潢>]1",			"@A",	  "name=[太祖=ja:%%<阮潢>];1558^Vietnamese1544"],
	["[<阮福源>]1",			"@A",	"name=[熙宗=ja:%%<阮福源>];1613^Vietnamese1544", "1631^Vietnamese1631", ""],
	["[<阮福瀾>]1",			"@A",	"name=[神宗=ja:%%<阮福瀾>];1635.10.11"],
	["[<阮福瀕>=zh:%%<阮福瀕>]0",	"@A",	"name=[太宗=zh:%%<阮福瀕>];1648.02.27"],
	["[<阮福溙>=zh:%%<阮福溱>]0",	"@A",	"name=[英宗=zh:%%<阮福溱>];1687.03.20"],
	["[<阮福淍>=zh:%%<阮福淍>]0",	"@A",	"name=[顕宗=zh:%%<阮福淍>];1691.01.11"],
	["[<阮福澍>]0",			"@A",	"name=[粛宗=ja:%%<阮福澍>];1725.04.22"],
	["[<阮福闊>]0",			"@A",	"name=[世宗=ja:%%<阮福闊>];1738.04.21"],
	["[<阮福淳>]0",			"@A",	"name=[睿宗=ja:%%<阮福淳>];1765.05.21"],
 	["[<阮福暎>=ja:%%<嘉隆帝>]1",	"@A",	"name=[世祖=ja:%%<嘉隆帝>];1778", "1778"]
      ],
      [self,
	"period:[阮朝,Nguyễn Dynasty]",
	["[嘉隆]1",			"@F",	   "name=[世祖=ja:%%<嘉隆帝>];1802.05.02^Vietnamese1631", "1813^Vietnamese1813", ""],
	["[明命]1",			"@A",	   "name=[聖祖=ja:%%<明命帝>];1820"],
	["[紹治]1",			"@A",	   "name=[憲祖=ja:%%<紹治帝>];1841"],
	["[嗣徳]1",			"@A",	   "name=[翼宗=ja:%%<嗣徳帝>];1848", '1849^#{Z:Chinese1645}', "1850^Vietnamese1813", ""],
	["[育徳=ja:%%<育徳帝>]1",	"@A",	   "name=[恭宗=ja:%%<育徳帝>];1883"],
	["[協和=ja:%%<協和帝>]1",	"@A",	   "name=[廃帝=ja:%%<協和帝>];1883"],
	["[建福=ja:%%<建福_(阮朝)>]1",	"@A",	   "name=[簡宗=ja:%%<建福帝>];1884"],
	["[咸宜]1",			"@A",	   "name=[出帝=ja:%%<咸宜帝>];1885.01.01"],
	["[同慶=ja:%%<同慶_(阮朝)>]0.10.01","@A",  "name=[敬宗=ja:%%<同慶帝>];1885.10.01"],
	["[成泰]1",			"@A",    "name=[阮福昭=ja:%%<成泰帝>];1889"],
	["[維新=ja:%%<維新_(阮朝)>]1",	"@A",    "name=[阮福晃=ja:%%<維新帝>];1907"],
	["[啓定]1",			"@A",	   "name=[弘宗=ja:%%<啓定帝>];1916"],
	["[保大=ja:%%<保大_(阮朝)>]1",	"@A","name=[阮福晪=ja:%%<バオ・ダイ>];1926", "1945.09.02=^Gregorian"]
      ]
    ]]
  end
end
