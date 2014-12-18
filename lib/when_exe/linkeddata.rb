# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  module Parts::Resource
    class << self

      # Linked Data �p namespace URI �� Array �� Hash �𐶐�����
      #
      # @param [Array<When::Parts::Resource or String>] resources namespace �𒊏o���� resource �� Array
      #
      # @return [Hash]
      #
      def namespace_prefixes(*resources)
        base = base_uri.sub(/When\/$/, '')
        resources.inject({
          'xsd'  => ['http://www.w3.org/2001/XMLSchema'],
          'rdf'  => ['http://www.w3.org/1999/02/22-rdf-syntax-ns#'],
          'rdfs' => ['http://www.w3.org/2000/01/rdf-schema#'],
          'owl'  => ['http://www.w3.org/2002/07/owl#'],
          'dc'   => ['http://purl.org/dc/elements/1.1/'],
          'dcq'  => ['http://purl.org/dc/terms/'],
          'dct'  => ['http://purl.org/dc/dcmitype/'],
        # 'date' => [base + 'tp/'],
          'ts'   => [base + 'ts#']
        }) {|namespace, resource|
          resource = When.Resource(resource) if resource.kind_of?(String)
          hash = resource.namespace_prefixes
          hash.each_pair do |key, value|
            namespace[key] = namespace[key] ? (namespace[key] + value).uniq.sort_by {|ns| -ns.length} : value
          end
          namespace
        }
      end

      # URI��Array�̍Ō�̗v�f�� prefix �ɑΉ����� namespace �Ƃ݂Ȃ��� json-ld �� @context �ɓK������`���ɕϊ�����
      #
      # @param [Hash<String=>Array<String>>] prefixes Linked Data �p namespace URI��Array��Hash
      #
      # @return [Hash<String=>String>] prefix �� namespace ��1��1�Ή�
      #
      def prefixs_to_context(prefixes)
         Hash[*(prefixes.keys.map {|key| [key, prefixes[key].last]}.flatten)]
      end

      # json-ld �� @context �ɓK������`���ŋL�q���ꂽ 1��1�Ή����� prefix �� namespace �� Linked Data �p namespace URI��Array��Hash������
      #
      # @param [Hash<String=>String>] prefixes prefix �� namespace ��1��1�Ή�
      #
      # @return [Hash<String=>Array<String>>] Linked Data �p namespace URI��Array��Hash
      #
      def context_to_prefixs(prefixes)
         hash = {}
         prefixes.each_pair do |key, value|
           hash[key] = [value]
         end
         hash
      end
    end

    # Linked Data �p namespace URI �� Array �� Hash �𐶐�����
    #
    # @return [Hash]
    #
    def namespace_prefixes
      prefixes = {}
      child.each do |c|
        next if c.iri =~ / /
        iri = c.child ? c.iri : self.iri
        prefixes[((c.kind_of?(When::BasicTypes::M17n) ? c : c.label) / 'en').split(/ +/).first] = [iri + '::']
      end
      prefixes
    end
  end

  class CalendarNote
     class << self

      # �w��͈̔͂�CalDate�I�u�W�F�N�g�̃O���t�� jsonld ��\������ Hash �𐶐�����
      #
      # @param [Range or Array] dates jsonld ��\������ Hash �𐶐�����CalDate�I�u�W�F�N�g�͈̔�
      # @param [Hash] options �ȉ��̒ʂ�
      # @option options [Boolean] :include ���g���܂ޕ���\������CalDate�I�u�W�F�N�g���O���t�Ɋ܂߂�
      # @option options [Object] @... ���̂܂ܖ߂�l��Hash�ɒǉ�
      # @option options [Symbol] ���̑� {When::TM::CalDate#to_jsonld} ���Q��
      #
      # @return [Hash] jsonld ��\������ Hash
      #
      def rdf_graph(dates, options={})
        jsonld_hash = {'@graph'=>[]}
        sub_options = {}
        options.each_pair do |key, value|
          (/^@/ =~ key ? jsonld_hash : sub_options)[key] = value
        end
        sub_options[:prefixes] ||= When::Parts::Resource.namespace_prefixes if options[:context]
        dates.each do |date|
          register_graph(jsonld_hash['@graph'], date, sub_options)
        end
        if options['@context'] && options[:context]
          sub_options[:prefixes].each_pair do |key, value|
            options['@context'][key] ||= value.last
          end
        end
        jsonld_hash
      end

      private

      # CalDate�I�u�W�F�N�g�� jsonld ���O���t�ɒǉ�����
      #
      def register_graph(list, date, options={})
        date_note = date.to_jsonld_hash(options)
        list << date_note
        if options[:include] && date.precision < When::DAY
          included_date = date.floor(date.precision+1)
          included_opt  = {:included=>date_note['@id']}.update(options)
          while date.include?(included_date) do
            register_graph(list, included_date, included_opt)
            included_date = included_date.succ
          end
        end
      end
    end
  end

  class TM::CalDate

    # ���g�� root �Ƃ���O���t�� jsonld ��\������ Hash �𐶐�����
    #
    # @param [Hash] options {When::CalendarNote.rdf_graph} ���Q��
    #
    # @return [Hash] jsonld ��\������ Hash
    #
    def rdf_graph(options={})
      When::CalendarNote.rdf_graph([self], options)
    end

    # CalDate�I�u�W�F�N�g�� jsonld ��\������ Hash �𐶐�����
    #
    # @param [Hash] options �ȉ��̒ʂ�
    # @option options [Hash] :prefixes Linked Data �p namespace URI �� Array �� Hash ('@context'�݊��ł���)
    # @option options [Boolean] :context true �Ȃ� �\�Ȍ��� namespace �� prefix �ɕϊ�����
    # @option options [String or Boolean] :prev �ЂƂO��CalDate�I�u�W�F�N�g��IRI
    # @option options [String or Boolean] :succ �ЂƂ��CalDate�I�u�W�F�N�g��IRI
    # @option options [String or Boolean] :included ���g���܂ޕ���\��1�ႢCalDate�I�u�W�F�N�g��IRI
    # @option options [Hash] :note ��v�Z�̃I�v�V���� {When::CalendarNote#notes} ���Q��
    # @option options [Object] @... ���̂܂ܖ߂�l��Hash�ɔ��f
    #
    # @note :prev,:succ,:included �� true �̂Ƃ��͎��g�œ��YIRI���v�Z����B
    #                                nil,false �̂Ƃ��͓��Y����߂�l��Hash�ɒǉ����Ȃ��B
    #
    # @return [Hash] jsonld ��\������ Hash
    #
    def to_jsonld_hash(options={})
      base = When::Parts::Resource.base_uri.sub(/When\/$/, '')
      tp   = base + 'tp/'
      ts   = base + 'ts#'
      hash = {}
      options.each_pair do |key, value|
        hash[key] = value if /^@/ =~ key
      end
      hash['@id'] ||= tp + to_uri_escape
      hash[ts + 'coordinate'] = self[precision].to_s
      hash[ts + 'succ'] = options[:succ].kind_of?(String) ?
        options[:succ] : tp + succ.to_uri_escape if options[:succ]
      hash[ts + 'prev'] = options[:prev].kind_of?(String) ?
        options[:prev] : tp + prev.to_uri_escape if options[:prev]
      hash['@reverse'] = (hash['@reverse'] || {}).merge(
        {'http://www.w3.org/2000/01/rdf-schema#member'=>
          {'@id'=>options[:included].kind_of?(String) ?
                    options[:included] :
                    tp + floor(precision-1).to_uri_escape
          }
        }) if options[:included] && precision + frame.indices.size > 0
      if options[:context]
        options[:prefixes] ||= When::Parts::Resource.namespace_prefixes
        context = hash['@context'] || {}
      end
      [hash, hash['@reverse']].each do |h|
        next unless h
        h.keys.each do |key|
          id = compact(key, options[:prefixes], context)
          if context && id != key
            prefix = id.split(':').first
            context[prefix] = options[:prefixes][prefix].last
          end
          h[id] = h.delete(key)
        end
      end
      note_options = {:indices=>precision, :notes=>:all, :method=>:to_iri}
      note_options.update(options[:note]) if options[:note]
      notes(note_options).first.each do |note|
        next unless note[:note]
        value = note[:value]
        value = value.last if value.kind_of?(Array)
        value = value.iri  if value.kind_of?(When::Parts::Resource)
        id    = compact(value, options[:prefixes], context)
        hash[compact(note[:note], options[:prefixes], context)] = (id == value) ? id : {'@id'=>id}
      end
      hash
    end

    private

    #
    # namespace �� prefix �ɃR���p�N�g������
    #
    def compact(source, prefixes, context=nil)
      return source unless prefixes
      prefixes.each_pair do |key, value|
        Array(value).each do |prefix|
          start = source.index(prefix)
          return key + ':' + source[prefix.length..-1] if start == 0
        end
      end
      return source unless context
      source =~ /\A((.+)([:#\/]))([^:#\/]+)\z/
      namespace, item = $1, $4
      if namespace =~ /^Ahttp:\/\/([^.]+)\.wikipedia\.org/
        prefix = "wiki_#{$1}"
      elsif namespace && namespace.index(When::Parts::Resource.base_uri) == 0
        parent = begin When.Resource(namespace.sub(/::\z/, '')) rescue return source end
        prefix = (parent.kind_of?(When::BasicTypes::M17n) ? parent : parent.label) / 'en'
      else
        return source
      end
      prefixes[prefix] ||= []
      prefixes[prefix] << namespace
      prefixes[prefix].sort_by! {|value| -value.length}
      context[prefix] = prefixes[prefix].last
      prefix + ':' + item
    end
  end
end
