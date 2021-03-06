# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  module Locale

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/sl.yml

    Locale_sl =
{"date"=>
  {"abbr_day_names"=>["ned", "pon", "tor", "sre", "čet", "pet", "sob"],
   "abbr_month_names"=>
    [nil,
     "jan",
     "feb",
     "mar",
     "apr",
     "maj",
     "jun",
     "jul",
     "avg",
     "sep",
     "okt",
     "nov",
     "dec"],
   "day_names"=>
    ["nedelja", "ponedeljek", "torek", "sreda", "četrtek", "petek", "sobota"],
   "formats"=>{"default"=>"%d.%m.%Y", "long"=>"%d. %b %Y", "short"=>"%d. %b"},
   "month_names"=>
    [nil,
     "januar",
     "februar",
     "marec",
     "april",
     "maj",
     "junij",
     "julij",
     "avgust",
     "september",
     "oktober",
     "november",
     "december"],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"dopoldan",
   "formats"=>
    {"default"=>"%A, %d %b %Y ob %H:%M:%S",
     "long"=>"%d. %B, %Y ob %H:%M",
     "short"=>"%d. %b ob %H:%M",
     "time"=>"%H:%M:%S"},
   "pm"=>"popoldan"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"few"=>"okoli %{count} ure",
       "one"=>"okoli 1 ura",
       "other"=>"okoli %{count} ur",
       "two"=>"okoli 2 uri"},
     "about_x_months"=>
      {"few"=>"okoli %{count} mesece",
       "one"=>"okoli 1 mesec",
       "other"=>"okoli %{count} mesecev",
       "two"=>"okoli 2 meseca"},
     "about_x_years"=>
      {"few"=>"okoli %{count} leta",
       "one"=>"okoli 1 leto",
       "other"=>"okoli %{count} let",
       "two"=>"okoli 2 leti"},
     "almost_x_years"=>
      {"few"=>"skoraj %{count} leta",
       "one"=>"skoraj 1 leto",
       "other"=>"skoraj %{count} let",
       "two"=>"skoraj 2 leti"},
     "half_a_minute"=>"pol minute",
     "less_than_x_minutes"=>
      {"few"=>"manj kot %{count} minute",
       "one"=>"manj kot ena minuta",
       "other"=>"manj kot %{count} minut",
       "two"=>"manj kot dve minuti"},
     "less_than_x_seconds"=>
      {"few"=>"manj kot %{count} sekunde",
       "one"=>"manj kot 1 sekunda",
       "other"=>"manj kot %{count} sekund",
       "two"=>"manj kot 2 sekundi"},
     "over_x_years"=>
      {"few"=>"več kot %{count} leta",
       "one"=>"več kot 1 leto",
       "other"=>"več kot %{count} let",
       "two"=>"več kot 2 leti"},
     "x_days"=>
      {"few"=>"%{count} dnevi",
       "one"=>"1 dan",
       "other"=>"%{count} dni",
       "two"=>"2 dneva"},
     "x_minutes"=>
      {"few"=>"%{count} minute",
       "one"=>"1 minuta",
       "other"=>"%{count} minut",
       "two"=>"2 minuti"},
     "x_months"=>
      {"few"=>"%{count} mesece",
       "one"=>"1 mesec",
       "other"=>"%{count} mesecev",
       "two"=>"2 meseca"},
     "x_seconds"=>
      {"few"=>"%{count} sekunde",
       "one"=>"1 sekunda",
       "other"=>"%{count} sekund",
       "two"=>"2 sekundi"}},
   "prompts"=>
    {"day"=>"Dan",
     "hour"=>"Ura",
     "minute"=>"Minute",
     "month"=>"Mesec",
     "second"=>"Sekunde",
     "year"=>"Leto"}}}
  end
end
