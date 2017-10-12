class Api::V1::MatchesController < ApplicationController
  def index
    @matches = Match.on_day(match_params[:date].to_date)
    return if @matches.present?

    response = refresh_matches
    render json: response if response.is_a?(Hash)

    @matches = Match.on_day(match_params[:date].to_date)
  end

  def refresh
    render json: refresh_matches
  end

  private

  def refresh_matches
    LoadDataFromSportradarService.perform(match_params)
  end

  def match_params
    params.permit(:date)
  end
end
