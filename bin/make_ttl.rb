# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in this archive.
=end

Encoding.default_external = 'UTF-8'
Encoding.default_internal = 'UTF-8'

#require 'linkeddata' # gem install linkeddata
require 'json/ld'     # gem install json-ld
require 'rdf/turtle'  # gem install rdf-turtle
require 'when_exe'
include When

config = JSON.parse(File.read(ARGV[0] || 'make_ttl.rb.config'))

PREFIXES = When::Parts::Resource.namespace_prefixes(*config['resource'])
CONTEXT  = When::Parts::Resource.prefixs_to_context(PREFIXES)

File.open(config['file'], 'w') do |file|
  CONTEXT.each_pair do |key, value|
    file.puts "@prefix #{key}: <#{value}> ."
  end
  (when?(config['begin'])..when?(config['end'])).each do |date|
    graph = RDF::Graph.new <<
      JSON::LD::API.toRdf(date.rdf_graph(
        {'@context'=>CONTEXT, :prefixes=>PREFIXES, :included=>true, :include=>true}))
    graph.dump(:ttl, :prefixes=>CONTEXT).each_line do |line|
      file.puts line unless line =~ /^@/
    end
    STDERR.puts '%4d - %s' % [date[YEAR], Time.now.to_s[/\d+:\d+:\d+/]]
  end
end

