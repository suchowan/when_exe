# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  module Locale

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/ro.yml

    Locale_ro =
{"date"=>
  {"abbr_day_names"=>["Dum", "Lun", "Mar", "Mie", "Joi", "Vin", "Sâm"],
   "abbr_month_names"=>
    [nil,
     "Ian",
     "Feb",
     "Mar",
     "Apr",
     "Mai",
     "Iun",
     "Iul",
     "Aug",
     "Sep",
     "Oct",
     "Noi",
     "Dec"],
   "day_names"=>
    ["Duminică", "Luni", "Marți", "Miercuri", "Joi", "Vineri", "Sâmbată"],
   "formats"=>{"default"=>"%d-%m-%Y", "long"=>"%d %B %Y", "short"=>"%d %b"},
   "month_names"=>
    [nil,
     "Ianuarie",
     "Februarie",
     "Martie",
     "Aprilie",
     "Mai",
     "Iunie",
     "Iulie",
     "August",
     "Septembrie",
     "Octombrie",
     "Noiembrie",
     "Decembrie"],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"",
   "formats"=>
    {"default"=>"%a %d %b %Y, %H:%M:%S %z",
     "long"=>"%d %B %Y %H:%M",
     "short"=>"%d %b %H:%M",
     "time"=>"%H:%M:%S %z"},
   "pm"=>""},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"one"=>"aproximativ o oră",
       "few"=>"aproximativ %{count} ore",
       "other"=>"aproximativ %{count} ore"},
     "about_x_months"=>
      {"one"=>"aproximativ o lună",
       "few"=>"aproximativ %{count} luni",
       "other"=>"aproximativ %{count} luni"},
     "about_x_years"=>
      {"one"=>"aproximativ un an",
       "few"=>"aproximativ %{count} ani",
       "other"=>"aproximativ %{count} ani"},
     "almost_x_years"=>
      {"one"=>"aproape 1 an",
       "few"=>"aproape %{count} ani",
       "other"=>"aproape %{count} ani"},
     "half_a_minute"=>"jumătate de minut",
     "less_than_x_minutes"=>
      {"one"=>"mai puțin de un minut",
       "few"=>"mai puțin de %{count} minute",
       "other"=>"mai puțin de %{count} minute"},
     "less_than_x_seconds"=>
      {"one"=>"mai puțin de o secundă",
       "few"=>"mai puțin de %{count} secunde",
       "other"=>"mai puțin de %{count} secunde"},
     "over_x_years"=>
      {"one"=>"mai mult de un an",
       "few"=>"mai mult de %{count} ani",
       "other"=>"mai mult de %{count} ani"},
     "x_days"=>
      {"one"=>"1 zi", "few"=>"%{count} zile", "other"=>"%{count} zile"},
     "x_minutes"=>
      {"one"=>"1 minut", "few"=>"%{count} minute", "other"=>"%{count} minute"},
     "x_months"=>
      {"one"=>"1 lună", "few"=>"%{count} luni", "other"=>"%{count} luni"},
     "x_seconds"=>
      {"one"=>"1 secundă",
       "few"=>"%{count} secunde",
       "other"=>"%{count} secunde"}},
   "prompts"=>
    {"day"=>"Ziua",
     "hour"=>"Ora",
     "minute"=>"Minutul",
     "month"=>"Luna",
     "second"=>"Secunda",
     "year"=>"Anul"}}}
  end
end
