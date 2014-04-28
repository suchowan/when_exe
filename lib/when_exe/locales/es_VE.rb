# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::Parts::Locale

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/es-VE.yml

    Locale_es_VE =
{"date"=>
  {"abbr_day_names"=>["dom", "lun", "mar", "mié", "jue", "vie", "sáb"],
   "abbr_month_names"=>
    [nil,
     "ene",
     "feb",
     "mar",
     "abr",
     "may",
     "jun",
     "jul",
     "ago",
     "sep",
     "oct",
     "nov",
     "dic"],
   "day_names"=>
    ["domingo", "lunes", "martes", "miércoles", "jueves", "viernes", "sábado"],
   "formats"=>
    {"default"=>"%d/%m/%Y", "long"=>"%A, %d de %B de %Y", "short"=>"%d de %b"},
   "month_names"=>
    [nil,
     "enero",
     "febrero",
     "marzo",
     "abril",
     "mayo",
     "junio",
     "julio",
     "agosto",
     "septiembre",
     "octubre",
     "noviembre",
     "diciembre"],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"am",
   "formats"=>
    {"default"=>"%a, %d de %b de %Y a las %H:%M:%S%p %Z",
     "long"=>"%A, %d de %B de %Y a las %I:%M%p",
     "short"=>"%d de %b a las %H:%M%p",
     "time"=>"%H:%M:%S%p %Z"},
   "pm"=>"pm"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"one"=>"cerca de 1 hora", "other"=>"cerca de %{count} horas"},
     "about_x_months"=>
      {"one"=>"cerca de 1 mes", "other"=>"cerca de %{count} meses"},
     "about_x_years"=>
      {"one"=>"cerca de 1 año", "other"=>"cerca de %{count} años"},
     "almost_x_years"=>{"one"=>"casi 1 año", "other"=>"casi %{count} años"},
     "half_a_minute"=>"medio minuto",
     "less_than_x_minutes"=>
      {"one"=>"menos de 1 minuto", "other"=>"menos de %{count} minutos"},
     "less_than_x_seconds"=>
      {"one"=>"menos de 1 segundo", "other"=>"menos de %{count} segundos"},
     "over_x_years"=>{"one"=>"más de 1 año", "other"=>"más de %{count} años"},
     "x_days"=>{"one"=>"1 día", "other"=>"%{count} días"},
     "x_minutes"=>{"one"=>"1 minuto", "other"=>"%{count} minutos"},
     "x_months"=>{"one"=>"1 mes", "other"=>"%{count} meses"},
     "x_seconds"=>{"one"=>"1 segundo", "other"=>"%{count} segundos"}},
   "prompts"=>
    {"day"=>"Día",
     "hour"=>"Hora",
     "minute"=>"Minuto",
     "month"=>"Mes",
     "second"=>"Segundos",
     "year"=>"Año"}}}
end
