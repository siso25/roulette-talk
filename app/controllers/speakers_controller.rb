# frozen_string_literal: true

class SpeakersController < ApplicationController
  before_action :set_roulette

  def new
    @speaker = Speaker.new
  end

  def create
    @roulette.speakers.create(speaker_params)
    @speakers = @roulette.speakers.order(:id)
    @talk_themes = @roulette.talk_themes.order(:id)
  end

  def edit
    @speaker = @roulette.speakers.find(params[:id])
  end

  def update
    @roulette.speakers.find(params[:id]).update(speaker_params)
    @speakers = @roulette.speakers.order(:id)
    @talk_themes = @roulette.talk_themes.order(:id)
  end

  def destroy
    @roulette.speakers.find(params[:id]).destroy
    @speakers = @roulette.speakers.order(:id)
    @talk_themes = @roulette.talk_themes.order(:id)
  end

  private

  def set_roulette
    @roulette = Roulette.find(params[:roulette_id])
  end

  def speaker_params
    params.require(:speaker).permit(:name)
  end
end
