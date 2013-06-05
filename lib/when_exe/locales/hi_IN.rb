# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::BasicTypes
  class M17n

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/hi-IN.yml

    Locale_hi_IN =
{"date"=>
  {"abbr_day_names"=>["रवि", "सोम", "मंगल", "बुध", "गुरु", "शुक्र", "शनि"],
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
    ["रविवार", "सोमवार", "मंगलवार", "बुधवार", "गुरुवार", "शुक्रवार", "शनिवार"],
   "formats"=>{"default"=>"%d-%m-%Y", "long"=>"%B %d, %Y", "short"=>"%b %d"},
   "month_names"=>
    [nil,
     "जनवरी",
     "फरवरी",
     "मार्च",
     "अप्रैल",
     "मई",
     "जून",
     "जुलाई",
     "अगस्त",
     "सितंबर",
     "अक्टूबर",
     "नवंबर",
     "दिसंबर"],
   "order"=>[:day, :month, :year]},
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
    {"about_x_hours"=>
      {"one"=>"लग - भग एक घंटा", "other"=>"लग - भग %{count} घंटा"},
     "about_x_months"=>
      {"one"=>"लग - भग 1 महीना", "other"=>"लग - भग %{count} महीना"},
     "about_x_years"=>
      {"one"=>"लग - भग 1 साल", "other"=>"लग - भग %{count} साल"},
     "almost_x_years"=>
      {"one"=>"लग - भग एक साल", "other"=>"लग - भग %{count} साल"},
     "half_a_minute"=>"एक आधा मिनट",
     "less_than_x_minutes"=>
      {"one"=>"एक मिनट से कम", "other"=>"%{count} मिनट से कम"},
     "less_than_x_seconds"=>
      {"one"=>"एक सेकंड से कम", "other"=>"%{count}  सेकंड से कम"},
     "over_x_years"=>{"one"=>"एक साल के ऊपर", "other"=>"%{count} साल के ऊपर"},
     "x_days"=>{"one"=>"एक दिन", "other"=>"%{count} दिन"},
     "x_minutes"=>{"one"=>"एक मिनट", "other"=>"%{count} मिनट"},
     "x_months"=>{"one"=>"एक महीना", "other"=>"%{count} महीना"},
     "x_seconds"=>{"one"=>"एक सेकंड", "other"=>"%{count} सेकंड"}},
   "prompts"=>
    {"day"=>"दिन",
     "hour"=>"घंटा",
     "minute"=>"क्षण",
     "month"=>"माह",
     "second"=>"सेकंड",
     "year"=>"वर्ष"}}}
  end
end
