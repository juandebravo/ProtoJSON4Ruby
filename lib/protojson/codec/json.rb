require 'active_support/core_ext'

require 'protojson/codec/codec_interface'

module Protojson
  module Codec
    class Json
      extend Protojson::Codec::CodecInterface

      class << self

        def encode(message)
          Protojson::Codec::Hash.encode(message).to_json
        end

        def decode(message, data)
          data.is_a?(String) and data = ActiveSupport::JSON.decode(data)
          Protojson::Codec::Hash.decode(message, data)
        end
      end

    end
  end
end