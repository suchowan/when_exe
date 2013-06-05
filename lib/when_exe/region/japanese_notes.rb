# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2012-2013 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

require 'when_exe/region/japanese_residues'

class When::CalendarTypes::CalendarNote

  #
  # 日本暦注
  #
  class JapaneseNote < self

    #
    # 日本暦注の要素
    #
    class Notes < When::CalendarTypes::CalendarNote::NoteElement; end

    NoteTypes = [
    # 開始年  暦法       土用のオフセット
      [-660, '儀鳳暦' ],
      [ 454, '元嘉暦' ],
      [ 697, '麟徳暦',   (Rational( 4,15) +  244) / 1340  ], # 啓蟄 <-> 雨水
      [ 764, '大衍暦',   (Rational(13,30) +  531) / 3040  ],
      [ 858, '五紀暦',   (Rational( 4,15) +  244) / 1340  ],
      [ 862, '宣明暦',   (Rational( 1, 2) + 1468) / 8400  ],
      [1685, ['timezone=32584.4/3600', '前貞享暦(節月)'  ]],
      [1687, ['timezone=32584.4/3600', '貞享暦(節月)'    ]],
      [1753, ['timezone=32584.4/3600', '前々宝暦暦(節月)']],
      [1754, ['timezone=32584.4/3600', '前宝暦暦(節月)'  ]],
      [1755, ['timezone=32584.4/3600', '宝暦暦(節月)'    ]],
      [1771, ['timezone=32584.4/3600', '修正宝暦暦(節月)']],
      [1798, ['timezone=32584.4/3600', '寛政暦(節月)'    ]],
      [1844, 'timezone=32584.4/3600'], # 京都平均太陽時の定朔定気法太陰太陽暦(天保暦の代用)
      [1873, 'timezone=33539/3600'  ], # 東京平均太陽時の定朔定気法太陰太陽暦
      [1888, 'timezone=9']             # 日本標準時の定朔定気法太陰太陽暦
    ].reverse

    NoteObjects = [When::BasicTypes::M17n, [
      "namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/]",
      "locale:[=ja:]",
      "names:[日本暦注]",

      # 年の暦注 ----------------------------
      [When::BasicTypes::M17n,
        "names:[年]",
        [Notes, "label:[干支]",       'position:共通'],                # 干支
      # [Notes, "label:[干=ja:%E5%8D%81%E5%B9%B2]",
      #                               'position:共通'],                # 干
      # [Notes, "label:[支=ja:%E5%8D%81%E4%BA%8C%E6%94%AF]",
      #                               'position:共通'],                # 支
        [Notes, "label:[九星]",       'position:民間'],                # 九星
        [Notes, "label:[大歳壇=]",    'position:暦序'],                # 干支
        [Notes, "label:[納音]",       'position:暦序',   'suffix:是'], # 干支
        [Notes, "label:[大歳=ja:%E5%A4%AA%E6%AD%B3%E7%A5%9E]",
                                      'position:暦序',   'suffix:在'], # 干支
        [Notes, "label:[大将軍=ja:%E5%A4%A7%E5%B0%86%E8%BB%8D_(%E6%96%B9%E4%BD%8D%E7%A5%9E)]",
                                      'position:暦序',   'suffix:在'], # 支
        [Notes, "label:[大陰=ja:%E5%A4%A7%E9%99%B0]",
                                      'position:暦序',   'suffix:在'], # 支
        [Notes, "label:[歳徳=ja:%E6%AD%B3%E5%BE%B3%E7%A5%9E]",
                                      'position:暦序',   'suffix:在'], # 干
        [Notes, "label:[歳刑=ja:%E6%AD%B3%E5%88%91%E7%A5%9E]",
                                      'position:暦序',   'suffix:在'], # 支
        [Notes, "label:[歳破=ja:%E6%AD%B3%E7%A0%B4%E7%A5%9E]",
                                      'position:暦序',   'suffix:在'], # 支
        [Notes, "label:[歳煞=ja:%E6%AD%B3%E6%AE%BA%E7%A5%9E]",
                                      'position:暦序',   'suffix:在'], # 支
        [Notes, "label:[黄幡=ja:%E9%BB%84%E5%B9%A1%E7%A5%9E]",
                                      'position:暦序',   'suffix:在'], # 支
        [Notes, "label:[豹尾=ja:%E8%B1%B9%E5%B0%BE%E7%A5%9E]",
                                      'position:暦序',   'suffix:在'], # 支
        [Notes, "label:[歳次=]",      'position:暦序',   'suffix:-'],  # 支
        [Notes, "label:[金神]",       'position:仮名暦', 'suffix:在']  # 干
      ],

      # 月の暦注 ----------------------------
      [When::BasicTypes::M17n,
        "names:[月]",
        [Notes, "label:[月名=ja:%E6%9C%88_(%E6%9A%A6)#.E6.97.A5.E6.9C.AC.E3.81.AE.E5.92.8C.E9.A2.A8.E6.9C.88.E5.90.8D]",
                                      'position:月建'],       # 月の和名
      # [Notes, "label:[干支]",       'position:共通'],       # 干支
      # [Notes, "label:[干=ja:%E5%8D%81%E5%B9%B2]",
      #                               'position:共通'],       # 干
      # [Notes, "label:[支=ja:%E5%8D%81%E4%BA%8C%E6%94%AF]",
      #                               'position:共通'],       # 支
        [Notes, "label:[九星]",       'position:民間'],       # 九星
        [Notes, "label:[月建=]",      'position:月建',   'suffix:-'],  # 干支
        [Notes, "label:[天道=]",      'position:月建',   'suffix:-'],  # 干
        [Notes, "label:[天徳=]",      'position:月建',   'suffix:在'], # 干
        [Notes, "label:[月煞=]",      'position:月建',   'suffix:在'], # 干
        [Notes, "label:[用時=]",      'position:月建'],                # 干
        [Notes, "label:[月徳=]",      'position:月建',   'suffix:在'], # 干
        [Notes, "label:[月徳合=]",    'position:月建',   'suffix:在'], # 干
        [Notes, "label:[月空=]",      'position:月建',   'suffix:在'], # 干
        [Notes, "label:[三鏡=]",      'position:月建'],                # 干
        [Notes, "label:[土府=]",      'position:月建',   'suffix:在'], # 干
        [Notes, "label:[土公=ja:%E5%9C%9F%E5%85%AC%E7%A5%9E]",
                                      'position:月建',   'suffix:在']  # 干
      ],

      # 日の暦注 ----------------------------
      [When::BasicTypes::M17n,
        "names:[日]",
        [Notes, "label:[干支]",       'position:共通'],                # 干支
      # [Notes, "label:[干=ja:%E5%8D%81%E5%B9%B2]",
      #                               'position:共通'],                # 干
      # [Notes, "label:[支=ja:%E5%8D%81%E4%BA%8C%E6%94%AF]",
      #                               'position:共通'],                # 支
        [Notes, "label:[納音]",       'position:共通',   'suffix:是'], # 干支
        [Notes, "label:[十二直]",     'position:共通'],                # 支 節月
        [Notes, "label:[七曜]",       'position:共通'],                # 七曜
        [Notes, "label:[廿八宿=ja:%E4%BA%8C%E5%8D%81%E5%85%AB%E5%AE%BF]",
                                      'position:共通'],                # 廿八宿
        [Notes, "label:[廿七宿=ja:%E4%BA%8C%E5%8D%81%E4%B8%83%E5%AE%BF]",
                                      'position:共通'],                # 暦月 暦日
        [Notes, "label:[九星]",       'position:民間'],                # 九星
        [Notes, "label:[六曜]",       'position:民間'],                # 暦月 暦日
        [Notes, "label:[祝祭日]",     'position:祝祭日'],              # 暦月 暦日 (七曜)

        [Notes, "label:[節中=]",      'position:時候'],                # 太陽黄経
        [Notes, "label:[廿四節気=ja:%E4%BA%8C%E5%8D%81%E5%9B%9B%E7%AF%80%E6%B0%97]",
                                      'position:時候'],                # 太陽黄経
        [Notes, "label:[七十二候]",   'position:時候'],                # 太陽黄経
        [Notes, "label:[六十卦=]",    'position:時候'],                # 太陽黄経
        [Notes, "label:[入梅]",       'position:雑節'],                # 干 太陽黄経

        [Notes, "label:[大禍=ja:%E5%A4%A7%E7%A6%8D%E6%97%A5#.E5.A4.A7.E7.A6.8D.E6.97.A5]",
                                      'position:上段 上段 欄外 欄外', 'suffix:日'],    # 支 節月
        [Notes, "label:[滅門=ja:%E6%BB%85%E9%96%80%E6%97%A5#.E6.BB.85.E9.96.80.E6.97.A5]",
                                      'position:上段 上段 欄外 欄外', 'suffix:日'],    # 支 節月
        [Notes, "label:[狼藉=ja:%E6%9A%A6%E6%B3%A8%E4%B8%8B%E6%AE%B5#.E7.8B.BC.E8.97.89.E6.97.A5]",
                                      'position:上段 上段 欄外 欄外', 'suffix:日'],    # 支 節月

        [Notes, "label:[甘露=]",      'position:上段 上段 上段 上段', 'suffix:日'],    # 七曜 廿七宿
        [Notes, "label:[金剛峯=]",    'position:上段 上段 上段 上段'],                 # 七曜 廿七宿
        [Notes, "label:[羅刹=]",      'position:中段 中段 上段 上段'],                 # 七曜 廿七宿

        [Notes, "label:[大将軍=ja:%E5%A4%A7%E5%B0%86%E8%BB%8D_(%E6%96%B9%E4%BD%8D%E7%A5%9E)]",
                                      'position:上段 上段 上段 上段',   'suffix:-'],   # 干支 節年
        [Notes, "label:[天一=ja:%E5%A4%A9%E4%B8%80%E7%A5%9E]",
                                      'position:上段 上段 上段 上段',   'suffix:-'],   # 干支
        [Notes, "label:[土公=ja:%E5%9C%9F%E5%85%AC%E7%A5%9E]",
                                      'position:上段 上段 上段 上段'],                 # 干支
        [Notes, "label:[歳下食=ja:%E6%AD%B3%E4%B8%8B%E9%A3%9F#.E6.AD.B3.E4.B8.8B.E9.A3.9F]",
                                      'position:上段 上段 上段 上段'],                 # 干支 節年
        [Notes, "label:[忌遠行=]",    'position:上段 中段 上段 上段'],                 # 支 節月
        [Notes, "label:[忌夜行=]",    'position:上段 中段 上段 上段'],                 # 支 節月
        [Notes, "label:[下食時=ja:%E4%B8%8B%E9%A3%9F%E6%99%82#.E6.99.82.E4.B8.8B.E9.A3.9F]",
                                      'position:上段 上段 上段 上段'],                 # 支 節月 貞享暦で一部廃止
        [Notes, "label:[天間=]",      'position:上段 中段 上段 中段上'],               # 干支 節月
        [Notes, "label:[不視病=]",    'position:上段 上段 上段 上段'],                 # 干
        [Notes, "label:[不問疾=]",    'position:上段 上段 上段 上段'],                 # 干
        [Notes, "label:[不弔人=]",    'position:上段 上段 上段 上段'],                 # 支
        [Notes, "label:[社=ja:%E7%A4%BE%E6%97%A5]",
                                      'position:中段 中段 中段 中段', 'suffix:日'],    # 干 太陽黄経
        [Notes, "label:[三伏]",       'position:中段 中段 中段 中段'],                 # 干 太陽黄経
        [Notes, "label:[除手足甲=]",  'position:中段 中段 中段 中段'],                 # 晦(除手足甲)、支(片方のみ), 没滅凶会日×
        [Notes, "label:[沐浴=]",      'position:中段 中段 中段 中段'],                 # 支 没滅凶会日×
        [Notes, "label:[臘=ja:%E8%87%98%E6%97%A5]",
                                      'position:中段 中段 中段 中段', 'suffix:日'],    # 支 太陽黄経
        [Notes, "label:[伐=]",        'position:上段 中段 中段 中段上', 'suffix:日'],  # 干支
        [Notes, "label:[五墓=ja:%E4%BA%94%E5%A2%93%E6%97%A5#.E4.BA.94.E5.A2.93.E6.97.A5]",
                                      'position:上段 上段 中段 中段下', 'suffix:日'],  # 干支
        [Notes, "label:[九虎=]",      'position:上段 中段 中段 中段上'],               # 干支 節月
        [Notes, "label:[八龍=]",      'position:上段 上段 中段 中段上'],               # 干支 節月
        [Notes, "label:[七鳥=]",      'position:上段 上段 中段 中段上'],               # 干支 節月
        [Notes, "label:[六蛇=]",      'position:上段 上段 中段 中段上'],               # 干支 節月

        [Notes, "label:[没=ja:%E6%B2%A1%E6%97%A5]",
                                      'position:中段 中段 中段 中段', 'suffix:日'],    # 太陽黄経
        [Notes, "label:[日食]",       'position:中段 中段 中段 中段'],                 # 日食表
        [Notes, "label:[滅=ja:%E6%BB%85%E6%97%A5]",
                                      'position:中段 中段 中段 中段', 'suffix:日'],    # 月の位相
        [Notes, "label:[月食]",       'position:中段 中段 中段 中段'],                 # 月食表
        [Notes, "label:[月相]",       'position:中段 中段 中段 中段'],                 # 月の位相
        [Notes, "label:[土用事=ja:%E5%9C%9F%E7%94%A8]",
                                      'position:中段 中段 中段 中段'],                 # 太陽黄経
        [Notes, "label:[伏龍=]",      'position:上段 上段 下段 下段', 'suffix:在'],    # 太陽黄経

        [Notes, "label:[凶会=ja:%E5%87%B6%E4%BC%9A%E6%97%A5#.E5.87.B6.E4.BC.9A.E6.97.A5]",
                                      'position:下段 下段 下段 下段', 'suffix:日'],    # 干支 節月(宣明暦以前)/暦月(貞享暦以降)
        [Notes, "label:[大小歳=]",    'position:下段 下段 下段 下段'],                 # 干支 節月
        [Notes, "label:[歳徳=ja:%E6%AD%B3%E5%BE%B3%E7%A5%9E]",
                                      'position:下段 下段 下段 下段',],                # 干 節年 凶会日× ～合も
        [Notes, "label:[天恩=ja:%E5%A4%A9%E6%81%A9%E6%97%A5#.E5.A4.A9.E6.81.A9.E6.97.A5]",
                                      'position:下段 下段 下段 下段', 'suffix:日'],    # 干支 節月 凶会日×
        [Notes, "label:[天赦=ja:%E6%9A%A6%E6%B3%A8%E4%B8%8B%E6%AE%B5#.E5.A4.A9.E8.B5.A6.E6.97.A5]",
                                      'position:下段 下段 下段 下段'],                 # 干支 節月
        [Notes, "label:[母倉=ja:%E6%AF%8D%E5%80%89%E6%97%A5#.E6.AF.8D.E5.80.89.E6.97.A5]",
                                      'position:下段 下段 下段 下段', 'suffix:日'],    # 支 節月 凶会日×
        [Notes, "label:[月徳=]",      'position:下段 下段 下段 下段',],                # 干 節月 凶会日× ～合も
        [Notes, "label:[九坎=]",      'position:下段 下段 下段 下段'],                 # 支 節月
        [Notes, "label:[帰忌=ja:%E5%B8%B0%E5%BF%8C%E6%97%A5#.E5.B8.B0.E5.BF.8C.E6.97.A5]",
                                      'position:下段 下段 下段 下段', 'suffix:日'],    # 支 節月
        [Notes, "label:[血忌=ja:%E8%A1%80%E5%BF%8C%E6%97%A5#.E8.A1.80.E5.BF.8C.E6.97.A5]",
                                      'position:下段 下段 下段 下段', 'suffix:日'],    # 支 節月
        [Notes, "label:[無翹=]",      'position:下段 下段 下段 下段'],                 # 支 節月
        [Notes, "label:[厭=]",        'position:下段 下段 下段 下段'],                 # 支 節月
        [Notes, "label:[重=ja:%E9%87%8D%E6%97%A5#.E9.87.8D.E6.97.A5]",
                                      'position:下段 下段 下段 下段', 'suffix:日'],    # 支
        [Notes, "label:[復=ja:%E5%BE%A9%E6%97%A5#.E5.BE.A9.E6.97.A5]",
                                      'position:下段 下段 下段 下段', 'suffix:日'],    # 干 節月
        [Notes, "label:[月煞=]",      'position:下段 下段 下段 下段', 'suffix:在'],    # 支 節月
        [Notes, "label:[往亡=ja:%E5%BE%80%E4%BA%A1%E6%97%A5#.E5.BE.80.E4.BA.A1.E6.97.A5]",
                                      'position:下段 下段 下段 下段', 'suffix:日'],    # 太陽黄経
        [Notes, "label:[日遊=ja:%E6%97%A5%E9%81%8A%E7%A5%9E]",
                                      'position:最下段', 'suffix:在'],                 # 干支

        [Notes, "label:[受死=ja:%E5%8F%97%E6%AD%BB%E6%97%A5#.E5.8F.97.E6.AD.BB.E6.97.A5]",
                                      'position:仮名暦', 'suffix:日'], # 支 節月
        [Notes, "label:[彼岸]",       'position:仮名暦'],              # 太陽黄経
        [Notes, "label:[八専]",       'position:仮名暦'],              # 干支
        [Notes, "label:[金神間日=ja:%E9%87%91%E7%A5%9E#.E9.87.91.E7.A5.9E.E3.81.AE.E9.81.8A.E8.A1.8C.E3.83.BB.E9.96.93.E6.97.A5]",
                                      'position:仮名暦'],              # 支 節月
        [Notes, "label:[天火=ja:%E5%A4%A9%E7%81%AB%E6%97%A5#.E5.A4.A9.E7.81.AB.E6.97.A5]",
                                      'position:仮名暦', 'suffix:日'], # 支 節月
        [Notes, "label:[地火=ja:%E5%9C%B0%E7%81%AB%E6%97%A5#.E5.9C.B0.E7.81.AB.E6.97.A5]",
                                      'position:仮名暦', 'suffix:日'], # 支 節月
        [Notes, "label:[人火=]",      'position:仮名暦'],              # 支 節月
        [Notes, "label:[雷火=]",      'position:仮名暦'],              # 支 節月
        [Notes, "label:[赤舌=ja:%E8%B5%A4%E8%88%8C%E6%97%A5]",
                                      'position:仮名暦', 'suffix:日'], # 暦月 暦日
        [Notes, "label:[十死=ja:%E5%8D%81%E6%AD%BB%E6%97%A5#.E5.8D.81.E6.AD.BB.E6.97.A5]",
                                      'position:仮名暦', 'suffix:日'], # 支 節月
        [Notes, "label:[道虚=]",      'position:仮名暦', 'suffix:日'], # 暦日
        [Notes, "label:[大明=ja:%E5%A4%A7%E6%98%8E%E6%97%A5#.E5.A4.A7.E6.98.8E.E6.97.A5]",
                                      'position:仮名暦', 'suffix:日'], # 干支
        [Notes, "label:[赤口=ja:%E8%B5%A4%E5%8F%A3%E6%97%A5]",
                                      'position:仮名暦', 'suffix:日'], # 暦月 暦日
        [Notes, "label:[甲子待=ja:%E7%94%B2%E5%AD%90]",
                                      'position:仮名暦'],              # 干支
        [Notes, "label:[庚申待]",     'position:仮名暦'],              # 干支
        [Notes, "label:[犯土]",       'position:仮名暦'],              # 干支
        [Notes, "label:[十方暮]",     'position:仮名暦'],              # 干支
        [Notes, "label:[一粒万倍=ja:%E4%B8%80%E7%B2%92%E4%B8%87%E5%80%8D%E6%97%A5]",
                                      'position:仮名暦', 'suffix:日'], # 支 節月
        [Notes, "label:[天福=]",      'position:仮名暦'],              # 支 節月
        [Notes, "label:[地福=]",      'position:仮名暦'],              # 支 節月
        [Notes, "label:[地五福=]",    'position:仮名暦'],              # 支 節月
        [Notes, "label:[三隣亡]",     'position:仮名暦'],              # 支 節月
        [Notes, "label:[不成就=ja:%E4%B8%8D%E6%88%90%E5%B0%B1%E6%97%A5]",
                                      'position:仮名暦', 'suffix:日'], # 暦月 暦日/晦日

        [Notes, "label:[三宝吉=]",    'position:上段 上段 上段 上段'],                 # 干支 節月(宣明暦以前)/暦月(貞享暦以降)
        [Notes, "label:[神吉=ja:%E7%A5%9E%E5%90%89%E6%97%A5#.E7.A5.9E.E5.90.89.E6.97.A5]",
                                      'position:上段 上段 中段 中段上', 'suffix:日'],  # 干支 節月
        [Notes, "label:[雑事吉=]",    'position:雑事吉'],                              # 干支 節月(宣明暦以前)/暦月(貞享暦以降)
        [Notes, "label:[小字注=]",    'position:下段小字 下段小字 下段小字 下段小字'], # 干支 節月(宣明暦以前)/暦月(貞享暦以降)
      ]
    ]]

    #
    #  日本暦注用の NoteObjects の要素のための内部クラス
    #
    class Notes

      # @private
      attr_reader :label, :position, :suffix

      # @private
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
    class Dates

      # @private
      attr_reader :year, :calendar, :doyo, :o_date, :m_date, :l_date, :s_date, :s_terms, :l_phases

      # 具注暦の配置パターン
      # @private
      def index_g
        return @index_g if @index_g
        @index_g = (@year < 1004) ? 0 : # 御堂関白記(前期)以前
                   (@year < 1185) ? 1 : # 御堂関白記(後期)
                   (@year < 1338) ? 2 : # 鎌倉時代
                                    3   # 室町時代以降
      end

      # 七十二候パターン
      # @private
      def index_s
        return @index_s if @index_s
        @index_s = (@year < 1685) ? 1 : # 宣明暦式
                   (@year < 1755) ? 2 : # 貞享暦式
                   (@year < 1874) ? 3 : # 宝暦暦式
                                    4   # 略本暦式
      end

      # 初期設定
      # @private
      def initialize(date, year, calendar, doyo=nil)
        case calendar
        when Array      # 日本製定朔平気法
          l_calendar = When.Calendar('ChineseLuniSolar?' + calendar[0])
          s_calendar = When.Calendar('Chinese::' + calendar[1])
        when /timezone/ # 定朔定気法
          l_calendar = When.Calendar('ChineseLuniSolar?' + calendar)
          s_calendar = When.Calendar('ChineseSolar?'     + calendar)
        else            # 中国製平定朔平気法
          l_calendar = When.Calendar('Chinese::' + calendar)
          s_calendar = When.Calendar('Chinese::' + calendar + '(節月)')
        end

        @year     = year
        @calendar = calendar
        @doyo     = doyo
        @o_date   = date
        @l_date   = l_calendar ^ date
        @m_date   = date.frame.kind_of?(When::CalendarTypes::Julian) ? @l_date : date
        @s_date   = s_calendar ^ date
        @s_terms  = When::CalendarTypes::CalendarNote::SolarTerms.new('formula'=>s_calendar.formula[0])
        @l_phases = When::CalendarTypes::CalendarNote::LunarPhases.new('formula'=>l_calendar.formula[-1])
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
    #   :note     => 暦注要素 (When::CalendarTypes::JapaneseNote::Notes)
    #   :value    => 暦注の値 (String or When::BasicTypes::M17n または、その Array)
    #   :position => 具注暦でのその暦注の配置場所(String)
    #
    def notes(date, options={})
      dates, indices, notes, conditions, options = _parse(date, options)
      _result(indices.map {|i|
        next [] unless i <= dates.o_date.precision
        send(NoteMethods[i-1], dates, notes[i-1], conditions)
      }, options)
    end

    private

    # オブジェクトの正規化
    def _normalize(args=[], options={})
      @prime ||= [%w(干支), %w(月名), %w(干支 六曜 廿四節気 祝祭日)]
      super
    end

    # 年の暦注
    def year_notes(dates, notes, conditions={})
      _note_values(dates, notes, _all_keys[-3], _elements[-3]) do |dates, focused_notes, notes_hash|

        root = When.Resource('_co:CommonResidue')

        # 干支
        residue = dates.m_date.most_significant_coordinate-4
        notes_hash['干支']   = root['干支'][residue % 60]
        notes_hash['干']     = root['干'  ][residue % 10]
        notes_hash['支']     = root['支'  ][residue % 12]

        # 九星
        notes_hash['九星'] ||= root['九星'][When::Coordinates::Kyusei.year(dates.s_date.most_significant_coordinate-4)]

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

        root = When.Resource('_co:CommonResidue')

        # 干支
        residue = dates.m_date.most_significant_coordinate*12+(dates.m_date.cal_date[1] * 1)+13
        notes_hash['干支']   = root['干支'][residue % 60]
        notes_hash['干']     = root['干'  ][residue % 10]
        notes_hash['支']     = root['支'  ][residue % 12]

        # 九星
        notes_hash['九星'] ||= root['九星'][When::Coordinates::Kyusei.month(
          dates.s_date.most_significant_coordinate*12+dates.s_date.cal_date[1]+13)]

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

        root = When.Resource('_co:CommonResidue')

        # 干支
        residue = dates.s_date.to_i-11
        notes_hash['干支']     = root['干支'][residue % 60]
        notes_hash['干']       = root['干'  ][residue % 10]
        notes_hash['支']       = root['支'  ][residue % 12]

        # 七曜
        notes_hash['七曜']   ||= root['Week'][dates.s_date.to_i % 7]

        # 廿八宿
        notes_hash['廿八宿'] ||= root['宿'][(dates.s_date.to_i+11) % 28] if dates.year >= 1685

        # 九星
        notes_hash['九星']   ||= root['九星'][When::Coordinates::Kyusei.day(dates.o_date, dates.s_terms)]

        # その他
        [SolarTerms, LunarPhases, notes_hash['干支'], notes_hash['干'], notes_hash['支'],
         JapaneseLuniSolarNote, JapaneseSolarNote].each do |note|
          note._day_notes(notes_hash, dates, conditions)
        end

        # 廿七宿
        notes_hash['廿七宿']   = root['宿'][notes_hash['廿七宿']] if notes_hash['廿七宿'].kind_of?(Integer)

        # 廿四節気
        notes_hash['廿四節気'] = 3 - notes_hash['廿四節気'] if dates.calendar == '麟徳暦' &&
                                                              [1,2].include?(notes_hash['廿四節気']) # 啓蟄 <-> 雨水
        notes_hash['廿四節気'] = root['二十四節気::*'][(notes_hash['廿四節気']-3) % 24] if notes_hash['廿四節気'].kind_of?(Integer)
        notes_hash
      end
    end

    #
    # 日本暦日情報オブジェクトの生成
    #
    def _to_date_for_note(date)
      date = _to_japanese_date(date)
      return nil unless date
      year = date.most_significant_coordinate
      NoteTypes.each do |type|
        start, calendar, doyo = type
        return Dates.new(date, year, calendar, doyo) if year >= start
      end
      nil
    end

    #
    # 任意の暦を日本暦日に変換
    #
    def _to_japanese_date(date)
      return date if date.frame.kind_of?(When::CalendarTypes::ChineseLuniSolar) ||
                     date._attr[:query] && date._attr[:query]['area'].to_s == '日本'
      (date^ When.era(:area=>'日本')).each do |list|
        return list[0] if list[0]
      end
      nil
    end
  end

  #
  # 太陽暦の暦注・祝祭日
  #
  class JapaneseSolarNote < self

    NotesList = {
      [ 1, 1] => [[1868..1872, '元旦'], [1874..1948, '四方拝'], [1949..2100, '元日']],
      [ 1, 3] => [[1874..1948, '元始祭']],
      [ 1, 5] => [[1874..1948, '新年宴会']],
      [ 1,-2] => [[2000..2100, '成人の日']],
      [ 1,15] => [[1868..1872, '小正月'], [1949..1999, '成人の日']],
      [ 1,29] => [[1873..1873, '神武天皇即位日']],
      [ 1,30] => [[1874..1912, '孝明天皇祭']],
      [ 2,11] => [[1874..1948, '紀元節'], [1967..2100, '建国記念の日']],
      [ 3, 3] => [[1868..1872, '弥生節句']],
      [ 3, 0] => [[1879..1948, '春季皇霊祭'], [1949..2100, '春分の日']],
      [ 4, 3] => [[1874..1948, '神武天皇祭']],
      [ 4,29] => [[1927..1948, '天長節'], [1949..1988, '天皇誕生日'], [1989..2006, 'みどりの日'], [2007..2100, '昭和の日']],
      [ 5, 3] => [[1949..2100, '憲法記念日']],
      [ 5, 4] => [[2007..2100, 'みどりの日']],
      [ 5, 5] => [[1868..1872, '端午節句'], [1949..2100, 'こどもの日']],
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
      [11,23] => [[1873..1947, '新嘗祭'], [1948..2100, '勤労感謝の日']],
      [12,23] => [[1989..2100, '天皇誕生日']],
      [12,25] => [[1927..1947, '大正天皇祭']]
    }

    class << self

      # 日の暦注 - 祝祭日の計算
      # @private
      def _day_notes(notes, dates, conditions={})
        # 明治維新以降のみ扱う
        year = dates.o_date.most_significant_coordinate
        return notes unless year >= 1868

        # 春分の日と秋分の日を祝祭日に加える
        long = {3=>0, 9=>180}[dates.o_date.cal_date[1]] if year >= 1878
        if long
          date = When.when?(dates.o_date.to_cal_date.to_s,
                           {:clock=>When.Clock(dates.s_date.frame.timezone[0]*86400)})
          term = dates.s_terms.term(date.floor(When::MONTH,
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

      # 三宝吉・神吉・雑事吉
      notes['神吉'] = notes['雑事吉'] = notes['三宝吉'] = nil   if notes['没'  ] || notes['滅'  ]
      notes['神吉'] = notes['雑事吉']                   = nil   if notes['日食'] || notes['月食'] || notes['往亡']
      notes['三宝吉'] = nil if !notes['甘露'] && (notes['羅刹'] || notes['日食'] || notes['月食'])
      notes['三宝吉'] = notes['甘露'] ? '三宝吉' : nil if /\+/ =~ notes['三宝吉'].to_s
      notes['三宝吉'] = '三吉' if notes['三宝吉'] && dates.year >= 1185 # 鎌倉以降

      # 除手足甲 & 道虚
      y,m0,d0 = dates.m_date.cal_date
      notes['道虚']   = '道虚' if d0 % 6 == 0
      if (d0 == 29)
        m1 = (dates.m_date + When.Duration('P1D')).cal_date[1]
        unless m0 == m1
         # 晦日
         notes['除手足甲'] = '除手足甲' unless notes['没'] || notes['滅'] || notes['凶会']
         notes['道虚']     = '道虚'
         misoka = true if m % 6 == 0  # 『現代こよみ読み解き事典』 for 不成就日
        end
      end

      # 仮名暦
      notes['赤舌'  ] ||= d0 == (m * 5 - 3) % 6 + 1 ? '赤舌' : nil
      notes['赤口'  ] ||= d0 == (m * 7 - 4) % 8 + 1 ? '赤口' : nil
      notes['不成就'] ||= d0 % 8 == [6,3,2,1,4,5][m % 6] || misoka ? '不成就' : nil
      notes['六曜'     ] ||= Rokuyo[(m + d0) % 6] if dates.year >= 1873 # 明治改暦以降
      notes
    end
  end

  #
  # 月の位相による暦注
  #
  class LunarPhases < LuniSolarPositions

    Phases = {7.0=>'上弦', 8.0=>'上弦', 15.0=>'望', 22.0=>'下弦', 23.0=>'下弦'}

    # 日の暦注
    # @private
    def self._day_notes(notes, dates, conditions={})
      return notes unless dates.year < 1685
      date = When.when?(dates.o_date.to_cal_date.to_s,
                        {:clock=>When.Clock(dates.l_date.frame.timezone[0]*86400)})
      phase, metsu = dates.l_phases.position(date)
      phase = Phases[phase]

      # 滅
      notes['滅'] = '滅' if metsu == 2

      # 月相
      notes['月相'] ||=
        /弦/ !~ phase ? phase : dates.l_phases.position(date, 0.5)[0] % 15 == 8.0 ? phase : nil

      # 月食
      notes['月食']        = nil # 計算できないので、偽としておく
      notes
    end
  end

  #
  # 太陽黄経による暦注
  #
  class SolarTerms < LuniSolarPositions

    Notes12 = %w(正月 二月 三月 四月 五月 六月 七月 八月 九月 十月 十一月 十二月)

    Notes60_A = [
      #  +0      
      '侯小過外', # 315 : 正月
      '侯需外',   # 345 : 二月
      '侯豫外',   #  15 : 三月
      '侯旅外',   #  45 : 四月
      '侯大有外', #  75 : 五月
      '侯鼎外',   # 105 : 六月
      '侯常外',   # 135 : 七月
      '侯巽外',   # 165 : 八月
      '侯帰妹外', # 195 : 九月
      '侯良外',   # 225 : 十月
      '侯未済外', # 255 : 十一月
      '侯屯外'    # 285 : 十二月
    ]

    Notes60_B = [
      #  +3          +9       +15       +21       +27
      '大夫蒙',   '卿益',   '公漸',   '辟泰',   '侯需内',   # 315 : 正月
      '大夫随',   '卿晋',   '公解',   '辟大壮', '侯豫内',   # 345 : 二月
      '大夫訟',   '卿蠱',   '公革',   '辟夬',   '侯旅内',   #  15 : 三月
      '大夫師',   '卿比',   '公小畜', '辟乾',   '侯大有内', #  45 : 四月
      '大夫家人', '卿井',   '公咸',   '辟女后', '侯鼎内',   #  75 : 五月
      '大夫豊',   '卿渙',   '公履',   '辟遁',   '侯常内',   # 105 : 六月
      '大夫節',   '卿同人', '公損',   '辟否',   '侯巽内',   # 135 : 七月
      '大夫萃',   '卿大畜', '公賁',   '辟観',   '侯帰妹内', # 165 : 八月
      '大夫無妄', '卿明夷', '公因',   '辟剥',   '侯良内',   # 195 : 九月
      '大夫既済', '卿噬嗑', '公大過', '辟坤',   '侯未済内', # 225 : 十月
      '大不蹇',   '卿頤',   '公中孚', '辟復',   '侯屯内',   # 255 : 十一月
      '大夫謙',   '卿睽',   '公升',   '辟臨',   '侯小過内'  # 285 : 十二月
    ]

    Notes72 = [
      # 宣明暦(中国)       宣明暦            貞享暦   宝暦暦・寛政暦 略本暦
      # 315 : 正月
       %w(東風解凍          東風解凍          東風解凍     東風解凍   東風解凍),
       %w(蟄始振            蟄虫始振          梅花乃芳     黄鶯睍睆   黄鶯睍睆),
       %w(魚上氷            魚上氷            魚上氷       魚上氷     魚上氷),
       %w(獺祭魚            獺祭魚            土脈潤起     土脈潤起   土脉潤起),
       %w(鴻雁来            鴻雁来            霞彩碧空     霞始靆     霞始靆),
       %w(草木萌動          草木萌動          草木萌動     草木萌動   草木萌動),

      # 345 : 二月
       %w(桃始華            桃始華            蟄虫啓戸     蟄虫啓戸   蟄虫啓戸),
       %w(倉庚鳴            倉庚鳴            寒雨間熟     桃始笑     桃始笑),
       %w(鷹化為鳩          鷹化為鳩          菜虫化蝶     菜虫化蝶   菜虫化蝶),
       %w(玄鳥至            玄鳥至            雀始巣       雀始巣     雀始巣),
       %w(雷乃発声          雷乃発声          雷乃発声     桜始開     桜始開),
       %w(始電              始電              桜始開桃始笑 雷乃発声   雷乃発声),

      #  15 : 三月
       %w(桐始華            桐始華            玄鳥至       玄鳥至     玄鳥至),
       %w(田鼠化為鴑        田鼠化為鴑        鴻雁北       鴻雁北     鴻雁北),
       %w(虹始見            虹始見            虹始見       虹始見     虹始見),
       %w(萍始生            萍始生            葭始生       葭始生     葭始生),
       %w(鳴鳩払其羽        鳴鳩払其羽        牡丹華       霜止出苗   霜止出苗),
       %w(戴勝降桑          戴勝降桑          霜止出苗     牡丹華     牡丹華),

      #  45 : 四月
       %w(螻蟈鳴            螻蟈鳴            鵑始鳴       鼃始鳴     鼃始鳴),
       %w(蚯蚓出            蚯蚓出            蚯蚓出       蚯蚓出     蚯蚓出),
       %w(王瓜生            王瓜生            竹笋生       竹笋生     竹笋生),
       %w(苦菜秀            苦菜秀            蚕起食桑     蚕起食桑   蚕起食桑),
       %w(靡草死            靡草死            紅花栄       紅花栄     紅花栄),
       %w(小暑至            小暑至            麦秋至       麦秋至     麦秋至),

      #  75 : 五月
       %w(蟷螂生            蟷螂生            螳螂生       螳螂生     螳螂生),
       %w(鵙始鳴            鵙始鳴            腐草為螢     腐草為螢   腐草為螢),
       %w(反舌無声          反舌無声          梅始黄       梅子黄     梅子黄),
       %w(鹿角解            鹿角解            乃東枯       乃東枯     乃東枯),
       %w(蝉始鳴            蝉始鳴            分龍雨       菖蒲華     菖蒲華),
       %w(半夏生            半夏生            半夏生       半夏生     半夏生),

      # 105 : 六月
       %w(温風至            温風至            温風至       温風至     温風至),
       %w(蟋蟀居壁          蟋蟀居壁          蓮始華       蓮始華     蓮始開),
       %w(鷹乃学習          鷹乃学習          鷹乃学習     鷹乃学習   鷹乃学習),
       %w(腐草為螢          腐草為螢          桐始結花     桐始結花   桐始結花),
       %w(土潤溽暑          土潤溽暑          土潤溽暑     土潤溽暑   土潤溽暑),
       %w(大雨時行          大雨時行          大雨時行     大雨時行   大雨時行),

      # 135 : 七月
       %w(涼風至            涼風至            涼風至       涼風至     涼風至),
       %w(白露降            白露降            山沢浮雲     寒蝉鳴     寒蝉鳴),
       %w(寒蝉鳴            寒蝉鳴            霧色已成     蒙霧升降   蒙霧升降),
       %w(鷹乃祭鳥          鷹乃祭鳥          寒蝉鳴       綿柎開     綿柎開),
       %w(天地始粛          天地始粛          天地始粛     天地始粛   天地始粛),
       %w(禾乃登            禾乃登            禾乃登       禾乃登     禾乃登),

      # 165 : 八月
       %w(鴻雁来            鴻雁来            草露白       草露白     草露白),
       %w(玄鳥帰            玄鳥帰            鶺鴒鳴       鶺鴒鳴     鶺鴒鳴),
       %w(群鳥養羞          群鳥養羞          玄鳥去       玄鳥去     玄鳥去),
       %w(雷乃収声          雷乃収声          鴻雁来       雷乃収声   雷乃収声),
       %w(蟄虫坏戸          蟄虫坏戸          蟄虫坏戸     蟄虫坏戸   蟄虫坏戸),
       %w(水始涸            水始涸            水始涸       水始涸     水始涸),

      # 195 : 九月
       %w(鴻雁来賓          鴻雁来賓          棗栗零       鴻雁来     鴻雁来),
       %w(雀入大水為蛤      雀入大水為蛤      蟋蟀在戸     菊花開     菊花開),
       %w(菊有黄花          菊有黄花          菊花開       蟋蟀在戸   蟋蟀在戸),
       %w(豺乃祭獣          豺祭獣            霜始降       霜始降     霜始降),
       %w(草木黄落          草木黄落          蔦楓紅葉     霎時施     霎時施),
       %w(蟄虫咸俯          蟄虫咸俯          鶯雛鳴       楓蔦黄     楓蔦黄),

      # 225 : 十月
       %w(水始氷            水始氷            山茶始開     山茶始開   山茶始開),
       %w(地始凍            地始凍            地始凍       地始凍     地始凍),
       %w(野鶏入大水為蜃    野鶏入大水為蜃    霎乃降       金盞香     金盞香),
       %w(虹蔵不見          虹蔵不見          虹蔵不見     虹蔵不見   虹蔵不見),
       %w(天気上騰地気下降  天気上騰地気下降  樹葉咸落     朔風払葉   朔風払葉),
       %w(閉塞而成冬        閉塞成冬          橘始黄       橘始黄     橘始黄),

      # 255 : 十一月
       %w(鶡鳥不鳴          鶡鳥不鳴          閉塞成冬     閉塞成冬   閉塞成冬),
       %w(虎始交            武始交            熊蟄穴       熊蟄穴     熊蟄穴),
       %w(茘挺生            茘挺生            水仙開       鱖魚群     鱖魚群),
       %w(蚯蚓結            蚯蚓結            乃東生       乃東生     乃東生),
       %w(麋角解            麋角解            麋角解       麋角解     麋角解),
       %w(水泉動            水泉動            雪下出麦     雪下出麦   雪下出麦),

      # 285 : 十二月
       %w(雁北嚮            雁北嚮            芹乃栄       芹乃栄     芹乃栄),
       %w(鵲始巣            鵲始巣            風気乃行     水泉動     水泉動),
       %w(野鶏始鴝          野鶏始鴝          雉始雊       雉始雊     雉始雊),
       %w(鶏始乳            鶏始乳            款冬華       款冬華     款冬華),
       %w(鷙鳥厲疾          鷙鳥厲疾          水沢腹堅     水沢腹堅   水沢腹堅),
       %w(水沢腹堅          水沢腹堅          鶏始乳       鶏始乳     鶏始乳)
    ]

    # 日の暦注
    # @private
    def self._day_notes(notes, dates, conditions={})
      date = When.when?(dates.o_date.to_cal_date.to_s,
                       {:clock=>When.Clock(dates.s_date.frame.timezone[0]*86400)})
      longitude, motsu = dates.s_terms.position(date)

      # 三伏 - 庚
      #
      # 初 : 夏至から 20..29
      # 仲 : 夏至から 30..39
      # 後 : 立秋から  0..9 
      if !notes['三伏'] && notes['干'].remainder == 6 # 庚
        if 109 <= longitude && longitude <= 129      # 夏至から
          term = dates.s_terms.term(date, [-270,360])
          diff = dates.s_date.to_i - term.to_i
          notes['三伏'] = '初伏' if 20 <= diff && diff <= 29
          notes['三伏'] = '中伏' if 30 <= diff && diff <= 39
        elsif longitude == 135                     # 立秋
          notes['三伏'] = '末伏'
        elsif 136 <= longitude && longitude <= 144 # 立秋から
          term = dates.s_terms.term(date, [-225,360])
          diff = dates.s_date.to_i - term.to_i
          notes['三伏'] = '末伏' if 0 < diff && diff <= 9
        end
      end

      # 社 - 戊
      #
      # 春秋分から -5..4
      if !notes['社'] && notes['干'].remainder == 4 # 戊
        if (longitude + 5) % 180 < 10 # 春秋分の近傍
          term = dates.s_terms.term(date - When.Duration('P6D'), [0,180])
          diff = dates.s_date.to_i - term.to_i
          notes['社'] = '社' if -5 <= diff && diff <= 4
        end
      end

      # 臘 - 辰
      #
      # 大寒から -6..5
      if !notes['臘'] && notes['支'].remainder == 4 # 辰
        if (longitude - 339) % 360 < 12 # 大寒の近傍
          term = dates.s_terms.term(date - When.Duration('P7D'), [345,360])
          diff = dates.s_date.to_i - term.to_i
          notes['臘'] = '臘' if -6 <= diff && diff <= 5
        end
      end

      # 入梅 - 壬
      #
      # 芒種から 0..11
      if !notes['入梅'] && notes['干'].remainder == 8 # 壬
        if (longitude - 120) % 360 < 10 # 芒種の近傍
          term = dates.s_terms.term(date - When.Duration('P1D'), [120,360])
          diff = dates.s_date.to_i - term.to_i
          notes['入梅'] = '入梅' if 0 <= diff && diff <= 11
        end
      end

      # 土用事
      unless notes['土用事']
        _longitude, _motsu = dates.doyo ? dates.s_terms.position(date, -dates.doyo) : [longitude, motsu]
        if _motsu != 0 && _longitude % 90 == 27
          notes['土用事'] =
            (dates.year <  697) ? '土用'   : # 元嘉暦以前
            (dates.year <  764) ? '土王'   : # 麟徳暦
            (dates.year < 1685) ? '土用事' : # 大衍暦～宣明暦
                                  '土用入'   # 貞享暦以降
        end
      end

      # 没
      if motsu == 0
        notes['没'] = '没' if dates.year < 1685
        return notes
      end

      # 伏龍
      notes['伏龍']     ||= {
        315 => '庭内去堂',  15 => '門内百日', 115 => '東垣六十日',
        175 => '四隅百日', 275 => '竈内四十日'
      }[longitude]

      # 廿四節気
      div, mod = longitude.divmod(15)
      if mod == 0
        notes['廿四節気'] = (div - 21) % 24
        div, mod = notes['廿四節気'].divmod(2)
        notes['節中']   ||= Notes12[div] + %w(節 中)[mod]
      end

      # 六十卦
      div, mod = longitude.divmod(30)
      notes['六十卦']   ||= mod == 15 ? Notes60_A[(div - 10) % 12] : nil
      div, mod = longitude.divmod(6)
      notes['六十卦']   ||= mod == 0  ? Notes60_B[(div - 53) % 60] : nil

      # 七十二候
      div, mod = longitude.divmod(5)
      notes['七十二候'] ||= mod == 0  ? Notes72[(div - 63) % 72][dates.index_s]  : nil

      # 彼岸
      notes['彼岸']     ||= longitude % 180 == 2 ? '彼岸'  : nil

      # 往亡
      month    = dates.s_date.cal_date[1] - 1
      div, mod = month.divmod(3)
      notes['往亡']     ||= ((div+7)*(mod+1) + month * 30 + 314 - longitude) % 360 == 0 ? '往亡'  : nil

      # 日食
      notes['日食']        = nil # 計算できないので、偽としておく
      notes
    end
  end
end
