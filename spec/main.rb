#!/usr/bin/env ruby

require 'rubygems'
require 'addressbook.pb'
require 'protojson'

unless ARGV.size == 1
  puts "Usage: #{$0} ADDRESS_BOOK_FILE"
  exit
end

person = Tutorial::Person.new
person.parse_from_file ARGV[0]

Protobuf::Message::encoding = Protobuf::Message::EncodingType::INDEXED

value = person.serialize_to_string

puts value

person = Tutorial::Person.new

person.parse_from_string(value)

p person

Protobuf::Message::encoding = Protobuf::Message::EncodingType::BINARY

value = person.serialize_to_string

puts value
#list_people address_book
