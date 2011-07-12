require 'spec_helper'

describe '#sdiffstore(destination, key [, key, ...])' do
  before do
    @numbers     = 'mock-redis-test:sdiffstore:numbers'
    @evens       = 'mock-redis-test:sdiffstore:odds'
    @primes      = 'mock-redis-test:sdiffstore:primes'
    @destination = 'mock-redis-test:sdiffstore:destination'

    
    (1..10).each {|i| @redises.sadd(@numbers, i) }
    [2, 4, 6, 8, 10].each {|i| @redises.sadd(@evens, i) }
    [2, 3, 5, 7].each {|i| @redises.sadd(@primes, i) }
  end

  it "returns the number of elements in the resulting set" do
    @redises.sdiffstore(@destination, @numbers, @evens).should == 5
  end

  it "stores the resulting set" do
    @redises.sdiffstore(@destination, @numbers, @evens)
    @redises.smembers(@destination).should == %w[1 3 5 7 9]
  end

  it "treats missing keys as empty sets" do
    @redises.sdiffstore(@destination, @evens, 'mock-redis-test:nonesuch')
    @redises.smembers(@destination).should == %w[10 2 4 6 8]
  end

  it "raises an error if given 0 sets" do
    lambda do
      @redises.sdiffstore(@destination)
    end.should raise_error(RuntimeError)
  end

  it "raises an error if any argument is not a a set" do
    @redises.set('mock-redis-test:notset', 1)

    lambda do
      @redises.sdiffstore(@destination, @numbers, 'mock-redis-test:notset')
    end.should raise_error(RuntimeError)

    lambda do
      @redises.sdiffstore(@destination, 'mock-redis-test:notset', @numbers)
    end.should raise_error(RuntimeError)
  end
end
