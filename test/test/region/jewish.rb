# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2014 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module Test

  class Jewish < Test::Unit::TestCase
    def test__jewish
      date = When.when? 'HY5700.1.1'
      [["HY5700.01.01", 2429521],
       ["HY5700.02.01", 2429551],
       ["HY5700.03.01", 2429581],
       ["HY5700.04.01", 2429611],
       ["HY5700.05.01", 2429640],
       ["HY5700.06*01", 2429670],
       ["HY5700.06=01", 2429700],
       ["HY5700.07.01", 2429729],
       ["HY5700.08.01", 2429759],
       ["HY5700.09.01", 2429788],
       ["HY5700.10.01", 2429818],
       ["HY5700.11.01", 2429847],
       ["HY5700.12.01", 2429877]].each do |sample|
        assert_equal(sample, [date.to_s, date.to_i])
        date += When.Duration('P1M')
      end

      date = When.when? 'HY5773.1.1'
      [["HY5773.01.01", 2456188],
       ["HY5774.01.01", 2456541],
       ["HY5775.01.01", 2456926],
       ["HY5776.01.01", 2457280],
       ["HY5777.01.01", 2457665],
       ["HY5778.01.01", 2458018],
       ["HY5779.01.01", 2458372],
       ["HY5780.01.01", 2458757],
       ["HY5781.01.01", 2459112],
       ["HY5782.01.01", 2459465],
       ["HY5783.01.01", 2459849],
       ["HY5784.01.01", 2460204],
       ["HY5785.01.01", 2460587],
       ["HY5786.01.01", 2460942],
       ["HY5787.01.01", 2461296],
       ["HY5788.01.01", 2461681],
       ["HY5789.01.01", 2462036],
       ["HY5790.01.01", 2462390],
       ["HY5791.01.01", 2462773],
       ["HY5792.01.01", 2463128]].each do |sample|
        assert_equal(sample, [date.to_s, date.to_i])
        date += When.Duration('P1Y')
      end

      assert_equal("BCE3761(-3760).10.07",
                   (When.era('BCE')[0] ^ When.Calendar('Jewish').domain[''].first).to_s)

    end
  end
end
