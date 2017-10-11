class Match < ApplicationRecord
  has_many :scores, dependent: :destroy

  validates_length_of :scores, maximum: 2
  validates_presence_of :date_time, :identifier
  validates_uniqueness_of :identifier

  scope :on_day, (lambda do |someday|
    where(date_time: (someday)..(someday + 1.day))
  end)
end
