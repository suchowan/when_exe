# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2015 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module MiniTest::LinkedData

  class Resouece < MiniTest::TestCase

    Dates = {
      'HinduLuniSolar?note=HinduNoteDetailed&location=(_co:Indian::Ujjain)&start_month=5&type=SBSA(1936-10%3C10-)' => {"@context"=>
        {"xsd"=>"http://www.w3.org/2001/XMLSchema",
         "rdf"=>"http://www.w3.org/1999/02/22-rdf-syntax-ns#",
         "rdfs"=>"http://www.w3.org/2000/01/rdf-schema#",
         "owl"=>"http://www.w3.org/2002/07/owl#",
         "dc"=>"http://purl.org/dc/elements/1.1/",
         "dcq"=>"http://purl.org/dc/terms/",
         "dct"=>"http://purl.org/dc/dcmitype/",
         "ts"=>"http://hosi.org/ts#",
         "day"=>"http://hosi.org/When/CalendarNote/HinduNoteDetailed/Notes::day::"},
       "@graph"=>
        [{"rdf:type"=>{"@id"=>"http://hosi.org/ts/When/TM/CalDate"},
          "@id"=>
           "http://hosi.org/tp/1936-10%3C10-%5E%5EHinduLuniSolar?note=HinduNoteDetailed&location=(_co:Indian::Ujjain)&start_month=5&type=SBSA",
          "ts:sdn"=>2457038,
          "ts:frame"=>
           {"@id"=>
             "http://hosi.org/When/CalendarTypes/HinduLuniSolar?note=HinduNoteDetailed&location=(_co:Indian::Ujjain)&start_month=5&type=SBSA"},
          "ts:coordinate"=>"10",
          "@reverse"=>
           {"rdfs:member"=>
             {"@id"=>
               "http://hosi.org/tp/1936-10%3C%5E%5EHinduLuniSolar?note=HinduNoteDetailed&location=(_co:Indian::Ujjain)&start_month=5&type=SBSA"}},
          "day:tithi"=>"Dashami(00:42)",
          "day:vara"=>"Guru(07:07)",
          "day:naksatra"=>"Anurādhā(04:59)",
          "day:yoga"=>"Gaṇḍa(21:11)",
          "day:karana"=>["Viṣṭi(12:34)", "Bava(00:42)"]}]},
      'Civil?note=Ephemeris(2015-01-15)' => {"@context"=>
        {"xsd"=>"http://www.w3.org/2001/XMLSchema",
         "rdf"=>"http://www.w3.org/1999/02/22-rdf-syntax-ns#",
         "rdfs"=>"http://www.w3.org/2000/01/rdf-schema#",
         "owl"=>"http://www.w3.org/2002/07/owl#",
         "dc"=>"http://purl.org/dc/elements/1.1/",
         "dcq"=>"http://purl.org/dc/terms/",
         "dct"=>"http://purl.org/dc/dcmitype/",
         "ts"=>"http://hosi.org/ts#",
         "day"=>"http://hosi.org/When/CalendarNote/Ephemeris/Notes::day::"},
       "@graph"=>
        [{"rdf:type"=>{"@id"=>"http://hosi.org/ts/When/TM/CalDate"},
          "@id"=>"http://hosi.org/tp/2015-01-15%5E%5ECivil?note=Ephemeris",
          "ts:sdn"=>2457038,
          "ts:frame"=>
           {"@id"=>"http://hosi.org/When/CalendarTypes/Civil?note=Ephemeris"},
          "ts:coordinate"=>"15",
          "@reverse"=>
           {"rdfs:member"=>
             {"@id"=>"http://hosi.org/tp/2015-01%5E%5ECivil?note=Ephemeris"}},
          "day:Moon_Age"=>"Moon_Age(24.4)"}]},
      '明治5-12-' => {"@context"=>
        {"xsd"=>"http://www.w3.org/2001/XMLSchema",
         "rdf"=>"http://www.w3.org/1999/02/22-rdf-syntax-ns#",
         "rdfs"=>"http://www.w3.org/2000/01/rdf-schema#",
         "owl"=>"http://www.w3.org/2002/07/owl#",
         "dc"=>"http://purl.org/dc/elements/1.1/",
         "dcq"=>"http://purl.org/dc/terms/",
         "dct"=>"http://purl.org/dc/dcmitype/",
         "ts"=>"http://hosi.org/ts#",
         "MonthNote"=>"http://hosi.org/When/CalendarNote/Japanese/Notes::月::",
         "LunarMansion"=>"http://hosi.org/When/Coordinates/Common::宿::",
         "Stem-Branch"=>"http://hosi.org/When/Coordinates/Common::干支::",
         "DayNote"=>"http://hosi.org/When/CalendarNote/Japanese/Notes::日::",
         "Week"=>"http://hosi.org/When/Coordinates/Common::Week::"},
       "@graph"=>
        [{"rdf:type"=>{"@id"=>"http://hosi.org/ts/When/TM/CalDate"},
          "@id"=>"http://hosi.org/tp/明治05(1872)-12-",
          "ts:sdn"=>2405158,
          "ts:frame"=>{"@id"=>"http://hosi.org/When/CalendarTypes/Japanese"},
          "ts:calendarEra"=>
           {"@id"=>"http://hosi.org/When/TM/CalendarEra/Japanese::明治"},
          "ts:coordinate"=>"12",
          "ts:ruler"=>
           {"@id"=>"http://hosi.org/When/TM/CalendarEra/Japanese::明治::明治天皇"},
          "@reverse"=>{"rdfs:member"=>{"@id"=>"http://hosi.org/tp/明治05(1872)"}},
          "MonthNote:月名"=>"十二月",
          "MonthNote:廿八宿"=>{"@id"=>"LunarMansion:危宿"},
          "MonthNote:月建"=>{"@id"=>"Stem-Branch:癸丑"},
          "MonthNote:天道"=>"西行",
          "MonthNote:天徳"=>"庚",
          "MonthNote:月煞"=>"辰",
          "MonthNote:用時"=>"乙丁辛亥",
          "MonthNote:月徳"=>"庚",
          "MonthNote:月徳合"=>"乙",
          "MonthNote:月空"=>"甲",
          "MonthNote:三鏡"=>"甲乙丁庚辛癸",
          "MonthNote:土府"=>"子",
          "MonthNote:土公"=>"庭",
          "MonthNote:大小"=>"改(2)"},
         {"rdf:type"=>{"@id"=>"http://hosi.org/ts/When/TM/CalDate"},
          "@id"=>"http://hosi.org/tp/明治05(1872)-12-01",
          "ts:sdn"=>2405158,
          "ts:frame"=>{"@id"=>"http://hosi.org/When/CalendarTypes/Japanese"},
          "ts:calendarEra"=>
           {"@id"=>"http://hosi.org/When/TM/CalendarEra/Japanese::明治"},
          "ts:coordinate"=>"1",
          "ts:ruler"=>
           {"@id"=>"http://hosi.org/When/TM/CalendarEra/Japanese::明治::明治天皇"},
          "@reverse"=>{"rdfs:member"=>{"@id"=>"http://hosi.org/tp/明治05(1872)-12-"}},
          "DayNote:干支"=>{"@id"=>"Stem-Branch:辛亥"},
          "DayNote:納音"=>"金",
          "DayNote:十二直"=>"閉",
          "DayNote:七曜"=>{"@id"=>"Week:Monday"},
          "DayNote:廿八宿"=>{"@id"=>"LunarMansion:張宿"},
          "DayNote:天一"=>"丑寅",
          "DayNote:沐浴"=>"沐浴",
          "DayNote:大小歳"=>"大歳位",
          "DayNote:天恩"=>"天恩",
          "DayNote:重"=>"重",
          "DayNote:大明"=>"大明",
          "DayNote:一粒万倍"=>"一粒万倍",
          "DayNote:三寶吉"=>"三吉",
          "DayNote:神吉"=>"神吉",
          "DayNote:小字注"=>"裁衣市買納財塞穴吉"},
         {"rdf:type"=>{"@id"=>"http://hosi.org/ts/When/TM/CalDate"},
          "@id"=>"http://hosi.org/tp/明治05(1872)-12-02",
          "ts:sdn"=>2405159,
          "ts:frame"=>{"@id"=>"http://hosi.org/When/CalendarTypes/Japanese"},
          "ts:calendarEra"=>
           {"@id"=>"http://hosi.org/When/TM/CalendarEra/Japanese::明治"},
          "ts:coordinate"=>"2",
          "ts:ruler"=>
           {"@id"=>"http://hosi.org/When/TM/CalendarEra/Japanese::明治::明治天皇"},
          "@reverse"=>{"rdfs:member"=>{"@id"=>"http://hosi.org/tp/明治05(1872)-12-"}},
          "DayNote:干支"=>{"@id"=>"Stem-Branch:壬子"},
          "DayNote:納音"=>"木",
          "DayNote:十二直"=>"建",
          "DayNote:七曜"=>{"@id"=>"Week:Tuesday"},
          "DayNote:廿八宿"=>{"@id"=>"LunarMansion:翼宿"},
          "DayNote:七十二候"=>"雪下出麦",
          "DayNote:大將軍"=>"遊北",
          "DayNote:天一"=>"丑寅",
          "DayNote:六蛇"=>"六蛇",
          "DayNote:凶会"=>"陰陽倶錯",
          "DayNote:厭"=>"厭",
          "DayNote:八專"=>"八專始",
          "DayNote:一粒万倍"=>"一粒万倍",
          "DayNote:小字注"=>"不為誓願不動財"}]},
      'SE1936-07%3C10-' => {"@context"=>
        {"xsd"=>"http://www.w3.org/2001/XMLSchema",
         "rdf"=>"http://www.w3.org/1999/02/22-rdf-syntax-ns#",
         "rdfs"=>"http://www.w3.org/2000/01/rdf-schema#",
         "owl"=>"http://www.w3.org/2002/07/owl#",
         "dc"=>"http://purl.org/dc/elements/1.1/",
         "dcq"=>"http://purl.org/dc/terms/",
         "dct"=>"http://purl.org/dc/dcmitype/",
         "ts"=>"http://hosi.org/ts#",
         "day"=>"http://hosi.org/When/CalendarNote/Balinese/Notes::day::",
         "Dwiwara"=>
          "http://hosi.org/When/CalendarNote/Balinese/Notes::day::Dwiwara::",
         "Triwara"=>
          "http://hosi.org/When/CalendarNote/Balinese/Notes::day::Triwara::",
         "Tjaturwara"=>
          "http://hosi.org/When/CalendarNote/Balinese/Notes::day::Tjaturwara::",
         "Pantjawara"=>
          "http://hosi.org/When/CalendarNote/Balinese/Notes::day::Pantjawara::",
         "Perinkelan"=>
          "http://hosi.org/When/CalendarNote/Balinese/Notes::day::Perinkelan::",
         "Sadwara"=>
          "http://hosi.org/When/CalendarNote/Balinese/Notes::day::Sadwara::",
         "Septawara"=>
          "http://hosi.org/When/CalendarNote/Balinese/Notes::day::Septawara::",
         "Astawara"=>
          "http://hosi.org/When/CalendarNote/Balinese/Notes::day::Astawara::",
         "Sangawara"=>
          "http://hosi.org/When/CalendarNote/Balinese/Notes::day::Sangawara::",
         "Dasawara"=>
          "http://hosi.org/When/CalendarNote/Balinese/Notes::day::Dasawara::",
         "Ingkel"=>"http://hosi.org/When/CalendarNote/Balinese/Notes::day::Ingkel::",
         "Watek"=>"http://hosi.org/When/CalendarNote/Balinese/Notes::day::Watek::",
         "Lintang"=>
          "http://hosi.org/When/CalendarNote/Balinese/Notes::day::Lintang::",
         "Wuku"=>"http://hosi.org/When/CalendarNote/Balinese/Notes::day::Wuku::"},
       "@graph"=>
        [{"rdf:type"=>{"@id"=>"http://hosi.org/ts/When/TM/CalDate"},
          "@id"=>"http://hosi.org/tp/SE1936(2014)-07%3C10-",
          "ts:sdn"=>2457038,
          "ts:frame"=>
           {"@id"=>"http://hosi.org/When/CalendarTypes/BalineseLuniSolar2003"},
          "ts:calendarEra"=>
           {"@id"=>"http://hosi.org/When/TM/CalendarEra/BalineseLuniSolar::SE"},
          "ts:coordinate"=>"10",
          "@reverse"=>
           {"rdfs:member"=>{"@id"=>"http://hosi.org/tp/SE1936(2014)-07%3C"}},
          "day:Hari"=>"Pare",
          "day:Dwiwara"=>{"@id"=>"Dwiwara:Menga"},
          "day:Triwara"=>{"@id"=>"Triwara:Pasah"},
          "day:Tjaturwara"=>{"@id"=>"Tjaturwara:Sri"},
          "day:Pantjawara"=>{"@id"=>"Pantjawara:Wage"},
          "day:Perinkelan"=>{"@id"=>"Perinkelan:Tungleh"},
          "day:Sadwara"=>{"@id"=>"Sadwara:Mina"},
          "day:Septawara"=>{"@id"=>"Septawara:Wraspati"},
          "day:Astawara"=>{"@id"=>"Astawara:Ludra"},
          "day:Sangawara"=>{"@id"=>"Sangawara:Dangu"},
          "day:Dasawara"=>{"@id"=>"Dasawara:Suka"},
          "day:Ingkel"=>{"@id"=>"Ingkel:Mina"},
          "day:Watek"=>{"@id"=>"Watek:Watu-Lintah"},
          "day:Lintang"=>{"@id"=>"Lintang:Kumba"},
          "day:Wuku"=>{"@id"=>"Wuku:Pujut"}}]}
    }

    def test__rdf_graph
      Dates.each_pair do |key, value|
        date = When.when?(key)
        hash = date.rdf_graph({'@context'=>{}, :context=>true,
                               :include=>true, :included=>true,
                               :note=>{:precision=>When::MINUTE}})
        assert_equal(value, hash)
      end
    end
  end
end
