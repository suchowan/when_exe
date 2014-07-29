# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module MiniTest

  class Balenese< MiniTest::TestCase
    def test_balinese_note
      note   = When::CalendarNote('Balinese')
      b_date = When::Calendar('BalineseLuniSolar2003') ^ When.when?('2012-6-19')
      g_date = When::Calendar('Gregorian')^b_date
      assert_equal(["Ulat/Lidi"    ], [note.hari(b_date).to_s,       note.hari(g_date).to_s      ].uniq) # hari      
      assert_equal(["Pepet"        ], [note.dwiwara(b_date).to_s,    note.dwiwara(g_date).to_s   ].uniq) # dwiwara   
      assert_equal(["Kajeng(2)"    ], [note.triwara(b_date).to_s,    note.triwara(g_date).to_s   ].uniq) # triwara   
      assert_equal(["Jaya"         ], [note.tjaturwara(b_date).to_s, note.tjaturwara(g_date).to_s].uniq) # tjaturwara
      assert_equal(["Wage(2)"      ], [note.pantjawara(b_date).to_s, note.pantjawara(g_date).to_s].uniq) # pantjawara
      assert_equal(["Urukung(2)"   ], [note.perinkelan(b_date).to_s, note.perinkelan(g_date).to_s].uniq) # perinkelan
      assert_equal(["Sato(2)"      ], [note.sadwara(b_date).to_s,    note.sadwara(g_date).to_s   ].uniq) # sadwara   
      assert_equal(["Anggara(2)"   ], [note.septawara(b_date).to_s,  note.septawara(g_date).to_s ].uniq) # septawara 
      assert_equal(["Guru"         ], [note.astawara(b_date).to_s,   note.astawara(g_date).to_s  ].uniq) # astawara  
      assert_equal(["Dangu"        ], [note.sangawara(b_date).to_s,  note.sangawara(g_date).to_s ].uniq) # sangawara 
      assert_equal(["Raja"         ], [note.dasawara(b_date).to_s,   note.dasawara(g_date).to_s  ].uniq) # dasawara  
      assert_equal(["Wong(2)"      ], [note.ingkel(b_date).to_s,     note.ingkel(g_date).to_s    ].uniq) # ingkel    
      assert_equal(["Watu-Lembu"   ], [note.watek(b_date).to_s,      note.watek(g_date).to_s     ].uniq) # watek     
      assert_equal(["Jong Sarat(2)"], [note.lintang(b_date).to_s,    note.lintang(g_date).to_s   ].uniq) # lintang   
      assert_equal(["Sinta(2)"     ], [note.wuku(b_date).to_s,       note.wuku(g_date).to_s      ].uniq) # wuku      
    end
  end
end

