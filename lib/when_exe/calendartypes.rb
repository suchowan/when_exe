# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2015 Takashi SUGA

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
      @note    ||= 'JulianDay'
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
      return super - @time_standard.localtime_difference unless sdn
      time = When::TM::JulianDate._d_to_t(sdn-0.5)
      @time_standard.to_dynamical_time(time) - When::TimeStandard.to_dynamical_time(time)
    end

    # この時法の時刻を128秒単位の実数に変換する
    #
    # @param [Array<Numeric>] clk_time
    # @param [Integer] sdn 参照事象の通し番号(ダミー)
    #
    # @return [Numeric]
    #
    def to_local_time(clk_time, sdn=nil)
      super - universal_time(sdn)
    end

    #
    # Zone 名
    #
    # @return [String]
    #
    def zone
      iri.split('/')[-1]
    end

    private

    # オブジェクトの正規化
    def _normalize(args=[], options={})
      @origin_of_LSC = - @time_standard.localtime_difference / When::TM::Duration::SECOND
      super
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

  # 
  # 太陰(太陽)暦の朔閏パターンを扱うモジュール
  #
  module Lunar

    # @private
    Pattern = ' ABCDEFGHIJKLMNOPQRSTUVWXYZ'

    # 朔閏表を生成する
    #
    # @param  [Range] year_range 生成範囲(西暦年)
    # @param  [Integer] length 大の月の日数
    # @param  [When::TM::Duration] duration チェックする月の間隔
    #
    # @return [Hash] 朔閏表
    #
    def lunar_table(year_range, length=30, duration=When::P1M)
      date  = When.TemporalPosition(year_range.first, {:frame=>self}).floor
      table = []
      hash  = {
        'origin_of_MSC' => year_range.first,
        'origin_of_LSC' => date.to_i,
        'rule_table'    => table
      }
      list  = ''
      while year_range.include?(date[When::YEAR])
        month = date[When::MONTH] * 1
        char  = Pattern[month..month]
        char  = char.downcase unless date.length(When::MONTH) == length
        list += char
        succ  = date + duration
        unless date[When::YEAR] == succ[When::YEAR]
          table << list
          list = ''
        end
        date = succ
      end
      hash
    end

    # 朔閏表を比較する
    #
    # @param  [When::TM::Calendar] base 基準とする暦法
    # @param  [Range] year_range 比較範囲(西暦年)
    # @param  [Integer] length 大の月の日数
    # @param  [When::TM::Duration] duration チェックする月の間隔
    #
    # @return [Hash] 朔閏表の差分
    #
    def verify(base, year_range=base.year_range, length=30, duration=When::P1M)
      year_range = When::Parts::GeometricComplex.new(year_range) & When::Parts::GeometricComplex.new(self.year_range) if respond_to?(:year_range)
      base_table = base.lunar_table(year_range, length, duration)
      self_table = self.lunar_table(year_range, length, duration)
      hash = {}
      year_range.each do |year|
        difference = _verify(base_table['rule_table'][year-year_range.first],
                             self_table['rule_table'][year-year_range.first])
        hash[year] = difference if difference
      end
      hash
    end

    # @private
    def _verify(source, target)
      return nil if source == target
      return {source => target} unless source.length == target.length
      indices = []
      index   = []
      source.length.times do |i|
        if source[i..i] == target[i..i]
          unless index.empty?
            indices << index
            index = []
          end
        else
          index << i
        end
      end
      indices << index unless index.empty?
      ranges = []
      indices.each do |index|
        if ranges.empty? || index.first > ranges.last.last + 2
          ranges << index
        else
          ranges[-1] = [ranges.last.first,index.last]
        end
      end
      hash = {}
      ranges.each do |index|
        range = index.first..index.last
        hash[source[range]] = target[range]
      end
      test = source.dup
      hash.each_pair do |key, value|
        test.sub!(key, value)
      end
    # raise ArgumentError, "can't replace '#{source}'=>'#{target}' by #{hash}." unless test == target
      return hash if test == target
      {source => target}
    end
  end

  # 
  # 朔閏パターンの表の拡張
  #
  module TableExtend

    # 年月日 -> 通日
    #
    # @param  [Numeric] y 年
    # @param  [Integer] m 月 (0 始まり)
    # @param  [Integer] d 日 (0 始まり)
    #
    # @return [Integer] 通日
    #
    def _coordinates_to_number(y, m, d)
      if @after && y >= @rule_table[@entry_key]['Years']
        _normalize_after
        return @after._coordinates_to_number(y + @_after_offset, m, d)
      end
      if @before && y < 0
        _normalize_before
        return @before._coordinates_to_number(y + @_before_offset, m, d)
      end
      super
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
      if @after && sdn >= @origin_of_LSC + @rule_table[@entry_key]['Days']
        _normalize_after
        y, m, d = @after._number_to_coordinates(sdn)
        return [y - @_after_offset, m, d]
      end
      if @before && sdn < @origin_of_LSC
        _normalize_before
        y, m, d = @before._number_to_coordinates(sdn)
        return [y - @_before_offset, m, d]
      end
      super
    end

    #
    # その他のテーブル参照
    #
    %w(ids_ length).each do |method|
      module_eval %Q{
        def _#{method}(date)
          if @after && +date[0] >= @rule_table[@entry_key]['Years']
            _normalize_after
            date[0] += @_after_offset
            return @after.send(:_#{method}, date)
          end
          if @before && +date[0] < 0
            _normalize_before
            date[0] += @_before_offset
            return @before.send(:_#{method}, date)
          end
          super
        end
      }
    end

    private

    def _normalize_after
      raise RangeError, "Out of range: #{iri}" if @after.kind_of?(Symbol)
      @after = When.Calendar(@after)
      @_after_offset = @origin_of_MSC - @after.origin_of_MSC
      class << self; alias :_normalize_after :_normalize_non end
    end

    def _normalize_before
      raise RangeError, "Out of range: #{iri}" if @before.kind_of?(Symbol)
      @before = When.Calendar(@before)
      @_before_offset = @origin_of_MSC - @before.origin_of_MSC
      class << self; alias :_normalize_before :_normalize_non end
    end

    def _normalize_non
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
      if m
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
      # range extension
      extend(TableExtend) if @before || @after

      super

      # rule_table
      # @rule_table = @rule_table.dup
      @rule_table = {'T' => {'Rule' => @rule_table }} if @rule_table.kind_of?(Array)
      @_m_cash_          = Hash.new {|hash,key| hash[key]={}}
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
      key   = (n_sdn - c_sdn).to_i
      rule  = (@_m_cash_["_rule"][key]  ||= _rule_(key))
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
     (_sdn(n_date) - _sdn(date)).to_i
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
        'Days'   => _year_length(key),
        'IDs'    => [],
        'Length' => [],
        'Offset' => []
      }

      key.length.times do |m|
        rule['Length'] << _month_length(key, m)
        rule['Offset'] << (m == 0 ? 0 : rule['Offset'][m-1]+rule['Length'][m-1])
        rule['IDs'] << _month_id(key, m)
      end
      return rule
    end
  end

  # 表引きにより実現する太陰太陽暦
  #
  #   Luni-Solar calendar which uses year / month /day table
  #
  class PatternTableBasedLuniSolar < TableBased

    include Lunar

    class << self
      #
      # ひとつのひな型朔閏表からの差分で朔閏表を生成する
      #
      # @param [Array] definition ひな型朔閏表
      # @param [Range] year_range 生成する朔閏表の年代範囲
      # @param [Hash{Integer=>(String or Hash{String or Regexp=>String})}] difference 差分情報
      #
      # @return [Array] 生成された朔閏表定義
      #
      def patch(definition, year_range=nil, difference={})
        When.Calendar(definition)
        base         = When::CalendarTypes.const_get(definition)
        hash         = base[-1].dup
        year_range ||= hash['origin_of_MSC']...(hash['origin_of_MSC']+hash['rule_table'].size)
        year_range   = year_range.to_a
        hash['origin_of_LSC'] += hash['rule_table'][year_range[0]-hash['origin_of_MSC']][1]
        hash['rule_table']     = year_range.map {|year|
          original = hash['rule_table'][year-hash['origin_of_MSC']][0]
          case difference[year]
          when String ; next difference[year]
          when nil    ; next original
          end
          original = original.dup
          difference[year].each_pair {|key,value|
            raise ArgumentError, "Can't patch \"#{original}\" by {#{key}=>#{value}} at #{year}" unless original.sub!(key,value)
          }
          original
        }
        hash['origin_of_MSC']  = year_range[0]
        base[0..-2] + [hash]
      end

      #
      # 複数のひな型朔閏表からの差分で朔閏表を生成する
      #
      # @param [[Array<Array<String, Range>>]] definitions ひな型朔閏表
      #     - String - もとにする太陰太陽暦のIRI文字列
      #     - Range  - 朔閏表の年代範囲(デフォルトはもとにする太陰太陽暦の年代範囲)
      # @param [Hash{Integer=>(String or Hash{String or Regexp=>String})}] difference 差分情報
      #
      # @return [Array] 生成された朔閏表定義
      #
      def join(definitions, difference={})
        if definitions.first.kind_of?(Array)
          base = When::CalendarTypes.const_get(definitions.first[0]).dup
        else
          base = []
          base << definitions.shift until definitions.first.kind_of?(Array)
        end
        tables = definitions.map {|definition|
          When.Calendar(definition[0]).lunar_table(definition[1])
        }
        hash   = base.pop.merge({
          'origin_of_MSC' => tables.first['origin_of_MSC'],
          'origin_of_LSC' => tables.first['origin_of_LSC'],
          'rule_table'    => tables.inject([]) {|rules, table| rules += table['rule_table']}
        })
        difference.each_pair do |year, pattern|
          offset = year - hash['origin_of_MSC']
          hash['rule_table'][offset] =
           if pattern.kind_of?(Hash)
              rule = hash['rule_table'][offset].dup
              pattern.each_pair do |key,value|
                raise ArgumentError, "Can't patch \"#{rule}\" by {#{key}=>#{value}} at #{year}" unless rule.sub!(key,value)
              end
              rule
            else
              pattern
            end
        end
        base << hash
      end
    end

    # 朔閏表を生成する
    #
    # @param  [Range] sub_range 生成範囲(西暦年) デフォルトは self.year_range
    # @param  [Integer] length 大の月の日数(ダミー)
    # @param  [When::TM::Duration] duration チェックする月の間隔(ダミー)
    #
    # @return [Hash] 朔閏表
    #
    def lunar_table(sub_range=nil, length=nil, duration=nil)
      sub_range ||= year_range
      last  = sub_range.last
      last -= 1 if sub_range.exclude_end?
      [sub_range.first, last].each do |edge|
        raise RangeError, 'Range exceeded: ' + sub_range.to_s unless year_range.include?(edge)
      end
      {
        'origin_of_MSC' => sub_range.first,
        'origin_of_LSC' => @origin_of_LSC + @rule_table['T']['Rule'][sub_range.first-@origin_of_MSC][1],
        'rule_table'    => sub_range.to_a.map {|year|
          @rule_table['T']['Rule'][year-@origin_of_MSC][0]
        }
      }
    end

    # 朔閏表の有効範囲
    #
    # @return [Range] 有効範囲(西暦年)
    #
    def year_range
       @origin_of_MSC...(@origin_of_MSC+@rule_table['T']['Rule'].length)
    end

    # 朔閏表の有効範囲(日)
    #
    # @return [Range] 有効範囲(ユリウス通日)
    #
    def sdn_range
       @sdn_range ||= @origin_of_LSC...(@origin_of_LSC+@rule_table['T']['Days'])
    end

    # 指定の日付は有効か?
    #
    # @param [When::TM::CalDate or Integer] date
    #
    # @return [Boolean] true 有効 / false 無効
    #
    def within_sdn_range?(date)
      date = date.to_i
      return true if sdn_range.include?(date)
      if date <= sdn_range.first
        case @before
        when PatternTableBasedLuniSolar; @before.within_sdn_range?(date)
        when false, nil                ; false
        else                           ; true
        end
      else
        case @after
        when PatternTableBasedLuniSolar; @after.within_sdn_range?(date)
        when false, nil                ; false
        else                           ; true
        end
      end
    end

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

      offsets = [0, 0]
      rule['Rule'].each_index do |k|
        subkey = rule['Rule'][k]
        if subkey.kind_of?(Array)
          subkey, *offsets = rule['Rule'][k]
        else
          subkey = _make_subkey(subkey)
          rule['Rule'][k] = [subkey] + offsets
        end
        _increment_offsets(offsets, subkey)
      end

      rule['Years']  ||= rule['Rule'].length # 年数
      rule['Months'] ||= offsets[1]          # 月数
      rule['Days']   ||= offsets[0]          # 日数

      @entry_key     ||= key
    end

    # 恒等変換
    alias :_make_subkey :_do_nothing

    # オフセットの更新
    def _increment_offsets(offsets, subkey)
      offsets[1] += subkey.length        # 月のオフセットを月数分進める
      offsets[0] += _year_length(subkey) # 日のオフセットを日数分進める
    end

    # 年初の通日によるセットアップ
    def _sdn_setup(c_key, c_date)
      root_rule   = @rule_table[@entry_key]
      count, year = c_date[0].divmod(root_rule['Years'])
      key, dd, mm = root_rule['Rule'][year]
      rule = (@_m_cash_["_rule"][key] ||= _rule_(key))
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

    # 朔閏パターン -> 日数/年
    #
    # @param [String] key 朔閏パターン
    #
    # @return [Integer] 日数/年
    #
    def _year_length(key)
      key.length * 29 + key.gsub(/[a-z]/,'').length
    end

    # 朔閏パターン -> 日数/年
    #
    # @param [String] key 朔閏パターン
    # @param [Integer] m 月番号(0始まり)
    #
    # @return [Integer] 日数/月
    #
    def _month_length(key, m)
      key[m,1] =~ /[a-z]/ ? 29 : 30
    end

    # 朔閏パターン -> 月のID
    #
    # @param [String] key 朔閏パターン
    # @param [Integer] m 月番号(0始まり)
    #
    # @return [Integer] 月のID
    #
    def _month_id(key, m)
      trunk  = key.upcase[m]
      branch = trunk == key.upcase[m-1] ? 1 : 0
      trunk  = trunk.ord if trunk.kind_of?(String)
      trunk -= 64
      branch == 0 ? trunk : When::Coordinates::Pair.new(trunk, branch)
    end
  end

  # 表引きにより実現する太陰太陽暦(29,30日以外の月がある場合)
  #
  #   Luni-Solar calendar which has months with irregular length
  #
  class PatternTableBasedLuniSolarExtended < PatternTableBasedLuniSolar

    private

    # rule の遅延生成
    def _rule_(key)
      key.kind_of?(Hash) ? key : super
    end

    # オフセットの更新
    def _increment_offsets(offsets, subkey)
      return super unless subkey.kind_of?(Hash)
      offsets[1] += subkey['Months'] # 月のオフセットを月数分進める
      offsets[0] += subkey['Days']   # 日のオフセットを日数分進める
    end
  end

  # 表引きにより実現する太陰太陽暦(Ephemerisにより朔を決定する)
  #
  #   Luni-Solar calendar whose new moon is determined by 'engine' calendar
  #
  class PatternTableBasedLuniSolarWithEphemeris < PatternTableBasedLuniSolar

    private

    # subkeyの生成
    def _make_subkey(key)
      pattern = @subkey_table[key]
      subkey  = ''
      pattern.length.times do |i|
        @month_no    += 1
        next_new_moon = @engine._new_month(@month_no)
        subkey       += next_new_moon - @new_moon >= 30 ? pattern[i..i].upcase : pattern[i..i].downcase
        @new_moon     = next_new_moon
      end
      subkey
    end

    # オブジェクトの正規化
    #
    #   PatternTableBasedLuniSolarWithEphemeris オブジェクトの性質定義を初期設定します。
    #
    def _normalize(args=[], options={})
      @engine   = When.Calendar(@engine)
      divmod    = When::Coordinates::Residue.mod(@origin_of_LSC.to_i+3) {|cn| @engine.formula[-1].cn_to_time(cn)}
      @month_no = divmod[0]
      @new_moon = @origin_of_LSC.to_i+3 - divmod[1]
      super
    end
  end

  # 表引きにより実現する太陽暦(閏月なし, 5,6,27～34日の月に対応)
  #
  #   Solar calendar which uses year / month /day table
  #
  class PatternTableBasedSolar < PatternTableBasedLuniSolar

    private

    # 朔閏パターン -> 日数/年
    #
    # @param [String] key 朔閏パターン
    #
    # @return [Integer] 日数/年
    #
    def _year_length(key)
      length = 0
      key.length.times do |m|
        length += _month_length(key, m)
      end
      length
    end

    # 朔閏パターン -> 日数/年
    #
    # @param [String] key 朔閏パターン
    # @param [Integer] m 月番号(0始まり)
    #
    # @return [Integer] 日数/月
    #
    def _month_length(key, m)
      trunk  = key.upcase[m]
      trunk  = trunk.ord if trunk.kind_of?(String)
      trunk -= 48
      case trunk
      when 5, 6 ; trunk
      when 7..9 ; trunk + 20
      else      ; trunk + 30
      end
    end

    # 朔閏パターン -> 月のID
    #
    # @param [String] key 朔閏パターン
    # @param [Integer] m 月番号(0始まり)
    #
    # @return [Integer] 月のID
    #
    def _month_id(key, m)
      m + 1
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
  # 年初を太陽黄経または別の暦で決定する暦
  #
  class SolarYearTableBased < TableBased

    module CalendarBased

      # 年初の通日(別の暦使用)
      #
      # @param [Numeric] year 年
      #
      # @return [Integer] 年初の通日
      #
      def _new_year_sdn(year)
        @engine._coordinates_to_number(year + @diff_to_CE - @engine.diff_to_CE, @engine_month, @engine_day)
      end

      # オブジェクトの正規化
      def _normalize_engine
        Rational
        @engine_month = @engine_month ? @engine_month.to_i - @indices[-2].base : 0
        @engine_day   = @engine_day   ? @engine_day.to_i   - @indices[-1].base : 0
        @engine       = When.Calendar(@engine || When::Gregorian)
      end
    end

    # 天体暦アルゴリズム
    #
    # @return [Array<When::Ephemeris::Formula>]
    #
    attr_reader :formula

    private

    # 年初の通日(天体暦使用)
    #
    # @param [Numeric] year 年
    #
    # @return [Integer] 年初の通日
    #
    def _new_year_sdn(year)
      solar_sdn(@formula[0].cn_to_time(year.to_f + @cycle_offset) + @day_offset)
    end

    # オブジェクトの正規化
    def _normalize_engine
      Rational
      @cycle_offset = @cycle_offset ? (@cycle_offset == @cycle_offset.to_i ? @cycle_offset.to_i : @cycle_offset.to_r) : 0
      @day_offset   = @day_offset   ? (@day_offset   == @day_offset.to_i   ? @day_offset.to_i   : @day_offset.to_r  ) : 0
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
      _new_year_sdn(+date[0])
    end

    # オブジェクトの正規化
    #
    #   SolarYearTableBased オブジェクトの性質定義を初期設定します。
    #
    def _normalize(args=[], options={})

      extend CalendarBased unless @formula || @location || @long || @lat || @alt || @time_basis
      _normalize_engine
      super
    end
  end

  #
  # 年初を特定の日の日の出で決定する暦
  #
  class SolarYearTableBasedWithSunrise < SolarYearTableBased

    # 年初の通日(天体暦使用)
    #
    # @param [Numeric] year 年
    #
    # @return [Integer] 年初の通日
    #
    def _new_year_sdn(year)
      event_time  = @formula[0].cn_to_time(year.to_f + @cycle_offset)
      event_date  = (event_time + 0.5 + @formula[0].long/360.0).floor
      sunset_time = @formula[0].sunrise(event_date)
      event_date -= 1 if sunrise_time > event_time
      event_date + @day_offset
    end
  end

  #
  # 年初を特定の日の日の入りで決定する暦
  #
  class SolarYearTableBasedWithSunset < SolarYearTableBased

    # 年初の通日(天体暦使用)
    #
    # @param [Numeric] year 年
    #
    # @return [Integer] 年初の通日
    #
    def _new_year_sdn(year)
      event_time  = @formula[0].cn_to_time(year.to_f + @cycle_offset)
      event_date  = (event_time + 0.5 + @formula[0].long/360.0).floor
      sunset_time = @formula[0].sunset(event_date)
      event_date += 1 if sunset_time <= event_time
      event_date + @day_offset
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
      if m
        #  指定した月に含まれる日の数を返します。
        m += @months_in_year * +y
        _new_month(m+1) - _new_month(m)
      else
        #  指定した年に含まれる月の数を返します。
        @months_in_year
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
      _new_month(m+@months_in_year) - _new_month(m)
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
      solar_sdn(@formula[0].cn_to_time(m + @cycle_offset))
    end

    private

    # オブジェクトの正規化
    # cycle_offset   = 位相のオフセット / １か月分の角度
    # formula        = 位相の計算に用いる太陽の Formula
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

    include Lunar

    #protected

    # 月初の通日
    #
    # @param  [Integer] m 通月
    #
    # @return [Integer] 月初の通日
    #
    def _new_month_(m)
      lunar_sdn(@formula[-1].cn_to_time(m + @cycle_offset))
    end

    private

    # オブジェクトの正規化
    # cycle_offset   = Goldstein Number に対する暦元の補正
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

    include Lunar

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
    def _coordinates_to_number(yy, mm, dd)
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
      if m
        #  指定した月に含まれる日の数を返します。
        m += _new_year_month(+y)
        _new_month(+m+1) - _new_month(+m)
      else
        #  指定した年に含まれる月の数を返します。
        _ids([y]).length
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
      _new_month(_new_year_month(y+1)) - _new_month(_new_year_month(y))
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
    # cycle_offset = 雨水の場合 -1
    # formula      = 位相の計算に用いる太陽と月の Formula
    # notes        = to_a でデフォルトとして用いる暦注
    #
    def _normalize(args=[], options={})
      @formula ||= ['Formula?formula=12S', 'Formula?formula=1L']
      super
    end
  end
end
