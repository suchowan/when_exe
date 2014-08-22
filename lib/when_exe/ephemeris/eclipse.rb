# -*- coding: utf-8 -*-
=begin
    Copyright (C) 2014 Takashi SUGA

    You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

class When::Coordinates::Spatial

  # 日食の情報
  #
  # @param [When::TM::TemporalPosition] date
  # @param [Boolean] just_the_date 日付の一致確認 (true - 日付が違えば nil, false - 近傍でも返す)
  #
  # @return [Array<String, Numeric, Array<Array<Numeric or When::TM::TemporalPosition, String>>>] 食の情報
  #   @see When::Coordinates::Spatial#eclipse_info
  #
  def solar_eclipse(date, just_the_date=false)
    clock = date.clock && (date.clock.tz_prop || date.clock.label)
    cn    = @mean.time_to_cn(date).round
    unless @ecls.key?([cn,clock.to_s])
      data = eclipse_info(@mean._to_seed_type(@mean.cn_to_time(cn), date), self, When.Resource('_ep:Sun'), When.Resource('_ep:Moon'))
      @ecls[[cn,clock.to_s]] = data ? [data[2][data[2].size / 2][0].to_i, data] : nil
    end
    key, info = @ecls[[cn,clock.to_s]]
    just_the_date && key != date.to_i ? nil : info
  end

  # 月食の情報
  #
  # @param [When::TM::TemporalPosition] date
  # @param [Boolean] just_the_date 日付の一致確認 (true - 日付が違えば nil, false - 近傍でも返す)
  #   @note 午前6時より前は前日扱い
  #
  # @return [Array<String, Numeric, Array<Array<Numeric or When::TM::TemporalPosition, String>>>] 食の情報
  #   @see When::Coordinates::Spatial#eclipse_info
  #
  def lunar_eclipse(date, just_the_date=false)
    clock = date.clock && (date.clock.tz_prop || date.clock.label)
    cn    = (@mean.time_to_cn(date)+0.25).floor+0.5
    unless @ecls.key?([cn,clock.to_s])
      data = eclipse_info(@mean._to_seed_type(@mean.cn_to_time(cn), date),
        When.Resource('_ep:Earth'), When.Resource('_ep:Moon'), When.Resource('_ep:Shadow'), [self, When.Resource('_ep:Moon')])
      @ecls[[cn,clock.to_s]] = data ? [(data[2][data[2].size / 2][0]-When::PT6H).to_i, data] : nil
    end
    key, info = @ecls[[cn,clock.to_s]]
    just_the_date && key != date.to_i ? nil : info
  end

  # 食の情報
  #
  # @param [Numeric] date ユリウス日(Terrestrial Time)
  # @param [When::TM::TemporalPosition] date
  # @param [When::Ephemeris::Datum or When::Coordinates::Spatial] location 観測地
  # @param [When::Ephemeris::Datum] target 隠される天体
  # @param [When::Ephemeris::Datum] base 隠す天体
  # @param [Array<When::Coordinates::Spatial, When::Ephemeris::Datum>] l_for_h 高度を計算する観測地と対象天体
  #
  # @return [Array<String, Numeric, Array<Array<Numeric or When::TM::TemporalPosition, String>>>] 食の情報
  #
  #   [ String  - 食の種類 'T' 皆既食, 'A' 金環食, 'P' 部分食, 'B' 帯食]
  #   [ Numeric - 最大食分                                             ]
  #   [ Array   - 第1～4接触の日時と地平座標(高度/方位角)              ]
  #
  def eclipse_info(date, location, target, base, l_for_h=[location, base])

    tc  = When::Ephemeris.root(+date) {|t|            # 離角最小日時
            base.elongation(t, target, location)**2
          }
    mag = base.phase_of_eclipse(tc, target, location) # 食分
    return nil unless mag >= 0                        # 食なし

    t1, t4 = [-0.1, +0.1].map {|dt|                   # 第1, 第4接触
      When::Ephemeris.root(tc+dt, 0) {|t|
        base.phase_of_eclipse(t, target, location)
      }
    }

    if mag >= 1
      category = 'T'
      t2, t3 = [-0.01, +0.01].map {|dt|               # 第2, 第3接触
        When::Ephemeris.root(tc+dt, 1.0) {|t|
          base.phase_of_eclipse(t, target, location)
        }
      }
    elsif target.phase_of_eclipse(tc, base, location) >= 1
      category = 'A'
      t2, t3 = [-0.01, +0.01].map {|dt|               # 第2, 第3接触
        When::Ephemeris.root(tc+dt, 1.0) {|t|
          target.phase_of_eclipse(t, base, location)
        }
      }
    else
      category = 'P'
    end
    ts = [t1,t2,tc,t3,t4].compact

    form = When::Ephemeris::Formula.new(:location=>l_for_h[0])
    height, azimuth = ts.map {|t|                     # 基準天体の高度・方位角
       coord = form._coords(t, HORIZONTAL, l_for_h[1])
      [coord.theta * 360, ((0.5-coord.phi)-(0.5-coord.phi).floor) * 360]
    }.transpose
    return nil  unless height.max >= 0                # 見えない食
    category += 'B' if height.min <  0                # 地平線下で食が始まる/終わる

    [category, mag, [ts.map {|t| form._to_seed_type(t, date)}, height, azimuth].transpose]

  rescue RangeError
    nil
  end
end
