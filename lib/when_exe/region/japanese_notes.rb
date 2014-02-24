# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

require 'when_exe/region/ephemeric_notes'
require 'when_exe/region/japanese_residues'


class When::TM::CalendarEra

  kyoto = '?time_basis=(LAT?long=135.4520E&lat=35.0117N)'
  tokyo = '?time_basis=+09:18:59'
  jst   = '?time_basis=+09:00&intercalary_span=3'

  # Japanese Luni-Solar Calendar Series for JapaneseNote
  JapaneseLuniSolarSeries = [self, [
    'namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/]',
    'locale:[=en:, ja=ja:, alias]',
    'area:[JapaneseLuniSolarSeries=, 日本の暦月=]',
    ['[平朔儀鳳暦=]-660.01.01', '@F',  "-660-01-01^Chinese::平朔儀鳳暦"],
    ['[元嘉暦]454.01.01',       '@CR',  "454-01-01^Chinese::元嘉暦"],
    ['[儀鳳暦]697.01.01',       '@CR',  "697-01-01^Chinese::麟徳暦"],
    ['[大衍暦]764.01.01',       '@CR',  "764-01-01^Chinese::大衍暦"],
    ['[五紀暦]858.01.01',       '@CR',  "858-01-01^Chinese::五紀暦"],
    ['[宣明暦]862.01.01',       '@CR',  "862-01-01^Chinese::宣明暦"],
    ['[前貞享暦=]1685.01.01',   '@CR', "1685-01-01^ChineseLuniSolar#{kyoto}"],
    ['[貞享暦]1687.01.01',      '@CR', "1687-01-01^ChineseLuniSolar#{kyoto}"],
    ['[貞享補暦A=]1753.01.01',  '@CR', "1753-01-01^ChineseLuniSolar#{kyoto}"],
    ['[貞享補暦B=]1754.01.01',  '@CR', "1754-01-01^ChineseLuniSolar#{kyoto}"],
    ['[宝暦暦]1755.01.01',      '@CR', "1755-01-01^ChineseLuniSolar#{kyoto}"],
    ['[修正宝暦暦=]1771.01.01', '@CR', "1771-01-01^ChineseLuniSolar#{kyoto}"],
    ['[寛政暦]1798.01.01',      '@CR', "1798-01-01^ChineseLuniSolar#{kyoto}"],
    ['[天保暦]1844.01.01',      '@CR', "1844-01-01^ChineseLuniSolar#{kyoto}"], # 京都平均太陽時
    ['[JLSA=,旧暦A=]1872.12.03','@CR', "1872-12-03^ChineseLuniSolar#{tokyo}"], # 東京平均太陽時
    ['[JLSB=,旧暦B=]1887.11.18','@CR', "1887-11-18^ChineseLuniSolar#{jst}"]    # 日本標準時
  ]]

  # Japanese Solar Calendar Series for JapaneseNote
  JapaneseSolarSeries = [self, [
    'namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/]',
    'locale:[=en:, ja=ja:, alias]',
    'area:[JapaneseSolarSeries=, 日本の節月=]',
    ['[平朔儀鳳暦=]-661.01.01', '@F',  "-661-01-01^Chinese::平朔儀鳳暦(節月)"], # 年の始めに遡って開始(実際は12.22)
    ['[元嘉暦]454.01.12',       '@CR',  "454-01-12^Chinese::元嘉暦(節月)"],
    ['[儀鳳暦]696.12.27',       '@CR',  "696-12-27^Chinese::麟徳暦(節月)"],
    ['[大衍暦]764.01.06',       '@CR',  "764-01-06^Chinese::大衍暦(節月)"],
    ['[五紀暦]857.12.19',       '@CR',  "857-12-19^Chinese::五紀暦(節月)"],
    ['[宣明暦]862.01.03',       '@CR',  "862-01-03^Chinese::宣明暦(節月)"],
    ['[前貞享暦=]1685.01.01',   '@CR', "1685-01-01^Chinese::前貞享暦(節月)"],
    ['[貞享暦]1687.01.08',      '@CR', "1687-01-08^Chinese::貞享暦(節月)"],
    ['[貞享補暦A=]1752.12.30',  '@CR', "1752-12-30^Chinese::貞享補暦A(節月)"],
    ['[貞享補暦B=]1753.12.19',  '@CR', "1753-12-19^Chinese::貞享補暦B(節月)"],
    ['[宝暦暦]1755.01.07',      '@CR', "1755-01-07^Chinese::宝暦暦(節月)"],
    ['[修正宝暦暦=]1771.01.11', '@CR', "1771-01-11^Chinese::修正宝暦暦(節月)"],
    ['[寛政暦]1798.01.12',      '@CR', "1798-01-12^Chinese::寛政暦(節月)"],
    ['[天保暦]1844.01.14',      '@CR', "1844-01-14^ChineseSolar#{kyoto}"], # 京都平均太陽時
    ['[JSA=,旧暦A=]1872.11.26', '@CR', "1872-11-26^ChineseSolar#{tokyo}"], # 東京平均太陽時
    ['[JSB=,旧暦B=]1887.11.26', '@CR', "1887-11-26^ChineseSolar#{jst}"]    # 日本標準時
  ]]
end

