require 'socket'

class Client
  def initialize host, port
    @host, @port = host, port
  end

  def connect
    @sock = TCPSocket.open(@host, @port)
    self
  end

  def close
    @sock.close
  end

  def write content
    @sock.puts content
  end

  def read
    raise TimeoutError, "timed out while waiting for more data" unless IO::select([@sock], nil, nil, 1)
    content = @sock.readpartial(1024)
    while IO::select([@sock], nil, nil, 0)
      content << @sock.readpartial(1024)
    end
    content
  end
end

Given /^I am connected to eircd$/ do
  @client = Client.new('localhost', 6667).connect
end

When /^enter "([^']+)"$/ do |content|
  @client.write content
end

Then /^I should receive the following content:$/ do |table|
  @client.read.split("\r\n").should == table.raw.first
end

After do
  @client.close if @client
end