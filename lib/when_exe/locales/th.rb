# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::Parts::Locale

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/th.yml

    Locale_th =
{"date"=>
  {"abbr_day_names"=>["อา", "จ", "อ", "พ", "พฤ", "ศ", "ส"],
   "abbr_month_names"=>
    [nil,
     "ม.ค.",
     "ก.พ.",
     "มี.ค.",
     "เม.ย.",
     "พ.ค.",
     "มิ.ย.",
     "ก.ค.",
     "ส.ค.",
     "ก.ย.",
     "ต.ค.",
     "พ.ย.",
     "ธ.ค."],
   "day_names"=>
    ["อาทิตย์", "จันทร์", "อังคาร", "พุธ", "พฤหัสบดี", "ศุกร์", "เสาร์"],
   "formats"=>{"default"=>"%d-%m-%Y", "long"=>"%d %B %Y", "short"=>"%d %b"},
   "month_names"=>
    [nil,
     "มกราคม",
     "กุมภาพันธ์",
     "มีนาคม",
     "เมษายน",
     "พฤษภาคม",
     "มิถุนายน",
     "กรกฎาคม",
     "สิงหาคม",
     "กันยายน",
     "ตุลาคม",
     "พฤศจิกายน",
     "ธันวาคม"],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"ก่อนเที่ยง",
   "formats"=>
    {"default"=>"%a %d %b %Y %H:%M:%S %z",
     "long"=>"%d %B %Y %H:%M น.",
     "short"=>"%d %b %H:%M น.",
     "time"=>"%H:%M:%S %z"},
   "pm"=>"หลังเที่ยง"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>"ประมาณ %{count} ชั่วโมง",
     "about_x_months"=>"ประมาณ %{count} เดือน",
     "about_x_years"=>"ประมาณ %{count} ปี",
     "almost_x_years"=>"เกือบ %{count} ปี",
     "half_a_minute"=>"ครึ่งนาที",
     "less_than_x_minutes"=>"น้อยกว่า %{count} นาที",
     "less_than_x_seconds"=>"น้อยกว่า %{count} วินาที",
     "over_x_years"=>"มากกว่า %{count} ปี",
     "x_days"=>"%{count} วัน",
     "x_minutes"=>"%{count} นาที",
     "x_months"=>"%{count} เดือน",
     "x_seconds"=>"%{count} วินาที"},
   "prompts"=>
    {"day"=>"วัน",
     "hour"=>"ชั่วโมง",
     "minute"=>"นาที",
     "month"=>"เดือน",
     "second"=>"วินาที",
     "year"=>"ปี"}}}
end
