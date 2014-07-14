# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module MiniTest

  class Coptic < MiniTest::TestCase
    def test__coptic
      julian    = When.Calendar('Julian')
      gregorian = When.Calendar('Gregorian')
      ethiopian = When.Calendar('Coptic?Epoch=8Y')
      egyptian  = When.Calendar('Coptic?Epoch=284Y')

      [['2010-8-29', %w(2010-08-29 2010-09-11 2003-01-01 1727-01-01)],
       ['2011-8-30', %w(2011-08-30 2011-09-12 2004-01-01 1728-01-01)],
       ['2012-8-29', %w(2012-08-29 2012-09-11 2005-01-01 1729-01-01)],
       ['2013-8-29', %w(2013-08-29 2013-09-11 2006-01-01 1730-01-01)]].each do |sample|
        date = When.when?(sample[0], :frame=>julian)
        assert_equal(sample[1], [date.to_s, (gregorian ^ date).to_s, (ethiopian ^ date).to_s, (egyptian ^ date).to_s])
      end
    end
  end
end
