Feature: Manage movies
  In order to share my movie library
  As a legitimate movie owner
  I want to manage my library 

  Scenario: Create new movie
    Given I am on the new movie page
    When I fill in "Title" with "Raiders of the Lost Ark"
    And I select "PG-13" from "Rating"
    And I select "Action/Adventure" from "Genre"
    And I fill in "Synopsis" with "The best movie ever. In the World."
    And I press "Create"
	  Then I should see "Movie was successfully created."
	  And I should see the following movie:
      | Title                   | Rating | Genre            |
      | Raiders of the Lost Ark | PG-13  | Action/Adventure |
      
  Scenario: Update movie
    Given the following movie:
      | Title                   | Rating | Genre            |
      | Raiders of the Lost Ark | PG-13  | Action/Adventure |
    And I am on the movies page
    When I click on "Edit"
    And I select "Comedy" from "Genre"
    And I press "Update"
    Then I should see "Movie was successfully updated."
    And I should see the following movie:
      | Title                   | Rating | Genre  |
      | Raiders of the Lost Ark | PG-13  | Comedy |
    

  # Scenario: Delete movie
  #   Given the following movies:
  #     |title|rating|genre|synopsis|
  #     |title 1|rating 1|genre 1|synopsis 1|
  #     |title 2|rating 2|genre 2|synopsis 2|
  #     |title 3|rating 3|genre 3|synopsis 3|
  #     |title 4|rating 4|genre 4|synopsis 4|
  #   When I delete the 3rd movie
  #   Then I should see the following movies:
  #     |title|rating|genre|synopsis|
  #     |title 1|rating 1|genre 1|synopsis 1|
  #     |title 2|rating 2|genre 2|synopsis 2|
  #     |title 4|rating 4|genre 4|synopsis 4|
