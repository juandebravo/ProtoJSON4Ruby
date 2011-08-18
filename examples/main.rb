
$:.unshift File.join(File.dirname(__FILE__),'..','lib')
$:.unshift File.join(File.dirname(__FILE__),'.')

require 'rubygems'
require 'addressbook2.pb'
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

puts ""
puts "Json encoding"
puts "................"
value = Protojson.encode(person, Protojson::Codec::Json)
puts value
person = Protojson.decode(Tutorial::Person, value, :json)

puts ""
puts "Indexed encoding"
puts "................"
value = Protojson.encode(person, Protojson::Codec::JsonIndexed)
p value
person = Protojson.decode(Tutorial::Person, value, :indexed)

puts ""
puts "Tagmap encoding"
puts "..............."
value = Protojson.encode(person, Protojson::Codec::JsonTagMap)
puts value
person = Protojson.decode(Tutorial::Person, value, :tag_map)

puts ""
puts "Hashmap encoding"
puts "................"
value = Protojson.encode(person, Protojson::Codec::Hash)
puts value
person = Protojson.decode(Tutorial::Person, value, :hash)

