# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

# Calendar/When/Ruby/2.APIの使用例/8.多言語対応文字列

# →関連クラス図 [[Calendar/When/Ruby/3.クラス図/02.BasicTypes]]

# *準備
require 'when_exe'
include When

# コア拡張を利用する場合は[[Calendar/When/Ruby/2.APIの使用例/8.多言語対応文字列/コア拡張]]を参照

# * グレゴリオ暦
gregorian = M17n('Christian::Gregorian')
p gregorian.iri                             #=> "http://hosi.org/When/BasicTypes/M17n/Christian::Gregorian"
p gregorian.translate('ja')                 #=> "グレゴリオ暦"
p gregorian.translate('en')                 #=> "Gregorian"
p gregorian.translate('fr')                 #=> "Gregorian" (未定義でデフォルト使用)
p gregorian/'ja'                            #=> "グレゴリオ暦"
p gregorian/'en'                            #=> "Gregorian"
p gregorian/'fr'                            #=> "Gregorian" (未定義でデフォルト使用)
p gregorian.reference('ja')                 #=> "https://ja.wikipedia.org/wiki/%E3%82%B0%E3%83%AC%E3%82%B4%E3%83%AA%E3%82%AA%E6%9A%A6"
p gregorian.reference('en')                 #=> "https://en.wikipedia.org/wiki/Gregorian_calendar"
p gregorian.reference('fr')                 #=> "https://en.wikipedia.org/wiki/Gregorian_calendar" (未定義でデフォルト使用)
p Calendar('Gregorian').label.iri           #=> "http://hosi.org/When/BasicTypes/M17n/Christian::Gregorian" (同じIRIのオブジェクト)

# * 一月
january = MonthName('Jan')
p january.iri                               #=> "http://hosi.org/When/BasicTypes/M17n/Calendar::Month::January"
p january.translate('ja')                   #=> "1月"
p january.translate('en')                   #=> "January"
p january.translate('fr')                   #=> "janvier"
p january/'ja'                              #=> "1月"
p january/'en'                              #=> "January"
p january/'fr'                              #=> "janvier"
p january.reference('ja')                   #=> "https://ja.wikipedia.org/wiki/1%E6%9C%88"
p january.reference('en')                   #=> "https://en.wikipedia.org/wiki/January"
p january.reference('fr')                   #=> "https://en.wikipedia.org/wiki/January" (未定義でデフォルト使用)
p MonthName('1月').iri                      #=> "http://hosi.org/When/BasicTypes/M17n/Calendar::Month::January" (同じIRIのオブジェクト)
p M17n('Calendar::Month::January').iri #=> "http://hosi.org/When/BasicTypes/M17n/Calendar::Month::January" (同じIRIのオブジェクト)

# * 日時書式
format = M17n('CalendarFormats::DateTime')
p format.iri                                #=> "http://hosi.org/When/BasicTypes/M17n/CalendarFormats::DateTime"
p format.translate('ja')                    #=> "%Y/%m/%d %H:%M:%S"
p format.translate('en')                    #=> "%a, %d %b %Y %H:%M:%S %z"
p format.translate('fr')                    #=> "%d %B %Y %H:%M:%S"
p format/'ja'                               #=> "%Y/%m/%d %H:%M:%S"
p format/'en'                               #=> "%a, %d %b %Y %H:%M:%S %z"
p format/'fr'                               #=> "%d %B %Y %H:%M:%S"
time = tm_pos(2013, 5, 29, 8, 39, 34, :clock=>'+09:00').strftime(format)
p time.translate('ja')                      #=> "2013/05/29 08:39:34"
p time.translate('en')                      #=> "Wed, 29 May 2013 08:39:34 +0900"
p time.translate('fr')                      #=> "29 mai 2013 08:39:34"
p time/'ja'                                 #=> "2013/05/29 08:39:34"
p time/'en'                                 #=> "Wed, 29 May 2013 08:39:34 +0900"
p time/'fr'                                 #=> "29 mai 2013 08:39:34"
