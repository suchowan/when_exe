# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module MiniTest

  class GoogleCalendar < MiniTest::TestCase

    config = ::When.config
    ACCOUNT, PASSWORD = config['@'] if config.key?('@')

    PUBLIC_FEED  = "http://www.google.com/calendar/feeds/%s__%s%%40holiday.calendar.google.com/public/full"
    PRIVATE_FEED = "http://www.google.com/calendar/feeds/%s%%40gmail.com/private/full"
    YEAR         = "1949"
    RULE0        = <<RULE0
DTSTART;VALUE=DATE:19490101
DTEND;VALUE=DATE:19490102
RRULE:FREQ=YEARLY
RULE0
    RULE1        = <<RULE1
RRULE:FREQ=YEARLY
DTSTART;TZID=America/New_York:#{YEAR}0321T120000
DTEND;TZID=America/New_York:#{YEAR}0322T130000
RULE1
    RECURRENCE   = <<RECURRENCE
DTSTART;TZID=America/New_York:#{YEAR}0321T120000
DTEND;TZID=America/New_York:#{YEAR}0322T130000
RRULE:FREQ=YEARLY
BEGIN:VTIMEZONE
TZID:America/New_York
X-LIC-LOCATION:America/New_York
BEGIN:DAYLIGHT
TZOFFSETFROM:-0500
TZOFFSETTO:-0400
TZNAME:EDT
DTSTART:19700308T020000
RRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=2SU
END:DAYLIGHT
BEGIN:STANDARD
TZOFFSETFROM:-0400
TZOFFSETTO:-0500
TZNAME:EST
DTSTART:19701101T020000
RRULE:FREQ=YEARLY;BYMONTH=11;BYDAY=1SU
END:STANDARD
END:VTIMEZONE
RECURRENCE

    HOLIDAYS1 = [ # Public Feed
      ["元日",                "2013-01-01T00:00:00.00+09:00", "2013-01-02T00:00:00.00+09:00"],
      ["銀行休業日",          "2013-01-02T00:00:00.00+09:00", "2013-01-03T00:00:00.00+09:00"],
      ["銀行休業日",          "2013-01-03T00:00:00.00+09:00", "2013-01-04T00:00:00.00+09:00"],
      ["成人の日",            "2013-01-14T00:00:00.00+09:00", "2013-01-15T00:00:00.00+09:00"],
      ["建国記念の日",        "2013-02-11T00:00:00.00+09:00", "2013-02-12T00:00:00.00+09:00"],
      ["春分の日",            "2013-03-20T00:00:00.00+09:00", "2013-03-21T00:00:00.00+09:00"],
      ["昭和の日",            "2013-04-29T00:00:00.00+09:00", "2013-04-30T00:00:00.00+09:00"],
      ["憲法記念日",          "2013-05-03T00:00:00.00+09:00", "2013-05-04T00:00:00.00+09:00"],
      ["みどりの日",          "2013-05-04T00:00:00.00+09:00", "2013-05-05T00:00:00.00+09:00"],
      ["こどもの日",          "2013-05-05T00:00:00.00+09:00", "2013-05-06T00:00:00.00+09:00"],
      ["こどもの日 振替休日", "2013-05-06T00:00:00.00+09:00", "2013-05-07T00:00:00.00+09:00"],
      ["海の日",              "2013-07-15T00:00:00.00+09:00", "2013-07-16T00:00:00.00+09:00"],
      ["敬老の日",            "2013-09-16T00:00:00.00+09:00", "2013-09-17T00:00:00.00+09:00"],
      ["秋分の日",            "2013-09-23T00:00:00.00+09:00", "2013-09-24T00:00:00.00+09:00"],
      ["体育の日",            "2013-10-14T00:00:00.00+09:00", "2013-10-15T00:00:00.00+09:00"],
      ["文化の日",            "2013-11-03T00:00:00.00+09:00", "2013-11-04T00:00:00.00+09:00"],
      ["文化の日 振替休日",   "2013-11-04T00:00:00.00+09:00", "2013-11-05T00:00:00.00+09:00"],
      ["勤労感謝の日",        "2013-11-23T00:00:00.00+09:00", "2013-11-24T00:00:00.00+09:00"],
      ["天皇誕生日",          "2013-12-23T00:00:00.00+09:00", "2013-12-24T00:00:00.00+09:00"],
      ["クリスマス",          "2013-12-25T00:00:00.00+09:00", "2013-12-26T00:00:00.00+09:00"],
      ["大晦日",              "2013-12-31T00:00:00.00+09:00", "2014-01-01T00:00:00.00+09:00"]
    ]

    HOLIDAYS2 = [ # Private Feed
      ["元日",                "2013-01-01T00:00:00.00+09:00", "2013-01-02T00:00:00.00+09:00"],
      ["元日 振替休日",       "2013-01-02T00:00:00.00+09:00", "2013-01-03T00:00:00.00+09:00"],
      ["銀行休業日",          "2013-01-03T00:00:00.00+09:00", "2013-01-04T00:00:00.00+09:00"],
      ["成人の日",            "2013-01-14T00:00:00.00+09:00", "2013-01-15T00:00:00.00+09:00"],
      ["建国記念の日",        "2013-02-11T00:00:00.00+09:00", "2013-02-12T00:00:00.00+09:00"],
      ["春分の日",            "2013-03-20T00:00:00.00+09:00", "2013-03-21T00:00:00.00+09:00"],
      ["昭和の日",            "2013-04-29T00:00:00.00+09:00", "2013-04-30T00:00:00.00+09:00"],
      ["憲法記念日",          "2013-05-03T00:00:00.00+09:00", "2013-05-04T00:00:00.00+09:00"],
      ["みどりの日",          "2013-05-04T00:00:00.00+09:00", "2013-05-05T00:00:00.00+09:00"],
      ["こどもの日",          "2013-05-05T00:00:00.00+09:00", "2013-05-06T00:00:00.00+09:00"],
      ["みどりの日 振替休日", "2013-05-06T00:00:00.00+09:00", "2013-05-07T00:00:00.00+09:00"],
      ["海の日",              "2013-07-15T00:00:00.00+09:00", "2013-07-16T00:00:00.00+09:00"],
      ["敬老の日",            "2013-09-16T00:00:00.00+09:00", "2013-09-17T00:00:00.00+09:00"],
      ["秋分の日",            "2013-09-23T00:00:00.00+09:00", "2013-09-24T00:00:00.00+09:00"],
      ["体育の日",            "2013-10-14T00:00:00.00+09:00", "2013-10-15T00:00:00.00+09:00"],
      ["文化の日",            "2013-11-03T00:00:00.00+09:00", "2013-11-04T00:00:00.00+09:00"],
      ["文化の日 振替休日",   "2013-11-04T00:00:00.00+09:00", "2013-11-05T00:00:00.00+09:00"],
      ["勤労感謝の日",        "2013-11-23T00:00:00.00+09:00", "2013-11-24T00:00:00.00+09:00"],
      ["天皇誕生日",          "2013-12-23T00:00:00.00+09:00", "2013-12-24T00:00:00.00+09:00"],
      ["クリスマス",          "2013-12-25T00:00:00.00+09:00", "2013-12-26T00:00:00.00+09:00"],
      ["大晦日",              "2013-12-31T00:00:00.00+09:00", "2014-01-01T00:00:00.00+09:00"]
    ]

    WEEKLY_EVENTS = [
      "2014-07-17T08:30:00+09:00...2014-07-17T09:30:00+09:00",
      "2014-07-31T08:30:00+09:00...2014-07-31T09:30:00+09:00"
    ]

    def get_cal(feed)
      ::GoogleCalendar::Calendar::new(::GoogleCalendar::Service.new("#{ACCOUNT}@gmail.com", PASSWORD), feed)
    end

    def test_nothing
    end

    if const_defined?(:PASSWORD) && Object.const_defined?(:GoogleCalendar)

      def test__to_vevent
        holidays = HOLIDAYS1.dup
        gcal     = get_cal(PUBLIC_FEED % ['japanese', 'ja'])
        gcal.events({'start-min'=>'2013-01-01', 'start-max'=>'2014-01-01',
                    'orderby'=>'starttime', 'sortorder'=>'a' # a:asend, d:desend
                   }).each do |event|
          vevent = event.to_vevent
          assert_equal(holidays.shift, [vevent.summary, vevent.dtstart.to_s, vevent.dtend.to_s])
          # puts event.xml
        end
        assert_equal(0, holidays.size)
      end

      def test__to_gcalevent
        gcal = get_cal(PRIVATE_FEED % ACCOUNT)
        period = {'start-min'=>'2001-01-01', 'start-max'=>'2001-01-31'}
        gcal.events(period).each do |event|
          event.destroy
        end
        event = When.Resource("examples/JapanHolidays.ics::Ganjitsu").to_gcalevent(gcal)
        event.save!
        holidays = [RULE0]
        gcal.events(period).each do |event|
          assert_equal(holidays.shift, event.recurrence)
        end
        assert_equal(0, holidays.size)
      end

      def test__enum_for
        holidays = HOLIDAYS2.dup
        gcal     = get_cal(PUBLIC_FEED % ['japanese', 'ja'])
        gcal.enum_for({'start-min'=>'2013-01-01', 'start-max'=>'2014-01-01'}).each do |date|
         sample = holidays.shift
         assert_equal(sample[1] + '...' + sample[2], date.to_s)
        end
        assert_equal(0, holidays.size)
      end
