# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2014 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module Test::Coordinates

  #
  # 剰余類
  #
  class Residue < Test::Unit::TestCase

    def test__intersection
      r1 = When::Coordinates::Residue.new(3,10)
      r2 = When::Coordinates::Residue.new(5,12)
      r3 = When::Coordinates::Residue.new(6,12)
      r  = r1 & r2
      assert_equal([53,60], [r.remainder, r.divisor])
      assert_nil(r1 & r3)

      r4 = When::Coordinates::Residue.new(2,7)
      date1 = When.when?(2440587.5)
      assert_equal(2440593.5, (date1 & r4).to_f)

      r5 = When::Coordinates::Residue.new(3,7)
      date2 = When.when?("19820606^^Julian")
      assert_equal("1982-06-11", (date2 & r5).to_s)
      assert_equal("1982-06-11", (r5 & date2).to_s)

      assert_equal("1982-06-10T00:00:00.00Z", (r5 & Time.utc(1982,6,6)).to_s)
      if ::Object.const_defined?(:Date) && Date.respond_to?(:civil)
        assert_equal("1982-06-24", (r5 & Date.new(1982,6,6,Date::JULIAN)).to_s)
      end

      date3 = When.when?("19820606T021540+0900^^Julian")
      [[-5, "1979-06-06T02:15:40+09:00"],
       [-4, "1980-06-06T02:15:40+09:00"],
       [-3, "1981-06-06T02:15:40+09:00"],
       [-2, "1922-06-06T02:15:40+09:00"],
       [-1, "1923-06-06T02:15:40+09:00"],
       [ 0, "1984-06-06T02:15:40+09:00"],
       [ 1, "1985-06-06T02:15:40+09:00"],
       [ 2, "1986-06-06T02:15:40+09:00"],
       [ 3, "1987-06-06T02:15:40+09:00"],
       [ 4, "1988-06-06T02:15:40+09:00"],
       [ 5, "1989-06-06T02:15:40+09:00"]].each do |sample|
        r6 = When::Coordinates::Residue.new(sample[0], 60, {'year'=>4})
        assert_equal(sample[1], (date3 & r6).to_s)
        assert_equal(sample[1], (r6 & date3).to_s)
      end

      kanshi = When.Resource("_co:Residue?divisor=60&year=4&day=11")
      date   = When.when?("19820606T021540+0900^^Julian")
      assert_equal("1982-07-27T02:15:40+09:00", (date & kanshi.to('day')).to_s)
      assert_equal("1985-06-06T02:15:40+09:00", (date & kanshi.to('year')[1]).to_s)

      week = When.Resource("_co:Residue?divisor=7")
      [[0, "1982-06-08T02:15:40+09:00"],
       [1, "1982-06-09T02:15:40+09:00"],
       [2, "1982-06-10T02:15:40+09:00"],
       [3, "1982-06-11T02:15:40+09:00"],
       [4, "1982-06-12T02:15:40+09:00"],
       [5, "1982-06-06T02:15:40+09:00"],
       [6, "1982-06-07T02:15:40+09:00"],
       [7, "1982-06-15T02:15:40+09:00"]].each do |sample|
        assert_equal(sample[1], (date & week[sample[0]]).to_s)
      end
    end

    class BestRationalApproximations < Test::Unit::TestCase
      def test__continued_fraction
        it = When.Resource("_co:Residue?remainder=365.2421875&divisor=1").each
        [[365, 1], [1461, 4], [10592, 29], [12053, 33], [46751, 128]].each do |ratio|
          assert_equal(ratio, it.next[0..1])
        end
      end
    end

    class Enumerator < Test::Unit::TestCase
      def test_nothing
      end
    end
  end

  # 暦座標番号
  class Index < Test::Unit::TestCase
    def test__trunk
      month = When::Coordinates::Index.new({:label=>'month', :unit=>12, :base=>1,
        :trunk => %w(January February March April May June July August September October November December).map {|v| When.m17n(v)}})
      assert_equal({
         1=>"January",
         2=>"February",
         3=>"March",
         4=>"April",
         5=>"May",
         6=>"June",
         7=>"July",
         8=>"August",
         9=>"September",
        10=>"October",
        11=>"November",
        12=>"December"
      }, month.trunk)
    end
  end

  # 暦座標要素
  class Pair < Test::Unit::TestCase
    def test_nothing
    end
  end

  class Temporal < Test::Unit::TestCase
    def test__validate

      midJulian = When.Resource("_c:Julian?border=[0,3,25]")
    # assert_equal([0, 3, 25], midJulian.border)

      mDate = When.when?('20100324', {:frame=>midJulian})
      assert_equal("2009=03-24", mDate.to_s)

      assert_equal("2010-05-11", When.when?('2010-05-11').to_s)
      assert_equal("2010=05-11", When.when?('2010=05-11').to_s)

      date1 =When.when?("M32.01.01")
      date2 =When.when?("M34.05.05")
      assert_equal("M34(1901).05.05", date2.to_s)
      assert_equal("M35(1902).05.05", (date2+When::Duration('P1Y')).to_s)
      assert_equal("S06(1931).05.05", (date2+When::Duration('P30Y')).to_s)

      assert_equal(2426467, (date2+When::Duration('P30Y')).to_i)
      sample = [
        ["ModernJapanese64(1931).05.05", false],
        ["S06(1931).05.05", true]
      ]
      ((date2+When::Duration('P30Y')).scan(When.Resource('ModernJapanese', '_e:'))).each do |d|
        assert_equal(sample.shift, [d.to_s, d.leaf?])
      end

      sample = [
        ["S06(1931).05.05", true]
      ]
      ((date2+When::Duration('P30Y'))^When.Resource('ModernJapanese', '_e:')).each do |d|
        assert_equal(sample.shift, [d.to_s, d.leaf?])
      end

      sample =[
        ["明治", "http://ja.wikipedia.org/wiki/%E6%98%8E%E6%B2%BB"],
        ["Meiji", "http://en.wikipedia.org/wiki/Meiji_period"],
        ["M", "http://ja.wikipedia.org/wiki/%E6%98%8E%E6%B2%BB"],
        ["大正", "http://ja.wikipedia.org/wiki/%E5%A4%A7%E6%AD%A3"],
        ["Taishō", "http://en.wikipedia.org/wiki/Taish%C5%8D_period"],
        ["T", "http://ja.wikipedia.org/wiki/%E5%A4%A7%E6%AD%A3"],
        ["昭和", "http://ja.wikipedia.org/wiki/%E6%98%AD%E5%92%8C"],
        ["Shōwa", "http://en.wikipedia.org/wiki/Sh%C5%8Dwa_period"],
        ["S", "http://ja.wikipedia.org/wiki/%E6%98%AD%E5%92%8C"],
        ["平成", "http://ja.wikipedia.org/wiki/%E5%B9%B3%E6%88%90"],
        ["Heisei", "http://en.wikipedia.org/wiki/Heisei_period"],
        ["H", "http://ja.wikipedia.org/wiki/%E5%B9%B3%E6%88%90"]
      ]
      ['明治', '大正', '昭和', '平成'].each do |nengo|
         era = When::era(nengo)
         ['ja', 'en', 'alias'].each do |lang|
           assert_equal(sample.shift, [era[0].label.translate(lang), era[0].label.reference(lang)])
         end
      end

      sample =[
        ["明治天皇", "http://ja.wikipedia.org/wiki/%E6%98%8E%E6%B2%BB%E5%A4%A9%E7%9A%87"],
        ["Emperor_Meiji", "http://en.wikipedia.org/wiki/Emperor_Meiji"],
        ["大正天皇", "http://ja.wikipedia.org/wiki/%E5%A4%A7%E6%AD%A3%E5%A4%A9%E7%9A%87"],
        ["Emperor_Taishō", "http://en.wikipedia.org/wiki/Emperor_Taish%C5%8D"],
        ["昭和天皇", "http://ja.wikipedia.org/wiki/%E6%98%AD%E5%92%8C%E5%A4%A9%E7%9A%87"],
        ["Emperor_Shōwa", "http://en.wikipedia.org/wiki/Emperor_Sh%C5%8Dwa"],
        ["今上天皇", "http://ja.wikipedia.org/wiki/%E6%98%8E%E4%BB%81"],
        ["Emperor_Kinjō", "http://en.wikipedia.org/wiki/Akihito"]
      ]
      ['明治', '大正', '昭和', '平成'].each do |nengo|
        name = When.when?(nengo + '06.01.01').query['name']
         ['ja', 'en'].each do |lang|
           assert_equal(sample.shift, [name.translate(lang), name.reference(lang)])
         end
      end

      assert_equal("昭和02(1927).03.01", When.when?('大正16.2.29').to_s)
      assert_equal({"name"=>"大正天皇", "period"=>nil, "area"=>"日本"}, When::era('大正')[0].options)
    end
  end

  #
  # 空間位置
  #
  class Spatial < Test::Unit::TestCase
    IndianCities = [
      ["CentralIndia",
       "インド中部",
       "http://en.wikipedia.org/wiki/CentralIndia",
       23.15 + 1.0/30,
       82.5],
      ["NorthIndia",
       "インド北部",
       "http://en.wikipedia.org/wiki/NorthIndia",
       29.0,
       82.5],
      ["Agra",
       "アーグラ",
       "http://en.wikipedia.org/wiki/Agra",
       27.2,
       78.0],
      ["Ahmedabad",
       "アフマダーバード",
       "http://en.wikipedia.org/wiki/Ahmedabad",
       23.0,
       72.6],
      ["Ajmer",
       "アジメール",
       "http://en.wikipedia.org/wiki/Ajmer",
       26.5,
       74.6],
      ["Aligarh",
       "アリーガル",
       "http://en.wikipedia.org/wiki/Aligarh",
       27.9,
       78.1],
      ["Amritsar",
       "アムリトサル",
       "http://en.wikipedia.org/wiki/Amritsar",
       31.6,
       74.9],
      ["Bangalore",
       "バンガロール",
       "http://en.wikipedia.org/wiki/Bangalore",
       13.0,
       77.6],
      ["Bhuvaneswar",
       "ブヴァネーシュヴァル",
       "http://en.wikipedia.org/wiki/Bhuvaneswar",
       20.2,
       85.8],
      ["Chennai",
       "チェンナイ",
       "http://en.wikipedia.org/wiki/Chennai",
       13.1,
       80.3],
      ["Colombo",
       "コロンボ",
       "http://en.wikipedia.org/wiki/Colombo",
       6.9,
       79.9],
      ["Dacca",
       "ダッカ",
       "http://en.wikipedia.org/wiki/Dacca",
       23.7,
       90.4],
      ["Delhi",
       "デリー",
       "http://en.wikipedia.org/wiki/Delhi",
       28.6,
       77.2],
      ["Hyderabad",
       "ハイデラバード",
       "http://en.wikipedia.org/wiki/Hyderabad",
       17.4,
       78.5],
      ["Jaipur",
       "ジャイプル",
       "http://en.wikipedia.org/wiki/Jaipur",
       26.9,
       75.8],
      ["Kathmandu",
       "カトマンズ",
       "http://en.wikipedia.org/wiki/Kathmandu",
       27.7,
       85.2],
      ["Kochi",
       "コーチ",
       "http://en.wikipedia.org/wiki/Kochi",
       10.0,
       76.2],
      ["Kolkata",
       "コルカタ",
       "http://en.wikipedia.org/wiki/Kolkata",
       22.6,
       88.4],
      ["Lahor",
       "ラホール",
       "http://en.wikipedia.org/wiki/Lahor",
       31.6,
       74.3],
      ["Mathura",
       "マトゥラー",
       "http://en.wikipedia.org/wiki/Mathura",
       27.5,
       77.7],
      ["Mumbai",
       "ムンバイ",
       "http://en.wikipedia.org/wiki/Mumbai",
       19.0,
       72.8],
      ["Mysore",
       "マイソール",
       "http://en.wikipedia.org/wiki/Mysore",
       12.3,
       76.6],
      ["Patna",
       "パトナ",
       "http://en.wikipedia.org/wiki/Patna",
       25.6,
       85.1],
      ["Pune",
       "プネー",
       "http://en.wikipedia.org/wiki/Pune",
       18.5,
       73.9],
      ["Srinagar",
       "シュリーナガル",
       "http://en.wikipedia.org/wiki/Srinagar",
       34.1,
       74.8],
      ["Thiruvananthapuram",
       "ティルヴァナンタプラム",
       "http://en.wikipedia.org/wiki/Thiruvananthapuram",
       8.5,
       77.0],
      ["Varanasi",
       "ワーラーナシー",
       "http://en.wikipedia.org/wiki/Varanasi",
       25.3,
       83.0],
      ["Ujjain",
       "ウッジャイン",
       "http://en.wikipedia.org/wiki/Ujjain",
       23.2,
       75.8]
    ]

    def test__inner_representation
      location = When.Resource("examples/sample.xml?lat=35&long=135")
      assert_equal( 7875.0, location.lat)
      assert_equal(30375.0, location.long)
      assert_equal( '35.0000N', location.lat_s)
      assert_equal('135.0000E', location.long_s)
      if Object.const_defined?(:JSON)
        location = When.Resource("examples/sample.json?lat=40")
        assert_equal( 9000.0, location.lat)
        assert_equal(31433.32625, location.long)
        assert_equal( '40.0000N', location.lat_s)
        assert_equal('139.421322E',location.long_s)
      else
        puts "\nTests for JSON have been skipped at line #{__LINE__} of #{__FILE__.split(/\//)[-1]}.\n"
      end
    end

    def test__reference
      location = When.Resource("_co:Spatial?label=Kyoto&long=136&lat=30&ref=(http://)")
      assert_equal("http://", location.ref)
    end

    def test__surface_radius
      location = When.Resource("_co:Spatial?label=Kyoto&long=136&lat=30&ref=(http://)")
      assert_equal(6378.14, location.surface_radius)
    end

    def test__spatial_m17n
      ['_co:IndianCities', 'examples/Spatial.m17n'].each do |iri|
        samples = IndianCities.dup
        assert_equal(samples.size, When.Resource(iri).child.size)
        When.Resource(iri).child.each do |obj|
          name   = obj.label
          sample = samples.shift.dup
          sample << iri.sub(/_co:/, 'http://hosi.org/When/Coordinates/') + '::' + sample[0]
          assert_equal(sample,
            [name.label,
             name.translate('ja'),
             name.reference('en'),
             obj.lat  / When::Coordinates::Spatial::DEGREE,
             obj.long / When::Coordinates::Spatial::DEGREE,
             obj.iri])
        end
      end
    end

    def test__to_dms
      assert_equal(+135.9, When::Coordinates.to_deg("東経135度54分", 'EW'))
      assert_equal(+135.9, When::Coordinates.to_deg("135度54分E", 'EW'))
      assert_equal(+135.9, When::Coordinates.to_deg("135.5400E", 'EW'))
      assert_equal(+135.9, When::Coordinates.to_deg("E135.5400", 'EW'))
      assert_equal("135.5400E", When::Coordinates.to_dms(+135.9, 'EW'))
      assert_equal( "35.3936N", When::Coordinates.to_dms(+35.66, 'NS'))
    end
  end
end

