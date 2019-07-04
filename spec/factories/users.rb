FactoryBot.define do
  factory :user do
    email                   { 'user@secretlink.org' }
    password                { 'password' }
    password_confirmation   { 'password' }
    confirmed_at            { Time.now }
    otp_required_for_login  { false }

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

    trait :with_secret do
      after :create do |user|
        create_list(:secret, 1, user: user)
      end
    end

    trait :otp_enabled do
      otp_required_for_login  { true }
      otp_secret              { User.generate_otp_secret }
    end
  end
end
