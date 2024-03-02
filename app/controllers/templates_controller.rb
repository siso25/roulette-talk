# frozen_string_literal: true

class TemplatesController < ApplicationController
  def show
    roulette = Roulette.find_by(id: params[:id])
    if roulette && roulette.talk_themes.count.positive?
      new_roulette = Roulette.create
      Template.create_talk_themes(new_roulette, roulette.talk_themes)
      Speaker.create_initial_records(new_roulette)
      redirect_to roulette_path(new_roulette)
    else
      redirect_to root_path
    end
  end
end
