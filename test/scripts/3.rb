# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014-2015 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

# Calendar/When/Ruby/2.APIの使用例/3.年号の扱い

# →関連クラス図 [[Calendar/When/Ruby/3.クラス図/13.暦及び時計]]

# *準備
# when_exe Ruby 版の When モジュールを include する
require 'when_exe'
include When

# コア拡張を利用する場合は[[Calendar/When/Ruby/2.APIの使用例/3.年号の扱い/コア拡張]]を参照

# 使用可能な &yard(CalendarEra) は http://hosi.org/frames/When/TM/CalendarEra.html 参照

# *グレゴリオ暦 ⇔ 現代日本暦日
# **最近の日付
date = tm_pos(2013, 5, 25)
p date                                #=> 2013-05-25
p CalendarEra('ModernJapanese').iri   #=> "http://hosi.org/When/TM/CalendarEra/ModernJapanese"
list = date ^ CalendarEra('ModernJapanese')
p list                                #=> [H25(2013).05.25]
p list[0].frame.iri                   #=> "http://hosi.org/When/CalendarTypes/Gregorian?note=DefaultNotes"
date = tm_pos('H', 25, 5, 25)
p date                                #=> H25(2013).05.25
p Calendar('Gregorian') ^ date        #=> 2013-05-25
date = when?('H25.5.25')
p date                                #=> H25(2013).05.25
p Calendar('Gregorian') ^ date        #=> 2013-05-25

# *グレゴリオ暦 ⇔ 西暦(CE/BCE)
# **グレゴリオ暦改暦直後
date = when?('1582-10-15')
p date                                #=> 1582-10-15
p CalendarEra('Common').iri           #=> "http://hosi.org/When/TM/CalendarEra/Common"
list = date ^ CalendarEra('Common')
p list                                #=> [CE1582.10.15]
p list[0].frame.iri                   #=> "http://hosi.org/When/CalendarTypes/Gregorian"
date = tm_pos('CE', 1582, 10, 15)
p date                                #=> CE1582.10.15
p Calendar('Gregorian') ^ date        #=> 1582-10-15
date = when?('CE1582.10.15')
p date                                #=> CE1582.10.15
p Calendar('Gregorian') ^ date        #=> 1582-10-15

# **グレゴリオ暦改暦直前
date = when?('1582-10-14')
p date                                #=> 1582-10-14
list = date ^ CalendarEra('Common')
p list                                #=> [CE1582.10.04]
p list[0].frame.iri                   #=> "http://hosi.org/When/CalendarTypes/Julian"
date = tm_pos('CE', 1582, 10, 4)
p date                                #=> CE1582.10.04
p Calendar('Gregorian') ^ date        #=> 1582-10-14
date = when?('CE1582.10.4')
p date                                #=> CE1582.10.04
p Calendar('Gregorian') ^ date        #=> 1582-10-14

# **紀元前45年
date = when?('-44-03-13')
p date                                #=> -00044-03-13
list = date ^ CalendarEra('Common')
p list                                #=> [BCE45(-044).03.15]
p list[0].frame.iri                   #=> "http://hosi.org/When/CalendarTypes/Julian"
date = tm_pos('BCE', 45, 3, 15)
p date                                #=> BCE45(-044).03.15
p Calendar('Gregorian') ^ date        #=> -00044-03-13
date = when?('BCE45.3.15')
p date                                #=> BCE45(-044).03.15
p Calendar('Gregorian') ^ date        #=> -00044-03-13

# *天保年号のバリエーション
# **日本
date = when?('天保2.3.4')             # ここで日本暦日をメモリに展開するため、少々時間がかかる
p date                                #=> 天保02(1831).03.04
p date.calendar_era.iri               #=> "http://hosi.org/When/TM/CalendarEra/Japanese::江戸時代::天保"
# **南朝の後梁
date = when?('天保2.3.4', :count=>2)  # ここで中国暦日をメモリに展開するため、さらに時間がかかる
p date                                #=> 天保02(0563).03.04
p date.calendar_era.iri               #=> "http://hosi.org/When/TM/CalendarEra/Chinese::南朝::後梁::天保"
date = when?('後梁::天保2.3.4')
p date                                #=> 天保02(0563).03.04
# **北朝の北斉
date = when?('天保2.3.4', :count=>3)
p date                                #=> 天保02(0551).03.04
p date.calendar_era.iri               #=> "http://hosi.org/When/TM/CalendarEra/Chinese::北朝::北斉::天保"
date = when?('北斉::天保2.3.4')
p date                                #=> 天保02(0551).03.04
# **四つ目はない
begin
  date = when?('天保2.3.4', :count=>4)
rescue => e
  p e.to_s                            #=> ArgumentError: CalendarEraName doesn't exist: 天保
end

# *明治改元
# **改元前
date = when?('1868-10-22')
p date                                #=> 1868-10-22
list = date ^ CalendarEra('Japanese')
p list                                #=> [慶応04(1868).09.07, 明治01(1868).09.07]
p list[0].calendar_era_go_back        #=> nil
p list[1].calendar_era_go_back        #=> true (改元前)
# **改元後
date = when?('1868-10-23')
p date                                #=> 1868-10-23
list = date ^ CalendarEra('Japanese')
p list                                #=> [明治01(1868).09.08]
p list[0].calendar_era_go_back        #=> nil
p list[0].calendar_era.reference_date #=> 01(1868)

# 年号の reference_date の“精度”が“年”なら、年初に遡って検索をヒットさせる

# *大正改元
# **改元前
date = when?('1912-7-29')
p date                                #=> 1912-07-29
list = date ^ CalendarEra('Japanese')
p list                                #=> [明治45(1912).07.29]
p list[0].calendar_era_go_back        #=> nil
# **改元後
date = when?('1912-7-30')
p date                                #=> 1912-07-30
list = date ^ CalendarEra('Japanese')
p list                                #=> [大正01(1912).07.30]
p list[0].calendar_era_go_back        #=> nil
p list[0].calendar_era.reference_date #=> 01(1912).07.30

# 年号の reference_date の“精度”が“日”なら、年初に遡って検索をヒットさせない
