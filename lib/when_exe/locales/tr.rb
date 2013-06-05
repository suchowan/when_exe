# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::BasicTypes
  class M17n

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/tr.yml

    Locale_tr =
{"date"=>
  {"abbr_day_names"=>["Pzr", "Pzt", "Sal", "Çrş", "Prş", "Cum", "Cts"],
   "abbr_month_names"=>
    [nil,
     "Oca",
     "Şub",
     "Mar",
     "Nis",
     "May",
     "Haz",
     "Tem",
     "Ağu",
     "Eyl",
     "Eki",
     "Kas",
     "Ara"],
   "day_names"=>
    ["Pazar",
     "Pazartesi",
     "Salı",
     "Çarşamba",
     "Perşembe",
     "Cuma",
     "Cumartesi"],
   "formats"=>
    {"default"=>"%d.%m.%Y", "long"=>"%e %B %Y, %A", "short"=>"%e %b"},
   "month_names"=>
    [nil,
     "Ocak",
     "Şubat",
     "Mart",
     "Nisan",
     "Mayıs",
     "Haziran",
     "Temmuz",
     "Ağustos",
     "Eylül",
     "Ekim",
     "Kasım",
     "Aralık"],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"öğleden önce",
   "formats"=>
    {"default"=>"%a %d.%b.%y %H:%M",
     "long"=>"%e %B %Y, %A, %H:%M",
     "short"=>"%e %B, %H:%M",
     "time"=>"%H:%M"},
   "pm"=>"öğleden sonra"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"one"=>"yaklaşık 1 saat", "other"=>"yaklaşık %{count} saat"},
     "about_x_months"=>
      {"one"=>"yaklaşık 1 ay", "other"=>"yaklaşık %{count} ay"},
     "about_x_years"=>
      {"one"=>"yaklaşık 1 yıl", "other"=>"yaklaşık %{count} yıl"},
     "almost_x_years"=>
      {"one"=>"neredeyse 1 yıl", "other"=>"neredeyse %{count} yıl"},
     "half_a_minute"=>"yarım dakika",
     "less_than_x_minutes"=>
      {"one"=>"1 dakikadan az",
       "other"=>"%{count} dakikadan az",
       "zero"=>"1 dakikadan az"},
     "less_than_x_seconds"=>
      {"one"=>"1 saniyeden az",
       "other"=>"%{count} saniyeden az",
       "zero"=>"1 saniyeden az"},
     "over_x_years"=>
      {"one"=>"1 yıldan fazla", "other"=>"%{count} yıldan fazla"},
     "x_days"=>{"one"=>"1 gün", "other"=>"%{count} gün"},
     "x_minutes"=>{"one"=>"1 dakika", "other"=>"%{count} dakika"},
     "x_months"=>{"one"=>"1 ay", "other"=>"%{count} ay"},
     "x_seconds"=>{"one"=>"1 saniye", "other"=>"%{count} saniye"}},
   "prompts"=>
    {"day"=>"Gün",
     "hour"=>"Saat",
     "minute"=>"Dakika",
     "month"=>"Ay",
     "second"=>"Saniye",
     "year"=>"Yıl"}}}
  end
end
