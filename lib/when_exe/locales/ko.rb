# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::BasicTypes
  class M17n

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/ko.yml

    Locale_ko =
{"date"=>
  {"abbr_day_names"=>["일", "월", "화", "수", "목", "금", "토"],
   "abbr_month_names"=>
    [nil,
     "1월",
     "2월",
     "3월",
     "4월",
     "5월",
     "6월",
     "7월",
     "8월",
     "9월",
     "10월",
     "11월",
     "12월"],
   "day_names"=>["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"],
   "formats"=>
    {"default"=>"%Y/%m/%d", "long"=>"%Y년 %m월 %d일 (%a)", "short"=>"%m/%d"},
   "month_names"=>
    [nil,
     "1월",
     "2월",
     "3월",
     "4월",
     "5월",
     "6월",
     "7월",
     "8월",
     "9월",
     "10월",
     "11월",
     "12월"],
   "order"=>[:year, :month, :day]},
 "time"=>
  {"am"=>"오전",
   "formats"=>
    {"default"=>"%Y/%m/%d %H:%M:%S",
     "long"=>"%Y년 %B월 %d일, %H시 %M분 %S초 %Z",
     "short"=>"%y/%m/%d %H:%M",
     "time"=>"%H:%M:%S"},
   "pm"=>"오후"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>{"one"=>"약 한 시간", "other"=>"약 %{count}시간"},
     "about_x_months"=>{"one"=>"약 한 달", "other"=>"약 %{count}달"},
     "about_x_years"=>{"one"=>"약 일 년", "other"=>"약 %{count}년"},
     "almost_x_years"=>{"one"=>"일 년 이하", "other"=>"%{count}년 이하"},
     "half_a_minute"=>"30초",
     "less_than_x_minutes"=>{"one"=>"일 분 이하", "other"=>"%{count}분 이하"},
     "less_than_x_seconds"=>{"one"=>"일 초 이하", "other"=>"%{count}초 이하"},
     "over_x_years"=>{"one"=>"일 년 이상", "other"=>"%{count}년 이상"},
     "x_days"=>{"one"=>"하루", "other"=>"%{count}일"},
     "x_minutes"=>{"one"=>"일 분", "other"=>"%{count}분"},
     "x_months"=>{"one"=>"한 달", "other"=>"%{count}달"},
     "x_seconds"=>{"one"=>"일 초", "other"=>"%{count}초"}},
   "prompts"=>
    {"day"=>"일",
     "hour"=>"시",
     "minute"=>"분",
     "month"=>"월",
     "second"=>"초",
     "year"=>"년"}}}
  end
end
