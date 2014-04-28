# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::Parts::Locale

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/sv.yml

    Locale_sv =
{"date"=>
  {"abbr_day_names"=>["sön", "mån", "tis", "ons", "tor", "fre", "lör"],
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
    ["söndag", "måndag", "tisdag", "onsdag", "torsdag", "fredag", "lördag"],
   "formats"=>{"default"=>"%Y-%m-%d", "long"=>"%e %B %Y", "short"=>"%e %b"},
   "month_names"=>
    [nil,
     "januari",
     "februari",
     "mars",
     "april",
     "maj",
     "juni",
     "juli",
     "augusti",
     "september",
     "oktober",
     "november",
     "december"],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"",
   "formats"=>
    {"default"=>"%a, %e %b %Y %H:%M:%S %z",
     "long"=>"%e %B %Y %H:%M",
     "short"=>"%e %b %H:%M",
     "time"=>"%H:%M:%S %z"},
   "pm"=>""},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"one"=>"ungefär en timme", "other"=>"ungefär %{count} timmar"},
     "about_x_months"=>
      {"one"=>"ungefär en månad", "other"=>"ungefär %{count} månader"},
     "about_x_years"=>
      {"one"=>"ungefär ett år", "other"=>"ungefär %{count} år"},
     "almost_x_years"=>{"one"=>"nästan ett år", "other"=>"nästan %{count} år"},
     "half_a_minute"=>"en halv minut",
     "less_than_x_minutes"=>
      {"one"=>"mindre än en minut", "other"=>"mindre än %{count} minuter"},
     "less_than_x_seconds"=>
      {"one"=>"mindre än en sekund", "other"=>"mindre än %{count} sekunder"},
     "over_x_years"=>{"one"=>"mer än ett år", "other"=>"mer än %{count} år"},
     "x_days"=>{"one"=>"en dag", "other"=>"%{count} dagar"},
     "x_minutes"=>{"one"=>"en minut", "other"=>"%{count} minuter"},
     "x_months"=>{"one"=>"en månad", "other"=>"%{count} månader"},
     "x_seconds"=>{"one"=>"en sekund", "other"=>"%{count} sekunder"}},
   "prompts"=>
    {"day"=>"Dag",
     "hour"=>"Timme",
     "minute"=>"Minut",
     "month"=>"Månad",
     "second"=>"Sekund",
     "year"=>"År"}}}
end
