# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2020 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module MiniTest

  class M17n < MiniTest::TestCase

    First = [
      ["Calendar", "Calendar", nil],
      ["Month",    "月の名前", "https://ja.wikipedia.org/wiki/%E6%9C%88_%28%E6%9A%A6%29"],
      ["Month",    "月の名前", "https://ja.wikipedia.org/wiki/%E6%9C%88_%28%E6%9A%A6%29"],
      ["January",  "1月",      "https://ja.wikipedia.org/wiki/1%E6%9C%88"]
    ]

    Second = [
      ["January",   "1月", "https://ja.wikipedia.org/wiki/1%E6%9C%88" ],
      ["February",  "2月", "https://ja.wikipedia.org/wiki/2%E6%9C%88" ],
      ["March",     "3月", "https://ja.wikipedia.org/wiki/3%E6%9C%88" ],
      ["April",     "4月", "https://ja.wikipedia.org/wiki/4%E6%9C%88" ],
      ["May",       "5月", "https://ja.wikipedia.org/wiki/5%E6%9C%88" ],
      ["June",      "6月", "https://ja.wikipedia.org/wiki/6%E6%9C%88" ],
      ["July",      "7月", "https://ja.wikipedia.org/wiki/7%E6%9C%88" ],
      ["August",    "8月", "https://ja.wikipedia.org/wiki/8%E6%9C%88" ],
      ["September", "9月", "https://ja.wikipedia.org/wiki/9%E6%9C%88" ],
      ["October",  "10月", "https://ja.wikipedia.org/wiki/10%E6%9C%88"],
      ["November", "11月", "https://ja.wikipedia.org/wiki/11%E6%9C%88"],
      ["December", "12月", "https://ja.wikipedia.org/wiki/12%E6%9C%88"]
    ]

    def test__m17n_1
      ['examples/Terms.m17n', '_m:Calendar'].each do |head|
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
                   {'en_ns'=>'https://en.wikipedia.org/wiki/',
                    'ja_ns'=>'https://ja.wikipedia.org/wiki/'})

      [
        ['ja', ["3月", "3月", "https://ja.wikipedia.org/wiki/3%E6%9C%88"]],
        ['en', ["March", "March", "https://en.wikipedia.org/wiki/March" ]]
      ].each do |sample|
        assert_equal(sample[1], [march.translate(sample[0]), march.translate(sample[0]), march.reference(sample[0])])
      end

      date = When.when?('CE2010.4.12')
      era  = When.era('CE')[0]
      assert_raises(NoMethodError) {When.m17n('[::_m:Calendar::Month::*]').map {|v| v.to_s}}
      When.Resource('_m:Calendar::Month::*')
      assert_equal(Second.map {|v| v[0]}, When.m17n('[::_m:Calendar::Month::*]').map {|v| v.to_s})
      assert_equal(["Accession", true, "http://hosi.org/When/BasicTypes/M17n/EpochEvents::Accession"],
        [era['::_m:EpochEvents::Accession'].to_s,
         era['::_m:EpochEvents::Accession'].registered?,
         era['::_m:EpochEvents::Accession'].iri])

      assert_equal(era['::_m:EpochEvents::*'].map {|v| v.to_s},
        ["Accession", "FelicitousEvent", "NaturalDisaster", "InauspiciousYear", "Foundation", "CalendarReform", "CalendarEpoch"])

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
      january = When.Resource('_m:Calendar::Month::January')
      [['en', 'January'], ['ja', '1月'], ['fr', 'janvier']].each do |sample|
        assert_equal(sample[1], january.translate(sample[0]))
      end
    end

    def test__m17n_4
      january = When.Resource('_m:Calendar::Month::January')
      [['en', 'January'], ['ja', '1月'], ['fr', 'janvier']].each do |sample|
        assert_equal(sample[1], january.translate(sample[0]))
      end
    end

    def test__m17n_5
      month = When.Resource('_m:Calendar::Month')
      [['en', 'month name'], ['ja', '月の名前']].each do |sample|
        assert_equal(sample[1], month.translate(sample[0]))
      end
    end

    def test__to_h
      [
       ['HLC0.0.0.0.0',
         {:calendar=>["PHLC",-13], :sdn=>584283, :cal_date=>[13, 0, 0, 0, 0],
          :notes=>[[{:note=>"Trecena", :value=>"Trecena(4/13)"},
                    {:note=>"Tzolk'in", :value=>"Ajaw(19/20)"},
                    {:note=>"Lords_of_the_Night", :value=>"G9(0/9)"},
                    {:note=>"Haab'", :value=>"8Kumk'u/365"}]], :locale=>'en'}],

       ['1985-1-1',
         {:calendar=>["Gregorian"], :sdn=>2446067, :cal_date=>[1985, 1, 1],
          :notes=>[[{:note=>"month name", :value=>"January"}],[{:note=>"Week", :value=>"Tuesday(1)"}]], :locale=>'en'}],

       ['明治7.5.7',
         {:calendar=>["明治",1867], :sdn=>2405651, :cal_date=>[7, 5, 7],
          :notes=>[[{:note=>"干支",  :value=>"甲戌(10)", :position=>"共通"}],
                   [{:note=>"月名",  :value=>"5月",      :position=>"月建"}],
                   [{:note=>"七曜",  :value=>"木曜日(3)", :position=>"共通"},
                    {:note=>"干支",  :value=>"甲子(00)", :position=>"共通"},
                    {:note=>"六曜",  :value=>"赤口",     :position=>"民間"}]], :locale=>'ja'}],

       ['明治17.5.7',
         {:calendar=>["明治",1867], :sdn=>2409304, :cal_date=>[17, 5, 7],
          :notes=>[[{:note=>"干支",  :value=>"甲申(20)", :position=>"共通"}],
                   [{:note=>"月名",  :value=>"5月",      :position=>"月建"}],
                   [{:note=>"七曜",  :value=>"水曜日(2)", :position=>"共通"},
                    {:note=>"干支",  :value=>"丁巳(53)", :position=>"共通"},
                    {:note=>"六曜",  :value=>"先負",     :position=>"民間"}]], :locale=>'ja'}],

       ['CE-2010.06.08T12:00:00+09:00',
         {:calendar=>["BeforeCommonEra", 1, true], :sdn=>987064, :cal_date=>[-2011, 6, 8],
          :notes=>[[{:note=>"month name", :value=>"June"}],[]], :locale=>'en',
          :clk_time=>[987064, 12, 0, 0]}],

       [11,
         {:calendar=>["_tm:JulianDate"], :sdn=>11,
          :notes=>[[{:note=>"週",  :value=>"金曜日(4)"},
                    {:note=>"干支",  :value=>"甲子(00)"}]], :locale=>'ja'}],

       [11.0,
         {:calendar=>["_tm:JulianDate"], :sdn=>11,
          :notes=>[[{:note=>"週",  :value=>"金曜日(4)"},
                    {:note=>"干支",  :value=>"甲子(00)"}]], :locale=>'ja',
          :clk_time=>[11, 12, 0, 0]}]

      ].each do |sample|
        date, verify = sample
        list = When.when?(date).to_h({:method=>:to_m17n, :locale=>verify[:locale], :prefix=>true})
        [:calendar, :cal_date, :sdn, :clk_time].each do |key|
          assert_equal([verify[key]], [list[key]])
        end
        verify[:notes].each_index do |i|
          verify[:notes][i].each_index do |k|
            assert_equal(verify[:notes][i][k], list[:notes][i][k])
          end
        end
      end

      assert_equal({:Frame=>"Gregorian",
                    :Precision=>0,
                    :Sdn=>2456388,
                    :Calendar=>["Gregorian"],
                    :Notes=>[[{:Note=>"month name", :Value=>"April"}],
                             [{:Note=>"Week", :Value=>"Friday(4)"}]],
                    :CalDate=>[2013, 4, 5]},
                    When.when?('2013-4-5').to_h(:method=>:to_m17n, :locale=>'en', :camel=>true))
    end
  end
end
