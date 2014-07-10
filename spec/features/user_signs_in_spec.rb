require 'rails_helper'

feature 'User can sign up or signin' do
  scenario 'User signs up successfully' do
    user = FactoryGirl.build(:user)

    visit root_path
    click_link 'Sign up'
    fill_in 'Username', with: user.username
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password

    click_button 'Sign up'

    expect(page).to have_content('A message with a confirmation link has been sent to your email address. Please open the link to activate your account.')
  end

  scenario 'User does not fill out sign up form successfully' do
    user = FactoryGirl.build(:user)

    visit root_path
    click_link 'Sign up'
    fill_in 'Username', with: user.username
    fill_in 'Email', with: user.email

    click_button 'Sign up'

    expect(page).to have_content('1 error prohibited this user from being saved')
  end

  scenario 'User tries to sign in without confirming email' do
    user = FactoryGirl.build(:user)

    visit root_path
    click_link 'Sign up'
    fill_in 'Username', with: user.username
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password

    click_button 'Sign up'
    expect(page).to have_content('A message with a confirmation link has been sent to your email address. Please open the link to activate your account.')

    click_link 'Login'

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password

    click_button 'Sign in'

    expect(page).to have_content('You have to confirm your account before continuing.')
  end

  scenario 'User tries to sign up with unauthorized email' do
    user = FactoryGirl.build(:user, email: "alex@gmail.com")

    visit root_path
    click_link 'Sign up'
    fill_in 'Username', with: user.username
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password

    click_button 'Sign up'
    expect(page).to have_content("Email #{user.email} is not a valid JMU email")
  end

  scenario 'User signs in successfully' do
    user = FactoryGirl.create(:user)

    sign_in_as(user)

    expect(page).to have_content('Welcome to BookHub. Please complete your profile!')
  end

  scenario 'User signs in and fills out profile' do
    user = FactoryGirl.create(:user)

    sign_in_as(user)

    expect(page).to have_content('Welcome to BookHub. Please complete your profile!')

    fill_in 'user_firstname', with: user.firstname
    fill_in 'user_lastname', with: user.lastname
    select(user.year, from: 'Year')
    fill_in 'Phone', with: user.phone
    fill_in 'user_address', with: user.address
    click_button 'Update'

    expect(page).to have_content('You updated your account successfully.')
  end

  scenario 'User tries to finish registration without phone number' do
    user = FactoryGirl.create(:user)

    sign_in_as(user)

    expect(page).to have_content('Welcome to BookHub. Please complete your profile!')

    fill_in 'user_firstname', with: user.firstname
    fill_in 'user_lastname', with: user.lastname
    select(user.year, from: 'Year')
    fill_in 'Phone', with: ""
    fill_in 'user_address', with: user.address
    click_button 'Update'

    expect(page).to have_content('Phone is not a valid phone number')
  end
end
