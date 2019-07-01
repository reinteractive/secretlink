FactoryBot.define do
  factory :user do
    email                   { 'user@secretlink.org' }
    password                { 'password' }
    password_confirmation   { 'password' }
    confirmed_at            { Time.current }

    trait :unconfirmed do
      password                { nil }
      password_confirmation   { nil }
      confirmation_token      { 'token' }
      confirmed_at            { nil }
    end
  end
end
