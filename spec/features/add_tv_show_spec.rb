require "spec_helper"

feature "user adds a new TV show" do
  # As a TV fanatic
  # I want to add one of my favorite shows
  # So that I can encourage others to binge watch it
  #
  # Acceptance Criteria:
  # * I must provide the title, network, and starting year.
  # * I can optionally provide the final year, genre, and synopsis.
  # * The synopsis can be no longer than 5000 characters.
  # * The starting year and ending year (if provided) must be
  #   greater than 1900.
  # * The genre must be one of the following: Action, Mystery,
  #   Drama, Comedy, Fantasy
  # * If any of the above validations fail, the form should be
  #   re-displayed with the failing validation message.
  scenario "successfully add a new show" do
    visit "/television_shows/new"

    fill_in 'title', with: "House of Cards"
    fill_in 'network', with: "Netflix"
    fill_in 'starting_year', with: 2013

    visit "/television_shows"

    expect(page).to have_content("House of Cards (Netflix)")
  end

  scenario "successfully add a new show with optional fields" do
    visit "/television_shows/new"

    fill_in 'title', with: "House of Cards"
    fill_in 'network', with: "Netflix"
    fill_in 'starting_year', with: 2013
    fill_in 'ending_year', with: 2016
    select "Comedy", from: "genre"
    fill_in 'synopsis', with: "Great Show"
    click_button 'Add TV Show'

    visit "/television_shows"

    expect(page).to have_content("House of Cards (Netflix)")
  end

  scenario "failt to add show by not filling out required fields" do
    visit "/television_shows/new"

    fill_in 'title', with: nil
    fill_in 'network', with: nil
    fill_in 'starting_year', with: nil
    click_button 'Add TV Show'

    expect(page).to have_content("title can't be blank")
    expect(page).to have_content("network can't be blank")
    expect(page).to have_content("starting year can't be blank")
    expect(page).to have_content("starting year is not a number")
  end

  scenario "fail to add a show with synopsis greater than 5000 characters" do
    visit "/television_shows/new"

    fill_in 'title', with: "House of Cards"
    fill_in 'network', with: "Netflix"
    fill_in 'starting_year', with: 2013
    fill_in 'synopsis', with: "a" * 5001
    click_button 'Add TV Show'


    expect(page).to have_selector("input[value='House of Cards']")
    expect(page).to have_selector("input[value='Netflix']")
    expect(page).to have_selector("input[value='2013']")
    expect(page).to have_selector("textarea[value='#{"a" * 5001}']")
    expect(page).to have_content("synopsis is too long (maximum is 5000 characters)")
  end

  scenario "fail to add a show with starting year 1900" do
    visit "/television_shows/new"

    fill_in 'title', with: "House of Cards"
    fill_in 'network', with: "Netflix"
    fill_in 'starting_year', with: 1900
    click_button 'Add TV Show'

    expect(page).to have_selector("input[value='House of Cards']")
    expect(page).to have_selector("input[value='Netflix']")
    expect(page).to have_selector("input[value='1900']")
    expect(page).to have_content("starting year must be greater than 1900")
  end

  scenario "fail to add a show with ending year 1900" do
    visit "/television_shows/new"

    fill_in 'title', with: "House of Cards"
    fill_in 'network', with: "Netflix"
    fill_in 'starting_year', with: 2013
    fill_in 'ending_year', with: 1900
    click_button 'Add TV Show'

    expect(page).to have_selector("input[value='House of Cards']")
    expect(page).to have_selector("input[value='Netflix']")
    expect(page).to have_selector("input[value='2013']")
    expect(page).to have_selector("input[value='1900']")
    expect(page).to have_content("ending year must be greater than 1900")
  end
end
