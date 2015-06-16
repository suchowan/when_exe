# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2015 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module MiniTest::TM
  class GeologicalAge < MiniTest::TestCase
    def test__geological_age
      age = When.Resource('_tm:OrdinalReferenceSystem/GeologicalAge')
      assert_equal("-2500000000", age['Archean::Neoarchean'].end.to_s)
      assert_equal("-09700", age['Phanerozoic::Cenozoic::Quaternary::Holocene'].begin.to_s)
    end
  end
end
