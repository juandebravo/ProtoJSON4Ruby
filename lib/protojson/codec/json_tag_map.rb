require 'active_support/core_ext'

require 'protojson/codec/codec_interface'

module Protojson
  module Codec
    class JsonTagMap
      extend Protojson::Codec::CodecInterface

      class << self

        def encode(message)
          Protojson::Codec::Hash.encode(message, :tag).to_json
        end

        def decode(message, data)
          data.is_a?(String) and data = ActiveSupport::JSON.decode(data)
          Protojson::Codec::Hash.decode(message, data, :tag)
        end

      end

    end
  end
end