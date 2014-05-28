# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  module Locale

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/fr-CH.yml

    Locale_fr_CH =
{"date"=>
  {"abbr_day_names"=>["dim", "lun", "mar", "mer", "jeu", "ven", "sam"],
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
   "day_names"=>
    ["dimanche", "lundi", "mardi", "mercredi", "jeudi", "vendredi", "samedi"],
   "formats"=>{"default"=>"%d.%m.%Y", "long"=>"%e %B %Y", "short"=>"%e %b"},
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
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"am",
   "formats"=>
    {"default"=>"%d. %B %Y %H:%M",
     "long"=>"%A, %d. %B %Y %H:%M:%S %Z",
     "short"=>"%d. %b %H:%M",
     "time"=>"%H:%M"},
   "pm"=>"pm"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"one"=>"environ une heure", "other"=>"environ %{count} heures"},
     "about_x_months"=>
      {"one"=>"environ un mois", "other"=>"environ %{count} mois"},
     "about_x_years"=>
      {"one"=>"environ un an", "other"=>"environ %{count} ans"},
     "almost_x_years"=>
      {"one"=>"presqu'un an", "other"=>"presque %{count} ans"},
     "half_a_minute"=>"une demi-minute",
     "less_than_x_minutes"=>
      {"one"=>"moins d'une minute",
       "other"=>"moins de %{count} minutes",
       "zero"=>"moins d'une minute"},
     "less_than_x_seconds"=>
      {"one"=>"moins d'une seconde",
       "other"=>"moins de %{count} secondes",
       "zero"=>"moins d'une seconde"},
     "over_x_years"=>{"one"=>"plus d'un an", "other"=>"plus de %{count} ans"},
     "x_days"=>{"one"=>"1 jour", "other"=>"%{count} jours"},
     "x_minutes"=>{"one"=>"1 minute", "other"=>"%{count} minutes"},
     "x_months"=>{"one"=>"1 mois", "other"=>"%{count} mois"},
     "x_seconds"=>{"one"=>"1 seconde", "other"=>"%{count} secondes"}},
   "prompts"=>
    {"day"=>"Jour",
     "hour"=>"Heure",
     "minute"=>"Minute",
     "month"=>"Mois",
     "second"=>"Seconde",
     "year"=>"Année"}}}
  end
end
