# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::BasicTypes
  class M17n

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/ru.yml

    Locale_ru =
{"date"=>
  {"abbr_day_names"=>["Вс", "Пн", "Вт", "Ср", "Чт", "Пт", "Сб"],
   "abbr_month_names"=>
    [nil,
     "янв.",
     "февр.",
     "марта",
     "апр.",
     "мая",
     "июня",
     "июля",
     "авг.",
     "сент.",
     "окт.",
     "нояб.",
     "дек."],
   "day_names"=>
    ["воскресенье",
     "понедельник",
     "вторник",
     "среда",
     "четверг",
     "пятница",
     "суббота"],
   "formats"=>{"default"=>"%d.%m.%Y", "long"=>"%-d %B %Y", "short"=>"%-d %b"},
   "month_names"=>
    [nil,
     "января",
     "февраля",
     "марта",
     "апреля",
     "мая",
     "июня",
     "июля",
     "августа",
     "сентября",
     "октября",
     "ноября",
     "декабря"],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"утра",
   "formats"=>
    {"default"=>"%a, %d %b %Y, %H:%M:%S %z",
     "long"=>"%d %B %Y, %H:%M",
     "short"=>"%d %b, %H:%M",
     "time"=>"%H:%M:%S %z"},
   "pm"=>"вечера"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"few"=>"около %{count} часов",
       "many"=>"около %{count} часов",
       "one"=>"около %{count} часа",
       "other"=>"около %{count} часа"},
     "about_x_months"=>
      {"few"=>"около %{count} месяцев",
       "many"=>"около %{count} месяцев",
       "one"=>"около %{count} месяца",
       "other"=>"около %{count} месяца"},
     "about_x_years"=>
      {"few"=>"около %{count} лет",
       "many"=>"около %{count} лет",
       "one"=>"около %{count} года",
       "other"=>"около %{count} лет"},
     "almost_x_years"=>
      {"one"=>"почти 1 год",
       "few"=>"почти %{count} года",
       "many"=>"почти %{count} лет",
       "other"=>"почти %{count} лет"},
     "half_a_minute"=>"меньше минуты",
     "less_than_x_minutes"=>
      {"few"=>"меньше %{count} минут",
       "many"=>"меньше %{count} минут",
       "one"=>"меньше %{count} минуты",
       "other"=>"меньше %{count} минуты"},
     "less_than_x_seconds"=>
      {"few"=>"меньше %{count} секунд",
       "many"=>"меньше %{count} секунд",
       "one"=>"меньше %{count} секунды",
       "other"=>"меньше %{count} секунды"},
     "over_x_years"=>
      {"few"=>"больше %{count} лет",
       "many"=>"больше %{count} лет",
       "one"=>"больше %{count} года",
       "other"=>"больше %{count} лет"},
     "x_days"=>
      {"few"=>"%{count} дня",
       "many"=>"%{count} дней",
       "one"=>"%{count} день",
       "other"=>"%{count} дня"},
     "x_minutes"=>
      {"few"=>"%{count} минуты",
       "many"=>"%{count} минут",
       "one"=>"%{count} минуту",
       "other"=>"%{count} минуты"},
     "x_months"=>
      {"few"=>"%{count} месяца",
       "many"=>"%{count} месяцев",
       "one"=>"%{count} месяц",
       "other"=>"%{count} месяца"},
     "x_seconds"=>
      {"few"=>"%{count} секунды",
       "many"=>"%{count} секунд",
       "one"=>"%{count} секундy",
       "other"=>"%{count} секунды"}},
   "prompts"=>
    {"day"=>"День",
     "hour"=>"Часов",
     "minute"=>"Минут",
     "month"=>"Месяц",
     "second"=>"Секунд",
     "year"=>"Год"}}}
  end
end
