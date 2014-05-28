# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  module Locale

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/lo.yml

    Locale_lo =
{"date"=>
  {"abbr_day_names"=>["", "", "", "", "", "", ""],
   "abbr_month_names"=>[nil, "", "", "", "", "", "", "", "", "", "", "", ""],
   "day_names"=>["ອາທິດ", "ຈັນ", "ອັງຄານ", "ພຸດ", "ພະຫັດ", "ສຸກ", "ເສົາ"],
   "formats"=>{"default"=>"%d-%m-%Y", "long"=>"%e %B %Y", "short"=>"%e %b"},
   "month_names"=>
    [nil,
     "ມັງກອນ",
     "ກຸມພາ",
     "ມີນາ",
     "ເມສາ",
     "ພຶດສະພາ",
     "ມິຖຸນາ",
     "ກໍລະກົດ",
     "ສິງຫາ",
     "ກັນຍາ",
     "ຕຸລາ",
     "ພະຈິກ",
     "ທັນວາ"],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"",
   "formats"=>
    {"default"=>"%a %d %b %Y %H:%M:%S %z",
     "long"=>"%d %B %Y %H:%M น.",
     "short"=>"%d %b %H:%M น.",
     "time"=>"%H:%M:%S %z"},
   "pm"=>""},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>
      {"zero"=>"ປະມານ %{count} ຊົ່ວໂມງ",
       "one"=>"ປະມານ 1 ຊົ່ວໂມງ",
       "two"=>"ປະມານ %{count} ຊົ່ວໂມງ",
       "few"=>"ປະມານ %{count} ຊົ່ວໂມງ",
       "many"=>"ປະມານ %{count} ຊົ່ວໂມງ",
       "other"=>"ປະມານ %{count} ຊົ່ວໂມງ"},
     "about_x_months"=>
      {"zero"=>"ປະມານ %{count} ເດືອນ",
       "one"=>"ປະມານ 1 ເດືອນ",
       "two"=>"ປະມານ %{count} ເດືອນ",
       "few"=>"ປະມານ %{count} ເດືອນ",
       "many"=>"ປະມານ %{count} ເດືອນ",
       "other"=>"ປະມານ %{count} ເດືອນ"},
     "about_x_years"=>
      {"zero"=>"ປະມານ %{count} ປີ ",
       "one"=>"ປະມານ 1 ປີ ",
       "two"=>"ປະມານ %{count} ປີ ",
       "few"=>"ປະມານ %{count} ປີ ",
       "many"=>"ປະມານ %{count} ປີ ",
       "other"=>"ປະມານ %{count} ປີ "},
     "half_a_minute"=>"ເຄິ່ງນາທີ ",
     "less_than_x_minutes"=>
      {"zero"=>"ນ້ອຍກວ່າ %{count} ນາທີ ",
       "one"=>"ນ້ອຍກວ່າ 1 ນາທີ ",
       "two"=>"ນ້ອຍກວ່າ %{count} ນາທີ ",
       "few"=>"ນ້ອຍກວ່າ %{count} ນາທີ ",
       "many"=>"ນ້ອຍກວ່າ %{count} ນາທີ ",
       "other"=>"ນ້ອຍກວ່າ %{count} ນາທີ "},
     "less_than_x_seconds"=>
      {"zero"=>"ນ້ອຍກວ່າ %{count} ວິນາທີ ",
       "one"=>"ນ້ອຍກວ່າ 1 ວິນາທີ ",
       "two"=>"ນ້ອຍກວ່າ %{count} ວິນາທີ ",
       "few"=>"ນ້ອຍກວ່າ %{count} ວິນາທີ ",
       "many"=>"ນ້ອຍກວ່າ %{count} ວິນາທີ ",
       "other"=>"ນ້ອຍກວ່າ %{count} ວິນາທີ "},
     "over_x_years"=>
      {"zero"=>"ຫຼາຍກວ່າ %{count} ປີ ",
       "one"=>"ຫຼາຍກວ່າ 1 ປີ ",
       "two"=>"ຫຼາຍກວ່າ %{count} ປີ ",
       "few"=>"ຫຼາຍກວ່າ %{count} ປີ ",
       "many"=>"ຫຼາຍກວ່າ %{count} ປີ ",
       "other"=>"ຫຼາຍກວ່າ %{count} ປີ "},
     "x_days"=>
      {"zero"=>"%{count} ມື້ ",
       "one"=>"1 ມື້ ",
       "two"=>"%{count} ມື້ ",
       "few"=>"%{count} ມື້ ",
       "many"=>"%{count} ມື້ ",
       "other"=>"%{count} ມື້ "},
     "x_minutes"=>
      {"zero"=>"%{count} ນາທີ ",
       "one"=>"1 ນາທີ ",
       "two"=>"%{count} ນາທີ ",
       "few"=>"%{count} ນາທີ ",
       "many"=>"%{count} ນາທີ ",
       "other"=>"%{count} ນາທີ "},
     "x_months"=>
      {"zero"=>"%{count} ເດືອນ",
       "one"=>"1 ເດືອນ",
       "two"=>"%{count} ເດືອນ",
       "few"=>"%{count} ເດືອນ",
       "many"=>"%{count} ເດືອນ",
       "other"=>"%{count} ເດືອນ"},
     "x_seconds"=>
      {"zero"=>"%{count} ວິນາທີ ",
       "one"=>"1 ວິນາທີ ",
       "two"=>"%{count} ວິນາທີ ",
       "few"=>"%{count} ວິນາທີ ",
       "many"=>"%{count} ວິນາທີ ",
       "other"=>"%{count} ວິນາທີ "}},
   "prompts"=>
    {"day"=>"ວັນ",
     "hour"=>"ຊົ່ວໂມງ",
     "minute"=>"ນາທີ",
     "month"=>"ເດືອນ",
     "second"=>"ວິນາທີ",
     "year"=>"ປີ"}}}
  end
end
