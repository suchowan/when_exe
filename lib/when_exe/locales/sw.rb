# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::BasicTypes
  class M17n

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/sw.yml

    Locale_sw =
{"date"=>
  {"abbr_day_names"=>["J2", "J3", "J4", "J5", "Al", "Ij", "J1"],
   "abbr_month_names"=>
    [nil,
     "Jan",
     "Feb",
     "Mac",
     "Apr",
     "Mei",
     "Jun",
     "Jul",
     "Ago",
     "Sep",
     "Okt",
     "Nov",
     "Des"],
   "day_names"=>
    ["Jumapili",
     "Jumatatu",
     "Jumanne",
     "Jumatano",
     "Alhamisi",
     "Ijumaa",
     "Jumamosi"],
   "formats"=>{"default"=>"%d-%m-%Y", "long"=>"%e %B, %Y", "short"=>"%e %b"},
   "month_names"=>
    [nil,
     "Mwezi wa kwanza",
     "Mwezi wa pili",
     "Mwezi wa tatu",
     "Mwezi wa nne",
     "Mwezi wa tano",
     "Mwezi wa sita",
     "Mwezi wa saba",
     "Mwezi wa nane",
     "Mwezi wa tisa",
     "Mwezi wa kumi",
     "Mwezi wa kumi na moja",
     "Mwezi wa kumi na mbili"],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"am",
   "formats"=>
    {"default"=>"%a, %d %b %Y %H:%M:%S",
     "long"=>"%A, %e. %B %Y, %H:%M:%S",
     "short"=>"%e %b %Y %H:%M",
     "time"=>"%H:%M:%S"},
   "pm"=>"pm"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"one"=>"kama saa limoja", "other"=>"kama masaa %{count}"},
     "about_x_months"=>{"one"=>"kama mwezi 1", "other"=>"kama miezi %{count}"},
     "about_x_years"=>{"one"=>"kama mwaka 1", "other"=>"kama miaka %{count}"},
     "almost_x_years"=>
      {"one"=>"karibia mwaka", "other"=>"karibia miaka %{count}"},
     "half_a_minute"=>"nusu dakika",
     "less_than_x_minutes"=>
      {"one"=>"chini ya dakika 1", "other"=>"chini ya dakika %{count}"},
     "less_than_x_seconds"=>
      {"one"=>"chini ya sekunde 1", "other"=>"chini ya sekunde %{count}"},
     "over_x_years"=>
      {"one"=>"zaidi ya mwaka 1", "other"=>"zaidi ya miaka %{count}"},
     "x_days"=>{"one"=>"siku 1", "other"=>"siku %{count}"},
     "x_minutes"=>{"one"=>"dakika 1", "other"=>"dakika %{count}"},
     "x_months"=>{"one"=>"mwezi 1", "other"=>"miezi %{count}"},
     "x_seconds"=>{"one"=>"sekunde 1", "other"=>"sekunde %{count}"}},
   "prompts"=>
    {"day"=>"Siku",
     "hour"=>"Saa",
     "minute"=>"Dakika",
     "month"=>"Mwezi",
     "second"=>"Sekunde",
     "year"=>"Mwaka"}}}
  end
end
