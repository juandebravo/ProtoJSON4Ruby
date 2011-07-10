require 'protojson/codec/codec_interface'

module Protojson
  module Codec
    class Binary
      extend Protojson::Codec::CodecInterface

      class << self

        def encode(message)
          message.serialize_to_string
        end

        def decode(message, data)
          message.new.parse_from_string(data)
        end
      end

    end
  end
end