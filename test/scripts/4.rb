# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

# Calendar/When/Ruby/2.APIの使用例/4.時間間隔

# →関連クラス図 [[Calendar/When/Ruby/3.クラス図/10.Duration]]

# *準備
# when_exe Ruby 版の When モジュールを include する
require 'when_exe'
include When

# コア拡張を利用する場合は[[Calendar/When/Ruby/2.APIの使用例/4.時間間隔/コア拡張]]を参照

# When::TM::Durationのみを利用する場合は[[Calendar/When/Ruby/2.APIの使用例/4.時間間隔/最小セット]]を参照

# *Period Duration
# **四則
date = when?('2013-03-25')
p date                               #=> 2013-03-25
duration = Duration('P1Y2M3D')
p duration                           #=> P1Y2M3D
p date + duration                    #=> 2014-05-28
p date - duration                    #=> 2012-01-22
duration2 = duration * 2
p duration2                          #=> P2Y4M6D
p duration2 + duration               #=> P3Y6M9D
p duration2 - duration               #=> P1Y2M3D
p date + duration2                   #=> 2015-07-31
p duration2 / 2                      #=> P1Y2M3D
begin
  p duration2 / duration
rescue => e                          #=> TypeError: nil can't be coerced into Float
  p e
end

# **ブロック
start = when?('2013-03-25')
p start                              #=> 2013-03-25
stop  = when?('2016-01-01')
p stop                               #=> 2016-01-01
duration = Duration('P1Y2M3D')
(start ^ duration).each do |date|
  break if date >= stop
  p date                             #=> 2013-03-25,2014-05-28,2015-07-31
end
duration.enum_for(start, :forward, 3).each do |date|
  p date                             #=> 2013-03-25,2014-05-28,2015-07-31
end

# *Interval Length
# **四則
time = when?('2013-03-25T01:23:45')
p time                               #=> 2013-03-25T01:23:45Z
duration = Duration('3s')
p duration                           #=> 3s
p time + duration                    #=> 2013-03-25T01:23:48Z
p time - duration                    #=> 2013-03-25T01:23:42Z
duration2 = duration * 2
p duration2                          #=> 6s
p duration2 + duration               #=> 9.0s
p duration2 - duration               #=> 3.0s
p time + duration2                   #=> 2013-03-25T01:23:51Z
p duration2 / 2                      #=> 3.0s
p duration2 / duration               #=> 2.0

# **ブロック
start = when?('2013-03-25T01:23:45')
p start                              #=> 2013-03-25T01:23:45Z
stop  = when?('2013-03-25T01:23:54')
p stop                               #=> 2013-03-25T01:23:54Z
duration = Duration('3s')
(start ^ duration).each do |time|
  break if time >= stop
  p time                             #=> 2013-03-25T01:23:45Z,2013-03-25T01:23:48Z,2013-03-25T01:23:51Z
end
duration.enum_for(start, :forward, 3).each do |time|
  p time                             #=> 2013-03-25T01:23:45Z,2013-03-25T01:23:48Z,2013-03-25T01:23:51Z
end


# *Duration
# **四則
time = when?('2013-03-25T01:23:45')
p time                               #=> 2013-03-25T01:23:45Z
duration = TM::Duration.second(3)
p duration                           #=> [0, 0, 0, 3.0]
p time + duration                    #=> 2013-03-25T01:23:48Z
p time - duration                    #=> 2013-03-25T01:23:42Z
duration2 = duration * 2
p duration2                          #=> [0, 0, 0, 6.0]
p duration2 + duration               #=> [0, 0, 0, 9.0]
p duration2 - duration               #=> [0, 0, 0, 3.0]
p time + duration2                   #=> 2013-03-25T01:23:51Z
p duration2 / 2                      #=> [0, 0, 0, 3.0]
p duration2 / duration               #=> 2.0

# **ブロック
start = when?('2013-03-25T01:23:45')
p start                              #=> 2013-03-25T01:23:45Z
stop  = when?('2013-03-25T01:23:54')
p stop                               #=> 2013-03-25T01:23:54Z
duration = TM::Duration.second(3)
(start ^ duration).each do |time|
  break if time >= stop
  p time                             #=> 2013-03-25T01:23:45Z,2013-03-25T01:23:48Z,2013-03-25T01:23:51Z
end
duration.enum_for(start, :forward, 3).each do |time|
  p time                             #=> 2013-03-25T01:23:45Z,2013-03-25T01:23:48Z,2013-03-25T01:23:51Z
end

# *Temporal Position の差
time1 = when?('2013-03-25T01:23:45')
time2 = when?('2013-03-26T01:23:45')
duration = time2 - time1
p [duration, duration.class] # => [86400.0s, When::TM::IntervalLength]

# 分解能が「日」よりも細かい時間位置の差は&yard(When::TM::IntervalLength)になる。

date1 = when?('2013-03-25')
date2 = when?('2013-03-26')
duration = date2 - date1
p [duration, duration.class] # => [P1D, When::TM::PeriodDuration]

# 分解能が「日」またはそれより粗い時間位置の差は「日」を単位とする&yard(When::TM::PeriodDuration)になる。

date3 = when?('215-20-17^^Darian')
duration = date3 - date1
p [duration, duration.class] # => [14434.504952669144s, When::TM::IntervalLength]

# グレゴリオ暦と火星暦のように歩度の異なる暦で表された時間位置の差は分解能に関係なく&yard(When::TM::IntervalLength)になる。

