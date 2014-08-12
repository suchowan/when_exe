#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

Dir.glob('scripts/*.rb') do |script|
  log = script.sub(/\.rb$/, '.txt')
  if FileTest.exist?(log)
    File.open(log, 'r') do |io|
      puts '%s : %s' % [`ruby #{script}` == io.read ? '=' : 'x', log.sub(/^scripts\//, '')]
    end
  else
    File.open(log, 'w') do |io|
      io.write(`ruby #{script}`)
      puts '%s : %s' % ['+', log.sub(/^scripts\//, '')]
    end
  end
end

