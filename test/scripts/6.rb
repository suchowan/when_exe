# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

# Calendar/When/Ruby/2.APIの使用例/6.iCalendar

# →関連クラス図 [[Calendar/When/Ruby/3.クラス図/05.RFC5545継承と包含]]

# *準備
# when_exe Ruby 版の When モジュールを include する
require 'when_exe'
include When

# 標準時間と夏時間の切り替え時の振る舞いについては[[Calendar/When/Ruby/2.APIの使用例/6.iCalendar/時間帯]]を参照

# &yard(When::TM::GoogleCalendar,1)を利用する場合は[[Calendar/When/Ruby/2.APIの使用例/6.iCalendar/GoogleCalendar]]も参照

# *敬老の日
# **APIのみで計算
event = When::V::Event.new({
  'rrule'   => {'FREQ'=>'MONTHLY', 'INTERVAL'=>12, 'BYDAY'=>{''=>'3MO'}},
  'dtstart' => 'VALUE=DATE;TZID=Asia/Tokyo:20080915'
})
p event.class   #=> When::V::Event
event.enum_for(When.when?('20070101'), :forward, 3).each do |date|
  p date        #=> 2008-09-15T+09:00, 2009-09-21T+09:00, 2010-09-20T+09:00
end

# **ローカル時刻を使う場合
When::TM::Clock.local_time = Clock("+0900")
event = When::V::Event.new({
  'rrule'   => {'FREQ'=>'MONTHLY', 'INTERVAL'=>12, 'BYDAY'=>{''=>'3MO'}},
  'dtstart' => 'VALUE=DATE:20080915'
})
p event.class   #=> When::V::Event
event.enum_for(When.when?('20070101'), :forward, 3).each do |date|
  p date        #=> 2008-09-15, 2009-09-21, 2010-09-20
end

# **icsファイルを読み込んで利用
-- sample1.ics -- (使用する場合は行頭の空白を削除)
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//hacksw/handcal//NONSGML v1.0//EN
BEGIN:VTIMEZONE
TZID:Asia/Tokyo
BEGIN:STANDARD
TZOFFSETFROM:+0900
TZOFFSETTO:+0900
TZNAME:JST
DTSTART:19700101T000000
END:STANDARD
END:VTIMEZONE
BEGIN:VEVENT
CREATED:20050809T050000Z
LAST-MODIFIED:20050809T050000Z
DTSTAMP:20050809T050000Z
UID:event1-ID
RRULE:FREQ=MONTHLY;INTERVAL=12;BYDAY=3MO
DTSTART;VALUE=DATE;TZID=Asia/Tokyo:20080915
DTEND;VALUE=DATE;TZID=Asia/Tokyo:20080916
END:VEVENT
END:VCALENDAR
----------------

event = Resource('sample1.ics::event1-ID')
p event.iri                               #=> "sample1.ics::event1-ID" (実際は IRI に適合しないが便宜上ファイル名から生成)
p event.class                             #=> When::V::Event
event.enum_for(When.when?('20080101'), :forward, 3).each do |date|
  p date                                  #=> 2008-09-15T+09:00, 2009-09-21T+09:00, 2010-09-20T+09:00
end

# *秋分の日
# **APIのみで計算(RFC5545に対する拡張機能)
event = When::V::Event.new({
  'rrule'   => {'FREQ'=>'YEARLY', 'BYDAY'=>{'SolarTerms'=>'term180'}},
  'dtstart' => 'VALUE=DATE;TZID=Asia/Tokyo:19480923'
})
p event.class   #=> When::V::Event
event.enum_for(When.when?('20110101'), :forward, 3).each do |date|
  p date        #=> 2011-09-23T+09:00, 2012-09-22T+09:00, 2013-09-23T+09:00
end

# **icsファイルを読み込んで利用
-- sample2.ics --
(snip) - sample1.ics と同じ
UID:event2-ID
RRULE:FREQ=YEARLY;BYDAY/SolarTerms=term180
DTSTART;VALUE=DATE;TZID=Asia/Tokyo:19480923
DTEND;VALUE=DATE;TZID=Asia/Tokyo:19480924
(snip) - sample1.ics と同じ
----------------

