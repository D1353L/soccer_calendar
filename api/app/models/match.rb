class Match < ApplicationRecord
  has_many :scores, dependent: :destroy

  validates_length_of :scores, maximum: 2
  validates_presence_of :date_time
end
