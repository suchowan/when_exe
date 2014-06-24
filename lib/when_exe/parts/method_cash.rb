# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  #
  # 本ライブラリのための諸々の部品
  #
  module Parts

    #
    # == メソッドの実行結果をキャッシュし処理の高速化を行う
    #
    # === fn というメソッドをキャッシュ化
    #  * fn ではなく fn_ を定義しておく
    #  * fn メソッドが呼ばれると fn_ を実行し、{引数=>戻り値} を Hash に記憶する
    #  * 同じ引数で再度 fn メソッドが呼ばれると Hash から戻り値を取り出して返す
    #
    # === a_to_b と b_to_a という互いに逆関数のメソッドをキャッシュ化
    #  * a_to_b ではなく a_to_b_ , b_to_a ではなく b_to_a_ を定義しておく
    #  * a_to_b メソッドが呼ばれると a_to_b_ を実行し、{引数=>戻り値}, {戻り値=>引数}を Hash に記憶する
    #  * 同じ引数で再度 a_to_b メソッドが呼ばれると Hash から戻り値を取り出して返す
    #  * b_to_a メソッドが呼ばれ Hash に戻り値があれば Hash から戻り値を取り出して返す
    #
    # == 特記事項
    #
    # === Argument identification
    #   The eql? method of When::TM::(Temporal)Position is not overridden.
    #   It seems that the cost of identification of the argument exceeds the merit of the method cash.
    #   I do not recommend applying the methodcash to the method which takes
    #   When::TM::(Temporal)Position as an argument.
    #
    # === Multi-thread critical situation
    #   There is a problem in consistency of hash when this function is used in multi-thread environment.
    #   If the initialize method sets Mutex in instance variable @_m_cash_lock_,
    #   this function gives up use of hash in the critical situation.
    #
    #   class Foo
    #     include MethodCash
    #
    #     def initialize
    #       ...
    #       @_m_cash_lock_ = Mutex.new
    #       ...
    #      end
    #   end
    #
    #   参考 http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-list/47663
    #
    module MethodCash

      # @private
      Escape = {:to_str  => true,
                :to_ary  => true,
                :to_hash => true}

      class << self

        # '_' で終わるメソッドをキャッシュせずに毎回計算するか否か
        #
        # @return [Boolean] キャッシュしない true, キャッシュする false/nil
        #
        attr_accessor :direct

        # When::Parts::MethodCash のグローバルな設定を行う
        #
        # @param [Hash] options 以下の通り
        # @option options [Boolean]               :direct '_' で終わるメソッドをキャッシュせずに毎回計算するか否か
        # @option options [Hash{Symbol=>boolean}] :escape 毎回 method_missing を発生させるメソッドを true にする
        # @option options [false, nil]            :escape to_str, to_ary, to_hash のみ毎回 method_missing を発生させる
        # @option options [true]                  :escape すべて毎回 method_missing を発生させる
        #
        # @return [void]
        #
        # @note When::TM::Calendar クラスの一部はキャッシュ使用を前提としているため :direct=>true では動作しません
        #
        def _setup_(options={})
          @_setup_info = options
          @direct      = options[:direct]
          case options[:escape]
          when true
            instance_eval %Q{
              def escape(method)
                true
              end
            }
          when Hash
            @escape = Escape.merge(options[:escape])
            instance_eval %Q{
              def escape(method)
                @escape[method]
              end
            }
          else
            instance_eval %Q{
              def escape(method)
                Escape.key?(method)
              end
            }
          end
        end

        # 設定情報を取得する
        #
        # @return [Hash] 設定情報
        #
        def _setup_info
          @_setup_info ||= {}
        end

        # method_missing メソッドを forward するか否か
        #
        # @param [Symbol] method メソッドシンボル
        #
        # @return [boolean] true - しない, false/nil - する
        #
        def escape(method)
          Escape.key?(method)
        end
      end

      alias :method_missing_ :method_missing

      #
      # 最初に発生する method_missing で、キャッシュ機能を登録する
      #
      # @param [Symbol] name メソッド名
      # @param [Array] args メソッド引数
      # @param [block] block ブロック(省略可)
      #
      # @return [void]
      #
      def method_missing(name, *args, &block)

        return method_missing_(name, *args, &block) unless respond_to?("#{name}_", true)
        return send("#{name}_",  *args, &block) if MethodCash.direct

        if ((name.to_s =~ /\A(_*)(.+?)_to_(.+)\z/) && respond_to?("#{$1}#{$3}_to_#{$2}_", true))
          prefix, from, to = $~[1..3]
          begin
            if (@_m_cash_lock_)
              return send("#{prefix}#{from}_to_#{to}_", *args, &block) unless @_m_cash_lock_.try_lock
              unlock = "ensure ; @_m_cash_lock_.locked? && @_m_cash_lock_.unlock"
            end
            [[from, to],[to, from]].each do |pair|
              a, b = pair
              lock = @_m_cash_lock_ ? "  return #{prefix}#{a}_to_#{b}_(*args) unless @_m_cash_lock_.try_lock" : ''
              instance_eval %Q{
                def #{prefix}#{a}_to_#{b}(*args)
                  key = _key_simplefy(args)
                  inv = @_m_cash_["#{prefix}#{a}_to_#{b}"][key]
                  return inv if inv
                  begin
                  #{lock}
                    inv = #{prefix}#{a}_to_#{b}_(*args)
                    @_m_cash_["#{prefix}#{b}_to_#{a}"][_key_simplefy(inv)] = args
                    @_m_cash_["#{prefix}#{a}_to_#{b}"][key] = inv
                    return inv
                  #{unlock}
                  end
                end
              }
            end
            key = _key_simplefy(args)
            inv = send("#{prefix}#{from}_to_#{to}_", *args)
            @_m_cash_ ||= {}
            @_m_cash_["#{prefix}#{to}_to_#{from}"]    ||= {}
            @_m_cash_["#{prefix}#{from}_to_#{to}"]    ||= {}
            @_m_cash_["#{prefix}#{to}_to_#{from}"][_key_simplefy(inv)] = args
            @_m_cash_["#{prefix}#{from}_to_#{to}"][key] = inv
            return inv
          ensure
            @_m_cash_lock_ && @_m_cash_lock_.locked? && @_m_cash_lock_.unlock
          end

        else
          begin
            respond = respond_to?("#{name}_setup", true)
            setup   = respond ? "#{name}_setup(key, *args)" :
                                "(@_m_cash_[\"#{name}\"][key] = #{name}_(*args))"
            if (@_m_cash_lock_)
              return send("#{name}_", *args, &block) unless @_m_cash_lock_.try_lock
              lock   = "  return #{name}_(*args) unless @_m_cash_lock_.try_lock"
              unlock = "ensure ; @_m_cash_lock_.locked? && @_m_cash_lock_.unlock"
            end
            instance_eval %Q{
              def #{name}(*args)
                key = _key_simplefy(args)
                ret = @_m_cash_["#{name}"][key]
                return ret if ret
                begin
                #{lock}
                  return #{setup}
                #{unlock}
                end
              end
            }
            key = _key_simplefy(args)
            @_m_cash_ ||= {}
            @_m_cash_["#{name}"] ||= {}
            if (respond)
              return send("#{name}_setup", key, *args)
            else
              return(@_m_cash_["#{name}"][key] ||= send("#{name}_", *args))
            end
          ensure
            @_m_cash_lock_ && @_m_cash_lock_.locked? && @_m_cash_lock_.unlock
          end
        end
      end

      private

      def _key_simplefy(args)
        key = args.kind_of?(Array) ? args.dup : args
        key = key[0] while key.kind_of?(Array) && key.length<=1
        return key
      end
    end
  end
end
