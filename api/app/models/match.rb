class Match < ApplicationRecord
  has_many :scores, dependent: :destroy
  validates_length_of :scores, maximum: 2
end
