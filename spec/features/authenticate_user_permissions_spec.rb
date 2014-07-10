require 'rails_helper'

feature 'Users try to access parts of the site without signing in' do
  scenario 'User tries to view add books' do
    book = FactoryGirl.create(:book)
    visit root_path
    click_link 'Books'

    expect(page).to have_content('The Wolf of Wall Stre')
  end

  scenario 'User tries to add books without signing in' do
    book = FactoryGirl.create(:book)
    visit root_path
    click_link 'Add Book'

    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end
end
