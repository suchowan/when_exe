# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2014 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

require 'pp'
require 'when_exe'
include When

Type = {
  354 => 'A',
  355 => 'B',
  384 => 'C'
}

Pattern = {}

open('scripts/thai-reviewed.txt', 'r') do |source|
  this_year = nil
  while (line=source.gets)
    year, month, day = line.split(/ +/)[2..4].map {|c| c.to_i}
    next_year = TemporalPosition(year, month, day, :frame=>Gregorian)
    thai_year = TemporalPosition(year-638, 6,   1, :frame=>'ThaiT')
    raise ArgumentError, "#{next_year} != #{Gregorian ^ thai_year}" unless next_year.to_i == thai_year.to_i
    year     -= 1
    if this_year
      type = Type[next_year.to_i-this_year.to_i]
      Pattern[year] = type
      puts "%04d,%04d,%s" % [year, year-638, type || '!']
    end
    this_year = next_year
  end
end
