# Add a declarative step here for populating the DB with movies.
require 'debugger'

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    movie_new = Movie.new(movie)
    movie_new.save!
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  content = page.body
  position1 = (content =~ Regexp.new(e1))
  position2 = (content =~ Regexp.new(e2))

  position1.should_not be nil
  position2.should_not be nil
  position1.should be < position2
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |should_uncheck, rating_list|
  rating_list.split(",").each do |rating|
    if should_uncheck
      uncheck("ratings[#{rating}]")
    else
      check("ratings[#{rating}]")
    end
  end
end

Then /I should see all the movies/ do
  Movie.all.each do |movie|
    page.should have_content(movie.title)
  end
end

Then /I should (not )?see movies from the following ratings: (.*)/ do |should_not_see, rating_list|
  Movie.where(rating: rating_list.split(",")).each do |movie|
    if(should_not_see)
      page.should_not have_content(movie.title)
    else
      page.should have_content(movie.title)
    end
  end
end
