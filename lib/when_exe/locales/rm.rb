# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::BasicTypes
  class M17n

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/rm.yml

    Locale_rm =
{"date"=>
  {"abbr_day_names"=>["du", "gli", "ma", "me", "gie", "ve", "so"],
   "abbr_month_names"=>
    [nil,
     "schan",
     "favr",
     "mars",
     "avr",
     "matg",
     "zercl",
     "fan",
     "avust",
     "sett",
     "oct",
     "nov",
     "dec"],
   "day_names"=>
    ["dumengia",
     "glindesdi",
     "mardi",
     "mesemna",
     "gievgia",
     "venderdi",
     "sonda"],
   "formats"=>{"default"=>"%d.%m.%Y", "long"=>"%e. %B %Y", "short"=>"%e. %b"},
   "month_names"=>
    [nil,
     "schaner",
     "favrer",
     "mars",
     "avrigl",
     "matg",
     "zercladur",
     "fanadur",
     "avust",
     "settember",
     "october",
     "november",
     "december"],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"avantmezdi",
   "formats"=>
    {"default"=>"%A, %d. %B %Y, %H:%M Uhr",
     "long"=>"%A, %d. %B %Y, %H:%M Uhr",
     "short"=>"%d. %B, %H:%M Uhr",
     "time"=>"%H:%M Uhr"},
   "pm"=>"suentermezdi"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"zero"=>"circa %{count} uras",
       "one"=>"circa in'ura",
       "two"=>"circa %{count} uras",
       "few"=>"circa %{count} uras",
       "many"=>"circa %{count} uras",
       "other"=>"circa %{count} uras"},
     "about_x_months"=>
      {"zero"=>"circa %{count} mais",
       "one"=>"circa in mais",
       "two"=>"circa %{count} mais",
       "few"=>"circa %{count} mais",
       "many"=>"circa %{count} mais",
       "other"=>"circa %{count} mais"},
     "about_x_years"=>
      {"zero"=>"circa %{count} onns",
       "one"=>"circa in onn",
       "two"=>"circa %{count} onns",
       "few"=>"circa %{count} onns",
       "many"=>"circa %{count} onns",
       "other"=>"circa %{count} onns"},
     "half_a_minute"=>"ina mesa minuta",
     "less_than_x_minutes"=>
      {"zero"=>"main che %{count} minutas",
       "one"=>"main ch’ina minuta",
       "two"=>"main che %{count} minutas",
       "few"=>"main che %{count} minutas",
       "many"=>"main che %{count} minutas",
       "other"=>"main che %{count} minutas"},
     "less_than_x_seconds"=>
      {"zero"=>"main che %{count} secundas",
       "one"=>"main ch’ina secunda",
       "two"=>"main che %{count} secundas",
       "few"=>"main che %{count} secundas",
       "many"=>"main che %{count} secundas",
       "other"=>"main che %{count} secundas"},
     "over_x_years"=>
      {"zero"=>"dapli che %{count} onns",
       "one"=>"dapli ch'in onn",
       "two"=>"dapli che %{count} onns",
       "few"=>"dapli che %{count} onns",
       "many"=>"dapli che %{count} onns",
       "other"=>"dapli che %{count} onns"},
     "x_days"=>
      {"zero"=>"%{count} dis",
       "one"=>"in di",
       "two"=>"%{count} dis",
       "few"=>"%{count} dis",
       "many"=>"%{count} dis",
       "other"=>"%{count} dis"},
     "x_minutes"=>
      {"zero"=>"%{count} minutas",
       "one"=>"1 minuta",
       "two"=>"%{count} minutas",
       "few"=>"%{count} minutas",
       "many"=>"%{count} minutas",
       "other"=>"%{count} minutas"},
     "x_months"=>
      {"zero"=>"%{count} mais",
       "one"=>"in mais",
       "two"=>"%{count} mais",
       "few"=>"%{count} mais",
       "many"=>"%{count} mais",
       "other"=>"%{count} mais"},
     "x_seconds"=>
      {"zero"=>"%{count} secundas",
       "one"=>"ina secunda",
       "two"=>"%{count} secundas",
       "few"=>"%{count} secundas",
       "many"=>"%{count} secundas",
       "other"=>"%{count} secundas"}},
   "prompts"=>
    {"day"=>"dis",
     "hour"=>"uras",
     "minute"=>"minutas",
     "month"=>"mais",
     "second"=>"secundas",
     "year"=>"onns"}}}
  end
end
