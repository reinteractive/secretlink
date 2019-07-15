class ActivityLog < ActiveRecord::Base
  validates :key, :owner, :trackable, presence: true
  validate :valid_key

  belongs_to :owner, polymorphic: true
  belongs_to :trackable, polymorphic: true
  belongs_to :recipient, polymorphic: true

  private

  def valid_key
    if key.present? && trackable.present?
      trackable_keys = trackable.class::ACTIVITY_LOG_KEYS.values
      errors.add(:key, :invalid) unless trackable_keys.include?(key)
    end
  end
end
