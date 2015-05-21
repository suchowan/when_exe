# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2015 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end


#
# gcalapi の GoogleCalendar モジュールへの機能追加
#
module When::GoogleAPI

  #
  # GoogleAPI の Calendar に対応した Calendar クラス
  #
  class Calendar

    # Calendar に属する Event
    #
    # @return [Array<When::V::Event>]
    #
    attr_reader :events

    # イベントを順に取り出す enumerator
    #
    # @param [Array] args 個々のイベントの引数 (see {When::V::Event#each})
    #
    # @return [Enumerator]
    #
    def enum_for(*args)
      When::Parts::Enumerator::Integrated.new(self, @events.map {|event| event.enum_for(*args)}, *args)
    end
    alias :to_enum :enum_for

    #
    # GoogleAPI の Calendar を生成する
    #
    # @param [Google::APIClient] client
    # @param [Google::APIClient::API] service
    # @param [String] calendar_id
    #
    def initialize(client, service, calendar_id)
      @events = []
      result  = client.execute({:api_method => service.events.list,
                                :parameters => {'calendarId' => calendar_id}})
      loop do
        @events += result.data.items.map {|event|
          props = event.to_hash
          next nil unless props['status'] == 'confirmed'
          When::V::Event.new(When::V::Event.gcal2ical(props))
        }.compact
        page_token = result.data.next_page_token
        break unless page_token
        result = client.execute({:api_method => service.events.list,
                                 :parameters => {'calendarId' => calendar_id,
                                                 'pageToken'  => page_token}})
      end
    end
  end
end

class When::V::Event

  class << self
    #
    # GoogleCalendar のプロパティを iCalendar のプロパティに変換する
    #
    # @param [Hash] gprops GoogleCalendar のプロパティ
    #
    # @return [Hash] iCalendar のプロパティ
    #
    def gcal2ical(gprops)
      iprops = {}
      gprops.each_pair do |key, value|
        case key
        when 'summary'
          iprops['summary'] = value
        when 'start', 'end'
          date  = 'VALUE=DATE'
          date += '-TIME' if value.key?('dateTime')
          date += ';TZID=' + value['timeZone'] if value.key?('timeZone')
          date += ':' + (value['date'] || value['dateTime'])
          iprops['dt' + key] = date
        when 'recurrence'
          value.map do |line|
            tag, rule = line.split(':', 2)
            tag.downcase!
            if iprops.key?(tag)
              iprops[tag] = Array(iprops[tag]) + [rule]
            else
              iprops[tag] = rule
            end
          end
        when 'iCalUID'
          iprops['uid'] = value
        end
      end
      iprops
    end
  end
end
