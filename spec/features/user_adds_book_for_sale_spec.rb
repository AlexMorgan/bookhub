require 'rails_helper'

feature 'User adds a book for sale' do
  scenario 'user successfully adds a book' do
    user = FactoryGirl.create(:user)
    book = FactoryGirl.create(:book, user: user)
    sign_in_as(user)

    click_button "Update"
    add_book_as(book)

    expect(page).to have_content('Make sure this information is correct!')
  end

  scenario '' do
  end
end
