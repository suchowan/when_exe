# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

# Calendar/When/Ruby/2.APIの使用例/7.暦注/月の位相

# *準備
# when_exe Ruby 版の When モジュールを include する
require 'date'
require 'when_exe'
include When

# *天体暦

# 標準時を日本時間にしておく
TM::Clock.local_time = '+09:00'

# ** 望の日付
# *** 天体暦用暦注リソースを明示的に使用
date = when?('2014-01-01')            #=> 2014-01-01
p date.class                          #=> When::TM::CalDate
note = CalendarNote('LunarPhases')
p note.class                          #=> When::CalendarNote::LunarPhases
p note.phase(date,  15)               #=> 2014-01-16 (2014-01-01の直後の望)
p note.phase(date, -15)               #=> 2013-12-17 (2014-01-01の直前の望)

# *** 天体暦用暦注リソースを暗黙的に使用
date = when?('2014-01-01')            #=> 2014-01-01
p date.class                          #=> When::TM::CalDate
p date.frame.class                    #=> When::CalendarTypes::Gregorian
p date.frame.note.class               #=> When::CalendarNote::Christian
p date.phase(15)                      #=> 2014-01-16 (2014-01-01の直後の望)
p date.phase(-15)                     #=> 2013-12-17 (2014-01-01の直前の望)

# &yard(When::CalendarNote::Christian,2)には phase メソッドがないため、代替して&yard(When::CalendarNote::LunarPhases,2)が使用される

# ** 朔の時刻
# *** 天体暦用暦注リソースを明示的に使用
time = when?('2014-01-01T00:00')      #=> 2014-01-01T00:00+09:00
p time.class                          #=> When::TM::DateAndTime
note = CalendarNote('LunarPhases')
p note.class                          #=> When::CalendarNote::LunarPhases
p note.phase(time)                    #=> 2014-01-01T20:14+09:00 (2014-01-01の直後の朔, time と同じ分解能)
p note.phase(time, -30)               #=> 2013-12-03T09:22+09:00 (2014-01-01の直前の朔, time と同じ分解能)

# *** 天体暦用暦注リソースを暗黙的に使用
time = when?('2014-01-01T00:00')      #=> 2014-01-01T00:00+09:00
p time.class                          #=> When::TM::DateAndTime
p time.frame.class                    #=> When::CalendarTypes::Gregorian
p time.frame.note.class               #=> When::CalendarNote::Christian
p time.phase                          #=> 2014-01-01T20:14+09:00 (2014-01-01の直後の朔, time と同じ分解能)
p time.phase(-30)                     #=> 2013-12-03T09:22+09:00 (2014-01-01の直前の朔, time と同じ分解能)

# phase メソッドの引数 0(=月の位相 0 ティティ)は省略できる

# ** 朔の日付時刻(標準の日付時刻クラスを使用)
# *** 天体暦用暦注リソースを明示的に使用
date = Date.new(2014,1,1)             #=> #<Date: 2014-01-01 (4913317/2,0,2299161)>
time = DateTime.new(2014,1,1)         #=> #<DateTime: 2014-01-01T00:00:00+00:00 (4913317/2,0,2299161)>
note = CalendarNote('LunarPhases')
p note.class                          #=> When::CalendarNote::LunarPhases
p note.phase(date)                    #=> 2014-01-31
p note.phase(time)                    #=> 2014-01-01T11:14:09.85Z

# UTC の正午は朔の後のため、直後の朔は1月31日になる

# *** 天体暦用暦注リソースを暗黙的に使用
require 'when_exe/core/extension'
date = Date.new(2014,1,1)             #=> #<Date: 2014-01-01 (4913317/2,0,2299161)>
time = DateTime.new(2014,1,1)         #=> #<DateTime: 2014-01-01T00:00:00+00:00 (4913317/2,0,2299161)>
p date.phase                          #=> #<Date: 2014-01-31 (4913377/2,0,2299161)>
p time.phase                          #=> #<DateTime: 2014-01-01T11:14:09+00:00 (70751778283/28800,0/1,2299161)>

# *宣明暦

# 標準時を未定義にしておく
TM::Clock.local_time = nil

# ** 望の日付
date = when?('康和3.2.1')             #=> 康和03(1101).02.01
p date.class                          #=> When::TM::CalDate
p date.frame.note.class               #=> When::CalendarNote::JapaneseNote
p date.phase(15)                      #=> 康和03(1101).02.16
p date.phase(-15)                     #=> 康和03(1101).01.16=

# &yard(When::CalendarNote::JapaneseNote,2)の phase メソッドが使われ、当時行用されていた宣明暦で計算が行われる

# 宣明暦での康和3年正月望は康和03(1101).01.16の翌朝の日の出前であるため = が付く

# (= は<When.exe Standard Representation ([[Calendar/When/Ruby/2.APIの使用例/1.前提となる概念/1.日付時刻の表現]])> で翌日を意味する)

# ** 月の位相の日付一覧
[0, 7.5, 15, 22.5, 30].each do |phase|
  date = when?('康和3.2.1T00:00').phase(phase)
  p date                             #=> 下記
  # 康和03(1101).02.01T04:33Z
  # 康和03(1101).02.08=T03:27Z
  # 康和03(1101).02.16T14:41Z
  # 康和03(1101).02.23T09:36Z
  # 康和03(1101).03.01*T19:36Z
end


# 宣明暦での康和3年３月朔は進朔しており実際は前日であるため * が付く

# (* は<When.exe Standard Representation ([[Calendar/When/Ruby/2.APIの使用例/1.前提となる概念/1.日付時刻の表現]])> で前日を意味する)
