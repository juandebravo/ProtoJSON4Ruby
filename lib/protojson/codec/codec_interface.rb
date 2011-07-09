module Protojson
  module Codec
    module CodecInterface

      def encode
        raise NotImplementedError, "#{self.class} should implement encode method"
      end

      def decode
        raise NotImplementedError, "#{self.class} should implement decode method"
      end
    end
  end
end