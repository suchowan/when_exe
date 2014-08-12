#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

HEAD = <<HEAD
# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

HEAD

if self.class.const_defined?(:Encoding)
  Encoding.default_external = 'UTF-8'
  Encoding.default_internal = 'UTF-8'
end

Dir.glob('../doc/api/*.txt') do |doc|
  File.open(doc, 'r') do |source|
    File.open(doc.sub(/^\.\.\/doc\/api/,'scripts').sub(/\.txt$/,'.rb'), 'w') do |script|
      script.puts HEAD
      while (line=source.gets)
        case line
        when /^$/ ; script.puts
        when /^ / ; script.puts(line[1..-1])
        else      ; script.puts('# ' + line)
        end
      end
    end
  end
end

