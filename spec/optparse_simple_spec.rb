require File.dirname(__FILE__) + '/spec_helper'

describe OptParseSimple, 'parsing' do

  before do
    ARGV.clear

    # make OptParseSimple act exactly like OptionParser
    OptParseSimple.compatibility_mode = true
  end

  it 'parse -f (compatibility mode)' do
    [ OptionParser, OptParseSimple ].each do |parser|
      @args = ['-a', '-f', '-x']
      @foo = nil

      opts = parser.new do |opts|
        opts.on('-f'){ @foo = 'w00t' }
      end

      @foo.should be_nil

      lambda { opts.parse @args }.should raise_error(/invalid option: -a/)

      # @foo.should  == 'w00t'
      # @args.should == ['-a', '-f', '-x']
    end
  end

  it 'parse! -f (compatibility mode)' do
    [ OptionParser, OptParseSimple ].each do |parser|
      @args = ['-a', '-f', '-x']
      @foo = nil

      opts = parser.new do |opts|
        opts.on('-f'){ @foo = 'w00t' }
      end

      @foo.should be_nil

      lambda { opts.parse! @args }.should raise_error(/invalid option: -a/)

      # @foo.should  == 'w00t'
      # @args.should == ['-a', '-x']
    end
  end

  it 'parse -f' do
    OptParseSimple.compatibility_mode = false

    @args = ['-a', '-f', '-x']
    @foo = nil

    opts = OptParseSimple.new do |opts|
      opts.on('-f'){ @foo = 'w00t' }
    end

    @foo.should be_nil

    opts.parse @args

    @foo.should  == 'w00t'
    @args.should == ['-a', '-f', '-x']
  end

  it 'parse! -f' do
    OptParseSimple.compatibility_mode = false

    @args = ['-a', '-f', '-x']
    @foo = nil

    opts = OptParseSimple.new do |opts|
      opts.on('-f'){ @foo = 'w00t' }
    end

    @foo.should be_nil

    opts.parse! @args

    @foo.should  == 'w00t'
    @args.should == ['-a', '-x']
  end

  it 'parse --foo' do
    OptParseSimple.compatibility_mode = false

    @args = ['-a', '--foo', '-x']
    @foo = nil

    opts = OptParseSimple.new do |opts|
      opts.on('--foo'){ @foo = 'w00t' }
    end

    @foo.should be_nil

    opts.parse @args

    @foo.should  == 'w00t'
    @args.should == ['-a', '--foo', '-x']
  end

  it 'parse! --foo' do
    OptParseSimple.compatibility_mode = false

    @args = ['-a', '--foo', '-x']
    @foo = nil

    opts = OptParseSimple.new do |opts|
      opts.on('--foo'){ @foo = 'w00t' }
    end

    @foo.should be_nil

    opts.parse! @args

    @foo.should  == 'w00t'
    @args.should == ['-a', '-x']
  end

  it 'parse -f, --foo' do
    OptParseSimple.compatibility_mode = false

    opts = OptParseSimple.new do |opts|
      opts.on('-f', '--foo'){ @foo = 'w00t' }
    end

    # -f

    @args = ['-a', '-f', '-x']
    @foo = nil

    @foo.should be_nil

    opts.parse @args

    @foo.should  == 'w00t'
    @args.should == ['-a', '-f', '-x']

    # --foo

    @args = ['-a', '--foo', '-x']
    @foo = nil

    @foo.should be_nil

    opts.parse @args

    @foo.should  == 'w00t'
    @args.should == ['-a', '--foo', '-x']
  end

  it 'parse! -f, --foo' do
    OptParseSimple.compatibility_mode = false

    opts = OptParseSimple.new do |opts|
      opts.on('-f', '--foo'){ @foo = 'w00t' }
    end

    # -f

    @args = ['-a', '-f', '-x']
    @foo = nil

    @foo.should be_nil

    opts.parse! @args

    @foo.should  == 'w00t'
    @args.should == ['-a', '-x']

    # --foo

    @args = ['-a', '--foo', '-x']
    @foo = nil

    @foo.should be_nil

    opts.parse! @args

    @foo.should  == 'w00t'
    @args.should == ['-a', '-x']
  end

  it 'parse -f [X]' do
    OptParseSimple.compatibility_mode = false

    opts = OptParseSimple.new do |opts|
      opts.on('-f [x]'){|x| @foo = x }
    end

    # -f

    @args = ['-a', '-f', '4', '-x']
    @foo = nil

    @foo.should be_nil

    opts.parse @args

    @foo.should  == '4'

    @args.should == ['-a', '-f', '4', '-x']
  end

  it 'parse! -f [X]' do
    OptParseSimple.compatibility_mode = false

    opts = OptParseSimple.new do |opts|
      opts.on('-f [x]'){|x| @foo = x }
    end

    # -f

    @args = ['-a', '-f', '4', '-x']
    @foo = nil

    @foo.should be_nil

    opts.parse! @args

    @foo.should  == '4'

    @args.should == ['-a', '-x']
  end

  # TODO i think OptionParser supports the -f=X / --foo=X syntaxes ... i need to add support!
  it '-f=X'

end
