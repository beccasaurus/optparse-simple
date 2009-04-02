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
        opts.on('-f'){ puts "-f block CALLED!"; @foo = 'w00t' }
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
        opts.on('-f'){ puts "-f block CALLED!"; @foo = 'w00t' }
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
      opts.on('-f'){ puts "-f block CALLED!"; @foo = 'w00t' }
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
      opts.on('-f'){ puts "-f block CALLED!"; @foo = 'w00t' }
    end

    @foo.should be_nil

    opts.parse! @args

    @foo.should  == 'w00t'
    @args.should == ['-a', '-x']
  end

  it '--foo'

  it '-f, --foo'

  it '-f X'

  it '-f=X'

end
