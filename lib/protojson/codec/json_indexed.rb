require 'active_support/core_ext'

require 'protojson/codec/codec_interface'

module Protojson
  module Codec
    class JsonIndexed
      extend Protojson::Codec::CodecInterface

      class << self

        def encode(message)
          data = Protojson::Codec::Hash.encode(message, :tag)
          serialize_hash_to_indexed(data).to_s
        end

        def decode(message, data)
          data.is_a?(String) and data = ActiveSupport::JSON.decode(data)

          values = parse_indexed_to_hash(message.new, data)
          Protojson::Codec::Hash.decode(message, values, :tag)
        end

        # This class method serializes a Hash
        def serialize_hash_to_indexed(value)
          !value.is_a?(::Hash) and raise ArgumentError, "value must be a hash"

          # index value
          index = ""
          index.respond_to?(:force_encoding) and index.force_encoding("UTF-8") # 1.9.2
          # field values
          result = []
          value.each_pair { |key, value|
            index << key.to_i+48 # ASCII integer. 1 => 49, ...
            # recursive call if value is a Hash
            if value.is_a?(::Hash)
              value = serialize_hash_to_indexed(value)
              # array => serializes each element
            elsif value.is_a?(Array)
              value.map! { |val|
                if val.is_a?(::Hash)
                  serialize_hash_to_indexed(val)
                else
                  val
                end
              }
            end
            # insert encoded value in Array
            result.push value
          }
          # include index as first element
          result.unshift(index)
        end

        # This method parses a INDEXED encoded message to a hash using
        # message message as model.
        # We need to know the specific message to decode to differenciate between
        # vectors and message fields
        def parse_indexed_to_hash(message, data)
          values = {}
          index = data.shift
          index.each_codepoint { |tag|
            tag = tag-48
            field = message.get_field_by_tag(tag)
            val = data.shift

            if val.is_a?(Array) && field.is_a?(Protobuf::Field::MessageField)
              if field.repeated?
                val.map! { |v|
                  v = parse_indexed_to_hash(field.type, v)
                }
              else
                val = parse_indexed_to_hash(field.type, val)
              end
            end
            values[tag.to_s] = val
          }
          values
        end
      end


    end
  end
end