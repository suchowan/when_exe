# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

require 'when_exe'
require 'when_exe/region/chinese/calendars'
include When

class When::TM::CalendarEra
  Korea = [self, [
    'namespace:[en=https://en.wikipedia.org/wiki/, ja=https://ja.wikipedia.org/wiki/]',
    'locale:[=en:, ja=ja:, alias]',
    'area:[Korea, 朝鮮]',
    ['[秦漢]1.01.01',    '@CR',    "1-01-01^Chinese_103"],
    ['[魏晋]239.01.01',  '@CR',  "239-01-01^Chinese0239"],
    ['[南朝]451.01.01',  '@CR',  "451-01-01^Chinese0445"],
    ['[隋唐]590.01.01',  '@CR',  "590-01-01^Chinese0523"],
    ['[宣明]893.01.01',  '@CR',  "893-01-01^ChineseTwin::宣明暦"],
    ['[大統]1309.01.01', '@CR', "1309-01-01^Chinese0939"],
    ['[時憲]1653.01.01', '@CR', "1653-01-01^Chinese1645"],
    ['[旧暦]1912.01.01', '@CR', "1912-01-01^ChineseLuniSolar?time_basis=+09:00"]
  ]]
end

R = {'10-'=>'0X-', '11-'=>'0N-', '12-'=>'0D-'}

def list_1st_day(range, calendar)
  range.each do |year|
    list  = "%4d" % year
    kdate = first = when?("Korea#{year}.1.1")
    loop do
      wdate  = (calendar ^ kdate).to_s[-5..-1]
      wdate.sub!(/1.-/) {|c| R[c]}
      wdate.sub!(/^0/, '')
      wdate.sub!('-', '+') if kdate.length(MONTH) == 30
      list  += (kdate[MONTH] * 0 == 0) ? "  #{wdate} " : " (#{wdate})"
      kdate += P1M
      break unless year == kdate[YEAR]
    end
    puts list
=begin
    list  = "    "
    kdate = first
    loop do
      wdate  = (Residue('干支') % kdate).label
      list  += (kdate[MONTH] * 0 == 0) ? "  #{wdate} " : " (#{wdate})"
      kdate += P1M
      break unless year == kdate[YEAR]
    end
    puts list
=end
    puts if year % 10 == 0
 end
end

list_1st_day(1..1895, Civil)
