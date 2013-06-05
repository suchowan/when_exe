# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::BasicTypes
  class M17n

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/eu.yml

    Locale_eu =
{"date"=>
  {"abbr_day_names"=>
    ["Igan", "Astel", "Astear", "Asteaz", "Oste", "Osti", "Lar"],
   "abbr_month_names"=>
    [nil,
     "Urt",
     "Ots",
     "Mar",
     "Api",
     "Mai",
     "Eka",
     "Uzt",
     "Abu",
     "Ira",
     "Urr",
     "Aza",
     "Aben"],
   "day_names"=>
    ["Igandea",
     "Astelehena",
     "Asteartea",
     "Asteazkena",
     "Osteguna",
     "Ostirala",
     "Larunbata"],
   "formats"=>
    {"default"=>"%Y/%m/%e", "long"=>"%Y(e)ko %Bk %e", "short"=>"%b %e"},
   "month_names"=>
    [nil,
     "Urtarrila",
     "Otsaila",
     "Martxoa",
     "Apirila",
     "Maiatza",
     "Ekaina",
     "Uztaila",
     "Abuztua",
     "Iraila",
     "Urria",
     "Azaroa",
     "Abendua"],
   "order"=>[:year, :month, :day]},
 "time"=>
  {"am"=>"am",
   "formats"=>
    {"default"=>"%A, %Y(e)ko %Bren %e %H:%M:%S %z",
     "long"=>"%Y(e)ko %Bren %e,  %H:%M",
     "short"=>"%b %e, %H:%M",
     "time"=>"%H:%M:%S %z"},
   "pm"=>"pm"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"one"=>"ordu bat inguru", "other"=>"%{count} ordu inguru"},
     "about_x_months"=>
      {"one"=>"hilabete bat inguru", "other"=>"%{count} hilabete inguru"},
     "about_x_years"=>
      {"one"=>"urte bat inguru", "other"=>"%{count} urte inguru"},
     "almost_x_years"=>{"one"=>"ia urte bat", "other"=>"ia %{count} urte"},
     "half_a_minute"=>"minutu erdi",
     "less_than_x_minutes"=>
      {"one"=>"1 minutu bat baino gutxiago",
       "other"=>"%{count} minutu baino gutxiago"},
     "less_than_x_seconds"=>
      {"one"=>"segundu bat baino gutxiago",
       "other"=>"%{count} segundu baino gutxiago"},
     "over_x_years"=>
      {"one"=>"urte bat baino gehiago",
       "other"=>"%{count} urte baino gehiago"},
     "x_days"=>{"one"=>"egun bat", "other"=>"%{count} egun"},
     "x_minutes"=>{"one"=>"minutu bat", "other"=>"%{count} minutu"},
     "x_months"=>{"one"=>"hilabete bat", "other"=>"%{count} hilabete"},
     "x_seconds"=>{"one"=>"segundu bat", "other"=>"%{count} segundu"}},
   "prompts"=>
    {"day"=>"Egun",
     "hour"=>"Ordu",
     "minute"=>"Minutu",
     "month"=>"Hilabete",
     "second"=>"Segundu",
     "year"=>"Urte"}}}
  end
end
