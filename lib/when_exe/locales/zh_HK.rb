# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::BasicTypes
  class M17n

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/zh-HK.yml

    Locale_zh_HK =
{"date"=>
  {"abbr_day_names"=>["日", "一", "二", "三", "四", "五", "六"],
   "abbr_month_names"=>
    [nil,
     "1月",
     "2月",
     "3月",
     "4月",
     "5月",
     "6月",
     "7月",
     "8月",
     "9月",
     "10月",
     "11月",
     "12月"],
   "day_names"=>["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"],
   "formats"=>{"default"=>"%Y-%m-%d", "long"=>"%Y年%b%d日", "short"=>"%b%d日"},
   "month_names"=>
    [nil,
     "一月",
     "二月",
     "三月",
     "四月",
     "五月",
     "六月",
     "七月",
     "八月",
     "九月",
     "十月",
     "十一月",
     "十二月"],
   "order"=>[:year, :month, :day]},
 "time"=>
  {"am"=>"上晝",
   "formats"=>
    {"default"=>"%Y年%b%d號 %A %H:%M:%S %Z",
     "long"=>"%Y年%b%d號 %H:%M",
     "short"=>"%b%d號 %H:%M",
     "time"=>"%H:%M:%S %Z"},
   "pm"=>"下晝"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>{"one"=>"大概一個鐘", "other"=>"大概%{count}個鐘"},
     "about_x_months"=>{"one"=>"大概一個月", "other"=>"大概%{count}個月"},
     "about_x_years"=>{"one"=>"大概一年", "other"=>"大概%{count}年"},
     "almost_x_years"=>{"one"=>"差唔多一年", "other"=>"差唔多%{count}年"},
     "half_a_minute"=>"半分鐘",
     "less_than_x_minutes"=>{"one"=>"唔夠一分鐘", "other"=>"唔夠%{count}分鐘"},
     "less_than_x_seconds"=>{"one"=>"唔夠一秒", "other"=>"唔夠%{count}秒"},
     "over_x_years"=>{"one"=>"超過一年", "other"=>"超過%{count}年"},
     "x_days"=>{"one"=>"一日", "other"=>"%{count}日"},
     "x_minutes"=>{"one"=>"一分鐘", "other"=>"%{count}分鐘"},
     "x_months"=>{"one"=>"一個月", "other"=>"%{count}個月"},
     "x_seconds"=>{"one"=>"一秒", "other"=>"%{count}秒"}},
   "prompts"=>
    {"day"=>"日",
     "hour"=>"點",
     "minute"=>"分",
     "month"=>"月",
     "second"=>"秒",
     "year"=>"年"}}}
  end
end
