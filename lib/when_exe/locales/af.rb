# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::BasicTypes
  class M17n

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/af.yml

    Locale_af =
{"date"=>
  {"abbr_day_names"=>["Son", "Maan", "Dins", "Woe", "Don", "Vry", "Sat"],
   "abbr_month_names"=>
    [nil,
     "Jan",
     "Feb",
     "Mar",
     "Apr",
     "Mei",
     "Jun",
     "Jul",
     "Aug",
     "Sep",
     "Okt",
     "Nov",
     "Des"],
   "day_names"=>
    ["Sondag",
     "Maandag",
     "Dinsdag",
     "Woensdag",
     "Donderdag",
     "Vrydag",
     "Saterdag"],
   "formats"=>{"default"=>"%Y-%m-%d", "long"=>"%B %d, %Y", "short"=>"%b %d"},
   "month_names"=>
    [nil,
     "Januarie",
     "Februarie",
     "Maart",
     "April",
     "Mai",
     "Junie",
     "Julie",
     "Augustus",
     "September",
     "Oktober",
     "November",
     "Desember"],
   "order"=>[:year, :month, :day]},
 "time"=>
  {"am"=>"vm",
   "formats"=>
    {"default"=>"%a, %d %b %Y %H:%M:%S %z",
     "long"=>"%B %d, %Y %H:%M",
     "short"=>"%d %b %H:%M",
     "time"=>"%H:%M:%S %z"},
   "pm"=>"nm"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"one"=>"ongeveer 1 uur", "other"=>"ongeveer %{count} ure"},
     "about_x_months"=>
      {"one"=>"ongeveer 1 maand", "other"=>"ongeveer %{count} maande"},
     "about_x_years"=>
      {"one"=>"ongeveer 1 jaar", "other"=>"ongeveer %{count} jaar"},
     "almost_x_years"=>{"one"=>"sowat 1 jaar", "other"=>"sowat %{count} jaar"},
     "half_a_minute"=>"halfminuut",
     "less_than_x_minutes"=>
      {"one"=>"minder as n minuut", "other"=>"minder as %{count} minute"},
     "less_than_x_seconds"=>
      {"one"=>"minder as 1 second", "other"=>"minder as %{count} sekondes"},
     "over_x_years"=>
      {"one"=>"meer as 1 jaar", "other"=>"meer as %{count} jaar"},
     "x_days"=>{"one"=>"1 dag", "other"=>"%{count} days"},
     "x_minutes"=>{"one"=>"1 minuut", "other"=>"%{count} minute"},
     "x_months"=>{"one"=>"1 maand", "other"=>"%{count} maande"},
     "x_seconds"=>{"one"=>"1 sekonde", "other"=>"%{count} sekondes"}},
   "prompts"=>
    {"day"=>"Dag",
     "hour"=>"Uur",
     "minute"=>"Minuut",
     "month"=>"Maand",
     "second"=>"Sekondes",
     "year"=>"Jaar"}}}
  end
end
