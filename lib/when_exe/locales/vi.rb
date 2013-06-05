# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When::BasicTypes
  class M17n

    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/vi.yml

    Locale_vi =
{"date"=>
  {"abbr_day_names"=>
    ["Chủ nhật",
     "Thứ hai",
     "Thứ ba",
     "Thứ tư",
     "Thứ năm",
     "Thứ sáu",
     "Thứ bảy"],
   "abbr_month_names"=>
    [nil,
     "Tháng một",
     "Tháng hai",
     "Tháng ba",
     "Tháng tư",
     "Tháng năm",
     "Tháng sáu",
     "Tháng bảy",
     "Tháng tám",
     "Tháng chín",
     "Tháng mười",
     "Tháng mười một",
     "Tháng mười hai"],
   "day_names"=>
    ["Chủ nhật",
     "Thứ hai",
     "Thứ ba",
     "Thứ tư",
     "Thứ năm",
     "Thứ sáu",
     "Thứ bảy"],
   "formats"=>{"default"=>"%d-%m-%Y", "long"=>"%d %B, %Y", "short"=>"%d %b"},
   "month_names"=>
    [nil,
     "Tháng một",
     "Tháng hai",
     "Tháng ba",
     "Tháng tư",
     "Tháng năm",
     "Tháng sáu",
     "Tháng bảy",
     "Tháng tám",
     "Tháng chín",
     "Tháng mười",
     "Tháng mười một",
     "Tháng mười hai"],
   "order"=>[:day, :month, :year]},
 "time"=>
  {"am"=>"sáng",
   "formats"=>
    {"default"=>"%a, %d %b %Y %H:%M:%S %z",
     "long"=>"%d %B, %Y %H:%M",
     "short"=>"%d %b %H:%M",
     "time"=>"%H:%M:%S %z"},
   "pm"=>"chiều"},
 "datetime"=>
  {"distance_in_words"=>
    {"about_x_hours"=>{"one"=>"khoảng 1 giờ", "other"=>"khoảng %{count} giờ"},
     "about_x_months"=>
      {"one"=>"khoảng 1 tháng", "other"=>"khoảng %{count} tháng"},
     "about_x_years"=>{"one"=>"khoảng 1 năm", "other"=>"khoảng %{count} năm"},
     "almost_x_years"=>{"one"=>"gần 1 năm", "other"=>"gần %{count} năm"},
     "half_a_minute"=>"30 giây",
     "less_than_x_minutes"=>
      {"one"=>"chưa tới 1 phút", "other"=>"chưa tới %{count} phút"},
     "less_than_x_seconds"=>
      {"one"=>"chưa tới 1 giây", "other"=>"chưa tới %{count} giây"},
     "over_x_years"=>{"one"=>"hơn 1 năm", "other"=>"hơn %{count} năm"},
     "x_days"=>{"one"=>"1 ngày", "other"=>"%{count} ngày"},
     "x_minutes"=>{"one"=>"1 phút", "other"=>"%{count} phút"},
     "x_months"=>{"one"=>"1 tháng", "other"=>"%{count} tháng"},
     "x_seconds"=>{"one"=>"1 giây", "other"=>"%{count} giây"}},
   "prompts"=>
    {"day"=>"Ngày",
     "hour"=>"Giờ",
     "minute"=>"Phút",
     "month"=>"Tháng",
     "second"=>"Giây",
     "year"=>"Năm"}}}
  end
end
