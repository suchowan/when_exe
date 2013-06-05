# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::BasicTypes
  class M17n

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/cs.yml

    Locale_cs =
{"date"=>
  {"abbr_day_names"=>["Ne", "Po", "Út", "St", "Čt", "Pá", "So"],
   "abbr_month_names"=>
    [nil,
     "Led",
     "Úno",
     "Bře",
     "Dub",
     "Kvě",
     "Čvn",
     "Čvc",
     "Srp",
     "Zář",
     "Říj",
     "Lis",
     "Pro"],
   "day_names"=>
    ["Neděle", "Pondělí", "Úterý", "Středa", "Čtvrtek", "Pátek", "Sobota"],
   "formats"=>{"default"=>"%d. %m. %Y", "long"=>"%d. %B %Y", "short"=>"%d %b"},
   "month_names"=>
    [nil,
     "Leden",
     "Únor",
     "Březen",
     "Duben",
     "Květen",
     "Červen",
     "Červenec",
     "Srpen",
     "Září",
     "Říjen",
     "Listopad",
     "Prosinec"],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"am",
   "formats"=>
    {"default"=>"%a %d. %B %Y %H:%M %z",
     "long"=>"%A %d. %B %Y %H:%M",
     "short"=>"%d. %m. %H:%M",
     "time"=>"%H:%M %z"},
   "pm"=>"pm"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"one"=>"asi hodinou",
       "few"=>"asi %{count} hodinami",
       "other"=>"asi %{count} hodinami"},
     "about_x_months"=>
      {"one"=>"asi měsícem",
       "few"=>"asi %{count} měsíci",
       "other"=>"asi %{count} měsíci"},
     "about_x_years"=>
      {"one"=>"asi rokem",
       "few"=>"asi %{count} roky",
       "other"=>"asi %{count} roky"},
     "almost_x_years"=>
      {"one"=>"téměř rokem",
       "few"=>"téměř %{count} roky",
       "other"=>"téměř %{count} roky"},
     "half_a_minute"=>"půl minutou",
     "less_than_x_minutes"=>
      {"one"=>"necelou minutou",
       "few"=>"ani ne %{count} minutami",
       "other"=>"ani ne %{count} minutami"},
     "less_than_x_seconds"=>
      {"one"=>"necelou sekundou",
       "few"=>"ani ne %{count} sekundami",
       "other"=>"ani ne %{count} sekundami"},
     "over_x_years"=>
      {"one"=>"více než rokem",
       "few"=>"více než %{count} roky",
       "other"=>"více než %{count} roky"},
     "x_days"=>
      {"one"=>"24 hodinami", "few"=>"%{count} dny", "other"=>"%{count} dny"},
     "x_minutes"=>
      {"one"=>"minutou",
       "few"=>"%{count} minutami",
       "other"=>"%{count} minutami"},
     "x_months"=>
      {"one"=>"měsícem", "few"=>"%{count} měsíci", "other"=>"%{count} měsíci"},
     "x_seconds"=>
      {"one"=>"sekundou",
       "few"=>"%{count} sekundami",
       "other"=>"%{count} sekundami"}},
   "prompts"=>
    {"day"=>"Den",
     "hour"=>"Hodina",
     "minute"=>"Minuta",
     "month"=>"Měsíc",
     "second"=>"Sekunda",
     "year"=>"Rok"}}}
  end
end
