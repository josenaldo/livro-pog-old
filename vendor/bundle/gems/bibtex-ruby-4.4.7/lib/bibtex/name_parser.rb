#
# DO NOT MODIFY!!!!
# This file is automatically generated by Racc 1.4.14
# from Racc grammer file "".
#

require 'racc/parser.rb'

require 'strscan'

module BibTeX
  class NameParser < Racc::Parser

module_eval(<<'...end names.y/module_eval...', 'names.y', 116)

  @patterns = {
    :and => /,?\s+and\s+/io,
    :space => /\s+/o,
    :comma => /,/o,
    :lower => /[[:lower:]][[:lower:][:upper:]]*/uo,
    :upper => /[[:upper:]][[:lower:][:upper:].]*/uo,
    :other => /[^\s,\{\}\\[:upper:][:lower:]]+/uo,
    :lbrace => /\{/o,
    :rbrace => /\}/o,
    :braces => /[\{\}]/o,
    :escape => /\\./o,
    :last_first => /[\p{Han}\p{Hiragana}\p{Katakana}\p{Hangul}]/uo
  }

  class << self
    attr_reader :patterns
  end

  def initialize(options = {})
    self.options.merge!(options)
  end

  def options
    @options ||= { :debug => ENV['DEBUG'] == true }
  end

  def parse(input)
    @yydebug = options[:debug]
    scan(input)
    do_parse
  end

  def next_token
    @stack.shift
  end

  def on_error(tid, val, vstack)
    BibTeX.log.debug("Failed to parse BibTeX Name on value %s (%s) %s" % [val.inspect, token_to_str(tid) || '?', vstack.inspect])
  end

  def scan(input)
    @src = StringScanner.new(input)
    @brace_level = 0
    @last_and = 0
    @stack = [[:ANDFL,'(^start)']]
    @word = [:PWORD,'']
    do_scan
  end

  private

  def do_scan
    until @src.eos?
      case
      when @src.scan(NameParser.patterns[:and])
        push_word
        @last_and = @stack.length
        @stack.push([:ANDFL,@src.matched])

      when @src.skip(NameParser.patterns[:space])
        push_word

      when @src.scan(NameParser.patterns[:comma])
        push_word
        @stack.push([:COMMA,@src.matched])

      when @src.scan(NameParser.patterns[:lower])
        is_lowercase
        @word[1] << @src.matched

      when @src.scan(NameParser.patterns[:upper])
        is_uppercase
        @word[1] << @src.matched

      when @src.scan(NameParser.patterns[:other])
        check_name_order
        @word[1] << @src.matched

      when @src.scan(NameParser.patterns[:lbrace])
        @word[1] << @src.matched
        scan_literal

      when @src.scan(NameParser.patterns[:rbrace])
        error_unbalanced

      when @src.scan(NameParser.patterns[:escape])
        @word[1] << @src.matched

      else
        error_invalid
      end
    end

    push_word
    @stack
  end

  def push_word
    unless @word[1].empty?
      @stack.push(@word)
      @word = [:PWORD,'']
    end
  end

  def is_lowercase
    @word[0] = :LWORD if @word[0] == :PWORD
  end

  def is_uppercase
    @word[0] = :UWORD if @word[0] == :PWORD
  end

  def check_name_order
    return if RUBY_VERSION < '1.9'
    @stack[@last_and][0] = :ANDLF if @stack[@last_and][0] != :ANDLF && @src.matched =~ NameParser.patterns[:last_first]
  end

  def scan_literal
    @brace_level = 1

    while @brace_level > 0
      @word[1] << @src.scan_until(NameParser.patterns[:braces]).to_s

      case @src.matched
      when '{'
        @brace_level += 1
      when '}'
        @brace_level -= 1
      else
        @brace_level = 0
        error_unbalanced
      end
    end
  end

  def error_unexpected
    @stack.push [:ERROR,@src.matched]
    BibTeX.log.warn("NameParser: unexpected token `#{@src.matched}' at position #{@src.pos}; brace level #{@brace_level}.")
  end

  def error_unbalanced
    @stack.push [:ERROR,'}']
    BibTeX.log.warn("NameParser: unbalanced braces at position #{@src.pos}; brace level #{@brace_level}.")
  end

  def error_invalid
    @stack.push [:ERROR,@src.getch]
    BibTeX.log.warn("NameParser: invalid character at position #{@src.pos}; brace level #{@brace_level}.")
  end

