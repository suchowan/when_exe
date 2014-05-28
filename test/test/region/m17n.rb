# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2014 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module Test

  class M17n < Test::Unit::TestCase

    First = [
      ["CalendarTerms", "CalendarTerms", nil],
      ["Month",      "月", "http://ja.wikipedia.org/wiki/%E6%9C%88_(%E6%9A%A6)"],
      ["Month",      "月", "http://ja.wikipedia.org/wiki/%E6%9C%88_(%E6%9A%A6)"],
      ["January",   "1月", "http://ja.wikipedia.org/wiki/1%E6%9C%88"]
    ]

    Second = [
      ["January",   "1月", "http://ja.wikipedia.org/wiki/1%E6%9C%88" ],
      ["February",  "2月", "http://ja.wikipedia.org/wiki/2%E6%9C%88" ],
      ["March",     "3月", "http://ja.wikipedia.org/wiki/3%E6%9C%88" ],
      ["April",     "4月", "http://ja.wikipedia.org/wiki/4%E6%9C%88" ],
      ["May",       "5月", "http://ja.wikipedia.org/wiki/5%E6%9C%88" ],
      ["June",      "6月", "http://ja.wikipedia.org/wiki/6%E6%9C%88" ],
      ["July",      "7月", "http://ja.wikipedia.org/wiki/7%E6%9C%88" ],
      ["August",    "8月", "http://ja.wikipedia.org/wiki/8%E6%9C%88" ],
      ["September", "9月", "http://ja.wikipedia.org/wiki/9%E6%9C%88" ],
      ["October",  "10月", "http://ja.wikipedia.org/wiki/10%E6%9C%88"],
      ["November", "11月", "http://ja.wikipedia.org/wiki/11%E6%9C%88"],
      ["December", "12月", "http://ja.wikipedia.org/wiki/12%E6%9C%88"]
    ]

    def test__m17n_1
      ['examples/Terms.m17n', '_m:CalendarTerms'].each do |head|
        When.Resource(head)

        # pp When::Parts::Resource[head].child.map {|v| v.label}
        assert_equal('Month', When::Parts::Resource[head].child[1].label.to_s)

        assert_equal(First, 
          [head,
           head + '::Month',
           head + '::Month::Month',
           head + '::Month::January'].inject([]) { |first, iri|
             obj = When::Parts::Resource[iri]
             first << [obj.label, obj.translate('ja'), obj.reference('ja')]
           }
        )

        assert_equal(Second, 
          When::Parts::Resource[head + '::Month'].child.inject([]) { |second, obj|
            second << [obj.label, obj.translate('ja'), obj.reference('ja')]
          }
        )
      end
    end

    def test__m17n_2
      march = When.m17n(['en:March=en_ns:', 'ja:3月=ja_ns:'],
                   {'en_ns'=>'http://en.wikipedia.org/wiki/',
                    'ja_ns'=>'http://ja.wikipedia.org/wiki/'})

      [
        ['ja', ["3月", "3月", "http://ja.wikipedia.org/wiki/3%E6%9C%88"]],
        ['en', ["March", "March", "http://en.wikipedia.org/wiki/March" ]]
      ].each do |sample|
        assert_equal(sample[1], [march.translate(sample[0]), march.translate(sample[0]), march.reference(sample[0])])
      end

      date = When.when?('CE2010.4.12')
      era  = When.era('CE')[0]
    # assert_equal(Second.map {|v| v[0]}, era.m17n('[::_m:CalendarTerms::Month::*]').map {|v| v.to_s})
      assert_equal(Second.map {|v| v[0]}, When.m17n('[::_m:CalendarTerms::Month::*]').map {|v| v.to_s})
      assert_equal(["Accession", true, "http://hosi.org/When/BasicTypes/M17n/EpochEvents::Accession"],
        [era['::_m:EpochEvents::Accession'].to_s,
         era['::_m:EpochEvents::Accession'].registered?,
         era['::_m:EpochEvents::Accession'].iri])

      assert_equal(era['::_m:EpochEvents::*'].map {|v| v.to_s},
        ["Accession", "FelicitousEvent", "NaturalDisaster", "InauspiciousYear", "Foundation", "CalendarReform"])

      term = []
      term << When.m17n('[日本語, English]', nil, ', en').translate('ja')
      term << When.m17n('[日本語, English]', nil, ['ja', 'en']).translate('ja')
      term << When.m17n('[ja:日本語, en:English]').translate('ja')
      term << When.m17n(['ja:日本語', 'en:English']).translate('ja')
      term.each do |result|
        assert_equal("日本語", result)
      end

      date = When.when?('明治6.10.1')
      era  = When.era('明治')[0]
      event = era.reference_event
      assert_equal("代始", event.translate('ja'))
      assert_equal(["Accession", true, "http://hosi.org/When/BasicTypes/M17n/EpochEvents::Accession"],
        [era['::_m:EpochEvents::Accession'].to_s,
         era['::_m:EpochEvents::Accession'].registered?,
         era['::_m:EpochEvents::Accession'].iri])
    end

    def test__m17n_3
      january = When.Resource('_m:CalendarTerms::Month::January')
      [['en', 'January'], ['ja', '1月'], ['fr', 'janvier']].each do |sample|
        assert_equal(sample[1], january.translate(sample[0]))
      end
    end

    def test__m17n_4
      january = When.Resource('_m:CalendarTerms::Month::January')
      [['en', 'January'], ['ja', '1月'], ['fr', 'janvier']].each do |sample|
        assert_equal(sample[1], january.translate(sample[0]))
      end
    end

    def test__m17n_5
      month = When.Resource('_m:CalendarTerms::Month')
      [['en', 'Month'], ['ja', '月'], ['fr', 'Mois']].each do |sample|
        assert_equal(sample[1], month.translate(sample[0]))
      end
    end

    def test__to_h
      [
       ['HLC0.0.0.0.0',
         {:calendar=>["_e:LongCount::PHLC",-13], :sdn=>584283, :cal_date=>[13, 0, 0, 0, 0],
          :notes=>[[{:note=>"Trecena", :value=>"Trecena(4/13)"},
                    {:note=>"Tzolk'in", :value=>"Ajaw(19/20)"},
                    {:note=>"Lords_of_the_Night", :value=>"G9(0/9)"},
                    {:note=>"Haab'", :value=>"8Kumk'u/365"}]]}],

       ['1985-1-1',
         {:calendar=>["_c:Gregorian"], :sdn=>2446067, :cal_date=>[1985, 1, 1],
          :notes=>[[{:note=>"Month", :value=>"January"}],[{:note=>"Week", :value=>"Tuesday(1)"}]]}],

       ['明治7.5.7',
         {:calendar=>["_e:Japanese::明治",1867], :sdn=>2405651, :cal_date=>[7, 5, 7],
          :notes=>[[{:note=>"干支",  :value=>"甲戌(10)", :position=>"共通"}],
                   [{:note=>"月名",  :value=>"May",      :position=>"月建"}],
                   [{:note=>"七曜",  :value=>"Thursday(3)", :position=>"共通"},
                    {:note=>"干支",  :value=>"甲子(00)", :position=>"共通"},
                    {:note=>"六曜",  :value=>"赤口",     :position=>"民間"}]]}],

       ['明治17.5.7',
         {:calendar=>["_e:Japanese::明治",1867], :sdn=>2409304, :cal_date=>[17, 5, 7],
          :notes=>[[{:note=>"干支",  :value=>"甲申(20)", :position=>"共通"}],
                   [{:note=>"月名",  :value=>"May",      :position=>"月建"}],
                   [{:note=>"七曜",  :value=>"Wednesday(2)", :position=>"共通"},
                    {:note=>"干支",  :value=>"丁巳(53)", :position=>"共通"},
                    {:note=>"六曜",  :value=>"先負",     :position=>"民間"}]]}],

       ['CE-2010.06.08T12:00:00+09:00',
         {:calendar=>["_e:Common::BCE", 1, true], :sdn=>987064, :cal_date=>[-2011, 6, 8],
          :notes=>[[{:note=>"Month", :value=>"June"}],[]],
          :clk_time=>[987064, 12, 0, 0]}],

       [11,
         {:calendar=>["_tm:JulianDate"], :sdn=>11,
          :notes=>[[{:note=>"Week",  :value=>"Friday(4)"},
                    {:note=>"干支",  :value=>"甲子(00)"}]]}],

       [11.0,
         {:calendar=>["_tm:JulianDate"], :sdn=>11,
          :notes=>[[{:note=>"Week",  :value=>"Friday(4)"},
                    {:note=>"干支",  :value=>"甲子(00)"}]],
          :clk_time=>[11, 12, 0, 0]}]

      ].each do |sample|
        date, verify = sample
        list = When.when?(date).to_h({:method=>:to_m17n, :prefix=>true})
        [:calendar, :cal_date, :sdn, :clk_time].each do |key|
          assert_equal(verify[key], list[key])
        end
        verify[:notes].each_index do |i|
          verify[:notes][i].each_index do |k|
            assert_equal(verify[:notes][i][k], list[:notes][i][k])
          end
        end
      end
    end
  end
end
