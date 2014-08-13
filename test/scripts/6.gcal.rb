# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

# Calendar/When/Ruby/2.APIの使用例/6.iCalendar/GoogleCalendar

# *Ruby から制御するAPI

# gcalapi for gem - http://gcalapi.rubyforge.org/

# これ自体は周期イベントに対応していないが、簡単なパッチで対応可能

require 'rubygems'
gem 'gcalapi'
require 'gcalapi'
module GoogleCalendar
  class Event
    attr_accessor :recurrence
    alias :_instance_to_xml :instance_to_xml
    def instance_to_xml
      _instance_to_xml
      @xml.root.elements[recurrence ? "gd:when" : "gd:recurrence"].remove
    end
  end
  Event::ATTRIBUTES_MAP["recurrence"] = { "element" => "gd:recurrence"}
end

# 期間を指定してイベントを取得する場合は、

events = cal.events({'start-min'=>'2012-01-01', 'start-max'=>'2012-12-31'})

# のようなコードで可能。:start_min, :start_max でないことに注意。

# また、日時はISO8601として正しい文字列でなければならない。

# *Google Calendar の挙動

# 2014-07-15現在、Google側の動作が変わって、gcalapi が動作しなくなっているようです。
# http://aligach.net/diary/20131214.html を読んだところ、REDIRECT 対応が必要になった由。
# REDIRECT動作に対応した https://github.com/suchowan/gcalapi (0.1.2s)で動作が改善されます。

# どうも insertだけでなく update や destroy でも REDIRECT 対応が必要のようです。
# &yard(GoogleCalendar)の仕様を理解しないまま対症療法的に施した対策ですので妥当性は不明です。
# が、一応 when_exe と協働したテストには通るようになったので、とりあえずこの 0.1.2s を前提にしようと思います。

# **フィード先URI

# フィード先URIは表の通り

# |私用|http://www.google.com/calendar/feeds/'''ユーザ名'''%40gmail.com/private/full
# |国別祝日|http://www.google.com/calendar/feeds/'''国名'''__'''言語コード'''%40holiday.calendar.google.com/public/full

# 国名には、irish, usa, uk, islamic, italian, iranian, indian, indonesian, dutch,
# australian, austrian, canadian, christian, greek, singapore, swedish, spain,
# thai, danish, german, new_zealand, norwegian, philippines, finnish, french,
# brazilian, vietnamese, portuguese, polish, malaysia, mexican, jewish, russian,
# china, sa, taiwan, japanese, south_korea, hong_kong_c, hong_kong が
# [[使用可能>https://gist.github.com/1438183]](2012-04-10現在)。

# ただし、iranian は言語コード ja では使えない。

# **recurrence定義

# *** タイムゾーン部

# 終日イベントはローカルタイムを使用する。タイムゾーンの指定は無視される。

# 終日でないイベントにはタイムゾーンが付く。
# 自前でタイムゾーンを定義する必要はなく、定義しても Google が提供するタイムゾーンに置き換えられる。
# たとえば、America/New_York は、
BEGIN:VTIMEZONE
TZID:America/New_York
X-LIC-LOCATION:America/New_York
BEGIN:DAYLIGHT
TZOFFSETFROM:-0500
TZOFFSETTO:-0400
TZNAME:EDT
DTSTART:19700308T020000
RRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=2SU
END:DAYLIGHT
BEGIN:STANDARD
TZOFFSETFROM:-0400
TZOFFSETTO:-0500
TZNAME:EST
DTSTART:19701101T020000
RRULE:FREQ=YEARLY;BYMONTH=11;BYDAY=1SU
END:STANDARD
END:VTIMEZONE

# となるが、夏時間が上記のロジックになったのは2007年からなので、
# Google が提供するタイムゾーン定義は実際には誤りである。

# *** イベント部

# 認識するのは、DTSTART, DTEND, RRULE のみである。

# LOCALE, NAMESPACE などはエラーにならず破棄される。

# 当然ながら RRULE に when.exe 独自の拡張機能は使えない(パースエラー)。

# EXDATE は使用せず、別途キャンセルイベントを定義する方式になっている。
# このため、キャンセルされたイベントも期間検索でヒットする。
<gd:eventStatus value='http://schemas.google.com/g/2005#event.canceled'/>

# * When::V::Event との連携

# [[When::V::Event>http://www.asahi-net.or.jp/~dd6t-sg/when_rdoc/doc.1.9/When/V/Event.html]]と連携するため、gcalapi に API を追加

# ** When::V::Event クラス
# *** to_gcalevent(gcal)

# When::V::Event クラスのインスタンスを &yard(GoogleCalendar::Event,2) クラスのインスタンスに変換する。

# 引数 gcal は&yard(GoogleCalendar)::Calendarクラスのインスタンス

# ** Google Calendar::Event クラス
# *** to_vevent()

# &yard(GoogleCalendar)::Event クラスのインスタンスを &yard(When::V::Event,2)クラスのインスタンスに変換する。

# ** Google Calendar::Calendar クラス
# *** enum_for(conditions)

# 引数 conditions で抽出したイベントに対応する日時(&yard(When::TM::TemporalPosition,2))を生成する Enumeratorを取得する。

# conditions は &yard(GoogleCalendar::Calendar,2)クラスの eventsメソッドと互換だが、'start-min'が省略された場合、現在時刻とみなす。

# to_enum は enum_for の alias
