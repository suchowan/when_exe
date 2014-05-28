# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  module Locale

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/ta.yml

    Locale_ta =
{"date"=>
  {"abbr_day_names"=>
    ["ஞாயிறு", "திங்கள்", "செவ்வாய்", "புதன்", "வியாழன்", "வெள்ளி", "சனி"],
   "abbr_month_names"=>
    [nil,
     "ஜன",
     "பிப்",
     "மார்ச்",
     "ஏப்",
     "மே",
     "ஜூன்",
     "ஜூலை",
     "ஆக",
     "செப்",
     "அக்",
     "நவ",
     "டிச"],
   "day_names"=>
    ["ஞாயிற்றுக்கிழமை",
     "திங்கட்கிழமை",
     "செவ்வாய்க்கிழமை",
     "புதன்கிழமை",
     "வியாழக்கிழமை",
     "வெள்ளிக்கிழமை",
     "சனிக்கிழமை"],
   "formats"=>{"default"=>"%d-%m-%Y", "long"=>"%B %d, %Y", "short"=>"%b %d"},
   "month_names"=>
    [nil,
     "ஜனவரி",
     "பிப்ரவரி",
     "மார்ச்",
     "ஏப்ரல்",
     "மே",
     "ஜூன்",
     "ஜூலை",
     "ஆகஸ்ட்",
     "செப்டம்பர்",
     "அக்டோபர்",
     "நவம்பர்",
     "டிசம்பர்"],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"மு.ப.",
   "formats"=>
    {"default"=>"%a, %d %b %Y %H:%M:%S %z",
     "long"=>"%B %d, %Y %H:%M",
     "short"=>"%d %b %H:%M",
     "time"=>"%H:%M:%S %z"},
   "pm"=>"பி.ப."},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"one"=>"சுமார் 1 மணி நேரம்", "other"=>"சுமார் %{count} மணி"},
     "about_x_months"=>
      {"one"=>"சுமார் 1 மாதம்", "other"=>"சுமார் %{count} மாதங்களுக்கு"},
     "about_x_years"=>
      {"one"=>"சுமார் 1  ஆண்டு", "other"=>"சுமார் %{count}  ஆண்டுகள்"},
     "almost_x_years"=>
      {"one"=>"கிட்டத்தட்ட 1  ஆண்டு",
       "other"=>"கிட்டத்தட்ட %{count}  ஆண்டுகள்"},
     "half_a_minute"=>"அரை நிமிடம்",
     "less_than_x_minutes"=>
      {"one"=>"ஒரு நிமிடத்திற்கும் குறைவாக",
       "other"=>"குறைவாக %{count} நிமிடங்கள்"},
     "less_than_x_seconds"=>
      {"one"=>"ஒரு வினாடிக்கும் குறைவாக",
       "other"=>"குறைவாக %{count} வினாடிகள்"},
     "over_x_years"=>
      {"one"=>"ஒரு  ஆண்டிற்கு மேலாக", "other"=>"%{count}  ஆண்டிற்கு மேலாக"},
     "x_days"=>{"one"=>"1 நாள்", "other"=>"%{count} நாட்கள்"},
     "x_minutes"=>{"one"=>"1 நிமிடம்", "other"=>"%{count} நிமிடங்கள்"},
     "x_months"=>{"one"=>"1 மாதம்", "other"=>"%{count} மாதங்கள்"},
     "x_seconds"=>{"one"=>"1 வினாடி", "other"=>"%{count} விநாடிகள்"}},
   "prompts"=>
    {"day"=>"நாள்",
     "hour"=>"மணி",
     "minute"=>"நிமிடம்",
     "month"=>"மாதம்",
     "second"=>"விநாடிகள்",
     "year"=>"ஆண்டு"}}}
  end
end
