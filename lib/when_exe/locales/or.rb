# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::BasicTypes
  class M17n

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/or.yml

    Locale_or =
{"date"=>
  {"abbr_day_names"=>["ରବି", "ସୋମ", "ମଂଗଳ", "ବୁଧ", "ଗୁରୁ", "ଶୁକ୍ର", "ଶନି"],
   "abbr_month_names"=>
    [nil,
     "ଜାନୁ",
     "ଫେବରୁ",
     "ମାର",
     "ଏପ୍ର",
     "ମାଈ",
     "ଜୁନ୍",
     "ଜୁଲ୍",
     "ଅଗସ୍ଟ",
     "ସେପ୍ଟ",
     "ଅକ୍ଟ",
     "ନୋଭ",
     "ଡିସ୍"],
   "day_names"=>
    ["ରବିବାର", "ସୋମବାର", "ମଗଂଳବାର", "ବୁଧବାର", "ଗୁରୁବାର", "ଶୁକ୍ରବାର", "ଶନିବାର"],
   "formats"=>{"default"=>"%Y-%m-%d", "long"=>"%B %d, %Y", "short"=>"%b %d"},
   "month_names"=>
    [nil,
     "ଜାନୁୟାରୀ",
     "ଫେବୃୟାରୀ",
     "ମାର୍ଚ଼",
     "ଏପ୍ରଲ",
     "ମାଈ",
     "ଜୁନ୍",
     "ଜୁଲାୟ",
     "ଅଗଷ୍ତ",
     "ସେପ୍ଟମ୍ବର୍",
     "ଅକ୍ଟୋବର୍",
     "ନୋଭେମ୍ବର",
     "ଡିସମ୍ବର"],
   "order"=>[:year, :month, :day]},
 "time"=>
  {"am"=>"ପୁର୍ଵାହ୍ନ",
   "formats"=>
    {"default"=>"%a, %d %b %Y %H:%M:%S %z",
     "long"=>"%B %d, %Y %H:%M",
     "short"=>"%d %b %H:%M",
     "time"=>"%H:%M:%S %z"},
   "pm"=>"ଅପରାହ୍ନ"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"one"=>"ପାଖାପାଖି 1 ଘଣ୍ତ", "other"=>"ପାଖାପାଖି %{count} ଘଣ୍ତ"},
     "about_x_months"=>
      {"one"=>"ପାଖାପାଖି 1 ମାସ", "other"=>"ପାଖାପାଖି %{count} ମାସ"},
     "about_x_years"=>
      {"one"=>"ପାଖାପାଖି 1 year", "other"=>"ପାଖାପାଖି %{count} years"},
     "almost_x_years"=>
      {"one"=>"ଅଳ୍ପ ଉଣ 1 ବର୍ଷ", "other"=>"ଅଳ୍ପ ଉଣ %{count} ବର୍ଷ"},
     "half_a_minute"=>"ଦେଢ ମିନଟ୍",
     "less_than_x_minutes"=>
      {"one"=>"1 ମିନଟ ବାକ", "other"=>"%{count} ମିନଟ ବାକ"},
     "less_than_x_seconds"=>
      {"one"=>"1 ସେକଣ୍ଢ ବାକ", "other"=>"%{count} ସେକଣ୍ଢ ବାକ"},
     "over_x_years"=>{"one"=>"1 ବର୍ଷରୁ ଅଧିକ", "other"=>"%{count} ବର୍ଷରୁ ଅଧିକ"},
     "x_days"=>{"one"=>"1  ଦିନ", "other"=>"%{count} ଦିନ"},
     "x_minutes"=>{"one"=>"1 ମିନଟ", "other"=>"%{count} ମିନଟ"},
     "x_months"=>{"one"=>"1 ମାସ", "other"=>"%{count} ମାସ"},
     "x_seconds"=>{"one"=>"1 ସେକଣ୍ଢ", "other"=>"%{count} ସେକଣ୍ଢ"}},
   "prompts"=>
    {"day"=>"ଦିନ",
     "hour"=>"ଘଣ୍ତ",
     "minute"=>"ମିନଟ",
     "month"=>"ମାସ",
     "second"=>"ସେକଣ୍ଢ",
     "year"=>"ବର୍ଷ"}}}
  end
end
