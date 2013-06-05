# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::BasicTypes
  class M17n

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/lt.yml

    Locale_lt =
{"date"=>
  {"abbr_day_names"=>["Sek", "Pir", "Ant", "Tre", "Ket", "Pen", "Šeš"],
   "abbr_month_names"=>
    [nil,
     "Sau",
     "Vas",
     "Kov",
     "Bal",
     "Geg",
     "Bir",
     "Lie",
     "Rgp",
     "Rgs",
     "Spa",
     "Lap",
     "Grd"],
   "day_names"=>
    ["sekmadienis",
     "pirmadienis",
     "antradienis",
     "trečiadienis",
     "ketvirtadienis",
     "penktadienis",
     "šeštadienis"],
   "formats"=>{"default"=>"%Y-%m-%d", "long"=>"%B %d, %Y", "short"=>"%b %d"},
   "month_names"=>
    [nil,
     "sausio",
     "vasario",
     "kovo",
     "balandžio",
     "gegužės",
     "birželio",
     "liepos",
     "rugpjūčio",
     "rugsėjo",
     "spalio",
     "lapkričio",
     "gruodžio"],
   "order"=>[:year, :month, :day]},
 "time"=>
  {"am"=>"am",
   "formats"=>
    {"default"=>"%a, %d %b %Y %H:%M:%S %z",
     "long"=>"%B %d, %Y %H:%M",
     "short"=>"%d %b %H:%M",
     "time"=>"%H:%M:%S %z"},
   "pm"=>"pm"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"one"=>"apie 1 valanda",
       "few"=>"apie %{count} valandų",
       "other"=>"apie %{count} valandų"},
     "about_x_months"=>
      {"one"=>"apie 1 mėnuo",
       "few"=>"apie %{count} mėnesiai",
       "other"=>"apie %{count} mėnesiai"},
     "about_x_years"=>
      {"one"=>"apie 1 metai",
       "few"=>"apie %{count} metų",
       "other"=>"apie %{count} metų"},
     "half_a_minute"=>"pusė minutės",
     "less_than_x_minutes"=>
      {"one"=>"mažiau nei minutė",
       "few"=>"mažiau nei %{count} minutės",
       "other"=>"mažiau nei %{count} minutės"},
     "less_than_x_seconds"=>
      {"one"=>"mažiau nei 1 sekundė",
       "few"=>"mažiau nei %{count} sekundės",
       "other"=>"mažiau nei %{count} sekundės"},
     "over_x_years"=>
      {"one"=>"virš 1 metų",
       "few"=>"virš %{count} metų",
       "other"=>"virš %{count} metų"},
     "x_days"=>
      {"one"=>"1 diena", "few"=>"%{count} dienų", "other"=>"%{count} dienų"},
     "x_minutes"=>
      {"one"=>"1 minutė",
       "few"=>"%{count} minutės",
       "other"=>"%{count} minutės"},
     "x_months"=>
      {"one"=>"1 mėnuo",
       "few"=>"%{count} mėnesiai",
       "other"=>"%{count} mėnesiai"},
     "x_seconds"=>
      {"one"=>"1 sekundė",
       "few"=>"%{count} sekundės",
       "other"=>"%{count} sekundės"}},
   "prompts"=>
    {"day"=>"Diena",
     "hour"=>"Valanda",
     "minute"=>"Minutė",
     "month"=>"Mėnuo",
     "second"=>"Sekundės",
     "year"=>"Metai"}}}
  end
end
