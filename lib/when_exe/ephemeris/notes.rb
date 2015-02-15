# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2015 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

#
# Ephemeris を用いる暦注
#
class When::CalendarNote
  #
  # 太陽と月の位置によるイベント
  #
  class LuniSolarPositions < self

    # 座標の分子
    #
    # @return [Numeric]
    #
    attr_reader :num

    # 座標の分母
    #
    # @return [Numeric]
    #
    attr_reader :den

    # 計算アルゴリズム
    #
    # @return [When::Ephemeris::Formula]
    #
    attr_reader :formula

    # enumerator の周期
    #
    # @return [Numeric]
    #
    attr_reader :delta

    # 没滅計算用の補正
    #
    # @return [Numeric]
    #
    attr_reader :margin

    # イベントの日時
    #
    # @param [When::TM::TemporalPosition] date イベントを探す基準とする日時
    # @param [Array<Numeric>] parameter 座標の分子と分母( num, den)
    #
    #   num 座標の分子 (デフォルト @num)
    #
    #   den 座標の分母 (デフォルト @den)
    #
    # @param [String] parameter  座標の分子と分母("#{ num }/#{ den }" の形式)
    # @param [Integer] precision 取得したい時間位置の分解能(デフォルト date の分解能)
    #
    # @return [When::TM::CalDate] date またはその直後のイベントの日時
    #
    def event_eval(date, parameter=@event, precision=nil)
      date         = When.when?(date) unless date.kind_of?(When::TimeValue)
      precision  ||= date.precision
      num, den     = parameter.kind_of?(String) ? (parameter[/\d.*\z/]||'').split(/\//, 2) : parameter
      num = (num || @num).to_f
      den = (den || @den).to_f
      date      = date.floor(precision) if precision < date.precision
      options   = date._attr
      is_date_and_time = options.key?(:clock) || precision > When::DAY
      options[:precision] = precision
      options[:clock]   ||= date.frame.time_basis || When::TM::Clock.local_time
      sdn       = _the_date(date, num, den)
      time      = When::TM::JulianDate._d_to_t(sdn)
      if @formula.is_dynamical
        time    = date.time_standard.from_dynamical_time(time)
        time   += options[:clock].universal_time(sdn.round) if options[:clock].kind_of?(When::CalendarTypes::LocalTime)
      end
      event = date.frame.jul_trans(When::TM::JulianDate.universal_time(time), options)
      is_date_and_time ? event : event.to_cal_date
    end

    # the event date
    def _the_date(date, num, den)
      quot, mod = (@formula.time_to_cn(date)*30.0).divmod(den)
      cycle     = quot * den + num
      cycle    += den if mod > (num % den)
      @formula.cn_to_time(cycle/30.0)
    end
    private :_the_date

    # 日付に対応する座標
    #
    # @param [When::TM::TemporalPosition] date 日付
    # @param [Numeric] delta 周期の補正(土用の時刻の補正に使用,デフォルト 0)
    #
    # @return [Array<Integer>] Array< Integer, 0 or 1 or 2 >
    #
    #   [Integer]     対応する座標
    #
    #   [0 or 1 or 2] 座標の進み(0 なら 没, 2 なら滅)
    #
    def position(date, delta=0)
      date   = date.floor
      p0, p1 = [date, date.succ].map {|d| (30.0 * @formula.time_to_cn(d) - @margin + delta).floor}
      [p1 % @den, p1 - p0]
    end

    #
    # イベントの標準的な間隔を返す
    #
    # @param [String] parameter 座標の分子と分母("#{ num }/#{ den }" の形式)
    #
    # @return [When::TM::IntervalLength]
    #
    # @private
    def event_delta(parameter=nil)
      return @delta unless parameter
      num, den = parameter.kind_of?(String) ? parameter.split(/\//, 2) : parameter
      When::TM::IntervalLength.new([(den || @den).to_f,1].max*0.9, 'day')
    end

    #
    # イベント日付(時刻付)
    #
    # @private
    def event_time(date, event_name, event)
      etime = term(date - When.Duration('P3D'), event, When::SYSTEM)
      if formula.respond_to?(:year_length) && formula.denominator && formula.denominator < 100000
        fraction  =  etime.clk_time.local_time
        fraction +=  When::TM::Duration::DAY * (etime.to_i - date.to_i)
        fraction  = (fraction  / When::TM::Duration::DAY * formula.denominator * 1000 + 0.5).floor / 1000.0
        fraction  =  fraction.to_i if fraction == fraction.to_i
        event_name + "(#{fraction}/#{formula.denominator})"
      else
        etime.events = [event_name]
        etime
      end
    end
  end

  #
  # 二十四節気
  #
  class SolarTerms < LuniSolarPositions

    # 二十四節気のための event の別名
    #
    # @return [When::TM::CalDate] date またはその直後のイベントの日時
    alias :term :event_eval

    private

    # 二十四節気のための event_delta の別名
    alias :term_delta :event_delta

    # オブジェクトの正規化
    #   num     - 太陽黄経/度の分子 (デフォルト   0 - 春分)
    #   den     - 太陽黄経/度の分母 (デフォルト 360 - 1年)
    #   formula - 計算アルゴリズム(デフォルト '_ep:Formula?formula=12S')
    #   delta   - enumerator の周期 (デフォルト (den/360)年)
    #   margin  - 没滅計算用の補正  (デフォルト 1E-8)
    def _normalize(args=[], options={})
      num, den, formula, delta, margin = args
      @event ||= 'term'
      @num     = (num || @num  ||   0).to_f
      @den     = (den || @den  || 360).to_f
      @formula = When.Resource(formula || @formula ||'Formula?formula=12S', '_ep:')
      @delta   = When.Duration(delta   || @delta   || When::TM::IntervalLength.new(@den/360, 'year'))
      @margin  = (margin || @margin    || 1E-8).to_f
      super
    end
  end

  #
  # 冬至を定気で計算し、その他の二十四節気を前後の冬至の日時を時間で等分して求める
  #
  class SolarTermsRevised < SolarTerms

    # the event date
    def _the_date(date, num, den)
      quot, mod = @formula.time_to_cn(date).divmod(12)
      quot     +=  1 if mod >= 9
      range     = [12*quot-3, 12*quot+9].map {|cn| [cn*30, @formula.cn_to_time(cn)]}
      time      = @formula.is_dynamical ? +date : date.to_f
      now       = [range[0][0] + (range[1][0] - range[0][0]) / (range[1][1] - range[0][1]) * (time - range[0][1]), time]

      quot, mod = now[0].divmod(den)
      cycle     = quot * den + num
      cycle    += den if mod > (num % den)
      range[0][1] + (range[1][1] - range[0][1]) / (range[1][0] - range[0][0]) * (cycle - range[0][0])
    end
  end

  #
  # 月の位相
  #
  class LunarPhases < LuniSolarPositions

    # 月の位相のための event の別名
    #
    # @return [When::TM::CalDate] date またはその直後のイベントの日時
    alias :phase :event_eval

    private

    # 月の位相のための event_delta の別名
    alias :phase_delta :event_delta

    # オブジェクトの正規化
    #   num     - 月の位相/12度の分子 (デフォルト  0 - 朔)
    #   den     - 月の位相/12度の分母 (デフォルト 30 - 1月)
    #   formula - 計算アルゴリズム(デフォルト '_ep:Formula?formula=1L')
    #   delta   - enumerator の周期 (デフォルト (den/30)月)
    #   margin  - 没滅計算用の補正  (デフォルト 1E-8)
    def _normalize(args=[], options={})
      num, den, formula, delta, margin = args
      @event ||= 'phase'
      @num     = (num || @num  ||  0).to_f
      @den     = (den || @den  || 30).to_f
      @formula = When.Resource(formula || @formula ||'Formula?formula=1L', '_ep:')
      @delta   = When.Duration(delta   || @delta   || When::TM::IntervalLength.new(@den/30, 'month'))
      @margin  = (margin || @margin    || 1E-8).to_f
      super
    end
  end

  #
  # 天体暦の暦注
  #
  class Ephemeris < self

    Notes = [When::BasicTypes::M17n, [
      "locale:[=en:, ja=ja:, alias=ja:]",
      "names:[Ephemeris]",

      # 年の暦注 ----------------------------
      [When::BasicTypes::M17n,
        "names:[year, 年]"
      ],

      # 月の暦注 ----------------------------
      [When::BasicTypes::M17n,
        "names:[month, 月]",
        [When::BasicTypes::M17n,
          "names:[Month]"
        ]
      ],

      # 日の暦注 ----------------------------
      [When::BasicTypes::M17n,
        "names:[day, 日]",
          "[Sunrise,   日の出          ]", # 日の出
          "[Sunset,    日の入り        ]", # 日の入り
          [When::Coordinates::Residue,
            "label:[Moon_Age=, 正午月齢=ja:%%<月齢>]",
            "divisor:60",
            "format:[%s(%4.1f)=]"
          ],
          "[Moonrise,  月の出          ]", # 月の出
          "[Moonset=,  月の入り        ]", # 月の入り
          [When::BasicTypes::M17n,
            "names:[Tide, 潮汐]",            # 満潮干潮日時
            "[High_Tide=en:Tide, 満潮=ja:%%<潮汐>]",
            "[Low_Tide=en:Tide,  干潮=ja:%%<潮汐>]"
          ]
      ]
    ]]

    #
    # 日の出
    #
    # @param [When::TM::TemporalPosition] date
    # @param [Hash] options dummy
    #
    # @return [When::TM::TemporalPosition] 日の出の時刻をイベント時刻とする
    #
    def sunrise(date, options={})
      event = formula(date.location.iri).sunrise(date)
      event.events = [@root['Sunrise']]
      event
    rescue
      nil
    end

    #
    # 日の入り
    #
    # @param [When::TM::TemporalPosition] date
    # @param [Hash] options dummy
    #
    # @return [When::TM::TemporalPosition] 日の入りの時刻をイベント時刻とする
    #
    def sunset(date, options={})
      event = formula(date.location.iri).sunset(date)
      event.events = [@root['Sunset']]
      event
    rescue
      nil
    end

    #
    # 正午月齢
    #
    # @param [When::TM::TemporalPosition] date
    # @param [Hash] options dummy
    #
    # @return [Numeric] 正午における朔からの経過日数
    #
    def moon_age(date, options={})
      @phase ||= When.CalendarNote('LunarPhases')
      noon  = date.floor(When::DAY,When::SYSTEM)
      noon += 0.5 if noon.kind_of?(When::TM::DateAndTime)
      @root['Moon_Age'][noon.to_f - @phase.phase(noon, [-30.0,30.0]).to_f]
    end

    #
    # 月の出
    #
    # @param [When::TM::TemporalPosition] date
    # @param [Hash] options dummy
    #
    # @return [When::TM::TemporalPosition] 月の出の時刻をイベント時刻とする
    #
    def moonrise(date, options={})
      event = formula(date.location.iri).moonrise(date)
      event.events = [@root['Moonrise']]
      event
    rescue
      nil
    end

    #
    # 月の入り
    #
    # @param [When::TM::TemporalPosition] date
    # @param [Hash] options dummy
    #
    # @return [When::TM::TemporalPosition] 月の入りの時刻をイベント時刻とする
    #
    def moonset(date, options={})
      event = formula(date.location.iri).moonset(date)
      event.events = [@root['Moonset']]
      event
    rescue
      nil
    end

    #
    # 干潮・満潮の日時
    #
    # @param [When::TM::TemporalPosition] date
    # @param [Hash] options 以下の通り
    # @option options [String] tide 潮汐計算方式 'Horizontal' - 地平高度基準, 'Equatorial' - 子午線通過基準(デフォルト)
    #
    # @return [Array<Array<Integer, When::TM::TemporalPosotion>>] 干潮・満潮の日時の Array
    #
    #   [Integer] +1:満潮, -1:干潮
    #
    #   [When::TM::TemporalPosotion] 干潮・満潮の日時
    #
    def tide(date, options={})
      return nil unless @interval
      @target  ||= When.Resource('_ep:Moon')
      events     = @root['Tide']
      form       = formula(date.location.iri)
      type       = options[:tide] =~ /\Ahorizon/i ? nil : 0

      now        = +date
      high_tides = []
      5.times do |i|
        high_tide = form.day_event(now + i - 2, type, @target) + @interval
        high_tides << high_tide if high_tides.size == 0 || high_tide > high_tides[-1] + 0.5
      end
      tides = []

      (high_tides.size-1).times do |i|
        tides << [0, high_tides[i]]
        tides << [1, 0.75*high_tides[i] + 0.25*high_tides[i+1]]
        tides << [0, 0.50*high_tides[i] + 0.50*high_tides[i+1]]
        tides << [1, 0.25*high_tides[i] + 0.75*high_tides[i+1]]
      end
      tides << [0, high_tides[-1]]

      today = +date.floor(When::DAY)...+date.ceil(When::DAY)
      seed  = date._attr
      seed[:clock] ||= When::TM::Clock.local_time
      tides.select {|x| today.include?(x[1])}.map {|x|
        d = form._to_seed_type(x[1], seed)
        d.events = [events[x[0]]]
        d
      }
    rescue
      nil
    end

    private

    # オブジェクトの正規化
    #   long     - 計算に用いる経度 / 度
    #   lat      - 計算に用いる緯度 / 度
    #   alt      - 計算に用いる高度 / m
    #   interval - 高潮間隔(月の子午線通過から満潮までの時間) / 時間
    def _normalize(args=[], options={})
      if @location
        @location = When.Resource(@location)
        @formula  = When.Resource(@formula || "Formula?location=(#{@location.iri})", '_ep:')
      else
        @formula  = {}
      end
      @interval  = @interval.sub('@','.').to_f / 24 if @interval
      @root      = When.CalendarNote('Ephemeris/Notes::day')
      @prime   ||= [%w(Month), %w(Sunrise Sunset Moon_Age)]
      super
    end

    # 計算に用いる Ephemeris
    def formula(location)
      return @formula unless @formula.kind_of?(Hash)
      @formula[location] ||= When.Resource("Formula?location=(#{location})", '_ep:')
    end
  end

  #
  # 節月の暦注
  #
  class Solar < self

    Notes = [When::BasicTypes::M17n, [
      "locale:[=en:, ja=ja:, zh=zh:, alias=ja:]",
      "names:[SolarMonth=, 節月=, 節月=]",

      # 年の暦注 ----------------------------
      [When::BasicTypes::M17n,
        "names:[year]",
        [When::BasicTypes::M17n,
          "names:[Year]"
        ]
      ],

      # 月の暦注 ----------------------------
      [When::BasicTypes::M17n,
        "names:[month]",
        [When::BasicTypes::M17n,
          "names:[Month]"
        ]
      ],

      # 日の暦注 ----------------------------
      [When::BasicTypes::M17n,
        "names:[day]",
         "[Week,                           週,         週        ]", # 七曜
         "[StemBranch=en:Sexagenary_cycle, 干支,       干支      ]", # 六十干支
         "[SolarTerm=en:Solar_term,  二十四節気, 節気=zh:%%<节气>]", # 二十四節気
         "[Motsu=,                         没=,        没=       ]"  # 没
      ]
    ]]

    #
    # 年の干支
    #
    # @param [When::TM::TemporalPosition] date
    # @param [Hash] options dummy
    #
    # @return [When::Coordinates::Residue] 六十干支
    #
    def year(date, options={})
      When.Residue('干支')[(date.year-4) % 60]
    end

    #
    # 七曜
    #
    # @param [When::TM::TemporalPosition] date
    # @param [Hash] options dummy
    #
    # @return [When::Coordinates::Residue] 七曜
    #
    def week(date, options={})
      When.Residue('Week')[date.to_i % 7]
    end

    #
    # 日の干支
    #
    # @param [When::TM::TemporalPosition] date
    # @param [Hash] options dummy
    #
    # @return [When::Coordinates::Residue] 六十干支
    #
    def stembranch(date, options={})
      When.Residue('干支')[(date.to_i-11) % 60]
    end

    #
    # 二十四節気
    #
    # @param [When::TM::TemporalPosition] date
    # @param [Hash] options dummy
    #
    # @return [When::Coordinates::Residue] 二十四節気 or nil
    #
    def solarterm(date, options={})
      _day_notes(date, options)['二十四節気']
    end

    #
    # 没
    #
    # @param [When::TM::TemporalPosition] date
    # @param [Hash] options dummy
    #
    # @return [When::BasicTypes::M17n] 没 or nil
    #
    def motsu(date, options={})
      _day_notes(date, options)['没']
    end

    private

    # オブジェクトの正規化
    def _normalize(args=[], options={})
      @prime  ||= [%w(Year), %w(Month), %w(Week StemBranch SolarTerm Motsu)]
      super
    end

    #
    # 日の暦注
    #
    # @param [When::TM::TemporalPosition] date
    # @param [Hash] options dummy
    #
    # @return [Hash] 暦注名=>暦注値
    #
    def _day_notes(date, options={})
      s_date = When.when?(date.to_cal_date.to_s,
        {:frame=>date.frame,
         :clock=>(date.frame.kind_of?(When::CalendarTypes::EphemerisBasedSolar) || !date.frame.twin ?
            date.frame :
            When.Calendar(date.frame.twin))._time_basis[0]
        })

      # 没
      notes   = {}
      longitude, motsu = SolarTerms.new('formula'=>date.frame.formula[0]).position(s_date)
      if motsu == 0
        notes['没'] = '没' unless date.most_significant_coordinate >= 1685 && date.frame.iri =~ /JapaneseTwin/
        return notes
      end

      # 廿四節気
      div, mod = longitude.divmod(15)
      if mod == 0
        note = (div - 21) % 24
        div, mod = note.divmod(2)
        notes['二十四節気'] ||= 
         When.Resource(date.frame.iri =~ /戊寅|麟徳|儀鳳/ ? '_co:Common?V=0618' : '_co:Common')['二十四節気::*'][(note-3) % 24]
      end
      notes
    end
  end
end
