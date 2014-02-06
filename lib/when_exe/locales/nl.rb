# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::BasicTypes
  class M17n

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/nl.yml

    Locale_nl =
{"date"=>
  {"abbr_day_names"=>["zo", "ma", "di", "wo", "do", "vr", "za"],
   "abbr_month_names"=>
    [nil,
     "jan",
     "feb",
     "mar",
     "apr",
     "mei",
     "jun",
     "jul",
     "aug",
     "sep",
     "okt",
     "nov",
     "dec"],
   "day_names"=>
    ["zondag",
     "maandag",
     "dinsdag",
     "woensdag",
     "donderdag",
     "vrijdag",
     "zaterdag"],
   "formats"=>{"default"=>"%d-%m-%Y", "long"=>"%e %B %Y", "short"=>"%e %b"},
   "month_names"=>
    [nil,
     "januari",
     "februari",
     "maart",
     "april",
     "mei",
     "juni",
     "juli",
     "augustus",
     "september",
     "oktober",
     "november",
     "december"],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"'s ochtends",
   "formats"=>
    {"default"=>"%a %d %b %Y %H:%M:%S %Z",
     "long"=>"%d %B %Y %H:%M",
     "short"=>"%d %b %H:%M",
     "time"=>"%H:%M:%S %Z"},
   "pm"=>"'s middags"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"one"=>"ongeveer een uur", "other"=>"ongeveer %{count} uur"},
     "about_x_months"=>
      {"one"=>"ongeveer een maand", "other"=>"ongeveer %{count} maanden"},
     "about_x_years"=>
      {"one"=>"ongeveer een jaar", "other"=>"ongeveer %{count} jaar"},
     "almost_x_years"=>
      {"one"=>"bijna een jaar", "other"=>"bijna %{count} jaar"},
     "half_a_minute"=>"een halve minuut",
     "less_than_x_minutes"=>
      {"one"=>"minder dan een minuut", "other"=>"minder dan %{count} minuten"},
     "less_than_x_seconds"=>
      {"one"=>"minder dan een seconde",
       "other"=>"minder dan %{count} seconden"},
     "over_x_years"=>
      {"one"=>"meer dan een jaar", "other"=>"meer dan %{count} jaar"},
     "x_days"=>{"one"=>"1 dag", "other"=>"%{count} dagen"},
     "x_minutes"=>{"one"=>"1 minuut", "other"=>"%{count} minuten"},
     "x_months"=>{"one"=>"1 maand", "other"=>"%{count} maanden"},
     "x_seconds"=>{"one"=>"1 seconde", "other"=>"%{count} seconden"}},
   "prompts"=>
    {"day"=>"dag",
     "hour"=>"uur",
     "minute"=>"minuut",
     "month"=>"maand",
     "second"=>"seconde",
     "year"=>"jaar"}}}
  end
end
