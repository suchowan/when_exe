#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

require 'pp'
require 'yaml'
require 'fileutils'
require 'net/https'

HEADER = <<HEADER
# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  module Locale
HEADER

if "1".respond_to?(:force_encoding)
  Encoding.default_external = 'UTF-8'
  Encoding.default_internal = 'UTF-8'
end
yamls = {}
["locales/yaml", "locales/locales"].each do |dir|
  FileUtils.mkdir_p(dir) unless FileTest.exist?(dir)
end
site  = Net::HTTP.new('github.com', '443')
site.use_ssl = true
site.verify_mode = OpenSSL::SSL::VERIFY_NONE
site.get('/svenfuchs/rails-i18n/tree/master/rails/locale').body.scan(/>([^> ]+?)\.yml</) do |match|
  code   = match[0]
  locale = nil
  begin
    open("locales/yaml/#{code}.yml", 'r') do |source|
      locale = source.read
    end
  rescue Errno::ENOENT
    http = Net::HTTP.new('raw.githubusercontent.com', '443')
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    sleep(1)
    locale = http.get("/svenfuchs/rails-i18n/master/rails/locale/#{code}.yml").body
    locale = locale.force_encoding('UTF-8') if "1".respond_to?(:force_encoding)
    open("locales/yaml/#{code}.yml", 'w') do |file|
      file.write(locale)
    end
  end
  yaml = YAML.load(locale)
  next unless yaml
  time_format = yaml[code]['time']['formats']['default'][/%H.*$/]
  yaml[code]['time']['formats']['time'] ||= time_format.sub(/\s*%Y.*$/,'') if time_format
  yamls[code.sub(/-/,'_')] = {'date'=>yaml[code]['date'], 'time'=>yaml[code]['time'], 'datetime'=>yaml[code]['datetime']}
end

open("locales/locales/autoload.rb", 'w') do |script|
  script.puts HEADER
  yamls.each_key do |key|
    script.puts "    autoload :Locale_%-8s 'when_exe/locales/%s'" % [key + ',', key]
  end
  script.puts "  end"
  script.puts "end"
end

yamls.each_pair do |key, value|
  open("locales/locales/#{key}.rb", 'w') do |script|
    script.puts HEADER
    script.puts "\n    # from https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/#{key.sub(/_/,'-')}.yml"
    script.puts "\n    Locale_#{key} ="
    script.write(value.pretty_inspect)
    script.puts "  end"
    script.puts "end"
  end
end
