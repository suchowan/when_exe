# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::BasicTypes
  class M17n

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/ja.yml

    Locale_ja =
{"date"=>
  {"abbr_day_names"=>["日", "月", "火", "水", "木", "金", "土"],
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
   "day_names"=>["日曜日", "月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日"],
   "formats"=>
    {"default"=>"%Y/%m/%d", "long"=>"%Y年%m月%d日(%a)", "short"=>"%m/%d"},
   "month_names"=>
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
   "order"=>[:year, :month, :day]},
 "time"=>
  {"am"=>"午前",
   "formats"=>
    {"default"=>"%Y/%m/%d %H:%M:%S",
     "long"=>"%Y年%m月%d日(%a) %H時%M分%S秒 %z",
     "short"=>"%y/%m/%d %H:%M",
     "time"=>"%H:%M:%S"},
   "pm"=>"午後"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>{"one"=>"約1時間", "other"=>"約%{count}時間"},
     "about_x_months"=>{"one"=>"約1ヶ月", "other"=>"約%{count}ヶ月"},
     "about_x_years"=>{"one"=>"約1年", "other"=>"約%{count}年"},
     "almost_x_years"=>{"one"=>"1年弱", "other"=>"%{count}年弱"},
     "half_a_minute"=>"30秒前後",
     "less_than_x_minutes"=>{"one"=>"1分以内", "other"=>"%{count}分未満"},
     "less_than_x_seconds"=>{"one"=>"1秒以内", "other"=>"%{count}秒未満"},
     "over_x_years"=>{"one"=>"1年以上", "other"=>"%{count}年以上"},
     "x_days"=>{"one"=>"1日", "other"=>"%{count}日"},
     "x_minutes"=>{"one"=>"1分", "other"=>"%{count}分"},
     "x_months"=>{"one"=>"1ヶ月", "other"=>"%{count}ヶ月"},
     "x_seconds"=>{"one"=>"1秒", "other"=>"%{count}秒"}},
   "prompts"=>
    {"day"=>"日",
     "hour"=>"時",
     "minute"=>"分",
     "month"=>"月",
     "second"=>"秒",
     "year"=>"年"}}}
  end
end
