class Api::V1::MatchesController < ApplicationController
  respond_to :json

  def show
    @matches = Match.on_day(match_params[:date].to_date)

    unless @matches
      refresh_matches
      @matches = Match.on_day(match_params[:date].to_date)
    end

    render json: @matches
  end

  def refresh
    render json: refresh_matches
  end

  private

  def refresh_matches
    RefreshMatchesService.perform(match_params)
  end

  def match_params
    params.permit(:date)
  end
end
