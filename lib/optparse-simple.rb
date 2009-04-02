$:.unshift File.dirname(__FILE__)

require 'rubygems'
require 'indifferent-variable-hash'

class OptParseSimple
  extend IndifferentVariableHash

  # an Array of Options
  attr_accessor :options

  # DEFAULT configuration values
  OptParseSimple.compatibility_mode = false # whether or not OptParseSimple acts like OptionParser

  def initialize &block
    block.call self
  end

  def parse args
    check_for_invalid_options(args) if OptParseSimple.compatibility_mode
    options.each {|option| option.parse(args) }
  end

  def parse! args
    check_for_invalid_options(args) if OptParseSimple.compatibility_mode
    options.each {|option| option.parse!(args) }
  end

  #:nodoc:
  def options
    @options ||= []
  end

  def on *args, &block
    options << Option.new(*args, &block)
  end

  private

  def check_for_invalid_options args
    args_clone = args.clone
    options.each {|option| option.match! args_clone }
    raise "invalid option: #{ args_clone.first }" unless args_clone.empty?
  end

end

class OptParseSimple #:nodoc:

  # 
  # represents a single option, eg. its matchers (-f, --foo) 
  # and its block of logic to call, if matched
  #
  class Option
    attr_accessor :short_string, :long_string, :accepts_argument, :proc

    def initialize *args, &block
      set_defaults

      @proc = block

      # take arguments (eg. '-f' or '--f' or '--f [foo]')
      # and set #short_string, #long_string, and #accepts_argument
      args.each do |arg|
        case arg
        when /^-(\w)/
          @short_string = $1 
        when /^--(\w+)/
          @long_string = $1
        else
          raise "Don't know how to handle argument: #{ arg.inspect }"
        end

        @accepts_argument = true if arg =~ /\[.*\]$/
      end
    end

    def short_string_with_dash
      (short_string) ? "-#{ short_string }" : ''
    end

    def long_string_with_dashes
      (long_string) ? "--#{ long_string }" : ''
    end

    def parse *args
      args = args.first if args.first.is_a?(Array) and args.length == 1
      do_parsing args, :run => true, :destructive => false
    end
    
    def parse! *args
      args = args.first if args.first.is_a?(Array) and args.length == 1
      do_parsing args, :run => true, :destructive => true
    end

    def match *args
      args = args.first if args.first.is_a?(Array) and args.length == 1
      do_parsing args, :run => false, :destructive => false
    end

    def match! *args
      args = args.first if args.first.is_a?(Array) and args.length == 1
      do_parsing args, :run => false, :destructive => true
    end

    alias accept_argument?   accepts_argument
    alias accept_arguments?  accepts_argument
    alias accepts_argument?  accepts_argument
    alias accepts_arguments? accepts_argument

    private

    def do_parsing args, options = { }
      options = { :run => false, :destructive => false }.merge(options)
      
      if accepts_arguments?
        match_with_arguments args, options
      else
        match_without_arguments args, options
      end
    end

    def match_without_arguments args, options
      args.each do |arg|
        if arg == short_string_with_dash || arg == long_string_with_dashes
          args.delete arg if options[:destructive]
          @proc.call if options[:run] and @proc.respond_to?(:call)
          return true
        end
      end
      return false
    end

    def match_with_arguments args, options
      indexes_that_match = [] # indexes that match either the short or long string
      args.each_with_index do |arg, index|
        indexes_that_match << index if arg == short_string_with_dash || arg == long_string_with_dashes
        if indexes_that_match.include?( index - 1 )
          unless arg.start_with?('-')
            this_argument = arg
            if options[:destructive]
              args.delete_at index - 1 # delete the last matching index
              args.delete_at index - 1 # delete this index (-1 because we deleted matching)
            end
            if options[:run] and @proc.respond_to?(:call)
              @proc.call this_argument
            end

            return true
          end
        end
      end
      return false
    end

    def set_defaults
      @accepts_argument = false
    end
  end

end
