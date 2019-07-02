FactoryBot.define do
  factory :secret do
    uuid                    { SecureRandom.uuid }
    secret_key              { SecureRandom.hex(16) }
    title                   { 'Sample Secret' }
    from_email              { 'someone@secretlink.org' }
    to_email                { 'user@random.com' }
    secret                  { 'abc' }
    comments                { 'This is a sample secret' }
    expire_at               { Time.current + 10.days }

    trait :consumed do
      consumed_at           { Time.current }
    end

    trait :expired do
      expire_at             { Time.current - 10.days }
    end

    trait :extended do
      extended_at           { Time.current }
    end
  end
end
