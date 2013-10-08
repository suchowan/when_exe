# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::BasicTypes
  class M17n

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/gl.yml

    Locale_gl =
{"date"=>
  {"abbr_day_names"=>["Dom", "Lun", "Mar", "Mer", "Xov", "Ven", "Sab"],
   "abbr_month_names"=>
    [nil,
     "Xan",
     "Feb",
     "Mar",
     "Abr",
     "Mai",
     "Xuñ",
     "Xul",
     "Ago",
     "Set",
     "Out",
     "Nov",
     "Dec"],
   "day_names"=>
    ["Domingo", "Luns", "Martes", "Mércores", "Xoves", "Venres", "Sábado"],
   "formats"=>
    {"default"=>"%e/%m/%Y", "long"=>"%A %e de %B de %Y", "short"=>"%e %b"},
   "month_names"=>
    [nil,
     "Xaneiro",
     "Febreiro",
     "Marzo",
     "Abril",
     "Maio",
     "Xuño",
     "Xullo",
     "Agosto",
     "Setembro",
     "Outubro",
     "Novembro",
     "Decembro"],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"",
   "formats"=>
    {"default"=>"%A, %e de %B de %Y ás %H:%M",
     "long"=>"%A %e de %B de %Y ás %H:%M",
     "short"=>"%e/%m, %H:%M",
     "time"=>"%H:%M"},
   "pm"=>""},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"one"=>"aproximadamente unha hora", "other"=>"%{count} horas"},
     "about_x_months"=>
      {"one"=>"aproximadamente 1 mes", "other"=>"%{count} meses"},
     "about_x_years"=>
      {"one"=>"aproximadamente 1 ano", "other"=>"%{count} anos"},
     "half_a_minute"=>"medio minuto",
     "less_than_x_minutes"=>
      {"one"=>"1 minuto",
       "other"=>"%{count} minutos",
       "zero"=>"menos dun minuto"},
     "less_than_x_seconds"=>
      {"few"=>"poucos segundos",
       "one"=>"1 segundo",
       "other"=>"%{count} segundos",
       "zero"=>"menos dun segundo"},
     "over_x_years"=>{"one"=>"máis dun ano", "other"=>"%{count} anos"},
     "x_days"=>{"one"=>"1 día", "other"=>"%{count} días"},
     "x_minutes"=>{"one"=>"1 minuto", "other"=>"%{count} minuto"},
     "x_months"=>{"one"=>"1 mes", "other"=>"%{count} meses"},
     "x_seconds"=>{"one"=>"1 segundo", "other"=>"%{count} segundos"}}}}
  end
end
