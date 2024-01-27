# frozen_string_literal: true

class TalkThemesController < ApplicationController
  before_action :set_roulette

  def new
    @talk_theme = TalkTheme.new
  end

  def create
    @roulette.talk_themes.create(talk_theme_params)
    @talk_themes = @roulette.talk_themes.order(:created_at)
    @speakers = @roulette.speakers.order(:created_at)
  end

  def edit
    @talk_theme = @roulette.talk_themes.find(params[:id])
  end

  def update
    @roulette.talk_themes.find(params[:id]).update(talk_theme_params)
    @talk_themes = @roulette.talk_themes.order(:created_at)
    @speakers = @roulette.speakers.order(:created_at)
  end

  def destroy
    @roulette.talk_themes.find(params[:id]).destroy
    @talk_themes = @roulette.talk_themes.order(:created_at)
    @speakers = @roulette.speakers.order(:created_at)
  end

  private

  def set_roulette
    @roulette = Roulette.find(params[:roulette_id])
  end

  def talk_theme_params
    params.require(:talk_theme).permit(:theme)
  end
end
