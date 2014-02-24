# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::BasicTypes
  class M17n

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/he.yml

    Locale_he =
{"date"=>
  {"abbr_day_names"=>["א", "ב", "ג", "ד", "ה", "ו", "ש"],
   "abbr_month_names"=>
    [nil,
     "יאנ",
     "פבר",
     "מרץ",
     "אפר",
     "מאי",
     "יונ",
     "יול",
     "אוג",
     "ספט",
     "אוק",
     "נוב",
     "דצמ"],
   "day_names"=>["ראשון", "שני", "שלישי", "רביעי", "חמישי", "שישי", "שבת"],
   "formats"=>{"default"=>"%d-%m-%Y", "long"=>"%e ב%B, %Y", "short"=>"%e %b"},
   "month_names"=>
    [nil,
     "ינואר",
     "פברואר",
     "מרץ",
     "אפריל",
     "מאי",
     "יוני",
     "יולי",
     "אוגוסט",
     "ספטמבר",
     "אוקטובר",
     "נובמבר",
     "דצמבר"],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"am",
   "formats"=>
    {"default"=>"%a %d %b %H:%M:%S %Z %Y",
     "long"=>"%d ב%B, %Y %H:%M",
     "short"=>"%d %b %H:%M",
     "time"=>"%H:%M:%S %Z"},
   "pm"=>"pm"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>{"one"=>"בערך שעה אחת", "other"=>"בערך %{count} שעות"},
     "about_x_months"=>
      {"one"=>"בערך חודש אחד", "other"=>"בערך %{count} חודשים"},
     "about_x_years"=>{"one"=>"בערך שנה אחת", "other"=>"בערך %{count} שנים"},
     "almost_x_years"=>{"one"=>"כמעט שנה", "other"=>"כמעט %{count} שנים"},
     "half_a_minute"=>"חצי דקה",
     "less_than_x_minutes"=>
      {"one"=>"פחות מדקה אחת",
       "other"=>"פחות מ- %{count} דקות",
       "zero"=>"פחות מדקה אחת"},
     "less_than_x_seconds"=>
      {"one"=>"פחות משניה אחת",
       "other"=>"פחות מ- %{count} שניות",
       "zero"=>"פחות משניה אחת"},
     "over_x_years"=>{"one"=>"מעל שנה אחת", "other"=>"מעל %{count} שנים"},
     "x_days"=>{"one"=>"יום אחד", "other"=>"%{count} ימים"},
     "x_minutes"=>{"one"=>"דקה אחת", "other"=>"%{count} דקות"},
     "x_months"=>{"one"=>"חודש אחד", "other"=>"%{count} חודשים"},
     "x_seconds"=>{"one"=>"שניה אחת", "other"=>"%{count} שניות"}},
   "prompts"=>
    {"day"=>"יום",
     "hour"=>"שעה",
     "minute"=>"דקה",
     "month"=>"חודש",
     "second"=>"שניות",
     "year"=>"שנה"}}}
  end
end
