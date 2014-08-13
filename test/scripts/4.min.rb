# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

# Calendar/When/Ruby/2.APIの使用例/4.時間間隔/最小セット

# *準備
require 'when_exe/tmduration'
require 'when_exe/core/duration'             # コア拡張する場合のみ

# *Duration
# **生成
# ***コア拡張に依存しない生成方式
p When::TM::Duration.week(1)                 #=> [7, 0, 0, 0.0]
p When::TM::Duration.day(2)                  #=> [2, 0, 0, 0.0]
p When::TM::Duration.hour(3)                 #=> [0, 3, 0, 0.0]
p When::TM::Duration.minute(4)               #=> [0, 0, 4, 0.0]
p When::TM::Duration.second(5)               #=> [0, 0, 0, 5.0]
p When::TM::Duration.dhms(2,3,4,5)           #=> [2, 3, 4, 5.0]

# ***コア拡張時のみ可能な生成方式
p 1.week_duration                            #=> [7, 0, 0, 0.0]
p 2.days_duration                            #=> [2, 0, 0, 0.0]
p 3.hours_duration                           #=> [0, 3, 0, 0.0]
p 4.minutes_duration                         #=> [0, 0, 4, 0.0]
p 5.seconds_duration                         #=> [0, 0, 0, 5.0]
p [2,3,4,5].duration                         #=> [2, 3, 4, 5.0]

# 単数(～)、複数(～s)は同義

# **四則
# ***コア拡張に依存しない生成方式を使用
time = Time.at(1369475972)
p time                                       #=> 2013-05-25 18:59:32 +0900
duration = When::TM::Duration.second(3)
p duration                                   #=> [0, 0, 0, 3.0]
p time + duration                            #=> 2013-05-25 18:59:35 +0900
p time - duration                            #=> 2013-05-25 18:59:29 +0900
duration2 = duration * 2
p duration2                                  #=> [0, 0, 0, 6.0]
p duration2 + duration                       #=> [0, 0, 0, 9.0]
p duration2 - duration                       #=> [0, 0, 0, 3.0]
p time + duration2                           #=> 2013-05-25 18:59:38 +0900
p duration2 / 2                              #=> [0, 0, 0, 3.0]
p duration2 / duration                       #=> 2.0
p duration2 + When::TM::Duration.dhms(1,2,3) #=> [1, 2, 3, 6.0]

# ***コア拡張時のみ可能な生成方式を使用
time = Time.at(1369475972)
p time                                       #=> 2013-05-25 18:59:32 +0900
duration = 3.seconds_duration
p duration                                   #=> [0, 0, 0, 3.0]
p time + duration                            #=> 2013-05-25 18:59:35 +0900
p time - duration                            #=> 2013-05-25 18:59:29 +0900
duration2 = duration * 2
p duration2                                  #=> [0, 0, 0, 6.0]
p duration2 + duration                       #=> [0, 0, 0, 9.0]
p duration2 - duration                       #=> [0, 0, 0, 3.0]
p time + duration2                           #=> 2013-05-25 18:59:38 +0900
p duration2 / 2                              #=> [0, 0, 0, 3.0]
p duration2 / duration                       #=> 2.0
p duration2 + [1,2,3].duration               #=> [1, 2, 3, 6.0]
