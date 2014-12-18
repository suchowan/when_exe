# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  module Parts::Resource
    class << self

      # Linked Data 用 namespace URI の Array の Hash を生成する
      #
      # @param [Array<When::Parts::Resource or String>] resources namespace を抽出する resource の Array
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

      # URIのArrayの最後の要素を prefix に対応する namespace とみなして json-ld の @context に適合する形式に変換する
      #
      # @param [Hash<String=>Array<String>>] prefixes Linked Data 用 namespace URIのArrayのHash
      #
      # @return [Hash<String=>String>] prefix と namespace の1対1対応
      #
      def prefixs_to_context(prefixes)
         Hash[*(prefixes.keys.map {|key| [key, prefixes[key].last]}.flatten)]
      end

      # json-ld の @context に適合する形式で記述された 1対1対応する prefix と namespace を Linked Data 用 namespace URIのArrayのHash化する
      #
      # @param [Hash<String=>String>] prefixes prefix と namespace の1対1対応
      #
      # @return [Hash<String=>Array<String>>] Linked Data 用 namespace URIのArrayのHash
      #
      def context_to_prefixs(prefixes)
         hash = {}
         prefixes.each_pair do |key, value|
           hash[key] = [value]
         end
         hash
      end
    end

    # Linked Data 用 namespace URI の Array の Hash を生成する
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

      # 指定の範囲のCalDateオブジェクトのグラフの jsonld を表現する Hash を生成する
      #
      # @param [Range or Array] dates jsonld を表現する Hash を生成するCalDateオブジェクトの範囲
      # @param [Hash] options 以下の通り
      # @option options [Boolean] :include 自身が含む分解能が高いCalDateオブジェクトをグラフに含める
      # @option options [Object] @... そのまま戻り値のHashに追加
      # @option options [Symbol] その他 {When::TM::CalDate#to_jsonld} を参照
      #
      # @return [Hash] jsonld を表現する Hash
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

      # CalDateオブジェクトの jsonld をグラフに追加する
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

    # 自身を root とするグラフの jsonld を表現する Hash を生成する
    #
    # @param [Hash] options {When::CalendarNote.rdf_graph} を参照
    #
    # @return [Hash] jsonld を表現する Hash
    #
    def rdf_graph(options={})
      When::CalendarNote.rdf_graph([self], options)
    end

    # CalDateオブジェクトの jsonld を表現する Hash を生成する
    #
    # @param [Hash] options 以下の通り
    # @option options [Hash] :prefixes Linked Data 用 namespace URI の Array の Hash ('@context'互換でも可)
    # @option options [Boolean] :context true なら 可能な限り namespace を prefix に変換する
    # @option options [String or Boolean] :prev ひとつ前のCalDateオブジェクトのIRI
    # @option options [String or Boolean] :succ ひとつ後のCalDateオブジェクトのIRI
    # @option options [String or Boolean] :included 自身を含む分解能が1低いCalDateオブジェクトのIRI
    # @option options [Hash] :note 暦注計算のオプション {When::CalendarNote#notes} を参照
    # @option options [Object] @... そのまま戻り値のHashに反映
    #
    # @note :prev,:succ,:included が true のときは自身で当該IRIを計算する。
    #                                nil,false のときは当該情報を戻り値のHashに追加しない。
    #
    # @return [Hash] jsonld を表現する Hash
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
    # namespace を prefix にコンパクト化する
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
