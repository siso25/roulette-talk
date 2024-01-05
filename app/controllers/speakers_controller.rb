# frozen_string_literal: true

class SpeakersController < ApplicationController
  def new
    @roulette = Roulette.find(params[:roulette_id])
    @speaker = Speaker.new
  end

  def create
    roulette = Roulette.find(params[:roulette_id])
    roulette.speakers.create(speaker_params)
    redirect_to roulette_path(roulette)
  end

  def edit
    @roulette = Roulette.find(params[:roulette_id])
    @speaker = @roulette.speakers.find(params[:id])
  end

  def update
    roulette = Roulette.find(params[:roulette_id])
    speaker = roulette.speakers.find(params[:id])
    speaker.update(speaker_params)
    redirect_to roulette_path(roulette)
  end

  def destroy
    roulette = Roulette.find(params[:roulette_id])
    speaker = roulette.speakers.find(params[:id])
    speaker.destroy
    redirect_to roulette_path(roulette)
  end

  private

  def speaker_params
    params.require(:speaker).permit(:name)
  end
end
