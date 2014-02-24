# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::BasicTypes
  class M17n

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/bn.yml

    Locale_bn =
{"date"=>
  {"abbr_day_names"=>
    ["রবিবার",
     "সোমবার",
     "মঙ্গলবার",
     "বুধবার",
     "বৃহস্পতিবার",
     "শুক্রবার",
     "শনিবার"],
   "abbr_month_names"=>
    [nil,
     "জানুয়ারি",
     "ফেব্রুয়ারি",
     "মার্চ",
     "এপ্রিল",
     "মে",
     "জুন",
     "জুলাই",
     "অগাস্ট",
     "সেপ্টেমবার",
     "অক্টোবার",
     "নভেম্বার",
     "ডিসেম্বার"],
   "day_names"=>
    ["রবিবার",
     "সোমবার",
     "মঙ্গলবার",
     "বুধবার",
     "বৃহস্পতিবার",
     "শুক্রবার",
     "শনিবার"],
   "formats"=>
    {"default"=>"%e/%m/%Y", "long"=>"%e de %B de %Y", "short"=>"%e de %b"},
   "month_names"=>
    [nil,
     "জানুয়ারি",
     "ফেব্রুয়ারি",
     "মার্চ",
     "এপ্রিল",
     "মে",
     "জুন",
     "জুলাই",
     "অগাস্ট",
     "সেপ্টেমবার",
     "অক্টোবার",
     "নভেম্বার",
     "ডিসেম্বার"],
   "order"=>[:year, :month, :day]},
 "time"=>
  {"am"=>"am",
   "formats"=>
    {"default"=>"%A, %e de %B de %Y %H:%M:%S %z",
     "long"=>"%e de %B de %Y %H:%M",
     "short"=>"%e de %b %H:%M",
     "time"=>"%H:%M:%S %z"},
   "pm"=>"pm"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"one"=>"প্রায় ১ ঘন্টা", "other"=>"প্রায় %{count} ঘন্টা"},
     "about_x_months"=>{"one"=>"প্রায় ১ মাস", "other"=>"প্রায় %{count} মাস"},
     "about_x_years"=>{"one"=>"প্রায় ১ বছর", "other"=>"প্রায় %{count} বছর"},
     "half_a_minute"=>"অার্ধেক মিনিট",
     "less_than_x_minutes"=>
      {"one"=>"১ মিনিটের কম", "other"=>"%{count} মিনিটের কম"},
     "less_than_x_seconds"=>
      {"one"=>"১ সেকেন্ডর কম ", "other"=>"%{count} সেকেন্ডের কম"},
     "over_x_years"=>{"one"=>"১ বছরের বেশি", "other"=>"%{count} বছরের বেশি"},
     "x_days"=>{"one"=>"১ দিন", "other"=>"%{count} দিন"},
     "x_minutes"=>{"one"=>"১ মিনিট", "other"=>"%{count} মিনিট"},
     "x_months"=>{"one"=>"১ মাস", "other"=>"%{count} মাস"},
     "x_seconds"=>{"one"=>"১ সেকেন্ড", "other"=>"%{count} সেকেন্ড"}},
   "prompts"=>
    {"day"=>"দিন",
     "hour"=>"ঘন্টা",
     "minute"=>"মিনিট",
     "month"=>"মাস",
     "second"=>"সেকেন্ড",
     "year"=>"বছর"}}}
  end
end
