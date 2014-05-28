# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  module Locale

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/nb.yml

    Locale_nb =
{"date"=>
  {"abbr_day_names"=>["søn", "man", "tir", "ons", "tor", "fre", "lør"],
   "abbr_month_names"=>
    [nil,
     "jan",
     "feb",
     "mar",
     "apr",
     "mai",
     "jun",
     "jul",
     "aug",
     "sep",
     "okt",
     "nov",
     "des"],
   "day_names"=>
    ["søndag", "mandag", "tirsdag", "onsdag", "torsdag", "fredag", "lørdag"],
   "formats"=>{"default"=>"%d.%m.%Y", "long"=>"%e. %B %Y", "short"=>"%e. %b"},
   "month_names"=>
    [nil,
     "januar",
     "februar",
     "mars",
     "april",
     "mai",
     "juni",
     "juli",
     "august",
     "september",
     "oktober",
     "november",
     "desember"],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"",
   "formats"=>
    {"default"=>"%A, %e. %B %Y, %H:%M",
     "long"=>"%A, %e. %B %Y, %H:%M",
     "short"=>"%e. %B, %H:%M",
     "time"=>"%H:%M"},
   "pm"=>""},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>{"one"=>"rundt 1 time", "other"=>"rundt %{count} timer"},
     "about_x_months"=>
      {"one"=>"rundt 1 måned", "other"=>"rundt %{count} måneder"},
     "about_x_years"=>{"one"=>"rundt 1 år", "other"=>"rundt %{count} år"},
     "almost_x_years"=>{"one"=>"nesten 1 år", "other"=>"nesten %{count} år"},
     "half_a_minute"=>"et halvt minutt",
     "less_than_x_minutes"=>
      {"one"=>"mindre enn 1 minutt", "other"=>"mindre enn %{count} minutter"},
     "less_than_x_seconds"=>
      {"one"=>"mindre enn 1 sekund", "other"=>"mindre enn %{count} sekunder"},
     "over_x_years"=>{"one"=>"over 1 år", "other"=>"over %{count} år"},
     "x_days"=>{"one"=>"1 dag", "other"=>"%{count} dager"},
     "x_minutes"=>{"one"=>"1 minutt", "other"=>"%{count} minutter"},
     "x_months"=>{"one"=>"1 måned", "other"=>"%{count} måneder"},
     "x_seconds"=>{"one"=>"1 sekund", "other"=>"%{count} sekunder"}},
   "prompts"=>
    {"day"=>"Dag",
     "hour"=>"Time",
     "minute"=>"Minutt",
     "month"=>"Måned",
     "second"=>"Sekund",
     "year"=>"År"}}}
  end
end
