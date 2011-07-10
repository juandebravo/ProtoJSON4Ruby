# -*- coding: UTF-8 -*-

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
$:.unshift File.join(File.dirname(__FILE__), '..', 'examples')

require 'protojson'

require 'simple.pb'
require 'repeated.pb'
require 'addressbook.pb'

describe Protojson::Codec::Json do
  before(:all) do
    Protojson.set_default_codec(Protojson::Codec::Json)
  end

  context "simple message" do

    it "should encode properly when two required attributes provided" do
      simple = Examples::Simple.new
      simple.foo = "Foo"
      simple.bar = 1000
      Protojson.encode(simple).should eql('{"foo":"Foo","bar":1000}')
    end

    it "should encode properly when two required attributes and one optional attribute provided" do
      simple = Examples::Simple.new
      simple.foo = "Foo"
      simple.bar = 1000
      simple.baz = "Bazz"
      Protojson.encode(simple).should eql('{"foo":"Foo","bar":1000,"baz":"Bazz"}')
    end
  end

  context "repeated message" do

    it "should encode properly when the string field has more than one value" do
      repeated = Examples::Repeated.new
      repeated.string << "one"
      repeated.string << "two"
      repeated.string << "three"
      Protojson.encode(repeated).should eql('{"string":["one","two","three"]}')
    end

    it "should encode properly when the int field has more than one value" do
      repeated = Examples::Repeated.new
      repeated.int << 1
      repeated.int << 2
      repeated.int << 3
      Protojson.encode(repeated).should eql('{"int":[1,2,3]}')
    end

    it "should encode properly when both int and string fields has more than one value" do
      repeated = Examples::Repeated.new
      repeated.string << "one"
      repeated.string << "two"
      repeated.string << "three"
      repeated.int << 1
      repeated.int << 2
      repeated.int << 3
      Protojson.encode(repeated).should eql('{"string":["one","two","three"],"int":[1,2,3]}')
    end

    it "should encode properly when the nested field has more than one value" do
      repeated = Examples::Repeated.new
      (1..3).each { |id|
        nested = Examples::Repeated::Nested.new
        nested.id = id
        repeated.nested << nested
      }
      Protojson.encode(repeated).should eql('{"nested":[{"id":1},{"id":2},{"id":3}]}')
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

      expected =<<END
{
                "person":[
                    {
                        "name":"John Doe",
                        "id":2051,
                        "email":"john.doe@gmail.com",
                        "phone":[
                            {"number":"1231231212","type":1},
                            {"number":"55512321312","type":0}
                        ]
                    },
                    {
                        "name":"Ivan Montes",
                        "id":23,
                        "email":"drslump@pollinimini.net",
                        "phone":[{"number":"3493123123","type":2}]
                    },
                    {
                        "name":"Juan de Bravo",
                        "id":24,
                        "email":"juan@pollinimini.net",
                        "phone":[{"number":"3493123124","type":2}]
                    }
                ]
            }
END

      encoded = Protojson.encode(book)
      encoded.should eql(expected.gsub(/\n\s*/, ''))
      decoded = Protojson.decode(Examples::AddressBook, encoded)
      decoded.person.length.should eql 3
      decoded.person[0].name.should eql "John Doe"
      decoded.person[1].name.should eql "Ivan Montes"
      decoded.person[2].name.should eql "Juan de Bravo"
      decoded.person[0].phone[1].number.should eql "55512321312"
    end

  end

end