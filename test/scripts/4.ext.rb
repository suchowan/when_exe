# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

# Calendar/When/Ruby/2.APIの使用例/4.時間間隔/コア拡張

# コアクラスを require 'when_exe/core/extension' で拡張した場合の記法を確認

# *準備
# when_exe Ruby 版の When モジュールを include する
require 'when_exe'
require 'when_exe/core/extension'
include When

# *Period Duration
# **四則
date = when?('2013-03-25')
p date                               #=> 2013-03-25
duration = 2.months_period_duration
p duration                           #=> P2M
p date + duration                    #=> 2013-05-25
p date - duration                    #=> 2013-01-25
duration2 = duration * 2
p duration2                          #=> P4M
p duration2 + duration               #=> P6M
p duration2 - duration               #=> P2M
p date + duration2                   #=> 2013-07-25
p duration2 / 2                      #=> P2M
begin
  p duration2 / duration
rescue => e                          #=> TypeError: nil can't be coerced into Float
  p e
end

# **ブロック
start = when?('2013-03-25')
p start                              #=> 2013-03-25
stop  = when?('2013-09-01')
p stop                               #=> 2013-09-01
duration = 2.months_period_duration
(start ^ duration).each do |date|
  break if date >= stop
  p date                             #=> 2013-03-25,2013-05-25,2013-07-25
end
duration.enum_for(start, :forward, 3).each do |date|
  p date                             #=> 2013-03-25,2013-05-25,2013-07-25
end

# *Interval Length
# **四則
time = when?('2013-03-25T01:23:45')
p time                               #=> 2013-03-25T01:23:45Z
duration = 3.seconds_interval_length
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
duration = 3.seconds_interval_length
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
duration =  3.seconds_duration
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
duration =  3.seconds_duration
(start ^ duration).each do |time|
  break if time >= stop
  p time                             #=> 2013-03-25T01:23:45Z,2013-03-25T01:23:48Z,2013-03-25T01:23:51Z
end
duration.enum_for(start, :forward, 3).each do |time|
  p time                             #=> 2013-03-25T01:23:45Z,2013-03-25T01:23:48Z,2013-03-25T01:23:51Z
end

