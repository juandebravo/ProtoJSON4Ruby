require 'active_support/core_ext'

#
# This is an extension of Protobud::Message class
# which aims to support both JSON and INDEXED formats.
#
# Author:: Juan de Bravo  (juandebravo@gmail.com, juan@pollinimini.net)
# Author:: Ivan -DrSlump- Montes (drslump@pollinimini.net)
# License::  --
#
module Protobuf

  class Message

    # Enum type that defines the supported encodings
    #  - Binary
    #  - Hashmap
    #  - Indexed
    #  - Indexed
    module EncodingType
      BINARY = 0,
      HASHMAP = 1,
      TAGMAP = 2,
      INDEXED = 3
    end

    # static variable to define the specific encoding to be used.
    # By default, use the primitive encoding type (BINARY)
    @@encoding = Protobuf::Message::EncodingType::BINARY

    # encoding setter
    def self.encoding=(encoding)
      @@encoding = encoding
    end

    # encoding getter
    def self.encoding
      @@encoding
    end

    # Encode the message to a hash object defined as a collection for key/values
    # where each element has:
    # - key: field tag
    # - value:
    #  - if field.is_a? message_field => field.value.serialized_to_hash
    #  - if field.is_a? enum_field    => field.value.value
    #  - else                         => field.value
    #    
    # @return [Hash] a specific Message encoded in an Hash object
    def serialize_to_hash(encoding_key = :tag)
      raise NotInitializedError unless self.initialized?
      # var to store the encoded message fields
      result = {}

      # lambda function that extract the field tag and value
      # it's called recursively if value is a MessageField
      field_value_to_string = lambda { |field, value|
        field_value = \
          if field.optional? && !self.has_field?(field.name)
                                  ''
          else
            case field
              when Field::MessageField
                if value.nil?
                  nil
                else
                  value.serialize_to_hash(encoding_key)
                end
              when Field::EnumField
                if value.is_a?(EnumValue)
                  value.value
                else
                  value.to_i
                end
              else
                value
            end
          end
        return field.send(encoding_key), field_value
      }

      # per each message field create a new element in result var with
      # key = field.tag and value = field.value
      self.each_field do |field, value|
        # create a vector if field is repeated
        if field.repeated? && !value.empty?
          key_value = []
          key = nil
          value.each do |v|
            key, val = field_value_to_string.call(field, v) # always return the same key
            key_value.push val
          end
          # field is not repeated but is not empty
        elsif !field.repeated?
          key, key_value = field_value_to_string.call(field, value)
          # empty field, discard
        else
          next
        end
        # new element in result Hash
        result[key.to_s] = key_value
      end
      result
    end

    # allow new serialization, not only binary
    alias :serialize_to_string_old :serialize_to_string

    # This method is used to serialize the message to a specific format
    # based on the class variable *encoding*
    def serialize_to_string(string='')
      case @@encoding
        when EncodingType::BINARY # primitive format
          serialize_to_string_old(string)
        when EncodingType::HASHMAP # JSON format with key = field.name
          serialize_to_json(:name)
        when EncodingType::TAGMAP # JSON format with key = field.tag
          serialize_to_json(:tag)
        when EncodingType::INDEXED # INDEXED format
          serialize_to_indexed
        else
          raise ArgumentError, "Invalid encoding type"
      end
    end

    # This method serializes the message in JSON format
    def serialize_to_json(encoding_key = :tag)
      serialize_to_hash(encoding_key).to_json
    end

    # This method serializes the message in INDEXED format
    def serialize_to_indexed
      data = serialize_to_hash
      self.class.serialize_hash_to_indexed(data).to_json
    end

    # This class method serializes a Hash
    def self.serialize_hash_to_indexed(value)
      !value.is_a?(Hash) and raise ArgumentError, "value must be a hash"
      # index value
      index = ""
      index.respond_to?(:force_encoding) and index.force_encoding("UTF-8") # 1.9.2
      # field values
      result = []
      value.each_pair { |key, value|
        index << key.to_i+48 # ASCII integer. 1 => 49, ...
        # recursive call if value is a Hash
        if value.is_a?(Hash)
          value = self.class.serialize_hash_to_indexed(value)
          # array => serializes each element
        elsif value.is_a?(Array)
          value.map! { |val|
            if val.is_a?(Hash)
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

    # This method parses a JSON encoded message to the self.class object
    def parse_from_json(data, decoding_key = :tag)
      # decode if data is JSON
      data.is_a?(String) and data = ActiveSupport::JSON.decode(data)

      # per each hash element:
      data.each_pair { |key, value|
        key = decoding_key.eql?(:tag) ? key.to_i : key.to_s

        #  get the field object using the key (field tag)
        #field = self.get_field_by_tag(key.to_i)
        field = self.send("get_field_by_#{decoding_key}".to_sym, key)

        if field.nil?
          # ignore unknown field
        elsif field.repeated?
          # create the element
          array = self.__send__(field.name)
          value.each { |val|
          # if value is a complex field, create the object and parse the content
            if field.is_a?(Protobuf::Field::MessageField)
              instance = field.type.new
              val = instance.parse_from_json(val, decoding_key)
            end
            # include each element in the parent element field
            array.push(val)
          }
        else
          # if value is a complex field, create the object and parse the content
          if field.is_a?(Protobuf::Field::MessageField)
            instance = field.type.new
            value = instance.parse_from_json(value, decoding_key)
          end
          # set the message field
          self.__send__("#{field.name}=", value)
        end
      }
      self
    end

    # This method parses a INDEXED encoded message to a hash using
    # klass message as model.
    # We need to know the specific klass to decode to differenciate between
    # vectors and message fields
    def self.parse_indexed_to_hash(data, klass)
      values = {}
      index = data.shift
      index.each_codepoint { |tag|
        tag = tag-48
        field = klass.get_field_by_tag(tag)
        val = data.shift

        if val.is_a?(Array) && field.is_a?(Protobuf::Field::MessageField)
          if field.repeated?
            val.map! { |v|
              v = self.parse_indexed_to_hash(v, field.type)
            }
          else
            val = self.parse_indexed_to_hash(val, field.type)
          end
        end
        values[tag.to_s] = val
      }
      values
    end

    # This method parses a INDEXED encoded message to a hash using
    # self.class message as model.
    def parse_from_indexed(data)
      # decode if data is JSON
      data.is_a?(String) and data = ActiveSupport::JSON.decode(data)
      values = self.class.parse_indexed_to_hash(data, self)
      parse_from_json(values)
    end

    # allow new parsing, not only binary
    alias :parse_from_string_old :parse_from_string

    # This method is used to parse the message from a specific format
    # based on the class variable *encoding*
    def parse_from_string(string)
      case @@encoding
        when EncodingType::BINARY
          parse_from_string_old(string)
        when EncodingType::HASHMAP
          parse_from_json(string, :name)
        when EncodingType::TAGMAP
          parse_from_json(string, :tag)
        when EncodingType::INDEXED
          parse_from_indexed(string)
        else
          raise ArgumentError, "Invalid encoding type"
      end
    end
  end
end
