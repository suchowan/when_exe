# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::BasicTypes
  class M17n

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/mk.yml

    Locale_mk =
{"date"=>
  {"abbr_day_names"=>["Нед", "Пон", "Вто", "Сре", "Чет", "Пет", "Саб"],
   "abbr_month_names"=>
    [nil,
     "Јан",
     "Фев",
     "Мар",
     "Апр",
     "Мај",
     "Јун",
     "Јул",
     "Авг",
     "Сеп",
     "Окт",
     "Ное",
     "Дек"],
   "day_names"=>
    ["Недела",
     "Понеделник",
     "Вторник",
     "Среда",
     "Четврток",
     "Петок",
     "Сабота"],
   "formats"=>{"default"=>"%d/%m/%Y", "long"=>"%B %e, %Y", "short"=>"%e %b"},
   "month_names"=>
    [nil,
     "Јануари",
     "Февруари",
     "Март",
     "Април",
     "Мај",
     "Јуни",
     "Јули",
     "Август",
     "Септември",
     "Октомври",
     "Ноември",
     "Декември"],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"АМ",
   "formats"=>
    {"default"=>"%a %b %d %H:%M:%S %Z %Y",
     "long"=>"%B %d, %Y %H:%M",
     "short"=>"%d %b %H:%M",
     "time"=>"%H:%M:%S %Z"},
   "pm"=>"ПМ"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"one"=>"околу %{count} час", "other"=>"околу %{count} часа"},
     "about_x_months"=>
      {"one"=>"околу %{count} месец", "other"=>"околу %{count} месеци"},
     "about_x_years"=>
      {"one"=>"околу %{count} година", "other"=>"околу %{count} години"},
     "almost_x_years"=>
      {"one"=>"скоро %{count} година", "other"=>"скоро %{count} години"},
     "half_a_minute"=>"пола минута",
     "less_than_x_minutes"=>
      {"one"=>"помалку од %{count} минута",
       "other"=>"помалку од %{count} минути"},
     "less_than_x_seconds"=>
      {"one"=>"помалку од %{count} секунда",
       "other"=>"помалку од %{count} секунди"},
     "over_x_years"=>
      {"one"=>"над %{count} година", "other"=>"над %{count} години"},
     "x_days"=>{"one"=>"%{count} ден", "other"=>"%{count} денови"},
     "x_minutes"=>{"one"=>"%{count} минута", "other"=>"%{count} минути"},
     "x_months"=>{"one"=>"%{count} месец", "other"=>"%{count} месеци"},
     "x_seconds"=>{"one"=>"%{count} секунда", "other"=>"%{count} секунди"}},
   "prompts"=>
    {"day"=>"Ден",
     "hour"=>"Час",
     "minute"=>"Минута",
     "month"=>"Месец",
     "second"=>"Секунди",
     "year"=>"Година"}}}
  end
end
