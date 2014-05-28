# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  module Locale

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/ca.yml

    Locale_ca =
{"date"=>
  {"abbr_day_names"=>["Dg", "Dl", "Dm", "Dc", "Dj", "Dv", "Ds"],
   "abbr_month_names"=>
    [nil,
     "Gen",
     "Feb",
     "Mar",
     "Abr",
     "Mai",
     "Jun",
     "Jul",
     "Ago",
     "Set",
     "Oct",
     "Nov",
     "Des"],
   "day_names"=>
    ["Diumenge",
     "Dilluns",
     "Dimarts",
     "Dimecres",
     "Dijous",
     "Divendres",
     "Dissabte"],
   "formats"=>
    {"default"=>"%d-%m-%Y", "long"=>"%d de %B de %Y", "short"=>"%d de %b"},
   "month_names"=>
    [nil,
     "Gener",
     "Febrer",
     "Març",
     "Abril",
     "Maig",
     "Juny",
     "Juliol",
     "Agost",
     "Setembre",
     "Octubre",
     "Novembre",
     "Desembre"],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"am",
   "formats"=>
    {"default"=>"%A, %d de %B de %Y %H:%M:%S %z",
     "long"=>"%d de %B de %Y %H:%M",
     "short"=>"%d de %b %H:%M",
     "time"=>"%H:%M:%S %z"},
   "pm"=>"pm"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"one"=>"aproximadament 1 hora",
       "other"=>"aproximadament %{count} hores"},
     "about_x_months"=>
      {"one"=>"aproximadament 1 mes",
       "other"=>"aproximadament %{count} mesos"},
     "about_x_years"=>
      {"one"=>"aproximadament 1 any", "other"=>"aproximadament %{count} anys"},
     "almost_x_years"=>{"one"=>"quasi 1 any", "other"=>"quasi %{count} anys"},
     "half_a_minute"=>"mig minut",
     "less_than_x_minutes"=>
      {"one"=>"menys d'1 minut", "other"=>"menys de %{count} minuts"},
     "less_than_x_seconds"=>
      {"one"=>"menys d'1 segon", "other"=>"menys de %{count} segons"},
     "over_x_years"=>{"one"=>"més d'1 any", "other"=>"més de %{count} anys"},
     "x_days"=>{"one"=>"1 dia", "other"=>"%{count} dies"},
     "x_minutes"=>{"one"=>"1 minut", "other"=>"%{count} minuts"},
     "x_months"=>{"one"=>"1 mes", "other"=>"%{count} mesos"},
     "x_seconds"=>{"one"=>"1 segon", "other"=>"%{count} segons"}},
   "prompts"=>
    {"day"=>"dia",
     "hour"=>"hora",
     "minute"=>"minut",
     "month"=>"mes",
     "second"=>"segon",
     "year"=>"any"}}}
  end
end
