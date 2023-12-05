class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  after_create :create_settings

  # devise :registerable, :confirmable,
  #         :recoverable, :rememberable, :trackable, :validatable

  # devise :two_factor_authenticatable,
  #         otp_secret_encryption_key: Rails.configuration.topsekrit_2fa_key

  validate :email_authorised?, on: :create

  has_one :settings, class_name: 'UserSetting'
  has_many :secrets, primary_key: 'email', foreign_key: 'from_email'

  protected

  def password_required?
    confirmed? ? super : false
  end

  def email_authorised?
    unless AuthorisedEmailService.authorised_to_register?(email)
      errors.add(:email, I18n.t('field_errors.unauthorised'))
    end
  end

  def self.with_reset_password_token(token)
    reset_password_token = Devise.token_generator.digest(self, :reset_password_token, token)
    to_adapter.find_first(reset_password_token: reset_password_token)
  end

  # hooks
  def create_settings
    UserSetting.create(user: self)
  end
end
