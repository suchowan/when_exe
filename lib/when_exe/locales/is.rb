# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  module Locale

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/is.yml

    Locale_is =
{"date"=>
  {"abbr_day_names"=>["sun", "mán", "þri", "mið", "fim", "fös", "lau"],
   "abbr_month_names"=>
    [nil,
     "jan",
     "feb",
     "mar",
     "apr",
     "maí",
     "jún",
     "júl",
     "ágú",
     "sep",
     "okt",
     "nóv",
     "des"],
   "day_names"=>
    ["sunnudaginn",
     "mánudaginn",
     "þriðjudaginn",
     "miðvikudaginn",
     "fimmtudaginn",
     "föstudaginn",
     "laugardaginn"],
   "formats"=>{"default"=>"%d.%m.%Y", "long"=>"%e. %B %Y", "short"=>"%e. %b"},
   "month_names"=>
    [nil,
     "janúar",
     "febrúar",
     "mars",
     "apríl",
     "maí",
     "júní",
     "júlí",
     "ágúst",
     "september",
     "október",
     "nóvember",
     "desember"],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"",
   "formats"=>
    {"default"=>"%A %e. %B %Y kl. %H:%M",
     "long"=>"%A %e. %B %Y kl. %H:%M",
     "short"=>"%e. %B kl. %H:%M",
     "time"=>"%H:%M"},
   "pm"=>""},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"one"=>"u.þ.b. 1 klukkustund",
       "other"=>"u.þ.b. %{count} klukkustundir"},
     "about_x_months"=>
      {"one"=>"u.þ.b. 1 mánuður", "other"=>"u.þ.b. %{count} mánuðir"},
     "about_x_years"=>{"one"=>"u.þ.b. 1 ár", "other"=>"u.þ.b. %{count} ár"},
     "almost_x_years"=>{"one"=>"næstum 1 ár", "other"=>"næstum %{count} ár"},
     "half_a_minute"=>"hálf mínúta",
     "less_than_x_minutes"=>
      {"one"=>"minna en 1 mínúta", "other"=>"minna en %{count} mínútur"},
     "less_than_x_seconds"=>
      {"one"=>"minna en 1 sekúnda", "other"=>"minna en %{count} sekúndur"},
     "over_x_years"=>{"one"=>"meira en 1 ár", "other"=>"meira en %{count} ár"},
     "x_days"=>{"one"=>"1 dagur", "other"=>"%{count} dagar"},
     "x_minutes"=>{"one"=>"1 mínúta", "other"=>"%{count} mínútur"},
     "x_months"=>{"one"=>"1 mánuður", "other"=>"%{count} mánuðir"},
     "x_seconds"=>{"one"=>"1 sekúnda", "other"=>"%{count} sekúndur"}},
   "prompts"=>
    {"day"=>"Dagur",
     "hour"=>"Klukkustund",
     "minute"=>"Mínúta",
     "month"=>"Mánuður",
     "second"=>"Sekúnda",
     "year"=>"Ár"}}}
  end
end
