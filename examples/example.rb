$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
$:.unshift File.join(File.dirname(__FILE__), '.')

require 'addressbook.pb'
require 'protojson'

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

puts "\nAddressbook info:\n"

p book

puts "\nJSON encoding: \n"
puts Protojson.encode(book, :json)

puts "\nTAGMAP encoding: \n"
puts Protojson.encode(book, :tag_map)

puts "\nINDEXED encoding: \n"
puts Protojson.encode(book, :indexed).to_s

