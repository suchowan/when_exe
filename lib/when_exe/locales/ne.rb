# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::Parts::Locale

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/ne.yml

    Locale_ne =
{"date"=>
  {"abbr_day_names"=>["आईत", "सोम", "मंगल", "बुध", "बिही", "शुक्र", "शनि"],
   "abbr_month_names"=>
    [nil,
     "जन.",
     "फेब्रु.",
     "मार्च",
     "अप्रिल",
     "मई",
     "जुन",
     "जुलाई",
     "अगष्ट",
     "सेप्ट.",
     "अक्टो.",
     "नोभ.",
     "डिसे."],
   "day_names"=>
    ["आईतबार", "सोमबार", "मंगलबार", "बुधबार", "बिहीबार", "शुक्रबार", "शनिबार"],
   "formats"=>{"default"=>"%Y-%m-%d", "long"=>"%B %d, %Y", "short"=>"%b %d"},
   "month_names"=>
    [nil,
     "जनवरी",
     "फेब्रुवरी",
     "मार्च",
     "अप्रिल",
     "मई",
     "जुन",
     "जुलाई",
     "अगष्ट",
     "सेप्टेम्बार",
     "अक्टोबर",
     "नोभेम्बर",
     "डिसेम्बर"],
   "order"=>[:year, :month, :day]},
 "time"=>
  {"am"=>"बिहान",
   "formats"=>
    {"default"=>"%a, %d %b %Y %H:%M:%S %z",
     "long"=>"%B %d, %Y %H:%M",
     "short"=>"%d %b %H:%M",
     "time"=>"%H:%M:%S %z"},
   "pm"=>"बेलुका"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>{"one"=>"लगभग 1 घण्टा", "other"=>"लगभग %{count} घण्टा"},
     "about_x_months"=>{"one"=>"लगभग 1 महिना", "other"=>"लगभग %{count} महिना"},
     "about_x_years"=>{"one"=>"लगभग 1 बर्ष", "other"=>"लगभग %{count} बर्ष"},
     "almost_x_years"=>{"one"=>"झण्डै 1 बर्ष", "other"=>"झण्डै %{count} बर्ष"},
     "half_a_minute"=>"आधा मिनेट",
     "less_than_x_minutes"=>
      {"one"=>"1 मिनेटभन्दा कम्ति", "other"=>"%{count} मिनेटभन्दा कम्ति"},
     "less_than_x_seconds"=>
      {"one"=>"1 सेकेण्डभन्दा कम्ति", "other"=>"%{count} सेकेण्डभन्दा कम्ति"},
     "over_x_years"=>
      {"one"=>"1 बर्षभन्दा बेसी", "other"=>"%{count} बर्षभन्दा बेसी"},
     "x_days"=>{"one"=>"1 दिन", "other"=>"%{count} दिन"},
     "x_minutes"=>{"one"=>"1 मिनेट", "other"=>"%{count} मिनेट"},
     "x_months"=>{"one"=>"1 महिना", "other"=>"%{count} महिना"},
     "x_seconds"=>{"one"=>"1 सेकेण्ड", "other"=>"%{count} सेकेण्ड"}},
   "prompts"=>
    {"day"=>"दिन",
     "hour"=>"घण्टा",
     "minute"=>"मिनेट",
     "month"=>"महिना",
     "second"=>"सेकेण्ड",
     "year"=>"बर्ष"}}}
end
