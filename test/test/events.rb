# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2015 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

module MiniTest::CalendarTypes

  class DataSet < MiniTest::TestCase
    def test__dataset
      datasets = When.Resource('examples/history-dataset.csv')
      dataset = datasets.dataset('en')
      assert_equal([5],       dataset.index['ts:whatDay'][[false, 1, 2]])
      assert_equal([5, 1],    dataset.edge_included_i('ts:start', When.when?('-Infinity...1256-11-23^^Japanese')))
      assert_equal([5, 1, 2], dataset.edge_included_i('ts:start', When.when?('-Infinity..1256-11-23^^Japanese')))
      assert_equal([1],       dataset.edge_included_i('ts:start', When.when?('1256-11-22...1256-11-23^^Japanese')))
      assert_equal([1, 2],    dataset.edge_included_i('ts:start', When.when?('1256-11-22/23^^Japanese')))
      assert_equal([2],       dataset.edge_included_i('ts:start', When.when?('1256-11-23...1555-10-01^^Japanese')))
      assert_equal([2, 3],    dataset.edge_included_i('ts:start', When.when?('1256-11-23..1555-10-01^^Japanese')))
      assert_equal([2, 3, 4], dataset.edge_included_i('ts:start', When.when?('1256-11-23..+Infinity^^Japanese')))
    end
  end
end