=begin
      def test__private_events_1
        weekly_events = WEEKLY_EVENTS.dup
        gcal   = get_cal(PRIVATE_FEED % ACCOUNT)
        period = {'start-min'=>'2014-07-01', 'start-max'=>'2014-08-01'}

        assert_equal(["canceled","confirmed"], gcal.events(period).map {|event| event.event_status})
        gcal.enum_for(period).each do |date|
          assert_equal(weekly_events.shift, date.to_s)
        end
        assert_equal(0, weekly_events.size)
      end

      def test__private_events_2
        gcal    = get_cal(PRIVATE_FEED % ACCOUNT)
        period = {'start-min'=>YEAR + '-03-01', 'start-max'=>YEAR + '-03-31'}

        gcal.events(period).each do |event|
          event.destroy
        end

        new_event = gcal.create_event
        new_event.title = "MiniTest Event"
        new_event.desc  = "MiniTest Event Description"
        new_event.where = "America/New_York"
        #new_event.st =  Time.mktime(YEAR.to_i, 3, 21, 12, 0, 0)
        #new_event.en =  Time.mktime(YEAR.to_i, 3, 22, 13, 0, 0)
        new_event.recurrence = RULE1
        new_event.save!

        gcal.events(period).each do |event|
          assert_equal([new_event.title, new_event.desc, new_event.where, RECURRENCE],
                       [event.title, event.desc, event.where, event.recurrence])
        end
        new_event.destroy
      end
=end
    else
      puts "Tests for GoogleCalendar have been skipped at line #{__LINE__} of #{__FILE__.split(/\//)[-1]}."
    end
  end
end

