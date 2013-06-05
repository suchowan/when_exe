# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::BasicTypes
  class M17n

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/et.yml

    Locale_et =
{"date"=>
  {"abbr_day_names"=>["P", "E", "T", "K", "N", "R", "L"],
   "abbr_month_names"=>
    [nil,
     "jaan.",
     "veebr.",
     "märts",
     "apr.",
     "mai",
     "juuni",
     "juuli",
     "aug.",
     "sept.",
     "okt.",
     "nov.",
     "dets."],
   "day_names"=>
    ["pühapäev",
     "esmaspäev",
     "teisipäev",
     "kolmapäev",
     "neljapäev",
     "reede",
     "laupäev"],
   "formats"=>
    {"default"=>"%d.%m.%Y", "long"=>"%d. %B %Y", "short"=>"%d.%m.%y"},
   "month_names"=>
    [nil,
     "jaanuar",
     "veebruar",
     "märts",
     "aprill",
     "mai",
     "juuni",
     "juuli",
     "august",
     "september",
     "oktoober",
     "november",
     "detsember"],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"enne lõunat",
   "formats"=>
    {"default"=>"%d. %B %Y, %H:%M",
     "long"=>"%a, %d. %b %Y, %H:%M:%S %z",
     "short"=>"%d.%m.%y, %H:%M",
     "time"=>"%H:%M"},
   "pm"=>"pärast lõunat"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"one"=>"umbes %{count} tund", "other"=>"umbes %{count} tundi"},
     "about_x_months"=>
      {"one"=>"umbes %{count} kuu", "other"=>"umbes %{count} kuud"},
     "about_x_years"=>
      {"one"=>"umbes %{count} aasta", "other"=>"umbes %{count} aastat"},
     "almost_x_years"=>
      {"one"=>"peaaegu üks aasta", "other"=>"peaaegu %{count} aastat"},
     "half_a_minute"=>"pool minutit",
     "less_than_x_minutes"=>
      {"one"=>"vähem kui %{count} minut",
       "other"=>"vähem kui %{count} minutit"},
     "less_than_x_seconds"=>
      {"one"=>"vähem kui %{count} sekund",
       "other"=>"vähem kui %{count} sekundit"},
     "over_x_years"=>
      {"one"=>"üle %{count} aasta", "other"=>"üle %{count} aasta"},
     "x_days"=>{"one"=>"%{count} päev", "other"=>"%{count} päeva"},
     "x_minutes"=>{"one"=>"%{count} minut", "other"=>"%{count} minutit"},
     "x_months"=>{"one"=>"%{count} kuu", "other"=>"%{count} kuud"},
     "x_seconds"=>{"one"=>"%{count} sekund", "other"=>"%{count} sekundit"}},
   "prompts"=>
    {"day"=>"Päev",
     "hour"=>"Tunde",
     "minute"=>"Minutit",
     "month"=>"Kuu",
     "second"=>"Sekundit",
     "year"=>"Aasta"}}}
  end
end
