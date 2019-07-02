class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :two_factor_authenticatable,
         otp_secret_encryption_key: Rails.configuration.topsekrit_2fa_key

  validate :email_authorised?, on: :create

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
end
