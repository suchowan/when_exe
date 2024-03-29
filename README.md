when_exe - A multicultural and multilingualized calendar library
================================================================

[![Gem Version](https://badge.fury.io/rb/when_exe.svg)](http://badge.fury.io/rb/when_exe)

[when_exe](https://rubygems.org/gems/when_exe) is a multicultural and multilingualized calendar library based on [ISO 8601:2004](https://en.wikipedia.org/wiki/ISO_8601), [ISO 19108](http://www.iso.org/iso/home/store/catalogue_tc/catalogue_detail.htm?csnumber=26013), [RFC 5545(iCalendar)](http://tools.ietf.org/html/rfc5545) and [RFC6350](http://tools.ietf.org/html/rfc6350). [JSON-LD](http://www.w3.org/TR/json-ld/) formats for TemporalPosition and TemporalReferenceSystem are available.

[<img alt='Architecture' title='display this figure at actual size' src='https://raw.githubusercontent.com/suchowan/when_exe/f7bb8b51259f0c1653c6c37b3ce20bd2a6ab7914/architecture.png' width='637' height='408'/>](https://raw.githubusercontent.com/suchowan/when_exe/f7bb8b51259f0c1653c6c37b3ce20bd2a6ab7914/architecture.png)

Installation
------------

The when_exe gem can be installed by running:

    gem install when_exe


Web Server
----------

The Web server for when_exe demonstration is available on [hosi.org](http://hosi.org).

You can see examples of [When.exe Standard Representation](http://www.asahi-net.or.jp/~dd6t-sg/when_rdoc/when_en.html#label-8) and Reference System IRI at the top-left corner of Date frame.

Preferences are changeable on [hosi.org/cookies](http://hosi.org/cookies).

SPARQL endpoint is [hosi.org/japan/sparql](http://hosi.org/japan/sparql).


Documentation
-------------

API documentation for when_exe is available on [RubyDoc.info](https://rubydoc.info/gems/when_exe) or [here](http://www2u.biglobe.ne.jp/~suchowan/when_exe/frames.html).

Available calendars and clocks are defined as subclasses of TM_Calendar and TM_Clock or using definition tables in [CalendarTypes namespace](https://rubydoc.info/gems/when_exe/When/CalendarTypes).

Available calendar eras are defined using definition tables in [CalendarEra namespace](https://rubydoc.info/gems/when_exe/When/TM/CalendarEra).

Whole TemporalReferenceSystem resources are listed in the [Resource Dictionary](http://www2u.biglobe.ne.jp/~suchowan/ResourceDictionary.html).

For further detail, please refer to the [when_exe Wiki](http://www2u.biglobe.ne.jp/~suchowan/when_exe_wiki.html) pages.


License
-------

This beta version's license is the MIT license. Please see [LICENSE.txt](https://github.com/suchowan/when_exe/blob/master/LICENSE.txt).

Data sets [TemporalPositionDataSet](http://hosi.org/tp.rdf) and [TemporalReferenceSystemDataSet](http://hosi.org/When.rdf) should be used according to [CC-BY](http://creativecommons.org/licenses/by/4.0/) license.


Source Code
-----------

Source code for when_exe is available on [GitHub](https://github.com/suchowan/when_exe).


Example Usage
-------------

    require 'when_exe'
    # include When
    
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
    p islamic_date.frame.iri                     #=> "http://hosi.org/When/CalendarTypes/TabularIslamic"
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
    #  retrieve JSON, JSON-LD, Turtle response from http://hosi.org:3000 (when_exe demonstration web server)
    # (Notation3, RDF/XML, N-Triples and XML formats are also available.)
    require 'open-uri'
    URI.open('http://hosi.org:3000/Date/2014-04-20.json') do |json|
      puts json.read #=> newlines and blanks are inserted for readability.
       # {"frame"    : "http://hosi.org/When/CalendarTypes/Gregorian",
       #  "precision": 0,
       #  "location" : "http://hosi.org/When/Coordinates/Spatial?long=139.4441E&lat=35.3916N&alt=0.0",
       #  "sdn"      : 2456768,
       #  "calendar" : ["http://hosi.org/When/CalendarTypes/Gregorian"],
       # <..snip..>
       #  "cal_date" : [2014,4,20]}
    end
    
    URI.open('http://hosi.org/tp/2014-04-20.jsonld') do |jsonld| # redirected from http://hosi.org to http://hosi.org:3000
      puts jsonld.read #=> newlines and blanks are inserted for readability.
       # {"@context":
       #    {"xsd" :"http://www.w3.org/2001/XMLSchema",
       #     "rdf" :"http://www.w3.org/1999/02/22-rdf-syntax-ns#",
       #     "rdfs":"http://www.w3.org/2000/01/rdf-schema#",
       #     "owl" :"http://www.w3.org/2002/07/owl#",
       #     "dc"  :"http://purl.org/dc/elements/1.1/",
       #     "dcq" :"http://purl.org/dc/terms/",
       #     "dct" :"http://purl.org/dc/dcmitype/",
       #     "ts"  :"http://hosi.org/ts#",
       #     "Week":"http://hosi.org/When/Coordinates/Common::Week::",
       #     "day" :"http://hosi.org/When/CalendarNote/Christian/Notes::day::"},
       #  "@graph":[{
       #    "rdf:type"     : {"@id":"http://hosi.org/ts/When/TM/CalDate"},
       #    "@id"          : "http://hosi.org/tp/2014-04-20",
       #    "ts:sdn"       : 2456768,
       #    "ts:frame"     : {"@id":"http://hosi.org/When/CalendarTypes/Gregorian"},
       #    "ts:coordinate": "20",
       #    "@reverse"     : {"rdfs:member":{"@id":"http://hosi.org/tp/2014-04"}},
       #    "day:Week"     : {"@id":"Week:Sunday"},
       #    "day:Easter"   : "easter(0)",
       #    "day:Christmas": "christmas(-249)"
       #   }]
       # }
    end
    
    URI.open('http://hosi.org/tp/2014-04-20.ttl') do |ttl| # redirected from http://hosi.org to http://hosi.org:3000
      puts ttl.read
       # @prefix Week: <http://hosi.org/When/Coordinates/Common::Week::> .
       # @prefix day: <http://hosi.org/When/CalendarNote/Christian/Notes::day::> .
       # @prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
       # @prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
       # @prefix ts: <http://hosi.org/ts#> .
       # @prefix xsd: <http://www.w3.org/2001/XMLSchema> .
       # 
       # <http://hosi.org/tp/2014-04> rdfs:member <http://hosi.org/tp/2014-04-20> .
       # 
       # <http://hosi.org/tp/2014-04-20> a <http://hosi.org/ts/When/TM/CalDate>;
       #    day:Christmas "christmas(-249)";
       #    day:Easter "easter(0)";
       #    day:Week Week:Sunday;
       #    ts:coordinate "20";
       #    ts:frame <http://hosi.org/When/CalendarTypes/Gregorian>;
       #    ts:sdn 2456768 .
    end
    
    URI.open('http://hosi.org/When/TM/OrdinalReferenceSystem/GeologicalAge.ttl') do |ttl| # redirected from http://hosi.org to http://hosi.org:3000
      puts ttl.read
       # @prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
       # @prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
       # @prefix ts: <http://hosi.org/ts#> .
       # @prefix xsd: <http://www.w3.org/2001/XMLSchema> .
       # 
       # <http://hosi.org/When/TM/OrdinalReferenceSystem/GeologicalAge> a <http://hosi.org/ts/When/TM/OrdinalReferenceSystem>;
       #    rdfs:member <http://hosi.org/When/TM/OrdinalReferenceSystem/GeologicalAge::Hadean>,
       #      <http://hosi.org/When/TM/OrdinalReferenceSystem/GeologicalAge::Archean>,
       #      <http://hosi.org/When/TM/OrdinalReferenceSystem/GeologicalAge::Proterozoic>,
       #      <http://hosi.org/When/TM/OrdinalReferenceSystem/GeologicalAge::Phanerozoic> .
       # 
       # <http://hosi.org/When/TM/OrdinalReferenceSystem/GeologicalAge::Archean> a <http://hosi.org/ts/When/TM/OrdinalEra>;
       #    ts:begin "-4000000000";
       #    ts:end "-2500000000";
       #    ts:label <http://hosi.org/When/TM/OrdinalReferenceSystem/GeologicalAge::Archean::Archean>;
       #    rdfs:member <http://hosi.org/When/TM/OrdinalReferenceSystem/GeologicalAge::Archean::Eoarchean>,
       #      <http://hosi.org/When/TM/OrdinalReferenceSystem/GeologicalAge::Archean::Paleoarchean>,
       #      <http://hosi.org/When/TM/OrdinalReferenceSystem/GeologicalAge::Archean::Mesoarchean>,
       #      <http://hosi.org/When/TM/OrdinalReferenceSystem/GeologicalAge::Archean::Neoarchean> .
       # 
       # <http://hosi.org/When/TM/OrdinalReferenceSystem/GeologicalAge::Archean::Eoarchean> a <http://hosi.org/ts/When/TM/OrdinalEra>;
       #    ts:begin "-4000000000";
       #    ts:end "-3600000000";
       #    ts:label <http://hosi.org/When/TM/OrdinalReferenceSystem/GeologicalAge::Archean::Eoarchean::Eoarchean> .
       # <..snip..>
    end
    
    #
    # SPARQL endpoint ------------------------------
    #  https://rubygems.org/gems/sparql is required for this section's operations.
    #  Please install sparql before operation.
    
    require 'sparql/client'
    PREFIXES = When::Parts::Resource.namespace_prefixes(
      '_co:Common', '_co:Common?V=0618', '_m:Calendar', '_m:Japanese', '_n:Japanese/Notes')
    
    client = SPARQL::Client.new("http://hosi.org/japan/sparql")
    
    client.query(PREFIXES.keys.map {|key|
      "PREFIX #{key}: <#{PREFIXES[key].last}> "}.join("\n") +
      %(
        SELECT DISTINCT ?s
        WHERE {
          ?s ts:coordinate "10" .
          ?s DayNote:廿四節気 SolarTerm:清明 .
          ?s DayNote:干支     Stem-Branch:壬戌 .
        }
      )).each do |solution|
      p solution[:s].to_s #=>
        #=> "http://hosi.org/tp/0689-03-10%5E%5EJapanese"
        #=> "http://hosi.org/tp/1490-03-10%5E%5EJapanese"
    end
    
    #
    # TZInfo ---------------------------------------
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
    p When.when?('TZID=America/New_York:1997-10-26T01=30') #=> 1997-10-26T01:30-05:00, '=' indicates "leap hour"
    p When.when?('TZID=America/New_York:1997-10-26T02:30') #=> 1997-10-26T02:30-05:00
    p When.when?('TZID=America/New_York:1997-10-26T03:30') #=> 1997-10-26T03:30-05:00
    
