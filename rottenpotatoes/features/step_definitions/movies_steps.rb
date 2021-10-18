
Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
end

Then /(.*) seed movies should exist/ do | n_seeds |
  Movie.count.should be n_seeds.to_i
end


Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  expect(page.body.index(e1) < page.body.index(e2))
end

When /I (un)?check the following ratings: +"(.*)"$/ do |uncheck, rating_list|
  ratings = rating_list.split;
  ratings.each do |r|
    if (uncheck)
      uncheck("ratings_#{r}")
    else
      check("ratings_#{r}")
    end
  end
end

Then /I should (not )?see the following ratings: +"(.*)"$/ do |yes, ratings|
  hash = Hash[(ratings.split).map {|rating| [rating, 1]} ]
  mat = "//table[@id='movies']//td[2]"
  page.all(:xpath, mat) do |r|
      if yes
        if (hash.key?(r.text)) 
          fail "Not expected but found: #{r}"
        end
      else
        if !(hash.key?(r.text))
          fail "Expected but not found: #{r}"
        end
      end
  end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  Movie.all.each do |movie|
    step %{I should see "#{movie.title}"}
  end
end

Then /the director of "(.*)" should be "(.*)"/ do |movie, director|
  if page.respond_to? :should
    page.should have_content("Details about #{movie}")
    page.should have_content("Director: #{director}")
  else
    assert page.has_content?("Details about #{movie}")
    assert page.has_content?("Director: #{director}")
  end
end