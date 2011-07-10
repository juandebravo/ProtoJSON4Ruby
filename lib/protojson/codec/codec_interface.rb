module Protojson
  module Codec
    module CodecInterface

        def encode(message)
          raise NotImplementedError, "#{self.class} should implement encode method"
        end

        def decode(message, data)
          raise NotImplementedError, "#{self.class} should implement decode method"
        end

    end
  end
end