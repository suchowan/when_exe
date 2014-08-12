# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2014 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module MiniTest

  class Inspect < MiniTest::TestCase

    def test__strftime_1
      ns     = 'ISO, jwiki=http://ja.wikipedia.org/wiki/, ewiki=http://en.wikipedia.org/wiki/'
      locale = '=jwiki:, en=ewiki:'
      term1  = When::BasicTypes::M17n.new('[月曜, Monday]',                      ns, locale)
      term2  = When::BasicTypes::M17n.new('[です, It is]',                       ns, locale)
      form   = When::BasicTypes::M17n.new('[%s%s%2d:, %2$s %1$s%3$2d-]', ns, locale)
      assert_equal(["月曜です 1%", "It is Monday 1%"],
        ['ja_JP', 'en_US'].map {|c| (form % [term1, term2, When::Coordinates::Pair.new(1,-2)]).translate(c)})

      pair11 = When::Coordinates::Pair.new(1,1)
      assert_equal("2:", "%d:" % pair11)
      assert_equal("2=", "%d=" % pair11)
      assert_equal("1=", When.m17n("%d:") % pair11)

      date = When.when?('2011-02-28T12:34:56+09:00')
      assert_equal(["February", {""=>"February", "ja"=>"2月"}], [date.name(-1).to_s, date.name(-1).names])
      assert_equal("Mon Feb 28 12:34:56 +0900 2011", date.strftime('%+'))

      date = When.when?('2011-05-17T12:34:56', {:clock=>'+09:00'})
    # assert_equal("5月", date.strftime('%.2b').translate('ja'))
      assert_equal("05", date.strftime('%m'))
      assert_equal("Tue May 17 12:34:56 +0900 2011", date.strftime('%+'))
    # assert_equal("火 5月 17 12:34:56 +0900 2011", date.strftime('%+').translate('ja'))

      clock = When.Clock('+09:00')
      #pp clock.to_s
      assert_equal("+09:00", clock.label.to_s)
      assert_equal(nil, clock.referenceEvent)
      assert_equal("T00+09:00", clock.referenceTime.to_s)
      assert_equal("T*15:00:00Z", clock.utcReference.to_s)
    end

    def test__strftime_2
      [['%c', 'ja', '2012/04/03 10:14:00'], ['%c', 'fr', '03 avril 2012 10:14:00'],
       ['%x', 'ja', '2012/04/03'         ], ['%x', 'fr', '03/04/2012'            ],
       ['%X', 'ja', '10:14:00'           ], ['%X', 'fr', '10:14:00'              ]
      ].each do |sample|
        assert_equal(sample[2], When.when?('2012-4-3T10:14:00').
          strftime(sample[0], sample[1]))
      end
    end

    def test__strftime_3
      [['DateTime',      'ja', '2012/04/03 10:14:00'                  ], ['DateTime',      'fr', '03 avril 2012 10:14:00'   ],
       ['DateTimeLong',  'ja', '2012年04月03日(火) 10時14分00秒 +0000'], ['DateTimeLong',  'fr', 'mardi 03 avril 2012 10:14'],
       ['DateTimeShort', 'ja', '12/04/03 10:14'                       ], ['DateTimeShort', 'fr', '03 avr 10:14'             ],
       ['Date',          'ja', '2012/04/03'                           ], ['Date',          'fr', '03/04/2012'               ],
       ['DateLong',      'ja', '2012年04月03日(火)'                   ], ['DateLong',      'fr', ' 3 avril 2012'            ],
       ['DateShort',     'ja', '04/03'                                ], ['DateShort',     'fr', ' 3 avr'                   ],
       ['Time',          'ja', '10:14:00'                             ], ['Time',          'fr', '10:14:00'                 ]
      ].each do |sample|
        assert_equal(sample[2], When.when?('2012-4-3T10:14:00').
          strftime(When.Resource('_m:CalendarFormats::'+sample[0]), sample[1]))
      end
    end

    def test__name
      month = When.when?('AP1393.1.1T12:34:56').name('month')
      assert_equal("فروردین", month.translate('ar'))
    end

    def test__coordinates
      date = When.when?('2012.3=16T12:34:56', {:frame=>When::CalendarTypes::ChineseLuniSolar.new({'time_basis'=>'+09:00'})})
      assert_equal(2012, date.year  )
      assert_equal(When::Coordinates::Pair.new(3,1), date.month)
      assert_equal(  16, date.day   )
      assert_equal(  12, date.hour  )
      assert_equal(  34, date.minute)
      assert_equal(  56, date.second)
      assert_equal(   4, date.ymon  )
      assert_equal( 105, date.yday  )
      assert_equal(  16, date.mday  )
      assert_equal(   0, date.wday  )
    end

    def mweek(dow, day)
      dow = (dow + 1) % 7
      w,d = (day - 1).divmod(7)
      (d < dow) ? w : w+1
    end

    def test__term
     # [13,14,15].each do |d|
     #   7.times do |i|
     #      p [d, i, mweek(i, d)]
     #   end
     # end
     # raise
      format = ['%U %w %W %j', '%G-W%V-%u']
      7.times do |i|
        2.times do |k|
          [ '1-1' , '1-2' , '1-3' , '1-4' , '1-5' , '1-6' , '1-7' , '1-8' ,
           '12-24','12-25','12-26','12-27','12-28','12-29','12-30','12-31',].each do |m|
            date1 = When.when?("#{2000+4*i+k}-#{m}")
            expr0 = format.map {|f| date1.to_date.strftime(f)}
            date2 = When.when?(expr0[1])
            expr1 = format.map {|f| date1.strftime(f)}
            expr2 = format.map {|f| date2.strftime(f)}
            assert_equal([expr0,expr0,mweek(date1.to_i % 7, date1.day)], [expr1,expr2,date1.mweek])
          end
        end
      end
    end

    def test__month_included
      assert_equal([['December 2013',
                    ['*', '-', '-', '-', '-', '-', 1, 2],
                    ['*', 3, 4, 5, 6, 7, 8, 9],
                    ['*', 10, 11, 12, 13, 14, 15, 16],
                    ['*', 17, 18, 19, 20, 21, 22, 23],
                    ['*', 24, 25, 26, 27, 28, 29, 30, 31]]],

        When.when?('2013-12-30').month_included('WorldWeek') {|date, type|
          case type
          when When::YEAR  ; date.strftime('%Y')
          when When::MONTH ; date.strftime('%B %Y')
          when When::WEEK  ; '*'
          when When::DAY   ; date[When::DAY]
          else             ; '-'
          end
        })
    end

    def test__round
      date = When.when?("2010-09-29T14:45:12.33+09:00")
      assert_equal(%w(2010-09-29T14:45:12.33+09:00 2010-09-29T14:45:12+09:00), [date.to_s, date.to_s(3, true)])

      date = When.when?('2013-10-28T23:59:59.999', :clock=>'+09:00', :precision=>3)
      assert_equal(%w(2013-10-28T23:59:59+09:00    2013-10-28T24:00:00+09:00), [date.to_s, date.to_s(3, true)])

      date = When.when?('2013-10-28T23:59:59.999', :clock=>'+09:00')
      assert_equal(%w(2013-10-28T23:59:59.99+09:00 2013-10-28T24:00:00+09:00), [date.to_s, date.to_s(3, true)])

      date = When.when?('2013-10-28T23:59:29.999', :clock=>'+09:00')
      assert_equal(%w(2013-10-28T23:59:29.99+09:00 2013-10-28T23:59+09:00),    [date.to_s, date.to_s(2, true)])

      date = When.when?('2013-10-28T23:59:30.001', :clock=>'+09:00')
      assert_equal(%w(2013-10-28T23:59:30.00+09:00 2013-10-28T24:00+09:00),    [date.to_s, date.to_s(2, true)])
    end
  end
end
