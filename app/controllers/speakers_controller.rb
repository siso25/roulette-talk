# frozen_string_literal: true

class SpeakersController < ApplicationController
  def new
    @roulette = Roulette.find(params[:roulette_id])
    @speaker = Speaker.new
  end

  def create
    @roulette = Roulette.find(params[:roulette_id])
    @roulette.speakers.create(speaker_params)
    @speakers = @roulette.speakers.order(:id)
    @talk_themes = @roulette.talk_themes.order(:id)
  end

  def edit
    @roulette = Roulette.find(params[:roulette_id])
    @speaker = @roulette.speakers.find(params[:id])
  end

  def update
    @roulette = Roulette.find(params[:roulette_id])
    @roulette.speakers.find(params[:id]).update(speaker_params)
    @speakers = @roulette.speakers.order(:id)
    @talk_themes = @roulette.talk_themes.order(:id)
  end

  def destroy
    @roulette = Roulette.find(params[:roulette_id])
    @roulette.speakers.find(params[:id]).destroy
    @speakers = @roulette.speakers.order(:id)
    @talk_themes = @roulette.talk_themes.order(:id)
  end

  private

  def speaker_params
    params.require(:speaker).permit(:name)
  end
end
