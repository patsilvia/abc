require_relative './spec_helper'

describe Analyzer do

  before :all do
    @a = Analyzer.new('./counter.rb', '/tmp/analyzer_spec.log')
  end

  # examples  start here.
  it "a should be an instance an Analyzer" do
    expect(@a).to be_instance_of(Analyzer)
  end

  it "a should have all zero at init." do
    expect(@a.line_count).to equal(0)
    expect(@a.blank_lcount).to equal(0)
    expect(@a.comment_lcount).to equal(0)
    expect(@a.inline_comment_lcount ).to equal(0)
    expect(File.exist?(@a.input_file_name)).to be_truthy
    expect(File.exist?(@a.log_file_name)).to be_truthy
    expect(@a.ts_start).to equal(0)
    expect(@a.ts_stop).to equal(0)
  end

  it "is_shebang? should return true with #!/usr/bin/env" do
    expect(@a.is_shebang?('#!/usr/bin/env ruby')).to be_truthy
  end

  it "is_shebang? should return false line isn't shebang" do
    expect(@a.is_shebang?(' #!/usr/bin/env ruby')).to be_falsey
    expect(@a.is_shebang?('##!/usr/bin/env ruby')).to be_falsey
    expect(@a.is_shebang?('!#!/usr/bin/env ruby')).to be_falsey
    expect(@a.is_shebang?(' !#/usr/bin/env ruby')).to be_falsey
    expect(@a.is_shebang?('/usr/bin/env ruby')).to be_falsey
  end

  it "has_hash? should return true when input line contains # character" do
    expect(@a.has_hash?('blah # blah')).to be_truthy
    expect(@a.has_hash?('#blah # blah')).to be_truthy
    expect(@a.has_hash?('blah blah#')).to be_truthy
  end

  it "has_hash? should return false when input line does not contain # character" do
    expect(@a.has_hash?('blah blah')).to be_falsey
    expect(@a.has_hash?('!blah blah')).to be_falsey
  end

  it "is_blank? should return true with white-char eg. tab newline" do
    expect(@a.is_blank?("\t\t  \n")).to be_truthy
    expect(@a.is_blank?("\t\t..outlaw non white..\n")).to be_falsey
  end

  it "is_blank? should return false with non_blank_line" do
    expect(@a.is_blank?("non blank line string\n")).to be_falsey
  end

  it "is_comment_line? should return true when comment line starts
      with (optionally white space) comment character" do
    expect(@a.is_comment_line?("# # ascomment.", '#')).to be_truthy
    expect(@a.is_comment_line?("\t  # # ascomment.", '#')).to be_truthy
  end

  it "is_comment_line? should return false when comment line start
      with non-white-char" do
    expect(@a.is_comment_line?("deal breaker  # # ascomment.", '#')).to be_falsey
    expect(@a.is_comment_line?("not comment # # ascomment.", '#')).to be_falsey
  end

  it "is_inline_comment should return true when a line is code + # comment" do
    expect(@a.is_inline_comment?('puts "hello world" # comment is here', '#')).to be_truthy
    expect(@a.is_inline_comment?(%q<puts "x' # '"''" # ma#{}ker>, '#')).to be_truthy
  end

  it "is_inline_comment should return false" do
    expect(@a.is_inline_comment?(%q<puts "grab me' 'a # cup" #commsdlfjad>, '#')).to be_falsey
    expect(@a.is_inline_comment?(%q<puts "grab me' 'a # cup"# commsdlfjad>, '#')).to be_falsey
    expect(@a.is_inline_comment?(%q<puts "broken code   # doubleqoute is " and single quote is '>, '#')).to be_falsey
    expect(@a.is_inline_comment?(%q< # cup"#commsdlfjad>, '#')).to be_falsey
    expect(@a.is_inline_comment?('puts "hello # ##world"', '#')).to be_falsey
    expect(@a.is_inline_comment?('puts "hello world" # comment" is here', '#')).to be_falsey
    expect(@a.is_inline_comment?('puts "hello world" # comment\' is here', '#')).to be_falsey

  end

  it "to_hash should converts Analyzer object to hash" do
    @a.line_count = 1
    @a.code_lcount = 1
    @a.blank_lcount = 1
    @a.comment_lcount = 1
    @a.inline_comment_lcount = 1
    @a.input_file_name = 'input_file.rb'
    @a.log_file_name = 'log_file.log'
    @ts_start = 1
    @ts_stop = 10

    h = @a.to_hash

    expect(@a.line_count).to eq(h['line_count'])
    expect(@a.code_lcount).to eq(h['code_lcount'])
    expect(@a.blank_lcount).to eq(h['blank_lcount'])
    expect(@a.comment_lcount).to eq(h['comment_lcount'])
    expect(@a.inline_comment_lcount).to eq(h['inline_comment_lcount'])
    expect(@a.input_file_name).to eq(h['input_file_name'])
    expect(@a.ts_start).to eq(h['ts_start'])
    expect(@a.ts_stop).to eq(h['ts_stop'])

    expect(@a.to_hash.keys.count).to eq(@a.instance_variables.count + 1)
    expect(@a.to_hash.class.to_s).to eq("Hash")
  end

  it "to_json should converts Analyzer object to json" do
    require 'json'
    expect(@a.to_json.class.to_s).to eq("String")
    expect(JSON.parse(@a.to_json).class.to_s).to eq("Hash")
  end

  it "to_text should converts Analyzer object to array of text" do
    @a.line_count = 1
    @a.code_lcount = 1
    @a.blank_lcount = 1
    @a.comment_lcount = 1
    @a.inline_comment_lcount = 1
    @a.input_file_name = 'input_file.rb'
    @a.log_file_name = 'log_file.log'
    @a.ts_start = 1
    @a.ts_stop = 10

    t = @a.to_text

    expect(t.class.to_s).to eq("Array")
    expect(t[0]).to match(/input_file.rb$/)
    expect(t[1]).to match(/1$/)
    expect(t[2]).to match(/1$/)
    expect(t[3]).to match(/1$/)
    expect(t[4]).to match(/1$/)
    expect(t[5]).to match(/1$/)
    expect(t[6]).to match(/log_file.log$/)
    expect(t[7]).to match(/1$/)
    expect(t[8]).to match(/10$/)

  end
end