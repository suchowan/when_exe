# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2014 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module Test

  class Residue < Test::Unit::TestCase
    def test__enumerator0
      list = []
      res = When::Coordinates::Residue.new(365.2422, 29.530589)
      res.each({:error=>1E-10}) do |v|
        list << v[0..1]
      end
      assert_equal(
        [[12, 1],
         [25, 2],
         [37, 3],
         [99, 8],
         [136, 11],
         [235, 19],
         [4131, 334],
         [8497, 687],
         [12628, 1021],
         [33753, 2729],
         [46381, 3750],
         [219277, 17729],
         [923489, 74666]], list)
    end

    def test__kanshi
      ['_co:CommonResidue', 'examples/Residue.m17n'].each do |iri|
        assert_equal("Week", When.Resource(iri + '::Week').label)
        assert_equal("Monday", When.Resource(iri + '::Week::Monday').label)
        assert_equal(7, When.Resource(iri + '::Week::Friday').divisor)
        assert_equal(6, When.Resource(iri + '::Week::Sunday').remainder)
        assert_equal(7, When.Resource(iri + '::Week::Sunday').divisor)
        assert_equal("日曜日", When.Resource(iri + '::Week::Sunday::Sunday').translate('ja'))

        sample = [
          ["Monday",    "月曜日", "http://en.wikipedia.org/wiki/Monday"],
          ["Tuesday",   "火曜日", "http://en.wikipedia.org/wiki/Tuesday"],
          ["Wednesday", "水曜日", "http://en.wikipedia.org/wiki/Wednesday"],
          ["Thursday",  "木曜日", "http://en.wikipedia.org/wiki/Thursday"],
          ["Friday",    "金曜日", "http://en.wikipedia.org/wiki/Friday"],
          ["Saturday",  "土曜日", "http://en.wikipedia.org/wiki/Saturday"],
          ["Sunday",    "日曜日", "http://en.wikipedia.org/wiki/Sunday"]
        ]
        assert_equal(7, When::Parts::Resource[iri + '::Week'].child.size)
        When::Parts::Resource[iri + '::Week'].child.each do |obj|
          name = obj.label
          assert_equal(sample.shift, [name.label, name.translate('ja'), name.reference('en')])
        end

        stem        = When.Resource(iri + '::干')
        kinoto      = When.Resource(iri + '::干::乙')
        ushi        = When.Resource(iri + '::支::丑')
        kinoto_ushi = When.Resource(iri + '::干支::乙丑')

        sample = [
          ["干", 10, 0],
          ["乙", 10, 1],
          ["丑", 12, 1]
        ]
        [stem, kinoto, ushi].each do |v|
          assert_equal(sample.shift, [v.label, v.divisor, v.remainder])
        end

        assert_equal("hinoto", stem[3].label.translate('en'))

        date0 = When.when?('2011-05-16T12:34:56Z')
        date = date0 & (kinoto & ushi)
        assert_equal("2011-07-09T12:34:56Z", date.to_s)

        date = date0 & (kinoto & ushi).to('day')
        assert_equal("2011-07-09T12:34:56Z", date.to_s)

        date = date0 & (kinoto & ushi) / 'day'
        assert_equal("2011-07-09T12:34:56Z", date.to_s)

        date = date0 & (kinoto & ushi).to('year')
        assert_equal("2045-05-16T12:34:56Z", date.to_s)

        date = date0 & kinoto_ushi / 'year'
        assert_equal("2045-05-16T12:34:56Z", date.to_s)
      end
    end

    def test__epoch_in_CE
      cals  = [
        'Gregorian',
        'Coptic?Epoch=284Y',
        'Coptic?Epoch=8Y',
        'IndianNationalSolar',
        'HinduSolar?type=SBV',
        'HinduSolar?type=SBVZ',
        'HinduSolar?type=SBS',
        'HinduSolar?type=SBSZ',
     #  'HinduLuniSolar?type=SBVA',
     #  'HinduLuniSolar?type=SBVZA',
     #  'HinduLuniSolar?type=SBSA',
     #  'HinduLuniSolar?type=SBSZA',
        'SolarHejri',
        'Jewish',
        'ThaiB',
      # 'ThaiC',
        'Tibetan',
      ]
      eto   = When.Resource('_co:CommonResidue::干支').to('year')
      today = When.when?('2012-06-13')
      assert_equal([[28, 246778, 246778]],
        cals.map { |cal|
          date = When.Calendar(cal) ^ today
          [date % eto, (eto & date).to_i/10, (date & eto).to_i/10]
        }.uniq
      )
    end
  end
end

