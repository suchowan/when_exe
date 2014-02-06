# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2012 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  class BasicTypes::M17n

    ThaiTerms = [self, [
      "namespace:[en=http://en.wikipedia.org/wiki/, ja=http://ja.wikipedia.org/wiki/]",
      "locale:[=en:, ja=ja:, alias]",
      "names:[ThaiTerms]",
      "[ThaiLuniSolar=en:Thai_lunar_calendar, タイ太陰太陽暦=ja:%%<チャントラカティ>]"
    ]]
  end

  module CalendarTypes

    #
    # The Calendar of Thai people in China
    #
    class ThaiC < TableBased

      NormalIDs    =  '1,1<,2,2<,3,3<,4,4<,5,5<,6,6<,7,7<,8,8<,9,9<,10,10<,11,11<,12,12<'
      LeapIDs      =  '1,1<,2,2<,3,3<,4,4<,5,5<,6,6<,7,7<,8,8<,9&,9*,9,9<,10,10<,11,11<,12,12<'

      # ソンクラーン - 太陽の白羊宮入り
      #
      # @param [Integer] y 年
      #
      # @return [Integer] ソンクラーンのユリウス日
      #
      def songkran_(y)
        e = _eph(y)
        return @origin_of_LSC - 1 + e['H'][0]
      end

      private

      # ThaiC+オブジェクトの性質定義を初期設定します。
      #
      # オブジェクトの正規化
      # @private
      def _normalize(args=[], options={})
        @label ||= When.Resource('_m:ThaiTerms::ThaiLuniSolar')

        Rational
        @mean_month    ||=       29 + Rational(  373,    703)
        @mean_year     ||=      365 + Rational(25876, 100000)
        @epoch_in_CE   ||=      638
        @origin_of_MSC ||=        0 # 638 + 543
        @origin_of_LSC ||=  1954168
        @origin_of_MSC   =  @origin_of_MSC.to_i
        @origin_of_LSC   =  @origin_of_LSC.to_i

        intercalary_month = When.Resource('_m:IndianTerms::IntercalaryMonth::*')
        @indices ||= [
          Coordinates::Index.new({:branch=>{0   =>  intercalary_month[0],
                                            0.5 =>  intercalary_month[1],
                                           -1.5 =>  intercalary_month[2],
                                           -1   =>  intercalary_month[3]},
                                  :trunk =>When.Resource('_m:IndianTerms::LunarMonth::*')}),
          Coordinates::DefaultDayIndex
        ]
        @rule_table  ||=  {
          354 => {'Length'=>[15,15,15,14]*6,                            'IDs' => NormalIDs},
          355 => {'Length'=>[15,15,15,14]*3 + [15]*4 + [15,15,15,14]*2, 'IDs' => NormalIDs},
          356 => {'Length'=>[15,15,15,14]*3 + [15]*7 + [14] + [15]*4,   'IDs' => NormalIDs},
          383 => {'Length'=>[15,14,15,15]*6 + [15,14],                  'IDs' => LeapIDs},
          384 => {'Length'=>[15,15,15,14]*4 + [15]*2 + [15,15,15,14]*2, 'IDs' => LeapIDs}
        }

        super
      end

      # 年初の通日
      #
      # @param [Array<Numeric>] date ( 年 )
      #
      # @return [Integer] 年初の通日
      #
      def _sdn_(date)
        y  = +date[0]
        e0 = _thai(y,  0)[0]
        e1 = _thai(y+1,0)[0]
        e0['T'] -= 1 if (e1['T']-e0['T'] == 353)
        return @origin_of_LSC - 1 + e0['T'] - 30*3 - 29*2
      end

      # y で指定した年の暦定数を返します。
      #
      # @param [Integer] y 年
      #
      # @return [Hash]
      #
      def _eph(y) # C
        h  = (y+4).divmod(9)[0]                   # y
        h  = (y-h).divmod(3)[0]                   # z
        h  = (y+1-h).divmod(2)[0]                 # r (2 => h?)
        h  = (36525876*y+149049-h).divmod(100000) # s
        a  = (h[0]*11+633-((h[0]+7368).divmod(8878))[0]).divmod(692)
        m  = (h[0]+a[0]+0).divmod(30)
        return {'H'=>h, 'A'=>a, 'M'=>m}
      end

      #  y で指定した年の平閏、8月の大小を判定します。
      #
      # @param [Integer] y   年
      # @param [Integer] dir 前後の閏状態を表すコード
      #
      # @return [Array<Hash, String>]
      #
      def _thai(y,dir)
          # 諸元の計算 
        e = _eph(y)
        k = 800*125 - e['H'][1]
        t = e['M'][1]

          # Jyaistha 大の判定 
        b = ((e['A'][1]<126) && (k<=207*125)) || ((e['A'][1]<137) && (k> 207*125))

          # 閏年の判定
        c = ((t<6) || (t>24))
        c = true  if ((t==24) && (_thai(y+1,+1)[1]< 'C'))
        c = false if ((t==25) && (_thai(y+1,+1)[1]>='C'))

          # Caitra 月 0 日 
        e['T'] = e['H'][0] - t
        e['T'] -= 1  if (t==0)
        e['T'] -= 29 if (c && (t<=6))
        e['b'] = b
        e['c'] = c
        e['t'] = t
        return e,' '
      end
    end

    #
    # The Calendar of central Thailand
    #
    class ThaiB < ThaiC

      YEAR_TYPE = {'A'=>354, 'B'=>355, 'C'=>384, 'D'=>384, 'E'=>384}

      NormalIDs    =  '1,1<,2,2<,3,3<,4,4<,5,5<,6,6<,7,7<,8,8<,9,9<,10,10<,11,11<,12,12<'
      LeapIDs      =  '1,1<,2,2<,3,3<,4,4<,5,5<,6,6<,7,7<,8&,8*,8,8<,9,9<,10,10<,11,11<,12,12<'

      private

      # オブジェクトの正規化
      #
      def _normalize(args=[], options={})
        @rule_table ||= {
          354 => {'Length'=>[15,14,15,15]*6,    'IDs' => NormalIDs},
          355 => {'Length'=>[15,14,15,15]*3 + [15]*4 + [15,14,15,15]*2, 'IDs' => NormalIDs},
          384 => {'Length'=>[15,14,15,15]*4 + [15]*2 + [15,14,15,15]*2, 'IDs' => LeapIDs  }
        }

        super
      end

      # 年初の通日
      #
      # @param [Array<Numeric>] date ( 年 )
      #
      # @return [Integer] 年初の通日
      #
      def _sdn_(date)
        y  = +date[0]
        e0,dir0  = _thai(y,  0)
        e1,dir1  = _thai(y+1,0)
        e0['T'] -= 1 if (e1['T'] - e0['T'] < YEAR_TYPE[dir0])
        return @origin_of_LSC + e0['T'] - 29*2 - 30*2
      end

      # y で指定した年の暦定数を返します。
      #
      # @param [Integer] y 年
      #
      # @return [Hash]
      #
      def _eph(y) # C
        h = (y*292207+373+800*1).divmod(800)
      # u = (h[0]+2611).divmod(3232)
        a = (h[0]*11+650).divmod(692)
        m = (h[0]+a[0]+0).divmod(30)
        h[1] *= 125
        return {'H'=>h, 'A'=>a, 'M'=>m}
      end

      #  y で指定した年の平閏、8月の大小を判定します。
      #
      # @param [Integer] y   年
      # @param [Integer] dir 前後の閏状態を表すコード
      #
      # @return [Array<Hash, String>]
      #
      def _thai(y,dir)
        # 諸元の計算
        e,w = super(y,dir)

        # カレンダーのタイプ 
        if (e['c'])
          if (!e['b'])
            return  e,'C'   # 普通の閏年   
          elsif ((0<e['t']) && (e['t']<6))
            return  e,'D'   # 前年大の閏年 
          else
            return  e,'E'   # 翌年大の閏年 
          end
        else
          if (e['b'])
            return  e,'B'   # 大の平年 
          elsif ((dir != -1) && (_thai(y+1,+1)[1]=='D'))
            return  e,'B'   # 大の平年 
          elsif ((dir != +1) && (_thai(y-1,-1)[1]=='E'))
            return  e,'B'   # 大の平年 
          else
            return  e,'A'   # 小の平年 
          end
        end
      end
    end
  end
end