event = Resource('sample2.ics::event2-ID')
p event.iri                               #=> "sample2.ics::event2-ID" (実際は IRI に適合しないが便宜上ファイル名から生成)
p event.class                             #=> When::V::Event
event.enum_for(When.when?('20110101'), :forward, 3).each do |date|
  p date                                  #=> 2011-09-23T+09:00, 2012-09-22T+09:00, 2013-09-23T+09:00
end

# *日本の年間祝日
# **イベントの取得
service = GoogleCalendar::Service.new('xxxxxxxx@gmail.com', '*********')
feed = "http://www.google.com/calendar/feeds/%s__%s%%40holiday.calendar.google.com/public/full" % ['japanese', 'ja']
gcal = GoogleCalendar::Calendar::new(service, feed)
gcal.events({'start-min'=>'2012-01-01', 'start-max'=>'2013-01-01',
             'orderby'=>'starttime', 'sortorder'=>'a'
            }).each do |event|
  vevent = event.to_vevent
  p [vevent.summary, vevent.dtstart]  #=> 下記の通り
  # ["元日",                "2012-01-01T00:00:00.00+09:00"]
  # ["元日 振替休日",       "2012-01-02T00:00:00.00+09:00"]
  # ["銀行休業日",          "2012-01-02T00:00:00.00+09:00"]
  # ["銀行休業日",          "2012-01-03T00:00:00.00+09:00"]
  # ["成人の日",            "2012-01-09T00:00:00.00+09:00"]
  # ["建国記念の日",        "2012-02-11T00:00:00.00+09:00"]
  # ["春分の日",            "2012-03-20T00:00:00.00+09:00"]
  # ["昭和の日",            "2012-04-29T00:00:00.00+09:00"]
  # ["昭和の日 振替休日",   "2012-04-30T00:00:00.00+09:00"]
  # ["憲法記念日",          "2012-05-03T00:00:00.00+09:00"]
  # ["みどりの日",          "2012-05-04T00:00:00.00+09:00"]
  # ["こどもの日",          "2012-05-05T00:00:00.00+09:00"]
  # ["海の日",              "2012-07-16T00:00:00.00+09:00"]
  # ["敬老の日",            "2012-09-17T00:00:00.00+09:00"]
  # ["秋分の日",            "2012-09-22T00:00:00.00+09:00"]
  # ["体育の日",            "2012-10-08T00:00:00.00+09:00"]
  # ["文化の日",            "2012-11-03T00:00:00.00+09:00"]
  # ["勤労感謝の日",        "2012-11-23T00:00:00.00+09:00"]
  # ["天皇誕生日",          "2012-12-23T00:00:00.00+09:00"]
  # ["天皇誕生日 振替休日", "2012-12-24T00:00:00.00+09:00"]
  # ["クリスマス",          "2012-12-25T00:00:00.00+09:00"]
  # ["大晦日",              "2012-12-31T00:00:00.00+09:00"]
end

