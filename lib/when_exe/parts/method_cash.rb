# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

#
# 本ライブラリのための諸々の部品
#
module When::Parts

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

      if ((name.to_s =~ /^(_*)(.+?)_to_(.+)$/) && respond_to?("#{$1}#{$3}_to_#{$2}_", true))
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

  #
  # デバッグのためのオブジェクト内部記録用
  # @private
  module SnapShot

    @@depth = 2

    class << self
      def _default(depth=2)
        @@depth = depth
      end

      def _snapshot(object, depth=@@depth, processed={})
        obj = object.dup rescue (return object)
      # def obj.is_snapshoted? ; true ; end
        if (depth==0 || processed.key?(object))
          return object if object.instance_of?(String)
          string = object.to_s
          string = "<##{object.class}>" + string unless (string =~ /^#</)
          return string
        else
          object.instance_variables.each do |v|
            if ((v =~ /^@_/) && object.kind_of?(SnapShot))
              obj._remove_instance_variable(v)
            else
              src = object.instance_variable_get(v)
              case src
              when Array
                val = src.map {|e| _snapshot(e, depth-1, processed)}
              when Hash
                val = {}
                src.each_pair {|k,c| val[_snapshot(k, depth-1, processed)] = _snapshot(c, depth-1, processed)}
              else
                val = _snapshot(src, depth-1, processed)
              end
              obj.instance_variable_set(v, val)
            end
          end
          processed[object] = true
        end
        return obj
      end
    end

    def _snapshot(depth=@@depth, processed={})
      SnapShot._snapshot(self, depth, processed)
    end

    private

    def _remove_instance_variable(name)
      remove_instance_variable(name) if (name =~ /^@_/)
    end
  end
  # module Resource ; include SnapShot ; end
end
