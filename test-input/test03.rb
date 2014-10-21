#!/usr/bin/env ruby
require_relative 'lib/analyzer'
require_relative 'lib/filer'
require 'micro-optparse'
require 'pp'

# Variables
lines = []

# Main
options = Parser.new do |p|
  p.banner = 'This is a assignment script for ABC-Tech, for the usage ~>'
  p.version = '0.1 alpha'
  p.option :comment_char, "Set comment character. wrapped by ''(# is default)", :default => '#'
  p.option :input_file, "Input file location. (this script is default)", :default => "#{__FILE__}"
  p.option :mode, "sync or async", :default => "sync"
  p.option :log_file, "path to file name", :default => "./count.log"
end.process!

pp options

analyzer = Analyzer.new
filer = Filer.new(options[:input_file], options[:mode])

case options[:mode]
  when 'sync'
    lines = filer.read_all
    analyzer.line_count = lines.count
  else
end

# if the first line is a shebang, we can save one if clause.
if analyzer.is_shebang?(lines[0])
  analyzer.code_lcount += 1
  lines.shift
end


lines.each do |l|

  puts "===== #{l} ====="

  if analyzer.is_blank?(l)
    analyzer.blank_lcount += 1
    puts "next at blank"
    analyzer.if_blank_lcount += 1
    next
  end

  if analyzer.is_comment_line?(l, options[:comment_char])
    analyzer.comment_lcount += 1
    puts "next at comment line"
    analyzer.if_comment_lcount += 1
    next
  end

  if analyzer.is_inline_comment?(l)
    analyzer.inline_comment_lcount += 1
    puts "next at code comment line"
    analyzer.if_inline_comment_lcount += 1
    next
  end

  analyzer.code_lcount += 1 # inline comment
  puts "reach to the code count" # inline comment

end

pp analyzer.inspect
