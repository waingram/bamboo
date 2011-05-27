#This is intended mostly as a rough example of how a cucumber test might go
#This is a very broad test - it's easy to imagine narrower ones. But this is the kind of thing that it can do.
#It's also a bit problematic because it has to start the processing and then wait, potentially for a while,
#to see if it completes, but it may be that we need some tests of that sort.
Feature: Demo
  In order to demonstrate the workflow system
  As a developer
  I want to be able to run a demo

  @use-demo-servers-with-timeout
  Scenario: Run the demo
    Given I give the demo servers time to start up
    When I move demo file folder into the in directory and rename it
    Then I should see the processed files in the out directory