# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  module Locale

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/pl.yml

    Locale_pl =
{"date"=>
  {"abbr_day_names"=>["nie", "pon", "wto", "śro", "czw", "pią", "sob"],
   "abbr_month_names"=>
    [nil,
     "sty",
     "lut",
     "mar",
     "kwi",
     "maj",
     "cze",
     "lip",
     "sie",
     "wrz",
     "paź",
     "lis",
     "gru"],
   "day_names"=>
    ["niedziela",
     "poniedziałek",
     "wtorek",
     "środa",
     "czwartek",
     "piątek",
     "sobota"],
   "formats"=>{"default"=>"%d-%m-%Y", "long"=>"%B %d, %Y", "short"=>"%d %b"},
   "month_names"=>
    [nil,
     "styczeń",
     "luty",
     "marzec",
     "kwiecień",
     "maj",
     "czerwiec",
     "lipiec",
     "sierpień",
     "wrzesień",
     "październik",
     "listopad",
     "grudzień"],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"przed południem",
   "formats"=>
    {"default"=>"%a, %d %b %Y %H:%M:%S %z",
     "long"=>"%B %d, %Y %H:%M",
     "short"=>"%d %b %H:%M",
     "time"=>"%H:%M:%S %z"},
   "pm"=>"po południu"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"few"=>"około %{count} godziny",
       "one"=>"około godziny",
       "other"=>"około %{count} godzin",
       "many"=>"około %{count} godzin"},
     "about_x_months"=>
      {"few"=>"około %{count} miesiące",
       "one"=>"około miesiąca",
       "other"=>"około %{count} miesięcy",
       "many"=>"około %{count} miesięcy"},
     "about_x_years"=>
      {"few"=>"około %{count} lata",
       "one"=>"około rok",
       "other"=>"około %{count} lat",
       "many"=>"około %{count} lat"},
     "almost_x_years"=>
      {"few"=>"prawie %{count} lata",
       "one"=>"prawie rok",
       "other"=>"prawie %{count} lat",
       "many"=>"prawie %{count} lat"},
     "half_a_minute"=>"pół minuty",
     "less_than_x_minutes"=>
      {"few"=>"mniej niż %{count} minuty",
       "one"=>"mniej niż minutę",
       "other"=>"mniej niż %{count} minut",
       "many"=>"mniej niż %{count} minut"},
     "less_than_x_seconds"=>
      {"few"=>"mniej niż %{count} sekundy",
       "one"=>"mniej niż sekundę",
       "other"=>"mniej niż %{count} sekund",
       "many"=>"mniej niż %{count} sekund"},
     "over_x_years"=>
      {"few"=>"ponad %{count} lata",
       "one"=>"ponad rok",
       "other"=>"ponad %{count} lat",
       "many"=>"ponad %{count} lat"},
     "x_days"=>
      {"few"=>"%{count} dni",
       "one"=>"1 dzień",
       "other"=>"%{count} dni",
       "many"=>"%{count} dni"},
     "x_minutes"=>
      {"few"=>"%{count} minuty",
       "one"=>"1 minuta",
       "other"=>"%{count} minut",
       "many"=>"%{count} minut"},
     "x_months"=>
      {"few"=>"%{count} miesiące",
       "one"=>"1 miesiąc",
       "other"=>"%{count} miesięcy",
       "many"=>"%{count} miesięcy"},
     "x_seconds"=>
      {"few"=>"%{count} sekundy",
       "one"=>"1 sekunda",
       "other"=>"%{count} sekund",
       "many"=>"%{count} sekund"}},
   "prompts"=>
    {"day"=>"Dzień",
     "hour"=>"Godzina",
     "minute"=>"Minuta",
     "month"=>"Miesiąc",
     "second"=>"Sekundy",
     "year"=>"Rok"}}}
  end
end
