### Generated by rprotoc. DO NOT EDIT!
### <proto file: simple.proto>
# package examples;
# 
# message Simple {
#   required string foo = 1;
#   required int32 bar = 2;
#   optional string baz = 3;
# }

require 'protobuf/message/message'
require 'protobuf/message/enum'
require 'protobuf/message/service'
require 'protobuf/message/extend'

module Examples
  class Simple < ::Protobuf::Message
    defined_in __FILE__
    required :string, :foo, 1
    required :int32, :bar, 2
    optional :string, :baz, 3
  end
end