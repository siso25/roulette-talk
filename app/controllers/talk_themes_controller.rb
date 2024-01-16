# frozen_string_literal: true

class TalkThemesController < ApplicationController
  def new
    @roulette = Roulette.find(params[:roulette_id])
    @talk_theme = TalkTheme.new
  end

  def create
    @roulette = Roulette.find(params[:roulette_id])
    @roulette.talk_themes.create(talk_theme_params)
  end

  def edit
    @roulette = Roulette.find(params[:roulette_id])
    @talk_theme = @roulette.talk_themes.find(params[:id])
  end

  def update
    roulette = Roulette.find(params[:roulette_id])
    talk_theme = roulette.talk_themes.find(params[:id])
    talk_theme.update(talk_theme_params)
    redirect_to roulette_path(roulette)
  end

  def destroy
    roulette = Roulette.find(params[:roulette_id])
    talk_theme = roulette.talk_themes.find(params[:id])
    talk_theme.destroy
    redirect_to roulette_path(roulette)
  end

  private

  def talk_theme_params
    params.require(:talk_theme).permit(:theme)
  end
end
