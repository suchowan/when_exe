# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2015 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module When::Coordinates

  LocationTable = [

    # 0 : Resource Pool
    {},

    # 1 : Fine Area Coordinates
    {},

    # 2 : Middle Area  Coordinates
    Hash.new {|h,k|
      h[k] = {}
    },

    # 3 : Wide Area Coordinates
    Hash.new {|h1,k1|
      h1[k1] = Hash.new {|h2,k2|
        h2[k2] = {}
      }
    },

    # 4 : Alias Pool
    Hash.new {|h,k|
      h[k] = []
    }
  ]

end

require 'when_exe/region/japanese/location'

