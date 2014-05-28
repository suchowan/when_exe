# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  module Locale

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/da.yml

    Locale_da =
{"date"=>
  {"abbr_day_names"=>["søn", "man", "tir", "ons", "tor", "fre", "lør"],
   "abbr_month_names"=>
    [nil,
     "jan",
     "feb",
     "mar",
     "apr",
     "maj",
     "jun",
     "jul",
     "aug",
     "sep",
     "okt",
     "nov",
     "dec"],
   "day_names"=>
    ["søndag", "mandag", "tirsdag", "onsdag", "torsdag", "fredag", "lørdag"],
   "formats"=>
    {"default"=>"%d.%m.%Y", "long"=>"%e. %B %Y", "short"=>"%e. %b %Y"},
   "month_names"=>
    [nil,
     "januar",
     "februar",
     "marts",
     "april",
     "maj",
     "juni",
     "juli",
     "august",
     "september",
     "oktober",
     "november",
     "december"],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"",
   "formats"=>
    {"default"=>"%e. %B %Y, %H.%M",
     "long"=>"%A d. %e. %B %Y, %H.%M",
     "short"=>"%e. %b %Y, %H.%M",
     "time"=>"%H.%M"},
   "pm"=>""},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"one"=>"cirka en time", "other"=>"cirka %{count} timer"},
     "about_x_months"=>
      {"one"=>"cirka en måned", "other"=>"cirka %{count} måneder"},
     "about_x_years"=>{"one"=>"cirka et år", "other"=>"cirka %{count} år"},
     "almost_x_years"=>{"one"=>"næsten et år", "other"=>"næsten %{count} år"},
     "half_a_minute"=>"et halvt minut",
     "less_than_x_minutes"=>
      {"one"=>"mindre end et minut", "other"=>"mindre end %{count} minutter"},
     "less_than_x_seconds"=>
      {"one"=>"mindre end et sekund", "other"=>"mindre end %{count} sekunder"},
     "over_x_years"=>
      {"one"=>"mere end et år", "other"=>"mere end %{count} år"},
     "x_days"=>{"one"=>"en dag", "other"=>"%{count} dage"},
     "x_minutes"=>{"one"=>"et minut", "other"=>"%{count} minutter"},
     "x_months"=>{"one"=>"en måned", "other"=>"%{count} måneder"},
     "x_seconds"=>{"one"=>"et sekund", "other"=>"%{count} sekunder"}},
   "prompts"=>
    {"day"=>"Dag",
     "hour"=>"Time",
     "minute"=>"Minut",
     "month"=>"Måned",
     "second"=>"Sekund",
     "year"=>"År"}}}
  end
end
