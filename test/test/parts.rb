# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2012 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module When::Parts
  class GeometricComplex
    def ==(other)
      return false unless other.kind_of?(self.class)
      return self.node == other.node && self.reverse == other.reverse
    end
  end
end

module Test::Parts

  class MethodCash < Test::Unit::TestCase
    class A
      include When::Parts::MethodCash

      def func_0_(x)
        #pp ['--0--',x]
        return x**2
      end

      def func_0_setup(k, x)
        #pp ['-0-setup-',k,x]
        @_m_cash_["func_0"][k] ||= x**2
      end

      def func_1_(x)
        #pp ['--1--',x]
        return x**4
      end

      def _from_to_to_(x,y)
        #pp ['--2--',x, y]
        return 10 * x + y
      end

      def _to_to_from_(x)
        #pp ['--3--',x]
        return x.divmod(10)
      end

      def cash
        @_m_cash_
      end
    end

    class B < A
      def initialize
        @_m_cash_lock_ = Mutex.new
      end
    end

    def test__method_cash
      [A, B].each do |klass|
        c = klass.new
        assert_equal(4, c.func_0(2))
        assert_equal(4, c.func_0(2))
        assert_equal({"func_0"=>{2=>4}}, c.cash)
        assert_equal(16, c.func_1(2))
        assert_equal(16, c.func_1(2))
        assert_equal({"func_1"=>{2=>16}, "func_0"=>{2=>4}}, c.cash)
        assert_equal(34, c._from_to_to(3,4))
        assert_equal([3, 4], c._to_to_from(34))
        assert_equal([3, 3], c._to_to_from(33))
        assert_equal({"func_1"=>{2=>16}, "func_0"=>{2=>4},
                      "_from_to_to"=>{[3, 3]=>[33], [3, 4]=>34}, "_to_to_from"=>{33=>[3, 3], 34=>[3, 4]}}, c.cash)
      end
    end
  end

  class SnapShot < Test::Unit::TestCase
    def test_nothing
    end
  end

  class Locale < Test::Unit::TestCase
    Term1 = When.m17n('Tokyo', 'zip')
    Term2 = When.m17n(<<LABEL, <<NS, <<LOCALE)
