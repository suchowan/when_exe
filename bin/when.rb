#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

require 'pp'
require 'when_exe'
require 'when_exe/mini_application'
args   = ARGV.map {|arg| arg.encode('UTF-8')}
config = When.config
server, port = config['?']
result = !port || !Object.const_defined?(:JSON) ? When.free_conv(*args) : args == [] ? When.server(port) : When.client(server, port, args.join(' '))
pp When::Locale.translate(result, config['!']) if result
