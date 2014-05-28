# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  module Locale

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/zh-TW.yml

    Locale_zh_TW =
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
  {"am"=>"上午",
   "formats"=>
    {"default"=>"%Y年%b%d日 %A %H:%M:%S %Z",
     "long"=>"%Y年%b%d日 %H:%M",
     "short"=>"%b%d日 %H:%M",
     "time"=>"%H:%M:%S %Z"},
   "pm"=>"下午"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>{"one"=>"大約一小時", "other"=>"大約 %{count} 小時"},
     "about_x_months"=>{"one"=>"大約一個月", "other"=>"大約 %{count} 個月"},
     "about_x_years"=>{"one"=>"大約一年", "other"=>"大約 %{count} 年"},
     "almost_x_years"=>{"one"=>"接近一年", "other"=>"接近 %{count} 年"},
     "half_a_minute"=>"半分鐘",
     "less_than_x_minutes"=>{"one"=>"不到一分鐘", "other"=>"不到 %{count} 分鐘"},
     "less_than_x_seconds"=>{"one"=>"不到一秒", "other"=>"不到 %{count} 秒"},
     "over_x_years"=>{"one"=>"一年多", "other"=>"%{count} 年多"},
     "x_days"=>{"one"=>"一天", "other"=>"%{count} 天"},
     "x_minutes"=>{"one"=>"一分鐘", "other"=>"%{count} 分鐘"},
     "x_months"=>{"one"=>"一個月", "other"=>"%{count} 個月"},
     "x_seconds"=>{"one"=>"一秒", "other"=>"%{count} 秒"}},
   "prompts"=>
    {"day"=>"日",
     "hour"=>"時",
     "minute"=>"分",
     "month"=>"月",
     "second"=>"秒",
     "year"=>"年"}}}
  end
end
