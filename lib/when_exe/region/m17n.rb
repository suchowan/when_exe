# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2015 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  module BasicTypes
    class M17n
      #
      # 月名
      #
      # @param [Numeric] name 指定の月番号の月名を返します
      # @param [When::BasicTypes::M17n] name name 自身をそのまま返します
      # @param [String] name 最初の3文字から決定した月名を返します。
      #                      一致する月名がない場合、名前の一致するその他のM17nを探して返します。
      #
      # @return [When::BasicTypes::M17n] 月名
      #
      def self.month_name(name)
        return name if name.kind_of?(self)

        months = When.Resource('_m:Calendar::Month').child
        abbrs  = When.Resource('_m:Calendar::Abbr_Month').child
        return name > 0 ? months[name-1] : abbrs[-name-1] if name.kind_of?(Numeric)

        name   = When::EncodingConversion.to_internal_encoding(name)
        match  = name[/\A...|^..\z/]
        if match
          (months+abbrs).each do |month|
            return month if month.=~(/\A#{match}/i)
          end
        end

        ObjectSpace.each_object(self) do |object|
          return object if object.registered? && object.=~(/\A#{name}\z/)
        end

        return nil
      end

      #
      # 共通的な暦用語
      # 
      Calendar = [M17n, [
        "locale:[=en:, ja=ja:, alias]",
        "names:[Calendar=]",

        "[Intercalary %s=, *閏, zh:閏]",

        [M17n,
          "names:[Month, 月=ja:%%<月_(暦)>, /datetime/prompts/month]",
          "[January,   1月, /date/month_names/1] ",
          "[February,  2月, /date/month_names/2] ",
          "[March,     3月, /date/month_names/3] ",
          "[April,     4月, /date/month_names/4] ",
          "[May,       5月, /date/month_names/5] ",
          "[June,      6月, /date/month_names/6] ",
          "[July,      7月, /date/month_names/7] ",
          "[August,    8月, /date/month_names/8] ",
          "[September, 9月, /date/month_names/9] ",
          "[October,  10月, /date/month_names/10]",
          "[November, 11月, /date/month_names/11]",
          "[December, 12月, /date/month_names/12]"
        ],

        [M17n,
          "names:[Abbr_Month, 月略称)]",
          "[Jan,  1月, /date/abbr_month_names/1] ",
          "[Feb,  2月, /date/abbr_month_names/2] ",
          "[Mar,  3月, /date/abbr_month_names/3] ",
          "[Apr,  4月, /date/abbr_month_names/4] ",
          "[May,  5月, /date/abbr_month_names/5] ",
          "[Jun,  6月, /date/abbr_month_names/6] ",
          "[Jul,  7月, /date/abbr_month_names/7] ",
          "[Aug,  8月, /date/abbr_month_names/8] ",
          "[Sep,  9月, /date/abbr_month_names/9] ",
          "[Oct, 10月, /date/abbr_month_names/10]",
          "[Nov, 11月, /date/abbr_month_names/11]",
          "[Dec, 12月, /date/abbr_month_names/12]"
        ]
      ]]

      # Events
      EpochEvents = [M17n, [
        "locale:[=en:, ja=ja:, alias]",
        "names:[EpochEvents=]",
        "[Accession=,        代始]",
        "[FelicitousEvent=,  祥瑞]",
        "[NaturalDisaster=,  災異]",
        "[InauspiciousYear=, 革年]",
        "[Foundation=,       創業]",
        "[CalendarReform=,   改暦]",
        "[CalendarEpoch=,    暦元]"
      ]]

      # Formats
      CalendarFormats = [M17n, [
        "locale:[=]",
        "names:[CalendarFormats=]",
        "[Date=,          /date/formats/default]",
        "[DateLong=,      /date/formats/long   ]",
        "[DateShort=,     /date/formats/short  ]",
        "[DateTime=,      /time/formats/default]",
        "[DateTimeLong=,  /time/formats/long   ]",
        "[DateTimeShort=, /time/formats/short  ]",
        "[Time=,          /time/formats/time   ]",
        "[AM=,            /time/am             ]",
        "[PM=,            /time/pm             ]"
      ]]
    end
  end
end
