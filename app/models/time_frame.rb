# frozen_string_literal: true
class TimeFrame < ActiveRecord::Base
  belongs_to :group, class_name: 'TimeFrameGroup', inverse_of: :time_frames
  has_many :lessons, inverse_of: :time_frame, dependent: :restrict_with_exception

  validates :group, presence: true
  validates :starts_at, presence: true, date: { before: :ends_at }
  validates :ends_at, presence: true, date: { after: :starts_at }

  validate :validate_date
  validate :validate_conflicts

  just_define_datetime_picker :starts_at
  just_define_datetime_picker :ends_at

  private

  def validate_date
    return unless group

    if starts_at.present? && starts_at.to_date != group.group_date
      errors.add :starts_at, 'non è la data del gruppo'
    end

    if ends_at.present? && ends_at.to_date != group.group_date
      errors.add :ends_at, 'non è la data del gruppo'
    end
  end

  def validate_conflicts
    return unless group && starts_at.present? && ends_at.present?

    return unless group.time_frames.to_a.select(&:persisted?).reject { |o| o == self }.any? do |o|
      (starts_at <= o.ends_at) && (ends_at >= o.starts_at)
    end

    errors.add :group, 'è in conflitto con un altro periodo del gruppo'
  end
end
