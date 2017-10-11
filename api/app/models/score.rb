class Score < ApplicationRecord
  belongs_to :team
  belongs_to :match

  validates_associated :match
  validates :goals_count, numericality: { greater_than_or_equal_to: 0 },
                          allow_nil: true
end
