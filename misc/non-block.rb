require 'pp'

blah = ''
count = 0

# test04.rb = 1G
f = File.open('../test-input/test06.rb', 'r')
while !f.eof?
  blah = f.readline()
  count += 1
end
f.close

# File.open('test-input/test06.rb', 'r').each_line { |line|
#   # puts "#{line}"
#   count += 1
#   # puts "--out--"
# }

puts "non-block #{count}"
