# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2013 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

require 'pp'
require 'when_exe'
include When

#require 'date'
#pp now({:clock=>'+0900'}).to_datetime.strftime('%+')

#=begin
date = today
pp [date.to_s, date.strftime('%D'), date.frame.iri, date.to_time.to_s]
puts

['Julian', 'ChineseLuniSolar?time_basis=+09&intercalary_span=3', 'TabularIslamic', 'Jewish', 'LongCount'].each do |calendar|
  date = Calendar(calendar) ^ today
  pp [date.to_s,  date.frame.iri]
end
puts

(today ^ TM::Calendar).each do |date|
  pp [date.to_s,  date.frame.iri]
end
puts

pp today.month_included('SU') {|date, type|
     case type
     when WEEK       ; '*'
     when YEAR,MONTH ; date.strftime("%B %Y")
     when DAY        ; date[0]
     else            ; ''
     end
   }
puts

pp when?('CE1582.10').month_included('SU') {|date, type|
     case type
     when WEEK       ; nil
     when YEAR,MONTH ; date.strftime("%B %Y")
     when DAY        ; date[0]
     else            ; ''
     end
   }
puts

it = Resource("JapanHolidays.ics").enum_for(today.year_included)
it.each do |date|
  pp date.to_s
end
puts

Resource("NewYork.ics")
time = now({:clock=>'America/New_York'})
pp [time.to_s, time.strftime('%+'), time.clock.tzname[0]]

