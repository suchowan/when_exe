# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

require 'gcalapi'

#
# gcalapi の GoogleCalendar モジュールへの機能追加
#
module GoogleCalendar

  #
  # gcalapi の GoogleCalendar::Event クラスへの機能追加
  #
  class Event
    # 繰り返しイベントの定義
    # @return [Array<String>]
    attr_accessor :recurrence

    Event::ATTRIBUTES_MAP["recurrence"] = { "element" => "gd:recurrence"}

    # @private
    alias :_instance_to_xml :instance_to_xml

    # @private
    def instance_to_xml
      _instance_to_xml
      @xml.root.elements[recurrence ? "gd:when" : "gd:recurrence"].remove
    end

    # When::V::Event オブジェクトへの変換
    #
    # @return [When::V::Event]
    #
    def to_vevent
      options = {'summary'=>@title, 'description'=>@desc, 'location'=>@where}
      if @recurrence
        @recurrence.each_line do |line|
          options[$1.downcase] ||= $2 if line =~ /\A(DTSTART|DTEND|RRULE).(.+)\z/i
        end
      else
        options.update({'dtstart'=>When.when?(@st), 'dtend'=>When.when?(@en)})
      end
      When::V::Event.new(options)
    end
    alias :vevent :to_vevent

    # イベントのステータス
    #
    # @return [String]
    #   [ 'confirmed' - 有効 ]
    #   [ 'canceled'  - 無効 ]
    #
    def event_status
      @xml.root.elements['gd:eventStatus'].attributes['value'][/[^.]+\z/]
    end
  end

  #
  # gcalapi の GoogleCalendar::Calendar クラスへの機能追加
  #
  class Calendar
    # イベントを順に取り出す enumerator
    #
    # @param [Hash] conditions
    # @option conditions [String, When::TM::TemporalPosition] 'start-min' 最初のイベント開始日時(省略時は現在時刻)
    # @option conditions [String, When::TM::TemporalPosition] 'start-max' 最後のイベント開始日時(省略時は制限なし)
    # @option conditions [String] 'sortorder'
    #   [ 'a' - asend(省略時) ]
    #   [ 'd' - desend ]
    #
    # @return [Enumerator]
    #
    def enum_for(conditions={})
      conditions['start-min'] ||= When.now
      conditions['sortorder'] ||= 'a'
      conditions['orderby']     = 'starttime'
      direction = (conditions['sortorder'] == 'd') ? :reverse : :forward
      first     = When.when?(conditions['start-min'])
      conditions['start-min']   = (When::Gregorian ^ first).to_s
      if conditions['start-max']
        last       = When.when?(conditions['start-max'])
        inner_args = [first...last]
        conditions['start-max'] = (When::Gregorian ^ last).to_s
      else
        inner_args = [first, direction]
      end

      confirmed = []
      canceled  = []
      self.events(conditions).each do |event|
        case event.event_status
        when 'canceled' ; canceled  << event
        else            ; confirmed << event
        end
      end
      outer_args = [first, direction]
      outer_args << {:exevent => canceled.map {|event| event.to_vevent}} if canceled.length > 0

      When::Parts::Enumerator::Integrated.new(self, confirmed.map {|event|
        event.to_vevent.enum_for(*inner_args)
      }, *outer_args)
    end
    alias :to_enum :enum_for
  end
end

module When::V
  class Event

    # GoogleCalendar::Event オブジェクトへの変換
    #
    # @param [GoogleCalendar::Calendar] cal
    #
    # @return [GoogleCalendar::Event]
    #
    def to_gcalevent(cal)
      event = cal.create_event
      event.title = summary     if respond_to?(:summary)
      event.desc  = description if respond_to?(:description)
      event.where = location    if respond_to?(:location)
      if rrule.size == 0
        event.st  = dtstart.to_time
        event.en  = dtend.to_time
      else
        event.recurrence =
          (['RRULE:' + property['rrule'][0].object] +
           ['dtstart', 'dtend'].map {|key|
             value = property[key].attribute['.']
             key.upcase + (value =~ /=/ ? ';' : ':') + value
           }).join("\n") + "\n"
      end
      event
    end
    alias :gcalevent :to_gcalevent
  end
end
