# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2015-2021 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.

  Before running this script, please create "credentials.json" and "token.yaml" by 
  running quickstart.rb according to the Quick Start description at the URL below, 
  and place them in the same directory as test.rb.

    https://developers.google.com/calendar/quickstart/ruby

=end

require 'fileutils'
if FileTest.exist?("token.yaml")
  require "google/apis/calendar_v3"
  require "googleauth"
  require "googleauth/stores/file_token_store"
end

module MiniTest

  class GoogleAPI < MiniTest::TestCase

    HOLIDAYS = [
      ["2021-01-01", "New Year's Day"],
      ["2021-01-11", "Coming of Age Day"],
      ["2021-02-11", "National Foundation Day"],
      ["2021-02-23", "Emperor's Birthday"],
      ["2021-03-20", "Spring Equinox"],
      ["2021-04-29", "Shōwa Day"],
      ["2021-05-03", "Constitution Memorial Day"],
      ["2021-05-04", "Greenery Day"],
      ["2021-05-05", "Children's Day"],
      ["2021-07-22", "Sea Day"],
      ["2021-07-23", "Sports Day"],
      ["2021-08-08", "Mountain Day"],
      ["2021-08-09", "Day off for Mountain Day"],
      ["2021-09-20", "Respect for the Aged Day"],
      ["2021-09-23", "Autumn Equinox"],
      ["2021-11-03", "Culture Day"],
      ["2021-11-23", "Labor Thanksgiving Day"]
    ]

    def authorize
      client_id = Google::Auth::ClientId.from_file "credentials.json"
      scope = Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY
      token_store = Google::Auth::Stores::FileTokenStore.new file: "token.yaml"
      authorizer = Google::Auth::UserAuthorizer.new client_id, scope, token_store
      authorizer.get_credentials "default"
    end

    if FileTest.exist?("token.yaml")

      def test__enum_for
        service = Google::Apis::CalendarV3::CalendarService.new
        service.client_options.application_name = "Google Calendar API Ruby Test"
        service.authorization = authorize

        calendar = When::GoogleAPI::Calendar.list(service,
                         'en.japanese#holiday@group.v.calendar.google.com')
        assert_equal(calendar.calendar_id, 'en.japanese#holiday@group.v.calendar.google.com')
        holidays = HOLIDAYS.dup
        calendar.enum_for(When.when?('20210101/1231')).each do |date|
          assert_equal(holidays.shift, [date.to_s, date.events[0].summary])
        end
        assert_equal([], holidays)
      end
    else
      def test__enum_for
      end
      puts "Tests for GoogleCalendar have been skipped at line #{__LINE__} of #{__FILE__.split(/\//)[-1]}."
    end
  end
end

