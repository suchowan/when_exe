# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

begin
  require 'rubygems'
rescue LoadError
end
begin
  gem 'tzinfo'
  autoload :TZInfo, 'tzinfo'
rescue LoadError, NoMethodError
end
begin
  gem 'gcalapi'
  autoload :GoogleCalendar, 'when_exe/googlecalendar'
rescue LoadError, NoMethodError
end

autoload :URI,       'uri'
autoload :OpenURI,   'open-uri'
autoload :OpenSSL,   'openssl'
autoload :FileUtils, 'fileutils'
autoload :JSON,      'json'
autoload :REXML,     'rexml/document'
autoload :Mutex,     'thread' unless Object.const_defined?(:Mutex)

$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

#
# A multicultural and multilingualized calendar library based on ISO 8601, ISO 19108 and RFC 5545
#
module When

  class << self

    #
    # マルチスレッド対応の場合 true
    #
    # @return [Boolean]
    #
    attr_reader :multi_thread

    # Initializations
    #
    # @param [Hash] options
    # @option options [When::Parts::Timezone::Base] :local        デフォルトの地方時
    # @option options [When::Coordinates::Spatial]  :location     デフォルトの空間位置
    # @option options [When::TM::IntervalLength]    :until        V::Event::Enumerator の until
    # @option options [Hash{String=>String}]        :alias        Locale の読替パターン         ({ 読替前のlocale=>読替後のlocale })
    # @option options [Hash{String=>String}]        :unification  漢字の包摂パターン            ({ 包摂前の文字列=>包摂後の文字列 })
    # @option options [Array<String>]               :order        CalendarEra の検索順序        ([ IRI of When::TM::CalendarEra ])
    # @option options [Hash{String=>Array, String}] :format       strftime で用いる記号の定義   ({ 記号=>[ 書式,項目名 ] or 記号列 })
    # @option options [Array<Array>]                :leap_seconds 閏秒の挿入記録                ([ [JD, TAI-UTC, (MJD, OFFSET)] ])
    # @option options [Boolean]                     :multi_thread マルチスレッド対応            (true: 対応, false/nil: 非対応)
    # @option options [Boolean]                     :direct       '_' で終わるメソッドをキャッシュせずに毎回計算するか否か
    # @option options [Hash{Symbol=>boolean}]       :escape       毎回 method_missing を発生させるメソッドを true にする
    #
    # @return [void]
    #
    # @note
    #   本メソッドでマルチスレッド対応の管理変数の初期化を行っている。
    #   このため、本メソッド自体および本メソッドから呼んでいる各クラスの _setup_ メソッドはスレッドセーフでない。
    #
    def _setup_(options={})
      @multi_thread = options[:multi_thread]
      Parts::MethodCash._setup_(options[:direct], options[:escape])
      Parts::Resource._setup_
      Parts::Locale._setup_(options)
      Coordinates::Spatial._setup_(options[:location])
      TM::CalendarEra._setup_(options[:order])
      TM::Calendar._setup_
      TM::Clock._setup_(options[:local])
      TM::TemporalPosition._setup_(options[:format])
      V::Event._setup_(options[:until])
      V::Timezone._setup_
      Parts::Timezone._setup_
      TimeStandard._setup_(options[:leap_seconds])
    end
  end

  #
  # when_exe 用 International Resource Identifier
  #
  SourceURI = "http://hosi.org/When/"

  #
  # ライブラリのあるディレクトリ
  #
  RootDir   = File.dirname(__FILE__).sub(/\/[^\/]*$/,'')

  require 'when_exe/version'
  require 'when_exe/parts/enumerator'
  require 'when_exe/parts/locale'
  require 'when_exe/parts/resource'
  require 'when_exe/parts/geometric_complex'
  require 'when_exe/parts/timezone'
  require 'when_exe/parts/method_cash'
  require 'when_exe/core/compatibility'
  require 'when_exe/basictypes'
  require 'when_exe/ephemeris'
  require 'when_exe/tmduration'
  require 'when_exe/coordinates'
  require 'when_exe/icalendar'
  require 'when_exe/tmobjects'
  require 'when_exe/timestandard'
  require 'when_exe/tmposition'
  require 'when_exe/tmreference'
  require 'when_exe/calendartypes'
  require 'when_exe/locales/locales'
  require 'when_exe/region/m17n'
  require 'when_exe/region/residue'
  require 'when_exe/region/christian'
  require 'when_exe/inspect'

  #
  # Module Constants
  #

  DurationP1D = TM::PeriodDuration.new([0,0,1])
  DurationP1W = TM::PeriodDuration.new([0,0,7])
  DurationP1M = TM::PeriodDuration.new([0,1,0])
  DurationP1Y = TM::PeriodDuration.new([1,0,0])
  TimeValue   = TM::IndeterminateValue

  PlusInfinity  = TM::TemporalPosition.new({:indeterminated_position=>TimeValue::Max})
  MinusInfinity = TM::TemporalPosition.new({:indeterminated_position=>TimeValue::Min})

  UTF8  = '.UTF-8'
  W31J  = '.Windows-31J'
  EUCJP = '.eucJP'

  class BasicTypes::M17n
    autoload :JapaneseTerms,         'when_exe/region/japanese'
    autoload :ChineseTerms,          'when_exe/region/chinese'
    autoload :YiTerms,               'when_exe/region/chinese'
    autoload :TibetanTerms,          'when_exe/region/tibetan'
    autoload :ThaiTerms,             'when_exe/region/thai'
    autoload :BalineseTerms,         'when_exe/region/balinese'
    autoload :JavaneseTerms,         'when_exe/region/javanese'
    autoload :IndianTerms,           'when_exe/region/indian'
    autoload :IranianTerms,          'when_exe/region/iranian'
    autoload :IslamicTerms,          'when_exe/region/islamic'
    autoload :JewishTerms,           'when_exe/region/jewish'
    autoload :RomanTerms,            'when_exe/region/roman'
    autoload :ChristianTerms,        'when_exe/region/christian'
    autoload :FrenchTerms,           'when_exe/region/french'
    autoload :WorldTerms,            'when_exe/region/world'
    autoload :ShireTerms,            'when_exe/region/shire'
    autoload :MartianTerms,          'when_exe/region/martian'
    autoload :WikipediaLinks,        'when_exe/locales/links'
  end

  module CalendarTypes
    autoload :Japanese,              'when_exe/region/japanese'
    autoload :ChineseSolar,          'when_exe/region/chinese'
    autoload :ChineseLuniSolar,      'when_exe/region/chinese'
    autoload :Chinese,               'when_exe/region/chinese'
    autoload :Yi,                    'when_exe/region/chinese'
    autoload :Tibetan,               'when_exe/region/tibetan'
    autoload :ThaiB,                 'when_exe/region/thai'
    autoload :ThaiC,                 'when_exe/region/thai'
    autoload :Tenganan,              'when_exe/region/balinese'
    autoload :Pranatamangsa,         'when_exe/region/javanese'
    autoload :IndianNationalSolar,   'when_exe/region/indian'
    autoload :HinduSolar,            'when_exe/region/indian'
    autoload :HinduLuniSolar,        'when_exe/region/indian'
    autoload :SolarHejri,            'when_exe/region/iranian'
    autoload :Bahai,                 'when_exe/region/bahai'
    autoload :TabularIslamic,        'when_exe/region/islamic'
    autoload :EphemerisBasedIslamic, 'when_exe/region/islamic'
    autoload :Jewish,                'when_exe/region/jewish'
    autoload :JulianA,               'when_exe/region/roman'
    autoload :JulianB,               'when_exe/region/roman'
    autoload :JulianC,               'when_exe/region/roman'
    autoload :Roman,                 'when_exe/region/roman'
    autoload :FrenchRepublican,      'when_exe/region/french'
    autoload :World,                 'when_exe/region/world'
    autoload :LongCount,             'when_exe/region/mayan'
    autoload :Shire,                 'when_exe/region/shire'
    autoload :ShireG,                'when_exe/region/shire'
    autoload :Darian,                'when_exe/region/martian'

    _time_systems = {
      'LMT' => nil,                       # Local Mean Time
      'LAT' => nil,                       # Local Apparent Time
      'THS' => nil,                       # Temporal Hour System
      'MTC' => 'when_exe/region/martian', # Martian Time, Coordinated
    }
    TimeSystems = _time_systems.keys.join('|')
    _time_systems.each_pair do |key, required|
      autoload key.to_sym, required if required
    end

    class CalendarNote
      autoload :SolarTerms,          'when_exe/region/ephemeric_notes'
      autoload :LunarPhases,         'when_exe/region/ephemeric_notes'
      autoload :EphemericNote,       'when_exe/region/ephemeric_notes'
      autoload :JapaneseNote,        'when_exe/region/japanese_notes'
      autoload :BalineseNote,        'when_exe/region/balinese'
      autoload :RomanNote,           'when_exe/region/roman'
      autoload :WorldWeek,           'when_exe/region/world'
      autoload :ShireWeek,           'when_exe/region/shire'

      DefaultNotes   = [['_m:CalendarTerms::Month'], ['CommonResidue::Week']]
      JulianDayNotes = [['CommonResidue::Week', 'CommonResidue::干支']]
      BahaiNotes     = [['Bahai::YearName'], ['_m:BahaiTerms::Month'], ['CommonResidue::Week']]
      JavaneseNotes  = [['Javanese::Windu'], ['_m:CalendarTerms::Month'],
                        ['Javanese::Pasaran', 'Javanese::Paringkelan', 'Javanese::Week', 'Javanese::Wuku']]
      ChineseNotes   = [['CommonResidue::干支'], ['_m:CalendarTerms::Month'], ['CommonResidue::Week', 'CommonResidue::干支']]
      TibetanNotes   = [['Tibetan::干支'], ['_m:CalendarTerms::Month'], ['CommonResidue::Week']]
      YiNotes        = [['Yi::YearName'], ['_m:CalendarTerms::Month'], ['CommonResidue::Week']]
      MayanNotes     = [{},['Mayan#{?Epoch=Epoch}::Trecena', 'Mayan#{?Epoch=Epoch}::Tzolk\'in',
                            'Mayan#{?Epoch=Epoch}::Lords_of_the_Night', 'Mayan#{?Epoch=Epoch}::Haab\'']]
    end
  end

  module Coordinates
    autoload :Tibetan,               'when_exe/region/tibetan'
    autoload :Yi,                    'when_exe/region/chinese'
    autoload :Javanese,              'when_exe/region/javanese'
    autoload :IndianCities,          'when_exe/region/indian'
    autoload :Bahai,                 'when_exe/region/bahai'
    autoload :Roman,                 'when_exe/region/roman'
    autoload :Mayan,                 'when_exe/region/mayan'

    # default index for day coordinate
    DefaultDayIndex = Coordinates::Index.new

    # default indices for date coordinates
    DefaultDateIndices = [
      Coordinates::Index.new({:unit=>12}),
      DefaultDayIndex
    ]

    # default indices for time coordinates
    DefaultTimeIndices = [
      Coordinates::Index.new({:base=>0, :unit=>24}),
      Coordinates::Index.new({:base=>0, :unit=>60}),
      Coordinates::Index.new({:base=>0, :unit=>60})
    ]
  end

  module TM
    class OrdinalReferenceSystem
      autoload :GeologicalAge,           'when_exe/region/geologicalage'
    end

    class CalendarEra
      autoload :Japanese,                'when_exe/region/japanese'
      autoload :JapanesePrimeMinister,   'when_exe/region/japanese'
      autoload :NihonKoki,               'when_exe/region/nihon_shoki'
      autoload :NihonShoki,              'when_exe/region/nihon_shoki'
      autoload :JapaneseSolarSeries,     'when_exe/region/japanese_notes'
      autoload :JapaneseLuniSolarSeries, 'when_exe/region/japanese_notes'
      autoload :Chinese,                 'when_exe/region/chinese_epoch'
      autoload :ChineseSolarSeries,      'when_exe/region/chinese_epoch'
      autoload :ChineseLuniSolarSeries,  'when_exe/region/chinese_epoch'
      autoload :Ryukyu,                  'when_exe/region/ryukyu'
      autoload :Korean,                  'when_exe/region/korean'
      autoload :Vietnamese,              'when_exe/region/vietnamese'
      autoload :Manchurian,              'when_exe/region/far_east'
      autoload :Rouran,                  'when_exe/region/far_east'
      autoload :Gaochang,                'when_exe/region/far_east'
      autoload :Yunnan,                  'when_exe/region/far_east'
    # autoload :Tibetan,                 'when_exe/region/tibetan'
      autoload :BalineseLuniSolar,       'when_exe/region/balinese'
      autoload :JavaneseLunar,           'when_exe/region/javanese'
      autoload :IndianNationalSolar,     'when_exe/region/indian'
      autoload :Iranian,                 'when_exe/region/iranian'
      autoload :Hijra,                   'when_exe/region/islamic'
      autoload :Jewish,                  'when_exe/region/jewish'
      autoload :Roman,                   'when_exe/region/roman'
      autoload :Julian,                  'when_exe/region/roman'
      autoload :Pope,                    'when_exe/region/pope'
      autoload :Byzantine,               'when_exe/region/christian'
      autoload :French,                  'when_exe/region/french'
      autoload :World,                   'when_exe/region/world'
      autoload :LongCount,               'when_exe/region/mayan'

      # Defualt search path for Epochs and Eras
      DefaultEpochs = ['Common',     'ModernJapanese',
                       'IndianNationalSolar',  'Iranian',   'Hijra', 'Jewish',
                       'Roman',      'Byzantine', 'French', 'World', 'LongCount',
                       'BalineseLuniSolar',  'JavaneseLunar',
                       'Japanese',   'JapanesePrimeMinister', 'NihonKoki', 'NihonShoki',
                       'Chinese',    'Ryukyu',  'Vietnamese', 'Korean',
                       'JapaneseSolarSeries', 'JapaneseLuniSolarSeries',
                       'ChineseSolarSeries',  'ChineseLuniSolarSeries',
                       'Manchurian', 'Rouran',  'Gaochang',   'Yunnan', # 'Tibetan',
                       'Pope' ]

      # Defualt events for Epochs and Eras
      DefaultEvents = Hash[*([['@A',  'Accession'       ],
                              ['@FE', 'FelicitousEvent' ],
                              ['@ND', 'NaturalDisaster' ],
                              ['@IY', 'InauspiciousYear'],
                              ['@F',  'Foundation'      ],
                              ['@CR', 'CalendarReform'  ]].map {|e|
        [e[0], When::Parts::Resource._instance('EpochEvents::'+e[1], '_m:')]
      }.flatten)]

      # Common Era
      Common = [{}, self, [
        'namespace:[en=http://en.wikipedia.org/wiki/]',
        'area:Common#{?Reform=Reform}',
        ['[BeforeCommonEra=en:BCE_(disambiguation),*alias:BCE]0.1.1'],
        ['[CommonEra=en:Common_Era,*alias:CE]1.1.1', 'Calendar Epoch', '01-01-01^Julian'],
        ['[CommonEra=en:Common_Era,*alias:CE]#{Reform:1582.10.15}', 'Calendar Reform', '#{Reform:1582.10.15}^Gregorian']
      ]]

      # Modern Japanese Eras after the calendar reform to the Gregorian Calendar
      ModernJapanese = [self, [
        'namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/]',
        'area:[ModernJapanese]',
        ['[M=,alias:明=ja:明治]6.01.01', '@CR', '1873-01-01^Gregorian?note=DefaultNotes'],
        ['[T=,alias:大=ja:大正]1.07.30', '@A',  '1912-07-30'],
        ['[S=,alias:昭=ja:昭和]1.12.25', '@A',  '1926-12-25'],
        ['[H=,alias:平=ja:平成]1.01.08', '@A',  '1989-01-08']
      ]]
    end
  end

  #
  # Module Functions
  #
  module_function

  # Generation of Temporal Objetct, duration or When::Parts::GeometricComplex
  #
  # @param [String] specification  When.exe Standard Representation として解釈して生成する
  # @param [Numeric] specification ユリウス日として解釈して生成する
  # @param [Array] specification   要素を個別に解釈して生成したオブジェクトのArrayを返す
  # @param [When::TM::TemporalPosition, When::Parts::GeometricComplex] specification specificationをそのまま返す
  # @param [When::TM::TemporalPosition] specification specification.any_otherを返す
  #
  # @param [Hash] options 暦法や時法などの指定 (see {When::TM::TemporalPosition._instance})
  #
  # @return [When::TM::TemporalPosition, When::TM::Duration, When::Parts::GeometricComplex or Array<them>]
  #
  def when?(specification, options={})

    # フォーマットごとの処理
    case specification
    when TM::TemporalPosition, Parts::GeometricComplex ; specification
    when TM::Position ; specification.any_other
    when Array        ; begin options = TM::TemporalPosition._options(options) ; specification.map {|e| when?(e, options)} end
    when /^today$/i   ; today(options)
    when /^now$/i     ; now(options)
    when /[\n\r]+/    ; when?(specification.split(/[\n\r]+/), options)
    when String       ; TM::TemporalPosition._instance(specification, options)
    when Numeric      ; TM::JulianDate.new(+specification, TM::TemporalPosition._options(options))
    else              ; Calendar(options[:frame] || 'Gregorian').jul_trans(specification, options)
    end
  end

  # When::TM::TemporalPosition の生成
  #
  # @overload TemporalPosition(*args, options={})
  #   @param [String or [String, Integer], Numeric, ...] args
  #     [String]                 年号
  #     [Array<String, Integer>] 年号と 0 年の通年
  #     [Numeric]                年月日時分秒(途中で打ち切り可)
  #   @param [Hash] options      暦法や時法などの指定
  #   @option options [Symbol] :invalid
  #     [:raise     日時が存在しない場合例外発生              ]
  #     [:check     日時が存在しない場合 nil を返す           ]
  #     [その他/nil 日時が存在することを確認しない(デフォルト)]
  #   @see When::TM::TemporalPosition._instance
  #
  # @return [When::TM::TemporalPosition]
  # @raise [ArgumentError]
  #   options[ :invalid ] が :raise で、日時が存在しない場合
  #
  def TemporalPosition(*args)
    # 引数の解釈
    options  = args[-1].kind_of?(Hash) ? args.pop.dup : {}
    validate = options.delete(:invalid)
    options  = TM::TemporalPosition._options(options)
    options[:frame]  ||= 'Gregorian'
    options[:frame]    = Resource(options[:frame], '_c:') if options[:frame].kind_of?(String)
    options[:era_name] = args.shift if args[0].kind_of?(String) || args[0].kind_of?(Array)

    # 時間位置の生成
    date = Array.new(options[:frame].indices.length+1) {args.shift}
    if (args.length > 0)
      options[:clock] ||= TM::Clock.local_time
      time = Array.new(options[:clock].indices.length) {args.shift}
      position = TM::DateAndTime.new(date, time.unshift(0), options)
    else
      position = TM::CalDate.new(date, options)
    end
    return position unless [:raise, :check].include?(validate)

    # 時間位置の存在確認
    date[0] = -date[0] if position.calendar_era_name && position.calendar_era_name[2] # 紀元前
    date.each_index do |i|
      break unless date[i]
      next if Coordinates::Pair._force_pair(date[i]) == Coordinates::Pair._force_pair(position.cal_date[i])
      return nil if validate == :check
      raise ArgumentError, "Specified date not found: #{date}"
    end
    return position unless time
    time.each_index do |i|
      break unless time[i]
      next if Coordinates::Pair._force_pair(time[i]) == Coordinates::Pair._force_pair(position.clk_time.clk_time[i])
      return nil if validate == :check
      raise ArgumentError, "Specified time not found: #{time}"
    end
    return position
  end

  # 指定日時に対応する When::TM::TemporalPosition の生成
  # (When::TM::DateAndTime of specified Time)
  #
  # @param [::Time] time    変換元の日時のTimeオブジェクト
  # @param [Float]  time    1970-01-01T00:00:00Z からの経過秒数
  # @param [Hash]   options 暦法や時法などの指定
  # @see When::TM::TemporalPosition._instance
  #
  # @return [When::TM::DateAndTime]
  #
  def at(time, options={})
    options = options._attr if options.kind_of?(TM::TemporalPosition)
    options[:frame] ||= 'Gregorian'
    options[:frame]   = Resource(options[:frame], '_c:') if options[:frame].kind_of?(String)
    options[:clock] ||= Clock(time.utc_offset) if time.kind_of?(::Time)
    jdt  = TM::JulianDate.universal_time(time.to_f * TM::IntervalLength::SECOND, {:frame=>TM::Clock.get_clock(options)})
    options[:clock]   = jdt.frame
    date = options[:frame].jul_trans(jdt, options)
    date = TM::CalDate.new(date.cal_date, options) if options[:precision] &&
                                                      options[:precision] <= DAY
    return date
  end

  # 現在日時に対応する When::TM::TemporalPosition の生成
  # (When::TM::DateAndTime of now)
  # @note メソッド実行時の「現在日時」である。@indeterminated_position は設定しないので自動的に日時が進むことはない
  #
  # @param [Hash]   options 暦法や時法などの指定
  # @see When::TM::TemporalPosition._instance
  #
  # @return [When::TM::DateAndTime]
  #
  def now(options={})
    When.at(Time.now, options)
  end

  # 本日に対応する When::TM::CalDate の生成
  # (When::TM::CalDate of today)
  # @note メソッド実行時の「本日」である。@indeterminated_position は設定しないので自動的に日時が進むことはない
  # @note options で時間帯を指定しても「本日」の決定に使用するのみで、戻り値には反映されない
  #
  # @param [Hash]   options 暦法や時法などの指定
  # @see When::TM::TemporalPosition._instance
  #
  # @return [When::TM::CalDate]
  #
  def today(options={})
    now(options.merge({:precision=>DAY}))
  end

  # When::TM::Duration の生成
  #
  # @param [String] period  When.exe Standard Representation として解釈して生成する
  # @param [Numeric] period When::TM::IntervalLength::SYSTEM 単位の値として解釈して生成する
  # @param [Array] period   要素を個別に解釈して生成したオブジェクトのArrayを返す
  # @param [When::TM::Duration] period  処理を行わず、そのまま返す
  # @param [Hash] options 現時点では未使用
  #
  # @return [When::TM::Duration or Array<them>]
  #
  def Duration(period, options={})
    case period
    when Array
      period.map {|e| Duration(e, options)}

    when TM::Duration
      period

    when 0
      TM::IntervalLength.new(0, 'day')

    when Numeric
      [TM::Duration::YEAR, TM::Duration::MONTH,  TM::Duration::WEEK, TM::Duration::DAY,
       TM::Duration::HOUR, TM::Duration::MINUTE, TM::Duration::SECOND].each do |unit|
        div, mod = period.divmod(unit)
        return TM::IntervalLength.new(div, TM::Duration::Unit.invert[unit]) if mod == 0
      end
      TM::IntervalLength.new(period, 'system')

    when String
      # IntervalLength
      args = TM::IntervalLength._to_array(period)
      return TM::IntervalLength.new(*args) if args

      # PeriodDuration
      sign, *args = TM::PeriodDuration._to_array(period)
      raise TypeError, "Argument 'period' is not a Duration" unless (sign)
      args << options
      duration = TM::PeriodDuration.new(*args)
      return (sign >= 0) ? duration : -duration

    else
      nil
    end
  end

  # When::TM::Calendar の生成/参照
  #
  # @param [String] calendar 暦法を表す文字列
  #
  # @return [When::TM::Calendar] calendar に対応する When::TM::Calendar オブジェクト
  #
  def Calendar(calendar)
    Parts::Resource._instance(calendar, '_c:')
  end

  # When::CalendarTypes::CalendarNote の生成/参照
  #
  # @param [String] notes 暦注リストを表す文字列
  #
  # @return [When::CalendarTypes::CalendarNote] notes に対応する When::CalendarTypes::CalendarNote オブジェクト
  #
  def CalendarNote(notes)
    Parts::Resource._instance(notes, '_n:')
  end

  # When::TM::CalendarEra の生成/参照
  #
  # @param [String] era 暦年代を表す文字列
  #
  # @return [When::TM::CalendarEra] era に対応する When::TM::CalendarEra オブジェクト
  #
  def CalendarEra(era)
    Parts::Resource._instance(era, '_e:')
  end

  # When::TM::CalendarEra の検索
  #
  # @overload era(key, epoch=nil, reverse=nil, options={})
  #   @param [String, Regexp] key     検索する暦年代または、暦年代にマッチする正規表現
  #   @param [Integer]        epoch   年数を昇順にカウントする方式での暦元(0年)の通年(デフォルトは nil - 指定なし)
  #   @param [Integer]        reverse 年数を降順にカウントする方式での暦元(0年)の通年(デフォルトは nil - 指定なし)
  #   @param [Hash] options
  #   @option options [String]  :area   暦年代の使用地域の指定(デフォルトは nil - 指定なし)
  #   @option options [String]  :period 暦年代の使用時代の指定(デフォルトは nil - 指定なし)
  #   @option options [Integer] :count  何件ヒットするまで検索するかを指定(デフォルトは 1件)
  #   @option options [String]  the_others 例えば When::TM::CalendarEra オブジェクトの epoch_of_use に 'name' などの
  #                                        指定がある場合、:name に指定しておけば、検索での絞り込みに使用できる。
  #
  # @return [Array<When::TM::CalendarEra>] 検索結果を When::TM::CalendarEra オブジェクトの Array で返す
  # @note ヒット数が不足している場合は、_setup_ で指定した順序で When::TM::CalendarEra オブジェクトを生成しつつ読み込んで検索する。
  #
  def era(*args)
    TM::CalendarEra._instance(*args)
  end

  # When::TM::Clock の生成/参照
  #
  # @param [When::Parts::Timezone::Base] clock なにもせず clock をそのまま返す
  # @param [String] clock  時法を表す文字列
  # @param [Numeric] clock 秒を単位として表した時差(東経側を + とする)
  #
  # @return [When::Parts::Timezone::Base] 生成/参照した When::Parts::Timezone::Base オブジェクト
  #
  def Clock(clock)
    case clock
    when Parts::Timezone::Base            ; return clock
    when 'Z', 0                           ; return utc
    when Numeric                          ; return Parts::Resource._instance("_tm:Clock?label=" + TM::Clock.to_hms(clock))
    when /^#{CalendarTypes::TimeSystems}/ ; return Parts::Resource._instance('_c:' + clock)
    when String                           ;
    else                                  ; raise TypeError, "Invalid Type: #{clock.class}"
    end
    c    = TM::Clock[clock] || V::Timezone[clock]
    return c if c
    clock, options = clock.split('?')
    hms  = TM::Clock.to_hms(clock)
    return Parts::Timezone[clock] unless hms
    iri  = "_tm:Clock?label=" + hms
    iri += "&" + options if options
    Parts::Resource._instance(iri)
  end

  # When::CalendarTypes::UTC の生成/参照
  #
  # @return [When::CalendarTypes::UTC]
  #
  def utc
    Parts::Resource._instance("_c:UTC")
  end

  # When::Coordinates::Spatial の生成/参照
  #
  # @overload Location(location)
  #   @param [When::Coordinates::Spatial] location なにもせず location をそのまま返す
  #   @param [String] location  空間位置の IRI (デフォルトプレフィクス _l:)
  #   @param [When::Parts::Timezone] 代表する都市の時間帯
  #
  # @overload Location(longitude, latitide, altitide=0, datum='Earth')
  #   @param [Numeric] longitude 経度 / 度 (東経を正とする)
  #   @param [Numeric] latitide  緯度 / 度 (北緯を正とする)
  #   @param [Numeric] altitide  高度 / m
  #   @param [When::Ephemeris::Datum] datum 座標系
  #   @param [String] datum 座標系の IRI (デフォルトプレフィクス _ep:)
  #
  # @note longitudeが経度を意味する文字列, latitude が緯度を意味する文字列の場合、
  #       引数の順番によらず、それぞれ経度および緯度と解釈する
  #
  # @return [When::Coordinates::Spatial] 生成/参照した When::Coordinates::Spatial オブジェクト
  #
  def Location(*args)
    case args[0]
    when Coordinates::Spatial ; return args[0]
    when Parts::Timezone      ; return args[0].location
    when String               ; return Parts::Resource._instance(args[0], '_l:') if args.size == 1
    when Numeric              ;
    else                      ; raise TypeError, "Invalid Type: #{args[0].class}"
    end
    rest = []
    longitude = latitude = nil
    args.each do |arg|
      case arg
      when /^#{Coordinates::MATCH['EW']}\s*[.@\d]/, /[.@\d]\s*#{Coordinates::MATCH['EW']}$/; longitude = arg
      when /^#{Coordinates::MATCH['NS']}\s*[.@\d]/, /[.@\d]\s*#{Coordinates::MATCH['NS']}$/; latitude  = arg
      else ; rest << arg
      end
    end
    longitude ||= rest.shift
    latitude  ||= rest.shift
    raise ArgumentError, "too few arguments" unless longitude && latitude
    altitude, datum = rest
    iri = "_l:long=#{longitude}&lat=#{latitude}"
    iri += "&alt=#{altitude}" if altitude
    iri += "&datum=#{datum}"  if datum
    Parts::Resource._instance(iri)
  end

  #
  # 曜日(剰余類)
  #
  # @param [Numeric] day 月曜を 0 とする七曜(剰余類)を返します
  # @param [String]  day 最初の3文字から決定した七曜(剰余類)を返します。
  #                      一致する七曜(剰余類)がない場合、名前の一致するその他の剰余類を探して返します。
  #
  # @return [When::Coordinates::Residue] 月曜を 0 とする七曜(剰余類) または 名前の一致するその他の剰余類
  #
  def Residue(day)
    When::Coordinates::Residue.to_residue(day)
  end
  alias :day_of_week :Residue

  #
  # 月名
  #
  # @param [Numeric] name 指定の月番号の月名を返します
  # @param [String]  name 最初の3文字から決定した月名を返します。
  #                       一致する月名がない場合、名前の一致するその他のM17nを探して返します。
  #                       (name が M17n なら name 自身をそのまま返します)
  #
  # @return [When::BasicTypes::M17n] 月名
  #
  def MonthName(name)
    When::BasicTypes::M17n.month_name(name)
  end

  # When::BasicTypes::M17n の生成/参照
  #
  # @param [String] source 多言語対応文字列のIRI
  #
  # @return [When::BasicTypes::M17n] source に対応する When::BasicTypes::M17n オブジェクト
  #
  def M17n(source)
    Parts::Resource._instance(source, '_m:')
  end

  # When::BasicTypes::M17n の生成/参照
  #
  # @param [When::BasicTypes::M17n] source 処理を行わず、そのままsourceを返す
  # @param [String] source locale と 文字列の対応
  # @param [Array]  source 要素を個別に解釈して生成したオブジェクトのArrayを返す
  # @param [Hash]   namespace prefix の指定
  # @param [Array]  locale    locale の定義順序の指定
  # @param [Hash]   options (see {When::BasicTypes::M17n.new}[link:When/BasicTypes/M17n.html#method-c-new])
  #
  # @return [When::BasicTypes::M17n or Array<them>]
  #
  def m17n(source, namespace=nil, locale=nil, options={})
    case source
    when Array            ; BasicTypes::M17n.new(source, namespace, locale, options)
    when BasicTypes::M17n ; source
    when String
      return self[$1] if source =~ /^\s*\[((\.{1,2}|::)+[^\]]+)\]/ && self.kind_of?(When::Parts::Resource)
      return Parts::Resource[$1] if source =~ /^\s*\[::([^\]]+)\]/
      BasicTypes::M17n.new(source, namespace, locale, options)
    else ; raise TypeError, "Invalid Type: #{source.class}"
    end
  end

  # Wikipedia を参照して When::BasicTypes::M17n を生成する
  #
  # @param [String] title Wikipedia の項目名
  # @param [String] locale Wikipedia の言語
  #
  # @return [When::BasicTypes::M17n] 項目に対応する多言語対応文字列
  #
  # @note 生成した多言語対応文字列の parent が nil でない場合、
  #       その項目の位置情報を表わす When::Coordinates::Spatial を指す
  #
  def Wikipedia(title, locale='en')
    object = Parts::Resource._instance("http://#{locale}.wikipedia.org/wiki/#{URI.encode(title).gsub(' ', '_')}")
    object.kind_of?(BasicTypes::M17n) ? object : object.label
  end

  # When::Parts::Resource の生成/参照
  #
  # @param [String] iri        IRI を表す文字列
  # @param [String]  namespace デフォルトの namespace
  #
  # @return [When::Parts::Resourc] iri (または namespace:iri) に対応する When::Parts::Resource オブジェクト
  #
  def Resource(iri, namespace=nil)
    Parts::Resource._instance(iri, namespace)
  end
  alias :IRI :Resource

  # When::Coordinates::Pair の生成
  #
  # @param [Numeric, String] trunk  幹の要素
  # @param [Numeric, String] branch 枝の要素
  # @see When::Coordinates::Pair._force_pair
  #
  # @return [When::Coordinates::Pair]
  #
  def Pair(trunk, branch=nil)
    Coordinates::Pair._force_pair(trunk, branch)
  end
end
