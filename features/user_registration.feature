Feature: User registers a nick
	As a user
	I want to register my nickname
	So that other people can find me

Scenario: User connects for the first time
	Given I am connected to eircd
	When enter "NICK user1"
	Then I should receive content ":verne.freenode.net 001 markryall :Welcome to the freenode Internet Relay Chat Network markryall"