# -*- racc -*-
...end names.y/module_eval...
##### State transition tables begin ###

racc_action_table = [
   -22,     6,   -25,   -24,    42,   -37,   -22,   -22,    56,   -24,
   -24,   -37,   -37,   -37,    42,   -25,   -38,    34,   -39,   -37,
   -37,   -24,   -38,   -38,   -39,   -39,    54,   -24,   -24,   -22,
    26,   -25,   -20,   -20,   -20,   -22,   -22,   -26,    24,    51,
    25,   -26,    24,    40,    25,    24,    43,    25,    49,    48,
    50,    49,    48,    50,    24,    37,    25,    49,    48,    50,
    16,    14,    17,    24,    23,    25,    49,    48,    50,    16,
    29,    17,    24,    32,    25,    24,    37,    25,    24,    32,
    25,    49,    48,    50,     4,     5,     4,     5,    54 ]

racc_action_check = [
    23,     1,    23,    51,    36,    29,    23,    23,    45,    51,
    51,    29,    29,    14,    31,    14,    16,    13,    17,    14,
    14,    40,    16,    16,    17,    17,    53,    40,    40,    37,
     6,    37,    32,    32,    32,    37,    37,    38,    38,    38,
    38,    21,    21,    21,    21,    33,    33,    33,    34,    34,
    34,    42,    42,    42,    20,    20,    20,    56,    56,    56,
     4,     4,     4,     5,     5,     5,    54,    54,    54,    10,
    10,    10,    11,    11,    11,    39,    39,    39,    28,    28,
    28,    47,    47,    47,     0,     0,     2,     2,    41 ]

racc_action_pointer = [
    78,     1,    80,   nil,    57,    60,    30,   nil,   nil,   nil,
    66,    69,   nil,    15,    13,   nil,    16,    18,   nil,   nil,
    51,    39,   nil,     0,   nil,   nil,   nil,   nil,    75,     5,
   nil,    12,    29,    42,    45,   nil,     2,    29,    35,    72,
    21,    86,    48,   nil,   nil,     6,   nil,    78,   nil,   nil,
   nil,     3,   nil,    24,    63,   nil,    54,   nil,   nil,   nil ]

racc_action_default = [
    -1,   -40,    -2,    -3,   -40,   -40,   -40,    -4,    -5,    -7,
   -26,   -40,   -11,   -40,   -19,   -29,   -31,   -32,    -6,   -12,
   -40,   -23,   -15,   -19,   -31,   -32,    60,    -8,   -40,   -19,
   -30,   -10,   -25,   -26,   -35,   -13,   -40,   -20,   -23,   -40,
   -19,    -9,   -35,   -21,   -16,   -27,   -33,   -36,   -37,   -38,
   -39,   -21,   -14,   -40,   -35,   -17,   -35,   -34,   -18,   -28 ]

racc_goto_table = [
     9,    10,    21,    19,    30,    31,    27,     3,    44,     7,
    12,    22,     1,    59,    36,    30,    55,    38,    35,     2,
     8,    18,    41,    11,    20,   nil,   nil,    30,    58,    28,
   nil,   nil,    30,    53,   nil,   nil,    38,    52,   nil,   nil,
    39,   nil,   nil,    57 ]

racc_goto_check = [
     6,     7,     7,    11,    14,     9,     6,     3,    12,     3,
    10,    10,     1,    13,     9,    14,    12,     7,    11,     2,
     4,     5,     9,     8,     8,   nil,   nil,    14,    12,     8,
   nil,   nil,    14,     9,   nil,   nil,     7,    11,   nil,   nil,
     8,   nil,   nil,     6 ]

racc_goto_pointer = [
   nil,    12,    19,     7,    16,    16,    -4,    -3,    19,    -6,
     6,    -2,   -26,   -43,    -6,   nil ]

