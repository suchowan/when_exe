# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module Test

  class FrenchRepublican < Test::Unit::TestCase
    def test__french_republican
      date = When.when? '1.1.1^^FrenchRepublican'
      [["0001-01-01", 2375840],
       ["0002-01-01", 2376205],
       ["0003-01-01", 2376570],
       ["0004-01-01", 2376936],
       ["0005-01-01", 2377301],
       ["0006-01-01", 2377666],
       ["0007-01-01", 2378031],
       ["0008-01-01", 2378397],
       ["0009-01-01", 2378762],
       ["0010-01-01", 2379127],
       ["0011-01-01", 2379492],
       ["0012-01-01", 2379858],
       ["0013-01-01", 2380223],
       ["0014-01-01", 2380588]].each do |sample|
        assert_equal(sample, [date.to_s, date.to_i])
        date += When::P1Y
      end
    end
  end
end
