This script is responding to assignment from ABC-Tech. The main functionality is to counts how many lines of code
the program contains. In additon, the script also counts number of lines containing comments, and blank lines.


Quick Start
===========
1. Install libmagic library

   $ brew install libmagic

2. Install required gem (micro-optparse, ruby-filemagic, rspec)

   2.1 change directory to the directory that you have download/install the project.
   2.2 install required gem
        $ bundle install

3. The script will process the script itself as an input.

   3.1 run with default
        $ ruby counter.rb

   3.2 the script also provide help showing what can be change
        $ ruby counter.rb -h

        You should see

        This is an assignment script for ABC-Tech.

        Usage: ruby counter.rb -h
            -i, --input-file counter.rb      Input file location. (this script is default)
            -o, --output-format text         json|hash|text
            -c, --comment-char #             Set comment character. wrapped by ''(# is default)
            -l, --log-file /tmp/count.log    path to log file name
            -h, --help                       Show this message
            -v, --version                    Print version

4. Examples

    4.1 Process the script itself and log to /tmp/funcount.log

        $ ruby counter.rb -l /tmp/funcount.log

    4.2 Process the file name ./test-input/test03.rb (this file is packaged with the project),
        and write log to /tmp/funcount.log

        $ ruby counter.rb -i test-input/test03.rb -l /tmp/funcount.log

    4.3 Process the file name ./test-input/test03.rb, but using ';' as a comment character.

        $ ruby counter.rb -i test-input/test03.rb -c ';'

    4.4 Process with everything default but output in json

        $ ruby counter.rb -o json

5. Reading Output example

$ ruby counter.rb  -i test-input/test03.rb
Text file...looks good.
File test-input/test03.rb exists...looks good
01.Input.File.Name:...............test-input/test03.rb
02.Number.of.Lines:.................................69
03.Line.of.Codes:...................................51  **
04.Blank.Lines:.....................................15
05.Comment.Lines:....................................3
06.Code.Line.with.Comment:...........................2  **
07.Log.File.Name:......................./tmp/count.log
08.Time.Start:...............2014-10-20.22:04:48.+0700
09.Time.Stop:................2014-10-20.22:04:48.+0700
10.Execution.Time:............................0.001316


1. input file test-input/test03.rb
2. Total line count in this file is 69 lines
    $ wc -l test-input/test03.rb
          69 test-input/test03.rb

** 3. Line of code = code line(without comment) + Code.Line.with.Comment(2)
      51 = code line (without comment) + 2.

      So, code line (without comment) = 49 lines

4. Blank Line = 15
5. Comment only = 3
6. Code with comment = 2

So 69 = code line (without comment) + blank line + comment line + code line with comment
      = 49 + 15 + 3 + 2


System Settings
===============

This script was written and tested in the following settings.

1. Mac OS X 10.9.5
2. Ruby 2.1.3p242 (2014-09-19 revision 47630) [x86_64-darwin13.0] on rbenv 0.4.0-98-g13a474c
3. libmagic-5.19
4. Gems: micro-optparse, ruby-filemagic, rspec


Details
=======

Components
----------

There are 2 main components in this project that do the heavy lifting: class Analyzer (lib/analyzer.rb) and counter.rb script.

1. Analyzer class is responsible for:

1.1	Classify each line of input if the line is blank line, comment line, code line, or code line with comment.

1.2	Instance variables of Analyzer class collects counting statistics of each type of processed input line.

    @line_count ->
      counter keeps how many lines have been processed.

    @code_lcount ->
      counter keeps how many lines of code _including_ the line that code and comment are in the same line.
      eg. puts "hello world" and puts "hello sir" # comment
      both are falling into to this category.

    @blank_lcount ->
      counter keeps how many blank line have been processed.

    @comment_lcount ->
      counter keeps how many lines that are comment lines (just comment).
      eg.   # here is comment line

    @inline_comment_lcount -> counter keep how many lines that code and comment are in the same line
      (subtract this number from code_lcount will get the number of code line that does not have comment
      in the same line)

      eg. puts "code is here" # comment is here.
      note: it has to have one or more space after hash(or comment character)

    @input_file_name ->
      keep file name of input file being processed.

    @log_file_name ->
      keep file name of log file in current processing session.

    @ts_start ->
      keep time stamp of start time (start loop through each line of input file)

    @ts_stop ->
      keep time stamp of finished time


