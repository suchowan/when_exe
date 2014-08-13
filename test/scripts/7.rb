# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

# Calendar/When/Ruby/2.APIの使用例/7.暦注

# →関連クラス図 [[Calendar/When/Ruby/3.クラス図/03.CalendarTypes]]

# *準備
# when_exe Ruby 版の When モジュールを include する
require 'when_exe'
include When

# 七曜表の扱いなどについては[[Calendar/When/Ruby/2.APIの使用例/7.暦注/七曜]]を参照

# *復活祭
# ** グレゴリオ暦
gdate = CalendarNote('Christian').easter(when?('2013'))
p [gdate, gdate.frame.class]                                #=> [2013-03-31, When::CalendarTypes::Gregorian]
gdate = when?('2013').easter
p [gdate, gdate.frame.class]                                #=> [2013-03-31, When::CalendarTypes::Gregorian]
p gdate.events                                              #=> ["easter"]
p gdate.to_h(:method=>:to_m17n)                             #=> 下記
 # {:frame=>"http://hosi.org/When/CalendarTypes/Gregorian",
 #  :precision=>0,
 #  :events=>["easter"],
 #  :sdn=>2456383,
 #  :calendar=>["http://hosi.org/When/CalendarTypes/Gregorian"],
 #  :notes=>[[{:note=>"Month", :value=>"March"}], []],
 #  :cal_date=>[2013, 3, 31]}
p CalendarNote('Christian').include?(gdate, 'easter')       #=> true
p gdate.is?('easter')                                       #=> true
p CalendarNote('Christian').include?(Calendar('Julian') ^ gdate, 'easter') #=> false
p (Calendar('Julian') ^ gdate).is?('easter')                #=> false

# ** ユリウス暦
jdate = CalendarNote('Christian').easter(when?('2013^^Julian'))
p [jdate, jdate.frame.class, Calendar('Gregorian') ^ jdate] #=> [2013-04-22, When::CalendarTypes::Julian, 2013-05-05]
jdate = when?('2013^^Julian').easter
p [jdate, jdate.frame.class, Calendar('Gregorian') ^ jdate] #=> [2013-04-22, When::CalendarTypes::Julian, 2013-05-05]
p jdate.events                                              #=> ["easter"]
p CalendarNote('Christian').include?(jdate, 'easter')       #=> true
p jdate.is?('easter')                                       #=> true
p CalendarNote('Christian').include?(Calendar('Gregorian') ^ jdate, 'easter') #=> false
p (Calendar('Gregorian') ^ jdate).is?('easter')             #=> false

# *秋分の日
# **デフォルト暦注
date = when?('H25.9.23')
p date                                                      #=> H25(2013).09.23
p date.frame.iri                                            #=> "http://hosi.org/When/CalendarTypes/Gregorian?note=DefaultNotes"
p date.notes                                                #=>[[{:note=>"Month", :value=>"September"}], []]

# &yard(When::TM::CalendarEra,1)('&yard(ModernJapanese)')は日本暦注を読み込まない

# **日本暦注
date = when?('平成25.9.23')                                 # ここで日本暦日をメモリに展開するため、少々時間がかかる
p date                                                      #=> 平成25(2013).09.23
p date.frame.iri                                            #=> "http://hosi.org/When/CalendarTypes/Gregorian?note=JapaneseNote"
p date.notes                                                #=> 下記
 # [[{:note=>"干支",     :value=>"癸巳(29)",  :position=>"共通"}],
 #  [{:note=>"月名",     :value=>"September", :position=>"月建"}],
 #  [{:note=>"干支",     :value=>"壬辰(28)",  :position=>"共通"},
 #   {:note=>"六曜",     :value=>"友引",      :position=>"民間"},
 #   {:note=>"廿四節気", :value=>"秋分(180)", :position=>"時候"},
 #   {:note=>"祝祭日",   :value=>"秋分の日",  :position=>"祝祭日"}]]
p date.notes("祝祭日")                                      #=> {:note=>"祝祭日",   :value=>"秋分の日",  :position=>"祝祭日"}
p date.is?({:note=>"祝祭日", :value=>"秋分の日"})           #=> true
p date.is?("祝祭日")                                        #=> true
p date.is?("秋分の日")                                      #=> true

# *応永年間
# **すべての日本暦注
date = when?('応永25.9.23')
p date                                                      #=> 応永25(1418).09.23
p date.notes({:notes=>:all, :locale=>'ja.UTF-8'})           #=> 省略 (全暦注出力)

# *ヒンドゥー暦
# **パンチャンガ
date = Calendar('HinduLuniSolar?note=HinduNote') ^ when?('2013-5-28', :clock=>'+05:30')
p date                                                      #=> 1935-02<04-T+05:30
p date.notes({:locale=>'ja.UTF-8'})                         #=> 下記
 # [[],
 #  [{:note=>"Month",
 #    :value=>"Vaiśākha Kṛṣṇapakṣa"}],
 #  [{:note=>"tithi", :value=>["Chaturthi(00:42:49)"]},
 #   {:note=>"vara", :value=>["Maṅgala(05:48:00)"]},
 #   {:note=>"naksatra", :value=>["U. āṣāḍha(16:47:13)"]},
 #   {:note=>"yoga", :value=>["ukla(11:57:35)"]},
 #   {:note=>"karana", :value=>["Bālava(13:54:42)", "Kaulava(00:42:49)"]}]]

# それぞれの要素の値が上記になる時刻を時間帯+05:30で表記
