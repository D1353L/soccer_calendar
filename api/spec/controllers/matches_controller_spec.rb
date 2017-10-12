require 'rails_helper'

RSpec.describe Api::V1::MatchesController, type: :controller do
  describe 'GET #index' do
    it 'returns http success' do
      get :index, params: { date: '2017-11-11' }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #refresh' do
    it 'returns http success' do
      post :refresh, params: { date: '2017-11-11' }
      expect(response).to have_http_status(:success)
    end
  end
end
