# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  module Locale

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/ms.yml

    Locale_ms =
{"date"=>
  {"abbr_day_names"=>["Ahd", "Isn", "Sel", "Rab", "Kha", "Jum", "Sab"],
   "abbr_month_names"=>
    [nil,
     "Jan",
     "Feb",
     "Mac",
     "Apr",
     "Mei",
     "Jun",
     "Jul",
     "Ogo",
     "Sep",
     "Okt",
     "Nov",
     "Dis"],
   "day_names"=>
    ["Ahad", "Isnin", "Selasa", "Rabu", "Khamis", "Jumaat", "Sabtu"],
   "formats"=>{"default"=>"%d-%m-%Y", "long"=>"%d %B, %Y", "short"=>"%d %b"},
   "month_names"=>
    [nil,
     "Januari",
     "Febuari",
     "Mac",
     "April",
     "Mei",
     "Jun",
     "Julai",
     "Ogos",
     "September",
     "Oktober",
     "November",
     "Disember"],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"am",
   "formats"=>
    {"default"=>"%a, %d %b %Y %H:%M:%S %z",
     "long"=>"%d %B, %Y %H:%M",
     "short"=>"%d %b %H:%M",
     "time"=>"%H:%M:%S %z"},
   "pm"=>"pm"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"one"=>"lebih kurang 1 jam", "other"=>"lebih kurang %{count} jam"},
     "about_x_months"=>
      {"one"=>"lebih kurang 1 bulan", "other"=>"lebih kurang %{count} bulan"},
     "about_x_years"=>
      {"one"=>"lebih kurang 1 tahun", "other"=>"lebih kurang %{count} tahun"},
     "almost_x_years"=>
      {"one"=>"hampir 1 tahun", "other"=>"hampir %{count} tahun"},
     "half_a_minute"=>"setengah minit",
     "less_than_x_minutes"=>
      {"one"=>"kurang dari satu minit", "other"=>"kurang dari %{count} minit"},
     "less_than_x_seconds"=>
      {"one"=>"kurang dari satu saat", "other"=>"kurang dari %{count} saat"},
     "over_x_years"=>{"one"=>"lebih 1 tahun", "other"=>"lebih %{count} tahun"},
     "x_days"=>{"one"=>"1 hari", "other"=>"%{count} hari"},
     "x_minutes"=>{"one"=>"1 minit", "other"=>"%{count} minit"},
     "x_months"=>{"one"=>"1 bulan", "other"=>"%{count} bulan"},
     "x_seconds"=>{"one"=>"1 saat", "other"=>"%{count} saat"}},
   "prompts"=>
    {"day"=>"Hari",
     "hour"=>"Jam",
     "minute"=>"Minit",
     "month"=>"Bulan",
     "second"=>"Saat",
     "year"=>"Tahun"}}}
  end
end
