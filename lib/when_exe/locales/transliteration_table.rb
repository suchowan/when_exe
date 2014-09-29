# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  module Locale
    class << self

      #
      # Generate Regexp for transliteration
      #
      # @param [Hash] hash transliteration table
      #
      # @return [Regexp] Regexp for transliteration
      #
      def transliteration_keys(hash)
        Regexp.new((hash.keys.sort_by {|key| -key.length} + ['%.*?[A-Za-z]']).join('|'))
      end

      #
      # Generate Hash of {locale=>Regexp} for transliteration
      #
      # @param [Hash] hash transliteration table hash
      #
      # @return [Hash{String=>Regexp}] Hash of {locale=>Regexp} for transliteration
      #
      def transliteration_keys_hash(hash)
        Hash[*(hash.keys.map {|locale|
              [locale, transliteration_keys(hash[locale])]
            }).flatten]
      end

      alias :_method_missing :method_missing

      #
      # Registlation of conversion method
      #
      def method_missing(name, *args, &block)
        table_name = name.to_s.upcase
        return _method_missing(name, *args, &block) unless table_name !~ /_/ && const_defined?(table_name)
        table_obj  = const_get(table_name)
        default    = table_obj.keys.first
        locale     = args[1] || default
        const_set(table_name + '_keys', transliteration_keys_hash(table_obj)) unless const_defined?(table_name + '_keys')
        return send(name, args[0], locale) if respond_to?(name)
        instance_eval %Q{
          def #{name}(string, locale='#{default}')
            string.gsub(#{table_name}_keys[locale]) do |code|
              #{table_name}[locale][code] || code
            end
          end
        }
        args[0].gsub(const_get("#{table_name}_keys")[locale]) do |code|
          table_obj[locale][code] || code
        end
      end
    end
  end
end
