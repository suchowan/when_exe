# -*- coding: utf-8 -*-
=begin
    Copyright (C) 2014-2016 Takashi SUGA

    You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

class When::Coordinates::Spatial

  # @private
  EclipseHalfYear = (346 + (14*3600+52*60+54.965) / 86400) / 2

  # @private
  EclipseRange    = (75.0..120.0) # 82.05003457775217..114.62097737290446

  # 日食の情報
  #
  # @param [When::TM::TemporalPosition] date
  # @param [::Range<When::TM::TemporalPosition>] date
  # @param [Block] block
  #
  # @return [Array<String, Numeric, Array<Array<Numeric or When::TM::TemporalPosition, String>>>] 食の情報(のArray(dateが::Rangeの場合))
  #   @see When::Coordinates::Spatial#eclipse_info
  #
  def solar_eclipse(date, &block)
    if date.kind_of?(::Range)
      last  = date.last.to_i
      last -= 1 if date.exclude_end?
      first = date.first.to_i
      date  = date.first
    end
    clock = date.clock && (date.clock.tz_prop || date.clock.label)
    cn    = @mean.time_to_cn(date).round
    list  = []
    loop do
      unless @ecls.key?([cn,clock.to_s])
        time = @mean.cn_to_time(cn)
        data = EclipseRange.include?(time % EclipseHalfYear) ?
                eclipse_info(@mean._to_seed_type(time, date), self, When.Resource('_ep:Sun'), When.Resource('_ep:Moon')) : nil
        @ecls[[cn,clock.to_s]] = data ? [data[2][data[2].size / 2][0].to_i, data] : nil
      end
      key, info = @ecls[[cn,clock.to_s]]
      return info unless first
      list << (block_given? ? yield(info) : info) if key && first <= key && key <= last
      break if (key || first) >= last
      cn += 1
    end
    return list
  end

  # 月食の情報
  #
  # @param [When::TM::TemporalPosition] date
  # @param [::Range<When::TM::TemporalPosition>] date
  #   @note ::Rangeの場合夜半より翌日に向けmargin経過時点より前は前日扱い
  # @param [When::TM::Duration] margin 
  # @param [Block] block
  #
  # @return [Array<String, Numeric, Array<Array<Numeric or When::TM::TemporalPosition, String>>>] 食の情報(のArray(dateが::Rangeの場合))
  #   @see When::Coordinates::Spatial#eclipse_info
  #
  def lunar_eclipse(date, margin=When::PT6H, &block)
    if date.kind_of?(::Range)
      last  = date.last.to_i
      last -= 1 if date.exclude_end?
      first = date.first.to_i
      date  = date.first
    end
    clock = date.clock && (date.clock.tz_prop || date.clock.label)
    cn    = (@mean.time_to_cn(date)+0.25).floor+0.5
    list  = []
    loop do
      unless @ecls.key?([cn,clock.to_s])
        time = @mean.cn_to_time(cn)
        data = EclipseRange.include?(time % EclipseHalfYear) ?
                 eclipse_info(@mean._to_seed_type(time, date), When.Resource('_ep:Earth'), When.Resource('_ep:Moon'),
                   When.Resource('_ep:Shadow'), [self, When.Resource('_ep:Moon')]) : nil
        @ecls[[cn,clock.to_s]] = data ? [(data[2][data[2].size / 2][0]-margin).to_i, data] : nil
      end
      key, info = @ecls[[cn,clock.to_s]]
      return info unless first
      list << (block_given? ? yield(info) : info) if key && first <= key && key <= last
      break if (key || first) >= last
      cn += 1
    end
    return list
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
