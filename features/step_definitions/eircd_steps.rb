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
    content = ""
    content << @sock.readpartial(1024) while IO::select([@sock], nil, nil, 1)
    content
  end
end

Given /^I am connected to eircd$/ do
  @client = Client.new('localhost', 6667).connect
end

Given /^I am registered as "([^"]*)"$/ do |nickname|
  steps %{
    Given I am connected to eircd
    And I enter "NICK #{nickname}"
    And I enter "USER #{nickname} hostname servername realname"
  }
  @client.read
end

When /^I enter "([^']+)"$/ do |content|
  @client.write content
end

Then /^I should receive "([^"]*)"$/ do |text|
  @client.read.chomp.should =~ /#{text}/
end

Then /^I should receive the following content:$/ do |text|
  @client.read.chomp.split("\r\n").should == text.split("\n")
end

After do
  @client.close if @client
end