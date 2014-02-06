# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2013 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module Test::TM
  class GeologicalAge < Test::Unit::TestCase
    def test__geological_age
      age = When.Resource('_tm:OrdinalReferenceSystem/GeologicalAge')
      assert_equal("-2500000000", age['始生代::新始生代'].end.to_s)
      assert_equal("-09700", age['顕生代::新生代::第四紀::完新世'].begin.to_s)
    end
  end
end
