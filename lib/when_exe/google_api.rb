# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2015-2021 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

#
# GoogleAPI の Calendar API v3 への対応
#
#   see {Ruby Quickstart https://developers.google.com/calendar/quickstart/ruby}
#   see {Simple REST client for version V3 of the Calendar API https://googleapis.dev/ruby/google-apis-calendar_v3/v0.1.0/}
#
module When::GoogleAPI

  #
  # GoogleAPI の Calendar API v3 に対応した Calendar クラス
  #
  class Calendar

    # Calendar API のインスタンス
    #
    # @return [Google::Apis::CalendarV3::CalendarService]
    #
    attr_reader :service

    # calendar の id
    #
    # @return [String]
    #
    attr_reader :calendar_id

    # Calendar に属する Event
    #
    # @return [Array<When::V::Event>]
    #
    attr_reader :events

    class << self
      #
      # GoogleAPI の Calendar を生成する
      #
      # @param [Google::Apis::CalendarV3::CalendarService] service
      # @param [String] calendar_id
      #
      def list(service, calendar_id)
        events = []
        result = service.list_events(calendar_id)
        loop do
          events += result.items.map {|event| event.to_h}
          page_token = result.next_page_token
          break unless page_token
          result = service.list_events(calendar_id, page_token: page_token)
        end
        calendar = new(events)
        calendar.instance_variable_set(:@service, service)
        calendar.instance_variable_set(:@calendar_id, calendar_id)
        calendar
      end
    end

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
    # Calendar インスタンスを生成する
    #
    # @param [Array<Hash>] events
    #
    def initialize(events)
      @events = events.map {|event|
        next nil unless event[:status] == 'confirmed'
        When::V::Event.new(event)
      }.compact
    end
  end
end

class When::V::Event

  # イベントのプロパティ
  #
  # @return [Hash]
  #
  attr_reader :google_api_props

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
        when :start, :end
          date  = 'VALUE=DATE'
          if value.key?(:date)
            date += ':' + value[:date].strftime('%Y%m%d')
          else
            date += '-TIME'
            date += ':' + value[:date_time].strftime('%Y%m%dT%H%M%S')
            date += value[:date_time].strftime('%z') unless value[:time_zone]
          end
          date.sub!(':', ";TZID=#{value[:time_zone]}:") if value.key?(:time_zone)
          iprops['dt' + key.to_s] = date
        when :recurrence
          value.map do |line|
            tag, rule = line.split(':', 2)
            tag.downcase!
            if iprops.key?(tag)
              iprops[tag] = Array(iprops[tag]) + [rule]
            else
              iprops[tag] = rule
            end
          end
        when :i_cal_uid
          iprops['uid'] = value
        when Symbol
          iprops[key.to_s] = value
        end
      end
      iprops
    end
  end

  private

  # Hash からの属性読み込み
  def _parse_from_code(options)
    if options.key?(:start)
      @google_api_props = options
      options = self.class.gcal2ical(options)
    end
    super(options)
  end
end
