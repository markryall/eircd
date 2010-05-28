Feature: User registers a nick
	As a user
	I want to register my nickname
	So that other people can find me

Scenario: User connects for the first time
	Given I am connected to eircd
	When enter "NICK user2"
	And enter "USER user2 hostname servername realname"
	Then I should receive ":eircd 001 user2 :Welcome to the eircd Internet Relay Chat Network user2"