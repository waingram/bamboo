Feature: repository manager finds MA file
	As a repository manager
	I want to find the MA file
	So that I can ingest it in Fedora
	Scenario: find MA file
		Given I have a TEI XML file
		When I ingest the TEI
		Then the ingester should know the TCP ID
		And the ingester should know the MA file location
		And the ingester should know the Gayle image URL
