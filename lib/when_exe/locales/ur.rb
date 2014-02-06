# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::BasicTypes
  class M17n

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/ur.yml

    Locale_ur =
{"date"=>
  {"abbr_day_names"=>
    ["اتوار", "سوموار", "منگل", "ندھ", "جمعرات", "جمعہ", "ہفتہ"],
   "abbr_month_names"=>
    [nil,
     "جنوری",
     "فروری",
     "مارچ",
     "اپریل",
     "مئی",
     "جون",
     "جولائی",
     "اگست",
     "ستمبر",
     "اکتوبر",
     "نومبر",
     "دسمبر"],
   "day_names"=>["اتوار", "سوموار", "منگل", "ندھ", "جمعرات", "جمعہ", "ہفتہ"],
   "formats"=>{"default"=>"%d %B %Y", "long"=>"%B %d، %Y", "short"=>"%d %b"},
   "month_names"=>
    [nil,
     "جنوری",
     "فروری",
     "مارچ",
     "اپریل",
     "مئی",
     "جون",
     "جولائی",
     "اگست",
     "ستمبر",
     "اکتوبر",
     "نومبر",
     "دسمبر"],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"صبح",
   "pm"=>"شام",
   "formats"=>
    {"default"=>"%a، %d %b %Y، %p %l:%M %Z",
     "long"=>"%B %d، %Y %p %H:%M",
     "short"=>"%d %b، %H:%M"}},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"one"=>"تقریبا ایک گھنٹہ", "other"=>"تقریبا %{count} گھنٹے"},
     "about_x_months"=>
      {"one"=>"تقریبا ایک مہینہ", "other"=>"تقریبا %{count} مہینہ"},
     "about_x_years"=>
      {"one"=>"تقریبا ایک سال", "other"=>"تقریبا %{count} سال"},
     "almost_x_years"=>
      {"one"=>"تقریبا ایک سال", "other"=>"تقریبا %{count} سال"},
     "half_a_minute"=>"آدھا منٹ",
     "less_than_x_minutes"=>
      {"one"=>"ایک مںٹ سے کم", "other"=>"%{count} مںٹوں سے کم"},
     "less_than_x_seconds"=>
      {"one"=>"ایک سیکنڈ سے کم", "other"=>"%{count} سیکنڈوں سے کم"},
     "over_x_years"=>
      {"one"=>"ایک سال سے زیادہ", "other"=>"%{count} سالوں سے زیادہ"},
     "x_days"=>{"one"=>"ایک دن", "other"=>"%{count} دن"},
     "x_minutes"=>{"one"=>"ایک منٹ", "other"=>"%{count} منٹ"},
     "x_months"=>{"one"=>"ایک ماہ", "other"=>"%{count} ماہ"},
     "x_seconds"=>{"one"=>"ایک سیکنڈ", "other"=>"%{count} سیکنڈ"}},
   "prompts"=>
    {"day"=>"دن",
     "hour"=>"گہنٹہ",
     "minute"=>"منٹ",
     "month"=>"ماہ",
     "second"=>"سیکنڈ",
     "year"=>"سال"}}}
  end
end
