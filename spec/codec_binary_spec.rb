# -*- coding: UTF-8 -*-

#$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
$:.unshift File.join(File.dirname(__FILE__), '..')

require 'protojson'

require 'examples/simple.pb'
require 'examples/repeated.pb'
require 'examples/addressbook.pb'

describe Protojson::Codec::Binary do
  before(:all) do
    Protojson.set_default_codec(Protojson::Codec::Binary)
  end

  context "simple message" do

    it "should encode properly when two required attributes provided" do
      simple = Examples::Simple.new
      simple.foo = "Foo"
      simple.bar = 1000
      decoded = Protojson.decode(Examples::Simple, Protojson.encode(simple))
      decoded.foo.should eql("Foo")
      decoded.bar.should eql(1000)
    end

    it "should encode properly when two required attributes and one optional attribute provided" do
      simple = Examples::Simple.new
      simple.foo = "Foo"
      simple.bar = 1000
      simple.baz = "Bazz"
      decoded = Protojson.decode(Examples::Simple, Protojson.encode(simple))
      decoded.foo.should eql("Foo")
      decoded.bar.should eql(1000)
      decoded.baz.should eql("Bazz")
    end
  end

  context "repeated message" do

    it "should encode properly when the string field has more than one value" do
      repeated = Examples::Repeated.new
      repeated.string << "one"
      repeated.string << "two"
      repeated.string << "three"
      decoded = Protojson.decode(Examples::Repeated, Protojson.encode(repeated))
      decoded.string.length.should eql(3)
      decoded.string[0].should eql("one")
      decoded.string[1].should eql("two")
      decoded.string[2].should eql("three")
    end

    it "should encode properly when the int field has more than one value" do
      repeated = Examples::Repeated.new
      repeated.int << 1
      repeated.int << 2
      repeated.int << 3
      decoded = Protojson.decode(Examples::Repeated, Protojson.encode(repeated))
      decoded.int.length.should eql(3)
      (0..2).each{|i|
        decoded.int[i].should eql(i+1)
      }
    end

    it "should encode properly when both int and string fields has more than one value" do
      repeated = Examples::Repeated.new
      repeated.string << "one"
      repeated.string << "two"
      repeated.string << "three"
      repeated.int << 1
      repeated.int << 2
      repeated.int << 3
      decoded = Protojson.decode(Examples::Repeated, Protojson.encode(repeated))
      decoded.string.length.should eql(3)
      decoded.string[0].should eql("one")
      decoded.string[1].should eql("two")
      decoded.string[2].should eql("three")
      decoded.int.length.should eql(3)
      (0..2).each{|i|
        decoded.int[i].should eql(i+1)
      }
    end

    it "should encode properly when the nested field has more than one value" do
      repeated = Examples::Repeated.new
      (1..3).each { |id|
        nested = Examples::Repeated::Nested.new
        nested.id = id
        repeated.nested << nested
      }
      decoded = Protojson.decode(Examples::Repeated, Protojson.encode(repeated))
      decoded.nested.length.should eql(3)
      (0..2).each{|i|
        decoded.nested[i].should be_instance_of Examples::Repeated::Nested
        decoded.nested[i].id.should eql(i+1)
      }
    end

  end

  context "complex message" do
    it "should work!! :)" do
      book = Examples::AddressBook.new
      person = Examples::Person.new
      person.name = 'John Doe'
      person.id = 2051
      person.email = "john.doe@gmail.com"
      phone = Examples::Person::PhoneNumber.new
      phone.number = '1231231212'
      phone.type = Examples::Person::PhoneType::HOME
      person.phone << phone
      phone = Examples::Person::PhoneNumber.new
      phone.number = '55512321312'
      phone.type = Examples::Person::PhoneType::MOBILE
      person.phone << phone
      book.person << person

      person = Examples::Person.new
      person.name = "Ivan Montes"
      person.id = 23
      person.email = "drslump@pollinimini.net"
      phone = Examples::Person::PhoneNumber.new
      phone.number = '3493123123'
      phone.type = Examples::Person::PhoneType::WORK
      person.phone << phone
      book.person << person

      person = Examples::Person.new
      person.name = "Juan de Bravo"
      person.id = 24
      person.email = "juan@pollinimini.net"
      phone = Examples::Person::PhoneNumber.new
      phone.number = '3493123124'
      phone.type = Examples::Person::PhoneType::WORK
      person.phone << phone
      book.person << person

      decoded = Protojson.decode(Examples::AddressBook, Protojson.encode(book))

      decoded.person.length.should eql 3
      decoded.person[0].name.should eql "John Doe"
      decoded.person[1].name.should eql "Ivan Montes"
      decoded.person[2].name.should eql "Juan de Bravo"
      decoded.person[0].phone[1].number.should eql "55512321312"
    end

  end

end