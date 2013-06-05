# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::BasicTypes
  class M17n

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/az.yml

    Locale_az =
{"date"=>
  {"abbr_day_names"=>["B.", "B.E.", "Ç.A.", "Ç.", "C.A.", "C.", "Ş."],
   "abbr_month_names"=>
    [nil,
     "Yan",
     "Fev",
     "Mar",
     "Apr",
     "May",
     "İyn",
     "İyl",
     "Avq",
     "Sen",
     "Okt",
     "Noy",
     "Dek"],
   "day_names"=>
    ["Bazar",
     "Bazar ertəsi",
     "Çərşənbə axşamı",
     "Çərşənbə",
     "Cümə axşamı",
     "Cümə",
     "Şənbə"],
   "formats"=>{"default"=>"%d.%m.%Y", "long"=>"%d %B %Y", "short"=>"%d %b"},
   "month_names"=>
    [nil,
     "Yanvar",
     "Fevral",
     "Mart",
     "Aprel",
     "May",
     "İyun",
     "İyul",
     "Avqust",
     "Sentyabr",
     "Oktyabr",
     "Noyabr",
     "Dekabr"],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"günortaya qədər",
   "formats"=>
    {"default"=>"%a, %d %b %Y, %H:%M:%S %z",
     "long"=>"%d %B %Y, %H:%M",
     "short"=>"%d %b, %H:%M",
     "time"=>"%H:%M:%S %z"},
   "pm"=>"günortadan sonra"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"one"=>"təxminən 1 saat", "other"=>"təxminən %{count} saat"},
     "about_x_months"=>
      {"one"=>"təxminən 1 ay", "other"=>"təxminən %{count} ay"},
     "about_x_years"=>
      {"one"=>"təxminən 1 il", "other"=>"təxminən %{count} il"},
     "almost_x_years"=>
      {"one"=>"təqribən 1 il", "other"=>"təqribən %{count} il"},
     "half_a_minute"=>"yarım dəqiqə",
     "less_than_x_minutes"=>
      {"one"=>"1 dəqiqədən az", "other"=>"%{count} dəqiqədən az"},
     "less_than_x_seconds"=>
      {"one"=>"1 saniyədən az", "other"=>"%{count} saniyədən az"},
     "over_x_years"=>{"one"=>"1 ildən çox", "other"=>"%{count} ildən çox"},
     "x_days"=>{"one"=>"1 gün", "other"=>"%{count} gün"},
     "x_minutes"=>{"one"=>"1 dəqiqə", "other"=>"%{count} dəqiqə"},
     "x_months"=>{"one"=>"1 ay", "other"=>"%{count} ay"},
     "x_seconds"=>{"one"=>"1 saniyə", "other"=>"%{count} saniyə"}},
   "prompts"=>
    {"day"=>"Gün",
     "hour"=>"Saat",
     "minute"=>"Dəqiqə",
     "month"=>"Ay",
     "second"=>"Saniyə",
     "year"=>"İl"}}}
  end
end