1.3	Generate output or report after finish processing input file.
    Output can be in format of hash, json, or formatted text.

    .to_json ->
      ex. analyzer.to_json will dump all the object's instance variables and injects duration time
      (how long processing takes) as a part of returning value in json format.

      $ ruby counter.rb -i test-input/test03.rb -o jSon
      Text file...looks good.
      File test-input/test03.rb exists...looks good
      "\"{\\\"line_count\\\":69,\\\"code_lcount\\\":51,\\\"blank_lcount\\\":15, ... clipped ...

    .to_hash ->
      ex. analyzer.to_hash will dump, returns all counters and injects duration in a hash.

      $ ruby counter.rb -i test-input/test03.rb -o haSH
      Text file...looks good.
      File test-input/test03.rb exists...looks good
      "{\"line_count\"=>69, \"code_lcount\"=>51, \"blank_lcount\"=>15, \"comment_lcount\"=>3,

    .to_text  ->
      ex. analyzer.to_text returns all counters as above including human-friendly label in an array.

      $ ruby counter.rb -i test-input/test03.rb -o text

      Text file...looks good.
      File test-input/test03.rb exists...looks good
      01.Input.File.Name:...............test-input/test03.rb
      02.Number.of.Lines:.................................69
      03.Line.of.Codes:...................................51
      04.Blank.Lines:.....................................15
      05.Comment.Lines:....................................3
      06.Code.Line.with.Comment:...........................2
      07.Log.File.Name:......................./tmp/count.log
      08.Time.Start:...............2014-10-20.19:42:19.+0700
      09.Time.Stop:................2014-10-20.19:42:19.+0700
      10.Execution.Time:.............................0.00096


