# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

require 'when_exe/locales/transliteration_table'

module When
  module Locale

    _IAST_Part_I = {
        "A"  => "अ",      "a"  => "अ",
        "Ā"  => "आ",     "ā"  => "आ",
        "I"  => "इ",      "i"  => "इ",
        "Ī"  => "ई",      "ī"  => "ई",
        "U"  => "उ",      "u"  => "उ",
        "Ū"  => "ऊ",      "ū"  => "ऊ",
        "Ṛ"  => "ऋ",     "ṛ"  => "ऋ",
        "Ṝ"  => "ॠ",     "ṝ"  => "ॠ",
        "Ḷ"  => "ऌ",      "ḷ"  => "ऌ",
        "Ḹ"  => "ॡ",      "ḹ"  => "ॡ",
        "E"  => "ए",      "e"  => "ए",
        "Ai" => "ऐ",      "ai" => "ऐ",
        "O"  => "ओ",     "o"  => "ओ",
        "Au" => "औ",     "au" => "औ",
        "Ṃ"  => "अं",     "ṃ"  => "अं",
        "Ḥ"  => "अः",    "ḥ"  => "अः",
        "'"  => "अऽ",

        "K"  => "क",      "k"  => "क",
        "C"  => "च",      "c"  => "च",
        "Ṭ"  => "ट",      "ṭ"  => "ट",
        "T"  => "त",      "t"  => "त",
        "P"  => "प",      "p"  => "प",
        "Kh" => "ख",     "kh" => "ख",
        "Ch" => "छ",      "ch" => "छ",
        "Ṭh" => "ठ",      "ṭh" => "ठ",
        "Th" => "थ",      "th" => "थ",
        "Ph" => "फ",      "ph" => "फ",
        "G"  => "ग",      "g"  => "ग",
        "J"  => "ज",      "j"  => "ज",
        "Ḍ"  => "ड",      "ḍ"  => "ड",
        "D"  => "द",      "d"  => "द",
        "B"  => "ब",      "b"  => "ब",
        "Gh" => "घ",      "gh" => "घ",
        "Jh" => "झ",      "jh" => "झ",
        "Ḍh" => "ढ",      "ḍh" => "ढ",
        "Dh" => "ध",      "dh" => "ध",
        "Bh" => "भ",      "bh" => "भ",
        "Ṅ"  => "ङ",      "ṅ"  => "ङ",
        "Ñ"  => "ञ",      "ñ"  => "ञ",
        "Ṇ"  => "ण",      "ṇ"  => "ण",
        "N"  => "न",      "n"  => "न",
        "M"  => "म",      "m"  => "म",
        "H"  => "ह",      "h"  => "ह",
        "Y"  => "य",      "y"  => "य",
        "R"  => "र",      "r"  => "र",
        "L"  => "ल",      "l"  => "ल",
        "V"  => "व",      "v"  => "व",
        "Ś"  => "श",      "ś"  => "श",
        "Ṣ"  => "ष",      "ṣ"  => "ष",
        "S"  => "स",      "s"  => "स"
    }

    _IAST_Part_II = {
        "R̥"  => "ऋ",     "r̥"  => "ऋ",
        "R̥̄"  => "ॠ",     "r̥̄"  => "ॠ",
        "Ē"  => "ए",      "ē"  => "ए",
        "Ō"  => "ओ",     "ō"  => "ओ",
        "Ṁ"  => "अं",     "ṁ"  => "अं"
    }

    #
    # IAST: International Alphabet of Sanskrit Transliteration
    #
    IAST = {
      'hi' => _IAST_Part_I.merge(_IAST_Part_II)
    }

    #
    # IASTR: International Alphabet of Sanskrit Transliteration - Reverse
    #
    IASTR = {
      'hi' => _IAST_Part_I.invert
    }

  end
end
