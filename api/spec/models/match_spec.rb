require 'rails_helper'

RSpec.describe Match, type: :model do
  describe 'associations' do
    it { should have_many(:scores).dependent(:destroy) }
  end

  describe 'validations' do
    subject { create(:match) }

    it { should validate_presence_of(:date_time) }

    it { should validate_presence_of(:identifier) }

    it { should validate_uniqueness_of(:identifier) }

    it 'validates scores count to be not greater than 2' do
      team = create(:team)
      3.times { create(:score, team: team, match: subject) }
      subject.reload
      expect(subject).to be_invalid
    end
  end

  describe 'default scope' do
    before do
      date_times = [
        DateTime.now - 1.year,
        DateTime.now - 1.day,
        DateTime.now - 2.year
      ]
      @matches = Array.new(10) do
        create(:match, date_time: date_times.sample)
      end
    end

    it 'ordered ascendingly' do
      expect(Match.all).to match_array Match.order(:date_time)
    end
  end

  describe 'scope on_day' do
    before do
      @expected = [
        create(:match, date_time: DateTime.new(2017, 2, 3, 4, 5, 6)),
        create(:match, date_time: DateTime.new(2017, 2, 3, 1, 0, 0))
      ]
      create(:match, date_time: DateTime.new(2017, 2, 1, 1, 0, 0))
      create(:match, date_time: DateTime.new(2017, 2, 4, 1, 0, 0))
      @day = Date.new(2017, 2, 3)
    end

    subject { Match.on_day @day }

    it 'returns matches only for specified day' do
      expect(subject).to match_array @expected
    end
  end
end
