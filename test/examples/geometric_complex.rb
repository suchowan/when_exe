# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2013 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

require 'pp'
require 'when_exe'
include When

range_null = Parts::GeometricComplex.new()
range_1_1  = Parts::GeometricComplex.new(1)
range_1_4  = Parts::GeometricComplex.new(1,4)
range_2_2  = Parts::GeometricComplex.new(2)
range_2_3  = Parts::GeometricComplex.new(2,3)
range_2_5  = Parts::GeometricComplex.new(2,5)
range_4_4  = Parts::GeometricComplex.new(4)
pp range_1_4
pp range_2_3
range_1_4.each {|x| pp x}
pp range_4_4
pp range_1_4 | range_2_3
pp range_1_4.include?(range_2_2)
pp range_1_4.include?(range_2_3)
range_1_5 = range_1_4 | range_2_5
pp range_1_5
pp range_1_4.include?(range_2_5)
pp range_1_4 | range_4_4
pp range_1_4.include?(range_4_4)
reverse_all  = Parts::GeometricComplex.new(true)
reverse_1_4  = Parts::GeometricComplex.new(1,4, true)
reverse_2_3  = Parts::GeometricComplex.new(2,3, true)
reverse_2_5  = Parts::GeometricComplex.new(2,5, true)
pp reverse_all
pp reverse_1_4
pp reverse_2_3
pp reverse_2_3 | range_2_3
pp reverse_1_4 | range_2_5

