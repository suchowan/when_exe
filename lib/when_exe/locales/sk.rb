# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::BasicTypes
  class M17n

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/sk.yml

    Locale_sk =
{"date"=>
  {"abbr_day_names"=>["Ne", "Po", "Ut", "St", "Št", "Pi", "So"],
   "abbr_month_names"=>
    [nil,
     "Jan",
     "Feb",
     "Mar",
     "Apr",
     "Máj",
     "Jún",
     "Júl",
     "Aug",
     "Sep",
     "Okt",
     "Nov",
     "Dec"],
   "day_names"=>
    ["Nedeľa", "Pondelok", "Utorok", "Streda", "Štvrtok", "Piatok", "Sobota"],
   "formats"=>{"default"=>"%d.%m.%Y", "long"=>"%d. %B %Y", "short"=>"%d %b"},
   "month_names"=>
    [nil,
     "Január",
     "Február",
     "Marec",
     "Apríl",
     "Máj",
     "Jún",
     "Júl",
     "August",
     "September",
     "Október",
     "November",
     "December"],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"dopoludnia",
   "formats"=>
    {"default"=>"%a %d. %B %Y %H:%M %z",
     "long"=>"%A %d. %B %Y %H:%M",
     "short"=>"%d.%m. %H:%M",
     "time"=>"%H:%M %z"},
   "pm"=>"popoludní"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"one"=>"asi hodinou",
       "few"=>"asi %{count} hodinami",
       "other"=>"asi %{count} hodinami"},
     "about_x_months"=>
      {"one"=>"asi mesiacom",
       "few"=>"asi %{count} mesiacmi",
       "other"=>"asi %{count} mesiacmi"},
     "about_x_years"=>
      {"one"=>"asi rokom",
       "few"=>"asi %{count} rokmi",
       "other"=>"asi %{count} rokmi"},
     "almost_x_years"=>
      {"one"=>"takmer rokom",
       "few"=>"takmer %{count} rokmi",
       "other"=>"takmer %{count} rokmi"},
     "half_a_minute"=>"pol minútou",
     "less_than_x_minutes"=>
      {"one"=>"necelou minútou",
       "few"=>"necelými %{count} minútami",
       "other"=>"necelými %{count} minútami"},
     "less_than_x_seconds"=>
      {"one"=>"necelou sekundou",
       "few"=>"necelými %{count} sekundami",
       "other"=>"necelými %{count} sekundami"},
     "over_x_years"=>
      {"one"=>"viac ako rokom",
       "few"=>"viac ako %{count} rokmi",
       "other"=>"viac ako %{count} rokmi"},
     "x_days"=>
      {"one"=>"dňom", "few"=>"%{count} dňami", "other"=>"%{count} dňami"},
     "x_minutes"=>
      {"one"=>"minútou",
       "few"=>"%{count} minútami",
       "other"=>"%{count} minútami"},
     "x_months"=>
      {"one"=>"mesiacom",
       "few"=>"%{count} mesiacmi",
       "other"=>"%{count} mesiacmi"},
     "x_seconds"=>
      {"one"=>"sekundou",
       "few"=>"%{count} sekundami",
       "other"=>"%{count} sekundami"}},
   "prompts"=>
    {"day"=>"Deň",
     "hour"=>"Hodina",
     "minute"=>"Minúta",
     "month"=>"Mesiac",
     "second"=>"Sekunda",
     "year"=>"Rok"}}}
  end
end
