require "spec_helper"

feature "user edits TV show" do
  # As a TV fanatic
  # I want to edit an existing show
  # So that I can correct any foolish mistakes
  #
  # Acceptance Criteria:
  # * Editing a show provides a pre-populated form for each field.
  # * Submitting the edit form will update a show if all validations pass.
  # * The user is redirected to the details page for that show if successfully updated.
  # * If the update fails any validations, re-display the form with the appropriate error messages.

  game_of_thrones = TelevisionShow.create!({
      title: "Game of Thrones", network: "HBO",
      starting_year: 2011, genre: "Fantasy"
    })

  scenario "visiting edit page shows a pre-populated form for each field" do
    visit "/television_shows/#{game_of_thrones.id}/edit"

    expect(page).to have_selector("input[value='#{game_of_thrones.title}']")
    expect(page).to have_selector("input[value='#{game_of_thrones.network}']")
    expect(page).to have_selector("input[value='#{game_of_thrones.starting_year}']")
    # expect(page).to have_select("genre", selected: '#{game_of_thrones.starting_year}')
  end

  scenario "successfully edit show" do
    visit "/television_shows/#{game_of_thrones.id}/edit"

    fill_in 'title', with: "GOT"

    click_button 'Edit TV Show'

    expect(page).to have_content("GOT")
    expect(page).to have_content("HBO")
    expect(page).to have_content("2011 - Present")
    expect(page).to have_content("Fantasy")
  end

  scenario "failt to edit show by not filling out required fields" do
    visit "/television_shows/#{game_of_thrones.id}/edit"

    fill_in 'title', with: nil
    fill_in 'network', with: nil
    fill_in 'starting_year', with: nil
    click_button 'Edit TV Show'

    expect(page).to have_content("title can't be blank")
    expect(page).to have_content("network can't be blank")
    expect(page).to have_content("starting year can't be blank")
    expect(page).to have_content("starting year is not a number")
  end

  scenario "fail to edit a show with synopsis greater than 5000 characters" do
    visit "/television_shows/#{game_of_thrones.id}/edit"

    fill_in 'synopsis', with: "a" * 5001
    click_button 'Edit TV Show'

    expect(page).to have_selector("input[value='GOT']")
    expect(page).to have_selector("input[value='HBO']")
    expect(page).to have_selector("input[value='2011']")
    expect(page).to have_selector("textarea[value='#{"a" * 5001}']")
    expect(page).to have_content("synopsis is too long (maximum is 5000 characters)")
  end

  scenario "fail to edit a show with starting year 1900" do
    visit "/television_shows/#{game_of_thrones.id}/edit"

    fill_in 'starting_year', with: 1900
    click_button 'Edit TV Show'

    expect(page).to have_selector("input[value='GOT']")
    expect(page).to have_selector("input[value='HBO']")
    expect(page).to have_selector("input[value='1900']")
    expect(page).to have_content("starting year must be greater than 1900")
  end

  scenario "fail to edit a show with ending year 1900" do
    visit "/television_shows/#{game_of_thrones.id}/edit"

    fill_in 'ending_year', with: 1900
    click_button 'Edit TV Show'

    expect(page).to have_selector("input[value='GOT']")
    expect(page).to have_selector("input[value='HBO']")
    expect(page).to have_selector("input[value='2011']")
    expect(page).to have_selector("input[value='1900']")
    expect(page).to have_content("ending year must be greater than 1900")
  end
end
