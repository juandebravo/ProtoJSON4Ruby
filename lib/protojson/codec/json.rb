require 'active_support/core_ext'

require 'protojson/codec/codec_interface'

module Protojson
  module Codec
    class Json
      include Protojson::Codec::CodecInterface

      def encode(message)
        Protojson::Codec::Hash.encode(message).to_json
      end

    end
  end
end