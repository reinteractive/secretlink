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

    trait :confirmed_without_password do
      password                { nil }
      password_confirmation   { nil }
      confirmation_token      { 'token' }
      confirmed_at            { nil }

      after :create do |user|
        user.update(confirmed_at: Time.current)
      end
    end
  end
end
