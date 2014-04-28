# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::Parts::Locale

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/tl.yml

    Locale_tl =
{"date"=>
  {"formats"=>
    {"default"=>"%d/%m/%Y",
     "short"=>"ika-%d ng %b",
     "long"=>"ika-%d ng %B, %Y"},
   "day_names"=>
    ["Linggo",
     "Lunes",
     "Martes",
     "Miyerkules",
     "Huwebes",
     "Biyernes",
     "Sabado"],
   "abbr_day_names"=>["Lin", "Lun", "Mar", "Miy", "Huw", "Biy", "Sab"],
   "month_names"=>
    [nil,
     "Enero",
     "Pebrero",
     "Marso",
     "Abril",
     "Mayo",
     "Hunyo",
     "Hulyo",
     "Agosto",
     "Setyembre",
     "Oktubre",
     "Nobyembre",
     "Disyembre"],
   "abbr_month_names"=>
    [nil,
     "Ene",
     "Peb",
     "Mar",
     "Abr",
     "May",
     "Hun",
     "Hul",
     "Ago",
     "Set",
     "Okt",
     "Nob",
     "Dis"],
   "order"=>[:year, :month, :day]},
 "time"=>
  {"formats"=>
    {"default"=>"%A, ika-%d ng %B ng %Y %H:%M:%S %z",
     "short"=>"%d ng %b %H:%M",
     "long"=>"ika-%d ng %B ng %Y %H:%M",
     "time"=>"%H:%M:%S %z"},
   "am"=>"AM",
   "pm"=>"PM"},
 "datetime"=>
  {"distance_in_words"=>
    {"half_a_minute"=>"kalahating minuto",
     "less_than_x_seconds"=>
      {"one"=>"mas mababa sa isang segundo",
       "other"=>"mas mababa sa %{count} segundo"},
     "x_seconds"=>{"one"=>"isang segundo", "other"=>"%{count} segundo"},
     "less_than_x_minutes"=>
      {"one"=>"mas mababa sa isang minuto",
       "other"=>"mas mababa sa %{count} minuto"},
     "x_minutes"=>{"one"=>"isang minuto", "other"=>"%{count} minuto"},
     "about_x_hours"=>
      {"one"=>"humigit-kumulang isang oras",
       "other"=>"humigit-kumulang %{count} oras"},
     "x_days"=>{"one"=>"isang araw", "other"=>"%{count} araw"},
     "about_x_months"=>
      {"one"=>"humigit-kumulang isang buwan",
       "other"=>"humigit-kumulang %{count} buwan"},
     "x_months"=>{"one"=>"isang buwan", "other"=>"%{count} buwang"},
     "about_x_years"=>
      {"one"=>"humigit-kumulang isang taon",
       "other"=>"humigit-kumulang %{count} taon"},
     "over_x_years"=>
      {"one"=>"higit sa isang taon", "other"=>"higit %{count} taon"},
     "almost_x_years"=>
      {"one"=>"halos isang taon", "other"=>"halos %{count} taon"}},
   "prompts"=>
    {"year"=>"taon",
     "month"=>"buwan",
     "day"=>"araw",
     "hour"=>"oras",
     "minute"=>"minuto",
     "second"=>"segundo"}}}
end
