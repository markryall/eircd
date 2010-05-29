Feature: User pings server
	As a user
	I want to ping the server
	So that I can tell that it is still alice

Scenario: User pings server
	Given I am connected to eircd
	When I enter "PING"
	Then I should receive "PONG"