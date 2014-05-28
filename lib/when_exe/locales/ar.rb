# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  module Locale

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/ar.yml

    Locale_ar =
{"date"=>
  {"abbr_day_names"=>
    ["الأحد", "الإثنين", "الثلاثاء", "الأربعاء", "الخميس", "الجمعة", "السبت"],
   "abbr_month_names"=>
    [nil,
     "يناير",
     "فبراير",
     "مارس",
     "ابريل",
     "مايو",
     "يونيو",
     "يوليو",
     "اغسطس",
     "سبتمبر",
     "اكتوبر",
     "نوفمبر",
     "ديسمبر"],
   "day_names"=>
    ["الأحد", "الإثنين", "الثلاثاء", "الأربعاء", "الخميس", "الجمعة", "السبت"],
   "formats"=>{"default"=>"%Y-%m-%d", "long"=>"%B %e, %Y", "short"=>"%e %b"},
   "month_names"=>
    [nil,
     "يناير",
     "فبراير",
     "مارس",
     "ابريل",
     "مايو",
     "يونيو",
     "يوليو",
     "اغسطس",
     "سبتمبر",
     "اكتوبر",
     "نوفمبر",
     "ديسمبر"],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"صباحا",
   "formats"=>
    {"default"=>"%a %b %d %H:%M:%S %Z %Y",
     "long"=>"%B %d, %Y %H:%M",
     "short"=>"%d %b %H:%M",
     "time"=>"%H:%M:%S %Z"},
   "pm"=>"مساءا"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"zero"=>"حوالي %{count} ساعات",
       "one"=>"حوالي ساعة واحدة",
       "two"=>"حوالي ساعتان",
       "few"=>"حوالي %{count} ساعات",
       "many"=>"حوالي %{count} ساعة",
       "other"=>"حوالي %{count} ساعة"},
     "about_x_months"=>
      {"zero"=>"حوالي %{count} شهر",
       "one"=>"حوالي شهر واحد",
       "two"=>"حوالي شهران",
       "few"=>"حوالي %{count} أشهر",
       "many"=>"حوالي %{count} شهر",
       "other"=>"حوالي %{count} شهر"},
     "about_x_years"=>
      {"zero"=>"حوالي %{count} سنوات",
       "one"=>"حوالي سنة",
       "two"=>"حوالي سنتان",
       "few"=>"حوالي %{count} سنوات",
       "many"=>"حوالي %{count} سنة",
       "other"=>"حوالي %{count} سنة"},
     "almost_x_years"=>
      {"zero"=>"ما يقرب من %{count} سنة",
       "one"=>"تقريبا سنة واحدة",
       "two"=>"ما يقرب من سنتين",
       "few"=>"ما يقرب من %{count} سنوات",
       "many"=>"ما يقرب من %{count} سنة",
       "other"=>"ما يقرب من %{count} سنة"},
     "half_a_minute"=>"نصف دقيقة",
     "less_than_x_minutes"=>
      {"zero"=>"أقل من %{count} دقيقة",
       "one"=>"أقل من دقيقة",
       "two"=>"أقل من دقيقتان",
       "few"=>"أقل من %{count} دقائق",
       "many"=>"أقل من %{count} دقيقة",
       "other"=>"أقل من %{count} دقيقة"},
     "less_than_x_seconds"=>
      {"zero"=>"أقل من %{count} ثانية",
       "one"=>"أقل من ثانية",
       "two"=>"أقل من ثانيتان",
       "few"=>"أقل من %{count} ثوان",
       "many"=>"أقل من %{count} ثانية",
       "other"=>"أقل من %{count} ثانية"},
     "over_x_years"=>
      {"zero"=>"أكثر من %{count} سنة",
       "one"=>"أكثر من سنة",
       "two"=>"أكثر من سنتين",
       "few"=>"أكثر من %{count} سنوات",
       "many"=>"أكثر من %{count} سنة",
       "other"=>"أكثر من %{count} سنة"},
     "x_days"=>
      {"zero"=>"%{count} يوم",
       "one"=>"يوم واحد",
       "two"=>"يومان",
       "few"=>"%{count} أيام",
       "many"=>"%{count} يوم",
       "other"=>"%{count} يوم"},
     "x_minutes"=>
      {"zero"=>"%{count} دقيقة",
       "one"=>"دقيقة واحدة",
       "two"=>"دقيقتان",
       "few"=>"%{count} دقائق",
       "many"=>"%{count} دقيقة",
       "other"=>"%{count} دقيقة"},
     "x_months"=>
      {"zero"=>"%{count} شهر",
       "one"=>"شهر واحد",
       "two"=>"شهران",
       "few"=>"%{count} أشهر",
       "many"=>"%{count} شهر",
       "other"=>"%{count} شهر"},
     "x_seconds"=>
      {"zero"=>"%{count} ثانية",
       "one"=>"ثانية واحدة",
       "two"=>"ثانيتان",
       "few"=>"%{count} ثوان",
       "many"=>"%{count} ثانية",
       "other"=>"%{count} ثانية"}},
   "prompts"=>
    {"day"=>"اليوم",
     "hour"=>"ساعة",
     "minute"=>"دقيقة",
     "month"=>"الشهر",
     "second"=>"ثانية",
     "year"=>"السنة"}}}
  end
end
