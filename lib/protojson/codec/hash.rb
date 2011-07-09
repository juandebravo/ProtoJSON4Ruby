require 'protobuf/message/message'
require 'protobuf/message/field'
require 'protobuf/message/enum'

module Protojson
  module Codec
    class Hash
      class << self

        # Encode the message to a hash object defined as a collection for key/values
        # where each element has:
        # - key: field tag
        # - value:
        #  - if field.is_a? message_field => field.value.serialized_to_hash
        #  - if field.is_a? enum_field    => field.value.value
        #  - else                         => field.value
        #
        # @return [Hash] a specific Message encoded in an Hash object
        def encode(message, encoding_key = :name)
          raise NotInitializedError unless message.initialized?
          # var to store the encoded message fields
          result = {}

          # lambda function that extract the field tag and value
          # it's called recursively if value is a MessageField
          field_value_to_string = lambda { |field, value|
            field_value = \
          if field.optional? && !message.has_field?(field.name)
                                      ''
          else
            case field
              when Protobuf::Field::MessageField
                if value.nil?
                  nil
                else
                  encode(value, encoding_key)
                end
              when Protobuf::Field::EnumField
                if value.is_a?(Protobuf::EnumValue)
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
          message.each_field do |field, value|
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
            unless key_value.nil? or (key_value.respond_to?(:empty?) and key_value.empty?)
              result[key.to_s] = key_value
            end
          end
          result
        end
      end
    end
  end
end