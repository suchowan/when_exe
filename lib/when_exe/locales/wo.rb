# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::BasicTypes
  class M17n

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/wo.yml

    Locale_wo =
{"date"=>
  {"abbr_day_names"=>["Dib", "Alt", "Tal", "All", "Alx", "Ajj", "Gaw"],
   "abbr_month_names"=>
    [nil,
     "Jan",
     "Feb",
     "Mar",
     "Apr",
     "May",
     "Jun",
     "Jul",
     "Aug",
     "Sep",
     "Oct",
     "Nov",
     "Dec"],
   "day_names"=>
    ["Dibèer", "Altine", "Talaata", "Allarba", "Alxamess", "Ajjouma", "Gaawu"],
   "formats"=>{"default"=>"%Y-%m-%d", "long"=>"%B %d, %Y", "short"=>"%b %d"},
   "month_names"=>
    [nil,
     "Tamkharit",
     "Digui Gamou",
     "Gamou",
     "Raki Gamou",
     "Rakati Gamou",
     "Mamou Kor",
     "Ndeyou Kor",
     "Baraxlou",
     "Kor",
     "Kori",
     "Digui Tabaski",
     "Tabaski"],
   "order"=>[:year, :month, :day]},
 "time"=>
  {"am"=>"am",
   "formats"=>
    {"default"=>"%a, %d %b %Y %H:%M:%S %z",
     "long"=>"%B %d, %Y %H:%M",
     "short"=>"%d %b %H:%M",
     "time"=>"%H:%M:%S %z"},
   "pm"=>"pm"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>{"one"=>"about 1 hour", "other"=>"about %{count} hours"},
     "about_x_months"=>
      {"one"=>"about 1 month", "other"=>"about %{count} months"},
     "about_x_years"=>{"one"=>"about 1 year", "other"=>"about %{count} years"},
     "almost_x_years"=>
      {"one"=>"almost 1 year", "other"=>"almost %{count} years"},
     "half_a_minute"=>"half a minute",
     "less_than_x_minutes"=>
      {"one"=>"less than a minute", "other"=>"less than %{count} minutes"},
     "less_than_x_seconds"=>
      {"one"=>"less than 1 second", "other"=>"less than %{count} seconds"},
     "over_x_years"=>{"one"=>"over 1 year", "other"=>"over %{count} years"},
     "x_days"=>{"one"=>"1 day", "other"=>"%{count} days"},
     "x_minutes"=>{"one"=>"1 minute", "other"=>"%{count} minutes"},
     "x_months"=>{"one"=>"1 month", "other"=>"%{count} months"},
     "x_seconds"=>{"one"=>"1 second", "other"=>"%{count} seconds"}},
   "prompts"=>
    {"day"=>"Day",
     "hour"=>"Hour",
     "minute"=>"Minute",
     "month"=>"Month",
     "second"=>"Seconds",
     "year"=>"Year"}}}
  end
end
