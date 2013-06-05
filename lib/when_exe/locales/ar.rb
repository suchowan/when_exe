# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::BasicTypes
  class M17n

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
      {"zero"=>"%{count} ساعات",
       "one"=>"حوالي ساعة واحدة",
       "two"=>"%{count} ساعات",
       "few"=>"%{count} ساعات",
       "many"=>"%{count} ساعات",
       "other"=>"%{count} ساعات"},
     "about_x_months"=>
      {"zero"=>"%{count} أشهر",
       "one"=>"حوالي شهر واحد",
       "two"=>"%{count} أشهر",
       "few"=>"%{count} أشهر",
       "many"=>"%{count} أشهر",
       "other"=>"%{count} أشهر"},
     "about_x_years"=>
      {"zero"=>"%{count} سنوات",
       "one"=>"حوالي سنة",
       "two"=>"%{count} سنوات",
       "few"=>"%{count} سنوات",
       "many"=>"%{count} سنوات",
       "other"=>"%{count} سنوات"},
     "almost_x_years"=>
      {"zero"=>"ما يقرب من %{count} سنة",
       "one"=>"تقريبا سنة واحدة",
       "two"=>"ما يقرب من %{count} سنة",
       "few"=>"ما يقرب من %{count} سنة",
       "many"=>"ما يقرب من %{count} سنة",
       "other"=>"ما يقرب من %{count} سنة"},
     "half_a_minute"=>"نصف دقيقة",
     "less_than_x_minutes"=>
      {"zero"=>"%{count} دقائق",
       "one"=>"أقل من دقيقة",
       "two"=>"%{count} دقائق",
       "few"=>"%{count} دقائق",
       "many"=>"%{count} دقائق",
       "other"=>"%{count} دقائق"},
     "less_than_x_seconds"=>
      {"zero"=>"%{count} ثوان",
       "one"=>"أقل من ثانية",
       "two"=>"%{count} ثوان",
       "few"=>"%{count} ثوان",
       "many"=>"%{count} ثوان",
       "other"=>"%{count} ثوان"},
     "over_x_years"=>
      {"zero"=>"%{count} سنوات",
       "one"=>"أكثر من سنة",
       "two"=>"%{count} سنوات",
       "few"=>"%{count} سنوات",
       "many"=>"%{count} سنوات",
       "other"=>"%{count} سنوات"},
     "x_days"=>
      {"zero"=>"%{count} أيام",
       "one"=>"يوم واحد",
       "two"=>"%{count} أيام",
       "few"=>"%{count} أيام",
       "many"=>"%{count} أيام",
       "other"=>"%{count} أيام"},
     "x_minutes"=>
      {"zero"=>"%{count} دقائق",
       "one"=>"دقيقة واحدة",
       "two"=>"%{count} دقائق",
       "few"=>"%{count} دقائق",
       "many"=>"%{count} دقائق",
       "other"=>"%{count} دقائق"},
     "x_months"=>
      {"zero"=>"%{count} أشهر",
       "one"=>"شهر واحد",
       "two"=>"%{count} أشهر",
       "few"=>"%{count} أشهر",
       "many"=>"%{count} أشهر",
       "other"=>"%{count} أشهر"},
     "x_seconds"=>
      {"zero"=>"%{count} ثوان",
       "one"=>"ثانية واحدة",
       "two"=>"%{count} ثوان",
       "few"=>"%{count} ثوان",
       "many"=>"%{count} ثوان",
       "other"=>"%{count} ثوان"}},
   "prompts"=>
    {"day"=>"اليوم",
     "hour"=>"ساعة",
     "minute"=>"دقيقة",
     "month"=>"الشهر",
     "second"=>"ثانية",
     "year"=>"السنة"}}}
  end
end
