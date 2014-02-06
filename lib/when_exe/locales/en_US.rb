# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::BasicTypes
  class M17n

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/en-US.yml

    Locale_en_US =
{"date"=>
  {"abbr_day_names"=>["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
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
    ["Sunday",
     "Monday",
     "Tuesday",
     "Wednesday",
     "Thursday",
     "Friday",
     "Saturday"],
   "formats"=>{"default"=>"%m-%d-%Y", "long"=>"%B %d, %Y", "short"=>"%b %d"},
   "month_names"=>
    [nil,
     "January",
     "February",
     "March",
     "April",
     "May",
     "June",
     "July",
     "August",
     "September",
     "October",
     "November",
     "December"],
   "order"=>[:month, :day, :year]},
 "time"=>
  {"am"=>"am",
   "formats"=>
    {"default"=>"%a, %d %b %Y %I:%M:%S %p %Z",
     "long"=>"%B %d, %Y %I:%M %p",
     "short"=>"%d %b %I:%M %p"},
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
