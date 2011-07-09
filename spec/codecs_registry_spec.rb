$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'protojson'

describe Protojson do

  context "initialize with default behavior" do

    it "should have the default codec when initialized" do
      Protojson.codecs.length.should eql(1)
    end

    it 'should get a default codec if none set' do
      codec = Protojson[]
      codec.should be_a_kind_of Protojson::Codec::CodecInterface
    end

  end
  context "getting codecs" do

    it 'should return the passed codec instance' do
      passed = Protojson::Codec::Binary
      getted = Protojson[passed]
      passed.should eql getted
    end

    it 'should return the codec mapped to the attribute' do
      setted = Protojson::Codec::Binary
      Protojson[:test] = setted
      getted = Protojson[:test]
      getted.should be(Protojson::Codec::Binary)
    end

    it 'should raise an exception if the codec does not exist' do
      lambda { Protojson[:foo] }.should raise_error(Exception)
    end

  end

  context "setting codecs" do

    it 'should register a new codec' do
      setted = Protojson::Codec::Binary
      Protojson[:test] = setted
      getted = Protojson[:test]
      getted.should eql setted
    end

    it 'should register a new default codec with parameter type of Codec' do
      setted = Protojson::Codec::Binary
      Protojson.set_default_codec(setted)
      Protojson[].should eql setted
    end

    it 'should register a new default codec with parameter type of string' do
      setted = Protojson::Codec::Binary
      Protojson[:foo] = setted
      Protojson.set_default_codec(:foo)
      Protojson[].should eql setted
    end

    it 'should throw an exception while registering a codec that does not implement the Codec interface' do
      lambda { Protojson[:test] = :foo }.should raise_error(Exception)
    end
  end

  context "unsetting codecs" do

    it 'should unregister an existing codec' do
      setted = Protojson::Codec::Binary
      Protojson[:test] = setted
      getted = Protojson[:test]
      getted.should eql setted
      Protojson[:test] = nil
      lambda { Protojson[:test] }.should raise_error(Exception)
    end

    it "should unregister the default codec" do
      Protojson[] = nil
      getted = Protojson[]
      getted.should be_a_kind_of Protojson::Codec::CodecInterface
      getted.should be Protojson::Codec::Binary
    end
  end
end