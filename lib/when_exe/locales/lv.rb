# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::Parts::Locale

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/lv.yml

    Locale_lv =
{"date"=>
  {"abbr_day_names"=>["Sv.", "P.", "O.", "T.", "C.", "Pk.", "S."],
   "abbr_month_names"=>
    [nil,
     "Janv",
     "Febr",
     "Marts",
     "Apr",
     "Maijs",
     "Jūn",
     "Jūl",
     "Aug",
     "Sept",
     "Okt",
     "Nov",
     "Dec"],
   "day_names"=>
    ["svētdiena",
     "pirmdiena",
     "otrdiena",
     "trešdiena",
     "ceturtdiena",
     "piektdiena",
     "sestdiena"],
   "formats"=>
    {"default"=>"%d.%m.%Y.", "long"=>"%Y. gada %e. %B", "short"=>"%e. %B"},
   "month_names"=>
    [nil,
     "janvārī",
     "februārī",
     "martā",
     "aprīlī",
     "maijā",
     "jūnijā",
     "jūlijā",
     "augustā",
     "septembrī",
     "oktobrī",
     "novembrī",
     "decembrī"],
   "order"=>[:year, :month, :day]},
 "time"=>
  {"am"=>"priekšpusdiena",
   "formats"=>
    {"default"=>"%Y. gada %e. %B, %H:%M",
     "long"=>"%Y. gada %e. %B, %H:%M:%S",
     "short"=>"%d.%m.%Y., %H:%M",
     "time"=>"%H:%M"},
   "pm"=>"pēcpusdiena"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"zero"=>"apmēram %{count} stundas",
       "one"=>"apmēram %{count} stunda",
       "other"=>"apmēram %{count} stundas"},
     "about_x_months"=>
      {"zero"=>"apmēram %{count} mēneši",
       "one"=>"apmēram %{count} mēnesis",
       "other"=>"apmēram %{count} mēneši"},
     "about_x_years"=>
      {"zero"=>"apmēram %{count} gadi",
       "one"=>"apmēram %{count} gads",
       "other"=>"apmēram %{count} gadi"},
     "almost_x_years"=>
      {"zero"=>"gandrīz %{count} gadi",
       "one"=>"gandrīz %{count} gads",
       "other"=>"gandrīz %{count} gadi"},
     "half_a_minute"=>"pusminūte",
     "less_than_x_minutes"=>
      {"zero"=>"mazāk par %{count} minūtēm",
       "one"=>"mazāk par %{count} minūti",
       "other"=>"mazāk par %{count} minūtēm"},
     "less_than_x_seconds"=>
      {"zero"=>"mazāk par %{count} sekundēm",
       "one"=>"mazāk par %{count} sekundi",
       "other"=>"mazāk par %{count} sekundēm"},
     "over_x_years"=>
      {"zero"=>"vairāk kā %{count} gadi",
       "one"=>"vairāk kā %{count} gads",
       "other"=>"vairāk kā %{count} gadi"},
     "x_days"=>
      {"zero"=>"%{count} dienas",
       "one"=>"%{count} diena",
       "other"=>"%{count} dienas"},
     "x_minutes"=>
      {"zero"=>"%{count} minūtes",
       "one"=>"%{count} minūte",
       "other"=>"%{count} minūtes"},
     "x_months"=>
      {"zero"=>"%{count} mēneši",
       "one"=>"%{count} mēnesis",
       "other"=>"%{count} mēneši"},
     "x_seconds"=>
      {"zero"=>"%{count} sekundes",
       "one"=>"%{count} sekunde",
       "other"=>"%{count} sekundes"}},
   "prompts"=>
    {"day"=>"diena",
     "hour"=>"stunda",
     "minute"=>"minūte",
     "month"=>"mēnesis",
     "second"=>"sekunde",
     "year"=>"gads"}}}
end
