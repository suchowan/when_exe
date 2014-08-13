# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

# Calendar/When/Ruby/2.APIの使用例/7.暦注/七曜

# *準備
# when_exe Ruby 版の When モジュールを include する
require 'pp'
require 'when_exe'
require 'when_exe/mini_application'
include When

# *グレゴリオ暦
# ** 週
date = when?('2013-12-30')
p date.week_included                            #=> 2013-12-30...2014-01-06 (月曜始まり)
p date.week_included('Mon')                     #=> 2013-12-30...2014-01-06 (月曜始まり)
p date.week_included('Sun')                     #=> 2013-12-29...2014-01-05 (日曜始まり)

# ** 月
date = when?('2013-12-30')
p date.month_included                           #=> 2013-12-01...2014-01-01
p date.month_included.map {|date| date[DAY]}    #=> [1,2, (snip), 31]
pp date.month_included('Sun') { |date, type|
    case type                                   #=> [["December 2013",
    when YEAR  ; date.strftime("%Y")            #    ["*",  1,  2,  3,  4,  5,  6,  7],
    when MONTH ; date.strftime("%B %Y")         #    ["*",  8,  9, 10, 11, 12, 13, 14],
    when WEEK  ; '*'                            #    ["*", 15, 16, 17, 18, 19, 20, 21],
    when DAY   ; date[DAY]                      #    ["*", 22, 23, 24, 25, 26, 27, 28],
    else       ; '-'                            #    ["*", 29, 30, 31,"-","-","-","-"]]]
    end                                         #
  }

# ** 年
date = when?('2013-12-30')
p date.year_included                            #=> 2013-01-01...2014-01-01
pp date.year_included('Sun') { |date, type|      #=> (省略)
    When.column(date, type)
  }

# *世界暦
# ** 週
date = when?('2013-12-30^^World')
p date.week_included                            #=> 2013-12-30...2014-01-06 (月曜始まり)
p date.week_included('Mon')                     #=> 2013-12-30...2014-01-06 (月曜始まり)
p date.week_included('Sun')                     #=> 2013-12-29...2014-01-05 (日曜始まり)
p date.week_included('WorldWeek')               #=> 2013-12-24...2014-01-01 (日曜始まりの8日間)

# &yard(When::CalendarTypes::CalendarNote,1)('&yard(WorldWeek)')を使うと、専用の固定曜日を使用

# ** 月
date = when?('2013-12-30^^World')
pp date.month_included('Sun') {|date, type|
    case type                                   #=> [["December 2013",
    when YEAR  ; date.strftime("%Y")            #    ["*",  1,  2,  3,  4,  5,  6,  7],
    when MONTH ; date.strftime("%B %Y")         #    ["*",  8,  9, 10, 11, 12, 13, 14],
    when WEEK  ; '*'                            #    ["*", 15, 16, 17, 18, 19, 20, 21],
    when DAY   ; date[DAY]                      #    ["*", 22, 23, 24, 25, 26, 27, 28],
    else       ; '-'                            #    ["*", 29, 30, 31,"-","-","-","-"]]]
    end                                         #
  }
pp date.month_included('WorldWeek') {|date, type|
    case type                                   #=> [["December 2013",
    when YEAR  ; date.strftime("%Y")            #    ["*","-","-","-","-","-",  1,  2],
    when MONTH ; date.strftime("%B %Y")         #    ["*",  3,  4,  5,  6,  7,  8,  9],
    when WEEK  ; '*'                            #    ["*", 10, 11, 12, 13, 14, 15, 16],
    when DAY   ; date[DAY]                      #    ["*", 17, 18, 19, 20, 21, 22, 23],
    else       ; '-'                            #    ["*", 24, 25, 26, 27, 28, 29, 30, 31]]]
    end                                         # 31日は七曜外
  }

# &yard(CalendarNote)('&yard(WorldWeek)')を使うと、専用の固定曜日を使用

# ** 年
date = when?('2013-12-30^^World')
p date.year_included                            #=> 2013-01-01...2014-01-01
pp date.year_included('Sun') {|date, type|       #=> (省略)
    When.column(date, type)
  }

