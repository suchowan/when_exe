# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::BasicTypes
  class M17n

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/fr.yml

    Locale_fr =
{"date"=>
  {"formats"=>{"default"=>"%d/%m/%Y", "short"=>"%e %b", "long"=>"%e %B %Y"},
   "day_names"=>
    ["dimanche", "lundi", "mardi", "mercredi", "jeudi", "vendredi", "samedi"],
   "abbr_day_names"=>["dim", "lun", "mar", "mer", "jeu", "ven", "sam"],
   "month_names"=>
    [nil,
     "janvier",
     "février",
     "mars",
     "avril",
     "mai",
     "juin",
     "juillet",
     "août",
     "septembre",
     "octobre",
     "novembre",
     "décembre"],
   "abbr_month_names"=>
    [nil,
     "jan.",
     "fév.",
     "mar.",
     "avr.",
     "mai",
     "juin",
     "juil.",
     "août",
     "sept.",
     "oct.",
     "nov.",
     "déc."],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"formats"=>
    {"default"=>"%d %B %Y %H:%M:%S",
     "short"=>"%d %b %H:%M",
     "long"=>"%A %d %B %Y %H:%M",
     "time"=>"%H:%M:%S"},
   "am"=>"am",
   "pm"=>"pm"},
 "datetime"=>
  {"distance_in_words"=>
    {"half_a_minute"=>"une demi-minute",
     "less_than_x_seconds"=>
      {"zero"=>"moins d'une seconde",
       "one"=>"moins d'une seconde",
       "other"=>"moins de %{count} secondes"},
     "x_seconds"=>{"one"=>"1 seconde", "other"=>"%{count} secondes"},
     "less_than_x_minutes"=>
      {"zero"=>"moins d'une minute",
       "one"=>"moins d'une minute",
       "other"=>"moins de %{count} minutes"},
     "x_minutes"=>{"one"=>"1 minute", "other"=>"%{count} minutes"},
     "about_x_hours"=>
      {"one"=>"environ une heure", "other"=>"environ %{count} heures"},
     "x_days"=>{"one"=>"1 jour", "other"=>"%{count} jours"},
     "about_x_months"=>
      {"one"=>"environ un mois", "other"=>"environ %{count} mois"},
     "x_months"=>{"one"=>"1 mois", "other"=>"%{count} mois"},
     "about_x_years"=>
      {"one"=>"environ un an", "other"=>"environ %{count} ans"},
     "over_x_years"=>{"one"=>"plus d'un an", "other"=>"plus de %{count} ans"},
     "almost_x_years"=>
      {"one"=>"presqu'un an", "other"=>"presque %{count} ans"}},
   "prompts"=>
    {"year"=>"Année",
     "month"=>"Mois",
     "day"=>"Jour",
     "hour"=>"Heure",
     "minute"=>"Minute",
     "second"=>"Seconde"}}}
  end
end
