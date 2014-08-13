# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

# Calendar/When/Ruby/2.APIの使用例/9.標準クラスとの変換/コア拡張

# コアクラスを require 'when_exe/core/extension' で拡張した場合の記法を確認

# *準備
require 'date'
require 'when_exe'
require 'when_exe/core/extension'
include When

# *標準クラスからの変換
# **Dateクラス
sdate = Date.new(1582,10,15)
p sdate                                     #=> #<Date: 1582-10-15 ((2299161j,0s,0n),+0s,2299161j)>
gdate = sdate.tm_pos
p gdate                                     #=> 1582-10-15
p gdate.class                               #=> When::TM::CalDate
p gdate.frame.iri                           #=> "http://hosi.org/When/CalendarTypes/Civil?reform_jdn=2299161"
sdate = Date.new(1582,10,4)
p sdate                                     #=> #<Date: 1582-10-04 ((2299160j,0s,0n),+0s,2299161j)>
gdate = sdate.tm_pos
p gdate                                     #=> 1582-10-04
p gdate.frame.iri                           #=> "http://hosi.org/When/CalendarTypes/Civil?reform_jdn=2299161"
jdate = sdate.tm_pos(:frame=>'Gregorian')
p jdate                                     #=> 1582-10-14
p jdate.frame.iri                           #=> "http://hosi.org/When/CalendarTypes/Gregorian"

# **Timeクラス
# ***UTC
stime = Time.utc(2013, 5 ,30, 16, 20, 45)
p stime                                     #=> 2013-05-30 16:20:45 UTC
gtime = stime.tm_pos
p gtime                                     #=> 2013-05-30T16:20:45.00Z
p gtime.class                               #=> When::TM::DateAndTime
p gtime.frame.iri                           #=> "http://hosi.org/When/CalendarTypes/Gregorian"
p gtime.clock.iri                           #=> "http://hosi.org/When/CalendarTypes/UTC"

# ***ローカル時刻
stime = Time.local(2013, 5 ,30, 16, 20, 45)
p stime                                     #=> 2013-05-30 16:20:45 +0900
gtime = stime.tm_pos
p gtime                                     #=> 2013-05-30T16:20:45.00+09:00
p gtime.class                               #=> When::TM::DateAndTime
p gtime.frame.iri                           #=> "http://hosi.org/When/CalendarTypes/Gregorian"
p gtime.clock.iri                           #=> "http://hosi.org/When/TM/Clock?label=+09:00"

# **Date Timeクラス
# ***UTC
sdate = DateTime.new(2013, 5 ,30, 16, 20, 45)
p sdate                                     #=> #<DateTime: 2013-05-30T16:20:45+00:00 ((2456443j,58845s,0n),+0s,2299161j)>
gdate = sdate.tm_pos
p gdate                                     #=> 2013-05-30T16:20:45.00Z
p gdate.class                               #=> When::TM::DateAndTime
p gdate.frame.iri                           #=> "http://hosi.org/When/CalendarTypes/Civil?reform_jdn=2299161"
p gdate.clock.iri                           #=> "http://hosi.org/When/CalendarTypes/UTC"

# ***ローカル時刻
sdate = DateTime.new(2013, 5 ,30, 16, 20, 45, 0.375)
p sdate                                     #=> #<DateTime: 2013-05-30T16:20:45+09:00 ((2456443j,26445s,0n),+32400s,2299161j)>
gdate = sdate.tm_pos
p gdate                                     #=> 2013-05-30T16:20:45.00+09:00
p gdate.class                               #=> When::TM::DateAndTime
p gdate.frame.iri                           #=> "http://hosi.org/When/CalendarTypes/Civil?reform_jdn=2299161"
p gdate.clock.iri                           #=> "http://hosi.org/When/TM/Clock?label=+09:00"

# *標準クラスへの変換
# **Dateクラス
gdate = '1582-10-15'.when?
p gdate                                     #=> 1582-10-15
p gdate.class                               #=> When::TM::CalDate
p gdate.frame.iri                           #=> "http://hosi.org/When/CalendarTypes/Gregorian"
sdate = gdate.to_date
p sdate                                     #=> #<Date: 1582-10-15 ((2299161j,0s,0n),+0s,-Infj)>
gdate = '1582-10-04'.when?(:frame=>'Julian')
p gdate                                     #=> 1582-10-04
p gdate.class                               #=> When::TM::CalDate
p gdate.frame.iri                           #=> "http://hosi.org/When/CalendarTypes/Julian"
sdate = gdate.to_date
p sdate                                     #=> #<Date: 1582-10-14 ((2299160j,0s,0n),+0s,-Infj)>

# to_date による変換結果は原則としてグレゴリオ暦だが、変換元がCivilのユリウス暦期間かまたはJulianの場合のみユリウス暦

# **Timeクラス
# ***UTC
gtime = '2013-05-30T16:20:45'.when?
p gtime                                     #=> 2013-05-30T16:20:45Z
p gtime.class                               #=> When::TM::DateAndTime
p gtime.frame.iri                           #=> "http://hosi.org/When/CalendarTypes/Gregorian"
p gtime.clock.iri                           #=> "http://hosi.org/When/CalendarTypes/UTC"
stime = gtime.to_time
p stime                                     #=> 2013-05-31 01:20:45 +0900

# ***ローカル時刻
if Object.const_defined?(:TZInfo) # TZInfo gem がインストールされていること
  gtime = '2013-05-30T16:20:45'.when?(:tz=>'Asia/Tokyo')
  p gtime                                   #=> 2013-05-30T16:20:45+09:00
  p gtime.class                             #=> When::TM::DateAndTime
  p gtime.frame.iri                         #=> "http://hosi.org/When/CalendarTypes/Gregorian"
  p gtime.clock.tz_prop.timezone            #=> #<TZInfo::DataTimezone: Asia/Tokyo>
  stime = gtime.to_time
  p stime                                   #=> 2013-05-30 16:20:45 +0900
end
# to_time による変換結果は常にローカル時刻である

# **Date Timeクラス
# ***UTC
gdate = '2013-05-30T16:20:45'.when?
p gdate                                     #=> 2013-05-30T16:20:45Z
p gdate.class                               #=> When::TM::DateAndTime
p gdate.frame.iri                           #=> "http://hosi.org/When/CalendarTypes/Gregorian"
p gdate.clock.iri                           #=> "http://hosi.org/When/CalendarTypes/UTC"
sdate = gdate.to_datetime
p sdate                                     #=> #<DateTime: 2013-05-30T16:20:45+00:00 ((2456443j,58845s,0n),+0s,-Infj)>

# ***ローカル時刻
if Object.const_defined?(:TZInfo) # TZInfo gem がインストールされていること
  gdate = '2013-05-30T16:20:45'.when?(:tz=>'Asia/Tokyo')
  p gdate                                   #=> 2013-05-30T16:20:45+09:00
  p gdate.class                             #=> When::TM::DateAndTime
  p gdate.frame.iri                         #=> "http://hosi.org/When/CalendarTypes/Gregorian"
  p gtime.clock.tz_prop.timezone            #=> #<TZInfo::DataTimezone: Asia/Tokyo>
  sdate = gdate.to_datetime
  p sdate                                   #=> #<DateTime: 2013-05-30T16:20:45+09:00 ((2456443j,26445s,0n),+32400s,-Infj)>
end
