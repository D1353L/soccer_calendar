require 'rails_helper'

RSpec.describe Score, type: :model do
  describe 'associations' do
    it { should belong_to :match }
    it { should belong_to :team }
  end

  describe 'validations' do
    it { should validate_numericality_of(:goals_count).is_greater_than_or_equal_to(0) }

    it 'validates associated match' do
      score = build(:score, team: create(:team))
      score.match = build(:match, identifier: nil)
      expect(score.save).to eq false
    end
  end
end
