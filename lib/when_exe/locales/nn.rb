# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::Parts::Locale

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/nn.yml

    Locale_nn =
{"date"=>
  {"abbr_day_names"=>["sun", "mån", "tys", "ons", "tor", "fre", "lau"],
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
    ["sundag", "måndag", "tysdag", "onsdag", "torsdag", "fredag", "laurdag"],
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
    {"about_x_hours"=>{"one"=>"rundt 1 time", "other"=>"rundt %{count} timar"},
     "about_x_months"=>
      {"one"=>"rundt 1 månad", "other"=>"rundt %{count} månader"},
     "about_x_years"=>{"one"=>"rundt 1 år", "other"=>"rundt %{count} år"},
     "half_a_minute"=>"eit halvt minutt",
     "less_than_x_minutes"=>
      {"one"=>"mindre enn 1 minutt", "other"=>"mindre enn %{count} minutt"},
     "less_than_x_seconds"=>
      {"one"=>"mindre enn 1 sekund", "other"=>"mindre enn %{count} sekund"},
     "over_x_years"=>{"one"=>"over 1 år", "other"=>"over %{count} år"},
     "x_days"=>{"one"=>"1 dag", "other"=>"%{count} dagar"},
     "x_minutes"=>{"one"=>"1 minutt", "other"=>"%{count} minutt"},
     "x_months"=>{"one"=>"1 månad", "other"=>"%{count} månader"},
     "x_seconds"=>{"one"=>"1 sekund", "other"=>"%{count} sekund"}}}}
end
