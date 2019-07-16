Feature: Display the weather at randomly chosen locations
  @javascript
  Scenario: Going to the page and entering a number in the form results in the display of the current weather for that many locations
    Given I have a page that has a form that accepts a number
    When I enter 5 points to display
    Then I expect to see 5 points with temperatures
