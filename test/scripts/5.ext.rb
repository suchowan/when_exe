# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

# Calendar/When/Ruby/2.APIの使用例/5.剰余類/コア拡張

# コアクラスを require 'when_exe/core/extension' で拡張した場合の記法を確認

# *準備
# when_exe Ruby 版の When モジュールを include する
require 'when_exe'
require 'when_exe/core/extension'
include When

# *日の剰余
# ** 剰余を求める
date = '2013-05-28'.when?
p date                               #=> 2013-05-28
p 'Week'.day_of_week.iri             #=> "http://hosi.org/When/Coordinates/CommonResidue::Week"
p ('Week'.day_of_week % date).iri    #=> "http://hosi.org/When/Coordinates/CommonResidue::Week::Tuesday"
p date % 'Week'.day_of_week          #=> 1 (Integer)
p 1.day_of_week.iri                  #=> "http://hosi.org/When/Coordinates/CommonResidue::Week::Tuesday"

# ** 指定の剰余となる日を求める
date = '2013-05-27'.when?
p date                               #=> 2013-05-27
p 'Tuesday'.day_of_week.iri          #=> "http://hosi.org/When/Coordinates/CommonResidue::Week::Tuesday"
p date & 'Tuesday'.day_of_week       #=> 2013-05-28
p date & 'Tuesday'.day_of_week << 1  #=> 2013-05-21
p '甲子'.residue.iri                 #=> "http://hosi.org/When/Coordinates/CommonResidue::干支::甲子"
p date & '甲子'.residue              #=> 2013-06-27
p date & '甲子'.residue >> 1         #=> 2013-08-26
p date & ('Tuesday'.day_of_week & '甲子'.residue) #=> 2013-12-24

# **ブロック
date = '2013-05-27'.when?
p date                               #=> 2013-05-27
(date ^ 'Tuesday'.day_of_week).each do |d|
  break if d >= '2013-06-15'.when?
  p d                                #=> 2013-05-28, 2013-06-04, 2013-06-11
end

# *年の剰余
p 'Indiction'.residue                #=> nil
p 'Metonic'.residue                  #=> nil
p 'Solar'.residue                    #=> nil

# ローマ暦をメモリにロードし、建国紀元500年の日付詳細を出力

p 'AUC0500'.when?.to_h(:method=>:to_m17n, :locale=>'en') #=> 下記
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

p 'Indiction'.residue.iri #=> "http://hosi.org/When/CalendarTypes/CalendarNote/RomanNote/NoteObjects::year::Indiction"
p 'Metonic'.residue.iri   #=> "http://hosi.org/When/CalendarTypes/CalendarNote/RomanNote/NoteObjects::year::Metonic"
p 'Solar'.residue.iri     #=> "http://hosi.org/When/CalendarTypes/CalendarNote/RomanNote/NoteObjects::year::Solar"

# ユリウス通日の元期を求めてみる
p [2014, 1, 1].tm_pos(:frame=>'Julian') &
   (('Indiction'.residue &
    'Metonic'.residue   &
    'Solar'.residue) << 1) #=> -04712-01-01 (ユリウス通日の元期)
