# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::BasicTypes
  class M17n

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/pt-BR.yml

    Locale_pt_BR =
{"date"=>
  {"abbr_day_names"=>["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sáb"],
   "abbr_month_names"=>
    [nil,
     "Jan",
     "Fev",
     "Mar",
     "Abr",
     "Mai",
     "Jun",
     "Jul",
     "Ago",
     "Set",
     "Out",
     "Nov",
     "Dez"],
   "day_names"=>
    ["Domingo", "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado"],
   "formats"=>
    {"default"=>"%d/%m/%Y", "long"=>"%d de %B de %Y", "short"=>"%d de %B"},
   "month_names"=>
    [nil,
     "Janeiro",
     "Fevereiro",
     "Março",
     "Abril",
     "Maio",
     "Junho",
     "Julho",
     "Agosto",
     "Setembro",
     "Outubro",
     "Novembro",
     "Dezembro"],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"",
   "formats"=>
    {"default"=>"%a, %d de %B de %Y, %H:%M:%S %z",
     "long"=>"%d de %B de %Y, %H:%M",
     "short"=>"%d de %B, %H:%M",
     "time"=>"%H:%M:%S %z"},
   "pm"=>""},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"one"=>"aproximadamente 1 hora",
       "other"=>"aproximadamente %{count} horas"},
     "about_x_months"=>
      {"one"=>"aproximadamente 1 mês",
       "other"=>"aproximadamente %{count} meses"},
     "about_x_years"=>
      {"one"=>"aproximadamente 1 ano",
       "other"=>"aproximadamente %{count} anos"},
     "almost_x_years"=>{"one"=>"quase 1 ano", "other"=>"quase %{count} anos"},
     "half_a_minute"=>"meio minuto",
     "less_than_x_minutes"=>
      {"one"=>"menos de um minuto", "other"=>"menos de %{count} minutos"},
     "less_than_x_seconds"=>
      {"one"=>"menos de 1 segundo", "other"=>"menos de %{count} segundos"},
     "over_x_years"=>
      {"one"=>"mais de 1 ano", "other"=>"mais de %{count} anos"},
     "x_days"=>{"one"=>"1 dia", "other"=>"%{count} dias"},
     "x_minutes"=>{"one"=>"1 minuto", "other"=>"%{count} minutos"},
     "x_months"=>{"one"=>"1 mês", "other"=>"%{count} meses"},
     "x_seconds"=>{"one"=>"1 segundo", "other"=>"%{count} segundos"}},
   "prompts"=>
    {"day"=>"Dia",
     "hour"=>"Hora",
     "minute"=>"Minuto",
     "month"=>"Mês",
     "second"=>"Segundo",
     "year"=>"Ano"}}}
  end
end
