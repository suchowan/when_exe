# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2015 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

require 'fileutils'
require 'yaml'
require 'google/api_client'

module MiniTest

  class GoogleAPI < MiniTest::TestCase

    HOLIDAYS = [
      ["2015-01-01", "New Year's Day"                    ],
      ["2015-01-12", "Coming of Age Day"                 ],
      ["2015-02-11", "National Foundation Day"           ],
      ["2015-03-21", "Spring Equinox"                    ],
      ["2015-04-29", "Shōwa Day"                         ],
      ["2015-05-03", "Constitution Memorial Day"         ],
      ["2015-05-04", "Greenery Day"                      ],
      ["2015-05-05", "Children's Day"                    ],
      ["2015-05-06", "Constitution Memorial Day observed"],
      ["2015-07-20", "Sea Day"                           ],
      ["2015-09-21", "Respect for the Aged Day"          ],
      ["2015-09-22", "Bridge Public holiday"             ],
      ["2015-09-23", "Autumn Equinox"                    ],
      ["2015-10-12", "Sports Day"                        ],
      ["2015-11-03", "Culture Day"                       ],
      ["2015-11-23", "Labor Thanksgiving Day"            ],
      ["2015-12-23", "Emperor's Birthday"                ]
    ]

    if FileTest.exist?('google-api.yaml')

      def test__enum_for
        oauth_yaml = YAML.load_file('google-api.yaml')
        client = Google::APIClient.new(:application_name => "when_exe",
                                       :application_version => When::VERSION)
        client.authorization.client_id = oauth_yaml["client_id"]
        client.authorization.client_secret = oauth_yaml["client_secret"]
        client.authorization.scope = oauth_yaml["scope"]
        client.authorization.refresh_token = oauth_yaml["refresh_token"]
        client.authorization.access_token = oauth_yaml["access_token"]
        service = client.discovered_api('calendar', 'v3')
        calendar = When::GoogleAPI::Calendar.list(client, service,
                         'en.japanese#holiday@group.v.calendar.google.com')
        assert_equal(calendar.calendar_id, 'en.japanese#holiday@group.v.calendar.google.com')
        holidays = HOLIDAYS.dup
        calendar.enum_for(When.when?('20150101/1231')).each do |date|
          assert_equal(holidays.shift, [date.to_s, date.events[0].summary])
        end
        assert_equal([], holidays)
      end
    else
      puts "Tests for GoogleCalendar have been skipped at line #{__LINE__} of #{__FILE__.split(/\//)[-1]}."
    end
  end
end

