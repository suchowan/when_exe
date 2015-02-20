# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2015 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  VERSION   = "0.4.1"
  YEARS     = "(C) 2011-2015"
  AUTHOR    = "Takashi SUGA"
  COPYRIGHT = "#{YEARS} #{AUTHOR}"

  class BasicTypes::M17n
    Rights = [self, [
      "locale:[=en:, ja=ja:, alias]",
      "names:[Basic information=, 基本情報=, *alias:Rights=]",
      "[#{YEARS}=, *alias:Years]",
      "[#{AUTHOR}=http://hosi.org/TakashiSuga, 須賀 隆=, *alias:Author=]",
      "[When.exe written in Ruby language=http://www2u.biglobe.ne.jp/~suchowan/when_exe_wiki.html,  When.exe Ruby版=,  *alias:Title=]",
      "[Gem Ver. #{VERSION}=http://rubygems.org/gems/when_exe, *alias:Version=]"
    ]]
  end
end
