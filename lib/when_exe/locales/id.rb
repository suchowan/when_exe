# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::BasicTypes
  class M17n

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/id.yml

    Locale_id =
{"date"=>
  {"abbr_day_names"=>["Min", "Sen", "Sel", "Rab", "Kam", "Jum", "Sab"],
   "abbr_month_names"=>
    [nil,
     "Jan",
     "Feb",
     "Mar",
     "Apr",
     "Mei",
     "Jun",
     "Jul",
     "Agu",
     "Sep",
     "Okt",
     "Nov",
     "Des"],
   "day_names"=>
    ["Minggu", "Senin", "Selasa", "Rabu", "Kamis", "Jum'at", "Sabtu"],
   "formats"=>
    {"default"=>"%d %B %Y", "long"=>"%A, %d %B %Y", "short"=>"%d.%m.%Y"},
   "month_names"=>
    [nil,
     "Januari",
     "Februari",
     "Maret",
     "April",
     "Mei",
     "Juni",
     "Juli",
     "Agustus",
     "September",
     "Oktober",
     "November",
     "Desember"],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"am",
   "formats"=>
    {"default"=>"%a, %d %b %Y %H.%M.%S %z",
     "long"=>"%d %B %Y %H.%M",
     "short"=>"%d %b %H.%M",
     "time"=>"%H.%M.%S %z"},
   "pm"=>"pm"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"one"=>"sekitar satu jam", "other"=>"sekitar %{count} jam"},
     "about_x_months"=>
      {"one"=>"sekitar sebulan", "other"=>"sekitar %{count} bulan"},
     "about_x_years"=>{"one"=>"setahun", "other"=>"noin %{count} tahun"},
     "almost_x_years"=>
      {"one"=>"hampir setahun", "other"=>"hampir %{count} tahun"},
     "half_a_minute"=>"setengah menit",
     "less_than_x_minutes"=>
      {"one"=>"kurang dari 1 menit",
       "other"=>"kurang dari  %{count} menit",
       "zero"=>"kurang dari 1 menit"},
     "less_than_x_seconds"=>
      {"one"=>"kurang dari 1 detik",
       "other"=>"kurang dari %{count} detik",
       "zero"=>"kurang dari 1 detik"},
     "over_x_years"=>
      {"one"=>"lebih dari setahun", "other"=>"lebih dari %{count} tahun"},
     "x_days"=>{"one"=>"sehari", "other"=>"%{count} hari"},
     "x_minutes"=>{"one"=>"satu menit", "other"=>"%{count} menit"},
     "x_months"=>{"one"=>"sebulan", "other"=>"%{count} bulan"},
     "x_seconds"=>{"one"=>"satu detik", "other"=>"%{count} detik"}},
   "prompts"=>
    {"day"=>"Hari",
     "hour"=>"Jam",
     "minute"=>"Menit",
     "month"=>"Bulan",
     "second"=>"Detik",
     "year"=>"Tahun"}}}
  end
end
