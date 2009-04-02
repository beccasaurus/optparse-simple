require File.dirname(__FILE__) + '/spec_helper'

describe OptParseSimple::Option do

  before :all do
    ::Option = OptParseSimple::Option
  end

  it "should hold onto the block it's initalized with" do
    option = Option.new('-f'){ "hello from block" }
    option.proc.should respond_to(:call)
    option.proc.call.should == "hello from block"

    option.accepts_arguments?.should be_false
  end

  it 'should have a short string' do
    option = Option.new('-f')
    option.short_string.should == 'f'
    option.long_string.should be_nil

    option.accepts_arguments?.should be_false
  end

  it 'should have a long string' do
    option = Option.new('--foo')
    option.long_string.should == 'foo'
    option.short_string.should be_nil

    option.accepts_arguments?.should be_false
  end

  it 'should have a short string and a long string' do
    option = Option.new('-f', '--foo')
    option.short_string.should == 'f'
    option.long_string.should == 'foo'

    # order shouldn't matter
    option2 = Option.new('--foo', '-f')
    option2.short_string.should == 'f'
    option2.long_string.should == 'foo'

    option.accepts_arguments?.should be_false
  end

  it 'should be able to accept an argument' do
    Option.new('-f [x]').accepts_arguments?.should be_true    
    Option.new('--foo [abc]').accepts_arguments?.should be_true    
    Option.new('-f', '--f [123]').accepts_arguments?.should be_true    
    Option.new('-f [x]', '--f').accepts_arguments?.should be_true    
    Option.new('-f []', '--f').accepts_arguments?.should be_true    
  end

  it 'should be able to determine if it #match a set of args' do
    Option.new('-f').match(['-f']).should be_true
    Option.new('-f').match(['-d']).should be_false
    Option.new('-f').match(['-a', 'hi', '1', '-f', '-g']).should be_true

    Option.new('-f [x]').match(['-f']).should be_false
    Option.new('-f [x]').match(['-f', '-g']).should be_false
    Option.new('-f [x]').match(['hi', '-f']).should be_false
    Option.new('-f [x]').match(['hi', '-f', '5']).should be_true
    Option.new('-f [x]').match(['hi', '-f', 'hi there']).should be_true

    # should *not* run procs
    Option.new('-f'){ @foo = 'w00t' }.match(['-f']).should be_true
    @foo.should be_nil
  end

  it 'should be able to #parse args (and run proc)' do
    @foo = nil
    Option.new('-f'){ @foo = 'w00t' }.parse(['-x']).should be_false
    @foo.should be_nil
    Option.new('-f'){ @foo = 'w00t' }.parse(['-f']).should be_true
    @foo.should == 'w00t'

    # also shouldn't alter args
    args = ['-x', '-f', '-g']
    Option.new('-f'){ @foo = 'w00t again' }.parse(args).should be_true
    @foo.should == 'w00t again'
    args.should == ['-x', '-f', '-g']
  end

  it 'should be able to #parse! (destructively) args (and run proc)' do
    # should alter args
    @foo = nil
    args = ['-x', '-f', '-g']
    Option.new('-f'){ @foo = 'w00t' }.parse!(args).should be_true
    @foo.should == 'w00t'
    args.should == ['-x', '-g']
  end

  it "should pass arguments to proc when #parse[!]'d (if accepts_arguments)" do
    # should not modify
    args = %w(-x -f 5 -y)
    Option.new('-f [x]'){|x| @foo = "it is #{x}" }.parse(args).should be_true
    @foo.should == "it is 5"
    args.should == %w(-x -f 5 -y)

    # should modify
    args = %w(-x -f 8 -y)
    Option.new('-f [x]'){|x| @foo = "it is #{x}" }.parse!(args).should be_true
    @foo.should == "it is 8"
    args.should == %w(-x -y)
  end

end
