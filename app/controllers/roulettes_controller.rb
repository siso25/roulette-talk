# frozen_string_literal: true

class RoulettesController < ApplicationController
  def show
    @roulette = Roulette.find(params[:id])
    @talk_themes = @roulette.talk_themes.order(:created_at)
    @speakers = @roulette.speakers.order(:created_at)
  end

  def create
    roulette = Roulette.create
    TalkTheme.create_initial_records(roulette)
    Speaker.create_initial_records(roulette)
    redirect_to roulette_path(roulette)
  end
end
