class Analyzer

  attr_accessor :line_count, :code_lcount, :blank_lcount, :comment_lcount,
                :inline_comment_lcount, :input_file_name, :log_file_name, :ts_start, :ts_stop

  def initialize(input_file, log_file)
    @line_count = 0
    @code_lcount = 0
    @blank_lcount = 0
    @comment_lcount = 0
    @inline_comment_lcount = 0
    @input_file_name = input_file
    @log_file_name = log_file
    @ts_start = 0
    @ts_stop = 0
  end

  #-------#
  public
  #-------#

  def is_shebang?(l)
    if /^#!.+?/.match(l)
      return true
    end

    return false
  end

  def has_hash?(l)
    if /#/.match(l)
      return true
    else
      return false
    end
  end

  # method is_blank check if a line has non-white space character.
  def is_blank?(l)
    if /\S/.match(l) #match non-white space
      return false
    else
      return true
    end
  end

  def is_comment_line?(l, c)
    # case: a comment line that begins with whitespace.
    #if /^\s*\#\s/.match(l)
    if /^\s*#{c}\s/.match(l)
      return true
    end

  end

  def is_inline_comment?(l, c)
    # TODO: code can be improve and should to catch many possible
    #   corner cases.
    #   More details see README
    #   1.4 Inline comment vs. prologue comment(not cover)

    # hardcode and backreference if m = /(?<code>.+)\s{1,}(?<comment>\#\s{1,}[^'"]*$)/.match(l) #m[:comment]
    # fastest!! if /[^\s]+\s{1,}\#\s{1,}[^'"]*$/.match(l)
    # with backreference!! if m = /(?<code>.+)\s{1,}(?<comment>#{c}\s{1,}[^'"]*$)/.match(l)
    if /[^\s]+\s{1,}#{c}\s{1,}[^'"]*$/.match(l)
      return true
    else
      return false
    end
  end

  def to_json
    require 'json'

    j = self.to_hash
    return j.to_json
  end

  def to_hash
    h = Hash.new

    self.instance_variables.each do |var|
      b = var.to_s
      b[0] = ''
      h[b] = self.instance_variable_get(var)
    end
    h['duration'] = self.ts_stop - self.ts_start
    return h
  end

  def to_text
    count = 1
    t = Array.new

    h = self.to_hash
    label = {
        'Input File Name:'     => 'input_file_name',
        'Number of Lines:'  => 'line_count',
        'Line of Codes:'    => 'code_lcount',
        'Blank Lines:'      =>  'blank_lcount',
        'Comment Lines:'    =>  'comment_lcount',
        'Code Line with Comment: ' => 'inline_comment_lcount',
        'Log File Name:'     => 'log_file_name',
        'Time Start:'        =>  'ts_start',
        'Time Stop:'         =>  'ts_stop',
        'Execution Time:'     => 'duration'
    }
    label.each do |l, i|
      report = sprintf("%02d %-25s %25s", count, l, h[i])
      t << report.gsub(/\s/, '.')
      count += 1
    end
    return t
  end

  #-------#
  private
  #-------#

end # end Analyzer class
