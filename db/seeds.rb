# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Rails.env.development?
  puts "Seeding user with secrets"
  user = User.find_or_initialize_by(email: 'user@secretlink.org').tap do |u|
    u.password = 'password'
    u.password_confirmation = 'password'
    u.confirmed_at = Time.current
    u.save
  end

  secret_key = '3d000ea44a98b640028d6e446ad6e98b'
  secrets = [
    {
      title: 'Sample Secret',
      uuid: '123',
      secret_key: secret_key,
      from_email: user.email,
      to_email: 'recipient@secretlink.org',
      secret: 'abc',
      comments:'This is a sample secret',
      expire_at: Time.current + 10.days
    },
    {
      title: 'Consumed Secret',
      uuid: '456',
      secret_key: secret_key,
      from_email: user.email,
      to_email: 'recipient@secretlink.org',
      secret: 'abc',
      comments:'This is a consumed secret',
      expire_at: Time.current + 10.days,
      consumed_at: Time.current
    },
    {
      title: 'Expired Secret',
      uuid: '789',
      secret_key: secret_key,
      from_email: user.email,
      to_email: 'recipient@secretlink.org',
      secret: 'abc',
      comments:'This is an expired secret',
      expire_at: Time.current - 10.days
    },
    {
      title: 'Expired and Extended Secret',
      uuid: '101112',
      secret_key: secret_key,
      from_email: user.email,
      to_email: 'recipient@secretlink.org',
      secret: 'abc',
      comments:'This is an expired secret',
      expire_at: Time.current - 10.days,
      extended_at: Time.current - 10.days
    }
  ]

  secrets.each do |secret|
    Secret.find_or_initialize_by(uuid: secret[:uuid]) do |s|
      s.title = secret[:title]
      s.uuid = secret[:uuid]
      s.secret_key = secret[:secret_key]
      s.from_email = secret[:from_email]
      s.to_email = secret[:to_email]
      s.secret = secret[:secret]
      s.comments = secret[:comments]
      s.expire_at = secret[:expire_at]
      s.consumed_at = secret[:consumed_at]
      s.extended_at = secret[:extended_at]
      s.save!
    end
  end
end
