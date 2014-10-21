#!/usr/bin/env ruby

require 'micro-optparse'
require 'filemagic'
require 'pp'


count_output = {
    :raw_num_line => 0,
    :blank_line => 0,
    :comment_line => 0,
    :line_has_comment => 0,
    :non_white_char => 0
}

# Function
def read_to_mem(fn)
  lines = []

  File.open(fn).each_line do |l|
    lines << l
  end
  return lines
end

def is_blank?(l)

  if /\S+/.match(l) #match non-white space
    puts "match non-white"
    return false
  else
    puts "no non-white"
    return true
  end

end

def is_comment_wholeline(l, c)
  if /^(\s)*#{c}/.match(l)
    puts "Catch the comment line"
    return true
  else
    puts "No comment"
    return false
  end
end

def is_comment_mix_inline(l, c)

end

def is_comment?(l, c)
  # case: start with space optional, and actually comment line
  puts "#{l}"
  if /^.*#[^"]*$/.match(l)
  # case: start with space and actually code




end

def has_comment?(l)
  # case: code with inline comment
end

def sanitize_input_exist?(f)
  if f == __FILE__
    puts "Counting myself...OK"
    return true
  else
    if ( !(File.directory?(f)) and (File::exists?(f)) )
      puts "File #{f} exists...looks good."
      return true
    else
      puts "File #{f} is not found or it is directory...exit"
      return false
    end
  end
end

def sanitize_input_text?(f)

  fm = FileMagic.new(FileMagic::MAGIC_MIME)
  if /^text/.match(fm.file(f))
    puts "Text file...looks good."
    return true
  else
    puts "File #{f} doesn't seem to be text/readable"
    return false
  end
end

def sanitize_input(opt)
  clean_input = Hash.new

  puts "Cleaning up input..."
  # Check if the file is exist.
  if ! sanitize_input_exist?(opt[:input_file])
    exit(1)
  end

  # Check if the file is text file !!!
  if ! sanitize_input_text?(opt[:input_file])
    exit(1)
  end

  # Check if comment is

  # Check if the given mode is make sense.

  clean_input = opt
  return clean_input

end

# Main
options = Parser.new do |p|
  p.banner = 'This is a assignment script for ABC-Tech, for the usage ~>'
  p.version = '0.1 alpha'
  p.option :comment_char, "Set comment character. wrapped by ''(# is default)", :default => '#'
  p.option :input_file, "Input file location. (this script is default)", :default => "#{__FILE__}"
  p.option :mode, "sync or async", :default => "sync"
  p.option :log_file, "path to file name", :default => "./count.log"
end.process!

#{:comment_char=>"#", :input_file=>"line_counter.rb", :mode=>"sync"}
clean_inputs = sanitize_input(options)

all_lines = read_to_mem(clean_inputs[:input_file])

# Scan through each line.
all_lines.each do |l|
  puts "=============="
  puts
  puts "==== #{l} ===="

  if is_blank?(l)
    count_output[:blank_line] = count_output[:blank_line] + 1
  end

  if is_comment?(l, clean_inputs[:comment_char])

  end


  puts "=============="
  puts
end

# Spit output.
puts count_output[:raw_line]
puts count_output[:blank_line]
