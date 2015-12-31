# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2015 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module When::Coordinates

  t1 = LocationTable[1]
  t2 = LocationTable[2]
  t3 = LocationTable[3]
  t4 = LocationTable[4]
  co = (0..2).to_a

  # 位置参照情報ダウンロードサービス「全ての大字・町丁目レベル」( http://nlftp.mlit.go.jp/isj/ )を配置してください
  geolocation_data = When::Parts::Resource.root_dir + '/data/geolocation/japanese/*.csv'

  #
  # はしご高など UTF-8 への変換に失敗するコードを含む地名は登録しない
  #
  # @private
  def self.utf_gets(io)
    error_occurred = false
    line = nil
    loop do
      error = nil
      begin
        line = io.gets
      rescue Encoding::UndefinedConversionError => error
        error_occurred = true
      end
      unless error
        return error_occurred ? utf_gets(io) : line
      end
    end
  end

  Dir.glob(geolocation_data).each do |path|
    open(path,'r:SHIFT_JIS') do |io|
      h = {}
      lines = ''
      while (line = utf_gets(io))
        lines.concat(line)
      end
      CSV.parse(lines) do |r|
        if h.empty?
          h = Hash[*(0...r.size).to_a.map {|i| [r[i],i]}.flatten]
        else
          location    = [r[h['経度']].to_f, r[h['緯度']].to_f, 0]
          wide_name   = r[h['都道府県名']]
          middle_name = wide_name + r[h['市区町村名']]
          fine_name   = r[h['大字町丁目名']]
          full_name   = middle_name + fine_name
          t1[full_name] = location
          t2[middle_name][fine_name] = location
          t3[wide_name][r[h['市区町村名']]][fine_name] = location
          case r[h['市区町村名']]
          when /\A((.+)市)(.+区)\z/
            t1[$1 + $3 + fine_name] = location
            t2[$1 + $3] [fine_name] = location
            t3[$1] [$3] [fine_name] = location
            t3[$2] [$3] [fine_name] = location
          when /\A((.+)市)\z/
            t4[$1] << middle_name
            t4[$2] << middle_name
            t4[$1 + fine_name] << full_name
          when /\A.+郡(.+[町村])\z/
            t4[wide_name + $1] << middle_name
            t4[wide_name + $1 + fine_name] << full_name
          end
        end
      end
    end
  end

  t3.keys.each do |p|
    t3[p].keys.each do |c|
      locations = t3[p][c].values.transpose
      t3[p][c][:SWB] = t2[p+c][:SWB] = co.map {|i| locations[i].min}
      t3[p][c][:NET] = t2[p+c][:NET] = co.map {|i| locations[i].max}
    end
    swb = t3[p].keys.map {|c| t3[p][c][:SWB]}.transpose
    net = t3[p].keys.map {|c| t3[p][c][:NET]}.transpose
    t3[p][:SWB] = co.map {|i| swb[i].min}
    t3[p][:NET] = co.map {|i| net[i].max}
  end

  t4.each_pair do |key, value|
    value.uniq!
  end
end
