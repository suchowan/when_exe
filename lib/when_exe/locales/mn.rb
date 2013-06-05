# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::BasicTypes
  class M17n

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/mn.yml

    Locale_mn =
{"date"=>
  {"abbr_day_names"=>["Ня", "Да", "Мя", "Лх", "Пү", "Ба", "Бя"],
   "abbr_month_names"=>
    [nil,
     "1 сар",
     "2 сар",
     "3 сар",
     "4 сар",
     "5 сар",
     "6 сар",
     "7 сар",
     "8 сар",
     "9 сар",
     "10 сар",
     "11 сар",
     "12 сар"],
   "day_names"=>
    ["Ням", "Даваа", "Мягмар", "Лхагва", "Пүрэв", "Баасан", "Бямба"],
   "formats"=>{"default"=>"%Y-%m-%d", "long"=>"%Y %B %d", "short"=>"%y-%m-%d"},
   "month_names"=>
    [nil,
     "1 сар",
     "2 сар",
     "3 сар",
     "4 сар",
     "5 сар",
     "6 сар",
     "7 сар",
     "8 сар",
     "9 сар",
     "10 сар",
     "11 сар",
     "12 сар"],
   "order"=>[:year, :month, :day]},
 "time"=>
  {"am"=>"өглөө",
   "formats"=>
    {"default"=>"%Y-%m-%d %H:%M",
     "long"=>"%Y %B %d, %H:%M:%S",
     "short"=>"%y-%m-%d",
     "time"=>"%H:%M"},
   "pm"=>"орой"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>{"one"=>"1 цаг орчим", "other"=>"%{count} цаг орчим"},
     "about_x_months"=>{"one"=>"1 сар орчим", "other"=>"%{count} сар орчим"},
     "about_x_years"=>{"one"=>"1 жил орчим", "other"=>"%{count} жил орчим"},
     "almost_x_years"=>{"one"=>"бараг 1 жил", "other"=>"бараг %{count} жил"},
     "half_a_minute"=>"хагас минут",
     "less_than_x_minutes"=>
      {"one"=>"1 минутаас бага", "other"=>"%{count} минутаас бага"},
     "less_than_x_seconds"=>
      {"one"=>"1 секундээс бага", "other"=>"%{count} секундээс бага"},
     "over_x_years"=>{"one"=>"1 жилээс илүү", "other"=>"%{count} жилээс илүү"},
     "x_days"=>{"one"=>"1 өдөр", "other"=>"%{count} өдөр"},
     "x_minutes"=>{"one"=>"1 минут", "other"=>"%{count} минут"},
     "x_months"=>{"one"=>"1 сар", "other"=>"%{count} сар"},
     "x_seconds"=>{"one"=>"1 секунд", "other"=>"%{count} секунд"}},
   "prompts"=>
    {"day"=>"Өдөр",
     "hour"=>"Цаг",
     "minute"=>"Минут",
     "month"=>"Сар",
     "second"=>"Секунд",
     "year"=>"Жил"}}}
  end
end
