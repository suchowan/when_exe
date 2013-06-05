# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::BasicTypes
  class M17n

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/hu.yml

    Locale_hu =
{"date"=>
  {"abbr_day_names"=>["v.", "h.", "k.", "sze.", "cs.", "p.", "szo."],
   "abbr_month_names"=>
    [nil,
     "jan.",
     "febr.",
     "márc.",
     "ápr.",
     "máj.",
     "jún.",
     "júl.",
     "aug.",
     "szept.",
     "okt.",
     "nov.",
     "dec."],
   "day_names"=>
    ["vasárnap", "hétfő", "kedd", "szerda", "csütörtök", "péntek", "szombat"],
   "formats"=>
    {"default"=>"%Y.%m.%d.", "long"=>"%Y. %B %e.", "short"=>"%b %e."},
   "month_names"=>
    [nil,
     "január",
     "február",
     "március",
     "április",
     "május",
     "június",
     "július",
     "augusztus",
     "szeptember",
     "október",
     "november",
     "december"],
   "order"=>[:year, :month, :day]},
 "time"=>
  {"am"=>"de.",
   "formats"=>
    {"default"=>"%Y. %b %e., %H:%M",
     "long"=>"%Y. %B %e., %A, %H:%M",
     "short"=>"%b %e., %H:%M",
     "time"=>"%H:%M"},
   "pm"=>"du."},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>{"one"=>"kb 1 óra", "other"=>"kb %{count} óra"},
     "about_x_months"=>{"one"=>"kb 1 hónap", "other"=>"kb %{count} hónap"},
     "about_x_years"=>{"one"=>"kb 1 év", "other"=>"kb %{count} év"},
     "almost_x_years"=>{"one"=>"majdnem 1 év", "other"=>"majdnem %{count} év"},
     "half_a_minute"=>"fél perc",
     "less_than_x_minutes"=>
      {"one"=>"kevesebb, mint 1 perc",
       "other"=>"kevesebb, mint %{count} perc"},
     "less_than_x_seconds"=>
      {"one"=>"kevesebb, mint 1 másodperc",
       "other"=>"kevesebb, mint %{count} másodperc"},
     "over_x_years"=>
      {"one"=>"több, mint 1 év", "other"=>"több, mint %{count} év"},
     "x_days"=>{"one"=>"1 nap", "other"=>"%{count} nap"},
     "x_minutes"=>{"one"=>"1 perc", "other"=>"%{count} perc"},
     "x_months"=>{"one"=>"1 hónap", "other"=>"%{count} hónap"},
     "x_seconds"=>{"one"=>"1 másodperc", "other"=>"%{count} másodperc"}},
   "prompts"=>
    {"day"=>"Nap",
     "hour"=>"Óra",
     "minute"=>"Perc",
     "month"=>"Hónap",
     "second"=>"Másodperc",
     "year"=>"Év"}}}
  end
end
