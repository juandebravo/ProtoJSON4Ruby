# -*- coding: UTF-8 -*-

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
$:.unshift File.join(File.dirname(__FILE__), '..', 'examples')

require 'protojson'

require 'simple.pb'
require 'repeated.pb'
require 'addressbook.pb'

describe Protojson::Codec::JsonTagMap do
  before(:all) do
    Protojson.set_default_codec(Protojson::Codec::JsonIndexed)
  end

  context "simple message" do

    before(:each) do
      @simple = Examples::Simple.new
      @simple.foo = "Foo"
      @simple.bar = 1000
      @encoded = Protojson.encode(@simple)
    end

    it "should encode properly when two required attributes provided" do
      @encoded.to_s.should eql('["12", "Foo", 1000]')
    end

    it "should decode properly" do
      decoded = Protojson.decode(Examples::Simple, @encoded)
      decoded.foo.should eql(@simple.foo)
      decoded.bar.should eql(@simple.bar)
    end

  end

  context "simple message (II)" do

    before(:each) do
      @simple = Examples::Simple.new
      @simple.foo = "Foo"
      @simple.bar = 1000
      @simple.baz = "Bazz"
      @encoded = Protojson.encode(@simple)
    end

    it "should encode properly when two required attributes and one optional attribute provided" do
      @encoded.to_s.should eql('["123", "Foo", 1000, "Bazz"]')
    end

    it "should decode properly" do
      decoded = Protojson.decode(Examples::Simple, @encoded)
      decoded.foo.should eql(@simple.foo)
      decoded.bar.should eql(@simple.bar)
      decoded.baz.should eql(@simple.baz)
    end

  end

  context "repeated message" do

    it "should encode properly when the string field has more than one value" do
      repeated = Examples::Repeated.new
      repeated.string << "one"
      repeated.string << "two"
      repeated.string << "three"
      Protojson.encode(repeated).to_s.should eql('["1", ["one", "two", "three"]]')
    end

    it "should encode properly when the int field has more than one value" do
      repeated = Examples::Repeated.new
      repeated.int << 1
      repeated.int << 2
      repeated.int << 3
      Protojson.encode(repeated).to_s.should eql('["2", [1, 2, 3]]')
    end

    it "should encode properly when both int and string fields has more than one value" do
      repeated = Examples::Repeated.new
      repeated.string << "one"
      repeated.string << "two"
      repeated.string << "three"
      repeated.int << 1
      repeated.int << 2
      repeated.int << 3
      Protojson.encode(repeated).to_s.should eql('["12", ["one", "two", "three"], [1, 2, 3]]')
    end

    it "should encode properly when the nested field has more than one value" do
      repeated = Examples::Repeated.new
      (1..3).each { |id|
        nested = Examples::Repeated::Nested.new
        nested.id = id
        repeated.nested << nested
      }
      Protojson.encode(repeated).to_s.should eql('["3", [["1", 1], ["1", 2], ["1", 3]]]')
    end

  end

  context "complex message" do

    it "should encode and decode the address_book example" do
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
[
                "1",[
                    [
                        "1234",
                        "John Doe",
                        2051,
                        "john.doe@gmail.com",
                        [
                            ["12", "1231231212", 1],
                            ["12", "55512321312", 0]
                        ]
                    ],
                    [
                        "1234",
                        Ivan Montes",
                        23,
                        "drslump@pollinimini.net",
                        [["12", "3493123123", 2]]
                    ],
                    {
                        "1234",
                        Juan de Bravo",
                        24,
                        "juan@pollinimini.net",
                        ["12", "3493123124", 2]]
                    ]
                ]
            ]
END

      encoded = Protojson.encode(book)
      decoded = Protojson.decode(Examples::AddressBook, encoded)
      decoded.person.length.should eql 3
      decoded.person[0].name.should eql "John Doe"
      decoded.person[1].name.should eql "Ivan Montes"
      decoded.person[2].name.should eql "Juan de Bravo"
      decoded.person[0].phone[1].number.should eql "55512321312"
    end

  end

end