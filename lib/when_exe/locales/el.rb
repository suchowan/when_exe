# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::BasicTypes
  class M17n

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/el.yml

    Locale_el =
{"date"=>
  {"abbr_day_names"=>["Κυρ", "Δευ", "Τρί", "Τετ", "Πέμ", "Παρ", "Σάβ"],
   "abbr_month_names"=>
    [nil,
     "Ιαν",
     "Φεβ",
     "Μαρ",
     "Απρ",
     "Μαϊ",
     "Ιουν",
     "Ιουλ",
     "Αυγ",
     "Σεπ",
     "Οκτ",
     "Νοε",
     "Δεκ"],
   "day_names"=>
    ["Κυριακή",
     "Δευτέρα",
     "Τρίτη",
     "Τετάρτη",
     "Πέμπτη",
     "Παρασκευή",
     "Σάββατο"],
   "formats"=>{"default"=>"%d/%m/%Y", "long"=>"%e %B %Y", "short"=>"%d %b"},
   "month_names"=>
    [nil,
     "Ιανουάριος",
     "Φεβρουάριος",
     "Μάρτιος",
     "Απρίλιος",
     "Μάιος",
     "Ιούνιος",
     "Ιούλιος",
     "Αύγουστος",
     "Σεπτέμβριος",
     "Οκτώβριος",
     "Νοέμβριος",
     "Δεκέμβριος"],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"π.μ.",
   "formats"=>
    {"default"=>"%d %B %Y %H:%M",
     "long"=>"%A %d %B %Y %H:%M:%S %Z",
     "short"=>"%d %b %H:%M",
     "time"=>"%H:%M"},
   "pm"=>"μ.μ."},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"one"=>"περίπου μία ώρα", "other"=>"περίπου %{count} ώρες"},
     "about_x_months"=>
      {"one"=>"περίπου ένα μήνα", "other"=>"περίπου %{count} μήνες"},
     "about_x_years"=>
      {"one"=>"περίπου ένα χρόνο", "other"=>"περίπου %{count} χρόνια"},
     "almost_x_years"=>
      {"one"=>"σχεδόν ένα χρόνο", "other"=>"σχεδόν %{count} χρόνια"},
     "half_a_minute"=>"μισό λεπτό",
     "less_than_x_minutes"=>
      {"one"=>"λιγότερο από ένα λεπτό",
       "other"=>"λιγότερο από %{count} λεπτά"},
     "less_than_x_seconds"=>
      {"one"=>"λιγότερο από ένα δευτερόλεπτο",
       "other"=>"λιγότερο από %{count} δευτερόλεπτα"},
     "over_x_years"=>
      {"one"=>"πάνω από ένα χρόνο", "other"=>"πάνω από %{count} χρόνια"},
     "x_days"=>{"one"=>"1 μέρα", "other"=>"%{count} μέρες"},
     "x_minutes"=>{"one"=>"1 λεπτό", "other"=>"%{count} λεπτά"},
     "x_months"=>{"one"=>"1 μήνα", "other"=>"%{count} μήνες"},
     "x_seconds"=>{"one"=>"1 δευτερόλεπτο", "other"=>"%{count} δευτερόλεπτα"}},
   "prompts"=>
    {"day"=>"Ημέρα",
     "hour"=>"Ώρα",
     "minute"=>"Λεπτό",
     "month"=>"Μήνας",
     "second"=>"Δευτερόλεπτο",
     "year"=>"Έτος"}}}
  end
end
