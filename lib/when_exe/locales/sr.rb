# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::BasicTypes
  class M17n

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/sr.yml

    Locale_sr =
{"date"=>
  {"abbr_day_names"=>["Нед", "Пон", "Уто", "Сре", "Чет", "Пет", "Суб"],
   "abbr_month_names"=>
    [nil,
     "Јан",
     "Феб",
     "Мар",
     "Апр",
     "Мај",
     "Јун",
     "Јул",
     "Авг",
     "Сеп",
     "Окт",
     "Нов",
     "Дец"],
   "day_names"=>
    ["Недеља", "Понедељак", "Уторак", "Среда", "Четвртак", "Петак", "Субота"],
   "formats"=>{"default"=>"%d/%m/%Y", "long"=>"%B %e, %Y", "short"=>"%e %b"},
   "month_names"=>
    [nil,
     "Јануар",
     "Фабруар",
     "Март",
     "Април",
     "Мај",
     "Јун",
     "Јул",
     "Август",
     "Септембар",
     "Октобар",
     "Новембар",
     "Децембар"],
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
      {"one"=>"око %{count} сат",
       "few"=>"око %{count} сата",
       "many"=>"око %{count} сати",
       "other"=>"око %{count} сати"},
     "about_x_months"=>
      {"one"=>"око %{count} месец",
       "few"=>"око %{count} месеца",
       "many"=>"око %{count} месеци",
       "other"=>"око %{count} месеци"},
     "about_x_years"=>
      {"one"=>"око %{count} године",
       "few"=>"око %{count} године",
       "many"=>"око %{count} година",
       "other"=>"око %{count} година"},
     "almost_x_years"=>
      {"one"=>"скоро %{count} година",
       "few"=>"скоро %{count} године",
       "many"=>"скоро %{count} година",
       "other"=>"скоро %{count} година"},
     "half_a_minute"=>"пола минуте",
     "less_than_x_minutes"=>
      {"one"=>"мање од %{count} минут",
       "few"=>"мање од %{count} минута",
       "many"=>"мање од %{count} минута",
       "other"=>"мање од %{count} минута"},
     "less_than_x_seconds"=>
      {"few"=>"мање од %{count} секунде",
       "one"=>"мање од %{count} секунд",
       "many"=>"мање од %{count} секунди",
       "other"=>"мање од %{count} секунди"},
     "over_x_years"=>
      {"one"=>"преко %{count} године",
       "few"=>"преко %{count} године",
       "many"=>"преко %{count} година",
       "other"=>"преко %{count} година"},
     "x_days"=>
      {"one"=>"%{count} дан",
       "few"=>"%{count} дана",
       "many"=>"%{count} дана",
       "other"=>"%{count} дана"},
     "x_minutes"=>
      {"one"=>"%{count} минут",
       "few"=>"%{count} минута",
       "many"=>"%{count} минута",
       "other"=>"%{count} минута"},
     "x_months"=>
      {"one"=>"%{count} месец",
       "few"=>"%{count} месеца",
       "many"=>"%{count} месеци",
       "other"=>"%{count} месеци"},
     "x_seconds"=>
      {"one"=>"%{count} секунда",
       "few"=>"%{count} секунде",
       "many"=>"%{count} секунди",
       "other"=>"%{count} секунди"}},
   "prompts"=>
    {"day"=>"Дан",
     "hour"=>"Сат",
     "minute"=>"Минут",
     "month"=>"Месец",
     "second"=>"Секунд",
     "year"=>"Година"}}}
  end
end
