# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::Parts::Locale

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/uz.yml

    Locale_uz =
{"date"=>
  {"abbr_day_names"=>["Ya", "Du", "Sh", "Ch", "Pa", "Ju", "Sh"],
   "abbr_month_names"=>
    [nil,
     "yan.",
     "fev.",
     "mart",
     "apr.",
     "may",
     "iyun",
     "iyul",
     "avg.",
     "sen.",
     "okt.",
     "noy.",
     "dek."],
   "day_names"=>
    ["yakshanba",
     "dushanba",
     "seshanbe",
     "chorshanba",
     "payshanba",
     "juma",
     "shanba"],
   "formats"=>{"default"=>"%d.%m.%Y", "long"=>"%d %B %Y", "short"=>"%d %b"},
   "month_names"=>
    [nil,
     "yanvar",
     "fevral",
     "mart",
     "aprel",
     "may",
     "iyun",
     "iyul",
     "avgust",
     "sentyabr",
     "oktyabr",
     "noyabr",
     "dekabr"],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"ertalab",
   "formats"=>
    {"default"=>"%a, %d %b %Y, %H:%M:%S %z",
     "long"=>"%d %B %Y, %H:%M",
     "short"=>"%d %b, %H:%M",
     "time"=>"%H:%M:%S %z"},
   "pm"=>"kechasi"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"few"=>"chamasi %{count} soat",
       "many"=>"chamasi %{count} soat",
       "one"=>"chamasi %{count} soat",
       "other"=>"chamasi %{count} soat"},
     "about_x_months"=>
      {"few"=>"chamasi %{count} oy",
       "many"=>"chamasi %{count} oy",
       "one"=>"chamasi %{count} oy",
       "other"=>"chamasi %{count} oy"},
     "about_x_years"=>
      {"few"=>"chamasi %{count} yil",
       "many"=>"chamasi %{count} yil",
       "one"=>"chamasi %{count} yil",
       "other"=>"chamasi %{count} yil"},
     "almost_x_years"=>
      {"one"=>"deyarli 1 yil",
       "few"=>"deyarli %{count} yil",
       "many"=>"deyarli %{count} yil",
       "other"=>"deyarli %{count} yil"},
     "half_a_minute"=>"bir daqiqadan kam",
     "less_than_x_minutes"=>
      {"few"=>"%{count} daqiqadan kam",
       "many"=>"%{count} daqiqadan kam",
       "one"=>"%{count} daqiqadan kam",
       "other"=>"%{count} daqiqadan kam"},
     "less_than_x_seconds"=>
      {"few"=>"%{count} soniyadan kam",
       "many"=>"%{count} soniyadan kam",
       "one"=>"%{count} soniyadan kam",
       "other"=>"%{count} soniyadan kam"},
     "over_x_years"=>
      {"few"=>"%{count} yildan ziyod",
       "many"=>"%{count} yildan ziyod",
       "one"=>"%{count} yildan ziyod",
       "other"=>"%{count} yildan ziyod"},
     "x_days"=>
      {"few"=>"%{count} kun",
       "many"=>"%{count} kun",
       "one"=>"%{count} kun",
       "other"=>"%{count} kun"},
     "x_minutes"=>
      {"few"=>"%{count} daqiqa",
       "many"=>"%{count} daqiqa",
       "one"=>"%{count} daqiqa",
       "other"=>"%{count} daqiqa"},
     "x_months"=>
      {"few"=>"%{count} oy",
       "many"=>"%{count} oy",
       "one"=>"%{count} oy",
       "other"=>"%{count} oy"},
     "x_seconds"=>
      {"few"=>"%{count} soniya",
       "many"=>"%{count} soniya",
       "one"=>"%{count} soniyaа",
       "other"=>"%{count} soniya"}},
   "prompts"=>
    {"day"=>"kun",
     "hour"=>"soat",
     "minute"=>"daqiqa",
     "month"=>"oy",
     "second"=>"soniya",
     "year"=>"yil"}}}
end
