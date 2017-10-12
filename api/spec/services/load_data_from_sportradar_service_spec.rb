require 'rails_helper'

RSpec.describe LoadDataFromSportradarService do

  describe 'push_to_db' do
    %w[results schedule].each do |type|
      context type do
        before(:all) do
          LoadDataFromSportradarService
            .new(date: '2017-10-12')
            .send(:push_to_db, JSON.parse(file_fixture("#{type}.json").read))
        end

        context 'Match' do
          let(:identifier) { 'sr:match:12032102' }

          it 'creates 1 match' do
            expect(Match.count).to eq 1
          end

          it 'specifies proper identifier' do
            expect(Match.first.identifier).to eq identifier
          end
        end

        context 'Teams' do
          let(:names) { ['Lamia', 'Panionios Athens'] }
          let(:country_codes) { %w[GRC] * 2 }

          it 'creates 2 teams' do
            expect(Team.count).to eq 2
          end

          it 'specifies proper names' do
            expect(Team.pluck(:name)).to match_array names
          end

          it 'specifies proper country code' do
            expect(Team.pluck(:country_code)).to match_array country_codes
          end
        end

        context 'Scores' do
          it 'creates 2 scores' do
            expect(Score.count).to eq 2
          end

          let(:goals_counts) { type == 'results' ? [1, 0] : [nil, nil] }

          it 'specifies proper goals_count' do
            expect(Score.pluck(:goals_count)).to match_array goals_counts
          end
        end
      end
    end
  end
end
