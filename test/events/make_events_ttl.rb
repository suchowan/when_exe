# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2016 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

require 'linkeddata'
require 'when_exe'

Encoding.default_external = 'UTF-8'
Encoding.default_internal = 'UTF-8'

path       = ARGV[0] || 'https://raw.githubusercontent.com/suchowan/when_exe/master/test/events/japanese-holiday-index.csv'
datasets   = When.Resource(path)
repository = datasets.repository
puts repository[''].dump(:ttl, :prefixes=>datasets.used_ns)
