# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

autoload :Rational, 'Rational' unless Object.const_defined?(:Rational)

#
# 具体的な When::TM::ReferenceSystem のサブクラスの実装
#
module When::CalendarTypes

  #
  # Universal Time, Coordinated
  #
  class UTC < When::TM::Clock

    # この時法の時刻をUTC時刻に変換する
    #
    # Description of an operation for
    # converting a time on this clock to a UTC time
    #
    # @param  [When::TM::ClockTime] u_time
    # @return [When::TM::ClockTime]
    #
    def utc_trans(u_time)
      return u_time
    end
    alias :utcTrans :utc_trans

    # UTC時刻をこの時法の時刻に変換する
    #
    # Description of an operation for
    # converting a UTC time to a time on this clock
    #
    # @param  [When::TM::ClockTime] clk_time
    # @return [When::TM::ClockTime]
    #
    def clk_trans(clk_time)
      return clk_time
    end
    alias :clkTrans :clk_trans

    #
    # Zone 名
    #
    # @return [String]
    #
    def zone
      @label.to_s
    end

    private

    # オブジェクトの正規化
    def _normalize(args=[], options={})
      @label   ||= m17n('Z')
      @indices ||= When::Coordinates::DefaultTimeIndices
      @note    ||= 'JulianDayNotes'
      _normalize_spatial
      _normalize_temporal
      @second    = (@second||1/When::TM::Duration::SECOND).to_f
      @zone      = '+00:00'
      @time_standard ||= When.Resource('_t:UniversalTime')
      @utc_reference   = When::TM::ClockTime.new([0,0,0,0], {:frame=>self})
    end
  end

  #
  # Abstract Local Time
  #
  class LocalTime < UTC

    # 128秒単位の実数による参照事象の時刻
    #
    # Fraction time of the reference event
    #
    # @param [Integer] sdn 参照事象の通し番号
    #
    # @return [Numeric]
    #
    #   T00:00:00Z からの参照事象の経過時間 / 128秒
    #
    def universal_time(sdn=nil)
      return super unless sdn
      time = When::TM::JulianDate._d_to_t(sdn-0.5)
      @time_standard.to_dynamical_time(time) - When::TimeStandard.to_dynamical_time(time)
    end

    #
    # Zone 名
    #
    # @return [String]
    #
    def zone
      iri.split('/')[-1]
    end
  end

  #
  # Local Mean Time
  #
  class LMT < LocalTime

    private

    # オブジェクトの正規化
    def _normalize(args=[], options={})
      @label         = m17n('LMT')
      @time_standard = When.Resource("_t:LocalMeanTime?location=_l:long=#{@long||0}")
      super
    end
  end

  #
  # Local Apparent Time
  #
  class LAT < LocalTime

    private

    # オブジェクトの正規化
    def _normalize(args=[], options={})
      @label         = m17n('LAT')
      @time_standard = When.Resource("_t:LocalApparentTime?location=_l:long=#{@long||0}")
      super
    end
  end

  #
  # Temporal Hour System
  #
  class THS < LocalTime

    private

    # オブジェクトの正規化
    def _normalize(args=[], options={})
      @label         = m17n('THS')
      @time_standard = When.Resource("_t:TemporalHourSystem?location=(_l:long=#{@long||0}&lat=#{@lat||0}&alt=#{@alt||0})")
      super
    end
  end

  # 月日の配当パターンの種類が限定されている暦の抽象基底クラス
  #
  #   Calendar which has some fixed arrangement rules for under year
  #
  #   新年の日付が専用メソッドで与えられ、月日の配当が1年の日数等
  #   で決まる暦。いわゆる Rule-Based な暦はほとんど該当します。
  class TableBased < When::TM::Calendar

    # 年月日 -> 通日
    #
    # @param  [Numeric] y 年
    # @param  [Integer] m 月 (0 始まり)
    # @param  [Integer] d 日 (0 始まり)
    #
    # @return [Integer] 通日
    #
    def _coordinates_to_number(y, m, d)
      sdn  = _sdn([+y])
      rule = _rule(_key([+y]))
      sdn += d + rule['Offset'][m]
      return sdn if d >= 0
      return sdn + rule['Length'][m % rule['Length'].length]
    end

    # 通日 - > 年月日
    #
    # @param  [Integer] sdn 通日
    #
    # @return [Array<Integer>] [ y, m, d ]
    #   y 年
    #   m 月 (0 始まり)
    #   d 日 (0 始まり)
    #
    def _number_to_coordinates(sdn)
      y, d = Residue.mod(sdn) {|n| _sdn([n])}
      rule = _rule(_key([y]))
      (rule['Months']-1).downto(0) do |m|
        if d >=rule['Offset'][m]
          d -= rule['Offset'][m]
          return [y, m, d]
        end
      end
      return nil
    end

    # 暦要素数
    #
    # @overload _length(date)
    #   @param [Array<Integer>] date ( y )
    #
    #      y 年
    #
    #   @return [Integer] その年の月数
    #
    # @overload _length(date)
    #   @param [Array<Integer>] date ( y, m )
    #
    #      y 年
    #
    #      m 月 (0 始まり)
    #
    #   @return [Integer] その年月の日数
    #
    def _length(date)
      y, m = date
      if (m)
        #  指定した月に含まれる日の数を返します。
        return @unit[2] if @unit[2]
        rule = _rule(_key([y]))
        return rule['Length'][m % rule['Length'].length]
      else
        #  指定した年に含まれる月の数を返します。
        return @unit[1] if @unit[1]
        return _rule(_key([y]))['Months']
      end
    end

    private

    # オブジェクトの正規化
    def _normalize(args=[], options={})
      super

      # rule_table
      # @rule_table = @rule_table.dup
      @rule_table = {'T' => {'Rule' => @rule_table }} if (@rule_table.kind_of?(Array))
      @_m_cash_          = {}
      @_m_cash_["_rule"] = @rule_table

      # unit length
      unit = @unit[1..2]
      @rule_table.each do |key, rule|
        _make_rule(key, rule, unit) if rule.kind_of?(Hash)
      end

      # mean month length
      if @entry_key
        ::Rational
        @mean_month = Rational(@rule_table[@entry_key]['Days'], @rule_table[@entry_key]['Months'])
        @mean_year  = Rational(@rule_table[@entry_key]['Days'], @rule_table[@entry_key]['Years' ])
      end
    end

    # rule の正規化
    def _make_rule(key, rule, unit=[])
      # @rule_table[key]['Years', 'Months', 'Offset', 'Days']
      rule['IDs'] = Pair._en_pair_array(rule['IDs']) if rule['IDs'].kind_of?(String)
      rule['Years']  ||= 1
      rule['Months'] ||= (rule['IDs']||rule['Length']).length
      rule['Offset'] = []
      sum, len = 0, rule['Length'].length
      rule['Months'].times do |k|
        rule['Offset'] << sum
        sum += rule['Length'][k % len]
      end
      rule['Days']   ||= sum

      # Months in Year
      unit[0] ||= rule['Months']
      unit[0]   = 0 unless (unit[0]==rule['Months'])

      # Days in Month
      len = rule['Length'][0]
      if rule['Length'].length == 1 && (rule['Days'] % len) == 0
        unit[1] ||= len
        unit[1]   = 0 unless (unit[1]==len)
      else
        unit[1] = 0
      end
    end

    # 年初の通日によるセットアップ
    def _sdn_setup(c_key, c_date)
      n_date = c_date.dup
      n_date[-1] += 1
      n_key = (n_date.length<=1) ? n_date[0] : n_date
      c_sdn = (@_m_cash_["_sdn"][c_key] ||= _sdn_(c_date))
      n_sdn = (@_m_cash_["_sdn"][n_key] ||= _sdn_(n_date))
      key   = n_sdn - c_sdn
      rule  = (@_m_cash_["_rule"][key]  ||= _rule_(key))
      @_m_cash_["_key"]        ||= {}
      @_m_cash_["_ids"]        ||= {}
      @_m_cash_["_key"][c_key] ||= key
      @_m_cash_["_ids"][c_key] ||= rule['IDs']
      return c_sdn
    end

    # 年初の通日
    #   このメソッドは subclass で定義します
    #
    # @param [Array<Numeric>] date ( 年 )
    #
    # @return [Integer] 年初の通日
    #
    def _sdn_(date)
      raise TypeError, "Abstract TableBased Calendar Type"
    end

    # 暦日表のキー取得
    #
    # @param [Array<Numeric>] date ( 年 )
    #
    # @return [Integer] 暦日表のキー 本暦法では当該年の日数を暦日表のキーとします
    #
    def _key_(date)
      n_date = date.dup
      n_date[-1] += 1
     _sdn(n_date) - _sdn(date)
    end

    # 日時要素の翻訳表の取得
    #
    # @param [Array<Numeric>] date ( 年 )
    #
    # @return [Array<When::Coordinates::Pair>] 日時要素の翻訳表
    #
    def _ids_(date)
      _rule(_key(date))['IDs']
    end

    # 暦要素数
    #
    # @param [Array<Numeric>] date ( 年 )
    #
    # @return [Integer] その年の日数
    #
    def _sum_(date)
      return _rule(_key([date[0]]))['Days']
    end

    # 月日の配当
    #
    # @param [Numeric] year 年
    #
    # @return [Array<Integer>] [ 月の日数 ]
    #
    def month_arrangement_(year)
      _rule(_key([year * 1 - @origin_of_MSC]))['Length']
    end

    # rule の遅延生成
    def _rule_(key)
      rule = {
        'Years'  => 1,
        'Months' => key.length,
        'Days'   => key.length * 29 + key.gsub(/[a-z]/,'').length,
        'IDs'    => [],
        'Length' => [],
        'Offset' => []
      }

      key.length.times do |k|
        rule['Length'] << (key[k,1] =~ /[a-z]/ ? 29 : 30)
        rule['Offset'] << (k == 0 ? 0 : rule['Offset'][k-1]+rule['Length'][k-1])
        trunk  = key.upcase[k]
        branch = (trunk == key.upcase[k-1]) ? 1 : 0
        trunk  = trunk.ord if trunk.kind_of?(String)
        trunk -= 64
        rule['IDs'] << ((branch==0) ? trunk : When::Coordinates::Pair.new(trunk, branch))
      end
      return rule
    end
  end

  # 表引きにより実現する太陰太陽暦
  #
  #   Luni-Solar calendar which uses year / month /day table
  #
  class PatternTableBasedLuniSolar < TableBased

    private

    #  new で指定された月日配当規則をプログラムで利用可能にします。
    # 
    #    key  年月日配当規則のハッシュキー
    #    rule 年月日配当規則
    #
    #    インスタンス変数 ハッシュのハッシュ@rule_table の要素
    #      Years  =>  the period length / year
    #      Months =>  the period length / month
    #      Days   =>  the period length / day 
    #      Rule   =>  Array of sub rules' key and offset
    def _make_rule(key, rule, unit=nil)

      mm, dd = 0, 0
      rule['Rule'].each_index do |k|
        subkey = rule['Rule'][k]
        case subkey
        when String ; rule['Rule'][k] = [subkey, dd, mm]
        when Array  ; subkey, dd, mm  = rule['Rule'][k]
        else        ; raise TypeError, "Irregal subkey type"
        end
        mm += subkey.length
        dd += subkey.length * 29 + subkey.gsub(/[a-z]/,'').length
      end

      rule['Years']  ||= rule['Rule'].length
      rule['Months'] ||= mm
      rule['Days']   ||= dd

      @entry_key ||= key
    end

    # 年初の通日によるセットアップ
    def _sdn_setup(c_key, c_date)
      root_rule   = @rule_table[@entry_key]
      count, year = c_date[0].divmod(root_rule['Years'])
      key, dd, mm = root_rule['Rule'][year]
      rule = (@_m_cash_["_rule"][key] ||= _rule_(key))
      @_m_cash_["_key"]        ||= {}
      @_m_cash_["_ids"]        ||= {}
      @_m_cash_["_key"][c_key] ||= key
      @_m_cash_["_ids"][c_key] ||= rule['IDs']
      @_m_cash_["_sdn"][c_key] ||= @origin_of_LSC + dd + count * root_rule['Days']
    end

    # 年初の通日
    #
    # @param [Array<Numeric>] date ( y )
    #
    #   y 年
    #
    # @return [Integer] 年初の通日
    #
    def _sdn_(date)
      rule = @rule_table[@entry_key]
      count, year = date[0].divmod(rule['Years'])
      return @origin_of_LSC + rule['Rule'][year][1] + count * rule['Days']
    end

    # 暦日表のキー取得
    #
    # @param [Array<Numeric>] date ( y )
    #
    #   y 年
    #
    # @return [Integer] 暦日表のキー
    #
    def _key_(date)
      rule = @rule_table[@entry_key]
      count, year = date[0].divmod(rule['Years'])
      return rule['Rule'][year][0]
    end

    # オブジェクトの正規化
    #
    # @note インスタンス変数 @note は to_a でデフォルトとして用いる暦注
    #
    def _normalize(args=[], options={})
      @note ||= When.CalendarNote('ChineseNotes') # See when.rb
      super
    end
  end

  # 表引きにより実現する太陰太陽暦(29,30日以外の月がある場合)
  #
  #   Luni-Solar calendar which uses year / month /day table
  #
  class PatternTableBasedLuniSolarExtended < PatternTableBasedLuniSolar

    private

    # rule の遅延生成
    def _rule_(key)
      key.kind_of?(Hash) ? key : super
    end

    #  new で指定された月日配当規則をプログラムで利用可能にします。
    # 
    #    key  年月日配当規則のハッシュキー
    #    rule 年月日配当規則
    #
    #    インスタンス変数 ハッシュのハッシュ@rule_table の要素
    #      Years  =>  the period length / year
    #      Months =>  the period length / month
    #      Days   =>  the period length / day 
    #      Rule   =>  Array of sub rules' key and offset
    def _make_rule(key, rule, unit=nil)

      mm, dd = 0, 0
      rule['Rule'].each_index do |k|
        subkey = rule['Rule'][k]
        case subkey
        when String, Hash ; rule['Rule'][k] = [subkey, dd, mm]
        when Array        ; subkey, dd, mm  = rule['Rule'][k]
        else              ; raise TypeError, "Irregal subkey type"
        end
        if subkey.kind_of?(String)
          mm += subkey.length
          dd += subkey.length * 29 + subkey.gsub(/[a-z]/,'').length
        else
          mm += subkey['Months']
          dd += subkey['Days']
        end
      end

      rule['Years']  ||= rule['Rule'].length
      rule['Months'] ||= mm
      rule['Days']   ||= dd

      @entry_key ||= key
    end
  end

  # 年の配当パターンが限定されている暦
  #
  #   Calendar which has some fixed arrangement rules of year pattern
  #
  class CyclicTableBased < TableBased

    # 通日 - > 年月日
    #
    # @param  [Integer] sdn 通日
    #
    # @return [Array<Integer>] [ y, m, d ]
    #   y 年
    #   m 月 (0 始まり)
    #   d 日 (0 始まり)
    #
    def _number_to_coordinates(sdn)
      root_rule = @rule_table[@entry_key]
      count, value = (sdn-@origin_of_LSC).divmod(root_rule['Days'])
      y, d, key = _read_period(@entry_key, 
                'Days',   value,
                'Years',  count * root_rule['Years'])
      rule = _rule(key)
      (rule['Months']-1).downto(0) do |m|
        if d >=rule['Offset'][m]
          d -= rule['Offset'][m]
          return [y, m, d]
        end
      end
      return nil
    end

    private

    #
    #  new で指定された月日配当規則をプログラムで利用可能にします。
    # 
    #    key  年月日配当規則のハッシュキー
    #    rule 年月日配当規則
    #
    #    インスタンス変数 ハッシュのハッシュ@rule_table の要素
    #      Years  =>  the period length / year
    #      Months =>  the period length / month
    #      Days   =>  the period length / day 
    #      Rule   =>  Array of sub rules' key
    #
    def _make_rule(key, rule, unit=nil)
      if rule.key?('Rule') # Table of Many Years
        ['Years', 'Months', 'Days'].each do |u|
          rule[u] ||= 
            begin
              s = 0
              rule['Rule'].each do |part|
                subkey, count = part
                subrule = @rule_table[subkey]
                _make_rule(subkey, subrule, unit) unless subrule[u]
                s += (count||1) * subrule[u]
              end
              s
            end
        end
        if !@entry_key ||
            @rule_table[@entry_key]['Days'] < rule['Days']
          @entry_key = key
        end
      else                 # Table of One Year
        super
      end
    end

    # 年初の通日によるセットアップ
    def _sdn_setup(c_key, c_date)
      root_rule = @rule_table[@entry_key]
      count, value = c_date[0].divmod(root_rule['Years'])
      sdn, y, key  = _read_period(@entry_key,
                   'Years', value,
                   'Days',  @origin_of_LSC + count * root_rule['Days'])
      @_m_cash_["_key"]        ||= {}
      @_m_cash_["_ids"]        ||= {}
      @_m_cash_["_key"][c_key] ||= key
      @_m_cash_["_ids"][c_key] ||= @_m_cash_["_rule"][key]['IDs']
      @_m_cash_["_sdn"][c_key] ||= sdn
    end

    # 年初の通日
    #
    # @param [Array<Numeric>] date ( y )
    #
    #   y 年
    #
    # @return [Integer] 年初の通日
    #
    def _sdn_(date)
      root_rule = @rule_table[@entry_key]
      count, value = date[0].divmod(root_rule['Years'])
      sdn, y, key  = _read_period(@entry_key,
                   'Years', value,
                   'Days',  @origin_of_LSC + count * root_rule['Days'])
      return sdn
    end

    # 暦日表のキー取得
    #
    # @param [Array<Numeric>] date ( y )
    #
    #   y 年
    #
    # @return [Integer] 暦日表のキー
    #
    def _key_(date)
      root_rule = @rule_table[@entry_key]
      count, value = date[0].divmod(root_rule['Years'])
      sdn, y, key  = _read_period(@entry_key,
                   'Years', value,
                   'Days',  @origin_of_LSC + count * root_rule['Days'])
      return key
    end

    #  年の配当規則を読み出します。
    #
    #    key    年の配当規則のキー
    #    akey   入力が'Days'か'Years'かを指定
    #    avalue 入力の'Days'または'Years'の値
    #    zkey   出力が'Years'か'Days'かを指定
    #    zvalue 出力の'Years'または'Days'の値
    def _read_period(key, akey, avalue, zkey, zvalue)
      rule = @rule_table
      rule[key]['Rule'].each do |part|
        subkey, count, = [*part] << 1
        if avalue >= count * rule[subkey][akey]
          avalue -= count * rule[subkey][akey]
          zvalue += count * rule[subkey][zkey]
        else
          count, avalue = avalue.divmod(rule[subkey][akey])
          zvalue += count * rule[subkey][zkey]
          return zvalue, avalue, subkey unless rule[subkey].key?('Rule')
          return _read_period(subkey, akey, avalue, zkey, zvalue)
        end
      end
    end
  end

  #
  # 年初を太陽黄経で決定する暦
  #
  class YearLengthTableBased < TableBased

    # 天体暦アルゴリズム
    #
    # @return [Array<When::Ephemeris::Formula>]
    #
    attr_reader :formula

    #protected

    private

    # 年初の通日
    #
    # @param [Array<Numeric>] date ( y )
    #
    #   y 年
    #
    # @return [Integer] 年初の通日
    #
    def _sdn_(date)
      y = +date[0]
      t = @formula[0].cn_to_time(y.to_f + @cycle_offset)
      return solar_sdn(t + @day_offset)
    end

    # オブジェクトの正規化
    #
    #   YearLengthTableBased+オブジェクトの性質定義を初期設定します。
    #
    def _normalize(args=[], options={})

      Rational
      @cycle_offset = (@cycle_offset||0).to_r
      @day_offset   = (@day_offset||0).to_r
      @formula      = 'Formula?formula=1S'

      super
    end
  end

  # 月日の配当が太陽または月の位置によって決定される暦
  #
  #   Calendar based on the ephemeris of the Sun or the Moon
  #
  class EphemerisBased < When::TM::Calendar

    # 天体暦
    #
    # @return [When::Ephmeris::Formula]
    #
    attr_reader :formula

    #protected

    # 年月日 -> 通日
    #
    # @param  [Numeric] y 年
    # @param  [Integer] m 月 (0 始まり)
    # @param  [Integer] d 日 (0 始まり)
    #
    # @return [Integer] 通日
    #
    def _coordinates_to_number(y, m, d)
      _new_month(@months_in_year * (+y) + m) + d
    end

    # 通日 - > 年月日
    #
    # @param  [Integer] sdn 通日
    #
    # @return [Array<Integer>] [ y, m, d ]
    #   y 年
    #   m 月 (0 始まり)
    #   d 日 (0 始まり)
    #
    def _number_to_coordinates(sdn)
      m, d = Residue.mod(sdn) {|m| _new_month(m)}
      y, m = m.divmod(@months_in_year)
      return y, m, d
    end

    # 暦要素数
    #
    # @overload _length(date)
    #   @param [Array<Integer>] date ( y )
    #
    #      y 年
    #
    #   @return [Integer] その年の月数
    #
    # @overload _length(date)
    #   @param [Array<Integer>] date ( y, m )
    #
    #      y 年
    #
    #      m 月 (0 始まり)
    #
    #   @return [Integer] その年月の日数
    #
    def _length(date)
      y, m = date
      if (m)
        #  指定した月に含まれる日の数を返します。
        m += @months_in_year * +y
        return _new_month(m+1) - _new_month(m)
      else
        #  指定した年に含まれる月の数を返します。
        return @months_in_year
      end
    end

    # 暦要素数
    #
    # @param [Array<Numeric>] date ( y )
    #
    #   y 年
    #
    # @return [Integer] その年の日数
    #
    def _sum_(date)
      y, = date
      m = @months_in_year * +y
      return _new_month(m+@months_in_year) - _new_month(m)
    end

    private

    # オブジェクトの正規化
    #
    #  @months_in_year = 1年の月の数
    #
    def _normalize(args=[], options={})
      @months_in_year ||= 12
      @formula = When::Parts::Resource._instantiate(@formula)
      super
    end
  end

  # 月日の配当が太陽の位置によって決定される太陽暦
  #
  #   Calendar based on the ephemeris of the Sun
  #
  class EphemerisBasedSolar < EphemerisBased

    #protected

    # 月初の通日
    #
    # @param  [Integer] m 通月
    #
    # @return [Integer] 月初の通日
    #
    def _new_month_(m)
      return solar_sdn(@formula[0].cn_to_time(m + @cycle_offset))
    end

    private

    # オブジェクトの正規化
    # @cycle_offset   = 位相のオフセット / １か月分の角度
    # @formula        = 位相の計算に用いる太陽の Formula
    #
    def _normalize(args=[], options={})
      @cycle_offset   ||= -1.5
      @formula        ||= "Formula?formula=#{@months_in_year||12}S"
      super
    end
 end

  # 月日の配当が月の位相によって決定される純太陰暦
  #
  #   Calendar based on the ephemeris of the Moon
  #
  class EphemerisBasedLunar < EphemerisBased

    #protected

    # 月初の通日
    #
    # @param  [Integer] m 通月
    #
    # @return [Integer] 月初の通日
    #
    def _new_month_(m)
      return lunar_sdn(@formula[-1].cn_to_time(m + @cycle_offset))
    end

    private

    # オブジェクトの正規化
    # @cycle_offset   = Goldstein Number に対する暦元の補正
    #
    def _normalize(args=[], options={})
      @cycle_offset ||= 1671 * 12 + 4
      super
    end
 end

  # 月日の配当が太陽および月の位置によって決定される太陰太陽暦
  #
  #   Calendar based on the ephemeris of the Sun and the Moon
  #
  class EphemerisBasedLuniSolar < EphemerisBasedSolar

    # 計算方法
    # @return [Array<When::Ephemeris::Formula>]
    attr_reader :formula

    #protected

    # 年月日 -> 通日
    #
    # @param  [Numeric] yy 年
    # @param  [Integer] mm 月 (0 始まり)
    # @param  [Integer] dd 日 (0 始まり)
    #
    # @return [Integer] 通日
    #
    def _coordinates_to_number(yy, mm=0, dd=0)
      _new_month(_new_year_month(+yy) + mm) + dd
    end

    # 通日 - > 年月日
    #
    # @param  [Integer] sdn 通日
    #
    # @return [Array<Integer>] ( y, m, d )
    #   [ y 年 ]
    #   [ m 月 (0 始まり) ]
    #   [ d 日 (0 始まり) ]
    #
    def _number_to_coordinates(sdn)
      nn, dd = Residue.mod(sdn) {|m| _new_month(m)}
      yy, mm = Residue.mod(nn)  {|y| _new_year_month(y)}
      [yy, mm, dd]
    end

    # 暦要素数
    #
    # @overload _length(date)
    #   @param [Array<Integer>] date ( 年 )
    #   @return [Integer] その年の月数
    #
    # @overload _length(date)
    #   @param [Array<Integer>] date ( 年, 月 )
    #   @note 月は 0 始まり
    #   @return [Integer] その年月の日数
    #
    def _length(date)
      y, m = date
      if (m)
        #  指定した月に含まれる日の数を返します。
        m += _new_year_month(+y)
        return _new_month(m+1) - _new_month(m)
      else
        #  指定した年に含まれる月の数を返します。
        return _ids([y]).length
      end
    end

    private

    # 暦要素数
    #
    # @param [Array<Numeric>] date ( y )
    #
    #   y 年
    #
    # @return [Integer] その年の日数
    #
    def _sum_(date)
      y = +date[0]
      return _new_month(_new_year_month(y+1)) - _new_month(_new_year_month(y))
    end

    # 太陽月初の通日
    # 
    #
    alias :_new_epoch_ :_new_month_

    # 太陰月初の通日
    #
    # @param  [Integer] m 通月
    #
    # @return [Integer] 月初の通日
    #
    def _new_month_(m)
      lunar_sdn(@formula[-1].cn_to_time(m))
    end

    # 年初の通月
    #
    # @param  [Integer] y 年
    #
    # @return [Integer] 年初の通月
    #
    def _new_year_month_(y)
      raise TypeError, 'EphemerisBasedLuniSolar is abstract class'
    end

    # オブジェクトの正規化
    #
    # @cycle_offset = 雨水の場合 -1
    # @formula      = 位相の計算に用いる太陽と月の Formula
    # @notes        = to_a でデフォルトとして用いる暦注
    #
    def _normalize(args=[], options={})
      @formula ||= ['Formula?formula=12S', 'Formula?formula=1L']
      super
    end
  end

  #
  # 日時要素の境界 - Border
  #
  class Border < When::TM::ReferenceSystem
    #
    # 境界の振舞
    #
    # @return [Numeric]
    #
    #  Pair(-1,+1) - 暦年/暦日が進む(境界が前年/日にあり、境界後が当年/日の扱いになる)
    #
    #  Pair( 0, 0) - 暦年/暦日が戻る(境界が当年/日にあり、境界前が前年/日の扱いになる)
    #
    def behavior
      @border[0]
    end

    # 境界の取得
    #
    # @param [Array<Numeric>] date 境界を計算する年/日
    # @param [When::TM::ReferenceSystem] frame 使用する暦法/時法
    #
    # @return [Array<Numeric>] その年/日の境界
    #
    def border(date=[], frame=nil)
      last = date.length-1
      return @border if (last<0)
      bDate  = date[0..last] + @border[(last+1)..-1]
      branch = @border[last] * 0
      return bDate if (branch==0)
      bDate[last] = When::Coordinates::Pair.new(+date[last]-branch, branch)
      return bDate
    end

    # 境界の正規化
    #
    # @param [Array<Numeric>] date 境界を計算する年/日
    # @param [When::TM::ReferenceSystem] frame 使用する暦法/時法
    #
    # @return [Array<Numeric>] その年/日の境界
    #
    def _adjust_epoch(date, frame=nil)
      s_date  = date.dup
      e_date  = border(date[0..0], frame)
      branch  = behavior * 0
      branch += 1 if ((s_date[1..-1] <=> e_date[1..-1]) < 0)
      s_date[0] = When::Coordinates::Pair.new(+s_date[0]-branch, branch)
      return s_date
    end

    private

    # 要素の正規化
    def _normalize(args=[], options={})
      @border = When::Coordinates::Pair._en_pair_date_time(@border) if (@border.kind_of?(String))
    end
  end

  #
  # 日時要素の境界 - 年/日によって、異なる境界を使用する場合
  #
  class MultiBorder < Border

    #
    # 境界の配列
    # @return [Array<When::CalendarTypes::Border>]
    attr_reader :borders

    #
    # 境界の振舞
    #
    # @return [Numeric]
    #
    #   Pair(-1,+1) - 暦年/暦日が進む(境界が前年/日にあり、境界後が当年/日の扱いになる)
    #
    #   Pair( 0, 0) - 暦年/暦日が戻る(境界が当年/日にあり、境界前が前年/日の扱いになる)
    #
    def behavior
      @borders[0][:border].behavior
    end

    # 境界の取得
    #
    # @param [Array<Numeric>] date 境界を計算する年/日
    # @param [When::TM::ReferenceSystem] frame 使用する暦法/時法
    #
    # @return [Array<Numeric>] その年/日の境界
    #
    def border(date=[], frame=nil)
      last = date.length-1
      return @borders[0][:boder] if (last<0)
      @borders.each do |border|
        return border[:border].border(date, frame) if date[0] >= border[:key]
      end
      date[0..last]
    end

    # 境界の正規化
    #
    # @param [Array<Numeric>] date 境界を計算する年/日
    # @param [When::TM::ReferenceSystem] frame 使用する暦法/時法
    #
    # @return [Array<Numeric>] その年/日の境界
    #
    def _adjust_epoch(date, frame=nil)
      @borders.each do |border|
        next unless date[0] >= border[:key]
        s_date  = date.dup
        e_date  = border[:border].border(date[0..0], frame)
        branch  = border[:border].behavior * 0
        branch += 1 if ((s_date[1..-1] <=> e_date[1..-1]) < 0)
        s_date[0] = When::Coordinates::Pair.new(+s_date[0]-branch, branch)
        return s_date
      end
      date
    end

    private

    # 要素の正規化
    def _normalize(args=[], options={})
      if @borders.kind_of?(String)
        list = @borders.split(/(\(.+?\))/)
        list.shift if list[0]==''
        list.unshift(-Float::MAX) unless list[0] =~ /\(/
        list.push('0-1-1') if list[-1] =~ /\(/
        @borders = []
        loop do
          key, border, *list = list
          break unless key
          key = $1.to_i if key.kind_of?(String) && /\((.+?)\)/ =~ key
          border = "_c:Border?border=#{border}" unless border =~ /^[A-Z_]/i
          border = When.Calendar(border)
          @borders << {:key=>key, :border=>border}
        end
      end
      @borders = @borders.sort_by {|border| -border[:key]}
    end
  end

  #
  # 日時要素の境界 - 日の出,日の入り
  #
  class DayBorder < Border

    # 境界の取得
    #
    # @param [Array<Numeric>] date 境界を計算する日
    # @param [When::TM::ReferenceSystem] clock 使用する時法
    #
    # @return [Array<Numeric>] その日の境界
    #
    # @note 属性 @event によって境界を計算する (see {When::Ephemeris::Formula#day_event})
    #
    def border(date=[], clock=When.utc)
      return @border unless date[0] && clock.formula

      clock._encode(
        clock._number_to_coordinates(clock.second *
          clock.time_standard.from_dynamical_time(
            When::TM::JulianDate._d_to_t(
              clock.formula[-1].day_event(
                clock.time_standard.to_dynamical_date(date[0]), @event, When.Resource('_ep:Sun'), @height
              )))), false)
    end
  end

  #
  # 日時要素の境界 - 日の出
  #
  class SunRise < DayBorder

    private

    # 要素の正規化
    def _normalize(args=[], options={})
      @border   = [0,0,0,0]
      @event    = -1
      @height ||= '0'
    end
  end

  #
  # 日時要素の境界 - 日の入り
  #
  class SunSet < DayBorder

    private

    # 要素の正規化
    def _normalize(args=[], options={})
      @border   = [When::Coordinates::Pair.new(+1,-1),0,0,0]
      @event    = +1
      @height ||= '0'
    end
  end
end
