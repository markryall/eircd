Feature: User joins a channel
	As a user
	I want to join a channel
	So that I can talk to like minded people

Scenario: User connects for the first time
	Given I am connected to eircd
	When enter "NICK user2"
	And enter "USER user2 hostname servername realname"
	And enter "JOIN #channel1"
	Then I should receive the following content:
	 | :eircd 001 user2 :Welcome to the eircd Internet Relay Chat Network user2  |
	 | :eircd MODE #channel1 +ns                                                 |
	 | I should receive content ":eircd 353 user2 @ #channel1 :@user2            |
	 | I should receive content ":eircd 366 user2 #channel1 :End of /NAMES list. |