[
Getsuyou
Monday
]
LABEL
ISO, jwiki=http://ja.wikipedia.org/wiki/, ewiki=http://en.wikipedia.org/wiki/
NS
=jwiki:, en=ewiki:
LOCALE
    Term3 = When.Resource('_co:CommonResidue::Week::Monday::Monday')

    def test__locale
      assert_equal("Tokyo", Term1.translate('en_US'))
      assert_equal("Monday", Term2.translate('en_US'))
      assert_equal("Monday", Term3.translate('en_US'))
    end

    def test__reference
      assert_equal(nil, Term1.reference('ja_JP'))
      assert_equal(nil, Term1.reference('en_US'))
      assert_equal("http://ja.wikipedia.org/wiki/Getsuyou", Term2.reference('ja_JP'))
      assert_equal("http://en.wikipedia.org/wiki/Monday", Term2.reference('en_US'))
      assert_equal("http://ja.wikipedia.org/wiki/%E6%9C%88%E6%9B%9C%E6%97%A5", Term3.reference('ja_JP'))
    end

    def test__labels
      assert_equal({""=>"Tokyo"}, Term1.names)
      assert_equal({""=>"Getsuyou", "en"=>"Monday"}, Term2.names)
    # assert_equal({""=>"Monday", "ja"=>"月曜日"}, Term3.names)
    end

    def test__link
      assert_equal({},Term1.link)
      assert_equal({""=>"http://ja.wikipedia.org/wiki/Getsuyou",
                   "en"=>"http://en.wikipedia.org/wiki/Monday"}, Term2.link)
      assert_equal({"ja"=>"http://ja.wikipedia.org/wiki/%E6%9C%88%E6%9B%9C%E6%97%A5",
                    ""=>"http://en.wikipedia.org/wiki/Monday"}, Term3.link)
    end

    def test__prefix
      date = When.when?('0594-09=12^Japanese')
      assert_equal(["閏長月", String], [date.name('Month').label, date.name('Month').label.class])
      assert_equal(["閏長月", String], [date.name('Month').to_s,  date.name('Month').to_s.class])
      assert_equal("閏長月", date.name('Month').translate('日本語'))
      assert_equal("Intercalary 9th Month", date.name('Month').translate('en_US'))
    end
  end

  class IRI < Test::Unit::TestCase
    def test_nothing
    end
  end

  class Enumerator < Test::Unit::TestCase

    def test_nothing
    end

    class Array < Test::Unit::TestCase
      def test_nothing
      end
    end

    class Integrated < Test::Unit::TestCase
      def test_nothing
      end
    end
  end

  class GeometricComplex < Test::Unit::TestCase

    def test__include

      sample  = [false, false, false, false, false]
      complex = When::Parts::GeometricComplex.new(false)
      assert_equal(nil, complex.exclude_end?)
      (1..5).each do |i|
        assert_equal(sample.shift, complex.include?(i))
      end

      sample  = [true, true, true, true, true]
      complex = When::Parts::GeometricComplex.new(true)
      assert_equal(nil, complex.exclude_end?)
      (1..5).each do |i|
        assert_equal(sample.shift, complex.include?(i))
      end

      sample  = [false, true, true, true, false]
      complex = When::Parts::GeometricComplex.new(2..4)
      assert_equal(false, complex.exclude_end?)
      (1..5).each do |i|
        assert_equal(sample.shift, complex.include?(i))
      end

      sample  = [false, true, true, false, false]
      complex = When::Parts::GeometricComplex.new(2...4)
      assert_equal(true, complex.exclude_end?)
      (1..5).each do |i|
        assert_equal(sample.shift, complex.include?(i))
      end

      sample  = [true, false, false, false, true]
      complex = -When::Parts::GeometricComplex.new(2..4)
      assert_equal(true, complex.exclude_end?)
      (1..5).each do |i|
        assert_equal(sample.shift, complex.include?(i))
      end

      sample  = [true, false, false, true, true]
      complex = -When::Parts::GeometricComplex.new(2...4)
      assert_equal(false, complex.exclude_end?)
      (1..5).each do |i|
        assert_equal(sample.shift, complex.include?(i))
      end

      period_1_2 = When::Parts::GeometricComplex.new(1..2)
      period_2_3 = When::Parts::GeometricComplex.new(2..3)
      period_3_4 = When::Parts::GeometricComplex.new(3..4)
      period_4_5 = When::Parts::GeometricComplex.new(4..5)
      period_5_6 = When::Parts::GeometricComplex.new(5..6)

      period_2_4 = When::Parts::GeometricComplex.new(2..4)
      period_3_6 = When::Parts::GeometricComplex.new(3..6)
      period_4_6 = When::Parts::GeometricComplex.new(4..6)
      period_1_6 = When::Parts::GeometricComplex.new(1..6)

      [[false,        period_1_2, period_4_6],
       [false,        period_1_2, period_2_4],
       [false,        period_2_4, period_3_6],
       [false,        period_2_3, period_2_4],
       [true,         period_2_4, period_2_3],

       [false,        period_2_4, period_1_6],
       [true,         period_1_6, period_2_4],
       [true,         period_2_4, period_2_4],

       [false,        period_3_6, period_2_4],
       [false,        period_3_4, period_2_4],
       [true,         period_2_4, period_3_4],
       [false,        period_4_5, period_2_4],
       [false,        period_5_6, period_2_4]].each do |sample|
        assert_equal(sample[0], sample[1].include?(sample[2]))
      end

      period_1_2 = When::Parts::GeometricComplex.new(1...2)
      period_2_3 = When::Parts::GeometricComplex.new(2...3)
      period_3_4 = When::Parts::GeometricComplex.new(3...4)
      period_4_5 = When::Parts::GeometricComplex.new(4...5)
      period_5_6 = When::Parts::GeometricComplex.new(5...6)

      period_2_4 = When::Parts::GeometricComplex.new(2...4)
      period_3_6 = When::Parts::GeometricComplex.new(3...6)
      period_4_6 = When::Parts::GeometricComplex.new(4...6)
      period_1_6 = When::Parts::GeometricComplex.new(1...6)

      [[false,        period_1_2, period_4_6],
       [false,        period_1_2, period_2_4],
       [false,        period_2_4, period_3_6],
       [false,        period_2_3, period_2_4],
       [true,         period_2_4, period_2_3],

       [false,        period_2_4, period_1_6],
       [true,         period_1_6, period_2_4],
       [true,         period_2_4, period_2_4],

       [false,        period_3_6, period_2_4],
       [false,        period_3_4, period_2_4],
       [true,         period_2_4, period_3_4],
       [false,        period_4_5, period_2_4],
       [false,        period_5_6, period_2_4]].each do |sample|
        assert_equal(sample[0], sample[1].include?(sample[2]))
      end

      period_1_2 = -When::Parts::GeometricComplex.new(1..2)
      period_2_3 = -When::Parts::GeometricComplex.new(2..3)
      period_3_4 = -When::Parts::GeometricComplex.new(3..4)
      period_4_5 = -When::Parts::GeometricComplex.new(4..5)
      period_5_6 = -When::Parts::GeometricComplex.new(5..6)

      period_2_4 = -When::Parts::GeometricComplex.new(2..4)
      period_3_6 = -When::Parts::GeometricComplex.new(3..6)
      period_4_6 = -When::Parts::GeometricComplex.new(4..6)
      period_1_6 = -When::Parts::GeometricComplex.new(1..6)

      [[false,        period_4_6, period_1_2],
       [false,        period_2_4, period_1_2],
       [false,        period_3_6, period_2_4],
       [false,        period_2_4, period_2_3],
       [true,         period_2_3, period_2_4],

       [false,        period_1_6, period_2_4],
       [true,         period_2_4, period_1_6],
       [true,         period_2_4, period_2_4],

       [false,        period_2_4, period_3_6],
       [false,        period_2_4, period_3_4],
       [true,         period_3_4, period_2_4],
       [false,        period_2_4, period_4_5],
       [false,        period_2_4, period_5_6]].each do |sample|
        assert_equal(sample[0], sample[1].include?(sample[2]))
      end

      period_1_2 = -When::Parts::GeometricComplex.new(1...2)
      period_2_3 = -When::Parts::GeometricComplex.new(2...3)
      period_3_4 = -When::Parts::GeometricComplex.new(3...4)
      period_4_5 = -When::Parts::GeometricComplex.new(4...5)
      period_5_6 = -When::Parts::GeometricComplex.new(5...6)

      period_2_4 = -When::Parts::GeometricComplex.new(2...4)
      period_3_6 = -When::Parts::GeometricComplex.new(3...6)
      period_4_6 = -When::Parts::GeometricComplex.new(4...6)
      period_1_6 = -When::Parts::GeometricComplex.new(1...6)

      [[false,        period_4_6, period_1_2],
       [false,        period_2_4, period_1_2],
       [false,        period_3_6, period_2_4],
       [false,        period_2_4, period_2_3],
       [true,         period_2_3, period_2_4],

       [false,        period_1_6, period_2_4],
       [true,         period_2_4, period_1_6],
       [true,         period_2_4, period_2_4],

       [false,        period_2_4, period_3_6],
       [false,        period_2_4, period_3_4],
       [true,         period_3_4, period_2_4],
       [false,        period_2_4, period_4_5],
       [false,        period_2_4, period_5_6]].each do |sample|
        assert_equal(sample[0], sample[1].include?(sample[2]))
      end
    end

    def test__union

      sample   = [false, true, false, true, true, false]
      complex  = When::Parts::GeometricComplex.new(3..4)
      complex |= 1
      (0..5).each do |i|
        assert_equal(sample.shift, complex.include?(i))
      end

      sample   = [true, false, true, false, false, true]
      complex  = When::Parts::GeometricComplex.new(3..4)
      complex |= 1
      complex  = -complex
      (0..5).each do |i|
        assert_equal(sample.shift, complex.include?(i))
      end

      sample   = [false, true, false, true, false, false]
      complex  = When::Parts::GeometricComplex.new(3...4)
      complex |= 1
      (0..5).each do |i|
        assert_equal(sample.shift, complex.include?(i))
      end

      sample   = [true, false, true, false, true, true]
      complex  = When::Parts::GeometricComplex.new(3...4)
      complex |= 1
      complex  = -complex
      (0..5).each do |i|
        assert_equal(sample.shift, complex.include?(i))
      end

      complex  = When::Parts::GeometricComplex.new(3..5)
      (3..5).each do |i|
        union  = complex | i
        assert_equal(complex, union)
      end

      assert_equal(When::Parts::GeometricComplex.new(3..5),
                   When::Parts::GeometricComplex.new(3...5) | 5)

      null       = When::Parts::GeometricComplex.new(false)
      all        = When::Parts::GeometricComplex.new(true)
      period_1_2 = When::Parts::GeometricComplex.new(1..2)
      period_2_3 = When::Parts::GeometricComplex.new(2..3)
      period_3_4 = When::Parts::GeometricComplex.new(3..4)
      period_4_5 = When::Parts::GeometricComplex.new(4..5)
      period_5_6 = When::Parts::GeometricComplex.new(5..6)

      period_1_4 = When::Parts::GeometricComplex.new(1..4)
      period_2_4 = When::Parts::GeometricComplex.new(2..4)
      period_2_5 = When::Parts::GeometricComplex.new(2..5)
      period_2_6 = When::Parts::GeometricComplex.new(2..6)
      period_3_6 = When::Parts::GeometricComplex.new(3..6)
      period_4_6 = When::Parts::GeometricComplex.new(4..6)
      period_1_6 = When::Parts::GeometricComplex.new(1..6)

      period_1_2_4_6 = When::Parts::GeometricComplex.new([[1,true],[2,true],[4,true],[6,true]])
      period_2_4_5_6 = When::Parts::GeometricComplex.new([[2,true],[4,true],[5,true],[6,true]])

      [[period_1_2_4_6, null,   period_1_2_4_6],
       [period_1_2_4_6, period_1_2_4_6,   null],
       [all,            all,    period_1_2_4_6],
       [all,            period_1_2_4_6,    all],
       [period_1_2_4_6, period_1_2, period_4_6],
       [period_1_4,     period_1_2, period_2_4],
       [period_2_6,     period_2_4, period_3_6],
       [period_2_4,     period_2_3, period_2_4],
       [period_2_4,     period_2_4, period_2_3],

       [period_1_6,     period_2_4, period_1_6],
       [period_1_6,     period_1_6, period_2_4],
       [period_2_4,     period_2_4, period_2_4],

       [period_2_6,     period_3_6, period_2_4],
       [period_2_4,     period_3_4, period_2_4],
       [period_2_4,     period_2_4, period_3_4],
       [period_2_5,     period_4_5, period_2_4],
       [period_2_4_5_6, period_5_6, period_2_4]].each do |sample|
        assert_equal(sample[0], sample[1] | sample[2])
      end

      period_1_2 = When::Parts::GeometricComplex.new(1...2)
      period_2_3 = When::Parts::GeometricComplex.new(2...3)
      period_3_4 = When::Parts::GeometricComplex.new(3...4)
      period_4_5 = When::Parts::GeometricComplex.new(4...5)
      period_5_6 = When::Parts::GeometricComplex.new(5...6)

      period_1_4 = When::Parts::GeometricComplex.new(1...4)
      period_2_4 = When::Parts::GeometricComplex.new(2...4)
      period_2_5 = When::Parts::GeometricComplex.new(2...5)
      period_2_6 = When::Parts::GeometricComplex.new(2...6)
      period_3_6 = When::Parts::GeometricComplex.new(3...6)
      period_4_6 = When::Parts::GeometricComplex.new(4...6)
      period_1_6 = When::Parts::GeometricComplex.new(1...6)

      period_1_2_4_6 = When::Parts::GeometricComplex.new([[1,true],[2,false],[4,true],[6,false]])
      period_2_4_5_6 = When::Parts::GeometricComplex.new([[2,true],[4,false],[5,true],[6,false]])

      [[period_1_2_4_6, null,   period_1_2_4_6],
       [period_1_2_4_6, period_1_2_4_6,   null],
       [all,            all,    period_1_2_4_6],
       [all,            period_1_2_4_6,    all],
       [period_1_2_4_6, period_1_2, period_4_6],
       [period_1_4,     period_1_2, period_2_4],
       [period_2_6,     period_2_4, period_3_6],
       [period_2_4,     period_2_3, period_2_4],
       [period_2_4,     period_2_4, period_2_3],

       [period_1_6,     period_2_4, period_1_6],
       [period_1_6,     period_1_6, period_2_4],
       [period_2_4,     period_2_4, period_2_4],

       [period_2_6,     period_3_6, period_2_4],
       [period_2_4,     period_3_4, period_2_4],
       [period_2_4,     period_2_4, period_3_4],
       [period_2_5,     period_4_5, period_2_4],
       [period_2_4_5_6, period_5_6, period_2_4]].each do |sample|
        assert_equal(sample[0], sample[1] | sample[2])
      end
    end

    def test__include_in_sample
      range_1_4  = When::Parts::GeometricComplex.new(1,4)
      range_2_2  = When::Parts::GeometricComplex.new(2)
      range_2_3  = When::Parts::GeometricComplex.new(2,3)
      range_2_5  = When::Parts::GeometricComplex.new(2,5)
      range_4_4  = When::Parts::GeometricComplex.new(4)
      assert_equal(true, range_1_4.include?(range_2_2))
      assert_equal(true, range_1_4.include?(range_2_3))
      assert_equal(false, range_1_4.include?(range_2_5))
      assert_equal(false, range_1_4.include?(range_4_4))
    end

    def test__union_in_sample
      #range_null = When::Parts::GeometricComplex.new()
      #range_1_1  = When::Parts::GeometricComplex.new(1)
      range_1_4  = When::Parts::GeometricComplex.new(1,4)
      range_2_2  = When::Parts::GeometricComplex.new(2)
      range_2_3  = When::Parts::GeometricComplex.new(2,3)
      range_2_5  = When::Parts::GeometricComplex.new(2,5)
      range_4_4  = When::Parts::GeometricComplex.new(4)
      assert_equal("1...4", range_1_4.to_s)
      assert_equal("2...3", range_2_3.to_s)
      sample = [1, 2, 3]
      range_1_4.each {|x| assert_equal(sample.shift, x)}
      assert_equal("4..4", range_4_4.to_s)
      assert_equal("1...4", (range_1_4 | range_2_3).to_s)
      range_1_5 = range_1_4 | range_2_5
      assert_equal("1...5", range_1_5.to_s)
      assert_equal("1..4", (range_1_4 | range_4_4).to_s)
      reverse_all  = When::Parts::GeometricComplex.new(true)
      reverse_1_4  = When::Parts::GeometricComplex.new(1,4, true)
      reverse_2_3  = When::Parts::GeometricComplex.new(2,3, true)
      reverse_2_5  = When::Parts::GeometricComplex.new(2,5, true)
      assert_equal("..", reverse_all.to_s)
      assert_equal("1..4", reverse_1_4.to_s)
      assert_equal("2..3", reverse_2_3.to_s)
      assert_equal("..", (reverse_2_3 | range_2_3).to_s)
      assert_equal("1..2", (reverse_1_4 | range_2_5).to_s)
    end
  end
end