1.4 Inline comment, prologue comment(not cover) [4]

  prologue comment is _not_ support here as because in different language it use diffrent convention
  ..well even in the same language - ruby see [5]

  = begin
  Lorem ipsum dolor sit amet, consectetur adipisicing elit. At dolorem et illum mo
  ipsum dolor sit amet, consectetur adipisicing elit. At dolorem et illum mo
  = end

  Inline comment
  eg. put "Hello World" # Comment
  This script can handle inline comment; however, with some known limitation.

  1. There must be one or more white-space between '#'(or comment character) and the beginning of comment
     eg.
     puts "code is #{here}" # begining of comment

  2. The ' or " cannot be apart of the comment. Resulting from some cases where hash character(s)
     is/are apart the code, but this is just a line of code.

     eg 1. puts "grab me a # #####cup"

     This is not inline comment. With the convention (comment must not contain ' or "), the regex will
     not think that # #####cup" is comment


     eg 2. puts "broken code   # comment doubleqoute is " and single quote is '

     Without this convention the script will not be able to decide if

     1. It is the (broken code) with inline comment
     broken code: puts "broken code <----(missing double quote)
     inline comment: # comment doubleqoute is " and single quote is '

     OR

     2. It is complete code with fraction of text which is not even comment.
     complete code: puts "broken code   # comment doubleqoute is "
     fraction of text: and single quote is '


2. The counter.rb script

2.1	Consume class Analyzer for categorizing type of input line.

2.2 Validate input from a user
    2.2.1. verify if the file does exist
    eg. $ ruby counter.rb -i test-input/test99.rb
        File test-input/test99.rb does not exist or it is directory...exit

    2.2.2. verify if the given input from user is a file no a directory
    eg. $ ruby counter.rb -i ../ABC-Tech
        File ../ABC-Tech does not exist or it is directory...exit

    2.2.3. verify if the file is not empty, not binary, not data, nor directory.
    eg. $ ruby counter.rb -i test-input/zero
        File test-input/zero doesn't seem to be text/readable...exit

2.3	While the script has defaults value to operate, it allows a user adjust some options
    eg. comment character (# as default), input file (the script itself as default),
    log file (/tmp/count.log as default), output format(text as default)

2.4 Writing log, the script keeps how it decides when process each line.

    excerpted log file
    .....
    [20/10/2014 19:50:10] | SHEBANG=CODE |>#!/usr/bin/env ruby<-
    [20/10/2014 19:50:10] | CODE |>require_relative 'lib/analyzer'<-
    [20/10/2014 19:50:10] | CODE |>require_relative 'lib/filer'<-
    [20/10/2014 19:50:10] | CODE |>require 'micro-optparse'<-
    [20/10/2014 19:50:10] | CODE |>require 'pp'<-
    [20/10/2014 19:50:10] | BLANK |><-
    [20/10/2014 19:50:10] | COMMENT |># Variables<-
    [20/10/2014 19:50:10] | CODE |>lines = []<-
    [20/10/2014 19:50:10] | BLANK |><-
    [20/10/2014 19:50:10] | COMMENT |># Main<-
    .....

3.0 Test TDD, rspec is being used to conduct unit test against each function in Analyzer class.

    $ rspec -fd spec/analyzer_spec.rb

    Analyzer
      a should be an instance an Analyzer
      a should have all zero at init.
      is_shebang? should return true with #!/usr/bin/env
      is_shebang? should return false line isn't shebang
      has_hash? should return true when input line contains # character
      has_hash? should return false when input line does not contain # character
      is_blank? should return true with white-char eg. tab newline
      is_blank? should return false with non_blank_line
      is_comment_line? should return true when comment line starts
          with (optionally white space) comment character
      is_comment_line? should return false when comment line start
          with non-white-char
      is_inline_comment should return true when a line is code + # comment
      is_inline_comment should return false
      to_hash should converts Analyzer object to hash
      to_json should converts Analyzer object to json
      to_text should converts Analyzer object to array of text

    Finished in 0.01607 seconds (files took 0.13734 seconds to load)
    15 examples, 0 failures


Performance
===========

With help from Ruby's Benchmark module
1. regex and logging can be bottleneck.

   /^\s*#{c}\s/.match(l)
   b:comment
   1 b:comment line  0.000000   0.000000   0.000000 (  0.000033)
   2 b:comment line  0.000000   0.000000   0.000000 (  0.000036)
   3 b:comment line  0.000000   0.000000   0.000000 (  0.000031)
   4 b:comment line  0.000000   0.000000   0.000000 (  0.000029)
   5 b:comment line  0.000000   0.000000   0.000000 (  0.000034)
   6 b:comment line  0.000000   0.000000   0.000000 (  0.000035)
   7 b:comment line  0.000000   0.000000   0.000000 (  0.000044)
   8 b:comment line  0.000000   0.000000   0.000000 (  0.000038)
   9 b:comment line  0.000000   0.000000   0.000000 (  0.000028)

   If we give up the feature that we can define different comment character, so we can hard code hash
   in regex. we can improve a little bit.

   if /^\s*\#\s/.match(l)
   b:comment
   1 b:comment line  0.000000   0.000000   0.000000 (  0.000020)
   2 b:comment line  0.000000   0.000000   0.000000 (  0.000050)
   3 b:comment line  0.000000   0.000000   0.000000 (  0.000015)
   4 b:comment line  0.000000   0.000000   0.000000 (  0.000009)
   5 b:comment line  0.000000   0.000000   0.000000 (  0.000009)
   6 b:comment line  0.000000   0.000000   0.000000 (  0.000032)
   7 b:comment line  0.000000   0.000000   0.000000 (  0.000006)
   8 b:comment line  0.000000   0.000000   0.000000 (  0.000008)
   9 b:comment line  0.000000   0.000000   0.000000 (  0.000007)

   Howerver, if we give up both capability to use different comment character _AND_ logging the processing trail.
   It's even faster.

   b:comment
   1 b:comment line  0.000000   0.000000   0.000000 (  0.000020)
   2 b:comment line  0.000000   0.000000   0.000000 (  0.000006)
   3 b:comment line  0.000000   0.000000   0.000000 (  0.000005)
   4 b:comment line  0.000000   0.000000   0.000000 (  0.000008)
   5 b:comment line  0.000000   0.000000   0.000000 (  0.000008)
   6 b:comment line  0.000000   0.000000   0.000000 (  0.000005)
   7 b:comment line  0.000000   0.000000   0.000000 (  0.000005)
   8 b:comment line  0.000000   0.000000   0.000000 (  0.000007)
   9 b:comment line  0.000000   0.000000   0.000000 (  0.000007)


2.  Line-by-line I/O (non blocking?), the script will fetch line by line in the given input file
    without any need to read every line into memory before starts processing. [1]
    When processing a small input file, it will not show any difference.
    However, an input file starts at 1G or larger in size reflects larger
    differences between line-by-line and fetch it all.

    eg. misc/block.rb vs misc/non-block.rb

    Purely count number of lines of 1 GB file (46,095,864 lines) [2]
    18 sec vs. 38 sec.

    $ time ruby non-block.rb
    non-block 46095864

    real	0m18.115s
    user	0m16.907s
    sys	0m0.842s

    $ time ruby block.rb
    block 46095864

    real	0m38.510s
    user	0m32.958s
    sys	0m4.367s


    Purely count number of lines of 4 GB file [3]
    1m 16sec vs. 6m 46sec

    $ time ruby non-block.rb
    non-block 184383456

    real	1m16.744s
    user	1m13.790s
    sys	0m2.655s

    $ time ruby block.rb
    block 184383456

    real	6m46.360s
    user	6m25.406s
    sys	0m19.170s


Manifest
========

ABC-Tech/
├── Gemfile
├── Gemfile.lock
├── README
├── TODO
├── counter.rb
├── lib
│   └── analyzer.rb
├── misc
│   ├── block.rb
│   ├── counter-bench.rb
│   ├── line_counter.rb
│   └── non-block.rb
├── spec
│   ├── analyzer_spec.rb
│   └── spec_helper.rb
└── test-input
    ├── test01.txt
    ├── test02.txt
    ├── test03.rb
    └── zero

Gemfile - list required gem
README - this file
counter.rb - the script that user will work with
lib/analyzer.rb - provide class Analyzer that is consumed by counter.rb
spec/analyzer_spec.rb - spec file for analyzer.rb
test-input/test01.txt - random simple input
test-input/test02.txt - empty file which the script should exit
test-input/test03.rb -  a ruby script that can be used as input.
test-input/zero - zero length file
misc/counter-bench.rb - similar to counter.rb script, but with some debugs message
                    and benchmark block surrounding each code block.
misc/block.rb - counts line by IO blocking
misc/non-block.rb - counts line by non-blocking IO


Reference
=========

1. http://stackoverflow.com/questions/5545068/what-are-all-the-common-ways-to-read-a-file-in-ruby/5545284#5545284,
    and http://stackoverflow.com/questions/1727217/file-open-open-and-io-foreach-in-ruby-what-is-the-difference
2. test-input/test04.rb is 1GB in size was not included in deliverable.
3. test-input/test06.rb is 4GB in size was not included in deliverable.
4. http://en.wikipedia.org/wiki/Comment_(computer_programming)
5. http://stackoverflow.com/questions/2989762/how-can-i-comment-multiple-lines-in-ruby
