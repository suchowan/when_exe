# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2020 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module MiniTest::Ephemeris

  class Ephemeris < MiniTest::TestCase
    def test_nothing
    end
  end

  class CelestialObject < MiniTest::TestCase
    def test_nothing
    end
  end

  class Star < MiniTest::TestCase

    def test_nothing
    end

    # 恒星
    class Fixed < MiniTest::TestCase
      def test__access_hr
        polaris = When::Resource('_sc:HR0424')
        assert_equal("Alp UMi", polaris.bayer_name)
      end
    end

    # 春分点
    class Vernal < MiniTest::TestCase
      def test_nothing
      end
    end

    # 北極
    class Pole < MiniTest::TestCase
      def test_nothing
      end
    end
  end

  class Planet < MiniTest::TestCase
    def test_nothing
    end
  end

  class Coords < MiniTest::TestCase
    def test_nothing
    end
  end

  class Formula < MiniTest::TestCase
    def test__sunrise

      assert_raises(NoMethodError) { When.when?('2012-11-15').sunrise }

      assert_nil(When.when?('2013-06-21T+09:00', :long=>135, :lat=>70).sunrise)

      if Object.const_defined?(:TZInfo)
        assert_equal(0, /2012-11-15T06:16/ =~ When.when?('2012-11-15', :tz=>'Asia/Tokyo').sunrise.to_s)
        assert_equal(0, /2012-11-15T06:16/ =~ When.when?('2012-11-15', :tz=>'Asia/Tokyo', :location=>'_l:long=139.7414&lat=35.6581').sunrise.to_s)
      else
        puts
        puts "Tests for TZInfo have been skipped at line #{__LINE__} of #{__FILE__.split(/\//)[-1]}."
      end
      assert_equal(0, /2012-11-15T06:16/ =~ When.when?('2012-11-15T+09:00', :long=>139.7414, :lat=>35.6581).sunrise.to_s)
      assert_equal(0, /2012-11-14T21:16/ =~ When.when?('2012-11-15', :long=>139.7414, :lat=>35.6581).sunrise.to_s)

      today = '2014-3-4'

      location = When.Location('long=139.413012E&lat=35.412222N')
      assert_equal(0, /2014-03-03T21:07/ =~ When.when?(today, {:location=>location}).sunrise.to_s)

      When::Coordinates::Spatial.default_location = location
      assert_equal(0, /2014-03-03T21:07/ =~ When.when?(today).sunrise.to_s)

      When::TM::Clock.local_time = '+09:00'
      assert_equal(0, /2014-03-04T06:07/ =~ When.when?(today).sunrise.to_s)
    end

    def test__lunisolar_location
      formula1 = When.Resource('_ep:Formula?formula=1L')
      formula2 = When.Resource('_ep:Formula?formula=12S')
      date = When.when?('2014-08-01', :clock=>'+09:00')
      assert_equal('2014-07-27T07:41+09:00', formula1.nearest_past(date).floor(When::MINUTE).to_s)
      assert_equal('2014-07-23T06:41+09:00', formula2.nearest_past(date).floor(When::MINUTE).to_s)
      assert_equal('2014-07-07T13:15+09:00', formula2.nearest_past(date, 0.5).floor(When::MINUTE).to_s)
    end
  end

  if Object.const_defined?(:TZInfo)
    class Note < MiniTest::TestCase
      def test__tide

        sample = [%w(2013-10-02T02:58+09:00 _n:Ephemeris/Notes::day::Tide::Low_Tide),
                  %w(2013-10-02T09:09+09:00 _n:Ephemeris/Notes::day::Tide::High_Tide),
                  %w(2013-10-02T15:20+09:00 _n:Ephemeris/Notes::day::Tide::Low_Tide),
                  %w(2013-10-02T21:32+09:00 _n:Ephemeris/Notes::day::Tide::High_Tide)]

        note = When.CalendarNote('Ephemeris?interval=0.0')
        date = When.when?('2013-10-02', :tz=>'Asia/Tokyo')
        note.tide(date).each do |d|
          assert_equal(sample.shift, [d.floor(When::MINUTE).to_s, d.events[0].iri(true)])
        end
      end
    end
  else
    puts "Tests for TZInfo have been skipped at line #{__LINE__} of #{__FILE__.split(/\//)[-1]}."
  end
end
