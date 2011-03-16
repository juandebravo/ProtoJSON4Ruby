
# Introduction

This gem extends the *ruby_protobuf* [1] gem to allow two new encodings in
a protocol buffer message:

- <tt>JSON</tt>
- <tt>INDEXED</tt>

[1] ruby_protobuf: https://github.com/macks/ruby-protobuf

# Installation

    gem install protojson

# How to use

## Serialize a message

    require 'addressbook.pb'
    require 'protojson'
    person = Tutorial::Person.new
    person.parse_from_file ARGV[0]

    Protobuf::Message::encoding = Protobuf::Message::EncodingType::INDEXED

    value = person.serialize_to_string

    puts value

## Parse a message

    require 'addressbook.pb'
    require 'protojson'

    person = Tutorial::Person.new
    person.parse_from_file ARGV[0]

    Protobuf::Message::encoding = Protobuf::Message::EncodingType::INDEXED

    value = person.serialize_to_string

    person = Tutorial::Person.new

    person.parse_from_string(value)

    p person

