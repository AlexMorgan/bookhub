FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@dukes.jmu.edu" }
    sequence(:firstname) { |n| "Alex#{n}" }
    sequence(:username) { |n| "AlexMorgan#{n}" }
    lastname "Morgan"
    address "James Madison University"
    sequence(:phone) { |n| "703853386#{n}"}
  end

  factory :book do
    title "The Wolf of Wall Street"
    quality "New"
    course_title "GHUM 100"
    price "2"

    user
  end
end
