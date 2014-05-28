# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  module Locale

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/hr.yml

    Locale_hr =
{"date"=>
  {"abbr_day_names"=>["Ned", "Pon", "Uto", "Sri", "Čet", "Pet", "Sub"],
   "abbr_month_names"=>
    [nil,
     "Sij",
     "Vel",
     "Ožu",
     "Tra",
     "Svi",
     "Lip",
     "Srp",
     "Kol",
     "Ruj",
     "Lis",
     "Stu",
     "Pro"],
   "day_names"=>
    ["Nedjelja",
     "Ponedjeljak",
     "Utorak",
     "Srijeda",
     "Četvrtak",
     "Petak",
     "Subota"],
   "formats"=>{"default"=>"%d.%m.%Y.", "long"=>"%B %e, %Y", "short"=>"%e %b"},
   "month_names"=>
    [nil,
     "Siječanj",
     "Veljača",
     "Ožujak",
     "Travanj",
     "Svibanj",
     "Lipanj",
     "Srpanj",
     "Kolovoz",
     "Rujan",
     "Listopad",
     "Studeni",
     "Prosinac"],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"AM",
   "formats"=>
    {"default"=>"%a %b %d %H:%M:%S %Z %Y",
     "long"=>"%B %d, %Y %H:%M",
     "short"=>"%d %b %H:%M",
     "time"=>"%H:%M:%S %Z"},
   "pm"=>"PM"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"one"=>"oko %{count} sat",
       "few"=>"oko %{count} sata",
       "many"=>"oko %{count} sati",
       "other"=>"oko %{count} sati"},
     "about_x_months"=>
      {"one"=>"oko %{count} mjesec",
       "few"=>"oko %{count} mjeseca",
       "many"=>"oko %{count} mjeseci",
       "other"=>"oko %{count} mjeseci"},
     "about_x_years"=>
      {"one"=>"oko %{count} godine",
       "few"=>"oko %{count} godine",
       "many"=>"oko %{count} godina",
       "other"=>"oko %{count} godina"},
     "almost_x_years"=>
      {"one"=>"skoro %{count} godina",
       "few"=>"skoro %{count} godine",
       "many"=>"skoro %{count} godina",
       "other"=>"skoro %{count} godina"},
     "half_a_minute"=>"pola minute",
     "less_than_x_minutes"=>
      {"one"=>"manje od %{count} minute",
       "few"=>"manje od %{count} minute",
       "many"=>"manje od %{count} minuta",
       "other"=>"manje od %{count} minuta"},
     "less_than_x_seconds"=>
      {"one"=>"manje od %{count} sekunde",
       "few"=>"manje od %{count} sekunde",
       "many"=>"manje od %{count} sekundi",
       "other"=>"manje od %{count} sekundi"},
     "over_x_years"=>
      {"one"=>"preko %{count} godine",
       "few"=>"preko %{count} godine",
       "many"=>"preko %{count} godina",
       "other"=>"preko %{count} godina"},
     "x_days"=>
      {"one"=>"%{count} dan",
       "few"=>"%{count} dana",
       "many"=>"%{count} dana",
       "other"=>"%{count} dana"},
     "x_minutes"=>
      {"one"=>"%{count} minuta",
       "few"=>"%{count} minute",
       "many"=>"%{count} minuta",
       "other"=>"%{count} minuta"},
     "x_months"=>
      {"one"=>"%{count} mjesec",
       "few"=>"%{count} mjeseca",
       "many"=>"%{count} mjeseci",
       "other"=>"%{count} mjeseci"},
     "x_seconds"=>
      {"one"=>"%{count} sekunda",
       "few"=>"%{count} sekunde",
       "many"=>"%{count} sekundi",
       "other"=>"%{count} sekundi"}},
   "prompts"=>
    {"day"=>"Dan",
     "hour"=>"Sat",
     "minute"=>"Minuta",
     "month"=>"Mjesec",
     "second"=>"Sekunde",
     "year"=>"Godina"}}}
  end
end
