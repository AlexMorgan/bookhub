FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@dukes.jmu.edu" }
    firstname "Alex"
    lastname "Morgan"
    sequence(:username) { |n| "AlexMorgan#{n}" }
    password "password"
    address "James Madison University"
    phone "7038538600"
    year "Sophomore"
    confirmed_at Time.now
  end

  factory :book do
    title "The Wolf of Wall Street"
    quality "New"
    course_title "GHUM 100"
    price "2"

    user
  end
end
