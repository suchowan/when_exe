# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  module Locale

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
    {"about_x_hours"=>{"one"=>"kb. 1 órája", "other"=>"kb. %{count} órája"},
     "about_x_months"=>
      {"one"=>"kb. 1 hónapja", "other"=>"kb. %{count} hónapja"},
     "about_x_years"=>{"one"=>"kb. 1 éve", "other"=>"kb. %{count} éve"},
     "almost_x_years"=>
      {"one"=>"majdnem 1 éve", "other"=>"majdnem %{count} éve"},
     "half_a_minute"=>"fél perce",
     "less_than_x_minutes"=>
      {"one"=>"kevesebb, mint 1 perce",
       "other"=>"kevesebb, mint %{count} perce"},
     "less_than_x_seconds"=>
      {"one"=>"kevesebb, mint 1 másodperce",
       "other"=>"kevesebb, mint %{count} másodperce"},
     "over_x_years"=>
      {"one"=>"több, mint 1 éve", "other"=>"több, mint %{count} éve"},
     "x_days"=>{"one"=>"1 napja", "other"=>"%{count} napja"},
     "x_minutes"=>{"one"=>"1 perce", "other"=>"%{count} perce"},
     "x_months"=>{"one"=>"1 hónapja", "other"=>"%{count} hónapja"},
     "x_seconds"=>{"one"=>"1 másodperce", "other"=>"%{count} másodperce"}},
   "prompts"=>
    {"day"=>"Nap",
     "hour"=>"Óra",
     "minute"=>"Perc",
     "month"=>"Hónap",
     "second"=>"Másodperc",
     "year"=>"Év"}}}
  end
end
