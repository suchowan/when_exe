# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014-2015 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When
  #
  # When::Parts::Resource への追加
  # 
  module Parts::Resource

    DocRoot = "http://www.rubydoc.info/gems/when_exe/#{When::VERSION}/When/"

    Schema = {
      'ts:reference'       => {'ts:reference' => "#{DocRoot}Locale#reference-instance_method"               },
      'ts:label'           => {'ts:reference' => "#{DocRoot}BasicTypes/M17n#label-instance_method"          },
      'ts:prev'            => {'ts:reference' => "#{DocRoot}TM/TemporalPosition#prev-instance_method"       },
      'ts:succ'            => {'ts:reference' => "#{DocRoot}TM/TemporalPosition#succ-instance_method"       },
      'ts:frame'           => {'ts:reference' => "#{DocRoot}TM/TemporalPosition#frame-instance_method"      },
      'ts:ruler'           => {'ts:reference' => "#{DocRoot}TM/TemporalPosition#query-instance_method"      },
      'ts:coordinate'      => {'ts:reference' => "#{DocRoot}TM/CalDate#cal_date-instance_method"            },
      'ts:sdn'             => {'ts:reference' => "#{DocRoot}TM/CalDate#to_i-instance_method"                },
      'ts:calendarEra'     => {'ts:reference' => "#{DocRoot}TM/CalDate#calendar_era-instance_method"        },
      'ts:referenceEvent'  => {'ts:reference' => "#{DocRoot}TM/Clock#reference_event-instance_method"       },
      'ts:referenceTime'   => {'ts:reference' => "#{DocRoot}TM/Clock#reference_time-instance_method"        },
      'ts:utcReference'    => {'ts:reference' => "#{DocRoot}TM/Clock#utc_reference-instance_method"         },
      'ts:dateBasis'       => {'ts:reference' => "#{DocRoot}TM/Clock#date_basis-instance_method"            },
      'ts:referenceFrame'  => {'ts:reference' => "#{DocRoot}TM/Calendar#reference_frame-instance_method"    },
      'ts:timeBasis'       => {'ts:reference' => "#{DocRoot}TM/Calendar#time_basis-instance_method"         },
      'ts:referenceEvent'  => {'ts:reference' => "#{DocRoot}TM/CalendarEra#reference_event-instance_method" },
      'ts:referenceDate'   => {'ts:reference' => "#{DocRoot}TM/CalendarEra#reference_date-instance_method"  },
      'ts:julianReference' => {'ts:reference' => "#{DocRoot}TM/CalendarEra#julian_reference-instance_method"},
      'ts:datingSystem'    => {'ts:reference' => "#{DocRoot}TM/CalendarEra#dating_system-instance_method"   },
      'ts:epoch'           => {'ts:reference' => "#{DocRoot}TM/CalendarEra#epoch-instance_method"           },
      'ts:remainder'       => {'ts:reference' => "#{DocRoot}Coordinates/Residue#remainder-instance_method"  },
      'ts:divisor'         => {'ts:reference' => "#{DocRoot}Coordinates/Residue#divisor-instance_method"    },
      'ts:longitude'       => {'ts:reference' => "#{DocRoot}Coordinates/Spatial#longitude-instance_method"  },
      'ts:latitude'        => {'ts:reference' => "#{DocRoot}Coordinates/Spatial#latitude-instance_method"   },
      'ts:altitide'        => {'ts:reference' => "#{DocRoot}Coordinates/Spatial#latitude-instance_method"   },
      'ts:event'           => {'ts:reference' => "#{DocRoot}CalendarNote#event-instance_method"             },
    }

    XSD  = 'http://www.w3.org/2001/XMLSchema'
    RDFS = 'http://www.w3.org/2000/01/rdf-schema#'
    RDF  = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#'

    class << self

      # Schema オブジェクトを生成する
      #
      # @return [Hash] #to_linked_data メソッドを追加した Hash
      #
      def schema
        hash = {'@context'=>{'ts'=>base_uri.sub(/When\/$/, '') + 'ts#'},
                '@graph'  => Schema.keys.map {|id|
          next nil unless id =~ /\Ats:/
          item = {}
          item['@id'] = id
          Schema[id].each_pair do |key, ref|
            item[key] = {'@id'=>ref}
          end
          item
        }.compact}
        class << hash
          def to_linked_data(writer=:jsonld, options={})
            When::Parts::Resource.to_linked_data(self, writer, self['@context'])
          end
        end
        hash
      end

      # jsonld を表現する Hash を各種のRDF表現形式に変換する
      #
      # @param [Hash] jsonld_hash jsonld を表現する Hash
      # @param [Symbol] writer RDF表現形式 (デフォルト :jsonld - 単に Hash を JSON化)
      # @param [Hash] prefixes prefix から namespace を引く Hash
      #
      # @return [String] writer で指定されたRDF表現形式の文字列
      #
      def to_linked_data(jsonld_hash, writer=:jsonld, prefixes=nil)
        if writer == :jsonld
          JSON.generate(jsonld_hash)
        else
          array = JSON::LD::API.toRdf(jsonld_hash)
          graph = ::RDF::Graph.new << array
          args  = [writer]
          args << {:prefixes=>prefixes} if prefixes
          graph.dump(*args)
        end
      end

      # 指定の範囲のResourceオブジェクトのグラフの jsonld を表現する Hash を生成する
      #
      # @param [Range or Array] objects jsonld を表現する Hash を生成するResourceオブジェクトの範囲または配列
      # @param [Hash] options 以下の通り
      # @option options [Boolean] :include 自身が含むResourceオブジェクトをグラフに含める(デフォルト nil)
      # @option options [Object] @... そのまま戻り値のHashに追加
      # @option options [Symbol] その他 {When::TM::CalDate#to_jsonld_hash} などを参照
      #
      # @return [Hash] jsonld を表現する Hash
      #
      def rdf_graph(objects, options={})
        jsonld_hash = {}
        sub_options = {}
        options.each_pair do |key, value|
          (/^@/ =~ key ? jsonld_hash : sub_options)[key] = value
        end
        jsonld_hash['@graph']  ||= []
        sub_options[:prefixes] ||= When::Parts::Resource.namespace_prefixes if options[:context]
        objects.each do |object|
          object.register_graph(jsonld_hash['@graph'], sub_options)
        end
        if options['@context'] && options[:context]
          sub_options[:prefixes].each_pair do |key, value|
            options['@context'][key] ||= value.last
          end
        end
        jsonld_hash
      end

      # Linked Data 用 namespace URI の Array の Hash を生成する
      #
      # @param [Array<When::Parts::Resource or String>] resources namespace を抽出する resource の Array
      #
      # @return [Hash]
      #
      def namespace_prefixes(*resources)
        base = base_uri.sub(/When\/$/, '')
        resources.inject({
          'xsd'  => [XSD],
          'rdf'  => [RDF],
          'rdfs' => [RDFS],
          'owl'  => ['http://www.w3.org/2002/07/owl#'],
          'dc'   => ['http://purl.org/dc/elements/1.1/'],
          'dcq'  => ['http://purl.org/dc/terms/'],
          'dct'  => ['http://purl.org/dc/dcmitype/'],
        # 'tp'   => [base + 'tp/'],
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

    # 自身を root とするグラフの jsonld を表現する Hash を各種のRDF表現形式に変換する
    #
    # @param [Symbol] writer RDF表現形式 (デフォルト :jsonld - 単に Hash を JSON化)
    # @param [Hash] options 内部で呼び出す #to_jsonld_hash にそのまま渡す
    #
    # @return [String] writer で指定されたRDF表現形式の文字列
    #
    def to_linked_data(writer=:jsonld, options={})
      jsonld_hash = rdf_graph(options)
      When::Parts::Resource.to_linked_data(jsonld_hash, writer, jsonld_hash['@context'])
    end

    # 自身を root とするグラフの jsonld を表現する Hash を生成する
    #
    # @param [Hash] options {When::Parts::Resource.rdf_graph} を参照
    #
    # @return [Hash] jsonld を表現する Hash
    #
    def rdf_graph(options={})
      When::Parts::Resource.rdf_graph([self], options)
    end

    # Resourceオブジェクトの jsonld をグラフに追加する
    #
    # @param [Array<Hash>] graph 個別のResourceオブジェクトの jsonld hash の Array
    # @param [Hash] options {When::Parts::Resource.rdf_graph} を参照
    #
    # @return [Array] jsonld hash の Array
    #
    def register_graph(graph, options={})
      jsonld_hash = to_jsonld_hash(options)
      graph << jsonld_hash
      if options[:include] && child
        included_opt = {:included=>jsonld_hash['@id']}.update(options)
        child.each do |included|
          included.register_graph(graph, included_opt)
        end
      end
    end

    # Resourceオブジェクトの jsonld を表現する Hash を生成する
    #
    # @param [Hash] options 以下の通り
    # @option options [Hash] :prefixes Linked Data 用 namespace URI の Array の Hash ('@context'互換でも可)
    # @option options [Boolean] :context true なら 可能な限り namespace を prefix に変換する
    # @option options [String or Boolean] :prev ひとつ前のResourceオブジェクトのIRI
    # @option options [String or Boolean] :succ ひとつ後のResourceオブジェクトのIRI
    # @option options [String or Boolean] :included 自身を含む親ResourceオブジェクトのIRI
    # @option options [Object] @... そのまま戻り値のHashに反映
    #
    # @note :prev,:succ,:included が true のときは自身で当該IRIを計算する。
    #                                nil,false のときは当該情報を戻り値のHashに追加しない。
    #
    # @return [Hash] jsonld を表現する Hash
    #
    def to_jsonld_hash(options={})
      neighbor  = {
        :succ   => options[:succ],
        :prev   => options[:prev],
        :parent => options[:included]
      }
      neighbor.each_pair do |key, value|
        neighbor[key] = send(key) if value == true
        neighbor[key] = neighbor[key].iri if neighbor[key].kind_of?(When::Parts::Resource)
      end
      hash, context, base = hash_and_variables(options)
      ts = base + 'ts#'
      hash['@id'] = iri
      hash[ts + 'succ'] = {'@id'=>neighbor[:succ]} if neighbor[:succ]
      hash[ts + 'prev'] = {'@id'=>neighbor[:prev]} if neighbor[:prev]
      hash['@reverse' ] = (hash['@reverse'] || {}).merge(
        {RDFS + 'member'=>{'@id'=>neighbor[:parent]}}) if neighbor[:parent]
      hash.update(hash_for_jsonld(ts, options))
      compact_predicate(hash, context, options[:prefixes])
      hash
    end

    private

    #
    # jsonld_hash と context, base を準備する
    #
    def hash_and_variables(options)
      base = When::Parts::Resource.base_uri.sub(/When\/$/, '')
      hash = {}
      options.each_pair do |key, value|
        hash[key] = value if /^@/ =~ key
      end
      hash[RDF + 'type'] = {'@id'=>base + 'ts/' + self.class.to_s.gsub(/::/, '/')}
      if options[:context]
        options[:prefixes] ||= When::Parts::Resource.namespace_prefixes
        context = hash['@context'] || {}
      end
      [hash, context, base]
    end

    #
    # jsonld_hash の個別部分
    #
    def hash_for_jsonld(ts, options)
      tp   = ts.sub('ts#', 'tp/')
      hash = {}
      to_h({:method=>:iri}.update(options)).each_pair do |key, value|
        case value
        when Array   ; hash[ts + key.to_s] = value.map {|v|
          case v
          when When::TM::CalDate ; {'@id'=>tp + v.to_uri_escape}
          when /:\/\//           ; {'@id'=>v}
          else                   ; nil
          end
        }.compact unless value.empty?
        when Hash    ;
        when /:\/\// ; hash[ts + key.to_s] = {'@id'=>value}
        else         ; hash[ts + key.to_s] = value
        end
      end
      hash
    end

    #
    # 述語をコンパクト化する
    #
    def compact_predicate(hash, context, prefixes)
      [hash, hash['@reverse']].each do |h|
        h.keys.each do |key|
          id = compact_namespace_to_prefix(key, prefixes, context)
          if context && id != key
            prefix = id.split(':').first
            context[prefix] = prefixes[prefix].last
          end
          h[id] = h.delete(key)
        end if h
      end
    end

    #
    # namespace を prefix にコンパクト化する
    #
    def compact_namespace_to_prefix(source, prefixes, context=nil)
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
        return source unless prefix =~ /\A[-A-Z\d_]+\z/i
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

  #
  # When::BasicTypes::M17n への追加
  # 
  class BasicTypes::M17n

    private

    #
    # jsonld_hash の個別部分
    #
    def hash_for_jsonld(ts, options)
      hash = {}
      hash[RDFS + 'label'] = names.keys.map {|key| key=='' ? names[key] : {'@language'=>key, '@value'=>names[key]}}
      hash[ts   + 'label'] = label
      hash[ts   + 'reference'] = link.values.map {|ref| {'@id'=>ref}}
      hash
    end
  end

  #
  # When::TM::Clock への追加
  # 
  class TM::Clock

    private

    #
    # jsonld_hash の個別部分
    #
    def hash_for_jsonld(ts, options)
      hash = {}
      self.class::HashProperty.each do |sym|
        hash[ts + sym.to_s] = send(sym).to_s if send(sym)
      end
      hash
    end
  end

  #
  # When::TM::CalDate への追加
  # 
  class TM::CalDate

    # 自身を root とするグラフの jsonld を表現する Hash を各種のRDF表現形式に変換する
    #
    # @param [Symbol] writer RDF表現形式 (デフォルト :jsonld - 単に Hash を JSON化)
    # @param [Hash] options 内部で呼び出す #to_jsonld_hash にそのまま渡す。ただし、
    # @option options [Boolean] :include 自身が含む分解能が高いCalDateオブジェクトをグラフに含める(デフォルト true)
    #
    # @return [String] writer で指定されたRDF表現形式の文字列
    #
    def to_linked_data(writer=:jsonld, options={})
      hash = rdf_graph({:include=>true}.update(options))
      When::Parts::Resource.to_linked_data(hash, writer, hash['@context'])
    end

    # 自身を root とするグラフの jsonld を表現する Hash を生成する
    #
    # @param [Hash] options {When::Parts::Resource.rdf_graph} を参照
    #
    # @return [Hash] jsonld を表現する Hash
    #
    def rdf_graph(options={})
      root = options[:include] && precision < When::YEAR ? floor(When::YEAR) : self
      When::Parts::Resource.rdf_graph([root], options)
    end

    # CalDateオブジェクトの jsonld をグラフに追加する
    #
    # @param [Array<Hash>] graph 個別のCalDateオブジェクトの jsonld hash の Array
    # @param [Hash] options {When::Parts::Resource.rdf_graph} を参照
    #
    # @return [Array] jsonld hash の Array
    #
    def register_graph(graph, options={})
      jsonld_hash = to_jsonld_hash(options)
      graph << jsonld_hash
      if options[:include] && precision < When::DAY
        included = floor(precision+1)
        included_opt  = {:included=>jsonld_hash['@id']}.update(options)
        while include?(included) do
          included.register_graph(graph, included_opt)
          included = included.succ
        end
      end
    end

    # CalDateオブジェクトの jsonld を表現する Hash を生成する
    #
    # @param [Hash] options 以下の通り
    # @option options [Hash] :prefixes Linked Data 用 namespace URI の Array の Hash ('@context'互換でも可)
    # @option options [Boolean] :context true なら 可能な限り namespace を prefix に変換する
    # @option options [String or Boolean] :prev ひとつ前のCalDateオブジェクトのIRI
    # @option options [String or Boolean] :succ ひとつ後のCalDateオブジェクトのIRI
    # @option options [String or Boolean] :included 自身を含む分解能が1低いCalDateオブジェクトのIRI
    # @option options [Hash] :note 暦注計算のオプション {When::Parts::Resource#notes} を参照
    # @option options [Object] @... そのまま戻り値のHashに反映
    #
    # @note :prev,:succ,:included が true のときは自身で当該IRIを計算する。
    #                                nil,false のときは当該情報を戻り値のHashに追加しない。
    #
    # @return [Hash] jsonld を表現する Hash
    #
    def to_jsonld_hash(options={})
      hash, context, base = hash_and_variables(options)
      tp   = base + 'tp/'
      ts   = base + 'ts#'
      hash['@id'] ||= tp + to_uri_escape
      hash[ts + 'sdn'] = precision <= When::DAY ? to_i : to_f
      hash[ts + 'frame'] = {'@id'=>frame.iri(false)}
      hash[ts + 'calendarEra'] = {'@id'=>calendar_era.iri(false)} if calendar_era
      hash[ts + 'coordinate'] = self[precision].to_s
      hash[ts + 'ruler'] = {'@id'=>query['name'].iri} if query && query['name'].kind_of?(When::BasicTypes::M17n)
      hash[ts + 'succ'] = options[:succ].kind_of?(String) ?
        options[:succ] : {'@id'=>tp + succ.to_uri_escape} if options[:succ]
      hash[ts + 'prev'] = options[:prev].kind_of?(String) ?
        options[:prev] : {'@id'=>tp + prev.to_uri_escape} if options[:prev]
      hash['@reverse'] = (hash['@reverse'] || {}).merge(
        {RDFS + 'member'=>
          {'@id'=>options[:included].kind_of?(String) ?
                    options[:included] :
                    tp + floor(precision-1).to_uri_escape
          }
        }) if options[:included] && precision + frame.indices.size > 0
      compact_predicate(hash, context, options[:prefixes])
      note_options = {:indices=>precision, :notes=>:all, :method=>:iri}
      note_options.update(options[:note]) if options[:note]
      notes(note_options).first.each do |note|
        next unless note[:note]
        value = note[:value]
        value = value.last if value.kind_of?(Array)
        value = value.iri  if value.kind_of?(When::Parts::Resource)
        id    = compact_namespace_to_prefix(value, options[:prefixes], context)
        hash[compact_namespace_to_prefix(note[:note], options[:prefixes], context)] = (id == value && id !~ /:\/\//) ? id : {'@id'=>id}
      end
      hash
    end
  end
end
