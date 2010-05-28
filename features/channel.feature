Feature: User joins a channel
	As a user
	I want to join a channel
	So that I can talk to like minded people

Scenario: User connects for the first time
	Given I am registered as "user2"
	When enter "JOIN #channel1"
	Then I should receive the following content:
	 """
	 :eircd MODE #channel1 +ns
	 :eircd 353 user2 @ #channel1 :@user2
	 :eircd 366 user2 #channel1 :End of /NAMES list.
	 """