racc_goto_default = [
   nil,   nil,   nil,   nil,   nil,   nil,    46,    33,   nil,    13,
   nil,   nil,   nil,    45,    15,    47 ]

racc_reduce_table = [
  0, 0, :racc_error,
  0, 10, :_reduce_1,
  1, 10, :_reduce_none,
  1, 11, :_reduce_3,
  2, 11, :_reduce_4,
  2, 12, :_reduce_5,
  2, 12, :_reduce_6,
  1, 13, :_reduce_7,
  2, 13, :_reduce_8,
  3, 13, :_reduce_9,
  2, 13, :_reduce_10,
  1, 13, :_reduce_none,
  1, 14, :_reduce_12,
  2, 14, :_reduce_13,
  3, 14, :_reduce_14,
  1, 14, :_reduce_none,
  3, 19, :_reduce_16,
  4, 19, :_reduce_17,
  5, 19, :_reduce_18,
  1, 17, :_reduce_none,
  2, 17, :_reduce_20,
  3, 17, :_reduce_21,
  1, 20, :_reduce_22,
  1, 20, :_reduce_23,
  2, 20, :_reduce_24,
  1, 18, :_reduce_none,
  1, 18, :_reduce_26,
  1, 21, :_reduce_27,
  3, 21, :_reduce_28,
  1, 16, :_reduce_29,
  2, 16, :_reduce_30,
  1, 23, :_reduce_none,
  1, 23, :_reduce_none,
  1, 24, :_reduce_none,
  2, 24, :_reduce_34,
  0, 22, :_reduce_none,
  1, 22, :_reduce_none,
  1, 15, :_reduce_none,
  1, 15, :_reduce_none,
  1, 15, :_reduce_none ]

racc_reduce_n = 40

racc_shift_n = 60

racc_token_table = {
  false => 0,
  :error => 1,
  :COMMA => 2,
  :UWORD => 3,
  :LWORD => 4,
  :PWORD => 5,
  :ANDFL => 6,
  :ANDLF => 7,
  :ERROR => 8 }

racc_nt_base = 9

racc_use_result_var = true

Racc_arg = [
  racc_action_table,
  racc_action_check,
  racc_action_default,
  racc_action_pointer,
  racc_goto_table,
  racc_goto_check,
  racc_goto_default,
  racc_goto_pointer,
  racc_nt_base,
  racc_reduce_table,
  racc_token_table,
  racc_shift_n,
  racc_reduce_n,
  racc_use_result_var ]

Racc_token_to_s_table = [
  "$end",
  "error",
  "COMMA",
  "UWORD",
  "LWORD",
  "PWORD",
  "ANDFL",
  "ANDLF",
  "ERROR",
  "$start",
  "result",
  "names",
  "name",
  "flname",
  "lfname",
  "word",
  "u_words",
  "von",
  "last",
  "comma",
  "lastfirst",
  "first",
  "opt_words",
  "u_word",
  "words" ]

Racc_debug_parser = false

##### State transition tables end #####

# reduce 0 omitted

module_eval(<<'.,.,', 'names.y', 31)
  def _reduce_1(val, _values, result)
     result = [] 
    result
  end
.,.,

# reduce 2 omitted

module_eval(<<'.,.,', 'names.y', 33)
  def _reduce_3(val, _values, result)
     result = [val[0]] 
    result
  end
.,.,

module_eval(<<'.,.,', 'names.y', 34)
  def _reduce_4(val, _values, result)
     result << val[1] 
    result
  end
.,.,

module_eval(<<'.,.,', 'names.y', 36)
  def _reduce_5(val, _values, result)
     result = Name.new(val[1]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'names.y', 37)
  def _reduce_6(val, _values, result)
     result = Name.new(val[1]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'names.y', 41)
  def _reduce_7(val, _values, result)
               result = { :last => val[0] }
         
    result
  end
.,.,

module_eval(<<'.,.,', 'names.y', 45)
  def _reduce_8(val, _values, result)
               result = { :first => val[0].join(' '), :last => val[1] }
         
    result
  end
