when_exe - A multicultural and multilingualized calendar library
================================================================

[![Gem Version](https://badge.fury.io/rb/when_exe.svg)](http://badge.fury.io/rb/when_exe)

[when_exe](http://rubygems.org/gems/when_exe) is a multicultural and multilingualized calendar library based on [ISO 8601](http://en.wikipedia.org/wiki/ISO_8601), [ISO 19108](http://www.iso.org/iso/home/store/catalogue_tc/catalogue_detail.htm?csnumber=26013), [RFC 5545 - iCalendar](http://tools.ietf.org/html/rfc5545) and [RFC6350](http://tools.ietf.org/html/rfc6350).

[<img alt='Architecture' title='display this figure at actual size' src='http://www2u.biglobe.ne.jp/~suchowan/u/pic/architecture.png' width='637' height='408'/>](http://www2u.biglobe.ne.jp/~suchowan/u/pic/architecture.png)

Installation
------------

The when_exe gem can be installed by running:

    gem install when_exe


Web Server
----------

Web server for when_exe demonstration is available on [hosi.org](http://hosi.org).

You can see examples of [When.exe Standard Representation](http://www.asahi-net.or.jp/~dd6t-sg/when_rdoc/when_en.html#label-8) and Reference System IRI at the top-left corner of Date frame.

Preferences are changeable on [hosi.org/cookies](http://hosi.org/cookies).


Documentation
-------------

API documentation for when_exe is available on [RubyDoc.info](http://rubydoc.info/gems/when_exe/frames).

Available calendars and clocks are defined as subclasses of TM_Calendar and TM_Clock or using definition tables in [CalendarTypes namespace](http://rubydoc.info/gems/when_exe/frames/When/CalendarTypes).

Available calendar eras are defined using definition tables in [CalendarEra namespace](http://rubydoc.info/gems/when_exe/frames/When/TM/CalendarEra).

License
-------

This beta version's license is limited. Please see [LICENSE.txt](https://github.com/suchowan/when_exe/blob/master/LICENSE.txt) for details.


Source Code
-----------

Source code for when_exe is available on [GitHub](https://github.com/suchowan/when_exe).


Example Usage
-------------

    require 'when_exe'
    
    # When::TM::CalDate ---------------------------
    
    gregorian_date = When.tm_pos(2014, 8, 1)
    p gregorian_date                             #=> 2014-08-01
    p When.when?('2014-08-01')                   #=> 2014-08-01, the same date
    p gregorian_date.to_i                        #=> 2456871, Julian Day Number(Integer)
    p gregorian_date.to_f                        #=> 2456871.0, at noon for UTC
    p gregorian_date.class                       #=> When::TM::CalDate
    p gregorian_date.frame.iri                   #=> "http://hosi.org/When/CalendarTypes/Gregorian"
    puts gregorian_date.name(When::MONTH).class  #=> When::BasicTypes::M17n
    puts gregorian_date.name(When::MONTH).iri    #=> http://hosi.org/When/BasicTypes/M17n/Calendar::Month::August
    puts gregorian_date.name(When::MONTH) / 'en' #=> August
    puts gregorian_date.name(When::MONTH) / 'fr' #=> août
    puts gregorian_date.name(When::MONTH) / 'ar' #=> اغسطس
    p gregorian_date.easter                      #=> 2014-04-20
    p gregorian_date.is?('Easter')               #=> false
    p When.tm_pos(2014, 4, 20).is?('Easter')     #=> true
    
    islamic_date = When::TabularIslamic ^ gregorian_date
    p islamic_date                               #=> 1435-10-04
    p When.tm_pos(1435, 10, 4, :frame=>'TabularIslamic')
                                                 #=> 1435-10-04, the same date
    p When.when?('1435-10-4^TabularIslamic')     #=> 1435-10-04, the same date
    p islamic_date.frame.iri                     #=> ""http://hosi.org/When/CalendarTypes/TabularIslamic"
    puts islamic_date.name(When::MONTH) / 'en'   #=> Shawwal
    puts islamic_date.name(When::MONTH) / 'ar'   #=> شوال
    
    # When::TM::DateAndTime ------------------------
    
    gregorian_date = When.tm_pos(2014, 8, 1, 9, 0, 0, :clock=>'+09:00')
    p gregorian_date                             #=> 2014-08-01T09:00:00+09:00
    p When.when?('2014-08-01T09:00:00+09:00')    #=> 2014-08-01T09:00:00+09:00, the same date
    p gregorian_date.to_i                        #=> 2456871, Julian Day Number(Integer)
    p gregorian_date.to_f                        #=> 2456870.5 at 09:00:00 of Timezone +09:00
    p gregorian_date.class                       #=> When::TM::DateAndTime
    p gregorian_date.frame.iri                   #=> "http://hosi.org/When/CalendarTypes/Gregorian"
    p gregorian_date.clk_time.class              #=> When::TM::ClockTime
    p gregorian_date.clk_time.frame.iri          #=> "http://hosi.org/When/TM/Clock?label=+09:00"
    
    gregorian_date = When.tm_pos(2014, 8, 1, 9, 0, 0, :clock=>'+09:00',
                                                      :long=>'139.413012E', :lat=>'35.412222N')
    p gregorian_date                             #=> 2014-08-01T09:00:00+09:00
    p gregorian_date.location.iri                #=> "http://hosi.org/When/Coordinates/Spatial?long=139.413012E&lat=35.412222N&alt=0"
    p gregorian_date.sunrise.floor(When::MINUTE) #=> 2014-08-01T04:48+09:00
    p gregorian_date.sunset.floor(When::MINUTE)  #=> 2014-08-01T18:46+09:00
    
    darian_date = When::Darian ^ gregorian_date
    p darian_date                                #=> 0216-13-23T15:12:11MTC
    p darian_date.to_i                           #=> 49974, Serial Day Number(Integer)
    p darian_date.to_f                           #=> 49974.13346485421
    p darian_date.frame.iri                      #=> "http://hosi.org/When/CalendarTypes/Darian"
    p darian_date.clk_time.frame.iri             #=> "http://hosi.org/When/CalendarTypes/MTC"
    p darian_date.time_standard.iri              #=> "http://hosi.org/When/TimeStandard/MartianTimeCoordinated?location=(_l:long=0&datum=Mars)"
    
    # When::TM::CalendarEra ------------------------
    
    babylonian_date = When.tm_pos('NebuchadnezzarII', 1, 1, 1)
    p babylonian_date                            #=> NebuchadnezzarII01(-603).01.01
    p When.when?('NebuchadnezzarII1.1.1')        #=> NebuchadnezzarII01(-603).01.01, the same date
    p babylonian_date.to_i                       #=> 1500904, Julian Day Number(Integer)
    p When.era('NebuchadnezzarII')               #=> [_e:AncientOrient::Neo-Babylonian::NebuchadnezzarII]
    p When.era('NebuchadnezzarII')[0] ^ 1500904  #=> NebuchadnezzarII01(-603).01.01, the same date
    p babylonian_date.to_f                       #=> 1500904.0, at noon for UTC
    p babylonian_date.frame.iri                  #=> "http://hosi.org/When/CalendarTypes/BabylonianPD"
    p babylonian_date.calendar_era.iri           #=> "http://hosi.org/When/TM/CalendarEra/AncientOrient::Neo-Babylonian::NebuchadnezzarII"
    
    babylonian_date = When.when?('NebuchadnezzarII1.1.1T18:13:00',
                                 :clock=>'+03:00?long=45&lat=32&border=Sunset')
    4.times do
      p [babylonian_date, babylonian_date.to_i]  #=>
        # [NebuchadnezzarII01(-603).01.01T:18:13:00+03:00, 1500904]
        # [NebuchadnezzarII01(-603).01.01T:18:14:00+03:00, 1500904]
        # [NebuchadnezzarII01(-603).01.02T*18:15:00+03:00, 1500905]
        # [NebuchadnezzarII01(-603).01.02T*18:16:00+03:00, 1500905]
      babylonian_date += When::PT1M
    end
    
    # Web service ----------------------------------
    #  retrieve JSON response from http://hosi.org:3000 (when_exe demonstration web server)
    require 'open-uri'
    open('http://hosi.org:3000/Date/2014-04-20.json') do |json|
      puts json.read #=> newlines and blanks are inserted for readability.
       # {"frame"    : "http://hosi.org/When/CalendarTypes/Gregorian",
       #  "precision": 0,
       #  "location" : "http://hosi.org/When/Coordinates/Spatial?long=139.4441E&lat=35.3916N&alt=0.0",
       #  "sdn"      : 2456768,
       #  "calendar" : ["http://hosi.org/When/CalendarTypes/Gregorian"],
       #  "notes"    : [[{"note":"Month","value":"April"}],
       #                [{"note":"Week","value":"Sunday(6)"}]],
       #  "clock"    : "Asia/Tokyo+09:00",
       #  "clk_time" : [2456768,0,0,0],
       #  "dynamical": 1397919667.184082,
       #  "universal": 1397919600.0,
       #  "cal_date" : [2014,4,20]}
    end
    
    # TZInfo --------------------------------------
    #  https://rubygems.org/gems/tzinfo is required for this section's operations.
    #  Please install tzinfo before operation.
    
    gregorian_date = When.tm_pos(2014, 8, 1, 9, 0, 0, :tz=>'Asia/Tokyo')
    p gregorian_date                             #=> 2014-08-01T09:00:00+09:00
    p gregorian_date.location.iri                #=> "http://hosi.org/When/Coordinates/Spatial?long=139.4441E&lat=35.3916N&label=Asia/Tokyo"
    p gregorian_date.sunrise.floor(When::MINUTE) #=> 2014-08-01T04:48+09:00
    p gregorian_date.sunset.floor(When::MINUTE)  #=> 2014-08-01T18:45+09:00
    
    jst = When.tm_pos(1997, 4, 6, 15, 30, 00, :tz=>'Asia/Tokyo')
    p jst                                        #=> 1997-04-06T15:30:00+09:00
    est = When.Clock('America/New_York') ^ jst
    p est                                        #=> 1997-04-06T01:30:00-05:00
    jst = When.tm_pos(1997, 4, 6, 16, 30, 00, :tz=>'Asia/Tokyo')
    p jst                                        #=> 1997-04-06T16:30:00+09:00
    edt = When.Clock('America/New_York') ^ jst
    p edt                                        #=> 1997-04-06T03:30:00-04:00
    
    p When.when?('TZID=America/New_York:1997-10-26T01:30') #=> 1997-10-26T01:30-04:00
    p When.when?('TZID=America/New_York:1997-10-26T01=30') #=> 1997-10-26T01:30-05:00, '=' indicates "leep hour"
    p When.when?('TZID=America/New_York:1997-10-26T02:30') #=> 1997-10-26T02:30-05:00
    p When.when?('TZID=America/New_York:1997-10-26T03:30') #=> 1997-10-26T03:30-05:00
    
    # Google Calendar ------------------------------
    #  https://github.com/suchowan/gcalapi is required for this section's operations.
    #  Please install gcalapi before operation.
    #  Please replace xxxxxxxx and ******** to valid id/password pair and access Google Calendar.
    
    service = GoogleCalendar::Service.new('xxxxxxxx@gmail.com', '********')
    feed = "http://www.google.com/calendar/feeds/%s__%s%%40holiday.calendar.google.com/public/full" %
            ['japanese', 'ja']
    gcal = GoogleCalendar::Calendar::new(service, feed)
    gcal.enum_for({'start-min'=>'2014-01-01', 'start-max'=>'2015-01-01',
                   'orderby'=>'starttime', 'sortorder'=>'a'
                  }).each do |range|
      puts '%s - %s' % [range, range.events[0].summary] #=>
        # 2014-01-01T00:00:00.00+09:00...2014-01-02T00:00:00.00+09:00 - 元日
        # 2014-01-02T00:00:00.00+09:00...2014-01-03T00:00:00.00+09:00 - 銀行休業日
        # 2014-01-03T00:00:00.00+09:00...2014-01-04T00:00:00.00+09:00 - 銀行休業日
        # 2014-01-13T00:00:00.00+09:00...2014-01-14T00:00:00.00+09:00 - 成人の日
        # 2014-02-11T00:00:00.00+09:00...2014-02-12T00:00:00.00+09:00 - 建国記念の日
        # 2014-03-21T00:00:00.00+09:00...2014-03-22T00:00:00.00+09:00 - 春分の日
        # 2014-04-29T00:00:00.00+09:00...2014-04-30T00:00:00.00+09:00 - 昭和の日
        # 2014-05-03T00:00:00.00+09:00...2014-05-04T00:00:00.00+09:00 - 憲法記念日
        # 2014-05-04T00:00:00.00+09:00...2014-05-05T00:00:00.00+09:00 - みどりの日
        # 2014-05-05T00:00:00.00+09:00...2014-05-06T00:00:00.00+09:00 - こどもの日
        # 2014-05-06T00:00:00.00+09:00...2014-05-07T00:00:00.00+09:00 - みどりの日 振替休日
        # 2014-07-21T00:00:00.00+09:00...2014-07-22T00:00:00.00+09:00 - 海の日
        # 2014-09-15T00:00:00.00+09:00...2014-09-16T00:00:00.00+09:00 - 敬老の日
        # 2014-09-23T00:00:00.00+09:00...2014-09-24T00:00:00.00+09:00 - 秋分の日
        # 2014-10-13T00:00:00.00+09:00...2014-10-14T00:00:00.00+09:00 - 体育の日
        # 2014-11-03T00:00:00.00+09:00...2014-11-04T00:00:00.00+09:00 - 文化の日
        # 2014-11-23T00:00:00.00+09:00...2014-11-24T00:00:00.00+09:00 - 勤労感謝の日
        # 2014-11-24T00:00:00.00+09:00...2014-11-25T00:00:00.00+09:00 - 勤労感謝の日 振替休日
        # 2014-12-23T00:00:00.00+09:00...2014-12-24T00:00:00.00+09:00 - 天皇誕生日
        # 2014-12-25T00:00:00.00+09:00...2014-12-26T00:00:00.00+09:00 - クリスマス
        # 2014-12-31T00:00:00.00+09:00...2015-01-01T00:00:00.00+09:00 - 大晦日
    end

For further detail, please refer to the [when_exe Wiki](http://www2u.biglobe.ne.jp/~suchowan/when_exe_wiki.html) pages.
