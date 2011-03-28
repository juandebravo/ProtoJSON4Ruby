
$:.unshift File.join(File.dirname(__FILE__),'..','lib')
$:.unshift File.join(File.dirname(__FILE__),'.')

require 'rubygems'
require 'addressbook.pb'
require 'protojson'

unless ARGV.size == 1
  puts "Usage: #{$0} ADDRESS_BOOK_FILE"
  exit
end

person = Tutorial::Person.new
person.parse_from_file ARGV[0]

puts ""
puts "Person data"
puts "..........."
p person

Protobuf::Message::encoding = Protobuf::Message::EncodingType::INDEXED

value = person.serialize_to_string

puts ""
puts "Indexed encoding"
puts "................"
puts value

Protobuf::Message::encoding = Protobuf::Message::EncodingType::TAGMAP

value = person.serialize_to_string

puts ""
puts "Tagmap encoding"
puts "..............."
puts value

Protobuf::Message::encoding = Protobuf::Message::EncodingType::HASHMAP

value = person.serialize_to_string

puts ""
puts "Hashmap encoding"
puts "................"
puts value
puts ""

#Protobuf::Message::encoding = Protobuf::Message::EncodingType::BINARY

#value = person.serialize_to_string

#puts value

