#!/usr/bin/env ruby
$LOAD_PATH << "./lib"

require "testable"

puts Testable::VERSION

puts "================================="
puts "Testable's Version"
puts "================================="
puts Testable.version

puts "================================="
puts "Testable's Dependencies"
puts "================================="
puts Testable.dependencies

puts "================================="
puts "Testable's API"
puts "================================="
puts Testable.api
