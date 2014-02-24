# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::BasicTypes
  class M17n

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/fa.yml

    Locale_fa =
{"date"=>
  {"abbr_day_names"=>["ی", "د", "س", "چ", "پ", "ج", "ش"],
   "abbr_month_names"=>
    [nil,
     "ژانویه",
     "فوریه",
     "مارس",
     "آوریل",
     "مه",
     "ژوئن",
     "ژوئیه",
     "اوت",
     "سپتامبر",
     "اکتبر",
     "نوامبر",
     "دسامبر"],
   "day_names"=>
    ["یکشنبه", "دوشنبه", "سه‌شنبه", "چهارشنبه", "پنج‌شنبه", "جمعه", "شنبه"],
   "formats"=>{"default"=>"%Y/%m/%d", "long"=>"%e %B %Y", "short"=>"%m/%d"},
   "month_names"=>
    [nil,
     "ژانویه",
     "فوریه",
     "مارس",
     "آوریل",
     "مه",
     "ژوئن",
     "ژوئیه",
     "اوت",
     "سپتامبر",
     "اکتبر",
     "نوامبر",
     "دسامبر"],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"قبل از ظهر",
   "formats"=>
    {"default"=>"%A، %e %B %Y، ساعت %H:%M:%S (%Z)",
     "long"=>"%e %B %Y، ساعت %H:%M",
     "short"=>"%e %B، ساعت %H:%M",
     "time"=>"%H:%M:%S (%Z)"},
   "pm"=>"بعد از ظهر"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>{"one"=>"حدود یک ساعت", "other"=>"حدود %{count} ساعت"},
     "about_x_months"=>{"one"=>"حدود یک ماه", "other"=>"حدود %{count} ماه"},
     "about_x_years"=>{"one"=>"حدود یک سال", "other"=>"حدود %{count} سال"},
     "almost_x_years"=>{"one"=>"حدود یک سال", "other"=>"حدود %{count} سال"},
     "half_a_minute"=>"نیم دقیقه",
     "less_than_x_minutes"=>
      {"one"=>"کمتر از یک دقیقه", "other"=>"کمتر از %{count} دقیقه"},
     "less_than_x_seconds"=>
      {"one"=>"یک ثانیه", "other"=>"کمتر  از %{count} ثانیه"},
     "over_x_years"=>{"one"=>"بیش از یک سال", "other"=>"بیش از %{count} سال"},
     "x_days"=>{"one"=>"یک روز", "other"=>"%{count} روز"},
     "x_minutes"=>{"one"=>"یک دقیقه", "other"=>"%{count} دقیقه"},
     "x_months"=>{"one"=>"یک ماه", "other"=>"%{count} ماه"},
     "x_seconds"=>{"one"=>"یک ثانیه", "other"=>"%{count} ثانیه"}},
   "prompts"=>
    {"day"=>"روز",
     "hour"=>"ساعت",
     "minute"=>"دقیقه",
     "month"=>"ماه",
     "second"=>"ثانیه",
     "year"=>"سال"}}}
  end
end