.,.,

module_eval(<<'.,.,', 'names.y', 49)
  def _reduce_9(val, _values, result)
               result = { :first => val[0].join(' '), :von => val[1], :last => val[2] }
         
    result
  end
.,.,

module_eval(<<'.,.,', 'names.y', 53)
  def _reduce_10(val, _values, result)
               result = { :von => val[0], :last => val[1] }
         
    result
  end
.,.,

# reduce 11 omitted

module_eval(<<'.,.,', 'names.y', 59)
  def _reduce_12(val, _values, result)
               result = { :last => val[0][0], :first => val[0][1] }
         
    result
  end
.,.,

module_eval(<<'.,.,', 'names.y', 63)
  def _reduce_13(val, _values, result)
               result = { :von => val[0], :last => val[1][0], :first => val[1][1] }
         
    result
  end
.,.,

module_eval(<<'.,.,', 'names.y', 67)
  def _reduce_14(val, _values, result)
               result = { :von => val[0..1].join(' '), :last => val[2][0], :first => val[2][1] }
         
    result
  end
.,.,

# reduce 15 omitted

module_eval(<<'.,.,', 'names.y', 73)
  def _reduce_16(val, _values, result)
              result = { :last => val[0], :jr => val[2][0], :first => val[2][1] }
        
    result
  end
.,.,

module_eval(<<'.,.,', 'names.y', 77)
  def _reduce_17(val, _values, result)
              result = { :von => val[0], :last => val[1], :jr => val[3][0], :first => val[3][1] }
        
    result
  end
.,.,

module_eval(<<'.,.,', 'names.y', 81)
  def _reduce_18(val, _values, result)
              result = { :von => val[0..1].join(' '), :last => val[2], :jr => val[4][0], :first => val[4][1] }
        
    result
  end
.,.,

# reduce 19 omitted

module_eval(<<'.,.,', 'names.y', 85)
  def _reduce_20(val, _values, result)
     result = val.join(' ') 
    result
  end
.,.,

module_eval(<<'.,.,', 'names.y', 86)
  def _reduce_21(val, _values, result)
     result = val.join(' ') 
    result
  end
.,.,

module_eval(<<'.,.,', 'names.y', 88)
  def _reduce_22(val, _values, result)
     result = [val[0], nil] 
    result
  end
.,.,

module_eval(<<'.,.,', 'names.y', 89)
  def _reduce_23(val, _values, result)
     result = [val[0][0], val[0][1] ? val[0][1..-1].join(' ') : nil] 
    result
  end
.,.,

module_eval(<<'.,.,', 'names.y', 90)
  def _reduce_24(val, _values, result)
     result = [val[0][0], (val[0][1..-1] << val[1]).join(' ')] 
    result
  end
.,.,

# reduce 25 omitted

module_eval(<<'.,.,', 'names.y', 92)
  def _reduce_26(val, _values, result)
     result = val[0].join(' ') 
    result
  end
.,.,

module_eval(<<'.,.,', 'names.y', 94)
  def _reduce_27(val, _values, result)
     result = [nil,val[0]] 
    result
  end
.,.,

module_eval(<<'.,.,', 'names.y', 95)
  def _reduce_28(val, _values, result)
     result = [val[0],val[2]] 
    result
  end
.,.,

module_eval(<<'.,.,', 'names.y', 97)
  def _reduce_29(val, _values, result)
     result = [val[0]] 
    result
  end
.,.,

module_eval(<<'.,.,', 'names.y', 98)
  def _reduce_30(val, _values, result)
     result << val[1] 
    result
  end
.,.,

# reduce 31 omitted

# reduce 32 omitted

# reduce 33 omitted

module_eval(<<'.,.,', 'names.y', 103)
  def _reduce_34(val, _values, result)
     result = val.join(' ') 
    result
  end
.,.,

# reduce 35 omitted

# reduce 36 omitted

# reduce 37 omitted

# reduce 38 omitted

# reduce 39 omitted

def _reduce_none(val, _values, result)
  val[0]
end

  end   # class NameParser
  end   # module BibTeX
