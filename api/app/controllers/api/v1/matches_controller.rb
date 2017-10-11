class Api::V1::MatchesController < ApplicationController
  respond_to :json

  def show
    @matches = Match.find_by_date_time(match_params[:date]) unless match_params[:refresh]

    render json: @matches || refresh_matches
  end

  private

  def refresh_matches
    RefreshMatchesService.perform(match_params)
  end

  def match_params
    params.permit(:date, :refresh)
  end
end
