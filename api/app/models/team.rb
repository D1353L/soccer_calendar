class Team < ApplicationRecord
  has_many :scores, dependent: :destroy
end
