# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module Test::CalendarNote

  class NotesContainer < Test::Unit::TestCase

    def test__lunar_phases
      assert_equal([[{:note=>"月相", :value=>"朔(-233/3040)", :position=>"中段"}]],
        When.when?('承和2.4.2').notes(:notes=>'月相', :conditions=>{:shoyo=>true}))
      assert_equal([[{:note=>"月相", :value=>"望(1478.5/3040)", :position=>"中段"}]],
        When.when?('承和2.4.16').notes(:notes=>'月相', :conditions=>{:shoyo=>true}))
      all = {}
      assert_equal([[{:note=>"月相", :value=>"望(1478.5/3040)", :position=>"中段"}]],
        When.when?('承和2.4.16').notes(:notes=>'月相', :shoyo=>true, :persistence=>all))
      assert_equal({2026177=>[[{:note=>"月相", :value=>"望(1478.5/3040)", :position=>"中段"}]]}, all)
    end

    def test__persistence
      all    = {}
      notes0 = When.when?('平成25.9.22').notes(:persistence=>all)
      notes1 = When.when?('平成25.9.23').notes(:persistence=>all)
      notes2 = When.when?('平成25.9.24').notes(:persistence=>all)
      notes3 = When.when?('平成25.9.23').notes(:persistence=>all)

      [notes1, notes3].each do |notes|
        assert_equal(
          [[{:note=>"干支", :value=>"癸巳(29)", :position=>"共通"}],
           [{:note=>"月名", :value=>"September", :position=>"月建"}],
           [{:note=>"七曜", :value=>"Monday(0)", :position=>"共通"},
            {:note=>"干支", :value=>"壬辰(28)", :position=>"共通"},
            {:note=>"六曜", :value=>"友引", :position=>"民間"},
            {:note=>"廿四節気", :value=>"秋分(180)", :position=>"時候"},
            {:note=>"祝祭日", :value=>"秋分の日", :position=>"祝祭日"}]], notes)
      end

      assert_equal([["癸巳(29)"], ["September"], ["Monday(0)", "壬辰(28)", "友引", "秋分(180)", "秋分の日"]],
        notes1.simplify[:value])

      assert_equal([[{:note=>"月名", :value=>"September", :position=>"月建"}]], notes1.subset(:note=>/Month/))
      assert_equal([[{:note=>"干支", :value=>"癸巳(29)", :position=>"共通"}],
                    [{:note=>"干支", :value=>"壬辰(28)", :position=>"共通"}]], notes1.subset(:note=>'干支'))
      assert_equal([[{:note=>"祝祭日", :value=>"秋分の日", :position=>"祝祭日"}]], notes1.subset(:value=>'秋分の日'))
      assert_equal(nil, notes1.subset(:value=>'春分の日'))
      assert_equal([[nil], [nil], [nil, nil, nil, nil, nil]], notes1.subset({:value=>'春分の日'}, false))

      assert_equal([2456558, 2456559, 2456560], all.keys)
      assert_equal({2456559=>"秋分の日"}, all.subset(:value=>'秋分の日').simplify[:value])
    end

    def test__holiday
      date1 = When.when?('平成25.9.23')
      date2 = When.when?('平成25.9.24')
      notes1 = date1.notes("祝祭日")
      assert_equal([[{:note=>"祝祭日", :value=>"秋分の日", :position=>"祝祭日"}]], notes1)
      assert_equal({:note=>"祝祭日", :value=>"秋分の日", :position=>"祝祭日"}, notes1.simplify)
      assert_equal(true, date1.is?({:note=>"祝祭日", :value=>"秋分の日"}))
      assert_equal(true, date1.is?("祝祭日"))
      assert_equal(true, date1.is?("秋分の日"))
      assert_equal(false, date2.is?("秋分の日"))
    end
  end
end

