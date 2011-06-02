Feature: repository manager ingests TCP files
	In order to access text and images for a book
	As the repository manager
	I want to ingest TCP files into Fedora
	
	Scenario: ingest a TCP package
		Given I have a TCP package to ingest
		When I ingest the TEI file "K000122.000.xml"
		Then I should get back a Fedora object PID "bamboo:K000122.000"