# **日時範囲の取得
service = GoogleCalendar::Service.new('xxxxxxxx@gmail.com', '*********')
feed = "http://www.google.com/calendar/feeds/%s__%s%%40holiday.calendar.google.com/public/full" % ['japanese', 'ja']
gcal = GoogleCalendar::Calendar::new(service, feed)
gcal.enum_for({'start-min'=>'2012-01-01', 'start-max'=>'2013-01-01',
               'orderby'=>'starttime', 'sortorder'=>'a'
              }).each do |range|
  p [range.events[0].summary, range] #=> 下記の通り
  # ["元日",                2012-01-01T00:00:00.00+09:00...2012-01-02T00:00:00.00+09:00]
  # ["元日 振替休日",       2012-01-02T00:00:00.00+09:00...2012-01-03T00:00:00.00+09:00]
  # ["銀行休業日",          2012-01-02T00:00:00.00+09:00...2012-01-03T00:00:00.00+09:00]
  # ["銀行休業日",          2012-01-03T00:00:00.00+09:00...2012-01-04T00:00:00.00+09:00]
  # ["成人の日",            2012-01-09T00:00:00.00+09:00...2012-01-10T00:00:00.00+09:00]
  # ["建国記念の日",        2012-02-11T00:00:00.00+09:00...2012-02-12T00:00:00.00+09:00]
  # ["春分の日",            2012-03-20T00:00:00.00+09:00...2012-03-21T00:00:00.00+09:00]
  # ["昭和の日",            2012-04-29T00:00:00.00+09:00...2012-04-30T00:00:00.00+09:00]
  # ["昭和の日 振替休日",   2012-04-30T00:00:00.00+09:00...2012-05-01T00:00:00.00+09:00]
  # ["憲法記念日",          2012-05-03T00:00:00.00+09:00...2012-05-04T00:00:00.00+09:00]
  # ["みどりの日",          2012-05-04T00:00:00.00+09:00...2012-05-05T00:00:00.00+09:00]
  # ["こどもの日",          2012-05-05T00:00:00.00+09:00...2012-05-06T00:00:00.00+09:00]
  # ["海の日",              2012-07-16T00:00:00.00+09:00...2012-07-17T00:00:00.00+09:00]
  # ["敬老の日",            2012-09-17T00:00:00.00+09:00...2012-09-18T00:00:00.00+09:00]
  # ["秋分の日",            2012-09-22T00:00:00.00+09:00...2012-09-23T00:00:00.00+09:00]
  # ["体育の日",            2012-10-08T00:00:00.00+09:00...2012-10-09T00:00:00.00+09:00]
  # ["文化の日",            2012-11-03T00:00:00.00+09:00...2012-11-04T00:00:00.00+09:00]
  # ["勤労感謝の日",        2012-11-23T00:00:00.00+09:00...2012-11-24T00:00:00.00+09:00]
  # ["天皇誕生日",          2012-12-23T00:00:00.00+09:00...2012-12-24T00:00:00.00+09:00]
  # ["天皇誕生日 振替休日", 2012-12-24T00:00:00.00+09:00...2012-12-25T00:00:00.00+09:00]
  # ["クリスマス",          2012-12-25T00:00:00.00+09:00...2012-12-26T00:00:00.00+09:00]
  # ["大晦日",              2012-12-31T00:00:00.00+09:00...2013-01-01T00:00:00.00+09:00]
end

# **when.exe での iCalendar の拡張

TM::Clock.local_time = Clock("+0900")
cal = Resource("../test/examples/JapanHolidays.ics")
cal.each(when?('20090101')...when?('20100101')) do |date|
  p date #=> 下記の通り
  # 2009-01-01T+09:00
  # 2009-01-12T+09:00
  # 2009-02-11T+09:00
  # 2009-03-20T+09:00
  # 2009-04-29T+09:00
  # 2009-05-03T+09:00
  # 2009-05-04T+09:00
  # 2009-05-05T+09:00
  # 2009-05-06T+09:00
  # 2009-07-20T+09:00
  # 2009-09-21T+09:00
  # 2009-09-22T+09:00
  # 2009-09-23T+09:00
  # 2009-10-12T+09:00
  # 2009-11-03T+09:00
  # 2009-11-23T+09:00
  # 2009-12-23T+09:00
end

# 9月22日が現れるのは &yard(JapanHolidays.ics) に拡張構文

 # -- JapanHolidays.ics --
 # (snip)
 # RRULE:FREQ=MONTHLY;INTERVAL=12;BYDAY=TU;BYDAY/SolarTerms=term180-1
 # (snip)
 # ----------------

# で「秋分の前日である火曜日」が定義してあるからです。
# 拡張構文を使っていますから&yard(JapanHolidays.ics) は when.exe 以外とは情報交換できません。

