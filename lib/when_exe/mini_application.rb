# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2013-2015 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

require 'socket'

#
# Time for v1.8.x compatibility
#
class Time
  if Time.now.respond_to?(:strftime) && Time.now.strftime('%FT%X.%L').length > 0
    alias :_log_ :strftime
  else
    def _log_(format)
      "%04d-%02d-%02dT%02d:%02d:%02d.%03d" % [year, month, day, hour, min, sec, usec / 1000]
    end
  end
end

#
# Micro Client / Server
#
module When
  class << self

    #
    # 設定ファイルを読み込む
    # @private
    def config(path=File.expand_path($0) + '.config')
      config = {}
      open(path, 'r') do |file|
        while (line=file.gets)
          next if line =~ /\A\s*#/
          key, *value = line.chomp.split(':')
          value = value[0] if value.size <= 1
          config[key] = value
        end
      end
      config
    rescue
      {}
    end
    
    #
    # マイクロ・サーバーを起動する
    #
    # @param [#to_i] port 待ち受けるポート番号
    #
    # @return [void]
    #
    # @note mini_application
    #
    def server(port)
      config = When.config
      TCPServer.open(port.to_i) do |socket|
        puts Time.now._log_('%FT%X.%L') + ': Start'
        loop do
          Thread.start(socket.accept) do |client|
            query = client.gets.chomp.force_encoding("UTF-8")
            start = Time.now
            puts start._log_('%FT%X.%L') + ': Query - ' + When::Locale.translate(query, config['!'])
            begin
              result = free_conv(*query.split(/\s+/))
              result = When::Locale.translate(result, config['!'])
              client.puts JSON.generate(Array(_to_string(result))).to_s
              stop = Time.now
              puts stop._log_('%FT%X.%L') + ": Respond (%7.0f ms)" % (1000 * (stop.to_f - start.to_f))
            rescue => err
              puts Time.now._log_('%FT%X.%L') + ': error - ' + err.to_s
              client.puts JSON.generate({:error=>query}).to_s
            end
            client.close
          end
        end
      end
    rescue Exception => e
      puts Time.now._log_('%FT%X.%L') + ': Exception - ' + e.to_s
    ensure
      puts Time.now._log_('%FT%X.%L') + ': Done.'
    end

    #
    # マイクロ・クライアントを実行する
    #
    # @param [String] server マイクロ・サーバのアドレス
    # @param [#to_i] port つなぐポート番号
    # @param [String] query 問い合わせ文字列
    #
    # @return [JSON] 応答
    #
    # @note mini_application
    #
    def client(server, port, query)
      TCPSocket.open(server, port.to_i) do |socket|
        socket.puts(query)
        results = JSON.parse(socket.gets.force_encoding("UTF-8"))
        results = Hash[*results.flatten(1)] if results[0].kind_of?(Array)
        _to_symbol(results)
      end
    end

    # 日付の自由変換
    #
    # @param [Array<String, When::TM::TemporalPosition, When::TM::CalendarEra or When::TM::Calendar>] args コマンドライン入力
    # @param [Block] block ブロック
    #
    # @return [Array<Hash>] 変換結果
    # @return [Array<Array<Numeric>>] 最良近似分数列
    #
    # @note 暦法のIRI, When.exe Standard Expression, 最良近似分数列の分母分子などを文字列で指定
    # @note mini_application
    #
    def free_conv(*args, &block)
      calendars, dates, numbers, methods, output, options = _parse_command(args)

      if numbers.size >= 2 && calendars.size == 0
        result = []
        When::Coordinates::Residue.new(numbers[0], numbers[1]).each { |v| result << v }
        return result
      end

      block ||= 
        if methods.size == 0
          lambda {|date| date.send(*output)}
        else
          lambda {|date, type| column(date, type)}
        end
      _free_conv(calendars, dates, methods, output, options, &block)
    end

    # 七曜表の一日分
    #
    # @param [When::TM::TemporalPosition] date 処理する一日
    # @param [Integer, nil] type 当該日の種類
    #
    # @return [Object>] 処理結果
    #
    def column(date, type)
      case type
      when When::YEAR  ; date.strftime("%Y")
      when When::MONTH ; date.strftime("%B %Y")
      when When::WEEK  ; nil
      when When::DAY   ; date[0]
      else             ; '-'
      end
    end

    private

    # to_h メソッドのオプション設定
    HashMethod = {:iri     => [:to_h, {:method=>:iri    , :prefix=>true}],
                  :to_m17n => [:to_h, {:method=>:to_m17n, :prefix=>true}]}

    # 引数読み込み
    #
    # args [String] コマンドライン入力
    #
    # @return [Array] ( calendars, dates, numbers, methods )
    #   [ calendars [Array<When::TM::Calendar or When::TM::CalendarEra>]]
    #   [ dates     [Array<When::TM::CalData or When::TM::DateAndTime>] ]
    #   [ numbers   [Array<Numeric>]]
    #   [ methods   [Array<String>] メソッド名('week', 'month', 'year') ]
    #   [ output    [Array<Symbol, String>] 出力処理に使うメソッドのシンボルと引数  ]
    #   [ options   [Hash{ :extent=>Boolean, :go_back=><:All || :Before(nil) || :After> }]
    #
    def _parse_command(args)
      calendars = []
      dates     = []
      numbers   = []
      methods   = []
      options   = {}
      output    = [:to_s]

      config    = When.config
      args.flatten.each do |arg|
        case arg
        when Numeric            ; dates << arg ; numbers << arg
        when Hash               ; options.update(arg)
        when Range              ; arg.each {|d| dates << d}
        when Symbol             ; output = [arg]
        when When::TM::CalendarEra,
             When::TM::Calendar ; calendars << arg
        when String
          arg = When::EncodingConversion.to_internal_encoding(arg)
          case arg
          when /\A:(.+?)(?:\[(..)\])?\z/             ; output  = [$1.to_sym, $2].compact
          when /\A(year|month|week)(?:\[(..)\])?\z/i ; methods << [$1.downcase + '_included', $2||'SU']
          when /\A[-+\d]\d*\z/                       ; dates   << arg.to_i ; numbers << arg.to_i
          when /\A[-+.\d][.\d]*\z/                   ; dates   << arg.to_f ; numbers << arg.to_f
          when /\Anow\z/i                            ; dates   << When.now
          when /\Atoday\z/i                          ; dates   << When.today
          when /(^[-+\d])|\^/                      ; dates   << arg
          when /\A\//
            arg[1..-1].scan(/./) do |c|
              c = c.upcase
              if config.key?(c)
                calendar = config[c]
                calendar = calendar.join(':') if calendar.kind_of?(Array)
                calendars << When.Calendar(calendar)
              elsif c == 'D'
                calendars << When::TM::JulianDate
              end
            end
          else
            begin
              calendars << ((arg == 'JulianDate') ? When::TM::JulianDate : When.Calendar(arg))
            rescue NameError, OpenURI::HTTPError
              dates << arg
            end
          end
        else
          dates << arg
        end
      end
      [calendars, dates, numbers, methods, HashMethod[output[0]] || output, options]
    end

    # 変換処理(実行部)
    #
    # @param [When::TM::Calendar, When::TM::CalendarEra] calendars
    # @param [When::TM::CalData, When::TM::DateAndTime] dates
    # @param [String] methods メソッド名('week', 'month', 'year')
    # @param [Hash] options {:extent=>Boolean, :go_back=><:All||:Before(nil)||:After>}
    #
    # @return [Array] 変換結果
    #
    def _free_conv(calendars, dates, methods, output, options, &block)
      dates[0]     ||= When.now
      calendars[0] ||= When::Gregorian
      result = dates.map {|date|
        date = When.when?(date)
        opts = {}
        opts[:location] = date.location if date.location
        opts[:clock   ] = date.clock    if date.respond_to?(:clock) && date.clock
        list = calendars.dup
        (0...calendars.size).to_a.reverse.each do |i|
          case list[i]
          when When::TM::Calendar ; list.slice!(i) if options[:extent] && !list[i].domain[''].include?(date)
          when Class              ; 
          else
             eras = (date ^ list[i]).delete_if {|e| !e.leaf?}
             unless options[:go_back] == :All
               if options[:go_back] == :After
                 eras = [eras[(eras.index {|e| e.calendar_era_go_back}) || -1]]
               else
                 eras.delete_if {|e| e.calendar_era_go_back}
               end
             end
             list[i,1] = eras.map {|e| e.calendar_era}
          end
        end

        if methods.size == 0
          list.map {|calendar|
             calendar.kind_of?(Class) ?
             yield(calendar.new(date, opts.dup)) :
             yield(calendar.^(calendar.rate_of_clock == date.time_standard.rate_of_clock ? date.to_i : date, opts))
          }
        else
          list.map {|calendar|
            date_for_calendar = calendar.^(calendar.rate_of_clock == date.time_standard.rate_of_clock ? date.to_i : date, opts)
            methods.map {|method|
              date_for_calendar.send(method[0].to_sym, method[1], &block)
            }
          }
        end
      }
      result = result[0] while result.kind_of?(Array) && result.size == 1
      return result
    end

    # JSONで通信するために Symbol を String に変換する
    def _to_string(source)
      case source
      when Array
        source.map {|e| _to_string(e)}
      when Hash
        result = {}
        source.each_pair {|k,v|
          result[k.kind_of?(Symbol) ? '_sym_' + k.to_s : k] = _to_string(v)
        }
        result
      else
        source
      end
    end

    # JSONで通信するために String を Symbol に変換する
    def _to_symbol(source)
      case source
      when Array
        source.map {|e| _to_symbol(e)}
      when Hash
        result = {}
        source.each_pair {|k,v|
          result[k =~ /\A_sym_(.+)\z/ ? $1.to_sym : k] = _to_symbol(v)
        }
        result
      else
        source
      end
    end
  end
end
