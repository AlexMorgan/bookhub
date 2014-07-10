require 'rails_helper'

feature 'User adds a book for sale' do
  scenario 'user successfully adds a book' do
    user = FactoryGirl.create(:user)
    book = FactoryGirl.build(:book, user: user)
    sign_in_as(user)

    click_button "Update"
    add_book_as(book)

    expect(page).to have_content('Make sure this information is correct!')
  end

  scenario 'user tries to add book without invalid ISBN13' do
    user = FactoryGirl.create(:user)
    book = FactoryGirl.build(:book, user: user)
    sign_in_as(user)

    click_button "Update"
    first('#add-book').click_link('Add Book')
    fill_in 'book_isbn13', with: 'asfasfob'
    select(book.quality, from: 'book_quality')
    fill_in 'book_price', with: book.price

    click_button 'Submit'

    expect(page).to have_content('Isbn13 is not a valid ISBN code')
  end
end
