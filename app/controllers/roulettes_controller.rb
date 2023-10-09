class RoulettesController < ApplicationController
  def show
    @roulette = Roulette.find(params[:id])
  end

  def create
    roulette = Roulette.create
    redirect_to roulette_path(roulette)
  end
end
