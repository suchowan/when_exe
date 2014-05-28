# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  module Locale

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/uk.yml

    Locale_uk =
{"date"=>
  {"abbr_day_names"=>["нд.", "пн.", "вт.", "ср.", "чт.", "пт.", "сб."],
   "abbr_month_names"=>
    [nil,
     "січ.",
     "лют.",
     "бер.",
     "квіт.",
     "трав.",
     "черв.",
     "лип.",
     "серп.",
     "вер.",
     "жовт.",
     "лист.",
     "груд."],
   "day_names"=>
    ["неділя",
     "понеділок",
     "вівторок",
     "середа",
     "четвер",
     "п'ятниця",
     "субота"],
   "formats"=>{"default"=>"%d.%m.%Y", "long"=>"%d %B %Y", "short"=>"%d %b"},
   "month_names"=>
    [nil,
     "Січня",
     "Лютого",
     "Березня",
     "Квітня",
     "Травня",
     "Червня",
     "Липня",
     "Серпня",
     "Вересня",
     "Жовтня",
     "Листопада",
     "Грудня"],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"до полудня",
   "formats"=>
    {"default"=>"%a, %d %b %Y, %H:%M:%S %z",
     "long"=>"%d %B %Y, %H:%M",
     "short"=>"%d %b, %H:%M",
     "time"=>"%H:%M:%S %z"},
   "pm"=>"по полудні"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"few"=>"близько %{count} години",
       "many"=>"близько %{count} годин",
       "one"=>"близько %{count} година",
       "other"=>"близько %{count} години"},
     "about_x_months"=>
      {"few"=>"близько %{count} місяців",
       "many"=>"близько %{count} місяців",
       "one"=>"близько %{count} місяця",
       "other"=>"близько %{count} місяця"},
     "about_x_years"=>
      {"few"=>"близько %{count} років",
       "many"=>"близько %{count} років",
       "one"=>"близько %{count} року",
       "other"=>"близько %{count} року"},
     "almost_x_years"=>
      {"few"=>"майже %{count} років",
       "many"=>"майже %{count} років",
       "one"=>"майже %{count} роки",
       "other"=>"майже %{count} років"},
     "half_a_minute"=>"півхвилини",
     "less_than_x_minutes"=>
      {"few"=>"менше %{count} хвилин",
       "many"=>"менше %{count} хвилин",
       "one"=>"менше %{count} хвилини",
       "other"=>"менше %{count} хвилини"},
     "less_than_x_seconds"=>
      {"few"=>"менше %{count} секунд",
       "many"=>"менше %{count} секунд",
       "one"=>"менше %{count} секунди",
       "other"=>"менше %{count} секунди"},
     "over_x_years"=>
      {"few"=>"більше %{count} років",
       "many"=>"більше %{count} років",
       "one"=>"більше %{count} року",
       "other"=>"більше %{count} року"},
     "x_days"=>
      {"few"=>"%{count} дні",
       "many"=>"%{count} днів",
       "one"=>"%{count} день",
       "other"=>"%{count} дня"},
     "x_minutes"=>
      {"few"=>"%{count} хвилини",
       "many"=>"%{count} хвилин",
       "one"=>"%{count} хвилина",
       "other"=>"%{count} хвилини"},
     "x_months"=>
      {"few"=>"%{count} місяці",
       "many"=>"%{count} місяців",
       "one"=>"%{count} місяць",
       "other"=>"%{count} місяця"},
     "x_seconds"=>
      {"few"=>"%{count} секунди",
       "many"=>"%{count} секунд",
       "one"=>"%{count} секунда",
       "other"=>"%{count} секунди"}},
   "prompts"=>
    {"day"=>"День",
     "hour"=>"Година",
     "minute"=>"Хвилина",
     "month"=>"Місяць",
     "second"=>"Секунда",
     "year"=>"Рік"}}}
  end
end
