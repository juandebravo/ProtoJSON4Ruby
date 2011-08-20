
# Introduction

A Ruby gem for Google's Protocol Buffers messages using three different encodings JSON based syntax instead of the
original binary protocol.

This gem extends the *ruby_protobuf* gem [1] to allow these new encodings in a protocol buffer message:

- [1] ruby_protobuf gem: [link to github project](https://github.com/macks/ruby-protobuf)

- [2] [ProtoJson specification](https://github.com/drslump/ProtoJson) by [DrSlump](https://github.com/drslump)

# Installation

    gem install protojson -v0.2.0

# Supported formats

- *Hashmap*: A tipical JSON message, with key:value pairs where the key is a string representing the field name.

- *Tagmap*: Very similar to Hashmap, but instead of having the field name as key it has the field tag number
as defined in the proto definition. This can save much space when transferring the messages, since usually field names
are longer than numbers.

- *Indexed*: Takes the Tagmap format a further step and optimizes the size needed for tag numbers by packing all of them
as a string, where each character represents a tag, and placing it as the first element of an array.


# How to use

## Serialize a message


    require 'protojson'
    require 'examples/addressbook.rb'

    book = Examples::AddressBook.new

    person = Examples::Person.new
    person.name = 'Juan de Bravo'
    person.id = 21
    book.person << person

### Serialize using the default codec (binary)

    data = Protojson.encode(book)

### Serialize using a specific codec

    [:json, :tagmap, :indexed].each{|codec|
        Protojson.encode(book, codec)
    }

## Unserialize a message

### Unserialize using a specific codec
    data = Protojson.encode(book, :json)
    value = Protojson.decode(Examples::AddressBook, data, :json)
    puts value.person[0].name # "Juan de Bravo"

### Unserialize using the default codec
    Protojson.set_default_codec(:json)
    data = Protojson.encode(book)
    value = Protojson.decode(Examples::AddressBook, data)
    puts value.person[0].name # "Juan de Bravo"

