# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::BasicTypes
  class M17n

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/de-AT.yml

    Locale_de_AT =
{"date"=>
  {"abbr_day_names"=>["So", "Mo", "Di", "Mi", "Do", "Fr", "Sa"],
   "abbr_month_names"=>
    [nil,
     "Jän",
     "Feb",
     "Mär",
     "Apr",
     "Mai",
     "Jun",
     "Jul",
     "Aug",
     "Sep",
     "Okt",
     "Nov",
     "Dez"],
   "day_names"=>
    ["Sonntag",
     "Montag",
     "Dienstag",
     "Mittwoch",
     "Donnerstag",
     "Freitag",
     "Samstag"],
   "formats"=>{"default"=>"%d.%m.%Y", "long"=>"%e. %B %Y", "short"=>"%e. %b"},
   "month_names"=>
    [nil,
     "Jänner",
     "Februar",
     "März",
     "April",
     "Mai",
     "Juni",
     "Juli",
     "August",
     "September",
     "Oktober",
     "November",
     "Dezember"],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"vormittags",
   "formats"=>
    {"default"=>"%A, %d. %B %Y, %H:%M Uhr",
     "long"=>"%A, %d. %B %Y, %H:%M Uhr",
     "short"=>"%d. %B, %H:%M Uhr",
     "time"=>"%H:%M Uhr"},
   "pm"=>"nachmittags"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"one"=>"etwa eine Stunde", "other"=>"etwa %{count} Stunden"},
     "about_x_months"=>
      {"one"=>"etwa ein Monat", "other"=>"etwa %{count} Monate"},
     "about_x_years"=>{"one"=>"etwa ein Jahr", "other"=>"etwa %{count} Jahre"},
     "almost_x_years"=>
      {"one"=>"fast ein Jahr", "other"=>"fast %{count} Jahre"},
     "half_a_minute"=>"eine halbe Minute",
     "less_than_x_minutes"=>
      {"one"=>"weniger als eine Minute",
       "other"=>"weniger als %{count} Minuten"},
     "less_than_x_seconds"=>
      {"one"=>"weniger als eine Sekunde",
       "other"=>"weniger als %{count} Sekunden"},
     "over_x_years"=>
      {"one"=>"mehr als ein Jahr", "other"=>"mehr als %{count} Jahre"},
     "x_days"=>{"one"=>"ein Tag", "other"=>"%{count} Tage"},
     "x_minutes"=>{"one"=>"eine Minute", "other"=>"%{count} Minuten"},
     "x_months"=>{"one"=>"ein Monat", "other"=>"%{count} Monate"},
     "x_seconds"=>{"one"=>"eine Sekunde", "other"=>"%{count} Sekunden"}},
   "prompts"=>
    {"day"=>"Tag",
     "hour"=>"Stunden",
     "minute"=>"Minuten",
     "month"=>"Monat",
     "second"=>"Sekunden",
     "year"=>"Jahr"}}}
  end
end
