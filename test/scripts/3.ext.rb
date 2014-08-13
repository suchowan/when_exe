# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

# Calendar/When/Ruby/2.APIの使用例/3.年号の扱い/コア拡張

# コアクラスを require 'when_exe/core/extension' で拡張した場合の記法を確認

# *準備
# when_exe Ruby 版の When モジュールを include する
require 'when_exe'
require 'when_exe/core/extension'
include When

# 使用可能な &yard(CalendarEra) は http://hosi.org/frames/When/TM/CalendarEra.html 参照

# *グレゴリオ暦 ⇔ 現代日本暦日
# **最近の日付
date = [2013, 5, 25].tm_pos
p date                                      #=> 2013-05-25
p 'ModernJapanese'.calendar_era.iri         #=> "http://hosi.org/When/TM/CalendarEra/ModernJapanese"
list = date ^ 'ModernJapanese'.calendar_era
p list                                      #=> [H25(2013).05.25]
p list[0].frame.iri                         #=> "http://hosi.org/When/CalendarTypes/Gregorian?note=DefaultNotes"
date = ['H', 25, 5, 25].tm_pos
p date                                      #=> H25(2013).05.25
p 'Gregorian'.calendar ^ date               #=> 2013-05-25
date = 'H25.5.25'.when?
p date                                      #=> H25(2013).05.25
p 'Gregorian'.calendar ^ date               #=> 2013-05-25

# *グレゴリオ暦 ⇔ 西暦(CE/BCE)
# **グレゴリオ暦改暦直後
date = '1582-10-15'.when?
p date                                      #=> 1582-10-15
p 'Common'.calendar_era.iri                 #=> "http://hosi.org/When/TM/CalendarEra/Common"
list = date ^ 'Common'.calendar_era
p list                                      #=> [CE1582.10.15]
p list[0].frame.iri                         #=> "http://hosi.org/When/CalendarTypes/Gregorian"
date = ['CE', 1582, 10, 15].tm_pos
p date                                      #=> CE1582.10.15
p 'Gregorian'.calendar ^ date               #=> 1582-10-15
date = 'CE1582.10.15'.when?
p date                                      #=> CE1582.10.15
p 'Gregorian'.calendar ^ date               #=> 1582-10-15

# **グレゴリオ暦改暦直前
date = '1582-10-14'.when?
p date                                      #=> 1582-10-14
list = date ^ 'Common'.calendar_era
p list                                      #=> [CE1582.10.04]
p list[0].frame.iri                         #=> "http://hosi.org/When/CalendarTypes/Julian"
date = ['CE', 1582, 10, 4].tm_pos
p date                                      #=> CE1582.10.04
p 'Gregorian'.calendar ^ date               #=> 1582-10-14
date = 'CE1582.10.4'.when?
p date                                      #=> CE1582.10.04
p 'Gregorian'.calendar ^ date               #=> 1582-10-14

# **紀元前45年
date = '-44-03-13'.when?
p date                                      #=> -00044-03-13
list = date ^ 'Common'.calendar_era
p list                                      #=> [BCE45(-044).03.15]
p list[0].frame.iri                         #=> "http://hosi.org/When/CalendarTypes/Julian"
date = ['BCE', 45, 3, 15].tm_pos
p date                                      #=> BCE45(-044).03.15
p 'Gregorian'.calendar ^ date               #=> -00044-03-13
date = 'BCE45.3.15'.when?
p date                                      #=> BCE45(-044).03.15
p 'Gregorian'.calendar ^ date               #=> -00044-03-13

# *天保年号のバリエーション
# **日本
date = '天保2.3.4'.when?                    # ここで日本暦日をメモリに展開するため、少々時間がかかる
p date                                      #=> 天保02(1831).03.04
p date.calendar_era.iri                     #=> "http://hosi.org/When/TM/CalendarEra/Japanese::江戸時代::天保"
# **南朝の後梁
date = '天保2.3.4'.when?(:count=>2)         # ここで中国暦日をメモリに展開するため、さらに時間がかかる
p date                                      #=> 天保02(0563).03.04
p date.calendar_era.iri                     #=> "http://hosi.org/When/TM/CalendarEra/Chinese::南朝::後梁::天保"
date = '後梁::天保2.3.4'.when?
p date                                      #=> 天保02(0563).03.04
# **北朝の北斉
date = '天保2.3.4'.when?(:count=>3)
p date                                      #=> 天保02(0551).03.04
p date.calendar_era.iri                     #=> "http://hosi.org/When/TM/CalendarEra/Chinese::北朝::北斉::天保"
date = '北斉::天保2.3.4'.when?
p date                                      #=> 天保02(0551).03.04
# **四つ目はない
begin
  date = '天保2.3.4'.when?(:count=>4)
rescue => e
  p e.to_s                                  #=> ArgumentError: CalendarEraName doesn't exist: 天保
end

# *明治改元
# **改元前
date = '1868-10-22'.when?
p date                                      #=> 1868-10-22
list = date ^ 'Japanese'.calendar_era
p list                                      #=> [慶応04(1868).09.07, 明治01(1868).09.07]
p list[0].calendar_name[3]                  #=> nil
p list[1].calendar_name[3]                  #=> true (改元前)
# **改元後
date = '1868-10-23'.when?
p date                                      #=> 1868-10-23
list = date ^ 'Japanese'.calendar_era
p list                                      #=> [明治01(1868).09.08]
p list[0].calendar_name[3]                  #=> nil
p list[0].calendar_era.reference_date       #=> 01(1868)

# 年号の reference_date の“精度”が“年”なら、年初に遡って検索をヒットさせる

# *大正改元
# **改元前
date = '1912-7-29'.when?
p date                                      #=> 1912-07-29
list = date ^ 'Japanese'.calendar_era
p list                                      #=> [明治45(1912).07.29]
p list[0].calendar_name[3]                  #=> nil
# **改元後
date = '1912-7-30'.when?
p date                                      #=> 1912-07-30
list = date ^ 'Japanese'.calendar_era
p list                                      #=> [大正01(1912).07.30]
p list[0].calendar_name[3]                  #=> nil
p list[0].calendar_era.reference_date       #=> 01(1912).07.30

# 年号の reference_date の“精度”が“日”なら、年初に遡って検索をヒットさせない
