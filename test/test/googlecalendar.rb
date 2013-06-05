# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2013 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module Test

  class GoogleCalendar < Test::Unit::TestCase

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

    HOLIDAYS = [
      ["元日",         "2012-01-01T00:00:00.00+09:00", "2012-01-02T00:00:00.00+09:00"],
      ["成人の日",     "2012-01-09T00:00:00.00+09:00", "2012-01-10T00:00:00.00+09:00"],
      ["建国記念の日", "2012-02-11T00:00:00.00+09:00", "2012-02-12T00:00:00.00+09:00"],
      ["昭和の日",     "2012-04-29T00:00:00.00+09:00", "2012-04-30T00:00:00.00+09:00"],
    # ["振替休日",     "2012-04-30T00:00:00.00+09:00", "2012-05-01T00:00:00.00+09:00"],
      ["憲法記念日",   "2012-05-03T00:00:00.00+09:00", "2012-05-04T00:00:00.00+09:00"],
      ["みどりの日",   "2012-05-04T00:00:00.00+09:00", "2012-05-05T00:00:00.00+09:00"],
      ["こどもの日",   "2012-05-05T00:00:00.00+09:00", "2012-05-06T00:00:00.00+09:00"],
      ["海の日",       "2012-07-16T00:00:00.00+09:00", "2012-07-17T00:00:00.00+09:00"],
      ["敬老の日",     "2012-09-17T00:00:00.00+09:00", "2012-09-18T00:00:00.00+09:00"],
    # ["秋分の日",     "2012-09-22T00:00:00.00+09:00", "2012-09-23T00:00:00.00+09:00"],
      ["体育の日",     "2012-10-08T00:00:00.00+09:00", "2012-10-09T00:00:00.00+09:00"],
      ["文化の日",     "2012-11-03T00:00:00.00+09:00", "2012-11-04T00:00:00.00+09:00"],
      ["勤労感謝の日", "2012-11-23T00:00:00.00+09:00", "2012-11-24T00:00:00.00+09:00"],
      ["天皇誕生日",   "2012-12-23T00:00:00.00+09:00", "2012-12-24T00:00:00.00+09:00"],
    # ["振替休日",     "2012-12-24T00:00:00.00+09:00", "2012-12-25T00:00:00.00+09:00"]
    ]

    WEEKLY_EVENTS = [
      "2012-03-08T08:30:00+09:00...2012-03-08T09:30:00+09:00",
      "2012-03-15T08:30:00+09:00...2012-03-15T09:30:00+09:00",
      "2012-03-22T08:30:00+09:00...2012-03-22T09:30:00+09:00",
      "2012-03-29T08:30:00+09:00...2012-03-29T09:30:00+09:00"
    ]

    def get_cal(feed)
      ::GoogleCalendar::Calendar::new(::GoogleCalendar::Service.new("#{ACCOUNT}@gmail.com", PASSWORD), feed)
    end

    def test_nothing
    end

    if const_defined?(:PASSWORD) && Object.const_defined?(:GoogleCalendar)
      def test__to_vevent
        holidays = HOLIDAYS.dup
        gcal     = get_cal(PUBLIC_FEED % ['japanese', 'ja'])
        gcal.events({'start-min'=>'2012-01-01', 'start-max'=>'2013-01-01',
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
        holidays = HOLIDAYS.dup
        gcal     = get_cal(PUBLIC_FEED % ['japanese', 'ja'])
        gcal.enum_for({'start-min'=>'2012-01-01', 'start-max'=>'2013-01-01'}).each do |date|
          sample = holidays.shift
          assert_equal(sample[1] + '...' + sample[2], date.to_s)
        end
        assert_equal(0, holidays.size)
      end

=begin
      def test__eprivate_events_1
        weekly_events = WEEKLY_EVENTS.dup
        gcal   = get_cal(PRIVATE_FEED % ACCOUNT)
        period = {'start-min'=>'2012-03-01', 'start-max'=>'2012-03-31'}

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
        new_event.title = "Test Event"
        new_event.desc  = "Test Event Description"
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

