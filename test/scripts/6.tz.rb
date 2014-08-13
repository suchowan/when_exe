# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

# Calendar/When/Ruby/2.APIの使用例/6.iCalendar/時間帯

# イベントが夏時間と標準時間の切り替えをまたがる場合の振舞

# →関連クラス図 [[Calendar/When/Ruby/3.クラス図/12.時間参照系]]

# *準備
# when_exe Ruby 版の When モジュールを include する
require 'when_exe'
include When

# *時間帯の指定に When::V::Timezone を使用する場合
# **.icsファイルで時間帯を定義
-- NewYork.ics -- (使用する場合は行頭の空白を削除)
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//hacksw/handcal//NONSGML v1.0//EN
BEGIN:VTIMEZONE
TZID:America/New_York
LAST-MODIFIED:20050809T050000Z
BEGIN:STANDARD
DTSTART:19671029T020000
RRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU;UNTIL=20061029T060000Z
TZOFFSETFROM:-0400
TZOFFSETTO:-0500
TZNAME:EST
END:STANDARD
BEGIN:DAYLIGHT
DTSTART:19870405T020000
RRULE:FREQ=YEARLY;BYMONTH=4;BYDAY=1SU;UNTIL=20060402T070000Z
TZOFFSETFROM:-0500
TZOFFSETTO:-0400
TZNAME:EDT
END:DAYLIGHT
END:VTIMEZONE
END:VCALENDAR
----------------

vcal = Resource("NewYork.ics")  # "NewYork.ics"をメモリに読み込む
p [vcal.class, vcal.iri]        #=> [When::V::Calendar, "NewYork.ics"]
tz   = vcal["America/New_York"]
p [tz.class, tz.iri]            #=> [When::V::Timezone, "NewYork.ics::America/New_York"]

# ** 標準時間→夏時間
When::V::Event.new({
          'rrule'   => 'FREQ=YEARLY;BYMONTH=4;BYDAY=1SU;BYHOUR=1,2,3,4;BYMINUTE=30;COUNT=4',
          'dtstart' => 'TZID=America/New_York:19970406T013000'
}).each do |date|
  p date #=> 1997-04-06T01:30:00-05:00, 1997-04-06T03:30:00-04:00, 1997-04-06T04:30:00-04:00, 1998-04-05T01:30:00-05:00
end

# ** 夏時間→標準時間(重複する1時間内はスキップ)
When::V::Event.new({
          'rrule'   => 'FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU;BYHOUR=1,2,3;BYMINUTE=30;COUNT=4',
          'dtstart' => 'TZID=America/New_York:19971026T013000'
}).each do |date|
  p date #=> 1997-10-26T01:30:00-04:00, 1997-10-26T02:30:00-05:00, 1997-10-26T03:30:00-05:00, 1998-10-25T01:30:00-04:00
end

# ** 夏時間→標準時間(重複する1時間内のイベントも発生)
When::V::Event.new({
          'rrule'   => 'FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU;BYHOUR=1,1=,2,3;BYMINUTE=30;COUNT=5',
          'dtstart' => 'TZID=America/New_York:19971026T013000'
}).each do |date|
  p date #=> 1997-10-26T01:30:00-04:00, 1997-10-26T01:30:00-05:00, 1997-10-26T02:30:00-05:00, 1997-10-26T03:30:00-05:00, 1998-10-25T01:30:00-04:00
end

# BYHOUR=1,1=,2,3 の 1= は [[When.exe　Standard　Expression>http://www.asahi-net.or.jp/~dd6t-sg/when_rdoc/when.html#label-8]] の書式に準じている

# *時間帯の指定に TZInfo::Timezone を使用する場合
# メモリに America/Chicago に対応する When::V::Timezone が読み込まれていない場合、TZInfo::Timezoneを使用する
# ** 標準時間→夏時間
When::V::Event.new({
          'rrule'   => 'FREQ=YEARLY;BYMONTH=4;BYDAY=1SU;BYHOUR=1,2,3,4;BYMINUTE=30;COUNT=4',
          'dtstart' => 'TZID=America/Chicago:19970406T013000'
}).each do |date|
  p date #=> 1997-04-06T01:30:00-06:00, 1997-04-06T03:30:00-05:00, 1997-04-06T04:30:00-05:00, 1998-04-05T01:30:00-06:00
end

# ** 夏時間→標準時間(重複する1時間内はスキップ)
When::V::Event.new({
          'rrule'   => 'FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU;BYHOUR=1,2,3;BYMINUTE=30;COUNT=4',
          'dtstart' => 'TZID=America/Chicago:19971026T013000'
}).each do |date|
  p date #=> 1997-10-26T01:30:00-05:00, 1997-10-26T02:30:00-06:00, 1997-10-26T03:30:00-06:00, 1998-10-25T01:30:00-05:00
end

# ** 夏時間→標準時間(重複する1時間内のイベントも発生)
When::V::Event.new({
          'rrule'   => 'FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU;BYHOUR=1,1=,2,3;BYMINUTE=30;COUNT=5',
          'dtstart' => 'TZID=America/Chicago:19971026T013000'
}).each do |date|
  p date #=> 1997-10-26T01:30:00-05:00, 1997-10-26T01:30:00-06:00, 1997-10-26T02:30:00-06:00, 1997-10-26T03:30:00-06:00, 1998-10-25T01:30:00-05:00
end

# 制限 : BYHOUR=1= から生成した 1997-10-26T01:30:00-06:00 が保持する時間帯は -06:00 固定となり加減算しても変わらない。


