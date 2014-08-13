# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

# Calendar/When/Ruby/2.APIの使用例/7.暦注/二十四節気

# *準備
# when_exe Ruby 版の When モジュールを include する
require 'when_exe'
include When

# *天体暦

# 標準時を日本時間にしておく
TM::Clock.local_time = '+09:00'

# ** 冬至の日付
# *** 天体暦用暦注リソースを明示的に使用
date = when?('2014-01-01')            #=> 2014-01-01
p date.class                          #=> When::TM::CalDate
note = CalendarNote('SolarTerms')
p note.class                          #=> When::CalendarNote::SolarTerms
p note.term(date, 270)                #=> 2014-12-22 (2014-01-01の直後の冬至)
p note.term(date, -90)                #=> 2013-12-22 (2014-01-01の直前の冬至)

# *** 天体暦用暦注リソースを暗黙的に使用
date = when?('2014-01-01')            #=> 2014-01-01
p date.class                          #=> When::TM::CalDate
p date.frame.class                    #=> When::CalendarTypes::Gregorian
p date.frame.note.class               #=> When::CalendarNote::Christian
p date.term(270)                      #=> 2014-12-22 (2014-01-01の直後の冬至)
p date.term(-90)                      #=> 2013-12-22 (2014-01-01の直前の冬至)

# &yard(When::CalendarNote::Christian,2)には term メソッドがないため、代替して&yard(When::CalendarNote::SolarTerms,2)が使用される

# ** 春分の時刻
# *** 天体暦用暦注リソースを明示的に使用
time = when?('2014-01-01T00:00')      #=> 2014-01-01T00:00+09:00
p time.class                          #=> When::TM::DateAndTime
note = CalendarNote('SolarTerms')
p note.class                          #=> When::CalendarNote::SolarTerms
p note.term(time)                     #=> 2014-03-21T01:56+09:00 (2014-01-01の直後の春分, time と同じ分解能)
p note.term(time, -360)               #=> 2013-03-20T20:02+09:00 (2014-01-01の直前の春分, time と同じ分解能)

# *** 天体暦用暦注リソースを暗黙的に使用
time = when?('2014-01-01T00:00')      #=> 2014-01-01T00:00+09:00
p time.class                          #=> When::TM::DateAndTime
p time.frame.class                    #=> When::CalendarTypes::Gregorian
p time.frame.note.class               #=> When::CalendarNote::Christian
p time.term                           #=> 2014-03-21T01:56+09:00 (2014-01-01の直後の春分, time と同じ分解能)
p time.term(-360)                     #=> 2013-03-20T20:02+09:00 (2014-01-01の直前の春分, time と同じ分解能)

# term メソッドの引数 0(=太陽黄経 0 度)は省略できる

# ** 春分の日付時刻(標準の日付時刻クラスを使用)
# *** 天体暦用暦注リソースを明示的に使用
require 'date'
date = Date.new(2014,1,1)             #=> #<Date: 2014-01-01 (4913317/2,0,2299161)>
time = DateTime.new(2014,1,1)         #=> #<DateTime: 2014-01-01T00:00:00+00:00 (4913317/2,0,2299161)>
note = CalendarNote('SolarTerms')
p note.class                          #=> When::CalendarNote::SolarTerms
p note.term(date)                     #=> 2014-03-21
p note.term(time)                     #=> 2014-03-20T16:56:55.09Z

# *** 天体暦用暦注リソースを暗黙的に使用
require 'when_exe/core/extension'
date = Date.new(2014,1,1)             #=> #<Date: 2014-01-01 (4913317/2,0,2299161)>
time = DateTime.new(2014,1,1)         #=> #<DateTime: 2014-01-01T00:00:00+00:00 (4913317/2,0,2299161)>
p date.term                           #=> #<Date: 2014-03-21 (4913475/2,0,2299161)>
p time.term                           #=> #<DateTime: 2014-03-20T16:56:55+00:00 (42452418923/17280,0/1,2299161)>

# *宣明暦

# 冬至の日付を移動して朔旦冬至にした建仁2～3年を例にする

# 標準時を未定義にしておく
TM::Clock.local_time = nil

# ** 冬至の日付
date = when?('建仁03.01.01')          #=> 建仁03(1203).01.01
p date.class                          #=> When::TM::CalDate
p date.frame.note.class               #=> When::CalendarNote::JapaneseNote
p date.term(270)                      #=> 建仁03(1203).11.12
p date.term(-90)                      #=> 建仁02(1202).11.01*

# &yard(When::CalendarNote::JapaneseNote,2)の term メソッドが使われ、当時行用されていた宣明暦で計算が行われる

# 宣明暦での建仁2年の冬至は建仁02(1202).11.01の前日であるため * が付く

# (* は<When.exe Standard Representation ([[Calendar/When/Ruby/2.APIの使用例/1.前提となる概念/1.日付時刻の表現]])> で前日を意味する)

# ** 二十四節気の日付一覧
date = when?('建仁02.01.01')          #=> 建仁02(1202).01.01
25.times do |t|
  # [0,15] は「太陽黄経を15で割って0余る」という指定
  date = date.ceil.term([0,15])
  p date                              #=> 下記
  # 建仁02(1202).01.05
  # 建仁02(1202).01.20
  # 建仁02(1202).02.06
  # 建仁02(1202).02.22
  # 建仁02(1202).03.07
  # 建仁02(1202).03.22
  # 建仁02(1202).04.08
  # 建仁02(1202).04.23
  # 建仁02(1202).05.10
  # 建仁02(1202).05.25
  # 建仁02(1202).06.10
  # 建仁02(1202).06.25
  # 建仁02(1202).07.12
  # 建仁02(1202).07.27
  # 建仁02(1202).08.13
  # 建仁02(1202).08.28
  # 建仁02(1202).09.13
  # 建仁02(1202).09.29
  # 建仁02(1202).10.14
  # 建仁02(1202).10.29
  # 建仁02(1202).10=14
  # 建仁02(1202).11.01*
  # 建仁02(1202).11.16
  # 建仁02(1202).12.01
  # 建仁02(1202).12.16
end

# &yard(When::TM::CalDate,2)オブジェクトはその日付の正午に丸められるため ceil メソッドで日付をすすめる必要がある
