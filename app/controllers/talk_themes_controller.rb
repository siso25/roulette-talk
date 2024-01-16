# frozen_string_literal: true

class TalkThemesController < ApplicationController
  def new
    @roulette = Roulette.find(params[:roulette_id])
    @talk_theme = TalkTheme.new
  end

  def create
    @roulette = Roulette.find(params[:roulette_id])
    @roulette.talk_themes.create(talk_theme_params)
    @talk_themes = @roulette.talk_themes.order(:id)
    @speakers = @roulette.speakers.order(:id)
  end

  def edit
    @roulette = Roulette.find(params[:roulette_id])
    @talk_theme = @roulette.talk_themes.find(params[:id])
  end

  def update
    @roulette = Roulette.find(params[:roulette_id])
    @roulette.talk_themes.find(params[:id]).update(talk_theme_params)
    @talk_themes = @roulette.talk_themes.order(:id)
    @speakers = @roulette.speakers.order(:id)
  end

  def destroy
    @roulette = Roulette.find(params[:roulette_id])
    @roulette.talk_themes.find(params[:id]).destroy
    @talk_themes = @roulette.talk_themes.order(:id)
    @speakers = @roulette.speakers.order(:id)
  end

  private

  def talk_theme_params
    params.require(:talk_theme).permit(:theme)
  end
end
