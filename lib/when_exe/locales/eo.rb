# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  module Locale

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/eo.yml

    Locale_eo =
{"date"=>
  {"abbr_day_names"=>["dim", "lun", "mar", "mer", "ĵaŭ", "ven", "sam"],
   "abbr_month_names"=>
    [nil,
     "jan.",
     "feb.",
     "mar.",
     "apr.",
     "majo",
     "jun.",
     "jul.",
     "aŭg.",
     "sep.",
     "okt.",
     "nov.",
     "dec."],
   "day_names"=>
    ["dimanĉo", "lundo", "mardo", "merkredo", "ĵaŭdo", "vendredo", "sabato"],
   "formats"=>{"default"=>"%Y/%m/%d", "long"=>"%e %B %Y", "short"=>"%e %b"},
   "month_names"=>
    [nil,
     "januaro",
     "februaro",
     "marto",
     "aprilo",
     "majo",
     "junio",
     "julio",
     "aŭgusto",
     "septembro",
     "oktobro",
     "novembro",
     "decembro"],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"am",
   "formats"=>
    {"default"=>"%d %B %Y %H:%M:%S",
     "long"=>"%A %d %B %Y %H:%M",
     "short"=>"%d %b %H:%M",
     "time"=>"%H:%M:%S"},
   "pm"=>"pm"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"one"=>"ĉirkaŭ unu horo", "other"=>"ĉirkaŭ %{count} horoj"},
     "about_x_months"=>
      {"one"=>"ĉirkaŭ unu monato", "other"=>"ĉirkaŭ %{count} monatoj"},
     "about_x_years"=>
      {"one"=>"ĉirkaŭ uno jaro", "other"=>"ĉirkaŭ %{count} jaroj"},
     "almost_x_years"=>
      {"one"=>"preskaŭ unu jaro", "other"=>"preskaŭ %{count} jaroj"},
     "half_a_minute"=>"duona minuto",
     "less_than_x_minutes"=>
      {"one"=>"malpli ol unu minuto",
       "other"=>"malpli ol %{count} minutoj",
       "zero"=>"malpli ol unu minuto"},
     "less_than_x_seconds"=>
      {"one"=>"malpli ol unu sekundo",
       "other"=>"malpli ol %{count} sekundoj",
       "zero"=>"malpli ol unu sekundo"},
     "over_x_years"=>
      {"one"=>"pli ol unu jaro", "other"=>"pli ol %{count} jaroj"},
     "x_days"=>{"one"=>"1 tago", "other"=>"%{count} tagoj"},
     "x_minutes"=>{"one"=>"1 minuto", "other"=>"%{count} minutoj"},
     "x_months"=>{"one"=>"1 monato", "other"=>"%{count} monatoj"},
     "x_seconds"=>{"one"=>"1 sekundo", "other"=>"%{count} sekundoj"}},
   "prompts"=>
    {"day"=>"Tago",
     "hour"=>"Horo",
     "minute"=>"Minuto",
     "month"=>"Monato",
     "second"=>"Sekundo",
     "year"=>"Jaro"}}}
  end
end
