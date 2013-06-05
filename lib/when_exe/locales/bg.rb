# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::BasicTypes
  class M17n

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/bg.yml

    Locale_bg =
{"date"=>
  {"abbr_day_names"=>["нед", "пон", "вт", "ср", "чет", "пет", "съб"],
   "abbr_month_names"=>
    [nil,
     "яну.",
     "фев.",
     "март",
     "апр.",
     "май",
     "юни",
     "юли",
     "авг.",
     "сеп.",
     "окт.",
     "ноем.",
     "дек."],
   "day_names"=>
    ["неделя",
     "понеделник",
     "вторник",
     "сряда",
     "четвъртък",
     "петък",
     "събота"],
   "formats"=>{"default"=>"%d.%m.%Y", "long"=>"%d %B %Y", "short"=>"%d %b"},
   "month_names"=>
    [nil,
     "януари",
     "февруари",
     "март",
     "април",
     "май",
     "юни",
     "юли",
     "август",
     "септември",
     "октомври",
     "ноември",
     "декември"],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"преди обяд",
   "formats"=>
    {"default"=>"%a, %d %b %Y, %H:%M:%S %z",
     "long"=>"%d %B %Y, %H:%M",
     "short"=>"%d %b, %H:%M",
     "time"=>"%H:%M:%S %z"},
   "pm"=>"следобед"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>{"one"=>"около 1 час", "other"=>"около %{count} часа"},
     "about_x_months"=>
      {"one"=>"около 1 месец", "other"=>"около %{count} месеца"},
     "about_x_years"=>
      {"one"=>"около 1 година", "other"=>"около %{count} години"},
     "almost_x_years"=>
      {"one"=>"почти 1 година", "other"=>"почти %{count} години"},
     "half_a_minute"=>"половин минута",
     "less_than_x_minutes"=>
      {"one"=>"по-малко от 1 минута", "other"=>"по-малко от %{count} минути"},
     "less_than_x_seconds"=>
      {"one"=>"по-малко от 1 секунда",
       "other"=>"по-малко от %{count} секунди"},
     "over_x_years"=>{"one"=>"над 1 година", "other"=>"над %{count} години"},
     "x_days"=>{"one"=>"1 ден", "other"=>"%{count} дни"},
     "x_minutes"=>{"one"=>"1 минута", "other"=>"%{count} минути"},
     "x_months"=>{"one"=>"1 месец", "other"=>"%{count} месеца"},
     "x_seconds"=>{"one"=>"1 секунда", "other"=>"%{count} секунди"}},
   "prompts"=>
    {"day"=>"Ден",
     "hour"=>"Час",
     "minute"=>"Минута",
     "month"=>"Месец",
     "second"=>"Секунда",
     "year"=>"Година"}}}
  end
end
