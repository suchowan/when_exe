# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  module Locale

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/kn.yml

    Locale_kn =
{"date"=>
  {"abbr_day_names"=>["ರವಿ", "ಸೋಮ", "ಮಂಗಳ", "ಬುಧ", "ಗುರು", "ಶುಕ್ರ", "ಶನಿ"],
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
    ["ರವಿವಾರ", "ಸೋಮವಾರ", "ಮಂಗಳವಾರ", "ಬುಧವಾರ", "ಗುರುವಾರ", "ಶುಕ್ರವಾರ", "ಶನಿವಾರ"],
   "formats"=>{"default"=>"%Y-%m-%d", "long"=>"%B %d, %Y", "short"=>"%b %d"},
   "month_names"=>
    [nil,
     "ಜನವರಿ",
     "ಫೆಬ್ರವರಿ",
     "ಮಾರ್ಚ್",
     "ಏಪ್ರಿಲ್",
     "ಮೇ",
     "ಜೂನ್",
     "ಜುಲೈ",
     "ಆಗಸ್ಟ್",
     "ಸೆಪ್ಟೆಂಬರ್",
     "ಅಕ್ಟೋಬರ್",
     "ನವಂಬರ್",
     "ಡಿಸೆಂಬರ್"],
   "order"=>[:year, :month, :day]},
 "time"=>
  {"am"=>"ಪ್ರಾತಃಕಾಲ",
   "formats"=>
    {"default"=>"%a, %d %b %Y %H:%M:%S %z",
     "long"=>"%B %d, %Y %H:%M",
     "short"=>"%d %b %H:%M",
     "time"=>"%H:%M:%S %z"},
   "pm"=>"ಅಪರನ್ನಃ"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"one"=>"ಸುಮಾರು ಒಂದು ಗಂಟೆ", "other"=>"ಸುಮಾರು %{count} ಗಂಟೆಗಳು"},
     "about_x_months"=>
      {"one"=>"ಸುಮಾರು ಒಂದು ತಿಂಗಳು", "other"=>"ಸುಮಾರು %{count} ತಿಂಗಳುಗಳು"},
     "about_x_years"=>
      {"one"=>"ಸುಮಾರು ಒಂದು ವರುಷ", "other"=>"ಸುಮಾರು %{count} ವರುಷಗಳು"},
     "almost_x_years"=>
      {"one"=>"ಸರಿಸುಮಾರು ಒಂದು ವರುಷ", "other"=>"ಸರಿಸುಮಾರು %{count} ವರುಷಗಳು"},
     "half_a_minute"=>"ಒಂದು ಅರ್ಧ ನಿಮಿಷ",
     "less_than_x_minutes"=>
      {"one"=>"ಒಂದು ನಿಮಿಷಕ್ಕೂ ಕಡಿಮೆ", "other"=>"%{count} ನಿಮಿಷಕ್ಕಿಂತ ಕಡಿಮೆ"},
     "less_than_x_seconds"=>
      {"one"=>"ಒಂದು ಸೆಕೆಂಡಿಗೂ ಕಡಿಮೆ", "other"=>"%{count} ಸೆಕೆಂಡಿಗಿಂತ ಕಡಿಮೆ"},
     "over_x_years"=>
      {"one"=>"ಒಂದು ವರುಷಕ್ಕಿಂತ ಹೆಚ್ಚು",
       "other"=>"%{count} ವರುಷಗಳಿಗಿಂತ ಹೆಚ್ಚು"},
     "x_days"=>{"one"=>"1 ದಿನ", "other"=>"%{count} ದಿನಗಳು"},
     "x_minutes"=>{"one"=>"1 ನಿಮಿಷ", "other"=>"%{count} ನಿಮಿಷಗಳು"},
     "x_months"=>{"one"=>"1 ತಿಂಗಳು", "other"=>"%{count} ತಿಂಗಳುಗಳು"},
     "x_seconds"=>{"one"=>"1 ಸೆಕೆಂಡ್", "other"=>"%{count} ಸೆಕೆಂಡುಗಳು"}},
   "prompts"=>
    {"day"=>"ದಿನ",
     "hour"=>"ಗಂಟೆ",
     "minute"=>"ನಿಮಿಷ",
     "month"=>"ತಿಂಗಳು",
     "second"=>"ಸೆಕೆಂಡು",
     "year"=>"ವರುಷ"}}}
  end
end
