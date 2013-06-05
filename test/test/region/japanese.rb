# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2012 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module Test

  class Japanese < Test::Unit::TestCase

    def test_japanese_epoch
      eras = When.Resource('_e:Japanese')

      sample = 
        [["天平21(0749).04.13", "天平感宝01(0749).04.13", "天平勝宝01(0749).04.13"],
         ["天平21(0749).04.13"],
         ["天平感宝01(0749).04.14", "天平勝宝01(0749).04.14"],
         ["天平感宝01(0749).04.14"],
         ["天平勝宝01(0749).07.02"],
         ["天平勝宝01(0749).07.02"]]
      ['天平勝宝01.04.13', '天平勝宝01.04.14', '天平勝宝01.07.02'].each do |string|
        assert_equal(sample.shift, ((When.when?(string) ^ eras).
                                     delete_if {|d| !d.leaf?}).map {|d| d.to_s})
        assert_equal(sample.shift, ((When.when?(string, {:lower=>true}) ^ eras).
                                     delete_if {|d| !d.leaf?}).map {|d| d.to_s})
      end

      sample =
        [["大正15(1926).12.24"],
         ["大正15(1926).12.24"],
         ["昭和01(1926).12.25"],
         ["昭和01(1926).12.25"],
         ["昭和01(1926).12.26"],
         ["昭和01(1926).12.26"]]
      ['大正15.12.24', '大正15.12.25', '大正15.12.26'].each do |string|
        assert_equal(sample.shift, ((When.when?(string) ^ eras).
                                     delete_if {|d| !d.leaf?}).map {|d| d.to_s})
        assert_equal(sample.shift, ((When.when?(string, {:lower=>true}) ^ eras).
                                     delete_if {|d| !d.leaf?}).map {|d| d.to_s})
      end
    end

=begin
    def test_japanese_date
      jc   = When.Resource('_c:Japanese')
      diff = []
      open('test/region/japanese-calendar.txt', "1".respond_to?(:force_encoding) ? 'r:utf-8' : 'r') do |f|
        while (line = f.gets)
          next if line =~ /^ *#/
          x, x, jdn, x, x, x, gy, gm, gd, x, x, jy, jm, jd = line.split(/ +/).map {|v| v.to_i}
          jm, leap = (jm > 0) ? [jm, '-'] : [-jm, '=']
          date = When.when?("%04d-%02d%s%02d" % [(gm >= jm) ? gy : gy-1, jm, leap, jd], {:frame=>jc})
          diff << [jdn - date.to_i, date.to_s] unless jdn == date.to_i
        end
      end
      assert_equal([], diff)
    end
=end
  end
end
