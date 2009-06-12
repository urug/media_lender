Feature: Manage movies
  In order to share my movie library
  As a legitimate movie owner
  I want to manage my library 

  Scenario: Create
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
      
  Scenario: Update
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
      
      
  Scenario: Show
  Given the following movie:
    | Title                   | Rating | Genre            | Synopsis                      |
    | Raiders of the Lost Ark | PG-13  | Action/Adventure | This is a non-stop thriller.  |
  And I am on the movies page
  When I click on "Show"
  Then I should see "Raiders of the Lost Ark"
  And I should see "This is a non-stop thriller."
    
  
    

  Scenario: Delete
    Given the following movies:
      | Title                   | Rating | Genre            |
      | Raiders of the Lost Ark | PG-13  | Action/Adventure |
      | Star Wars: A New Hope   | PG     | Action/Adventure |

    When I delete the 2nd movie
    Then I should see the following movies:
      | Title                   | Rating | Genre            |
      | Raiders of the Lost Ark | PG-13  | Action/Adventure |

