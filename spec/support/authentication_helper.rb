module AuthenticationHelper
  def sign_in_as(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Sign in'
  end

  def add_book_as(book)
    first('#add-book').click_link('Add Book')

    fill_in 'book_title', with: book.title
    select(book.quality, from: 'book_quality')
    fill_in 'book_price', with: book.price

    click_button 'Submit'
  end
end
