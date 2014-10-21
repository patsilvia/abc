require 'pp'

blah = Array.new
count = 0

f = File.open('../test-input/test06.rb', 'r')
count = f.readlines.count

# File.open('test-input/test06.rb', 'r').each_line do |l|
#   count += 1
# end

puts "block #{count}"
