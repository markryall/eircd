require 'socket'

Given /^I am connected to eircd$/ do
  @client = TCPSocket.open('localhost', 6667)
end

When /^enter "([^']+)"$/ do |content|
  @client.puts content
end

Then /^I should receive content "([^']+)"$/ do |content|
  @client.gets.chomp.should == content
end

After do
  @client.close if @client
end