class When::CalendarTypes::CalendarNote

  #
  # 日本暦注
  #
  class JapaneseNote < self

    #
    # 日本暦注が使用する暦法
    #
    # @private
    class Cal4Note
      def initialize(calendar, solar)
        @calendar = calendar
        @solar    = solar
      end
    end

    #
    # 日本暦注の要素
    #
    # @private
    class Note < When::CalendarTypes::CalendarNote::NoteElement
    end

    #
    # 日本暦注の要素
    #
    NoteObjects = [When::BasicTypes::M17n, [
      "namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/]",
      "locale:[=ja:]",
      "names:[日本暦注]",

      # 年の暦注 ----------------------------
      [When::BasicTypes::M17n,
        "names:[年]",
        [Note, 0xFFFF, "label:[干支]",       'position:共通'],                               #  0: 干支
      # [Note, 0xFFFF, "label:[干=ja:%%<十干>]",
      #                                   'position:共通'],                                  #     干
      # [Note, 0xFFFF, "label:[支=ja:%%<十二支>]",
      #                                   'position:共通'],                                  #     支
        [Note, 0x3800, "label:[廿八宿=ja:%%<二十八宿>]",
                                             'position:共通'],                               #  1: 廿八宿
        [Note, 0x3FFC, "label:[大歳壇=]",    'position:暦序'],                               #  2: 干支
        [Note, 0xC000, "label:[九星]",       'position:民間'],                               #  3: 九星
        [Note, 0xFFFC, "label:[納音]",       'position:暦序',   'suffix:是'],                #  4: 干支
        [Note, 0xFFFF, "label:[大歳=ja:%%<太歳神>]",
                                             'position:暦序',   'suffix:在'],                #  5: 干支
        [Note, 0xFFFF, "label:[大將軍=ja:%%<大将軍_(方位神)>]",
                                             'position:暦序',   'suffix:在'],                #  6: 支
        [Note, 0xFFFF, "label:[大陰=ja:%%<太陰神>]",
                                             'position:暦序',   'suffix:在'],                #  7: 支
        [Note, 0xFFFF, "label:[歳徳=ja:%%<歳徳神>]",
                                             'position:暦序',   'suffix:在'],                #  8: 干
        [Note, 0xFFFF, "label:[歳刑=ja:%%<歳刑神>]",
                                             'position:暦序',   'suffix:在'],                #  9: 支
        [Note, 0xFFFF, "label:[歳破=ja:%%<歳破神>]",
                                             'position:暦序',   'suffix:在'],                # 10: 支
        [Note, 0xFFFF, "label:[歳煞=ja:%%<歳煞神>]",
                                             'position:暦序',   'suffix:在'],                # 11: 支
        [Note, 0xFFFF, "label:[黄幡=ja:%%<黄幡神>]",
                                             'position:暦序',   'suffix:在'],                # 12: 支
        [Note, 0xFFFF, "label:[豹尾=ja:%%<豹尾神>]",
                                             'position:暦序',   'suffix:在'],                # 13: 支
        [Note, 0x0003, "label:[天道=]",      'position:暦序',   'suffix:-'],                 # 14: 支
        [Note, 0x0003, "label:[人道=]",      'position:暦序',   'suffix:-'],                 # 15: 支
        [Note, 0x3FFC, "label:[歳次=]",      'position:暦序',   'suffix:-'],                 # 16: 支
        [Note, 0xF800, "label:[金神]",       'position:仮名暦', 'suffix:在'],                # 17: 干
        [Note, 0xFFFF, "label:[大小]",       'position:暦序']                                # 18: 朔閏表
      ],

      # 月の暦注 ----------------------------
      [When::BasicTypes::M17n,
        "names:[月]",
        [Note, 0xFFFF, "label:[月名=ja:%%<月_(暦)>#%.<日本の和風月名>]",
                                             'position:月建'],                               #  0: 月の和名
      # [Note, 0xFFFF, "label:[干支]",       'position:共通'],                               #     干支
      # [Note, 0xFFFF, "label:[干=ja:%%<十干>]",
      #                                           'position:共通'],                          #     干
      # [Note, 0xFFFF, "label:[支=ja:%%<十二支>]",
      #                                           'position:共通'],                          #     支
        [Note, 0xF800, "label:[廿八宿=ja:%%<二十八宿>]",
                                             'position:共通'],                               #  1: 廿八宿
        [Note, 0xFFFC, "label:[月建=]",      'position:月建',   'suffix:-' ],                #  2: 年の十干と暦月
        [Note, 0xC000, "label:[九星]",       'position:民間'],                               #  3: 九星
        [Note, 0x0003, "label:[天氣=]",      'position:月建',   'suffix:-' ],                #  4: 暦月
        [Note, 0x3FFF, "label:[天道=]",      'position:月建',   'suffix:-' ],                #  5: 暦月
        [Note, 0x0003, "label:[人道=]",      'position:月建',   'suffix:-' ],                #  6: 暦月
        [Note, 0x0003, "label:[月破=]",      'position:月建',   'suffix:在'],                #  7: 暦月
        [Note, 0x3FFC, "label:[天徳=]",      'position:月建',   'suffix:在'],                #  8: 暦月
        [Note, 0x3FFF, "label:[月煞=]",      'position:月建',   'suffix:在'],                #  9: 暦月
        [Note, 0x3FFF, "label:[用時=]",      'position:月建',   'suffix:-' ],                # 10: 暦月
        [Note, 0x3FFF, "label:[月徳=]",      'position:月建',   'suffix:在'],                # 11: 暦月
        [Note, 0x3FFC, "label:[月徳合=]",    'position:月建',   'suffix:在'],                # 12: 暦月
        [Note, 0x3FFC, "label:[月空=]",      'position:月建',   'suffix:在'],                # 13: 暦月
        [Note, 0x3FFF, "label:[三鏡=]",      'position:月建',   'suffix:-' ],                # 14: 暦月
        [Note, 0x3FFF, "label:[土府=]",      'position:月建',   'suffix:在'],                # 15: 暦月
        [Note, 0x3FFC, "label:[土公=ja:%%<土公神>]",
                                             'position:月建',   'suffix:在'],                # 16: 暦月
        [Note, 0xFFFF, "label:[大小]",       'position:月建']                                # 17: 朔閏表
      ],

      # 日の暦注 ----------------------------
      [When::BasicTypes::M17n,
        "names:[日]",
        [Note, 0xFFFF, "label:[干支]",       'position:共通'],                               #  0: 干支
      # [Note, 0x, "label:[干=ja:%%<十干>]",
      #                                           'position:共通'],                          #     干
      # [Note, 0x, "label:[支=ja:%%<十二支>]",
      #                                           'position:共通'],                          #     支
        [Note, 0x3FFF, "label:[納音]",       'position:共通',   'suffix:是'],                #  1: 干支
        [Note, 0xFFFF, "label:[十二直]",     'position:共通'],                               #  2: 支 節月
        [Note, 0xFFFF, "label:[七曜]",       'position:共通'],                               #  3: 七曜
        [Note, 0xF800, "label:[廿八宿=ja:%%<二十八宿>]",
                                             'position:共通'],                               #  4: 廿八宿
        [Note, 0x07F8, "label:[廿七宿=ja:%%<二十八宿>]",
                                             'position:共通'],                               #  5: 暦月 暦日
        [Note, 0xC000, "label:[九星]",       'position:民間'],                               #  6: 九星
        [Note, 0x8000, "label:[六曜]",       'position:民間'],                               #  7: 暦月 暦日
        [Note, 0xE000, "label:[祝祭日]",     'position:祝祭日'],                             #  8: 暦月 暦日 (七曜)
        [Note, 0xFFFF, "label:[廿四節気=ja:%%<二十四節気>]",
                                             'position:時候'],                               #  9: 太陽黄経
        [Note, 0xFFFF, "label:[節中=]",      'position:時候'],                               # 10: 太陽黄経
        [Note, 0xFFFC, "label:[七十二候]",   'position:時候'],                               # 11: 太陽黄経
        [Note, 0x3FFC, "label:[六十卦=]",    'position:時候'],                               # 12: 太陽黄経
        [Note, 0xF800, "label:[節分]",       'position:雑節'],                               # 13: 立春からの日数
        [Note, 0xF800, "label:[初午]",       'position:雑節'],                               # 14: 支 節月 or 暦月
        [Note, 0xF800, "label:[八十八夜]",   'position:雑節'],                               # 15: 立春からの日数
        [Note, 0xF800, "label:[入梅]",       'position:雑節'],                               # 16: 干 太陽黄経
        [Note, 0xF800, "label:[二百十日]",   'position:雑節'],                               # 17: 立春からの日数
        [Note, 0xF800, "label:[二百廿日]",   'position:雑節'],                               # 18: 立春からの日数

        [Note, 0x3FFC, "label:[大禍=ja:%%<暦注下段>#%.<大禍日>]",
                                             'position:上段 上段 欄外 欄外', 'suffix:日'],   # 19: 支 節月
        [Note, 0x3FFC, "label:[滅門=ja:%%<暦注下段>#%.<滅門日>]",
                                             'position:上段 上段 欄外 欄外', 'suffix:日'],   # 20: 支 節月
        [Note, 0x3FFC, "label:[狼藉=ja:%%<暦注下段>#%.<狼藉日>]",
                                             'position:上段 上段 欄外 欄外', 'suffix:日'],   # 21: 支 節月

        [Note, 0x07F8, "label:[甘露=]",      'position:上段 上段 上段 上段', 'suffix:日'],   # 22: 七曜 廿七宿
        [Note, 0x07F8, "label:[金剛峯=]",    'position:上段 上段 上段 上段'],                # 23: 七曜 廿七宿
        [Note, 0x07F8, "label:[羅刹=]",      'position:上段 上段 上段 上段'],                # 24: 七曜 廿七宿

        [Note, 0x3FFC, "label:[大將軍=ja:%%<大将軍_(方位神)>]",
                                             'position:上段 上段 上段 上段',   'suffix:-'],  # 25: 干支 節年
        [Note, 0xFFFC, "label:[天一=ja:%%<天一神>]",
                                             'position:上段 上段 上段 上段',   'suffix:-'],  # 26: 干支
        [Note, 0x3FFC, "label:[土公=ja:%%<土公神>]",
                                             'position:上段 上段 上段 上段',   'suffix:-'],  # 27: 干支
        [Note, 0x3FFC, "label:[歳下食=ja:%%<暦注下段>#%.<歳下食>]",
                                             'position:上段 上段 上段 上段'],                # 28: 干支 節年
        [Note, 0x3FFC, "label:[忌遠行=]",    'position:上段 上段 上段 上段'],                # 29: 支 節月
        [Note, 0x3FFC, "label:[忌夜行=]",    'position:上段 上段 上段 上段'],                # 30: 支 節月
        [Note, 0x3FFC, "label:[下食時=ja:%%<暦注下段>#%.<時下食>]",
                                             'position:上段 上段 上段 上段',   'suffix:-'],  # 31: 支 節月 貞享暦で一部廃止
        [Note, 0x3FFC, "label:[天間=]",      'position:上段 上段 上段 中段上'],              # 32: 干支 節月
        [Note, 0x3FFC, "label:[不視病=]",    'position:上段 上段 上段 上段'],                # 33: 干
        [Note, 0x3FFC, "label:[不問疾=]",    'position:上段 上段 上段 上段'],                # 34: 干
        [Note, 0x3FFC, "label:[不弔人=]",    'position:上段 上段 上段 上段'],                # 35: 支
        [Note, 0xFFFC, "label:[彼岸]",       'position:仮名暦'],                             # 36: 太陽黄経
        [Note, 0xFFFF, "label:[社=ja:%%<社日>]",
                                             'position:中段 中段 中段 中段', 'suffix:日'],   # 37: 干 太陽黄経
        [Note, 0xFFFF, "label:[三伏]",       'position:中段 中段 中段 中段'],                # 38: 干 太陽黄経
        [Note, 0x3FFC, "label:[除手足甲=]",  'position:中段 中段 中段 中段'],                # 39: 晦(除手足甲)、支(片方のみ), 没滅凶会日×
        [Note, 0x3FFC, "label:[沐浴=]",      'position:中段 中段 中段 中段'],                # 40: 支 没滅凶会日×
        [Note, 0x3FFD, "label:[臘=ja:%%<臘日>]",
                                             'position:中段 中段 中段 中段', 'suffix:日'],   # 41: 支 太陽黄経
        [Note, 0x3FFC, "label:[伐=]",        'position:中段 中段 中段 中段上', 'suffix:日'], # 42: 干支
        [Note, 0x3FFC, "label:[五墓=ja:%%<暦注下段>#%.<五墓日>]",
                                             'position:中段 中段 中段 中段下', 'suffix:日'], # 43: 干支
        [Note, 0x3FFC, "label:[六蛇=]",      'position:中段 中段 中段 中段上'],              # 44: 干支 節月
        [Note, 0x3FFC, "label:[七鳥=]",      'position:中段 中段 中段 中段上'],              # 45: 干支 節月
        [Note, 0x3FFC, "label:[八龍=]",      'position:中段 中段 中段 中段上'],              # 46: 干支 節月
        [Note, 0x3FFC, "label:[九虎=]",      'position:中段 中段 中段 中段上'],              # 47: 干支 節月
        [Note, 0x07FF, "label:[没=ja:%%<没日>]",
                                             'position:中段 中段 中段 中段', 'suffix:日'],   # 48: 太陽黄経
        [Note, 0xFFF8, "label:[日食]",       'position:中段 中段 中段 中段'],                # 49: 日食表
        [Note, 0x07FC, "label:[滅=ja:%%<滅日]",
                                             'position:中段 中段 中段 中段', 'suffix:日'],   # 50: 月の位相
        [Note, 0xFFF8, "label:[月食]",       'position:中段 中段 中段 中段'],                # 51: 月食表
        [Note, 0xC7FD, "label:[月相]",       'position:中段 中段 中段 中段'],                # 52: 月の位相
        [Note, 0xFFFF, "label:[土用事=ja:%%<土用>]",
                                             'position:中段 中段 中段 中段'],                # 53: 太陽黄経
        [Note, 0x3FF0, "label:[伏龍=]",      'position:上段 上段 下段 下段', 'suffix:在'],   # 54: 太陽黄経

        [Note, 0x3FFF, "label:[凶会=ja:%%<暦注下段>#%.<凶会日>]",
                                             'position:下段 下段 下段 下段', 'suffix:日'],   # 55: 干支 節月(宣明暦以前)/暦月(貞享暦以降)
        [Note, 0x3FFF, "label:[大小歳=]",    'position:下段 下段 下段 下段'],                # 56: 干支 節月
        [Note, 0x3FFC, "label:[歳徳=ja:%%<歳徳神>]",
                                             'position:下段 下段 下段 下段'],                # 57: 干 節年 凶会日× ～合も
        [Note, 0x0003, "label:[天倉=]",      'position:古注'],                               # 58: 干支 節月
      # [Note, 0x0003, "label:[天李=]",      'position:古注'],                               #     干支 節月?
        [Note, 0x37FF, "label:[天恩=ja:%%<暦注下段>#%.<天恩日>]",
                                             'position:下段 下段 下段 下段', 'suffix:日'],   # 59: 干支 節月 凶会日×
        [Note, 0xFFFF, "label:[天赦=ja:%%<暦注下段>#%.<天赦日>]",
                                             'position:下段 下段 下段 下段'],                # 60: 干支 節月
        [Note, 0x37FF, "label:[母倉=ja:%%<暦注下段>#%.<母倉日>]",
                                             'position:下段 下段 下段 下段', 'suffix:日'],   # 61: 支 節月 凶会日×
        [Note, 0x37FC, "label:[月徳=]",      'position:下段 下段 下段 下段'],                # 62: 干 節月 凶会日× ～合も
        [Note, 0x3FFF, "label:[九坎=]",      'position:下段 下段 下段 下段'],                # 63: 支 節月
        [Note, 0x3FFF, "label:[歸忌=ja:%%<暦注下段>#%.<帰忌日>]",
                                             'position:下段 下段 下段 下段', 'suffix:日'],   # 64: 支 節月
        [Note, 0x3FFF, "label:[血忌=ja:%%<暦注下段>#%.<血忌日>]",
                                             'position:下段 下段 下段 下段', 'suffix:日'],   # 65: 支 節月
        [Note, 0x3FFC, "label:[無翹=]",      'position:下段 下段 下段 下段'],                # 66: 支 節月
        [Note, 0x3FFF, "label:[厭=]",        'position:下段 下段 下段 下段'],                # 67: 支 節月
        [Note, 0x3FFC, "label:[重=ja:%%<暦注下段>#%.<重日>]",
                                             'position:下段 下段 下段 下段', 'suffix:日'],   # 68: 支
        [Note, 0x3FFD, "label:[復=ja:%%<暦注下段>#%.<復日>]",
                                             'position:下段 下段 下段 下段', 'suffix:日'],   # 69: 干 節月
        [Note, 0x3FFC, "label:[月煞=]",      'position:下段 下段 下段 下段'],                # 70: 支 節月
        [Note, 0x3FFF, "label:[往亡=ja:%%<暦注下段>#%.<往亡日>]",
                                             'position:下段 下段 下段 下段', 'suffix:日'],   # 71: 太陽黄経
        [Note, 0x3FFF, "label:[日遊=ja:%%<日遊神>]",
                                             'position:最下段', 'suffix:在'],                # 72: 干支
        [Note, 0x07FF, "label:[人神配当=]",  'position:最下段孟月', 'suffix:-'],             # 73: 暦日

        [Note, 0x3E00, "label:[受死=ja:%%<暦注下段>#%.<受死日>]",
                                             'position:仮名暦', 'suffix:日'],                # 74: 支 節月
        [Note, 0xFFF0, "label:[八專]",       'position:仮名暦'],                             # 75: 干支
        [Note, 0x3E00, "label:[八專間日=ja:%%<八専>]",
                                             'position:仮名暦'],                             # 76: 干支
        [Note, 0xC000, "label:[金神間日=ja:%%<金神>#%.<金神の遊行・間日>]",
                                             'position:仮名暦'],                             # 77: 支 節月
        [Note, 0xC000, "label:[金神遊行=ja:%%<金神>#%.<金神の遊行・間日>]",
                                             'position:仮名暦'],                             # 78: 支 節月
        [Note, 0x3FF0, "label:[天火=ja:%%<暦注下段>#%.<天火日>]",
                                             'position:仮名暦', 'suffix:日'],                # 79: 支 節月
        [Note, 0x3FF0, "label:[地火=ja:%%<暦注下段>#%.<地火日>]",
                                             'position:仮名暦', 'suffix:日'],                # 80: 支 節月
        [Note, 0x3800, "label:[人火=]",      'position:仮名暦'],                             # 81: 支 節月
        [Note, 0x3800, "label:[雷火=]",      'position:仮名暦'],                             # 82: 支 節月
        [Note, 0x3FF0, "label:[赤舌=ja:%%<赤舌日>]",
                                             'position:仮名暦', 'suffix:日'],                # 83: 暦月 暦日
        [Note, 0x3E00, "label:[十死=ja:%%<暦注下段>#%.<十死日>]",
                                             'position:仮名暦', 'suffix:日'],                # 84: 支 節月
        [Note, 0x3E00, "label:[道虚=]",      'position:仮名暦', 'suffix:日'],                # 85: 暦日
        [Note, 0x3E00, "label:[大明=ja:%%<暦注下段>#%.<大明日>]",
                                             'position:仮名暦', 'suffix:日'],                # 86: 干支
        [Note, 0x0600, "label:[大赤=ja:%%<赤口日>]",
                                             'position:仮名暦', 'suffix:日'],                # 87: 暦月 暦日
        [Note, 0xF800, "label:[甲子待=ja:%%<甲子>]",
                                             'position:仮名暦'],                             # 88: 干支
        [Note, 0xC000, "label:[己巳]",       'position:仮名暦'],                             # 89: 干支
        [Note, 0xF800, "label:[庚申待]",     'position:仮名暦'],                             # 90: 干支
        [Note, 0x3800, "label:[犯土]",       'position:仮名暦'],                             # 91: 干支
        [Note, 0xF800, "label:[十方暮]",     'position:仮名暦'],                             # 92: 干支
        [Note, 0xF800, "label:[一粒万倍=ja:%%<一粒万倍日>]",
                                             'position:仮名暦', 'suffix:日'],                # 93: 支 節月
        [Note, 0x3800, "label:[天福=]",      'position:仮名暦'],                             # 94: 支 節月
        [Note, 0x3800, "label:[地福=]",      'position:仮名暦'],                             # 95: 支 節月
        [Note, 0x3800, "label:[地五福=]",    'position:仮名暦'],                             # 96: 支 節月
        [Note, 0xB800, "label:[三隣亡]",     'position:仮名暦'],                             # 97: 支 節月
        [Note, 0xF800, "label:[不成就=ja:%%<不成就日>]",
                                             'position:仮名暦', 'suffix:日'],                # 98: 暦月 暦日/晦日
        [Note, 0x3FFF, "label:[三寶吉=ja:%%<三宝吉>]",
                                             'position:上段 上段 上段 上段'],                # 99: 干支 節月(宣明暦以前)/暦月(貞享暦以降)
        [Note, 0x3FFF, "label:[神吉=ja:%%<暦注下段>#%.<神日>]",
                                             'position:上段 上段 中段 中段上', 'suffix:日'], #100: 干支 節月
        [Note, 0x3FFF, "label:[雑事吉=]",    'position:雑事吉'],                             #101: 干支 節月(宣明暦以前)/暦月(貞享暦以降)
        [Note, 0x07FF, "label:[小字注=]",    'position:下段小字 下段小字 下段小字 下段小字'],#102: 干支 節月(宣明暦以前)/暦月(貞享暦以降)
      ]
    ]]

    #
    # 日本暦注の時代変遷
    #
    # @private
    NoteTypes = (3...When::TM::CalendarEra::JapaneseSolarSeries[1].size).to_a.map {|i|
      calendars =
        [When::TM::CalendarEra::JapaneseLuniSolarSeries[1][i][2],
         When::TM::CalendarEra::JapaneseSolarSeries[1][i][2]].map {|epoch|
          epoch =~ /^(-?\d+)-(\d+)-(\d+)\^(.+)$/
          $4
        }
      [$2 == '01' ? $1.to_i : $1.to_i+1, Cal4Note.new(*calendars)]
    }.reverse

    # @private
    NoteRange = [
      # 開始 具注暦 七十二候        index mask
      [-660,    0,      0], # ～ 696  0 : 0001
      [ 697,    0,      0], # ～ 763  1 : 0002
      [ 764,    0,      2], # ～ 800  2 : 0004
      [ 801,    0,      2], # ～ 900  3 : 0008
      [ 901,    0,      2], # ～1003  4 : 0010
      [1004,    1,      2], # ～1047  5 : 0020
      [1048,    1,      2], # ～1100  6 : 0040
      [1101,    1,      2], # ～1184  7 : 0080
      [1185,    2,      2], # ～1300  8 : 0100
      [1301,    2,      2], # ～1337  9 : 0200
      [1338,    3,      2], # ～1684 10 : 0400
      [1685,    3,      3], # ～1754 11 : 0800
      [1755,    3,      4], # ～1867 12 : 1000
      [1868,    3,      4], # ～1872 13 : 2000
      [1873,    3,      4], # ～1873 14 : 4000
      [1874,    3,      5]  # ～     15 : 8000
    ]

    # @private
    NoteFocused = (0...NoteRange.size).to_a.map {|range|
      (3..5).to_a.map {|cord|
        notes = NoteObjects[1][cord]
        (2...notes.size).to_a.inject([]) {|focused,note|
          focused << notes[note][2][/\[.+?[=\]]/][1..-2] if notes[note][1][range] == 1
          focused
        }
      }
    }

    #
    # 月の大小
    #
    # @private
    MonthPattern = {
       29 => '小',
       30 => '大',
      -28 => '平',
      -29 => '閏',
      -30 => '小',
      -31 => '大'
    }

    #
    # 日本暦注が使用する暦法
    #
    # @private
    class Cal4Note
      attr_reader :calendar, :solar

      def l_calendar
        @l_calendar ||= When.Calendar(@calendar)
      end

      def s_calendar
        @s_calendar ||= When.Calendar(@solar)
      end

      def l_phases
        @l_phases   ||= JapaneseNote::LunarPhases.new('formula'=>l_calendar.formula[-1])
      end

      def s_terms
        @s_terms    ||= JapaneseNote::SolarTerms.new('formula'=>s_calendar.formula[0])
      end

      def doyo
        s_calendar.doyo
      end
    end

    #
    #  日本暦注用の NoteObjects の要素のための内部クラス
    #
    # @private
    class Note

      attr_reader :label, :position, :suffix

      def to_note_hash(note, dates=nil)
        {
          :note      => self,
          :value     => case @suffix
                        when '是' ; [@label + '是-', note[/.$/]]
                        when '在' ; [@label + '在-', note]
                        when '-'  ; [@label + '-',   note]
                        else      ; note
                        end,
          :position => @position[@position.size == 1 ? 0 : dates.index_g]
        }
      end

      private
      # オブジェクトの正規化
      #
      def _normalize(args=[], options={})
        @position = @position.split(/ /)
      end
    end

    #
    #  日本暦注計算に必要となる暦日や暦法をまとめた内部クラス
    #
    # @private
    class Dates

      attr_reader :year, :precision, :cal4note, :range, :index_g, :index_s, :o_date, :l_date, :m_date, :s_date

      # 初期設定
      def initialize(date, year=date.most_significant_coordinate, precision=date.precision, cal4note=nil)

        # 暦注パターン
        if cal4note
          # 年代による判定
          (1...NoteRange.size).to_a.reverse.each do |i|
            if year >= NoteRange[i][0]
              @range = i
              break
            end
          end
          @range ||= 0
        else
          # 暦法による判定
          cal4note = Cal4Note.new(date.frame, date.frame.twin)
          @range =
            case cal4note.l_calendar.formula[-1]
            when When::Ephemeris::ChineseTrueLunation
              date.frame.twin =~ /戊寅|麟徳/ ? 1 : 10 # 唐代定朔暦(儀鳳暦 or 宣明暦)
            when When::Ephemeris::MeanLunation   ;  0 # 唐代以前平朔暦(元嘉暦)
            else                                 ; 15 # 現代の旧暦
            end
        end

        # 具注暦の配置
        @index_g = NoteRange[@range][1]

        # 七十二候
        @index_s = NoteRange[@range][2]

        # その他の属性
        @year      = year
        @precision = precision
        @cal4note  = cal4note
        @o_date    = date
        @l_date    = @cal4note.l_calendar ^ date
        @m_date    = date.frame.kind_of?(When::CalendarTypes::Christian) ? @l_date : @o_date
        @s_date    = @cal4note.s_calendar ^ date
      end
    end

    NoteMethods = [:year_notes, :month_notes, :day_notes]

    # 暦注の計算
    #
    # @param [When::TM::TemporalPosition] date 暦注を計算する日時
    #   (date が When::TM::TemporalPosition でない場合、When::TM::TemporalPosition に変換して使用する)
    # @param [Hash] options
    #   :indices, :notes およびその他のキー => {When::CalendarTypes::CalendarNote#notes} を参照
    #
    # @return [Hash]               :notes が String の場合
    # @return [Array<Hash>]        上記に該当せず、:indices が Integer の場合
    # @return [Array<Array<Hash>>] 上記のいずれにも該当しない場合
    # @note return 値の [Hash] の要素は下記の通り
    #   :note     => 暦注要素 (When::CalendarTypes::JapaneseNote::Note)
    #   :value    => 暦注の値 (String or When::BasicTypes::M17n または、その Array)
    #   :position => 具注暦でのその暦注の配置場所(String)
    #
    def notes(date, options={})
      dates, indices, notes, conditions, options = _parse_note(date, options)
      _result(indices.map {|i|
        next [] unless i <= dates.precision
        send(NoteMethods[i-1], dates, notes[i-1], conditions)
      }, options)
    end

    private

    # オブジェクトの正規化
    def _normalize(args=[], options={})
      @prime ||= [%w(干支), %w(月名), %w(七曜 干支 六曜 廿四節気 祝祭日)]
      super
    end

    # 年の暦注
    def year_notes(dates, notes, conditions={})
      _note_values(dates, notes, _all_keys[-3], _elements[-3]) do |dates, focused_notes, notes_hash|

        focused_notes[0..-1] = focused_notes & NoteFocused[dates.range][-3]
        root = When.Resource('_co:CommonResidue')

        # 干支
        residue = (dates.precision < When::DAY ? dates.o_date : dates.s_date).most_significant_coordinate - 4
        notes_hash['干支']   = root['干支'][residue % 60]
        notes_hash['干']     = root['干'  ][residue % 10]
        notes_hash['支']     = root['支'  ][residue % 12]

        # 廿八宿
        notes_hash['廿八宿'] ||= root['宿'][(residue+18) % 28]

        # 九星
        notes_hash['九星'] ||= root['九星'][When::Coordinates::Kyusei.year(residue)]

        # 大小
        unless notes_hash['大小']
          year  = dates.o_date.floor(When::YEAR)
          month = year.floor(When::MONTH)
          pattern = ''
          while year == month
            length   = month.length(When::MONTH)
            length   = -length if dates.o_date.frame.kind_of?(When::CalendarTypes::Christian) # 太陽暦
            pattern += '閏' if month[When::MONTH] * 0 == 1
            pattern += MonthPattern[length] || '改'
            month   += When::DurationP1M
          end
          notes_hash['大小'] = "#{pattern}(#{year.length(When::YEAR)})"
        end

        # その他
        [notes_hash['干支'], notes_hash['干'], notes_hash['支']].each do |note|
          note._year_notes(notes_hash, dates, conditions)
        end
        notes_hash
      end
    end

    # 月の暦注
    def month_notes(dates, notes, conditions={})
      _note_values(dates, notes, _all_keys[-2], _elements[-2]) do |dates, focused_notes, notes_hash|

        focused_notes[0..-1] = focused_notes & NoteFocused[dates.range][-2]
        root = When.Resource('_co:CommonResidue')

        # 干支
        residue = month_stem_branch(dates.precision < When::DAY ? dates.o_date : dates.m_date)
        notes_hash['干支']   = root['干支'][residue % 60]
        notes_hash['干']     = root['干'  ][residue % 10]
        notes_hash['支']     = root['支'  ][residue % 12]

        # 廿八宿
        notes_hash['廿八宿'] ||= root['宿'][(residue+6) % 28]

        # 九星
        notes_hash['九星'] ||= root['九星'][When::Coordinates::Kyusei.month(
                  month_stem_branch(dates.precision < When::DAY ? dates.o_date : dates.s_date))]

        # 大小
        unless notes_hash['大小']
          length = dates.o_date.length(When::MONTH)
          length = -length if dates.o_date.frame.kind_of?(When::CalendarTypes::Christian) # 太陽暦
          notes_hash['大小'] = "#{dates.o_date[When::MONTH]*0==1 ? '閏' : ''}#{MonthPattern[length] || '改'}(#{length.abs})"
        end

        # その他
        [notes_hash['干支'], notes_hash['干'], notes_hash['支'], JapaneseLuniSolarNote].each do |note|
          note._month_notes(notes_hash, dates, conditions)
        end
        notes_hash
      end
    end

    # 日の暦注
    def day_notes(dates, notes, conditions={})
      _note_values(dates, notes, _all_keys[-1], _elements[-1]) do |dates, focused_notes, notes_hash|

        focused_notes[0..-1] = focused_notes & NoteFocused[dates.range][-1]
        root = When.Resource('_co:CommonResidue')

        # 干支
        residue = dates.s_date.to_i-11
        notes_hash['干支']     = root['干支'][residue % 60]
        notes_hash['干']       = root['干'  ][residue % 10]
        notes_hash['支']       = root['支'  ][residue % 12]

        # その他
        [SolarTerms, LunarPhases, notes_hash['干支'], notes_hash['干'], notes_hash['支'],
         JapaneseLuniSolarNote, JapaneseSolarNote].each do |note|
          note._day_notes(notes_hash, dates, conditions)
        end

        # 七曜
        notes_hash['七曜']   ||= root['Week'][dates.s_date.to_i % 7]

        # 廿七宿
        notes_hash['廿七宿']   = _residue27(notes_hash['廿七宿'], root)

        # 廿八宿
        notes_hash['廿八宿'] ||= root['宿'][(dates.s_date.to_i+11) % 28]

        # 九星
        notes_hash['九星']   ||= root['九星'][When::Coordinates::Kyusei.day(dates.s_date, dates.cal4note.s_terms)]

        notes_hash
      end
    end

    #
    # 日本暦日情報オブジェクトの生成
    #
    # @note 対となる太陽暦のある太陰太陽暦はそのまま(太陰太陽暦,太陽暦)の対
    #       そうでなければ、採用する対を年代により選択する
    #
    def _to_date_for_note(date)
      if date.frame.kind_of?(When::CalendarTypes::ChineseLuniSolar)
        return Dates.new(date) if date.frame.twin
        o_date = date
      else
        o_date = _to_japanese_date(date)
        return nil unless o_date
      end
      year = o_date.most_significant_coordinate
      NoteTypes.each do |line|
        return Dates.new(o_date, year, date.precision, line[1]) if year >= line[0]
      end
      nil
    end

    #
    # 任意の暦を日本年号付暦日に変換
    #
    def _to_japanese_date(date)
      return date if date._attr[:query] && date._attr[:query]['area'].to_s =~ /日本/
      (date^ When.era(:area=>'日本')).each do |list|
        return list[0] if list[0]
      end
      nil
    end

    #
    # 廿七宿を Resudue 化
    #
    def _residue27(index, root)
      return index unless index.kind_of?(Integer)
      root['宿'][index]
    end

    #
    # 月の干支
    #
    def month_stem_branch(date)
      date.most_significant_coordinate*12+(date.cal_date[1] * 1) +
     (date.frame.kind_of?(When::CalendarTypes::Christian) ? 12 : 13)
    end
  end

  #
  # 太陽暦の暦注・祝祭日
  #
  class JapaneseSolarNote < self

    #
    # 祝祭日一覧
    #
    NotesList = {
      [ 1, 1] => [[1868..1872, '元旦'], [1874..1948, '四方拝'], [1949..2100, '元日']],
      [ 1, 3] => [[1874..1948, '元始祭']],
      [ 1, 5] => [[1874..1948, '新年宴会']],
      [ 1,-2] => [[2000..2100, '成人の日']],
      [ 1,15] => [[1868..1872, '小正月'], [1949..1999, '成人の日']],
      [ 1,29] => [[1873..1873, '神武天皇即位日']],
      [ 1,30] => [[1874..1912, '孝明天皇祭']],
      [ 2,11] => [[1874..1948, '紀元節'], [1967..2100, '建国記念の日']],
      [ 2,24] => [[1989..1989, '昭和天皇の大喪の礼']],
      [ 3, 3] => [[1868..1872, '弥生節句']],
      [ 3, 0] => [[1879..1948, '春季皇霊祭'], [1949..2100, '春分の日']],
      [ 4, 3] => [[1874..1948, '神武天皇祭']],
      [ 4,10] => [[1959..1959, '皇太子明仁親王の結婚の儀']],
      [ 4,29] => [[1927..1948, '天長節'], [1949..1988, '天皇誕生日'], [1989..2006, 'みどりの日'], [2007..2100, '昭和の日']],
      [ 5, 3] => [[1949..2100, '憲法記念日']],
      [ 5, 4] => [[2007..2100, 'みどりの日']],
      [ 5, 5] => [[1868..1872, '端午節句'], [1949..2100, 'こどもの日']],
      [ 6, 9] => [[1993..1993, '皇太子徳仁親王の結婚の儀']],
      [ 7, 7] => [[1868..1872, '七夕節句']],
      [ 7,15] => [[1868..1872, 'お盆']],
      [ 7,20] => [[1996..2002, '海の日']],
      [ 7,-3] => [[2003..2100, '海の日']],
      [ 7,30] => [[1913..1926, '明治天皇祭']],
      [ 8, 1] => [[1868..1872, '田実節句']],
      [ 8,31] => [[1913..1926, '天長節']],
      [ 9, 9] => [[1868..1872, '重陽節句']],
      [ 9,15] => [[1966..2002, '敬老の日']],
      [ 9,-3] => [[2003..2100, '敬老の日']],
      [ 9,17] => [[1874..1878, '神嘗祭']],
      [ 9, 0] => [[1878..1947, '秋季皇霊祭'], [1948..2100, '秋分の日']],
      [10,10] => [[1966..1999, '体育の日']],
      [10,-2] => [[2000..2100, '体育の日']],
      [10,17] => [[1879..1947, '神嘗祭']],
      [10,31] => [[1913..1926, '天長節祝日']],
      [11, 3] => [[1873..1911, '天長節'], [1927..1947, '明治節'], [1948..2100, '文化の日']],
      [11,10] => [[1915..1915, '即位の礼'], [1928..1928, '即位の礼']],
      [11,12] => [[1990..1990, '即位の礼正殿の儀']],
      [11,14] => [[1915..1915, '大嘗祭'], [1928..1928, '大嘗祭']],
      [11,16] => [[1915..1915, '大饗第1日'], [1928..1928, '大饗第1日']],
      [11,23] => [[1873..1947, '新嘗祭'], [1948..2100, '勤労感謝の日']],
      [12,23] => [[1989..2100, '天皇誕生日']],
      [12,25] => [[1927..1947, '大正天皇祭']]
    }

    # @private
    Long = {3=>0, 9=>180}

    class << self

      # 日の暦注 - 祝祭日の計算
      # @private
      def _day_notes(notes, dates, conditions={})
        # 明治維新以降の実暦日のみ扱う
        return notes if dates.o_date.frame.kind_of?(When::CalendarTypes::ChineseLuniSolar)
        year = dates.o_date.most_significant_coordinate
        return notes unless year >= 1868

        # 春分の日と秋分の日を祝祭日に加える
        long = Long[dates.o_date.cal_date[1]] if year >= 1878
        if long
          date = When.when?(dates.o_date.to_cal_date.to_s,
                   {:frame=>dates.o_date.frame,
                    :clock=>dates.s_date.frame.time_basis})
          term = dates.cal4note.s_terms.term(date.floor(When::MONTH,
                                                        When::DAY), [long,360]).cal_date[1..2]
          list = NotesList.dup
          list[term] = list[[term[0],0]]
        else
          list = NotesList
        end

        # 「国民の休日」制定以前
        notes['祝祭日'] ||= _holiday(list, dates.o_date, '振替休日')
        return notes if notes['祝祭日'] || year < 1988

        # 「国民の休日」制定以後
        duration = When.Duration('P1D')
        [duration, -duration].each do |d|
          return notes unless _holiday(list, dates.o_date + d)
        end
        notes['祝祭日'] = '国民の休日'
        return notes
      end

      private

      # 振替休日とハッピーマンデーを考慮した祝祭日
      def _holiday(list, date, alternate=nil)
        y    = date.most_significant_coordinate
        m, d = date.cal_date[1..2]

        # 「振替休日」制定以前
        note = _note(list, y, m, d)
        return note if note || y < 1973

        # 「振替休日」制定以降
        case date.to_i % 7
        when 0 # 月曜
          # 振替休日
          note = _note(list, y, m, d-1)
          return alternate if note
          # ハッピーマンデー
          note = _note(list, y, m, -((d-1)/7 + 1))
          return note if note
        when 1,2 # 火曜・水曜
          # 振替休日
          return alternate if y >= 2007 && m == 5 && d == 6
        end
      end

      # 振替休日とハッピーマンデーを考慮しない祝祭日
      def _note(list, year, month, day)
        return nil if day == 0
        year = [year, 2100].min
        note = list[[month,day]]
        return nil unless note
        note.each do |range|
          return range[1] if range[0].include?(year)
        end
        return nil
      end
    end
  end

  #
  # 太陰太陽暦の暦注
  #
  class JapaneseLuniSolarNote < self

    # 変換表 月日→27宿
    StarMansions    = [                                 #              正  ２  ３  ４  ５  ６  ７  ８  ９  10  11  12  
      [11, 13, 15, 17, 19, 21, 24,  0,  2,  4,  7,  9], # 0 : 本月本説 室12奎14胃16畢18參20鬼22張25角00氐02心04斗07虛10
      [ 5,  3,  1, 25, 23, 21, 19, 16, 14, 11,  8,  7], # 1 : 本月異説 尾05房03亢01翼26星24鬼22參20昴17婁15室12女09斗07
      [14, 16, 18, 20, 22, 24,  0,  3,  5,  7, 10, 12], # 2 : 閏月本説 婁15昴17觜19井21柳23張25角00房03尾05斗07危11壁13
      [12, 14, 16, 18, 19, 21, 24,  0,  2,  5,  8, 10], # 3 : 閏月異説 壁13婁15昴17觜19參20鬼22張25角00氐02尾05女09危11
      [14, 16, 18, 23, 22, 24,  0,  3,  5,  7,  8, 12]  # 4 : 閏月本説(元)        (星24)                      (女09)
    ]

    # 変換表 27宿→28宿
    StarMansionIndex = (0..7).to_a + (9..27).to_a

    # 七曜と27宿で決まる暦注
    WeekDepended = {
                 # 日  月  火  水  木  金  土
      '甘露'   => [26, 17,  5, 22, 21,  3, 23],  # 軫27 畢18 尾05 柳23 鬼22 房03 星24
      '金剛峯' => [ 5,  8, 12, 16, 20, 24,  1],  # 尾05 女09 壁13 昴17 井21 張25 亢01
      '羅刹'   => [15, 21, 25, 19,  2, 13, 22]   # 胃16 鬼22 翼26 参20 氐02 奎14 柳23
    }

    # 人神配当
    HumanBody = %w(足大指 外踝 股内 腰   口     手     内踝   腕   尻 腰背
                   鼻柱   髪際 牙歯 胃管 遍身   胸     気街   股内 足 踝
                   足小指 足踝及胸、目下 肝及足 手陽明 足陽明 胸   膝 陰   膝晊 足跌)

    # 六曜
    Rokuyo = When.Resource('_m:JapaneseTerms::六曜')

    # 月の暦注
    # @private
    def self._month_notes(notes, dates, conditions={})
      # 月名
      notes['月名'] ||= dates.o_date.name('month')
    end

    # 日の暦注
    # @private
    def self._day_notes(notes, dates, conditions={})

      # 廿七宿
      m, l = [1,0].map {|f| dates.m_date.cal_date[1] * f}
      d    = (StarMansions[l==1 ? (conditions[:i27]||0) :
                                  (conditions[:n27]||0)][m-1] + dates.m_date.cal_date[2] - 1) % 27
      notes['廿七宿'] ||= StarMansionIndex[d]

      # 甘露 / 金剛峯 / 羅刹
      w    = (dates.m_date.to_i + 1) % 7
      ['甘露', '金剛峯', '羅刹'].each do |c|
        notes[c] = c if d == WeekDepended[c][w]
      end

      # 三寶吉・神吉・雑事吉
      notes['神吉']   = notes['雑事吉'] = notes['三寶吉'] = nil if notes['没'  ] || notes['滅'  ]
      notes['神吉']   = notes['雑事吉']                   = nil if notes['日食'] || notes['月食'] || notes['往亡']
      notes['三寶吉'] = nil if !notes['甘露'] && (notes['羅刹'] || notes['日食'] || notes['月食'])
      notes['三寶吉'] = notes['甘露'] ? '三寶吉' : nil if /\+/ =~ notes['三寶吉'].to_s
      notes['三寶吉'] = '三吉' if notes['三寶吉'] && dates.range >= 8 # 鎌倉以降

      # 除手足甲 & 道虚・人神配当
      y,m0,d0 = dates.m_date.cal_date
      misoka  = m0 != (dates.m_date + When.Duration('P1D')).cal_date[1] if d0 == 29
      notes['除手足甲'] = '除手足甲' if ([6,16,30].include?(d0) || misoka) && !(notes['没'] || notes['滅'] || notes['凶会'])
      notes['道虚']     = '道虚'     if d0 % 6 == 0 || misoka
      notes['人神配当'] = HumanBody[d0-1]

      # 仮名暦
      notes['赤舌'  ] ||= d0 == (m * 5 - 3) % 6 + 1 ? '赤舌' : nil
      notes['大赤'  ] ||= d0 % 8 == (m * 7 - 3) % 8 ? '大赤' : nil
      notes['不成就'] ||= d0 % 8 == [6,3,2,1,4,5][m % 6] || (misoka && m % 6 == 0) ? '不成就' : nil # 『現代こよみ読み解き事典』 for 不成就日
      notes['六曜'  ] ||= Rokuyo[(m + d0) % 6]
      notes
    end
  end

  #
  # 月の位相による暦注
  #
  class JapaneseNote::LunarPhases < LunarPhases

    # 日の暦注
    # @private
    def self._day_notes(notes, dates, conditions={})
      date = When.when?(dates.o_date.to_cal_date.to_s,
               {:frame=>dates.o_date.frame,
                :clock=>dates.l_date.frame.time_basis})
      phase, metsu = dates.cal4note.l_phases.position(date)

      # 滅
      notes['滅'] = '滅' if metsu == 2

      # 月相
      unless notes['月相']
        # イベントの判定
        formula = dates.cal4note.l_phases.formula
        clock   = formula.kind_of?(When::Ephemeris::ChineseTrueLunation) &&
          (3..27).include?(dates.l_date.cal_date[2]) ?
            When.Clock(-21600) :               # 唐代暦法の望弦は午前6時を日の境界とする
            dates.l_date.frame._time_basis[-1] # その他(進朔も考慮した時刻)
        odate   = When.when?(dates.o_date.to_cal_date.to_s, {:frame=>dates.o_date.frame, :clock=>clock})
        phases  = formula.phase_range(odate)
        thitis  = phases.map {|phase| (phase % 1) * 30.0}
        note    = if thitis[0] >= thitis[1]
          dates.o_date.frame.kind_of?(When::CalendarTypes::Christian) || conditions[:shoyo] ? '朔' : nil
        else
          range = thitis[0]...thitis[1]
          range.include?( 7.5) ? '上弦' :
          range.include?(15.0) ? '望'   :
          range.include?(22.5) ? '下弦' : nil
        end

        # 結果の反映
        if conditions[:shoyo]
          # :shoyo が true ならイベント時刻も返す
          notes['月相'] = if note
            etime = formula._to_seed_type(formula.cn_to_time((phases[1] * 4).floor / 4.0), odate)
            if formula.respond_to?(:lunation_length) && formula.lunation_length.kind_of?(Rational)
              shoyo  =  etime.clk_time.universal_time
              shoyo +=  When::TM::Duration::DAY if (0...clock.universal_time).include?(shoyo)
              shoyo  = (shoyo  / When::TM::Duration::DAY * formula.denominator * 1000 + 0.5).floor / 1000.0
              shoyo  =  shoyo.to_i if shoyo == shoyo.to_i
              "#{note}(#{shoyo}/#{formula.denominator})"
            else
              etime.events = [note]
              etime
            end
          else
            nil
          end
        else
          # :shoyo が false ならイベン名のみ返す
          notes['月相'] = note
        end
      end

      # 月食
      notes['月食']        = nil # 計算できないので、偽としておく
      notes
    end
  end

  #
  # 太陽黄経による暦注
  #
  class JapaneseNote::SolarTerms < SolarTerms

    Notes12 = %w(正月 二月 三月 四月 五月 六月 七月 八月 九月 十月 十一月 十二月)

    Notes10 = [
      %w(初伏 初伏),
      %w(仲伏 中伏),
      %w(後伏 末伏)]

    Notes60_A = [
      #  +0      
      '侯小過外', # 315 : 正月
      '侯需外',   # 345 : 二月
      '侯豫外',   #  15 : 三月
      '侯旅外',   #  45 : 四月
      '侯大有外', #  75 : 五月
      '侯鼎外',   # 105 : 六月
      '侯恆外',   # 135 : 七月
      '侯巽外',   # 165 : 八月
      '侯歸妹外', # 195 : 九月
      '侯艮外',   # 225 : 十月
      '侯未濟外', # 255 : 十一月
      '侯屯外'    # 285 : 十二月
    ]

    Notes60_B = [
      #  +3          +9       +15       +21       +27
      '大夫蒙',   '卿益',   '公漸',   '辟泰',   '侯需内',   # 315 : 正月
      '大夫随',   '卿晋',   '公解',   '辟大壯', '侯豫内',   # 345 : 二月
      '大夫訟',   '卿蠱',   '公革',   '辟夬',   '侯旅内',   #  15 : 三月
      '大夫師',   '卿比',   '公小畜', '辟乾',   '侯大有内', #  45 : 四月
      '大夫家人', '卿井',   '公咸',   '辟姤',   '侯鼎内',   #  75 : 五月
      '大夫豊',   '卿渙',   '公履',   '辟遯',   '侯恆内',   # 105 : 六月
      '大夫節',   '卿同人', '公損',   '辟否',   '侯巽内',   # 135 : 七月
      '大夫萃',   '卿大畜', '公賁',   '辟観',   '侯歸妹内', # 165 : 八月
      '大夫無妄', '卿明夷', '公困',   '辟剥',   '侯艮内',   # 195 : 九月
      '大夫既濟', '卿噬嗑', '公大過', '辟坤',   '侯未濟内', # 225 : 十月
      '大不蹇',   '卿頤',   '公中孚', '辟復',   '侯屯内',   # 255 : 十一月
      '大夫謙',   '卿睽',   '公升',   '辟臨',   '侯小過内'  # 285 : 十二月
    ]

    Notes72 = [
      # 儀鳳暦         宣明暦(中国)       宣明暦            貞享暦   宝暦暦・寛政暦 略本暦
      # 315 : 正月
       %w(雞始乳       東風解凍          東風解凍          東風解凍     東風解凍   東風解凍),
       %w(東風解凍     蟄始振            蟄虫始振          梅花乃芳     黄鶯睍睆   黄鶯睍睆),
       %w(蟄蟲始振     魚上氷            魚上氷            魚上氷       魚上氷     魚上氷),
       %w(魚上冰       獺祭魚            獺祭魚            土脈潤起     土脈潤起   土脉潤起),
       %w(獺祭魚       鴻雁来            鴻雁来            霞彩碧空     霞始靆     霞始靆),
       %w(鴻雁來       草木萌動          草木萌動          草木萌動     草木萌動   草木萌動),

      # 345 : 二月
       %w(始雨水       桃始華            桃始華            蟄虫啓戸     蟄虫啓戸   蟄虫啓戸),
       %w(桃始花       倉庚鳴            倉庚鳴            寒雨間熟     桃始笑     桃始笑),
       %w(倉庚鳴       鷹化爲鳩          鷹化爲鳩          菜虫化蝶     菜虫化蝶   菜虫化蝶),
       %w(鷹化爲鳩     玄鳥至            玄鳥至            雀始巣       雀始巣     雀始巣),
       %w(玄鳥至       雷乃發聲          雷乃發聲          雷乃発声     桜始開     桜始開),
       %w(雷始發聲     始電              始電              桜始開桃始笑 雷乃発声   雷乃発声),

      #  15 : 三月
       %w(始雷         桐始華            桐始華            玄鳥至       玄鳥至     玄鳥至),
       %w(蟄蟲咸動     田鼠化爲鴑        田鼠化爲鴑        鴻雁北       鴻雁北     鴻雁北),
       %w(蟄蟲啓戸     虹始見            虹始見            虹始見       虹始見     虹始見),
       %w(桐始華       萍始生            萍始生            葭始生       葭始生     葭始生),
       %w(田鼠化爲鴑   鳴鳩拂其羽        鳴鳩拂其羽        牡丹華       霜止出苗   霜止出苗),
       %w(虹始見       戴勝降于桑        戴勝降于桑        霜止出苗     牡丹華     牡丹華),

      #  45 : 四月
       %w(萍始生       螻蟈鳴            螻蟈鳴            鵑始鳴       鼃始鳴     鼃始鳴),
       %w(戴勝降于桑   蚯蚓出            蚯蚓出            蚯蚓出       蚯蚓出     蚯蚓出),
       %w(螻蟈鳴       王瓜生            王瓜生            竹笋生       竹笋生     竹笋生),
       %w(蚯蚓出       苦菜秀            苦菜秀            蚕起食桑     蚕起食桑   蚕起食桑),
       %w(王瓜生       靡草死            靡草死            紅花栄       紅花栄     紅花栄),
       %w(苦菜秀       小暑至            小暑至            麦秋至       麦秋至     麦秋至),
          
      #  75 : 五月
       %w(靡草死       螳蜋生            螳蜋生            螳螂生       螳螂生     螳螂生),
       %w(小暑至       鵙始鳴            鵙始鳴            腐草為螢     腐草為螢   腐草為螢),
       %w(螳螂生       反舌無聲          反舌無聲          梅始黄       梅子黄     梅子黄),
       %w(鵙始鳴       鹿角解            鹿角解            乃東枯       乃東枯     乃東枯),
       %w(反舌無聲     蜩始鳴            蜩始鳴            分龍雨       菖蒲華     菖蒲華),
       %w(鹿角解       半夏生            半夏生            半夏生       半夏生     半夏生),

      # 105 : 六月
       %w(蟬始鳴       温風至            温風至            温風至       温風至     温風至),
       %w(半夏生       蟋蟀居壁          蟋蟀居壁          蓮始華       蓮始華     蓮始開),
       %w(木槿榮       鷹乃學習          鷹乃學習          鷹乃学習     鷹乃学習   鷹乃学習),
       %w(温風至       腐草爲螢          腐草爲螢          桐始結花     桐始結花   桐始結花),
       %w(蟋蟀居壁     土潤溽暑          土潤溽暑          土潤溽暑     土潤溽暑   土潤溽暑),
       %w(鷹乃學習     大雨時行          大雨時行          大雨時行     大雨時行   大雨時行),

      # 135 : 七月
       %w(腐草爲螢     涼風至            涼風至            涼風至       涼風至     涼風至),
       %w(土潤溽暑     白露降            白露降            山沢浮雲     寒蝉鳴     寒蝉鳴),
       %w(涼風至       寒蟬鳴            寒蟬鳴            霧色已成     蒙霧升降   蒙霧升降),
       %w(白露降       鷹乃祭鳥          鷹乃祭鳥          寒蝉鳴       綿柎開     綿柎開),
       %w(寒蟬鳴       天地始肅          天地始肅          天地始粛     天地始粛   天地始粛),
       %w(鷹祭鳥       禾乃登            禾乃登            禾乃登       禾乃登     禾乃登),

      # 165 : 八月
       %w(天地始肅     鴻雁来            鴻雁来            草露白       草露白     草露白),
       %w(暴風至       玄鳥歸            玄鳥歸            鶺鴒鳴       鶺鴒鳴     鶺鴒鳴),
       %w(鴻雁來       群鳥養羞          群鳥養羞          玄鳥去       玄鳥去     玄鳥去),
       %w(玄鳥歸       雷乃收聲          雷乃收聲          鴻雁来       雷乃収声   雷乃収声),
       %w(羣鳥養羞     蟄蟲坏戸          蟄蟲坏戸          蟄虫坏戸     蟄虫坏戸   蟄虫坏戸),
       %w(雷始收聲     水始涸            水始涸            水始涸       水始涸     水始涸),

      # 195 : 九月
       %w(蟄蟲坏戸     鴻雁來賓          鴻雁來賓          棗栗零       鴻雁来     鴻雁来),
       %w(陰氣方盛     雀入大水爲蛤      雀入大水爲蛤      蟋蟀在戸     菊花開     菊花開),
       %w(陽氣始衰     菊有黄花          菊有黄花          菊花開       蟋蟀在戸   蟋蟀在戸),
       %w(水始涸       豺乃祭獸          豺乃祭獸          霜始降       霜始降     霜始降),
       %w(鴻雁來賓     草木黄落          草木黄落          蔦楓紅葉     霎時施     霎時施),
       %w(雀入水爲蛤   蟄蟲咸俯          蟄蟲咸俯          鶯雛鳴       楓蔦黄     楓蔦黄),

      # 225 : 十月
       %w(菊有黄花     水始冰            水始冰            山茶始開     山茶始開   山茶始開),
       %w(豺祭獣       地始凍            地始凍            地始凍       地始凍     地始凍),
       %w(水始冰       野雞入大水爲蜃    野雞入大水爲蜃    霎乃降       金盞香     金盞香),
       %w(地始凍       虹藏不見          虹藏不見          虹蔵不見     虹蔵不見   虹蔵不見),
       %w(野雞入水爲蜃 天氣上騰地氣下降  天氣上騰地氣下降  樹葉咸落     朔風払葉   朔風払葉),
       %w(虹藏不見     閉塞而成冬        閉塞而成冬        橘始黄       橘始黄     橘始黄),

      # 255 : 十一月
       %w(冰益壯       鶡鳥不鳴          鶡鳥不鳴          閉塞成冬     閉塞成冬   閉塞成冬),
       %w(地始坼       虎始交            虎始交            熊蟄穴       熊蟄穴     熊蟄穴),
       %w(鶡鳥不鳴     茘挺生            茘挺生            水仙開       鱖魚群     鱖魚群),
       %w(虎始交       蚯蚓結            蚯蚓結            乃東生       乃東生     乃東生),
       %w(芒始生       麋角解            麋角解            麋角解       麋角解     麋角解),
       %w(茘挺生       水泉動            水泉動            雪下出麦     雪下出麦   雪下出麦),

      # 285 : 十二月
       %w(蚯蚓結       雁北郷            雁北郷            芹乃栄       芹乃栄     芹乃栄),
       %w(麋角解       鵲始巣            鵲始巣            風気乃行     水泉動     水泉動),
       %w(水泉動       野雞始鴝          野雞始鴝          雉始雊       雉始雊     雉始雊),
       %w(雁北郷       雞始乳            雞始乳            款冬華       款冬華     款冬華),
       %w(鵲始巣       鷙鳥厲疾          鷙鳥厲疾          水沢腹堅     水沢腹堅   水沢腹堅),
       %w(雉始雊       水澤腹堅          水澤腹堅          鶏始乳       鶏始乳     鶏始乳)
    ]

    # 計算結果の修正
    # @private
    Patch = {
      2039054 => [149.0, 1], # 貞観12(0870).07.17 [149.0, 0] 没
      2039055 => [150.0, 0], # 貞観12(0870).07.18 [150.0, 1] 処暑

      2107233 => [ 29.0, 1], # 天喜05(1057).03.10 [ 29.0, 0] 没
      2107234 => [ 30.0, 0], # 天喜05(1057).03.11 [ 30.0, 1] 穀雨

      2160437 => [269.0, 0], # 建仁02(1202).10=29 [270.0, 1] 冬至
      2160438 => [270.0, 1], # 建仁02(1202).11.01 [271.0, 1]
      2160439 => [271.0, 1], # 建仁02(1202).11.02 [272.0, 1]
      2160440 => [272.0, 1], # 建仁02(1202).11.03 [272.0, 0] 没

      2175412 => [269.0, 1], # 寛元01(1243).11.03 [269.0, 0] 没
      2175413 => [270.0, 0], # 寛元01(1243).11.04 [270.0, 1] 冬至

      2189200 => [179.0, 0], # 弘安04(1281).07=30 [180.0, 1] 秋分
      2189201 => [180.0, 1], # 弘安04(1281).08.01 [181.0, 1]
      2189202 => [181.0, 1], # 弘安04(1281).08.02 [181.0, 0] 没

      2243577 => [136.0, 0], # 永享02(1430).07.11 [136.0, 1] (立秋の翌日)
      2243578 => [136.0, 1], # 永享02(1430).07.12 [137.0, 1]
      2243579 => [137.0, 1], # 永享02(1430).07.13 [138.0, 1]
      2243580 => [138.0, 1], # 永享02(1430).07.14 [139.0, 1]
      2243581 => [139.0, 1], # 永享02(1430).07.15 [140.0, 1]
      2243582 => [140.0, 1], # 永享02(1430).07.16 [141.0, 1]
      2243583 => [141.0, 1], # 永享02(1430).07.17 [142.0, 1]
      2243584 => [142.0, 1], # 永享02(1430).07.18 [143.0, 1]
      2243585 => [143.0, 1], # 永享02(1430).07.19 [144.0, 1]
      2243586 => [144.0, 1], # 永享02(1430).07.20 [145.0, 1]
      2243587 => [145.0, 1], # 永享02(1430).07.21 [146.0, 1]
      2243588 => [146.0, 1], # 永享02(1430).07.22 [147.0, 1]
      2243589 => [147.0, 1], # 永享02(1430).07.23 [148.0, 1]
      2243590 => [148.0, 1], # 永享02(1430).07.24 [149.0, 1]
      2243591 => [149.0, 1], # 永享02(1430).07.25 [149.0, 0] 没 (処暑の前日)

      2311770 => [ 29.0, 1], # 元和03(1617).03.18 [ 29.0, 0] 没
      2311771 => [ 30.0, 0]  # 元和03(1617).03.19 [ 30.0, 1] 穀雨
    }

    class << self
      # テスト用の属性
      attr_writer :patch
      private :patch=

      # 日の暦注
      # @private
      def _day_notes(notes, dates, conditions={})
        date  = When.when?(dates.o_date.to_cal_date.to_s,
                  {:frame=>dates.o_date.frame,
                   :clock=>dates.s_date.frame._time_basis[0]})
        patch = (@patch || Patch)[date.to_i] unless dates.o_date.frame.respond_to?(:twin) &&
                                                    dates.o_date.frame.twin
        longitude, motsu = patch ? patch : dates.cal4note.s_terms.position(date)

        # 三伏 - 庚
        #
        # 初 : 夏至から 20..29
        # 仲 : 夏至から 30..39
        # 後 : 立秋から  0..9 
        if !notes['三伏'] && notes['干'].remainder == 6 # 庚
          index = dates.range >= 11 ? 1 : 0
          if 109 <= longitude && longitude <= 129      # 夏至から
            term = dates.cal4note.s_terms.term(date, [-270,360])
            diff = dates.s_date.to_i - term.to_i
            notes['三伏'] = Notes10[0][index] if 20 <= diff && diff <= 29
            notes['三伏'] = Notes10[1][index] if 30 <= diff && diff <= 39
          elsif longitude == 135                     # 立秋
            notes['三伏'] = Notes10[2][index]
          elsif 136 <= longitude && longitude <= 144 # 立秋から
            term = dates.cal4note.s_terms.term(date, [-225,360])
            diff = dates.s_date.to_i - term.to_i
            notes['三伏'] = Notes10[2][index] if 0 < diff && diff <= 9
          end
        end

        # 社 - 戊
        #
        # 春秋分から -5..4
        if !notes['社'] && notes['干'].remainder == 4 # 戊
          if (longitude + 5) % 180 < 10 # 春秋分の近傍
            term = dates.cal4note.s_terms.term(date - When.Duration('P5D'), [0,180])
            diff = dates.s_date.to_i - term.to_i
            notes['社'] = '社' if -5 <= diff && diff <= 4
          end
        end

        # 臘 - 辰
        #
        # 大寒から -6..5
        if !notes['臘'] && notes['支'].remainder == 4 # 辰
          if (longitude - 339) % 360 < 12 # 大寒の近傍
            term = dates.cal4note.s_terms.term(date - When.Duration('P6D'), [345,360])
            diff = dates.s_date.to_i - term.to_i
            notes['臘'] = '臘' if -6 <= diff && diff <= 5
          end
        end

        # 土用事
        unless notes['土用事']
          _longitude, _motsu = dates.cal4note.doyo ? dates.cal4note.s_terms.position(date, -dates.cal4note.doyo) :
                                                     [longitude, motsu]
          if _motsu != 0 && _longitude % 90 == 27
            notes['土用事'] =
              case dates.range
              when 0     ; '土用'   # 元嘉暦以前
              when 1     ; '土王'   # 麟徳暦
              when 2..10 ; '土用事' # 大衍暦～宣明暦
              else       ; '土用入' # 貞享暦以降
              end
          end
        end

        # 入梅 - 壬
        #
        # 貞享2(1685)～ 芒種から 1..10 日の壬の日
        # 元文5(1740)～ 芒種から 0..9  日の壬の日
        # 明治9(1876)～ 太陽黄経80度
        unless notes['入梅']
          if dates.year >= 1876
            notes['入梅'] = '入梅' if longitude == 80 && motsu == 1
          elsif notes['干'].remainder == 8 # 壬
            if (longitude - 75) % 360 <= 10 # 芒種の近傍
              term  = dates.cal4note.s_terms.term(date - When.Duration('P11D'), [75,360])
              diff  = dates.s_date.to_i - term.to_i
              diff += 1 if dates.year >= 1740
              notes['入梅'] = '入梅' if dates.range >= 11 && 1 <= diff && diff <= 10
            end
          end
        end

        # 立春を起算日とする雑節
        #
        unless notes['節分'] && notes['八十八夜'] && notes['二百十日'] && notes['二百廿日']
          term = dates.cal4note.s_terms.term(date + When.Duration('P3D'), [-45,360])
          case dates.s_date.to_i - term.to_i
          when  -1 ; notes['節分']     ||= '節分'
          when  87 ; notes['八十八夜'] ||= '八十八夜'
          when 209 ; notes['二百十日'] ||= '二百十日'
          when 219 ; notes['二百廿日'] ||= '二百廿日'
          end
        end

        # 日食
        notes['日食']       = nil # 計算できないので、偽としておく

        # 没
        if motsu == 0
          notes['没'] = '没' if dates.range < 11
          return notes unless patch
        end

        # 廿四節気
        div, mod = longitude.divmod(15)
        if mod == 0
          note = (div - 21) % 24
          div, mod = note.divmod(2)
          notes['節中']     ||= Notes12[div] + %w(節 中)[mod]
          notes['廿四節気'] ||= 
            begin
              root      = When.Resource(dates.range == 1 ? '_co:CommonResidue?V=0618' : '_co:CommonResidue')
              residue   = root['二十四節気::*'][(note-3) % 24]
              if conditions[:shoyo]
                formula = dates.cal4note.s_terms.formula
                etime   = dates.cal4note.s_terms.term(date - When.Duration('P3D'), [0,15], When::SYSTEM)
                if formula.respond_to?(:year_length) && formula.year_length.kind_of?(Rational)
                  shoyo  =  etime.clk_time.universal_time
                  shoyo +=  When::TM::Duration::DAY * (etime.to_i - date.to_i)
                  shoyo  = (shoyo  / When::TM::Duration::DAY * formula.denominator * 1000 + 0.5).floor / 1000.0
                  shoyo  =  shoyo.to_i if shoyo == shoyo.to_i
                  residue.label + "(#{shoyo}/#{formula.denominator})"
                else
                  etime.events = [residue.label]
                  etime
                end
              else
                residue
              end
            end
        end

        # 七十二候
        div, mod = longitude.divmod(5)
        notes['七十二候'] ||= mod == 0  ? Notes72[(div - 63) % 72][dates.index_s]  : nil

        # 往亡
        month    = dates.s_date.cal_date[1] - 1
        div, mod = month.divmod(3)
        notes['往亡']     ||= ((div+7)*(mod+1) + month * 30 + 314 - longitude) % 360 == 0 ? '往亡'  : nil

        # 伏龍
        notes['伏龍']     ||= {
          315 => '庭内去堂',  15 => '門内百日', 115 => '東垣六十日',
          175 => '四隅百日', 275 => '竈内四十日'
        }[longitude]

        # 六十卦
        div, mod = longitude.divmod(30)
        notes['六十卦']   ||= mod == 15 ? Notes60_A[(div - 10) % 12] : nil
        div, mod = longitude.divmod(6)
        notes['六十卦']   ||= mod == 0  ? Notes60_B[(div - 53) % 60] : nil

        # 彼岸
        unless notes['彼岸']
          if dates.range < 11
            notes['彼岸'] = '彼岸' if longitude % 180 == 2 # 宣明暦以前(没を除いて３日後)
          else
            term = dates.cal4note.s_terms.term(date - When.Duration('P7D'), [0,180]) # 近傍の春秋分
            case dates.s_date.to_i - term.to_i
            when  2 ; notes['彼岸'] = '彼岸' if dates.range == 11 # 貞享暦(没を含めて３日後)
            when -5 ; notes['彼岸'] = '彼岸' if longitude >  180 && (1755...1844).include?(dates.year) # 宝暦暦・寛政暦(春-６日前))
            when -1 ; notes['彼岸'] = '彼岸' if longitude <= 180 && (1755...1844).include?(dates.year) # 宝暦暦・寛政暦(秋-２日前)
            when -3 ; notes['彼岸'] = '彼岸' if dates.year >= 1844 # 天保暦以降(秋-４日前)
            end
          end
          notes['彼岸'] = nil unless notes['彼岸'] == '彼岸'
        end

        notes
      end
    end
  end
end
