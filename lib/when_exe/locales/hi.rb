# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::BasicTypes
  class M17n

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/hi.yml

    Locale_hi =
{"date"=>
  {"abbr_day_names"=>["रवि", "सोम", "मंगल", "बुध", "गुरु", "शुक्र", "शनि"],
   "abbr_month_names"=>
    [nil,
     "जन",
     "फर",
     "मार्च",
     "अप्रै",
     "मई",
     "जून",
     "जुला",
     "अग",
     "सितं",
     "अक्टू",
     "नवं",
     "दिस"],
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
  {"am"=>"पूर्वाह्न",
   "formats"=>
    {"default"=>"%a, %d %b %Y %H:%M:%S %z",
     "long"=>"%B %d, %Y %H:%M",
     "short"=>"%d %b %H:%M",
     "time"=>"%H:%M:%S %z"},
   "pm"=>"अपराह्न"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>{"one"=>"लगभग एक घंटा", "other"=>"लगभग %{count} घंटा"},
     "about_x_months"=>{"one"=>"लगभग 1 महीना", "other"=>"लगभग %{count} महीना"},
     "about_x_years"=>{"one"=>"लगभग 1 साल", "other"=>"लगभग %{count} साल"},
     "almost_x_years"=>{"one"=>"लगभग एक साल", "other"=>"लगभग %{count} साल"},
     "half_a_minute"=>"एक आधा मिनट",
     "less_than_x_minutes"=>
      {"one"=>"एक मिनट से कम", "other"=>"%{count} मिनट से कम"},
     "less_than_x_seconds"=>
      {"one"=>"एक सेकेंड से कम", "other"=>"%{count}  सेकेंड से कम"},
     "over_x_years"=>{"one"=>"एक साल के ऊपर", "other"=>"%{count} साल से अधिक"},
     "x_days"=>{"one"=>"एक दिन", "other"=>"%{count} दिन"},
     "x_minutes"=>{"one"=>"एक मिनट", "other"=>"%{count} मिनट"},
     "x_months"=>{"one"=>"एक महीना", "other"=>"%{count} महीना"},
     "x_seconds"=>{"one"=>"एक सेकेंड", "other"=>"%{count} सेकेंड"}},
   "prompts"=>
    {"day"=>"दिन",
     "hour"=>"घंटा",
     "minute"=>"मिनट",
     "month"=>"माह",
     "second"=>"सेकेंड",
     "year"=>"वर्ष"}}}
  end
end
