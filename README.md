
# Introduction

A Ruby gem for Google's Protocol Buffers messages using three different encodings JSON based syntax instead of the
original binary protocol.

This gem extends the *ruby_protobuf* gem [1] to allow these new encodings in a protocol buffer message:

- [1] ruby_protobuf gem: [link to github project](https://github.com/macks/ruby-protobuf)

- [2] [ProtoJson specification](https://github.com/drslump/ProtoJson) by [DrSlump](https://github.com/drslump)

# Installation

    gem install protojson

# Supported formats

- *Hashmap*: A tipical JSON message, with key:value pairs where the key is a string representing the field name.

- *Tagmap*: Very similar to Hashmap, but instead of having the field name as key it has the field tag number
as defined in the proto definition. This can save much space when transferring the messages, since usually field names
are longer than numbers.

- *Indexed*: Takes the Tagmap format a further step and optimizes the size needed for tag numbers by packing all of them
as a string, where each character represents a tag, and placing it as the first element of an array.


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

