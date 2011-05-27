Feature: LookupMa
  In order to find the morphadorned files
  As a developer
  I want to be able to

  @use-demo-servers-with-timeout
  Scenario: Match the MA files with the TEI
    Given I give the demo servers time to start up
    When I move demo file folder into the in directory and rename it
    Then I should see the processed files in the out directory