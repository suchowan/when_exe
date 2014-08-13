# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

# Calendar/When/Ruby/2.APIの使用例/2.逆引き

# [[逆引きRuby>http://www.namaraii.com/rubytips/?%C6%FC%C9%D5%A4%C8%BB%FE%B9%EF]]の例を When_exe Ruby 版ではどうするか? 下記に列挙する

# *準備
# when_exe Ruby 版の When モジュールを include する
require 'when_exe'
include When

# コア拡張を利用する場合は[[Calendar/When/Ruby/2.APIの使用例/2.逆引き/コア拡張]]を参照

# *日付
# **日付オブジェクトを作成する
date = tm_pos(2013, 5,24)
p date       #=> 2013-05-24

# **日付オブジェクトを文字列に変換する
p date.to_s  #=>"2013-05-24"

# **指定の日付が存在するかどうか調べる
p tm_pos(2013, 2, 29)                   #=> 2013-03-01
p tm_pos(2013, 2, 29, :invalid=>:check) #=> nil
begin
  p tm_pos(2013, 2, 29, :invalid=>:raise)
rescue => e
  p e                                   #=> ArgumentError: Specified date not found: [2013, 2, 29]
end

# **ユリウス日から日付オブジェクトを作成する
date = Calendar('Gregorian').jul_trans(2451941)
p date           #=> 2001-01-31
p date.to_i      #=> 2451941

date = Gregorian ^ 2451941    # Gregorian は定数として定義済み、^ は jul_trans の alias
p date           #=> 2001-01-31
p date.to_i      #=> 2451941

# **何日後、何日前の日付を求める
date = tm_pos(2013, 1, 31)
p date + P1D     #=> 2013-02-01
p date + 1       #=> 2013-02-01
p date.precision #=> 0
p date.succ      #=> 2013-02-01

date = tm_pos(2013, 2,  1)
p date - 1       #=> 2013-01-31
p date - P1D     #=> 2013-01-31
p date.precision #=> 0
p date.prev      #=> 2013-01-31

# 定数 P1D の値は &yard(When::TM::PeriodDuration,2).new(1, DAY) である

# 加減算で Integer は &yard(When::TM::PeriodDuration) に暗黙変換される

# **何ヶ月後、何ヶ月前の日付を求める
date = tm_pos(2013, 1, 31)
p date + P1M     #=> 2013-02-28
date = tm_pos(2013, 1)
p date.precision #=> -1
p date.succ      #=> 2013-02

date = tm_pos(2013, 3, 31)
p date - P1M     #=> 2013-02-28
date = tm_pos(2013, 2)
p date.precision #=> -1
p date.prev      #=> 2013-01

# 定数 P1M の値は &yard(When::TM::PeriodDuration).new(1, MONTH) である

# 日付の精度が“月”の場合、prev, succ は“月”単位で前後を求める

# **2つの日付の差を求める
date1 = tm_pos(2012, 6,30)
date2 = tm_pos(2012, 7, 1)
p date2 - date1         #=> P1D
p (date2 - date1).class #=> When::TM::PeriodDuration

# 精度が“日”または“日”よりも粗い日付の差は &yard(When::TM::PeriodDuration) になる

# **日付オブジェクトの年月日・曜日を個別に扱う
date = tm_pos(2013, 5, 24)
p date         #=> 2013-05-24
p date[YEAR]   #=> 2013
p date[MONTH]  #=> 5
p date[DAY]    #=> 24
p date.year    #=> 2013
p date.month   #=> 5
p date.day     #=> 24
p date.wday    #=> 5

# **うるう年かどうか判定する
p date.length(YEAR) == 366 #=> false

# **文字列の日付を日付オブジェクトに変換する
p when?('2013-05-24') #=> 2013-05-24

# *日時
# **日時オブジェクトを生成する
time = tm_pos(2013, 5,24, 6, 3, 10.5)
p time         #=> 2013-05-24T06:03:10.5Z
p time[YEAR]   #=> 2013
p time[MONTH]  #=> 5
p time[DAY]    #=> 24
p time[HOUR]   #=> 6
p time[MINUTE] #=> 3
p time[SECOND] #=> 10.5
p time.year    #=> 2013
p time.month   #=> 5
p time.day     #=> 24
p time.hour    #=> 6
p time.min     #=> 3
p time.sec     #=> 10.5
p time.wday    #=> 5

# **日時中の曜日を日本語に変換する
p time.strftime('%A', 'ja') #=> "金曜日"

# **UTCとローカル時刻の日時オブジェクト
utc = tm_pos(2013, 5,24, 6, 3, 11)
p utc          #=> 2013-05-24T06:03:11Z
jst = tm_pos(2013, 5,24, 6, 3, 11, :clock=>'+09:00')
p jst          #=> 2013-05-24T06:03:11+09:00

# **日時オブジェクトを文字列に変換する
p jst.to_s     #=> "2013-05-24T06:03:11+09:00"

# **日時を任意のフォーマットで扱う
p jst.strftime("Now, %A %B %d %X %Y", 'fr') #=> "Now, vendredi mai 24 06:03:11 2013"

# **日本時間をニューヨーク時間に変換する
if Object.const_defined?(:TZInfo) # TZInfo gem がインストールされていること
  jst = tm_pos(1997, 4, 6, 15, 30, 00, :tz=>'Asia/Tokyo')
  p jst          #=> 1997-04-06T15:30:00+09:00
  est = Clock('America/New_York') ^ jst
  p est          #=> 1997-04-06T01:30:00-05:00
  jst = tm_pos(1997, 4, 6, 16, 30, 00, :tz=>'Asia/Tokyo')
  p jst          #=> 1997-04-06T16:30:00+09:00
  edt = Clock('America/New_York') ^ jst
  p edt          #=> 1997-04-06T03:30:00-04:00
end
# 使用可能な時間帯の一覧は &yard(When::Parts::Timezone,2).tz_info.keys で取得できる

# **日時に任意の時間を加減する
utc = tm_pos(2012, 6,30, 0, 0, 0)
p utc          #=> 2012-06-30T00:00:00Z
p utc + 1      #=> 2012-07-01T00:00:00Z
p utc + 1.0    #=> 2012-06-30T23:59:60Z

# 加減算で Integer は &yard(When::TM::PeriodDuration) に暗黙変換される

# 加減算で Float は &yard(When::TM::IntervalLength) に暗黙変換される

# **2つの日時の差を求める
utc1 = tm_pos(2012, 6,30, 0, 0, 0)
utc2 = tm_pos(2012, 7, 1, 0, 0, 0)
p utc2 - utc1         #=> 86401.0s
p (utc2 - utc1).class #=> When::TM::IntervalLength

# 精度が“日”よりも細かい日時の差は &yard(When::TM::IntervalLength,2) になる

# **UNIXタイムを日時オブジェクトに変換する
p when?(Time.at(1267867237)) #=> 2010-03-06T18:20:37.00+09:00
