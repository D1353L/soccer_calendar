class Score < ApplicationRecord
  belongs_to :team
  belongs_to :match
  validates_associated :match
end
