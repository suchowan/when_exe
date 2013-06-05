# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2012 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module Test

  class Mayan < Test::Unit::TestCase
    def test__mayan_epoch
      [['PHLC13.0.0.0.0', 'PHLC13(0000).00.00.00.00',   584283],
       ['HLC0.0.0.0.1',   'HLC00.00.00.00.01',       584284],
       ['HLC13.0.0.0.0',  'HLC13.00.00.00.00',      2456283],
       ['HLC13.0.0.0.1',  'NLC00(0013).00.00.00.01',  2456284]].each do |sample|
        date = When.when?(sample.shift)
        assert_equal(sample, [date.to_s, date.to_i])
      end
    end

    def test__mayan_period
      date   = When.when?('HLC0.0.0.0.1')
      period = When.Duration('P2X1X3Y4M5D')
      assert_equal('HLC02.01.03.04.06', (date + period).to_s)
    end

    def test__haab
      haab = When.Resource("_co:Mayan::Haab'")
      assert_equal("ハアブ", haab.label.translate('ja'))
      assert_equal("http://en.wikipedia.org/wiki/Haab'", haab.label.reference)
      pop = When.Resource("_co:Mayan::Haab'::Pop")
      assert_equal("Pop", pop.label.translate('en'))
      assert_equal("http://en.wikipedia.org/wiki/File:Maya-Pop.jpg", pop.label.reference)
      date0 = When.when?('2011-05-16T12:34:56Z')
      sample = [
        "2012-04-12T12:34:56Z",
        "2012-04-13T12:34:56Z",
        "2012-04-14T12:34:56Z"
      ]
      [10,11,12].each do |i|
        assert_equal(sample.shift, (date0 & pop[i]).to_s)
      end
      assert_equal(42, When.when?('2011-05-15') % haab)
      h = haab % When.when?('2011-05-15')
      assert_equal(["Sip", 2], [h.label.to_s, h.difference])
    end

    def test__tzolkin
      trecena = When.Resource("_co:Mayan::Trecena")
      assert_equal("トレセナ", trecena.label.translate('ja'))
      assert_equal("http://en.wikipedia.org/wiki/Trecena", trecena.label.reference)
      assert_equal(2, When.when?('2011-05-15') % trecena)


      tzolkin = When.Resource("_co:Mayan::Tzolk'in")
      assert_equal("ツォルキン", tzolkin.label.translate('ja'))
      assert_equal("http://en.wikipedia.org/wiki/Tzolk'in", tzolkin.label.reference)
      ajaw = When.Resource("_co:Mayan::Tzolk'in::Ajaw")
      assert_equal("Ajaw", ajaw.label.translate('en'))
      assert_equal("http://en.wikipedia.org/wiki/File:MAYA-g-log-cal-D20-Ajaw-cdxW.png", ajaw.label.reference('alias'))
      date0 = When.when?('2011-05-16T12:34:56Z')
      sample = [
        "2011-05-21T12:34:56Z",
        "2011-05-21T12:34:56Z",
        "2011-05-21T12:34:56Z"
      ]
      [10,11,12].each do |i|
        assert_equal(sample.shift, (date0 & ajaw).to_s)
      end
      assert_equal(13, When.when?('2011-05-15') % tzolkin)
      assert_equal('Ix', (tzolkin % When.when?('2011-05-15')).label.to_s)
      if ::Object.const_defined?(:Date) && Date.respond_to?(:civil)
        assert_equal('Ix', (tzolkin % Date.new(2011,5,15)).label.to_s)
      end
    end
  end
end
