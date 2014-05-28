# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  module Locale

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/fi.yml

    Locale_fi =
{"date"=>
  {"abbr_day_names"=>["su", "ma", "ti", "ke", "to", "pe", "la"],
   "abbr_month_names"=>
    [nil,
     "tammi",
     "helmi",
     "maalis",
     "huhti",
     "touko",
     "kesä",
     "heinä",
     "elo",
     "syys",
     "loka",
     "marras",
     "joulu"],
   "day_names"=>
    ["sunnuntai",
     "maanantai",
     "tiistai",
     "keskiviikko",
     "torstai",
     "perjantai",
     "lauantai"],
   "formats"=>
    {"default"=>"%-d.%-m.%Y", "long"=>"%A %e. %Bta %Y", "short"=>"%d. %b"},
   "month_names"=>
    [nil,
     "tammikuu",
     "helmikuu",
     "maaliskuu",
     "huhtikuu",
     "toukokuu",
     "kesäkuu",
     "heinäkuu",
     "elokuu",
     "syyskuu",
     "lokakuu",
     "marraskuu",
     "joulukuu"],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"aamupäivä",
   "formats"=>
    {"default"=>"%A %e. %Bta %Y %H:%M:%S %z",
     "long"=>"%e. %Bta %Y %H.%M",
     "short"=>"%e.%m. %H.%M",
     "time"=>"%H:%M:%S %z"},
   "pm"=>"iltapäivä"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>{"one"=>"noin tunti", "other"=>"noin %{count} tuntia"},
     "about_x_months"=>
      {"one"=>"noin kuukausi", "other"=>"noin %{count} kuukautta"},
     "about_x_years"=>{"one"=>"vuosi", "other"=>"noin %{count} vuotta"},
     "almost_x_years"=>
      {"one"=>"melkein yksi vuosi", "other"=>"melkein %{count} vuotta"},
     "half_a_minute"=>"puoli minuuttia",
     "less_than_x_minutes"=>
      {"one"=>"alle minuutti", "other"=>"alle %{count} minuuttia"},
     "less_than_x_seconds"=>
      {"one"=>"alle sekunti", "other"=>"alle %{count} sekuntia"},
     "over_x_years"=>{"one"=>"yli vuosi", "other"=>"yli %{count} vuotta"},
     "x_days"=>{"one"=>"päivä", "other"=>"%{count} päivää"},
     "x_minutes"=>{"one"=>"minuutti", "other"=>"%{count} minuuttia"},
     "x_months"=>{"one"=>"kuukausi", "other"=>"%{count} kuukautta"},
     "x_seconds"=>{"one"=>"sekunti", "other"=>"%{count} sekuntia"}},
   "prompts"=>
    {"day"=>"päivä",
     "hour"=>"tunti",
     "minute"=>"minuutti",
     "month"=>"kuukausi",
     "second"=>"sekunti",
     "year"=>"vuosi"}}}
  end
end
