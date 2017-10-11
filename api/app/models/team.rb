class Team < ApplicationRecord
  has_many :scores, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
