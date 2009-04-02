require File.dirname(__FILE__) + '/spec_helper'

describe OptParseSimple, 'parsing' do

  before do
    ARGV.clear

    # make OptParseSimple act exactly like OptionParser
    OptParseSimple.compatibility_mode = true
  end

  it '-f' do
    pending
    [ OptionParser, OptParseSimple ].each do |parser|
      @foo = nil

      opts = parser.new do |opts|
        opts.on('-f'){ puts "-f block CALLED!"; @foo = 'w00t' }
      end

      @foo.should be_nil

      opts.parse %w( -f )

      @foo.should == 'w00t'
    end
  end

  it '--foo'

  it '-f, --foo'

  it '-f X'

  it '-f=X'

end
