%W(binary json hash json_indexed json_tag_map).each { |codec|
  require "protojson/codec/#{codec}"
}

module Protojson

  class << self

    # Key name - Codec value
    def []=(codec_name = nil, codec = nil)
      codec_name.is_a?(String) and codec_name.downcase!

      unless codec_name.nil? # default codec
        unless codec_name.is_a?(Symbol)
          if codec_name.respond_to?(:to_sym)
            codec_name = codec_name.to_sym
          else
            raise Exception, "Only symbols allowed as codec names"
          end
        end
      end

      if codec.nil? # unregister codec
        codecs.delete(codec_name)
      else # register codec
        !codec.is_a? Protojson::Codec::CodecInterface and raise Exception, "codec should include Protojson::Codec::CodecInterface"
        codecs[codec_name] = codec
      end
    end

    # Returns the codec specified or the default one if no attribute is defined
    def [](codec = nil)
      codec.is_a?(Protojson::Codec::CodecInterface) and return codec
      codec.is_a?(Symbol) or codec.nil? and return codecs[codec]
      raise "Invalid codec #{codec}. It should either implement Protojson::Codec::CodecInterface or be a symbol"
    end

    # Initializes the codecs Hash
    def codecs
      @codecs ||= (
          # While accessing the Hash, if the key does not exist, throws an exception
      h = Hash.new { |hash, key|
        hash.has_key?(key) and return hash[key]
        !key.nil? and raise Exception, "Undefined codec #{key}"
        h[nil] = Protojson::Codec::Binary
      }
      # default value is Binary codec
      h[nil] = Protojson::Codec::Binary
      h[:hash] = Protojson::Codec::Hash
      h[:indexed] = Protojson::Codec::JsonIndexed
      h[:json] = Protojson::Codec::Json
      h[:tag_map] = Protojson::Codec::JsonTagMap
      h
      )
    end

    def set_default_codec(codec)
      # fetch codec from Hash if codec name received
      if codec.is_a?(Symbol) or codec.is_a?(String)
        codec = Protojson[codec]
      end

      # set default codec
      puts codec.is_a?(Protojson::Codec::CodecInterface)
      if codec.is_a?(Protojson::Codec::CodecInterface)
        codecs[nil] = codec
      else
        raise Exception, 'Codec must implement Protojson::Codec::CodecInterface'
      end
    end

    def encode(message, codec = nil)
      codec = send("[]".to_sym, codec)
      codec.encode(message)
    end

    def decode(message, data, codec = nil)
      codec = send("[]".to_sym, codec) # fetch default codec if none given
      codec.decode(message, data)
    end

  end

end
