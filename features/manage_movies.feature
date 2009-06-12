Feature: Manage movies
  In order to share my movie library
  As a legitimate movie owner
  I want to manage my library 

  Scenario: Create manually
    Given I am on the new movie page
    When I fill in "Title" with "Raiders of the Lost Ark"
    And I select "PG" from "Rating"
    And I select "Action/Adventure" from "Genre"
    And I fill in "Synopsis" with "The best movie ever. In the World."
    And I press "Create"
	  Then I should see "Movie was successfully created."
	  And I should see the following movie:
      | Title                   | Rating | Genre            |
      | Raiders of the Lost Ark | PG     | Action/Adventure |
      
  
  @in-progress
  Scenario: Create from Amazon information
    Given I am on the new movie page
    When I fill in "Title" with "Raiders of the Lost Ark"
    And I press "Look up in Amazon"
    Then I should be presented with the matching movies from Amazon
    
    When I select "Indiana Jones and the Raiders of the Lost Ark (Special Edition) (1981)" as the correct movie
    Then I should see "Movie was successfully updated."
    And I should see "Indiana Jones and the Raiders of the Lost Ark (Special Edition) (1981)"
      
  Scenario: Update
    Given the following movie:
      | Title                   | Rating | Genre            |
      | Raiders of the Lost Ark | PG     | Action/Adventure |
    And I am on the movies page
    When I click on "Edit"
    And I select "Comedy" from "Genre"
    And I press "Update"
    Then I should see "Movie was successfully updated."
    And I should see the following movie:
      | Title                   | Rating | Genre  |
      | Raiders of the Lost Ark | PG     | Comedy |
      
      
  Scenario: Show
    Given the following movie:
      | Title                   | Rating | Genre            | Synopsis                      |
      | Raiders of the Lost Ark | PG     | Action/Adventure | This is a non-stop thriller.  |
    And I am on the movies page
    When I click on "Show"
    Then I should see "Raiders of the Lost Ark"
    And I should see "This is a non-stop thriller."
    
  Scenario: Delete
    Given the following movies:
      | Title                   | Rating | Genre            |
      | Raiders of the Lost Ark | PG     | Action/Adventure |
      | Star Wars: A New Hope   | PG     | Action/Adventure |

    When I delete the 2nd movie
    Then I should see the following movies:
      | Title                   | Rating | Genre            |
      | Raiders of the Lost Ark | PG     | Action/Adventure |

