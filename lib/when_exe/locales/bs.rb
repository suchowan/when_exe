# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  module Locale

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/bs.yml

    Locale_bs =
{"date"=>
  {"abbr_day_names"=>["ned", "pon", "uto", "sri", "čet", "pet", "sub"],
   "abbr_month_names"=>
    [nil,
     "jan",
     "feb",
     "mar",
     "apr",
     "maj",
     "jun",
     "jul",
     "aug",
     "sep",
     "okt",
     "nov",
     "dec"],
   "day_names"=>
    ["nedjelja", "ponedjeljak", "utorak", "srijeda", "četvrtak", "petak"],
   "formats"=>
    {"default"=>"%d.%m.%Y.", "long"=>"%e. %B %Y.", "short"=>"%e. %b. %Y."},
   "month_names"=>
    [nil,
     "januar",
     "februar",
     "mart",
     "april",
     "maj",
     "juni",
     "juli",
     "august",
     "septembar",
     "oktobar",
     "novembar",
     "decembar"],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"",
   "formats"=>
    {"default"=>"%H:%M:%S",
     "long"=>"%d. %B %Y. - %H:%M:%S",
     "short"=>"%d. %b %Y. %H:%M",
     "time"=>"%H:%M:%S"},
   "pm"=>""},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"few"=>"oko %{count} sata",
       "many"=>"oko %{count} sati",
       "one"=>"oko sat",
       "other"=>"oko %{count} sati"},
     "about_x_months"=>
      {"few"=>"oko %{count} mjeseca",
       "many"=>"oko %{count} mjeseci",
       "one"=>"oko mjesec",
       "other"=>"oko %{count} mjeseci"},
     "about_x_years"=>
      {"few"=>"oko %{count} godine",
       "many"=>"oko %{count} godina",
       "one"=>"oko godine",
       "other"=>"oko %{count} godina"},
     "almost_x_years"=>
      {"few"=>"skoro %{count} godine",
       "many"=>"skoro %{count} godina",
       "one"=>"skoro 1 godina",
       "other"=>"skoro %{count} godina"},
     "half_a_minute"=>"pola minute",
     "less_than_x_minutes"=>
      {"few"=>"manje od %{count} minute",
       "many"=>"manje od %{count} minuta",
       "one"=>"manje od minute",
       "other"=>"manje od %{count} minuta"},
     "less_than_x_seconds"=>
      {"few"=>"manje od %{count} sekunde",
       "many"=>"manje od %{count} sekundi",
       "one"=>"manje od sekunde",
       "other"=>"manje od %{count} sekundi"},
     "over_x_years"=>
      {"few"=>"preko %{count} godine",
       "many"=>"preko %{count} godina",
       "one"=>"preko godine",
       "other"=>"preko %{count} godina"},
     "x_days"=>
      {"few"=>"%{count} dana",
       "many"=>"%{count} dana",
       "one"=>"1 dan",
       "other"=>"%{count} dana"},
     "x_minutes"=>
      {"few"=>"%{count} minute",
       "many"=>"%{count} minuta",
       "one"=>"1 minut",
       "other"=>"%{count} minuta"},
     "x_months"=>
      {"few"=>"%{count} mjeseca",
       "many"=>"%{count} mjeseci",
       "one"=>"1 mjesec",
       "other"=>"%{count} mjeseci"},
     "x_seconds"=>
      {"few"=>"%{count} sekunde",
       "many"=>"%{count} sekundi",
       "one"=>"1 sekund",
       "other"=>"%{count} sekundi"}},
   "prompts"=>
    {"day"=>"dan",
     "hour"=>"sat",
     "minute"=>"minut",
     "month"=>"mjesec",
     "second"=>"sekundi",
     "year"=>"godina"}}}
  end
end
