# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

# Calendar/When/Ruby/2.APIの使用例/5.剰余類

# →関連クラス図 [[Calendar/When/Ruby/3.クラス図/01.Coordinates]]

# *準備
# when_exe Ruby 版の When モジュールを include する
require 'when_exe'
include When

# コア拡張を利用する場合は[[Calendar/When/Ruby/2.APIの使用例/5.剰余類/コア拡張]]を参照

# *日の剰余
# ** 剰余を求める
date = when?('2013-05-28')
p date                                #=> 2013-05-28
p day_of_week('Week').iri             #=> "http://hosi.org/When/Coordinates/CommonResidue::Week"
p (day_of_week('Week') % date).iri    #=> "http://hosi.org/When/Coordinates/CommonResidue::Week::Tuesday"
p date % day_of_week('Week')          #=> 1 (Integer)
p day_of_week(1).iri                  #=> "http://hosi.org/When/Coordinates/CommonResidue::Week::Tuesday"

# ** 指定の剰余となる日を求める
date = when?('2013-05-27')
p date                                #=> 2013-05-27
p day_of_week('Tuesday').iri          #=> "http://hosi.org/When/Coordinates/CommonResidue::Week::Tuesday"
p date & day_of_week('Tuesday')       #=> 2013-05-28
p date & day_of_week('Tuesday') << 1  #=> 2013-05-21
p Residue('甲子').iri                 #=> "http://hosi.org/When/Coordinates/CommonResidue::干支::甲子"
p date & Residue('甲子')              #=> 2013-06-27
p date & Residue('甲子') >> 1         #=> 2013-08-26
p date & (day_of_week('Tuesday') & Residue('甲子')) #=> 2013-12-24

# **ブロック
date = when?('2013-05-27')
p date                                #=> 2013-05-27
day_of_week('Tuesday').enum_for(date, :forward, 3).each do |d|
  p d                                 #=> 2013-05-28, 2013-06-04, 2013-06-11
end
day_of_week('Tuesday').enum_for(date, :reverse, 3).each do |d|
  p d                                 #=> 2013-05-21, 2013-05-14, 2013-05-07
end

# *年の剰余
p Residue('Indiction')                #=> nil
p Residue('Metonic')                  #=> nil
p Residue('Solar')                    #=> nil

# ローマ暦をメモリにロードし、建国紀元500年の日付詳細を出力

p when?('AUC0500').to_h(:method=>:to_m17n, :locale=>'en') #=> 下記
 # {:frame=>"http://hosi.org/When/CalendarTypes/RomanA?border=0-5-1",
 #  :precision=>-2,
 #  :trans=>{},
 #  :query=>{"area"=>"", "period"=>"Roman", :validate=>:epoch},
 #  :sdn=>1628745,
 #  :calendar=>["http://hosi.org/When/TM/CalendarEra/Roman::AUC", -753],
 #  :notes=>
 #   [[{:note=>"Solar", :value=>"Solar(7)"},
 #     {:note=>"Metonic", :value=>"Metonic(13)"},
 #     {:note=>"Indiction", :value=>"V"}],
 #    [],
 #    []],
 #  :cal_date=>["500", "5", 1]}

# 剰余類の定義がメモリに読み込まれている

p Residue('Indiction').iri #=> "http://hosi.org/When/CalendarTypes/CalendarNote/RomanNote/NoteObjects::year::Indiction"
p Residue('Metonic').iri   #=> "http://hosi.org/When/CalendarTypes/CalendarNote/RomanNote/NoteObjects::year::Metonic"
p Residue('Solar').iri     #=> "http://hosi.org/When/CalendarTypes/CalendarNote/RomanNote/NoteObjects::year::Solar"

# ユリウス通日の元期を求めてみる
p tm_pos(2014, 1, 1, :frame=>'Julian') &
   ((Residue('Indiction') &
     Residue('Metonic')   &
     Residue('Solar')) << 1) #=> -04712-01-01 (ユリウス通日の元期)
