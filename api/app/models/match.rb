class Match < ApplicationRecord
  has_many :scores, dependent: :destroy

  validates_presence_of :date_time, :identifier
  validates_uniqueness_of :identifier
  validate :validate_scores_count

  default_scope { order('date_time ASC') }
  scope :on_day, (lambda do |someday|
    where(date_time: (someday)..(someday + 1.day))
  end)

  def validate_scores_count
    errors.add(:scores, 'too much') if scores.size > 2
  end
end
