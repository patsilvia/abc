#!/usr/bin/env ruby
require_relative 'lib/analyzer'
require 'micro-optparse'
require 'filemagic'
require 'date'
require 'pp'
require 'benchmark'

# Variables

# Functions
def log_it(f, msg)
  f.puts '[' + Time.now.strftime("%d/%m/%Y %H:%M:%S").to_s + "] " + msg
end

def validate_input(f)
  if f == __FILE__
    puts "Counting myself...OK"
    return true
  else
    if ( !(File.directory?(f)) and (File::exists?(f)) )
      if is_text?(f)
        puts "File #{f} exists...looks good"
        return true
      else
        exit(1)
      end
    else
      puts "File #{f} does not exist or it is directory...exit"
      exit(1)
    end
  end
end

def is_text?(f)
  fm = FileMagic.new(FileMagic::MAGIC_MIME)
  if /^text/.match(fm.file(f))
    puts "Text file...looks good."
    return true
  else
    puts "File #{f} doesn't seem to be text/readable...exit"
    return false
  end
end

# Main
options = Parser.new do |p|

  p.banner = "This is an assignment script for ABC-Tech. \n\nUsage: ruby #{__FILE__} -h"

  p.version = '0.2 alpha'
  p.option :input_file, "Input file location. (this script is default)", :default => "#{__FILE__}"
  p.option :output_format, "json|hash|text", :default => "text", :value_matches => /\A(json|hash|text)\Z/i
  p.option :comment_char, "Set comment character. wrapped by ''(# is default)", :default => '#'
  p.option :log_file, "path to log file name", :default => "/tmp/count.log"
end.process!

validate_input(options[:input_file])
log_file = File.open(options[:log_file], 'a')
analyzer = Analyzer.new(options[:input_file], options[:log_file])
f = File.open(options[:input_file], 'r')

analyzer.ts_start = Time.now
f.each_line do |l| # each_line offers non-block

  analyzer.line_count += 1

  Benchmark.bm(8) do |x|
  if analyzer.has_hash?(l)

    x.report("b:shebang") {
      # comment, inline comment, code
      if analyzer.is_shebang?(l)
        analyzer.code_lcount += 1
        log_it(log_file, '| SHEBANG=CODE |>' + l.chomp() + '<-')
        #puts "next at shebang"
        next
      end
    }

    x.report("b:comment line") {
    if analyzer.is_comment_line?(l, options[:comment_char])
      analyzer.comment_lcount += 1
      #log_it(log_file, '| COMMENT |>' + l.chomp() + '<-')
      #puts "next at comment line"
      next
    end
    }

    x.report("b:inline comment") {
    # inline comment = a line of code that has a comment in the same line.
    # This script will bump up both comment inline and code counter.
    if analyzer.is_inline_comment?(l, options[:comment_char])
      analyzer.inline_comment_lcount += 1
      analyzer.code_lcount += 1
      log_it(log_file, '| INLINE-COMMENT, CODE |>' + l.chomp() + '<-')
      #puts "next at code comment line"
      next
    end
    }

    x.report("b:upper code") {
      # code line
      analyzer.code_lcount += 1
      log_it(log_file, '| UPPER CODE |>' + l.chomp() + '<-')
      #puts "reach to the upper code count"
    }

  else

    x.report("b:is_blank") {
    # code, blank
    if analyzer.is_blank?(l)
      analyzer.blank_lcount += 1
      log_it(log_file, '| BLANK |>' + l.chomp() + '<-')
      #puts "next at blank"
      next
    end
    }

    x.report("b:below code") {
    # code line
    analyzer.code_lcount += 1
    log_it(log_file, '| CODE |>' + l.chomp() + '<-')
    #puts "reach to the lower code count"
    }

  end # if has_hash
 end # Benchmark

end # f.each_line

analyzer.ts_stop = Time.now

f.close
log_file.close

case options[:output_format]
  when /hash/i
    h = analyzer.to_hash
    p h.inspect
  when /json/i
    j = analyzer.to_json
    p j.inspect
  when /text/i
    t = analyzer.to_text
    puts t.join("\n")
  else
    puts "not sure how you get here! - #{options[:output_format]}"

end