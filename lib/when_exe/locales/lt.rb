# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::Parts::Locale

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
      {"one"=>"apie %{count} valanda",
       "few"=>"apie %{count} valandas",
       "other"=>"apie %{count} valandų"},
     "about_x_months"=>
      {"one"=>"apie %{count} mėnesį",
       "few"=>"apie %{count} mėnesius",
       "other"=>"apie %{count} mėnesių"},
     "about_x_years"=>
      {"one"=>"apie %{count} metus",
       "few"=>"apie %{count} metus",
       "other"=>"apie %{count} metų"},
     "half_a_minute"=>"pusė minutės",
     "less_than_x_minutes"=>
      {"one"=>"mažiau nei %{count} minutė",
       "few"=>"mažiau nei %{count} minutės",
       "other"=>"mažiau nei %{count} minučių"},
     "less_than_x_seconds"=>
      {"one"=>"mažiau nei %{count} sekundė",
       "few"=>"mažiau nei %{count} sekundės",
       "other"=>"mažiau nei %{count} sekundžių"},
     "over_x_years"=>
      {"one"=>"virš %{count} metų",
       "few"=>"virš %{count} metų",
       "other"=>"virš %{count} metų"},
     "x_days"=>
      {"one"=>"%{count} diena",
       "few"=>"%{count} dienos",
       "other"=>"%{count} dienų"},
     "x_minutes"=>
      {"one"=>"%{count} minutė",
       "few"=>"%{count} minutės",
       "other"=>"%{count} minučių"},
     "x_months"=>
      {"one"=>"%{count} mėnesis",
       "few"=>"%{count} mėnesiai",
       "other"=>"%{count} mėnesių"},
     "x_seconds"=>
      {"one"=>"%{count} sekundė",
       "few"=>"%{count} sekundės",
       "other"=>"%{count} sekundžių"}},
   "prompts"=>
    {"day"=>"Diena",
     "hour"=>"Valanda",
     "minute"=>"Minutė",
     "month"=>"Mėnuo",
     "second"=>"Sekundės",
     "year"=>"Metai"}}}
end
