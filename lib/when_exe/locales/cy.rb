# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::BasicTypes
  class M17n

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/cy.yml

    Locale_cy =
{"date"=>
  {"abbr_day_names"=>["Sul", "Llun", "Maw", "Mer", "Iau", "Gwe", "Sad"],
   "abbr_month_names"=>
    [nil,
     "Ion",
     "Chw",
     "Maw",
     "Ebr",
     "Mai",
     "Meh",
     "Gor",
     "Awst",
     "Med",
     "Hyd",
     "Tach",
     "Rha"],
   "day_names"=>
    ["Dydd Sul",
     "Dydd Llun",
     "Dydd Mawrth",
     "Dydd Mercher",
     "Dydd Iau",
     "Dydd Gwener",
     "Dydd Sadwrn"],
   "formats"=>{"default"=>"%d-%m-%Y", "long"=>"%B %d, %Y", "short"=>"%b %d"},
   "month_names"=>
    [nil,
     "Ionawr",
     "Chwefror",
     "Mawrth",
     "Ebrill",
     "Mai",
     "Mehefin",
     "Gorffennaf",
     "Awst",
     "Medi",
     "Hydref",
     "Tachwedd",
     "Rhagfyr"],
   "order"=>[:year, :month, :day]},
 "time"=>
  {"am"=>"yb",
   "formats"=>
    {"default"=>"%a, %d %b %Y %H:%M:%S %z",
     "long"=>"%B %d, %Y %H:%M",
     "short"=>"%d %b %H:%M",
     "time"=>"%H:%M:%S %z"},
   "pm"=>"yh"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"zero"=>"tua %{count} awr",
       "one"=>"tuag awr",
       "two"=>"tua %{count} awr",
       "few"=>"tua %{count} awr",
       "many"=>"tua %{count} awr",
       "other"=>"tua %{count} awr"},
     "about_x_months"=>
      {"zero"=>"tua %{count} mis",
       "one"=>"tua mis",
       "two"=>"tua %{count} mis",
       "few"=>"tua %{count} mis",
       "many"=>"tua %{count} mis",
       "other"=>"tua %{count} mis"},
     "about_x_years"=>
      {"zero"=>"tua %{count} blynedd",
       "one"=>"tua blwyddyn",
       "two"=>"tua %{count} blynedd",
       "few"=>"tua %{count} blynedd",
       "many"=>"tua %{count} blynedd",
       "other"=>"tua %{count} blynedd"},
     "almost_x_years"=>
      {"zero"=>"bron yn %{count} blynedd",
       "one"=>"bron yn flwyddyn",
       "two"=>"bron yn %{count} blynedd",
       "few"=>"bron yn %{count} blynedd",
       "many"=>"bron yn %{count} blynedd",
       "other"=>"bron yn %{count} blynedd"},
     "half_a_minute"=>"hanner munud",
     "less_than_x_minutes"=>
      {"zero"=>"llai na %{count} munud",
       "one"=>"llai na munud",
       "two"=>"llai na %{count} munud",
       "few"=>"llai na %{count} munud",
       "many"=>"llai na %{count} munud",
       "other"=>"llai na %{count} munud"},
     "less_than_x_seconds"=>
      {"zero"=>"llai na %{count} eiliad",
       "one"=>"llai nag eiliad",
       "two"=>"llai na %{count} eiliad",
       "few"=>"llai na %{count} eiliad",
       "many"=>"llai na %{count} eiliad",
       "other"=>"llai na %{count} eiliad"},
     "over_x_years"=>
      {"zero"=>"dros %{count} blynedd",
       "one"=>"dros flwyddyn",
       "two"=>"dros %{count} blynedd",
       "few"=>"dros %{count} blynedd",
       "many"=>"dros %{count} blynedd",
       "other"=>"dros %{count} blynedd"},
     "x_days"=>
      {"zero"=>"%{count} diwrnod",
       "one"=>"1 diwrnod",
       "two"=>"%{count} diwrnod",
       "few"=>"%{count} diwrnod",
       "many"=>"%{count} diwrnod",
       "other"=>"%{count} diwrnod"},
     "x_minutes"=>
      {"zero"=>"%{count} o funudau",
       "one"=>"1 munud",
       "two"=>"%{count} o funudau",
       "few"=>"%{count} o funudau",
       "many"=>"%{count} o funudau",
       "other"=>"%{count} o funudau"},
     "x_months"=>
      {"zero"=>"%{count} mis",
       "one"=>"1 mis",
       "two"=>"%{count} mis",
       "few"=>"%{count} mis",
       "many"=>"%{count} mis",
       "other"=>"%{count} mis"},
     "x_seconds"=>
      {"zero"=>"%{count} o eiliadau",
       "one"=>"1 eiliad",
       "two"=>"%{count} o eiliadau",
       "few"=>"%{count} o eiliadau",
       "many"=>"%{count} o eiliadau",
       "other"=>"%{count} o eiliadau"}},
   "prompts"=>
    {"day"=>"Diwrnod",
     "hour"=>"Awr",
     "minute"=>"Munud",
     "month"=>"Mis",
     "second"=>"Eiliad",
     "year"=>"Blwyddyn"}}}
  end
end
