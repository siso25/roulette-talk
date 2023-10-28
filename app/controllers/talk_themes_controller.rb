class TalkThemesController < ApplicationController
  def new
    @roulette = Roulette.find(params[:roulette_id])
    @talk_theme = TalkTheme.new
  end

  def edit
    @roulette = Roulette.find(params[:roulette_id])
    @talk_theme = @roulette.talk_themes.find(params[:id])
  end
end
