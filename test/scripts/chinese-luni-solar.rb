# -*- coding: utf-8 -*-
#
# Copyright (C) 2014 Takashi SUGA
#
require 'pp'
require 'when_exe'
require 'when_exe/region/chinese/calendars'
include When

def check(range, name, base, force=false)
  calendar = Calendar(name)
  count    = 0
  months   = 0
  puts "期間: #{name.sub(/^.*::/,'')} <#{range}>"
  puts ' 相違暦日   通日   日の干支  計算暦日  朔(計算)  定朔時刻/h(/d) 閏'
  date = when?("#{range.first}-1^^#{base}")
  while range.include?(date[YEAR]) do
    count  += 1
    months += 1 unless verify(date.floor, calendar, force)
    date  = date.next
  end
  puts "相違暦日集計: <%d/%d>\n\n" % [months, count] unless force
end

def verify(date0, calendar, force=false)
  date1 = calendar ^ date0
  if !force && date0.to_s == date1.to_s
    true
  else # 史上の暦日と不一致の場合は詳細を出力
    m   = When::Coordinates::Residue.mod(date0.to_i+3) {|cn| calendar.formula[-1].cn_to_time(cn)}
    t   = calendar.formula[-1].cn_to_time(m[0]) + 0.5
    t  -= calendar._time_basis[1].universal_time / 675 if calendar._time_basis[1]
    t,f = t.divmod(1)
    puts '%s %d %s %s %d %8.4f(%7.5f) %s' %
      [date0, date0.to_i, Residue('干支')  % date0, date1, t, f * 24.0, f, date0[DAY] == date1[DAY] ? '*' : '']
    false
  end
end

check(1281...1368, 'ChineseTwin::大統暦',   'Chinese0939')
check(1368...1500, 'ChineseTwin::大統暦',   'Chinese0939')
check(1501...1600, 'ChineseTwin::大統暦',   'Chinese0939')
check(1601...1662, 'ChineseTwin::大統暦',   'Chinese0939')
check(1685...1687, 'JapaneseTwin::貞享乙丑暦', 'Japanese')
check(1687...1753, 'JapaneseTwin::貞享暦',     'Japanese')
check(1753...1754, 'JapaneseTwin::宝暦癸酉暦', 'Japanese')
check(1754...1755, 'JapaneseTwin::宝暦甲戌暦', 'Japanese')
check(1755...1771, 'JapaneseTwin::宝暦暦',     'Japanese')
check(1771...1798, 'JapaneseTwin::修正宝暦暦', 'Japanese')
check(1798...1827, 'JapaneseTwin::寛政暦',     'Japanese')
check(1827...1844, 'JapaneseTwin::寛政丁亥暦', 'Japanese')
check(1844...1873, 'JapaneseTwin::天保暦',     'Japanese')
