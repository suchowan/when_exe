# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  module Locale

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/it.yml

    Locale_it =
{"date"=>
  {"abbr_day_names"=>["dom", "lun", "mar", "mer", "gio", "ven", "sab"],
   "abbr_month_names"=>
    [nil,
     "gen",
     "feb",
     "mar",
     "apr",
     "mag",
     "giu",
     "lug",
     "ago",
     "set",
     "ott",
     "nov",
     "dic"],
   "day_names"=>
    ["domenica",
     "lunedì",
     "martedì",
     "mercoledì",
     "giovedì",
     "venerdì",
     "sabato"],
   "formats"=>{"default"=>"%d/%m/%Y", "long"=>"%d %B %Y", "short"=>"%d %b"},
   "month_names"=>
    [nil,
     "gennaio",
     "febbraio",
     "marzo",
     "aprile",
     "maggio",
     "giugno",
     "luglio",
     "agosto",
     "settembre",
     "ottobre",
     "novembre",
     "dicembre"],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"am",
   "formats"=>
    {"default"=>"%a %d %b %Y, %H:%M:%S %z",
     "long"=>"%d %B %Y %H:%M",
     "short"=>"%d %b %H:%M",
     "time"=>"%H:%M:%S %z"},
   "pm"=>"pm"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>{"one"=>"circa un'ora", "other"=>"circa %{count} ore"},
     "about_x_months"=>
      {"one"=>"circa un mese", "other"=>"circa %{count} mesi"},
     "about_x_years"=>{"one"=>"circa un anno", "other"=>"circa %{count} anni"},
     "almost_x_years"=>{"one"=>"circa 1 anno", "other"=>"circa %{count} anni"},
     "half_a_minute"=>"mezzo minuto",
     "less_than_x_minutes"=>
      {"one"=>"meno di un minuto", "other"=>"meno di %{count} minuti"},
     "less_than_x_seconds"=>
      {"one"=>"meno di un secondo", "other"=>"meno di %{count} secondi"},
     "over_x_years"=>{"one"=>"oltre un anno", "other"=>"oltre %{count} anni"},
     "x_days"=>{"one"=>"1 giorno", "other"=>"%{count} giorni"},
     "x_minutes"=>{"one"=>"1 minuto", "other"=>"%{count} minuti"},
     "x_months"=>{"one"=>"1 mese", "other"=>"%{count} mesi"},
     "x_seconds"=>{"one"=>"1 secondo", "other"=>"%{count} secondi"}},
   "prompts"=>
    {"day"=>"Giorno",
     "hour"=>"Ora",
     "minute"=>"Minuto",
     "month"=>"Mese",
     "second"=>"Secondi",
     "year"=>"Anno"}}}
  end
end
